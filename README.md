
[![uNixie Clock](./resources/photos/uNixie-Clock.png)](https://cthru.hopto.org/unixie-clock)

[![CC BY-NC-SA 4.0][shield cc-by-nc-sa]][cc-by-nc-sa]
[![GitHub release (latest by date)][shield release]][latest release]
[![GitHub Release Date][shield release date]][latest release]
[![PayPal][shield paypal]][paypal]
[![Buy me a coffee][shield buymeacoffee]][buymeacoffee]


----------
## Introduction
----------
You will always know the time with this styleful Nixie Tube Clock on your Linux desktop.

## Table of Contents
- [Introduction](#introduction)  
- [Features](#features)  
- [Installation](#installation)  
- [Upgrading](#upgrading)
- [Usage](#usage)  
- [Release Notes](#release-notes)  
- [Copyright and License](#copyright-and-license)

## Features
- Displays time in hours, minutes and seconds.
- Each second is accompanied by a nostalgic transition of the changed digits.

## Installation
### Requirements
To use uNixie Clock, you need:
- A Linux operating system.
- The latest release of [Conky](https://github.com/brndnmtthws/conky).

### Installation Procedure
#### Step 1 - Install Conky
Install [Conky](https://github.com/brndnmtthws/conky) (`conky-all` package) using a package manager on your Linux OS or using the latest version from the [Conky website](https://github.com/brndnmtthws/conky).

#### Step 2 - Download and Extract uNixie Clock
- Go to the [Releases page][latest release] to download the source code of the latest uNixie Clock release.
- On the [Releases page][latest release], in the _Assets_ section, click on the _Source code (tar.gz)_ link to download 
  the sources.
- Save the tar.gz file with the sources on your system.
- Create a folder `.conky/unixie_clock` in your home directory.
- Extract all contents of main `uNixie-Clock-[version x.y.z]` folder in the tar.gz file to the `.conky/unixie_clock` folder in the home directory of your system.

#### Step 3 - Prepare for first run
- Open the `~/.conky/unixie_clock` directory.
- Open the file `unixie_clock.conky` in that directory and replace the occurences of `_your_user_home_dir_name_` with your user home directory name.

```lua
lua_load = /home/'_your_user_home_dir_name_/.conky/unixie_clock/unixie_clock.lua',
lua_startup_hook = /home/'conky_config _your_user_home_dir_name_/.conky/unixie_clock/ 100',
```

should be replaced with the code below (in this example the user home directory name is cthru)

```lua
lua_load = '/home/cthru/.conky/unixie_clock/unixie_clock.lua',
lua_startup_hook = '/home/cthru/.conky/unixie_clock/ 100',
```

#### Step 4 - First run
- Open a Terminal window.
- Change the current directory.

> cd ~/.conky/unixie_clock

- Start uNixieClock using the command below. Replace _your_user_home_dir_name_ with your user home directory name.

> conky -c /home/_your_user_home_dir_name_/.conky/unixie_clock/unixie_clock.conky

#### Step 5 (optional) - Autostart
- Open the `autostart_unixie_clock.sh` with a text editor and change the second line to your home directory.
	```sh
	#!/bin/sh
	MY_HOME=/home/_your_user_home_dir_name_
	```
	Example: for a user that is called cthru, change the second line as follows:
	```sh
	#!/bin/sh
	MY_HOME=/home/cthru
	```
- Add the `autostart_unixie_clock.sh` script to the Startup Applications of your linux OS. You can do this via the user interface.  
Alternatively, you can create a `unixie_clock.desktop` file in the `~/.config/autostart` folder.  
You can use the example `unixie_clock.desktop` file provided, but you need to edit the file as follows.  
	- Replace the text `_your_user_home_dir_name_` from the line below with your user home directory name.
		```
		Exec=/home/_your_user_home_dir_name_/.conky/unixie_clock/autostart_unixie_clock.sh
		```
	- You may need to add execution rights to the autostart_unixie_clock.sh file
        > chmod +x autostart_unixie_clock.sh

    - Copy the file.
		> cd ~/.conky/unixie_clock  
		> cp unixie_clock.desktop ~/.config/autostart/unixie_clock.desktop

## Release Notes
For a full changelog of all versions, please look in [`CHANGELOG.md`](./CHANGELOG.md).

## Copyright and License
[![cc-by-nc-sa][shield cc-by-nc-sa]][cc-by-nc-sa]  

Copyright (c) 2023 Christoph Vanthuyne

This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

Read the full license information [`here`](./LICENSE.md).

If you're more into a TL;DR approach, start [`here`][tldrlegal cc-by-nc-sa].

[shield cc-by-nc-sa]: https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png
[tldrlegal cc-by-nc-sa]: https://tldrlegal.com/license/creative-commons-attribution-noncommercial-sharealike-4.0-international-(cc-by-nc-sa-4.0)
[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[shield release]: https://img.shields.io/github/v/release/CTHRU/uNixie-Clock?color=orange
[shield release date]: https://img.shields.io/github/release-date/CTHRU/uNixie-Clock?color=orange
[latest release]: https://github.com/CTHRU/uNixie-Clock/releases/latest
[shield buymeacoffee]: https://img.shields.io/static/v1?label=Buy%20me%20a%20coffee&message=Thank%20You&logo=buymeacoffee
[buymeacoffee]: https://www.buymeacoffee.com/CTHRU
[shield paypal]: https://img.shields.io/static/v1?label=Donate&message=Thank%20You&logo=PayPal
[paypal]: https://www.paypal.com/donate/?hosted_button_id=SSSHR299GZEKQ