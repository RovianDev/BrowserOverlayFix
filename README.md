# Browser Overlay Fix

<img src="artwork/icon.svg" width="112" alt="Browser Overlay Fix icon">

**An LSPosed API 102 module by [RovianDev](https://github.com/RovianDev).**

Makes browser permission dialogs respond when a floating overlay such as Panels causes an “obscured by another app” warning. You still choose **Allow** or **Deny** yourself.

## What it does

Inside browsers you select in LSPosed, the module changes Java touch-event reporting so a touch is reported as unobscured. It clears only the obscured and partially obscured flags in `MotionEvent.getFlags()` and returns false from `isObscured()` and, where available, `isPartiallyObscured()`.

Browser Overlay Fix v1.0.0 is tested and working with Panels in Opera, Chrome, Brave, Microsoft Edge, Firefox, Vivaldi and DuckDuckGo. The module includes a browser allowlist, icon and informational app screen.

It does not grant permissions, click buttons, change website permissions, hide installed apps, or modify Panels. It does not hook system_server or Android's permission controller. It has no network permission, analytics, or background service.

## Security tradeoff

**This deliberately reduces tapjacking protection throughout each selected browser.** All overlays appear unobscured to these Java checks, not only Panels. A malicious overlay could exploit that reduced protection to mislead you into tapping browser controls.

Enable the module only for browsers where you need it, and use trusted overlays. Disable it in LSPosed and restart the browser before sensitive tasks if you want its normal protection restored. The module cannot identify which overlay obscures an individual touch.

## Browser scope and testing

| Browser | Package | Status |
| --- | --- | --- |
| Opera | `com.opera.browser` | Tested and working (v1.0.0) |
| Chrome | `com.android.chrome` | Tested and working (v1.0.0) |
| Brave | `com.brave.browser` | Tested and working (v1.0.0) |
| Microsoft Edge | `com.microsoft.emmx` | Tested and working (v1.0.0) |
| Samsung Browser | `com.sec.android.app.sbrowser` | Expected to work; not yet tested |
| Firefox | `org.mozilla.firefox` | Tested and working (v1.0.0) |
| Vivaldi | `com.vivaldi.browser` | Tested and working (v1.0.0) |
| DuckDuckGo | `com.duckduckgo.mobile.android` | Tested and working (v1.0.0) |

The seven browsers marked above are tested and working with Panels. Samsung Browser is expected to work because it uses the same Android touch-event APIs, but it has not been tested. Results can vary with the device, browser version, overlay or Android input blocking. Android runtime permission dialogs may still refuse obscured touches. Select only the browsers you need in LSPosed.

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

## Source code

The complete source is available in this repository. Developer build instructions are in [BUILD.md](BUILD.md).

## Testing and troubleshooting

See [the test checklist](docs/testing.md). In LSPosed logs, search for `BrowserOverlayFix` and `v1.0.0 loaded`, followed by the installed hook count. Three hooks are expected on versions exposing all methods; older Android versions may lack `isPartiallyObscured`.

If the module is listed but not working, restart the browser and inspect its logs. A load error means the fix never ran. If hooks install but the warning remains, that browser may use a different detection path. Share the browser version, Android version, LSPosed version and only relevant log lines after removing private data.

## Publishing

Source: [RovianDev/BrowserOverlayFix](https://github.com/RovianDev/BrowserOverlayFix). Xposed listing: [io.github.roviandev.browseroverlayfix](https://github.com/Xposed-Modules-Repo/io.github.roviandev.browseroverlayfix).

See [publishing instructions](docs/publishing.md). Only signed APKs, documentation and public source assets belong in a release. Never upload your development folder wholesale or include signing keys, device logs or unrelated projects.

## Support the developer

If Browser Overlay Fix helps you, you can support RovianDev:

- [Buy Me a Coffee](https://buymeacoffee.com/roviandev)
- [Patreon](https://www.patreon.com/c/RovianDev)

Donations are optional; the module remains free and open source.

## License and credits

Copyright © 2026 RovianDev. GPL-3.0-only; see [LICENSE](LICENSE). Compile-only API stubs were carried forward from existing API 102 module projects. The libxposed API is supplied at runtime by the framework. The globe, overlay and pointer icon is original project artwork, supplied as an editable SVG and Android vector.
