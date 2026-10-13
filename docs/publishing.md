# Publishing

1. Build and sign using `build-release.ps1`, entering the password locally.
2. Device-test this APK in Opera and record other tested browsers. Source scope alone is not proof of compatibility.
3. Publish the source and public artwork to `RovianDev/BrowserOverlayFix`. Use `.gitignore`; exclude keys, out/, build temporaries and logs.
4. Create a release tagged `1-1.0.0`, titled `1.0.0`, with the signed APK and [release notes](release-notes.md). Mark experimental browser support clearly.
5. Submit a separate listing issue to [Xposed submission](https://github.com/Xposed-Modules-Repo/submission/issues) with title `[submission] io.github.roviandev.browseroverlayfix` and the body in [xposed-submission.md](xposed-submission.md).
6. The repository bot creates the listing and invites the maintainer. Accept the invitation using your account.
7. Add README.md and SUMMARY to that listing. Link to the source repository; do not copy the source there.
8. Create a release in the listing tagged `1-1.0.0`, titled `1.0.0`, with the same signed APK and release notes. Set its description to Browser Overlay Fix and support URL to the source issues page.

Follow the [official submission instructions](https://github.com/Xposed-Modules-Repo/submission). A valid listing needs the correctly tagged release and an APK asset. Acceptance and indexing are external steps; an issue submission alone is not a published module.
