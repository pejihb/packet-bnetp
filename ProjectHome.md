## News ##

<font color='red'><b>NEW!</b></font> March 2015: Project moved to GitHub: https://github.com/diegonc/packet-bnetp

March 2015: The plugin was updated to make it work on newer versions of Wireshark. More testing needs to be done specially in previous versions (to make sure it still works on them)

February 2011: Now the plugin supports W3GS (Warcraft 3 game protocol).

## What is this? ##

_packet-bnetp_ is a Wireshark plugin written in Lua for dissecting the Battle.net® protocol and Warcraft 3 game protocol.

Feel free to give feedback, or don't wonder if the project dies.

## How to install? ##

### Since Wireshark 1.4.0 ###

Place the file `packet-bnetp.lua` in one of the directories in the Lua search path. Wireshark will then load it automatically during startup.

**UNIX**

  * /usr/share/wireshark/plugins/foo.lua (global)
  * $HOME/.wireshark/plugins/foo.lua (user-specific)

**Windows**

  * %PROGRAMFILES%\Wireshark\plugins\%WIRESHARK\_VERSION%\foo.lua (global)
  * %APPDATA%\Wireshark\plugins\foo.lua (user-specific)

### Earlier Versions ###

  1. Install Wireshark. The installation program may show Lua as an optional plugin. If it does, enable it. Using 1.2.x version or higher is highly recommended.
  1. Download [packet-bnetp](http://code.google.com/p/packet-bnetp/downloads/list) and unpack it to wireshark installation directory. If you want, you may place it anywhere else provided you give the full path to dofile in the next step.
  1. Open init.lua located at Wireshark installation directory and replace
```
-- Lua is disabled by default, comment out the following line to enable Lua support.
disable_lua = true; do return end;
```
> with
```
-- Lua is disabled by default, comment out the following line to enable Lua support.
-- disable_lua = true; do return end;
```
> (it can be already enabled on newer Wireshark versions).

> Then insert
```
dofile("packet-bnetp.lua")
```
> at the end of the file.

## Screenshots ##
Click on images to enlarge.

<a href='https://packet-bnetp.googlecode.com/svn/trunk/screenshots/bnetp_0x0f_channel_flags.png'><img src='https://packet-bnetp.googlecode.com/svn/trunk/screenshots/thumbs/bnetp_0x0f_channel_flags.jpg' /></a>
<a href='https://packet-bnetp.googlecode.com/svn/trunk/screenshots/bnetp_0x0f_user_flags.png'><img src='https://packet-bnetp.googlecode.com/svn/trunk/screenshots/thumbs/bnetp_0x0f_user_flags.jpg' /></a>
<a href='https://packet-bnetp.googlecode.com/svn/trunk/screenshots/bnetp_0x50.png'><img src='https://packet-bnetp.googlecode.com/svn/trunk/screenshots/thumbs/bnetp_0x50.jpg' /></a>

## Understanding protocol ##
Here is [the protocol documentation](http://bnetdocs.org/) which was used for creating packet-bnetp.