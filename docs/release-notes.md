# Browser Overlay Fix 1.0.0

By RovianDev.

- Expanded the Opera overlay workaround to a fixed allowlist covering Opera stable/beta, Chrome, Brave, Edge, Samsung Browser, Firefox, Vivaldi and DuckDuckGo.
- Added an original icon and an informational launcher screen explaining setup and the security tradeoff.
- Uses modern LSPosed API 102 metadata and explicit callback classes, avoiding the first prototype's dynamic-call loading failure.
- Added interactive release signing and APK structure validation. Signing keys and passwords are excluded from source distribution.

The Opera-only predecessor v1.0.1 was confirmed working with Panels. This expanded release and other browsers still need device testing. It reduces tapjacking protection for all overlays in selected browsers; it does not grant permissions or modify Android permission-controller dialogs.

New package: io.github.roviandev.browseroverlayfix. Disable the older Opera Overlay Fix module before enabling this one.
