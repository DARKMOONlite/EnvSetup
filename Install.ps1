if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

#-------------------------------------------------------------------------------------------
# Configure your applications here!!

function Check-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}


# To list all appx packages:
# Get-AppxPackage | Format-Table -Property Name,Version,PackageFullName
Write-Host "Removing UWP Rubbish" -ForegroundColor Green
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
Write-Host "Installing IIS" -ForegroundColor Green
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

Write-Host ""
Write-Host "Enable Windows 10 Developer Mode..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"

if (Check-Command -cmdname 'choco') {
    Write-Host "Choco is already installed, skip installation."
}
else {
    Write-Host ""
    Write-Host "Installing Chocolatey for Windows..." -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

Write-Host "Config Firacode aesthetics." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
choco install "firacode" -y

Set-Itemproperty -path "HKCU:\Console\%SystemRoot%_system32_cmd.exe" -Name "FaceName" -value "Fira Code Retina"
Set-Itemproperty -path "HKCU:\Console\%SystemRoot%_system32_cmd.exe" -Name "FontSize" -value c0000
Set-Itemproperty -path "HKCU:\Console\%SystemRoot%_system32_cmd.exe\" -Name "ScreenColors"  -value a

Write-Host "Console aesthetics have been updated for the cmd. Please restart any active cmds to see this change" -ForegroundColor Yellow

Write-Host ""
Write-Host "Installing Applications..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green


# Choose your editors here
$editors = @(
    "vscode"
    "sublimetext3.app"
    "visualstudio2019community"
    "jetbrains-rider"
    "dotcover"
    "dottrace"
    "dotmemory"
    "dbeaver"
    "resharper"
    "sql-server-management-studio"
    "microsoft-windows-terminal"
)

$vscodeExtensions = @(
    "bierner.markdown-mermaid"
    "DotJoshJohnson.xml"
    "dsznajder.es7-react-js-snippets"
    "eamodio.gitlens"
    "ecmel.vscode-html-css"
    "janisdd.vscode-edit-csv"
    "mathematic.vscode-latex"
    "ms-azuretools.vscode-docker"
    "ms-dotnettools.csharp"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-toolsai.jupyter"
    "ms-toolsai.jupyter-keymap"
    "ms-toolsai.jupyter-renderers"
    "ms-vscode-remote.remote-containers"
    "ms-vscode.cpptools"
    "ms-vscode.powershell"
    "redhat.java"
    "searKing.preview-vscode"
    "trond-snekvik.simple-rst"
    "VisualStudioExptTeam.vscodeintellicode"
    "vscjava.vscode-java-debug"
    "vscjava.vscode-java-dependency"
    "vscjava.vscode-maven"
    "XephAlpha.syntax"
    "yzhang.markdown-all-in-one"
)


# utilities for system testing and general use
$pcSystemApps = @(
    "msiafterburner"
    "7zip.install"
    "samsung-magician"
    "icue"
    "discord"
    "ddu"
    "rufus"
    "hwinfo"
)


# development utilies
$utilities = @(
    "git"
    "putty"
    "pingplotter"
    "wireshark"
    "windirstat"
    "wget"
    "openssl.light"
    "hfsexplorer"
    "docker-desktop"
    "via" # for keyboard config loading
)


# university, documents, admin stuff
$productivity = @(
    "zotero"
    "gimp"
    "microsoft-teams.install"
    "grammarly"
    "adobereader"
    "parsec"
    "powertoys" # Windows PowerToys
    "zoom"
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
    "plex"
    "spotify"
)

#-------------------------------------------------------------------------------------------

$Colours = @("Green", "Yellow", "Red", "White")

function Out {
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $Message,

        [switch]
        $Install,

        [switch]
        $Warn,

        [switch]
        $Comment
    )

    # Default (White)
    $Colour = $Colours[3]

Write-Host "Setting up runtimes" -ForegroundColor Green
InstallApps -Apps $langsAndRuntimes

Write-Host "Development Runtime Environments Configuring" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Write-Host ""
Write-Host "    Python"
python -m pip install --upgrade pip
python -m pip install -r python-sys-requirements.txt
mkdir git
git clone https://github.com/albert118/python-utilities.git
Write-Host ""
Write-Host "    WSL" -ForegroundColor Green
Write-Host "    if this install doesn't work, see this link: https://www.windowscentral.com/how-install-wsl2-windows-10" -ForegroundColor Yellow
wsl --install

Write-Host ""
Write-Host "    Installing VS Code Extensions"
foreach ($codeExtension in $vscodeExtensions) {
    code --install-extension $codeExtension
}

Write-Host "Grabbing browsers" -ForegroundColor Green
InstallApps -Apps $browsers

Write-Host "Setting up editors" -ForegroundColor Green
Write-Host "     Remember to configure the Windows Terminal!" -ForegroundColor Yellow
InstallApps -Apps $editors

Write-Host "Setting up utilities" -ForegroundColor Green
InstallApps -Apps $utilities

Write-Host "Installing PC System applications" -ForegroundColor Green
InstallApps -Apps $pcSystemApps

Write-Host "Productivity setup and install" -ForegroundColor Green
Write-Host "     Remember to configure the PowerToys!" -ForegroundColor Yellow
InstallApps -Apps $productivity

Write-Host "Minimal entertainment! Installing the basics" -ForegroundColor Green
InstallApps -Apps $entertainment

Write-Host "Installing Github.com/microsoft/artifacts-credprovider" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/microsoft/artifacts-credprovider/master/helpers/installcredprovider.ps1'))

# -----------------------------------------------------------------------------
$computerName = Read-Host 'Enter New Computer Name (no spaces or special characters!)'
Out "Renaming this computer to: $($computerName)" -Warn
Rename-Computer -NewName $computerName
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Checking Windows updates" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Install-Module -Name PSWindowsUpdate -Force
Write-Host "Installing updates (Computer will reboot in a few minutes)" -ForegroundColor Green
Get-WindowsUpdate -AcceptAll -Install -ForceInstall -AutoReboot
# -----------------------------------------------------------------------------
Write-Host "------------------------------------" -ForegroundColor Green
Read-Host -Prompt "Setup is done, restart is needed, press [ENTER] to restart computer"

Restart-Computer
