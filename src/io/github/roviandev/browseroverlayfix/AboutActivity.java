/* Copyright (C) 2026 RovianDev. SPDX-License-Identifier: GPL-3.0-only */
package io.github.roviandev.browseroverlayfix;

import android.app.Activity;
import android.os.Bundle;
import android.graphics.Color;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.ImageView;

/** Informational screen; LSPosed manages enablement and browser scope. */
public final class AboutActivity extends Activity {
    @Override public void onCreate(Bundle state) {
        super.onCreate(state);
        int gap = (int) (24 * getResources().getDisplayMetrics().density);
        ScrollView scroll = new ScrollView(this);
        LinearLayout content = new LinearLayout(this);
        content.setOrientation(LinearLayout.VERTICAL);
        content.setPadding(gap, gap, gap, gap);
        ImageView icon = new ImageView(this);
        icon.setImageResource(R.drawable.ic_launcher);
        icon.setContentDescription(getString(R.string.app_name));
        content.addView(icon, new LinearLayout.LayoutParams(gap * 3, gap * 3));
        TextView title = new TextView(this);
        title.setText(R.string.app_name);
        title.setTextSize(28);
        title.setTextColor(Color.rgb(23, 29, 56));
        title.setPadding(0, gap, 0, gap);
        content.addView(title);
        TextView body = new TextView(this);
        body.setText(R.string.about);
        body.setTextSize(16);
        body.setTextColor(Color.rgb(50, 55, 65));
        content.addView(body);
        scroll.addView(content);
        setContentView(scroll);
    }
}
