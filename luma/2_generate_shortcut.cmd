@echo off
setlocal EnableDelayedExpansion

if not exist steam_path.txt (
    echo steam_path.txt not found. Run get_steam_dir.cmd first.
    goto :exit
)
set /p STEAM_PATH=<%~dp0steam_path.txt

set "STEAM_EXE=%STEAM_PATH%\steam.exe"
set "GREENLUMA_DIR=%~dp0"
set "LAUNCHER_PATH=%GREENLUMA_DIR%\launcher.cmd"
set "SHORTCUT_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs"
set "SHORTCUT_NAME=Steam (GreenLuma).lnk"
set "SHORTCUT_PATH=%SHORTCUT_DIR%\%SHORTCUT_NAME%"

powershell -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%SHORTCUT_PATH%');$s.TargetPath='%LAUNCHER_PATH%';$s.WorkingDirectory='%GREENLUMA_DIR%';$s.IconLocation='%STEAM_EXE%';$s.Save()"

echo Steam dir: "%STEAM_PATH%" 
echo GreenLuma dir: "%GREENLUMA_DIR%"
echo Shortcut installed in "%SHORTCUT_PATH%"
echo You can now find "%SHORTCUT_NAME%" in your Start Menu.

:exit
pause
