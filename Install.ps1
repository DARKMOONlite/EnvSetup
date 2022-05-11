if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit 
}

# -----------------------------------------------------------------------------
# Source script variables

$configureSystemPreferences = $PSScriptRoot + "\configure-system-preferences.ps1"
$removeUwpApps = $PSScriptRoot + "\remove-uwp-apps.ps1"
$setUpChoco = $PSScriptRoot + "\setup-choco.ps1"
$installIss = $PSScriptRoot + "\install-iss.ps1"
$installDevDependencies = $PSScriptRoot + "\install-dev-dependencies-and-runtimes.ps1"
$installProductivity = $PSScriptRoot + "\install-productivity.ps1"
$installEntertainment = $PSScriptRoot + "\install-entertainment.ps1"
$checkWindowsUpdates = $PSScriptRoot + "\check-windows-updates.ps1"

# -----------------------------------------------------------------------------
# Run scripts

# Must always happen first!
& $setUpChoco

& $configureSystemPreferences
& $removeUwpApps

Write-Host ""
Write-Host "Installing Applications" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green

& $installIss
& $installDevDependencies
& $installProductivity
& $installEntertainment

& $checkWindowsUpdates

# apply updates
Restart-Computer
