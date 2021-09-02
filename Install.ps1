if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

#-------------------------------------------------------------------------------------------
# Configure your applications here!!

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

    if ($Comment) { $Colour = $Colours[0] }
    if ($Install) { $Colour = $Colours[1] }
    if ($Warn)   { $Colour = $Colours[2] }

    Write-Host "`r`n$($Message)" -ForegroundColor $Colour
}

function Install-Apps([string[]]$Apps) {
    foreach ($app in $Apps) {
        choco install $app -y
    }
}

function Check-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

function Choco() {
    if (Check-Command -cmdname 'choco') {
        Out "Choco is already installed, skipping installation" -Comment
    }
    else {
        Out "Installing Chocolatey Package Manager" -Install
        Out "-------------------------------------"
        Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }
}

function Add-Develop-Stuff() {
    # -----------------------------------------------------------------------------
    Out "Adding IIS..." -Install
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
    Out "Enable Windows 10 Developer Mode..." -Install
    Out "-----------------------------------"
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
    # -----------------------------------------------------------------------------
    Out "Config Fira Code fonts" -Install
    Out "----------------------"
    choco install "firacode" -y
    Set-Itemproperty -path "HKCU:\Console\%SystemRoot%_system32_cmd.exe" -Name "FaceName" -value "Fira Code Retina"
    Set-Itemproperty -path "HKCU:\Console\%SystemRoot%_system32_cmd.exe" -Name "FontSize" -value c0000
    Set-Itemproperty -path "HKCU:\Console\%SystemRoot%_system32_cmd.exe\" -Name "ScreenColors"  -value a
    Out "Console aesthetics have been updated for the cmd. Config will complete on restart." -Comment
    # -----------------------------------------------------------------------------
    Out "Installing Github.com/microsoft/artifacts-credprovider..." -Install
    Out "---------------------------------------------------------"
    iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/microsoft/artifacts-credprovider/master/helpers/installcredprovider.ps1'))
    $docPath = [Environment]::GetFolderPath("Documents")
    new-item -ItemType directory -Path $docPath\git
    # -----------------------------------------------------------------------------
}

function Setup-Python-Workspace() {
    # -----------------------------------------------------------------------------
    $docPath = [Environment]::GetFolderPath("Documents")
    new-item -ItemType directory -Path $docPath\PythonWorkspace
    python -m pip install --upgrade pip
    python -m pip install requirements.txt
    # -----------------------------------------------------------------------------
}

function Clear-Windows-Rubbish() {
    # To list all appx packages:
    # Get-AppxPackage | Format-Table -Property Name,Version,PackageFullName
    Out "Removing Windows crap Rubbish..." -Warn
    Out "--------------------------------"
    $uwpRubbishApps = @("Microsoft.Messaging", "king.com.CandyCrushSaga", "Microsoft.BingNews", "Microsoft.MicrosoftSolitaireCollection", "Microsoft.People", "Microsoft.WindowsFeedbackHub", "Microsoft.YourPhone", "Microsoft.MicrosoftOfficeHub", "Fitbit.FitbitCoach", "Microsoft.GetHelp")
    
    foreach ($uwp in $uwpRubbishApps) {
        Get-AppxPackage -Name $uwp | Remove-AppxPackage
    }
}

function Disable-Cortana-Regedits() {
    Out 'Bye Cortana - get out of my bloody system.' -Comment
    New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\' -Name 'Windows Search' | Out-Null
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortana' -PropertyType DWORD -Value '0' | Out-Null
    Out 'yay no Cortana getting in the way now! xD' -Comment
}

# -----------------------------------------------------------------------------
$computerName = Read-Host 'Enter New Computer Name (no spaces or special characters!)'
Out "Renaming this computer to: " $computerName  -Warn
Rename-Computer -NewName $computerName
# -----------------------------------------------------------------------------
Write-Host ""
$devMachine = Read-Host 'Is this a developer machine? (Y/N default N):'
$installDevContent = $devMachine.ToUpper().Trim() -eq 'Y'
# -----------------------------------------------------------------------------
Out "Configure your sleep preferences (for always on choose 0)"
$monitorTimeout = Read-Host 'Monitor timeout in minutes (0 always on):' -ForegroundColor Yellow
$standbyTimeout = Read-Host 'Standby timeout in minutes (0 always on):' -ForegroundColor Yellow
Powercfg /Change monitor-timeout-ac $monitorTimeout
Powercfg /Change standby-timeout-ac $standbyTimeout
# -----------------------------------------------------------------------------

# Setup choco and clean-house
Choco
Clear-Windows-Rubbish
Disable-Cortana-Regedits

Out "Setting up runtimes..." -Install
Install-Apps -Apps $langsAndRuntimes

# developer mode
if($installDevContent) {
    Add-Develop-Stuff
    Out "Installing Python and Configuring the workspace environments..." -Install
    Out "---------------------------------------------------------------"
    Setup-Python-Workspace
    Out "Setting up editors..." -Comment
    Out "---------------------"
    Install-Apps -Apps $editors
}

# -----------------------------------------------------------------------------

Out "Installing User Applications" -Comment
Out "----------------------------"

Out  "Grabbing browsers - hold tight and get ready to Google..." -Install
Install-Apps -Apps $browsers

Out  "Setting up utilities..." -Install
Install-Apps -Apps $utilities

Out  "Installing PC System applications..." -Install
Install-Apps -Apps $pcSystemApps

Out  "Productivity setup and install..." -Install
Install-Apps -Apps $productivity

Out  "Minimal entertainment! Installing the basics." -Install
Install-Apps -Apps $entertainment

# -----------------------------------------------------------------------------
Out  "Checking Windows updates. This will take awhile." -Comment
Out  "------------------------------------------------"
Install-Module -Name PSWindowsUpdate -Force
Out  "Installing updates (Restart will be required)." -Install
Get-WindowsUpdate -AcceptAll -Install -ForceInstall -AutoReboot
# -----------------------------------------------------------------------------
Read-Host -Prompt "Setup is done, restart is needed, press [ENTER] to restart computer"
Out 'Press any key to continue with restart. SAVE YOUR WORK' -Warn
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Restart-Computer