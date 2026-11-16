+++
title = "🪟 Windows Developer Setup"
description = "Tools for developing software with Odin."
date = "2026-11-16T01:00:00"
keywords = ["code", "programming","Windows"]
draft = true
+++

Having been a Mac user since 2001, it's taken some time to acclimate to working on Windows. This post covers my programming tools while learning [handmade game development](/handmade) with 🔱 [Odin][].

All these tools are _free_ and most of them are _open source._ I decided to cover graphics programming tools separately, and this post doesn't cover any tools for art, music, etc.

If you're new to system programming, this list may be a good place to start. If you're a veteran, maybe one or two of these tools will prove useful.

[Odin]: https://odin-lang.org/

## WinGet

[WinGet](https://learn.microsoft.com/en-us/windows/package-manager/) is a package manager that ships with Windows. It can `install`, `upgrade` and `uninstall` software from a command line interface (CLI).

Open the Terminal app to try it out. Windows PowerShell will likely work best.

```PowerShell
winget show -e --id Git.Git
```

The `-e` option means exact identifier and `--id` specifies that an identifier follows. If you don't specify these options (e.g. `winget show git`), you could get multiple other results. <mark>Always be careful when installing software from the Internet.</mark> Be sure the source is what you expect.

One very nice thing about WinGet is that it can upgrade software that was manually downloaded and installed. See what you already have installed with:

```PowerShell
winget list
```

## UniGetUI

[UniGetUI](https://devolutions.net/unigetui/) is an [open source](https://github.com/Devolutions/UniGetUI) graphical user interface (GUI) for managing packages with WinGet and several other package managers. It's great for keeping software up-to-date, no matter how it was installed.

As per the [installation instructions](https://github.com/Devolutions/UniGetUI#installation), you can install it with:

```PowerShell
winget install --exact --id Devolutions.UniGetUI --source winget
```

## Visual Studio Community Edition

Even though we'll be using the Odin, we still need to install the Windows <abbr title="Software Development Kit">SDK</abbr>, C runtime, etc.

A C/C++ compiler will also come in handy. Many of Odin's vendor libraries are written in C/C++ and we'll likely encounter other C/C++ libraries (e.g. Dear ImGUI). At some point we may need to build the Odin compiler from source (C++) too, say for a debug build to report/fix an issue.

MSVC isn't the only C/C++ compiler in town, but it's the smoothest option.[^1]

> "when in Windows, do as the [PCs](https://www.youtube.com/watch?v=0eEG5LVXdKo) do" 🤨

We need to install [Build Tools for Visual Studio](https://visualstudio.microsoft.com/downloads/) at minimum, and optionally the full [Visual Studio](https://visualstudio.microsoft.com/vs/community/) <abbr title="Integrated Development Environment">IDE</abbr>. Visual Studio is handy for building and running C++ example code, as books often include the solution/project files for <abbr title="Microsoft Visual Studio">MSVC</abbr>.

This installation is big and slow, so let's get it over with. Kick off the installation with one of these commands (Community being the full IDE):

```PowerShell
winget install -e --id Microsoft.VisualStudio.Community

# or

winget install -e --id Microsoft.VisualStudio.BuildTools
```

Or you can try out Karl Zylinski's new [Odin installer](https://github.com/karl-zylinski/odin-installer), which also installs MSVC.

During installation, look for **Desktop development with C++** and components like **MSVC** and the **Windows 11 SDK**. If you chose Visual Studio, there will be options for debuggers, profilers, etc. Most of the other options can be left unchecked (C#, .NET, etc.). You can always relaunch the installer later if you need to add/remove components.

My present understanding is that even if you only install the Build Tools, you're still subject to the Community Edition license. It's only free if annual revenue is less than $1 Million US Dollars. Noted.

[^1]: If you absolutely want to avoid Visual Studio, you may be able to install Clang/GCC with MinGW or WinLibs. But all the static C/C++ libraries you link to will need to be recompiled with that toolchain. That includes all the vendor libraries that ship with Odin. I've not attempted this and it's not officially supported by Odin.

To use the C/C++ compiler from the <abbr title="Command Line Interface">CLI</abbr> (`cl`), we need to launch one of the special ["Developer" command prompts][cl]. Awkward.😅

[cl]: https://learn.microsoft.com/en-us/cpp/build/building-on-the-command-line

## Odin

[Odin](https://odin-lang.org/) is "the C alternative for the Joy of Programming." It can be installed from [source][], or it's trivial to install with WinGet:

```PowerShell
winget install -e --id odin-lang.Odin
```

Installation should add `odin` to your PATH, but you need to <mark>close/reopen the entire Terminal app</mark> to recognize the new PATH.[^2] Then manually change directory (`cd`) back to where you were.[^2] After that, odin commands should work, eg:

```PowerShell
odin report
```

[source]: https://github.com/odin-lang/Odin

[^2]: Two frequent annoyances with Windows Terminal.😾

## Zed

[Zed](https://zed.dev/) is a fast, free and [open source](https://github.com/zed-industries/zed) text editor. Zed has been working well for me for the last few years, but many good editors exist. To try out Zed, install it with:

```PowerShell
winget install -e --id ZedIndustries.Zed
```

Configure your settings as desired: (Ctrl-,)

- Disable Telemetry
- Disable AI to reduce some clutter
- Set Line Ending to Prefer LF. I use a mix of operating systems, so I'd rather avoid the Windows <abbr title="Carriage return, line feed">CRLF</abbr> default.

Suggested extensions: (Ctrl-Shift-X)

- [Odin](https://github.com/zed-extensions/odin) -- syntax highlighting, formatting, documentation
- [Comments Highlighter](https://github.com/thedadams/zed-comment) -- colorizes NOTE, TODO, FIXME, etc.
- [CSpell](https://github.com/mantou132/zed-cspell) -- code aware spell checker
- [GLSL](https://github.com/zed-industries/zed) -- shader language for OpenGL/Vulkan
- [HLSL](https://github.com/igordreher/zed-hlsl) -- shader language for Direct3D
- [Justfile](https://github.com/jackTabsCode/zed-just) -- command runner (more below)

The Odin extension will automatically install the [Odin Language Server](https://github.com/DanielGavin/ols) (OLS).

## Git Bash

Install the Git <abbr title="Version Control System">VCS</abbr> to use it from the <abbr title="Command Line Interface">CLI</abbr> and from Zed. It also installs Git Bash, a more familiar shell for a Mac user like myself. It can even run shell scripts from Mac/Linux (no need for separate .bat files).

```PowerShell
winget install -e --id Git.Git
```

To disable screen flashes when backspacing and improve history traversal, create an .inputrc file. With Zed installed, just type `zed ~/.inputrc` in Terminal. The file should contain:

```bash
set bell-style none

# Use Up/Down arrows to search through history based on input
"\e[A": history-search-backward
"\e[B": history-search-forward
```

By default Git will do CRLF/LF translation, but that can be disabled with a few commands in Terminal:

```bash
git config --global core.autocrlf false
git config --global core.eol lf
```

Configuring Git Bash to run `cl` or `clang-cl` (if installed) is left as an [exercise for the reader][cl].😅

## RAD Debugger

[RAD Debugger][] is a very nice [open source][RAD Debugger] graphical debugger. Not only is it faster than adding `printf` debugging or logging, it will help debug unrecoverable errors like segfaults.

```PowerShell
winget install -e --id EpicGames.RADDebugger
```

Given an Odin executable named `hello.exe` compiled with `-debug` info, launching RAD Debugger is as easy as running: `raddbg hello.exe`.

[RAD Debugger]: https://github.com/EpicGames/raddebugger

## Just

[Just](https://just.systems/) is a modern command runner, and it's [open source](https://github.com/casey/just). Easily installed with:

```PowerShell
winget install -e --id Casey.Just
```

I'm planning to use `Justfile` as an alternative to Makefiles for any commands that I run often. Here's what a simple example looks like (`just check`), but it supports a lot more:

```Justfile
check:
    odin check . -strict-style -warnings-as-errors
```

## Obsidian

[Obsidian](https://obsidian.md/) is a digital notebook where I organize my day, list online resources and keep notes when reading books and articles.

```PowerShell
winget install -e --id Obsidian.Obsidian
```

Suggested theme:

- [Minimal](https://minimal.guide/) -- additional checklist states and other improvements

Suggested community plugins:

- [Advanced Canvas](https://github.com/developer-mike/obsidian-advanced-canvas) -- mind maps, etc.
- [Advanced Tables](https://github.com/tgrosinger/advanced-tables-obsidian) -- improved navigation
- [Auto Template Trigger](https://github.com/numeroflip/obsidian-auto-template-trigger) -- set folder-specific templates
- [Minimal Theme Settings](https://github.com/kepano/obsidian-minimal-settings) -- color schemes
- [Outliner](https://github.com/vslinko/obsidian-outliner) -- improve list navigation
- [Periodic Notes](https://github.com/liamcain/obsidian-periodic-notes) -- setting up daily templates

## SumatraPDF

[SumatraPDF](https://www.sumatrapdfreader.org/free-pdf-reader) is a fast, free and [open source](https://github.com/sumatrapdfreader/sumatrapdf) PDF reader. My library of ebooks can be used as reference material.

```PowerShell
winget install -e --id SumatraPDF.SumatraPDF
```

## MusicBee

[MusicBee](https://getmusicbee.com/) is a free music player to get in the zone.

## GitHub Desktop & CLI

We already have the `git` CLI and [Zed's git support](https://zed.dev/git), but sometimes I like a separate <abbr title="Graphical User Interface">GUI</abbr>.

[GitHub Desktop][] isn't my favorite Git client, but it's free and [open source](https://github.com/desktop/desktop).

```PowerShell
winget install -e --id GitHub.GitHubDesktop
```

[GitHub Desktop]: https://github.com/apps/desktop

[GitHub CLI](https://cli.github.com/) is an [open source](https://github.com/cli/cli) command line interface (`gh`) to interact with GitHub.

```PowerShell
winget install -e --id GitHub.cli
```

## Source checkouts

We installed the Odin binary, but it's helpful to clone the source code for viewing locally.

With regards to code organization, in the Go 1.0 days (before Go modules), I adopted a file structure that mirrors code repositories like [github.com](https://github.com/). For example, I have a `~/src/github.com/odin-lang` directory with repositories from the [odin-lang](https://github.com/odin-lang/) GitHub organization. This structure is by no means required, but I found it useful, so I stuck with it.

```bash
mkdir -p ~/src/github.com/odin-lang && cd ~/src/github.com/odin-lang

git clone https://github.com/odin-lang/Odin.git
git clone https://github.com/odin-lang/examples
```

If I want to clone a repository by Karl Zylinski, I would make a directory at `~/src/github.com/karl-zylinski` and then clone:

```bash
git clone https://github.com/karl-zylinski/odin-c-bindgen
```

And my own code follows the same pattern, falling under a `~/src/github.com/nathany` directory:

```bash
git clone https://github.com/nathany/odin-examples.git
```

If everything is installed correctly,

```bash
./build.bat

# or


```
