# TODO :
Set-ExecutionPolicy RemoteSigned fix needs adding

# Windows 10 Developer Machine Setup

Fork of Edi Wang's set up script for new dev machines. You can modify the scripts to fit your own requirements. See Edi Wang [here](https://github.com/EdiWang).

## Prereq's

- A clean install of Windows 10 Pro v2004 en-us or above.

## Basic Computer Config

- Set a New Computer Name
- Disable Sleep on AC Power
- Throw Cortana out (seriously, it's so annoying to accidentaly trigger her during something important)
- Remove a few pre-installed Win10 apps.
    - Messaging, CandyCrush, Bing News, Solitaire, People, Feedback Hub, Your Phone, My Office, FitbitCoach
- Install the credentials manager
- Install Chocolatey for Windows
- Install the user apps
- Install Power Tools
- Install Windows updates

### Terminal Config

- Custom Font: `Fira Code font`
  - Configures a monospace font (Fira Code Retina) for the system. Feel free to enable this in all your editors (ligatures too!)
- Terminal Preview

### Docker + WSL2

- Docker + Docker Desktop
- WSL2 + Ubunutu backend

### Git SetUp

- `mkdir` for git
- configure the credentials manager
- configure some git config defaults (editor, etc.)

### .NET Development

- Rider
- Visual Studio 2022 Communit

### Python Development

- Upgrade Pip (it never shuts up otherwise)
- Install some common libs I use (numpy of course and few others, see and update requirements.txt)

## Quick Start

1. Download this fork version. Latest copy [here](https://github.com/albert118/EnvSetup/blob/master/Install.ps1)
	**Optional**: For the original, download Edi Wang's latest script [here](https://raw.githubusercontent.com/EdiWang/EnvSetup/master/Install.ps1)
	**Optional**: Import "Add_PS1_Run_as_administrator.reg" to your registry to enable context menu on the powershell files to run as Administrator.

2. Run `Install.ps1`.
  * > right click and choose run with Powershell...
