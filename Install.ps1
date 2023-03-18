if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; 
    exit;
}

# -----------------------------------------------------------------------------
# Source script variables

$configureSystemPreferences = $PSScriptRoot + "\configure-system-preferences.ps1";
$removeUwpApps = $PSScriptRoot + "\remove-uwp-apps.ps1";
$setUpChoco = $PSScriptRoot + "\setup-choco.ps1";
$installDevDependencies = $PSScriptRoot + "\install-dev-dependencies-and-runtimes.ps1";
$installProductivity = $PSScriptRoot + "\install-productivity.ps1";
$installEntertainment = $PSScriptRoot + "\install-entertainment.ps1";
$installCustomEntertainment = $PSScriptRoot + "\install-custom-entertainment.ps1";
$checkWindowsUpdates = $PSScriptRoot + "\check-windows-updates.ps1";

# -----------------------------------------------------------------------------
# Run scripts

# Must always happen first!
& $setUpChoco;

& $configureSystemPreferences;
& $removeUwpApps;

Write-Host "Please review the system configuration and removed rubbish are as expected" -ForegroundColor Yellow;
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

Write-Host ""
Write-Host "Installing Applications" -ForegroundColor Green;
Write-Host "------------------------------------" -ForegroundColor Green;


Write-Host "Install custom entertainment (Y / N) ?"  $installCustom  -ForegroundColor Yellow;

if ($installCustom -eq "Y") {
    & $installCustomEntertainment;
}

Write-Host "Install dev dependencies (Y / N) ?"  $installDev  -ForegroundColor Yellow;

if ($installDev -eq "Y") {
    & $installDevDependencies;
}

Write-Host "Please review the development dependencies and configuration are as expected" -ForegroundColor Yellow;
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

& $installProductivity;
& $installEntertainment;
Write-Host "Please review the productivity and entertainment installation is as expected" -ForegroundColor Yellow;
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

# Updates take a long time, check these last
& $checkWindowsUpdates;

# -----------------------------------------------------------------------------
Write-Host "------------------------------------" -ForegroundColor Green;
Read-Host -Prompt "Setup is done, restart is needed, press [ENTER] to once logs review to (optionally) restart";

Write-Host "Ready to restart and apply changes (Y / N) ?"  $willRestart  -ForegroundColor Yellow;

if ($willRestart -eq "Y") {
    Write-Host -NoNewLine "Computer will restart on next keystroke";
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

    Restart-Computer;
}