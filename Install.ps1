if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

function InstallApps([string[]]$Apps)
{
    foreach ($app in $Apps) {
        choco install $app -y
    }
}

function Check-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# -----------------------------------------------------------------------------
$computerName = Read-Host 'Enter New Computer Name'
Write-Host "Renaming this computer to: " $computerName  -ForegroundColor Yellow
Rename-Computer -NewName $computerName
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Disable Sleep on AC Power..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Powercfg /Change monitor-timeout-ac 15
Powercfg /Change standby-timeout-ac 45

# To list all appx packages:
# Get-AppxPackage | Format-Table -Property Name,Version,PackageFullName
Write-Host "Removing UWP Rubbish..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
$uwpRubbishApps = @(
    "Microsoft.Messaging"
    "king.com.CandyCrushSaga"
    "Microsoft.BingNews"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.People"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.YourPhone"
    "Microsoft.MicrosoftOfficeHub"
    "Fitbit.FitbitCoach"
    "Microsoft.GetHelp"
    )

foreach ($uwp in $uwpRubbishApps) {
    Get-AppxPackage -Name $uwp | Remove-AppxPackage
}


Write-Host ""
Write-Host "Installing IIS..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Enable-WindowsOptionalFeature -Online -FeatureName IIS-DefaultDocument -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpCompressionDynamic -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpCompressionStatic -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebSockets -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationInit -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45 -All
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ServerSideIncludes
Enable-WindowsOptionalFeature -Online -FeatureName IIS-BasicAuthentication
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WindowsAuthentication
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Enable Windows 10 Developer Mode..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"

if (Check-Command -cmdname 'choco') {
    Write-Host "Choco is already installed, skip installation."
}
else {
    Write-Host ""
    Write-Host "Installing Chocolate for Windows..." -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

Write-Host "Config Firacode aesthetics." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
choco install "firacode" -y

Set-Itemproperty -path "HKCU:\Console\%SystemRoot%_system32_cmd.exe" -Name "FaceName" -value "Fira Code Retina"
Set-Itemproperty -path "HKCU:\Console\%SystemRoot%_system32_cmd.exe" -Name "FontSize" -value c0000
Set-Itemproperty -path "HKCU:\Console\%SystemRoot%_system32_cmd.exe\" -Name "ScreenColors"  -value a

Write-Host "Console aesthetics have been updated for the cmd. Please restart any active cmds..." -ForegroundColor Yellow

Write-Host ""
Write-Host "Installing Applications..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "[WARN] If in China: some software e.g. Chrome will require unobstricted internet to download!" -ForegroundColor Yellow


# Choose your editors here
$editors = @(
    "vscode"
    "sublimetext3.app"
    "visualstudio2019community"
    )


# utilities for system testing and general use
$pcSystemApps = @(
    "msiafterburner"
    "7zip.install"
    "samsung-magician"
    "icue"
    "discord"
    "ddu"
    "msiafterburner"
    "rufus"
    "hwinfo"
    )


# development utilies
$utilities = @(
    "git"
    "doxygen.install"
    "putty"
    "pingplotter"
    "wireshark"
    "windirstat"
    "wget"
    "openssl.light"
    "hfsexplorer"
    )


# university, documents, admin stuff
$productivity = @(
    "zotero"
    "gimp"
    "microsoft-teams.install"
    "grammarly-edge"
    "grammarly"
    "adobereader"
    "parsec"
    )


# I use pretty much everything,
# Note: vc runtimes are for all since 2005!!!
#   If you have any issues uninstall all but 2017/19
$langsAndRuntimes = @(
    "r"
    "python"
    "nodejs"
    "jre8"
    "vcredist-all"
    )


# typically i just include all of them for testing purposes
# but you do you - I know how people get fired up about their browsers...
# tbh I just main edge cause clean lines and Chromium that's better than Chrome
# "fight! fight! fight!"
$browsers = @(
    "microsoft-edge"
    "googlechrome"
    "firefox"
    )


# not much - keep it simple.
$entertainment = @(
    "vlc"
    "steam"
    )


Write-Host "Setting up runtimes..." -ForegroundColor Green
InstallApps -Apps $langsAndRuntimes

Write-Host "Installing Python and Configuring the enviornments..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
python -m pip install --upgrade pip
python -m pip install requirements.txt
mkdir git

Write-Host "Grabbing browsers - hold tight and get ready to Google..." -ForegroundColor Green
InstallApps -Apps $browsers

Write-Host "Setting up editors..." -ForegroundColor Green
InstallApps -Apps $editors

Write-Host "Setting up utilities..." -ForegroundColor Green
InstallApps -Apps $utilities


Write-Host "Installing PC System applications..." -ForegroundColor Green
InstallApps -Apps $pcSystemApps

Write-Host "Productivity setup and install..." -ForegroundColor Green
InstallApps -Apps $productivity

Write-Host "Minimal entertainment! Installing the basics." -ForegroundColor Green
InstallApps -Apps $entertainment

Write-Host "Installing Github.com/microsoft/artifacts-credprovider..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/microsoft/artifacts-credprovider/master/helpers/installcredprovider.ps1'))

# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Checking Windows updates..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Install-Module -Name PSWindowsUpdate -Force
Write-Host "Installing updates... (Computer will reboot in minutes...)" -ForegroundColor Green
Get-WindowsUpdate -AcceptAll -Install -ForceInstall -AutoReboot

# -----------------------------------------------------------------------------
Write-Host "------------------------------------" -ForegroundColor Green
Read-Host -Prompt "Setup is done, restart is needed, press [ENTER] to restart computer."
Restart-Computer
