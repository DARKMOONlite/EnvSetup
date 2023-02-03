# -----------------------------------------------------------------------------

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
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/microsoft/artifacts-credprovider/master/helpers/installcredprovider.ps1'))



Write-Host "      Excluding repos from Windows Defender" -ForegroundColor Green

Add-MpPreference -ExclusionPath "$env:USERPROFILE\source\repos"
Add-MpPreference -ExclusionPath "$env:USERPROFILE\.nuget"
Add-MpPreference -ExclusionPath "$env:USERPROFILE\.vscode"
Add-MpPreference -ExclusionPath "$env:USERPROFILE\.dotnet"
Add-MpPreference -ExclusionPath "$env:USERPROFILE\.ssh"
Add-MpPreference -ExclusionPath "$env:APPDATA\npm"
Add-MpPreference -ExclusionPath "$env:APPDATA\git"


Write-Host "      Adding default .ssh directory"  -ForegroundColor Green

mkdir .ssh

Write-Host "Development Depenedencies were installed";
