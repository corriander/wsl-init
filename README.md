# WSL-init

For Windows 10 WSL, makes hidden bash init process with auto-runned init\\* scripts (like ssh-agent for default).

Based on that idea: https://github.com/bahamas10/windows-bash-ssh-agent

## Install
Download or clone repo, run the install.bat for install the scripts in your %USERPROFILE%\wsl-init dir and make a shortcut %USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\wsl-init.lnk for autostart.

## Use
Put your linux scripts inside init folder, wsl-init.sh will auto exec them due a next boot (or run wsl-init.sh manual).

## Remove
* Del %USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\wsl-init.lnk
* Del %USERPROFILE%\wsl-init
* If you use init/ssh-agent script, remove the line ". $HOME/.ssh/environment" ($HOME is your homedir) from the ~/.bashrc file.
