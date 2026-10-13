# Device test checklist

Record browser/version, Android/version, LSPosed/version, overlay/version, module version and package.

1. Disable both Browser Overlay Fix and its Opera-only predecessor. Restart the browser and reproduce the overlay warning.
2. Enable Browser Overlay Fix for that browser only. Restart and confirm the log says the module loaded and hooks installed.
3. Test Deny and Allow separately, resetting the site's permission between tests. Confirm the actual denied/granted outcome, not just that the warning disappears.
4. Test Android runtime permissions separately. Confirm denial remains denial; the module must not auto-grant anything.
5. Disable the module, restart and verify original behavior returns.
6. Confirm an unselected browser and unrelated apps keep their original behavior.
7. Confirm the informational launcher screen opens and the icon displays in Settings and LSPosed.

The author confirmed the predecessor's Opera/Panels fix. Other browsers and this expanded APK still require device tests. Do not label an untested browser “confirmed compatible.”
