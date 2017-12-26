Dim WinScriptHost
Set WinScriptHost = CreateObject("WScript.Shell")
WinScriptHost.Run Chr(34) & "%userprofile%\wsl-init\wsl-init.bat" & Chr(34), 0
Set WinScriptHost = Nothing
