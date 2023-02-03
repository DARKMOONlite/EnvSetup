if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; 
    exit;
}

function InstallApps([string[]]$Apps)
{
    foreach ($app in $Apps) {
        choco install $app -y
    }
}

# -----------------------------------------------------------------------------
# Must always happen first!

# & $setUpChoco;

function CheckCommand($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# -----------------------------------------------------------------------------
if (CheckCommand -cmdname 'choco') {
    Write-Host "Choco is already installed, skip installation."
}
else {
    Write-Host ""
    Write-Host "Installing Chocolatey for Windows" -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# -----------------------------------------------------------------------------

# & $configureSystemPreferences;

$computerName = Read-Host 'Enter New Computer Name'

Write-Host "Renaming this computer to: " $computerName  -ForegroundColor Yellow
Rename-Computer -NewName $computerName

Write-Host ""
Write-Host "Disable Sleep on AC Power and set monitor timeout" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Powercfg /Change monitor-timeout-ac 10
Powercfg /Change standby-timeout-ac 0

Write-Host ""
Write-Host "Enabling Dark Mode" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0

Write-Host ""
Write-Host "Enable Windows 10 Developer Mode..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"


Write-Host "Config Firacode aesthetics." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
choco install "firacode" -y

Write-Host "Configured System Preferences" -ForegroundColor Green;

# -----------------------------------------------------------------------------

# & $removeUwpApps;

# To list all appx packages:
# Get-AppxPackage | Format-Table -Property Name,Version,PackageFullName
Write-Host "Removing UWP Rubbish" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
$uwpRubbishApps = @(
    "Microsoft.Messaging"
    "king.com.CandyCrushSaga"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.People"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.YourPhone"
    "Microsoft.MicrosoftOfficeHub"
    "Fitbit.FitbitCoach"
    "Microsoft.GetHelp"
    "Groove",
    "Microsoft.Getstarted"
    "Microsoft.WindowsMaps"
    "Microsoft.MixedReality.Portal"
    "Microsoft.SkypeApp",
    "Microsoft.Microsoft3DViewer"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.PowerAutomateDesktop"
    "Microsoft.BingWeather"
    "Microsoft.BingNews",
    "Microsoft.WindowsMaps"
)

# -----------------------------------------------------------------------------
foreach ($uwp in $uwpRubbishApps) {
    Get-AppxPackage -Name $uwp | Remove-AppxPackage
}

Write-Host "Removed UWP Apps" -ForegroundColor Green;


# -----------------------------------------------------------------------------


Write-Host "Please review the system configuration and removed rubbish are as expected" -ForegroundColor Yellow;
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

Write-Host ""
Write-Host "Installing Applications" -ForegroundColor Green;
Write-Host "------------------------------------" -ForegroundColor Green;

# -----------------------------------------------------------------------------

# & $installDevDependencies;

# Choose your editors here
$editors = @(
    "vscode"
    "visualstudio2022community"
    "jetbrains-rider"
    "dotcover"
    "dottrace"
    "dotmemory"
    "dbeaver"
    "resharper"
    "microsoft-windows-terminal"
)


$vscodeExtensions = @(
    # Python
    "python.isort"
    "ms-python.python"
    "ms-python.vscode-pylance"
    
    # C#
    "ms-dotnettools.csharp"
    
    # Docker
    "ms-azuretools.vscode-docker"
    
    # Markdown
    "bierner.markdown-mermaid"
    "searKing.preview-vscode"
    "yzhang.markdown-all-in-one"
    
    # HTML, CSS, JS
    "ecmel.vscode-html-css"
    "dsznajder.es7-react-js-snippets"
    
    # Theme(s)
    "sldobri.bunker-1.1.6"   # Dobri Next theme (blackout)
    
    # Git
    "eamodio.gitlens"
    
    # misc.
    "janisdd.vscode-edit-csv"  # CSV quick viewer
    "ms-vscode.powershell"     # Powershell support
    "DotJoshJohnson.xml"       # XML tool
    "trond-snekvik.simple-rst" # RST tool
)


# Note: vc runtimes are for all since 2005!!!
#   If you have any issues uninstall all but 2017/19
$langsAndRuntimes = @(
    "python"
    "jre8"
    "vcredist-all"
)

# -----------------------------------------------------------------------------
function InstallApps([string[]]$Apps)
{
    foreach ($app in $Apps) {
        Write-Host ""
        choco install $app -y
    }
}

# -----------------------------------------------------------------------------

Write-Host "Setting up runtimes" -ForegroundColor Green
InstallApps -Apps $langsAndRuntimes

Write-Host ""
Write-Host "    WSL" -ForegroundColor Green
Write-Host "    if this install doesn't work, see this link: https://www.windowscentral.com/how-install-wsl2-windows-10" -ForegroundColor Yellow
wsl --install

Write-Host "     Setting up editors" -ForegroundColor Green
Write-Host "     Remember to configure the Windows Terminal!" -ForegroundColor Yellow
InstallApps -Apps $editors

Write-Host ""
Write-Host "    Installing VS Code Extensions"

foreach ($codeExtension in $vscodeExtensions) {
    Write-Host ""
    code --install-extension $codeExtension
}

Write-Host "    VS Code and extensions have been installed, copy the following into your AppData/Roaming/Code/User/settings.json"
Write-Host '{
	"security.workspace.trust.untrustedFiles": "open",
	"explorer.confirmDragAndDrop": false,
	"workbench.iconTheme": "Monokai Classic Icons",
	"terminal.integrated.enableMultiLinePasteWarning": false,
	"workbench.colorTheme": "Dobri Next -A00- Black",
	"editor.fontFamily": "Fira Code Retina",
	"editor.fontSize": 12,
	"editor.fontLigatures": true,
	"window.zoomLevel": -1,
	"emmet.showSuggestionsAsSnippets": true,
	"emmet.includeLanguages": {
		"javascript": "javascriptreact"
	},
	"emmet.useInlineCompletions": true,
	"emmet.syntaxProfiles": {
}'


Write-Host "     Setting .NET (via winget)" -ForegroundColor Green

winget install Microsoft.DotNet.SDK.6

Write-Host "Development Runtime Environments Configuring" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Write-Host ""
Write-Host "    Python"
python -m pip install --upgrade pip
python -m pip install -r python-sys-requirements.txt

mkdir git

# Add an icon to the git directory
"[.ShellClassInfo]`nIconResource=C:\Windows\System32\SHELL32.dll,12`n[ViewState]`nMode=`nVid=`nFolderType=Generic`n" | Out-File git\desktop.ini

git clone https://github.com/albert118/python-utilities.git git
git config core.ignorecase false # avoid having issues with case sensitive naming
git config --system core.editor code
git config  --global pull.ff only # avoid accidental merges when pulling
git config --global core.autocrlf true # set line endings

Write-Host "      Installing Github.com/microsoft/artifacts-credprovider" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/microsoft/artifacts-credprovider/master/helpers/installcredprovider.ps1'))

Write-Host "      Excluding repos from Windows Defender" -ForegroundColor Green

Add-MpPreference -ExclusionPath "$env:USERPROFILE\source\repos"
Add-MpPreference -ExclusionPath "$env:USERPROFILE\.nuget"
Add-MpPreference -ExclusionPath "$env:USERPROFILE\.vscode"
Add-MpPreference -ExclusionPath "$env:USERPROFILE\.dotnet"
Add-MpPreference -ExclusionPath "$env:USERPROFILE\.ssh"
Add-MpPreference -ExclusionPath "$env:APPDATA\npm"
Add-MpPreference -ExclusionPath "$env:APPDATA\git"

Write-Host "Development Depenedencies were installed";

# -----------------------------------------------------------------------------

Write-Host "Please review the development dependencies and configuration are as expected" -ForegroundColor Yellow;
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

# -----------------------------------------------------------------------------

# & $installProductivity;

# university, documents, admin stuff
$productivity = @(
    "zotero"
    # "gimp"
    "microsoft-teams.install"
    # "grammarly-edge"
    # "grammarly"
    "adobereader"
    # "parsec"
    "powertoys" # Windows PowerToys
    "zoom"
)

$browsers = @(
    "microsoft-edge"
    "googlechrome"
    "firefox"
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
    "putty"
    "pingplotter"
    "wireshark"
    "windirstat"
    "wget"
    "openssl.light"
    "hfsexplorer"
    "docker-desktop"
    "via" # for keyboard config loading
    "voicemod"
)

Write-Host "Grabbing browsers" -ForegroundColor Green
InstallApps -Apps $browsers

Write-Host "Productivity setup and install" -ForegroundColor Green
Write-Host "     Remember to configure the PowerToys!" -ForegroundColor Yellow
InstallApps -Apps $productivity

Write-Host "Setting up utilities" -ForegroundColor Green
InstallApps -Apps $utilities

Write-Host "Installing PC System applications" -ForegroundColor Green
InstallApps -Apps $pcSystemApps

Write-Host "Productivity installation compeleted" -ForegroundColor Green;

# -----------------------------------------------------------------------------

# & $installEntertainment;

# not much - keep it simple.
$entertainment = @(
    # "vlc"
    "steam"
    "plex"
    "spotify"
)

Write-Host "Minimal entertainment - installing just the basics" -ForegroundColor Green
InstallApps -Apps $entertainment
Write-Host "Entertainment installation completed" -ForegroundColor Green;

# -----------------------------------------------------------------------------


Write-Host "Please review the productivity and entertainment installation is as expected" -ForegroundColor Yellow;
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');


# -----------------------------------------------------------------------------

# & $checkWindowsUpdates;

# Updates take a long time, check these last
Write-Host ""
Write-Host "Checking Windows updates" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Install-Module -Name PSWindowsUpdate -Force
Write-Host "Installing updates (Computer will reboot in a few minutes)" -ForegroundColor Green
Get-WindowsUpdate -AcceptAll -Install -ForceInstall -AutoReboot

# -----------------------------------------------------------------------------

Write-Host "------------------------------------" -ForegroundColor Green;
Read-Host -Prompt "Setup is done, restart is needed, press [ENTER] to once logs review to (optionally) restart";

Write-Host "Ready to restart and apply changes (Y / N) ?"  $willRestart  -ForegroundColor Yellow;

if ($willRestart -eq "Y") {
    Write-Host -NoNewLine "Computer will restart on next keystroke";
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

    Restart-Computer;
}
