param(
    [string]$DeviceId = "emulator-5554",
    [string]$AvdName = "Medium_Phone_API_36.1",
    [int]$BootTimeoutSeconds = 240
)

$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$localPropertiesPath = Join-Path $projectRoot "android\local.properties"

if (-not (Test-Path $localPropertiesPath)) {
    throw "Could not find android/local.properties at $localPropertiesPath"
}

function Get-LocalPropertyValue {
    param(
        [string]$Path,
        [string]$Key
    )

    $line = Get-Content $Path | Where-Object { $_ -match "^$([regex]::Escape($Key))=" } | Select-Object -First 1
    if (-not $line) {
        return $null
    }

    $value = $line.Substring($line.IndexOf("=") + 1)
    return $value.Replace("\\", "\")
}

$sdkDir = Get-LocalPropertyValue -Path $localPropertiesPath -Key "sdk.dir"
if (-not $sdkDir) {
    throw "sdk.dir was not found in android/local.properties"
}

$adbPath = Join-Path $sdkDir "platform-tools\adb.exe"
$emulatorPath = Join-Path $sdkDir "emulator\emulator.exe"

if (-not (Test-Path $adbPath)) {
    throw "adb.exe not found at $adbPath"
}

if (-not (Test-Path $emulatorPath)) {
    throw "emulator.exe not found at $emulatorPath"
}

Write-Host "Restarting ADB..."
& $adbPath kill-server | Out-Null
& $adbPath start-server | Out-Null

function Get-DeviceState {
    param([string]$Id)

    $devicesOutput = & $adbPath devices
    $match = $devicesOutput | Where-Object { $_ -match "^$([regex]::Escape($Id))\s+" } | Select-Object -First 1
    if (-not $match) {
        return "missing"
    }

    if ($match -match "\s+device$") {
        return "device"
    }

    if ($match -match "\s+offline$") {
        return "offline"
    }

    return "unknown"
}

$state = Get-DeviceState -Id $DeviceId
if ($state -ne "device") {
    Write-Host "Starting emulator '$AvdName'..."
    Start-Process -FilePath $emulatorPath -ArgumentList @("-avd", $AvdName, "-no-snapshot-load") | Out-Null
}

Write-Host "Waiting for $DeviceId to come online and finish booting..."
$deadline = (Get-Date).AddSeconds($BootTimeoutSeconds)
$booted = $false

while ((Get-Date) -lt $deadline) {
    $state = Get-DeviceState -Id $DeviceId
    if ($state -eq "device") {
        $bootCompleted = (& $adbPath -s $DeviceId shell getprop sys.boot_completed 2>$null).Trim()
        if ($bootCompleted -eq "1") {
            $booted = $true
            break
        }
    }

    Start-Sleep -Seconds 2
}

if (-not $booted) {
    throw "Timed out waiting for emulator '$DeviceId' to boot."
}

Write-Host "Emulator is ready. Launching Flutter app..."
Push-Location $projectRoot
try {
    flutter run -d $DeviceId
}
finally {
    Pop-Location
}
