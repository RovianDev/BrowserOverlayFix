# Developer build instructions

The public build uses WSL with a Java compiler, an Android compile jar, aapt, dalvik-exchange, zip and zipalign. Signing additionally requires apksigner. No Gradle is required.

Set ANDROID_JAR in WSL if your Android compile jar is not at the default path used by build.sh. Java sources compile as Java 8 bytecode. API 102 interfaces are compile-only and are excluded from the APK. Explicit callback classes avoid dynamic-call metadata; each build uses a fresh temporary directory to prevent stale classes from entering the APK.

## Unsigned build

From the source directory in WSL:

```bash
bash build.sh
```

This produces out/aligned.apk, which is unsigned.

## Sign your own build

Supply your own keystore; the public script has no personal signing-path default:

```powershell
powershell -ExecutionPolicy Bypass -File .\build-release.ps1 -Keystore "C:\path\to\your-keystore.jks"
```

Use -Alias when a particular alias is needed. apksigner asks for the password locally and the script does not save it or place it in command arguments. Keep keys outside the repository. Never upload keys or passwords.

The output is out/BrowserOverlayFix-v1.0.0.apk. The script checks API 102 metadata, scope, entry classes, signature and alignment and prints the APK SHA-256 hash.
