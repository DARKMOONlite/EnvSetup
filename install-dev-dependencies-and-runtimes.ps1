# -----------------------------------------------------------------------------

# Choose your editors here
$editors = @(
    "vscode"
    "sublimetext3.app"
    "visualstudio2019community"
    "jetbrains-rider"
    "dotcover"
    "dottrace"
    "dotmemory"
    "dbeaver"
    "resharper"
    "sql-server-management-studio"
    "microsoft-windows-terminal"
)


$vscodeExtensions = @(
    "bierner.markdown-mermaid"
    "DotJoshJohnson.xml"
    "dsznajder.es7-react-js-snippets"
    "eamodio.gitlens"
    "ecmel.vscode-html-css"
    "janisdd.vscode-edit-csv"
    "mathematic.vscode-latex"
    "ms-azuretools.vscode-docker"
    "ms-dotnettools.csharp"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-toolsai.jupyter"
    "ms-toolsai.jupyter-keymap"
    "ms-toolsai.jupyter-renderers"
    "ms-vscode-remote.remote-containers"
    "ms-vscode.cpptools"
    "ms-vscode.powershell"
    "redhat.java"
    "searKing.preview-vscode"
    "trond-snekvik.simple-rst"
    "VisualStudioExptTeam.vscodeintellicode"
    "vscjava.vscode-java-debug"
    "vscjava.vscode-java-dependency"
    "vscjava.vscode-maven"
    "XephAlpha.syntax"
    "yzhang.markdown-all-in-one"
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

Write-Host ""
Write-Host "    WSL" -ForegroundColor Green
Write-Host "    if this install doesn't work, see this link: https://www.windowscentral.com/how-install-wsl2-windows-10" -ForegroundColor Yellow
wsl --install

Write-Host ""
Write-Host "    Installing VS Code Extensions"
foreach ($codeExtension in $vscodeExtensions) {
    Write-Host ""
    code --install-extension $codeExtension
}

Write-Host "     Setting up editors" -ForegroundColor Green
Write-Host "     Remember to configure the Windows Terminal!" -ForegroundColor Yellow
InstallApps -Apps $editors

Write-Host "      Installing Github.com/microsoft/artifacts-credprovider" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/microsoft/artifacts-credprovider/master/helpers/installcredprovider.ps1'))


Write-Host "Development Depenedencies were installed";