
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Checking Windows updates" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Install-Module -Name PSWindowsUpdate -Force
Write-Host "Installing updates (Computer will reboot in a few minutes)" -ForegroundColor Green
Get-WindowsUpdate -AcceptAll -Install -ForceInstall -AutoReboot
