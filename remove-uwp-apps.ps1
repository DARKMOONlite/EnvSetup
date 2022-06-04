# -----------------------------------------------------------------------------
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
    "Groove"
)

# -----------------------------------------------------------------------------
foreach ($uwp in $uwpRubbishApps) {
    Get-AppxPackage -Name $uwp | Remove-AppxPackage
}

Write-Host "Removed UWP Apps" -ForegroundColor Green;
