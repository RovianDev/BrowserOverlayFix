/* Copyright (C) 2026 RovianDev. SPDX-License-Identifier: GPL-3.0-only */
package io.github.roviandev.browseroverlayfix;

import android.util.Log;
import android.view.MotionEvent;
import io.github.libxposed.api.XposedModule;
import io.github.libxposed.api.XposedInterface.Hooker;
import io.github.libxposed.api.XposedInterface.Chain;
import java.lang.reflect.Method;

public final class Module extends XposedModule {
    private static final String TAG = "BrowserOverlayFix";
    private static final String[] PACKAGES = {
        "com.opera.browser",
        "com.opera.browser.beta",
        "com.android.chrome",
        "com.brave.browser",
        "com.microsoft.emmx",
        "com.sec.android.app.sbrowser",
        "org.mozilla.firefox",
        "com.vivaldi.browser",
        "com.duckduckgo.mobile.android"
    };
    private static boolean isSupported(String pkg) {
        for (String supported : PACKAGES) if (supported.equals(pkg)) return true;
        return false;
    }
    private boolean installed;
    public Module() { super(); }

    private static final class ClearObscuredFlags implements Hooker {
        @Override public Object intercept(Chain chain) throws Throwable {
            return ((Integer) chain.proceed()) & ~3;
        }
    }

    private static final class ReportUnobscured implements Hooker {
        @Override public Object intercept(Chain chain) throws Throwable {
            return false;
        }
    }

    @Override public void onModuleLoaded(ModuleLoadedParam param) {
        log(Log.INFO, TAG, "v1.0.0 loaded in " + param.getProcessName());
    }

    @Override public void onPackageReady(PackageReadyParam param) {
        String pkg = param.getPackageName();
        if (!isSupported(pkg)) return;
        if (installed) return;
        installed = true;
        int count = 0;
        count += install("getFlags", new ClearObscuredFlags());
        count += install("isObscured", new ReportUnobscured());
        count += install("isPartiallyObscured", new ReportUnobscured());
        log(Log.INFO, TAG, "Installed " + count + " obscured-touch hooks in " + pkg
            + "; tapjacking protection is reduced in this Opera process.");
    }

    private int install(String name, Hooker hooker) {
        final Method method;
        try {
            method = MotionEvent.class.getDeclaredMethod(name);
            hook(method).intercept(hooker);
        } catch (Throwable error) {
            log(Log.WARN, TAG, "Could not install " + name, error);
            return 0;
        }
        try {
            log(Log.INFO, TAG, name + " hooked; deoptimize=" + deoptimize(method));
        } catch (Throwable error) {
            log(Log.WARN, TAG, name + " hooked, but deoptimization failed", error);
        }
        return 1;
    }
}