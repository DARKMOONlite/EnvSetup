# Windows 10 Developer Machine Setup
Fork of Edi Wang's set up script for new dev machines. You can modify the scripts to fit your own requirements.
See Edi Wang [here](https://github.com/EdiWang).

The first thing this script installs is Fira Code font. I find it super readable and it's on choco.
My machine is a bit of a mish-mash. It includes my Python dev env, networking tools, research tools, various team tools and editors, as well as some fun stuff like Steam and Netflix.

I also run a separate VM host for any Linux distros, so I don't both with Cygwin, WLS, etc. CMD is good
enough and does the jobs I use it for (git mainly - occasionally networking).
This script also runs a Python environment installation script after choco.

## Prerequisites

- A clean install of Windows 10 Pro v2004 en-us.
- If you are in China: a stable "Internet" connection.

> This script has not been tested on other version of Windows, please be careful if you are using it on other Windows versions.

## Install Guide

1. Download this fork version. Latest copy [here](https://github.com/albert118/EnvSetup/blob/master/Install.ps1)
	**Optional**: For the original, download Edi Wang's latest script [here](https://raw.githubusercontent.com/EdiWang/EnvSetup/master/Install.ps1)
	**Optional**: Import "Add_PS1_Run_as_administrator.reg" to your registry to enable context menu on the powershell files to run as Administrator.

2. Run `Install.ps1`.

- Set a New Computer Name
- Disable Sleep on AC Power
- Install Chocolate for Windows
- Configure the CMD to my liking with some quick regedits (Fira Code font, green text on black background).
- Install the following,
    - 7zip.install,
    - git,
    - vscode,
    - doxygen.install,
    - putty,
    - pingplotter,
    - wireshark,
    - zotero,
    - r.studio,
    - r,
    - windirstat,
    - gimp,
    - samsung-magician,
    - sublimetext3.app,
    - python,
    - python2,
    - microsoft-edge,
    - googlechrome,
    - wget,
    - openssl.light,
    - vscode,
    - microsoft-teams.install,
    - github-desktop,
    - vlc,
    - steam,
    - qbittorrent,
    - msiafterburner,
- Remove a few pre-installed UWP applications
    - Messaging
    - CandyCrush
    - Bing News
    - Solitaire
    - People
    - Feedback Hub
    - Your Phone
    - My Office
    - FitbitCoach
- Do some basic house cleaning for a Python / R workspace environment.
    - Upgrade Pip (it never shuts up otherwise).
    - Install some common libs I use (numpy of course and few others, see requirements.txt)
    - make a git directory for my projects.
