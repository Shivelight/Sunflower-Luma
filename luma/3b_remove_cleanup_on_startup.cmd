@echo off

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

set TASK_NAME=RemoveLumaStealthOnStartup

schtasks /query /tn "%TASK_NAME%" >nul 2>&1
if ERRORLEVEL==1 (
    echo Task "%TASK_NAME%" does not exist.
    goto :exit
)

schtasks /delete /tn "%TASK_NAME%" /f

if ERRORLEVEL==0 (
    echo Task "%TASK_NAME%" removed successfully.
) else (
    echo Failed to remove task "%TASK_NAME%".
)

:exit
pause
