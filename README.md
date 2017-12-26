Based on that idea: https://github.com/bahamas10/windows-bash-ssh-agent

Works on Windows 10.

Run the install.bat for install the scripts in your %USERPROFILE%\wsl-init dir and make a shortcut %USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\wsl-init.lnk for autostart.

Put your linux scripts inside init folder, wsl-init.sh will auto exec them due a next boot (or run wsl-init.sh manual).
