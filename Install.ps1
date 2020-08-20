if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

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
Powercfg /Change monitor-timeout-ac 20
Powercfg /Change standby-timeout-ac 0

# To list all appx packages:
# Get-AppxPackage | Format-Table -Property Name,Version,PackageFullName
Write-Host "Removing UWP Rubbish..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
$uwpRubbishApps = @(
    "Microsoft.Messaging",
    "king.com.CandyCrushSaga",
    "Microsoft.BingNews",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.People",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.YourPhone",
    "Microsoft.MicrosoftOfficeHub",
    "Fitbit.FitbitCoach",
    "Microsoft.GetHelp")

foreach ($uwp in $uwpRubbishApps) {
    Get-AppxPackage -Name $uwp | Remove-AppxPackage
}

if (Check-Command -cmdname 'choco') {
    Write-Host "Choco is already installed, skip installation."
}
else {
    Write-Host ""
    Write-Host "Installing Chocolate for Windows..." -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

Write-Host "Config console aesthetics." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
choco install "firacode" -y

Set-Itemproperty -path "HKCU:\Console\%SystemRoot%_system32_cmd.exe" -Name "FaceName" -value "Fira Code Retina"
Set-Itemproperty -path "HKCU:\Console\%SystemRoot%_system32_cmd.exe" -Name "FontSize" -value c0000
Set-Itemproperty -path "HKCU:\Console\%SystemRoot%_system32_cmd.exe\" -Name "ScreenColors"  -value a

Write-Host "Console aesthetics have been updated for the cmd. Please restart any active cmds..." -ForegroundColor Yellow

Write-Host ""
Write-Host "Installing Applications..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "[WARN] Ma de in China: some software like Google Chrome require the true Internet first" -ForegroundColor Yellow

$Apps = @(
    "7zip.install",
    "git",
    "vscode",
    "doxygen.install",
    "putty",
    "pingplotter",
    "wireshark",
    "zotero",
    "r.studio",
    "r",
    "windirstat",
    "gimp",
    "samsung-magician",
    "sublimetext3.app",
    "python",
    "python2",
    "microsoft-edge",
    "googlechrome",
    "wget",
    "openssl.light",
    "vscode",
    "microsoft-teams.install",
    "github-desktop",
    "vlc",
    "steam",
    "qbittorrent",
    "msiafterburner",
    )

foreach ($app in $Apps) {
    choco install $app -y
}

Write-Host "Beginning Python and R Dev Env set up." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
python -m pip install --upgrade pip
python -m pip install requirements.txt
mkdir git

Write-Host "------------------------------------" -ForegroundColor Green
Read-Host -Prompt "Setup is done, restart is needed, press [ENTER] to restart computer."
Restart-Computer
