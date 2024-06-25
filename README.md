# Windows 10 Developer Machine Setup

Fork of Albert118's setup script who forked it from Edi Wang's. You can modify the scripts to fit your own requirements. See Edi Wang [here](https://github.com/EdiWang). See Albert118 [here](https://github.com/Albert118)

## Prereq's

- A fresh install of Windows 10 and internet

## 'One Click' Copypasta install

```
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/albert118/EnvSetup/master/oneclick-install.ps1'))
```

## Manual Install

1. Download this repo as a zip

  > **Optional**: Import "Add_PS1_Run_as_administrator.reg" to your registry to enable context menu on the powershell files to run as Administrator.

2. Run `Install.ps1`.
  > right click and choose run with Powershell...

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
- `Set-ExecutionPolicy RemoteSigned`

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
