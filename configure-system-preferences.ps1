# -----------------------------------------------------------------------------
$computerName = Read-Host 'Enter New Computer Name'
Write-Host "Renaming this computer to: " $computerName  -ForegroundColor Yellow
Rename-Computer -NewName $computerName
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Disable Sleep on AC Power" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Powercfg /Change monitor-timeout-ac 10
Powercfg /Change standby-timeout-ac 30
Write-Host ""
Write-Host "Enabling Dark Mode" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0
