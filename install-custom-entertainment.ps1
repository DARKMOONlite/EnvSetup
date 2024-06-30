# -----------------------------------------------------------------------------

# not much - keep it simple.
$entertainment = @(
    #"opera"
    #"origin"
    "zoom"
)

# -----------------------------------------------------------------------------
function InstallApps([string[]]$Apps)
{
    foreach ($app in $Apps) {
        choco install $app -y
    }
}

# -----------------------------------------------------------------------------

Write-Host "installing custom entertainment" -ForegroundColor Green
InstallApps -Apps $entertainment
Write-Host "Custom entertainment installation completed" -ForegroundColor Green;
