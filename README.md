# Browser Overlay Fix

<img src="artwork/icon.svg" width="112" alt="Browser Overlay Fix icon">

**An LSPosed API 102 module by [RovianDev](https://github.com/RovianDev).**

Makes browser permission dialogs respond when a floating overlay such as Panels causes an “obscured by another app” warning. You still choose **Allow** or **Deny** yourself.

## What it does

Inside browsers you select in LSPosed, the module changes Java touch-event reporting so a touch is reported as unobscured. It clears only the obscured and partially obscured flags in `MotionEvent.getFlags()` and returns false from `isObscured()` and, where available, `isPartiallyObscured()`.

The fix began with Opera's website location dialog. The Opera-only predecessor v1.0.1 was confirmed working with Panels by the author on October 13, 2026. This expanded release preserves that hook behavior and adds a browser allowlist, icon and informational app screen.

It does not grant permissions, click buttons, change website permissions, hide installed apps, or modify Panels. It does not hook system_server or Android's permission controller. It has no network permission, analytics, or background service.

## Security tradeoff

**This deliberately reduces tapjacking protection throughout each selected browser.** All overlays appear unobscured to these Java checks, not only Panels. A malicious overlay could exploit that reduced protection to mislead you into tapping browser controls.

Enable the module only for browsers where you need it, and use trusted overlays. Disable it in LSPosed and restart the browser before sensitive tasks if you want its normal protection restored. The module cannot identify which overlay obscures an individual touch.

## Browser scope and testing

| Browser | Package | Status |
| --- | --- | --- |
| Opera | `com.opera.browser` | Underlying fix confirmed with Panels in predecessor v1.0.1; this release needs retest |
| Opera beta | `com.opera.browser.beta` | Scoped; not device-tested |
| Chrome | `com.android.chrome` | Scoped; not device-tested |
| Brave | `com.brave.browser` | Scoped; not device-tested |
| Microsoft Edge | `com.microsoft.emmx` | Scoped; not device-tested |
| Samsung Browser | `com.sec.android.app.sbrowser` | Scoped; not device-tested |
| Firefox | `org.mozilla.firefox` | Scoped; not device-tested |
| Vivaldi | `com.vivaldi.browser` | Scoped; not device-tested |
| DuckDuckGo | `com.duckduckgo.mobile.android` | Scoped; not device-tested |

These are intended targets, not a claim that every browser works. Native checks, compiled/inlined callers, browser changes, accessibility overlays, or Android input blocking can limit effectiveness. Android runtime permission dialogs may still refuse obscured touches. No universal browser compatibility is promised. Unlisted browser variants are excluded by the module's internal allowlist even if manually selected in LSPosed.

Package identities were checked against the [official Play listings](docs/browser-sources.md). Browser names belong to their respective owners; this project is not affiliated with them.

## Requirements and installation

- Rooted Android device running LSPosed with modern API 102 support.
- Android 8.0/API 26 or newer is the declared installation minimum; the minimum is not a claim of testing every Android version.
- One of the scoped browsers, and an overlay that causes the affected dialog to reject taps.

1. Install the release APK.
2. Enable **Browser Overlay Fix** in LSPosed.
3. Select only the browsers that need the fix.
4. Force-stop those browsers and reopen them, or reboot.
5. Open the affected page and test both Allow and Deny, resetting site permissions between attempts.

The launcher screen explains setup and limitations; scope and enablement are managed in LSPosed. It does not display live activation status.

This is a new application ID: `io.github.roviandev.browseroverlayfix`. Disable or uninstall the older **Opera Overlay Fix** module before enabling this one, so two modules do not hook the same methods. Your old module used a test signing key; this project is intended for your release key.

## Build and sign on Windows

The build uses the existing WSL toolchain: Java compiler with `--release 8`, an Android compile jar, `aapt`, `dalvik-exchange`, `zip` and `zipalign`. Signing additionally requires `apksigner`. No Gradle is needed. Override `ANDROID_JAR` in WSL if the compile jar is elsewhere; the existing environment uses `/usr/lib/android-sdk/platforms/android-23/android.jar`.

From this project folder:

```powershell
powershell -ExecutionPolicy Bypass -File .\build-release.ps1
```

The default keystore path matches the author's existing sibling signing backup directory. For other developers, supply a keystore:

```powershell
powershell -ExecutionPolicy Bypass -File .\build-release.ps1 -Keystore "C:\path\to\release.jks" -Alias "your-alias"
```

`apksigner` prompts for the password interactively. The script does not save the password or include it in command arguments. A separate key password may also be requested. Keep signing keys outside this repository and never upload them. No private key is distributed with the source.

Output: `out/BrowserOverlayFix-v1.0.0.apk`. The script verifies structure, signature and alignment and prints its SHA-256 hash. `bash build.sh` produces only `out/aligned.apk`, which is unsigned and not a public release.

Compile-only API 102 stubs are included for reproducibility and are excluded from the APK. Callback classes are written explicitly to avoid the dynamic-call metadata that caused the first prototype to fail Android verification. The build uses a fresh directory each time to prevent stale classes from entering the APK.

## Testing and troubleshooting

See [the test checklist](docs/testing.md). In LSPosed logs, search for `BrowserOverlayFix` and `v1.0.0 loaded`, followed by the installed hook count. Three hooks are expected on versions exposing all methods; older Android versions may lack `isPartiallyObscured`.

If the module is listed but not working, restart the browser and inspect its logs. A load error means the fix never ran. If hooks install but the warning remains, that browser may use a different detection path. Share the browser version, Android version, LSPosed version and only relevant log lines after removing private data.

## Publishing

The source repository is intended to be `RovianDev/BrowserOverlayFix`. The separate Xposed listing should be `Xposed-Modules-Repo/io.github.roviandev.browseroverlayfix`; Pixel Suite remains a separate project.

See [publishing instructions](docs/publishing.md). Only signed APKs, documentation and public source assets belong in a release. Never upload your development folder wholesale or include signing keys, device logs or unrelated projects.

## License and credits

Copyright © 2026 RovianDev. GPL-3.0-only; see [LICENSE](LICENSE). Compile-only API stubs were carried forward from the author's existing API 102 module projects. The libxposed API is supplied at runtime by the framework. The globe, overlay and pointer icon is original project artwork, supplied as an editable SVG and Android vector.
