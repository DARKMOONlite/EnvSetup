# -----------------------------------------------------------------------------

# not much - keep it simple.
$entertainment = @(
    "vlc"
    "steam"
    "plex"
    "spotify"
)

# -----------------------------------------------------------------------------
function InstallApps([string[]]$Apps)
{
    foreach ($app in $Apps) {
        choco install $app -y
    }
}

# -----------------------------------------------------------------------------

Write-Host "Minimal entertainment! Installing the basics" -ForegroundColor Green
InstallApps -Apps $entertainment
Write-Host "Entertainment installation completed" -ForegroundColor Green;