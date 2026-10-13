#!/bin/bash
# Copyright (C) 2026 RovianDev. SPDX-License-Identifier: GPL-3.0-only
# Always builds unsigned. Signing is a separate, interactive step.
set -euo pipefail
cd "$(dirname "$0")"
AJ="${ANDROID_JAR:-/usr/lib/android-sdk/platforms/android-23/android.jar}"
for tool in javac dalvik-exchange aapt zip zipalign; do command -v "$tool" >/dev/null || { echo "Missing tool: $tool" >&2; exit 1; }; done
[ -f "$AJ" ] || { echo "Missing Android compile jar: $AJ" >&2; exit 1; }
# Unique directory prevents stale classes from entering the next APK.
WORK=$(mktemp -d "$PWD/.build.XXXXXXXX")
trap 'rm -rf -- "$WORK"' EXIT
mkdir -p "$WORK/stubs" "$WORK/classes" "$WORK/generated" "$WORK/META-INF/xposed" out
aapt package -f -M AndroidManifest.xml -S res -I "$AJ" -0 arsc -J "$WORK/generated" -F "$WORK/unsigned.apk"
javac --release 8 -cp "$AJ" -d "$WORK/stubs" $(find stubs -name '*.java')
javac --release 8 -cp "$AJ:$WORK/stubs" -d "$WORK/classes" $(find src "$WORK/generated" -name '*.java')
dalvik-exchange --dex --min-sdk-version=26 --output="$WORK/classes.dex" "$WORK/classes"
cp meta/xposed/* "$WORK/META-INF/xposed/"
(cd "$WORK"; zip -q -0 unsigned.apk classes.dex; zip -q -X unsigned.apk META-INF/xposed/*)
zipalign -f -p 4 "$WORK/unsigned.apk" out/aligned.apk
zipalign -c -p 4 out/aligned.apk
echo "Built out/aligned.apk (unsigned). Use build-release.ps1 to sign for publication."
