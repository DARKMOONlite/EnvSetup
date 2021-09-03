# TODO :
Set-ExecutionPolicy RemoteSigned fix needs adding

# Windows 10 Developer Machine Setup
Fork of Edi Wang's set up script for new dev machines. You can modify the scripts to fit your own requirements.
See Edi Wang [here](https://github.com/EdiWang).

The first thing this script installs is Fira Code font. I find it super readable and it's on choco (yay)! My machine is a bit of a mish-mash. It includes my Python dev env, networking tools, research tools, various team tools and editors, as well as some fun stuff like Steam.

I also run a separate VM host for any Linux distros, so I don't both with Cygwin, WLS, etc. CMD is good enough and does the jobs I use it for (git mainly - occasionally networking). This script also runs a Python environment installation script after choco.

## Prereq's

- A clean install of Windows 10 Pro v2004 en-us or above.
- If you are in China: a stable "Internet" connection.

> This script has not been tested on other version of Windows, please be careful if you are using it on other Windows versions.

## Quick Start

1. Download this fork version. Latest copy [here](https://github.com/albert118/EnvSetup/blob/master/Install.ps1)
	**Optional**: For the original, download Edi Wang's latest script [here](https://raw.githubusercontent.com/EdiWang/EnvSetup/master/Install.ps1)
	**Optional**: Import "Add_PS1_Run_as_administrator.reg" to your registry to enable context menu on the powershell files to run as Administrator.

2. Run `Install.ps1`.
  * > right click and choose run with Powershell...

## What the Script Does

- Set a New Computer Name
- Disable Sleep on AC Power
- YEET Cortana (seriously, it's so annoying to accidentaly trigger her during something important).
- Remove a few pre-installed Win10 apps.
    - Messaging, CandyCrush, Bing News, Solitaire, People, Feedback Hub, Your Phone, My Office, FitbitCoach
    - Upgrade Pip (it never shuts up otherwise).
    - Install some common libs I use (numpy of course and few others, see and update requirements.txt)
    - Make a git directory for my projects.
    - Install the credentials manager.
    - Make a default python scratch-space.
- Install Chocolatey for Windows
- Setup the dev environs (opt.)
  - Configures a monospace font (Fira Code Retina) for the system. Feel free to enable this in all your editors (ligatures too!).
- Install the user apps
- Install Windows Udpates
