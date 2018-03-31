# WSL-init

Creates a simple framework for Windows Subsystem for Linux init capability using
a hidden console on Windows login.

This is a small adaptation of [`doig-u`'s](https://github.com/doig-u/wsl-init)
generalisation of [`bahamas10`'s original method][bahamas10]
for getting a persistent background `ssh-agent` for WSL.  WSL supports
background tasks now, but still doesn't allow for [startup
tasks](https://blogs.msdn.microsoft.com/commandline/2017/12/04/background-task-support-in-wsl/)
at the time of writing.

See [the original][bahamas10] for details about the persistent `ssh-agent` 
method (it may be that some of this is redundant with recent background task 
support but I haven't investigated). In any case, the main benefit of this is to
execute the contents of `init.d` on some trigger (e.g. as a startup application,
or a scheduled task).


## Install

In WSL, for example if you have a link to `C:\Users\<USER>` via `~/userprofile`
and you wish to install directly under the user profile:

	git clone https://github.com/corriander/wsl-init
	cd wsl-init
	bash install.sh ~/userprofile/wsl-init

Alternatively, `bash install.sh /mnt/c/Users/bob/wsl-init` is the explicit
form and naturally also works.

`install.sh` will prompt to create a shortcut in the user profile's startup
folder. Alternatively, `wsl-init.vbs` could be invoked by Windows task scheduler
or some other trigger.


### Other install methods

Using `install.sh` from Git Bash isn't fully supported (`\c\...` type drive
notation hasn't been handled) but at a glance appears to work. `doig-u`'s method
should also still work as before:

> Download or clone repo, run the install.bat for install the scripts in your
> %USERPROFILE%\wsl-init dir and make a shortcut
> %USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start
> Menu\Programs\Startup\wsl-init.lnk for autostart.


### Uninstall

* Delete `%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\wsl-init.lnk`
  or whatever orchestration method was set up.
* Delete `wsl-init` directory and contents.


## Usage

`wsl-init.sh` is called by `wsl-init.bat` which is called by `wsl-init.vbs`;
this chain execs the contents of `init.d` via a persistent bash process so you
could start web servers, services, and so on.


### `ssh-agent` setup

`ssh-agent` is the example init script; it starts an ssh agent in the
background allowing keys to be added and retrieved without passphrases across
multiple bash sessions.


#### Attaching to the `ssh-agent` process

When the `ssh-agent` is started, its details are put in `~/.ssh/environment`.
These can be used to connect to it within a given session. Something like the
following will attach a bash session to the ssh-agent automatically on Ubuntu
login:

	echo ". ~/.ssh/environment" >> .profile

Put this wherever makes sense, bearing in mind that `.ssh/environment` could
potentially get stale or not exist.


#### Adding keys

The `AddKeysToAgent` directive can be used in `~/.ssh/config` to auto-add keys,
or `ssh-add` could just be called manually. Or something.


[bahamas10]: https://github.com/bahamas10/windows-bash-ssh-agent
