@echo off
mkdir %USERPROFILE%\wsl-init
copy /y wsl-init* %USERPROFILE%\wsl-init\
xcopy /y .\init %USERPROFILE%\wsl-init\init\
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\wsl-init.lnk');$s.TargetPath='%USERPROFILE%\wsl-init\wsl-init.vbs';$s.Save()"

pause