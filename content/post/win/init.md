+++
title = "🪟 Windows Developer Setup"
description = "Tools for developing software with Odin."
date = "2026-11-15T01:00:00"
keywords = ["code", "programming","Windows"]
draft = true
+++



## WinGet

https://learn.microsoft.com/en-us/windows/package-manager/
install, list, upgrade and uninstall packages

Terminal to open Windows PowerShell

`winget install -e --id ...`
exact identifier

always be careful

either way, can still upgrade with WinGet or UniGetUI

## UniGetUI

WinGet and other package managers
https://devolutions.net/unigetui/
https://github.com/Devolutions/UniGetUI


## Visual Studio Community Edition

https://visualstudio.microsoft.com/vs/community/

2022
2026

Odin ships with The RAD Linker and LLD (for Link Time Optimization with `-lto:thin`)
Windows SDK, MSVC C runtime, etc.

build Odin compiler from source
build C/C++ libraries

Tools for Visual Studio > Build Tools for Visual Studio
https://visualstudio.microsoft.com/downloads/



Desktop development with C++
MSVC
Windows 11 SDK
Clang?

$1 Million US Dollars in annual revenue

Microsoft.VisualStudio.Community
Microsoft.VisualStudio.BuildTools

https://github.com/karl-zylinski/odin-installer


## Odin

https://odin-lang.org/
https://github.com/odin-lang/Odin
odin-lang.Odin


## Zed

ZedIndustries.Zed
https://zed.dev/
https://github.com/zed-industries/zed

Zed Line Ending setting to Prefer LF

Ctrl-Shift-X
https://github.com/zed-extensions/odin
OLS Odin Language Server
https://github.com/DanielGavin/ols


## Git Bash

Git.Git

`~/.inputrc`

```bash
set bell-style none

# Use Up/Down arrows to search through history based on input
"\e[A": history-search-backward
"\e[B": history-search-forward
```

```bash
git config --global core.autocrlf false
git config --global core.eol lf
```


## Obsidian

https://obsidian.md/
Obsidian.Obsidian

## MusicBee

https://getmusicbee.com/


## Just

https://just.systems/
https://github.com/casey/just
Casey.Just

## RAD Debugger

EpicGames.RADDebugger
https://github.com/EpicGames/raddebugger

## SumatraPDF

SumatraPDF.SumatraPDF
https://www.sumatrapdfreader.org/free-pdf-reader
https://github.com/sumatrapdfreader/sumatrapdf

## GitHub Desktop

Zed

Electron
GitHub.GitHubDesktop
https://github.com/apps/desktop
https://github.com/desktop/desktop

## GitHub command line

GitHub.cli
https://cli.github.com/
https://github.com/cli/cli

`gh`


## Source checkouts

~/src/github.com/odin-lang

git clone https://github.com/odin-lang/Odin.git
git clone https://github.com/odin-lang/examples

~/src/github.com/karl-zylinski

git clone https://github.com/karl-zylinski/odin-c-bindgen 

~/src/github.com/nathany

git clone https://github.com/nathany/odin-examples.git
