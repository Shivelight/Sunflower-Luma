@echo off

net session >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

rem need to restore working directory after elevating (it defaults to C:\Windows\System32 i think)
rem cd /d "%~dp0"

if not exist %~dp0steam_path.txt (
    echo steam_path.txt not found. Run get_steam_dir.cmd first.
    goto :exit
)
set /p STEAM_PATH=<%~dp0steam_path.txt

set TASK_NAME=RemoveLumaStealthOnStartup
set "FILE_TO_DELETE=%STEAM_PATH%\user32.dll"

schtasks /create ^
  /tn "%TASK_NAME%" ^
  /tr "cmd /c del /f /q \"%FILE_TO_DELETE%\"" ^
  /sc onstart ^
  /ru SYSTEM ^
  /rl HIGHEST ^
  /f

echo Task "%TASK_NAME%" created successfully.

:exit
pause
