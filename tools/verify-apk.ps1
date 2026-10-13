param([Parameter(Mandatory=$true)][string]$Apk)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [IO.Compression.ZipFile]::OpenRead([IO.Path]::GetFullPath($Apk))
function Read-Entry([string]$name) {
    $entry = $zip.GetEntry($name)
    if (-not $entry) { throw "Missing APK entry: $name" }
    $reader = [IO.StreamReader]::new($entry.Open())
    try { return $reader.ReadToEnd().Trim() } finally { $reader.Dispose() }
}
try {
    if ((Read-Entry 'META-INF/xposed/java_init.list') -ne 'io.github.roviandev.browseroverlayfix.Module') { throw 'Wrong module entry point.' }
    $prop = Read-Entry 'META-INF/xposed/module.prop'
    foreach ($line in @('minApiVersion=102','targetApiVersion=102','staticScope=true')) {
        if (($prop -split '\r?\n') -notcontains $line) { throw "Wrong metadata: $line" }
    }
    $root = Split-Path $PSScriptRoot -Parent
    $expected = (Get-Content -LiteralPath (Join-Path $root 'meta\xposed\scope.list') | Where-Object { $_.Trim() }) -join "`n"
    if ((Read-Entry 'META-INF/xposed/scope.list').Replace("`r", '') -ne $expected) { throw 'Packaged scope mismatch.' }
    $java = Get-Content -LiteralPath (Join-Path $root 'src\io\github\roviandev\browseroverlayfix\Module.java') -Raw
    $codeScope = @([regex]::Matches($java, '"((?:com|org)\.[a-z0-9.]+)"') | ForEach-Object { $_.Groups[1].Value }) -join "`n"
    if ($codeScope -ne $expected) { throw 'Code browser allowlist differs from module scope.' }
    $stream = $zip.GetEntry('classes.dex').Open()
    $memory = [IO.MemoryStream]::new()
    try { $stream.CopyTo($memory); $dex = $memory.ToArray() } finally { $stream.Dispose(); $memory.Dispose() }
    $mapOffset = [BitConverter]::ToUInt32($dex, 52)
    $mapCount = [BitConverter]::ToUInt32($dex, $mapOffset)
    for ($i=0; $i -lt $mapCount; $i++) {
        $type = [BitConverter]::ToUInt16($dex, $mapOffset + 4 + 12*$i)
        if ($type -eq 7 -or $type -eq 8) { throw 'Dynamic call metadata detected: use explicit callback classes.' }
    }
    $so = [BitConverter]::ToUInt32($dex,60)
    $to = [BitConverter]::ToUInt32($dex,68)
    $co = [BitConverter]::ToUInt32($dex,100)
    $count = [BitConverter]::ToUInt32($dex,96)
    $classes = @()
    for ($i=0; $i -lt $count; $i++) {
        $ti = [BitConverter]::ToUInt32($dex,$co+32*$i)
        $si = [BitConverter]::ToUInt32($dex,$to+4*$ti)
        $offset = [BitConverter]::ToUInt32($dex,$so+4*$si)
        while (($dex[$offset] -band 128) -ne 0) { $offset++ }
        $offset++; $end=$offset
        while ($dex[$end] -ne 0) { $end++ }
        $name = [Text.Encoding]::UTF8.GetString($dex,$offset,$end-$offset)
        if (-not $name.StartsWith('Lio/github/roviandev/browseroverlayfix/')) { throw "Unexpected bundled class: $name" }
        $classes += $name
    }
    foreach ($required in @('Module','Module$ClearObscuredFlags','Module$ReportUnobscured','AboutActivity','R')) {
        if ($classes -notcontains "Lio/github/roviandev/browseroverlayfix/$required;") { throw "Missing class: $required" }
    }
    Write-Host "PASS: API 102 metadata, scope, entry point, $count module classes; no API stubs or dynamic call metadata."
} finally { $zip.Dispose() }
