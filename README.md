# yaknewtab - a script to create new Yakuake tabs (a/k/a "Sessions")

_Forked from [yakuake-session](https://github.com/aplatanado/yakuake-session) by [Jesús Torres](https://github.com/aplatanado), (C) 2010-2018._

## What is yaknewtab?

**yaknewtab** is a (mostly) POSIX shell script that greatly simplifies the creation of new tabs/sessions in Yakuake. It uses simple logic to determine the D-Bus CLI tool needed to communicate with the already-running Yakuake process, adding the specifics (supplied as standard POSIX flags and arguments) in the necessary syntax to generate the desired result.

I forked it from the original developer mainly to streamline the approach, more closely following concensus best practices, and ultimately achieving (I believe) greater consistency of operation on a wider range of shells. Like the upstream project the goal is a better integration of Yakuake with the desktop environment (typically KDE Plasma 5) and other resident applications. This is something which has often been constrained by its design as an "always-running" foreground process that remains hidden from view until triggered, insisting on D-Bus as the only method to receive user directives that are not issued through its GUI.

Where on most *nix systems a needed terminal instance can be invoked by simply calling its executable, with Yakuake that would add another running instance, conflicting with the one which was already running and hidden. To successfully accomplish new instance creation with Yakuake (i.e. telling the hidden instance to show itself and add a new tab in the requested working directory) requires use of the D-Bus interface, a task sufficiently esoteric that even many power users struggle to do without hiccups.

For example, thanks to it, Yakuake can replace Konsole in "Open terminal here" action in Dolphin or we can setup a menu similar to Konsole Profiles widget but using Yakuake instead of Konsole.

## What is Yakuake?

A terminal emulator developed and distributed by KDE as part of the Plasma desktop environment. Visually, it seeks to hearken to the celebrated console panel from the 90s computer game, Quake: sliding into and out of view from the (top) edge of the screen upon the press of a hotkey.

The name is an exquisite example of over-the-top open source project naming irony. Technically a portmanteau crossed with a backronym, it's derived from the motto "Yet Another Kuake." In keeping with KDE project tradition, phonemes that can be represented with the letter 'k' are styled as such, explaining the odd spelling.

#### _Links to more information about Yakuake_

* [Project Home Page](https://kde.org/applications/system/yakuake/)
* [Browseable Source Code Repository](https://cgit.kde.org/yakuake.git/) (or clone via [git](git://anongit.kde.org/yakuake.git)/[https](https://anongit.kde.org/yakuake.git))
* [KDE Bugtracking System](https://bugs.kde.org/buglist.cgi?component=general&list_id=1612098&product=yakuake&resolution=---)
* [OpenDesktop.org - Yakuake](https://www.linux-apps.com/content/show.php?content=29153)
* [KDE UserBase Wiki](https://userbase.kde.org/Yakuake)
* [Freenode Web Chat: #yakuake](http://webchat.freenode.net/?randomnick=1&channels=%23yakuake&prompt=1&uio=MTY9dHJ1ZSY5PXRydWUmMTI9dHJ1ZQ6c) ([irc:// link](irc://irc.freenode.org/#yakuake))

## Bugs & known issues

* Requires wmctrl to change focus if yakuake is already open. Get it from the repo e.g. `apt install wmctrl`

* Fish is not a POSIX compliant shell, so yaknewtab detects if it is used for the invocation and adjusts its operations accordingly. If the auto-detection doesn't work properly, two solutions exist:
  * Issuing the command `export FISH_SHELL=0` temporarily disables the Fish shell adaptations, while `export FISH_SHELL=1` temporarily enables them

  * For a permanent change, use the following command (provided that you placed it in a location in your $PATH) to open the script file in the default editor and change line 14 accordingly: `FISH_SHELL=1` to enable the Fish shell changes or `FISH_SHELL=0` to disable them.
      ```bash
      which yaknewtab | xargs sudoedit -e
      ```


## Installation

Clone this repository.

```bash
git clone https://github.com/RogueScholar/yaknewtab.git
```

Copy the yaknewtab script to `~/bin`, `/usr/local/bin` or some other directory
in your `$PATH` variable, if you don't want to be forced to the path of the script when
invoked. For example, on Ubuntu:

```bash
sudo cp yaknewtab /usr/local/bin
```

## Usage

To invoke yaknewtab:

```bash
yaknewtab
```

Without arguments, yakuake-session creates a new session in the currently
running Yakuake terminal emulator.

The option `-e` allows to indicate a command to execute in the new session.

```bash
yakuake-session -e ls
```

The argument `-t` sets the title for the new tab.

```bash
yakuake-session -t "Title"
```

The session working directory is changed to the directory where yakuake-session
was called, before execute the command. If we want to launch the command from
user's home directory then we would use the option `-h`.

```bash
yakuake-session -h -e ls
```

If the command requires some arguments, they are taken from non-option
arguments passed to yakuake-session. That means that if some arguments for the
command begin with `-`, they must passed to yakuake-session after `--`.

```bash
yakuake-session -h -e ssh -- -X user@example.com
```

Another useful option is `--workdir`. It allows to change the working directory
before execute the command.

```bash
yakuake-session --workdir /tmp -e ls
```

yakuake-session has many other options that were shown in help.

```bash
yakuake-session --help

Usage: yakuake-session [options] [args]

Options:
  --help                    Show help about options.
  -h, --homedir             Set the working directory of the new tab to the user's home.
  -w, --workdir <dir>       Set the working directory of the new tab to 'dir'
  --hold, --noclose         Do not close the session automatically when the command ends.
  -p <property=value>       Change the value of a profile property (only for KDE 4).
  -q                        Do not open yakuake window.
  -t <title>                Set the title of the new tab
  -e <cmd>                  Command to execute. This option will catch all following arguments, so use it as the last option.
  --fish | --nofish         Override default shell autodetection to enable or disable the fish shell support.
  --debug                   Show yakuake_session debug information.

Arguments:
  args                      Arguments passed to command (for use with -e).
```

## Action in Dolphin

Dolphin provides the action "Open terminal here" that opens a Konsole terminal
emulator in the specified folder. This behavior can be changed to use Yakuake
instead of Konsole coping `konsolehere.desktop` into KDE Service Menus.

```bash
# KDE 4
cp ServiceMenus/konsolehere.desktop ~/.kde/share/kde4/services/ServiceMenus/
# KDE 5
cp ServiceMenus/konsolehere.desktop ~/.local/share/kservices5/ServiceMenus/
```

If we do not want to change the behavior of "Open terminal here", then copy
`yakuakehere.desktop` instead to add the new action "Open yakuake here" to
Dolphin.

```bash
# KDE 4
cp ServiceMenus/yakuakehere.desktop ~/.kde/share/kde4/services/ServiceMenus/
# KDE 5
cp ServiceMenus/yakuakehere.desktop ~/.local/share/kservices5/ServiceMenus/
```

## Quick Access Menu

Konsole Profiles is a Plasma widget that allows to open a new terminal window,
configured according to a select profile, and automatically execute a command
in it. We can get something similar but for Yakuake using the QuickAccess
widget. We only have to make a directory and setup a QuickAccess widget
instance to use it as origin (I also like to disable the browsing). Then we
add some "Link to Application" to that directory, such that each one use
yakuake-session to create a new Yakuake session and to execute the command
that we want.

The file `examples/username@example.com.desktop` contains an example that launch
a ssh client in a new Yakuake session.

### SPDX-License-Identifier: AGPL-3.0-or-later

## ![Creative Commons ShareAlike Symbol-20px](https://user-images.githubusercontent.com/15098724/56478451-5958a680-6464-11e9-944a-f4c744e70f26.png) _Copyleft: All rights reversed_. 2019 [Peter J. Mello](https://github.com/RogueScholar).
