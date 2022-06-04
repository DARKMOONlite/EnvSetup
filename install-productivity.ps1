# -----------------------------------------------------------------------------

# university, documents, admin stuff
$productivity = @(
    "zotero"
    "gimp"
    "microsoft-teams.install"
    "grammarly-edge"
    "grammarly"
    "adobereader"
    "parsec"
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
    "adobereader"
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


# -----------------------------------------------------------------------------
function InstallApps([string[]]$Apps)
{
    foreach ($app in $Apps) {
        choco install $app -y
    }
}

# -----------------------------------------------------------------------------

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