# Copyright (C) 2026 RovianDev. SPDX-License-Identifier: GPL-3.0-only
param(
    [Parameter(Mandatory=$true)]
    [string]$Keystore,
    [string]$Alias = ''
)
$ErrorActionPreference = 'Stop'
$keyPath = if ([IO.Path]::IsPathRooted($Keystore)) { [IO.Path]::GetFullPath($Keystore) } else { [IO.Path]::GetFullPath((Join-Path $PSScriptRoot $Keystore)) }
if (-not (Test-Path -LiteralPath $keyPath -PathType Leaf)) { throw 'Release keystore not found. Pass -Keystore with its path.' }
[xml]$manifest = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'AndroidManifest.xml') -Raw
$version = $manifest.manifest.GetAttribute('versionName', 'http://schemas.android.com/apk/res/android')
if ($version -notmatch '^\d+\.\d+\.\d+$') { throw 'Invalid release version.' }
& wsl --cd $PSScriptRoot -e bash build.sh
if ($LASTEXITCODE -ne 0) { throw 'Unsigned build failed.' }
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'tools\verify-apk.ps1') -Apk (Join-Path $PSScriptRoot 'out\aligned.apk')
if ($LASTEXITCODE -ne 0) { throw 'APK structural validation failed.' }
$linuxKey = (& wsl -e wslpath -a -u $keyPath | Out-String).Trim()
if ($LASTEXITCODE -ne 0 -or -not $linuxKey) { throw 'Could not translate keystore path for WSL.' }
$output = "out/BrowserOverlayFix-v$version.apk"
$signArgs = @('--cd', $PSScriptRoot, '-e', 'apksigner', 'sign', '--ks', $linuxKey, '--v4-signing-enabled', 'false', '--min-sdk-version', '26', '--out', $output)
if ($Alias) { $signArgs += @('--ks-key-alias', $Alias) }
$signArgs += 'out/aligned.apk'
Write-Host 'Enter your keystore password at the signing prompt. It is not saved in this script.'
& wsl @signArgs
if ($LASTEXITCODE -ne 0) { throw 'Signing failed. Do not publish an unsigned APK.' }
& wsl --cd $PSScriptRoot -e apksigner verify --verbose --print-certs $output
if ($LASTEXITCODE -ne 0) { throw 'Signature verification failed.' }
& wsl --cd $PSScriptRoot -e zipalign -c -p 4 $output
if ($LASTEXITCODE -ne 0) { throw 'APK alignment verification failed.' }
Get-FileHash -LiteralPath (Join-Path $PSScriptRoot $output) -Algorithm SHA256
Write-Host "Release APK: $PSScriptRoot\$output"
