@echo off
setlocal EnableDelayedExpansion

if not exist steam_path.txt (
    echo steam_path.txt not found. Run get_steam_dir.cmd first.
    pause
    goto :eof
)
set /p STEAM_PATH=<%~dp0steam_path.txt

for /F %%x IN ('tasklist /NH /FI "IMAGENAME eq steam.exe"') do if %%x == steam.exe (
  echo Steam is already running
  choice /C YN /M "Do you want to kill Steam and continue?"
  if %ERRORLEVEL%==2 exit
  taskkill /F /IM steam.exe
  echo Waiting for previous launch to cleanup...
  rem TODO: check wscript process
  timeout /t 5 /nobreak >nul
)

echo Steam dir: "%STEAM_PATH%" 
echo GreenLuma dir: "%~dp0"
echo Copying GreenLuma (Stealth) to Steam directory
copy /Y "%~dp0user32SF.dll" "%STEAM_PATH%\user32.dll"

choice /C YN /M "Run DeleteSteamAppCache? (Run if games or DLC stop being unlocked)"
if %ERRORLEVEL%==1 (start "" "%~dp0DeleteSteamAppCache.exe")

choice /C YN /M "Refresh AppList? (Refresh if you installed a new games or DLC)"
if %ERRORLEVEL%==1 (start "" "%~dp0sunflower-luma.exe")

echo Launching Steam with GreenLuma...

set "VBS_SCRIPT=%~dp0vbs_script.vbs"
(
  echo Set WshShell = CreateObject("WScript.Shell"^)
  echo Set FSO = CreateObject("Scripting.FileSystemObject"^)
  
  echo SteamPath = "%STEAM_PATH%\steam.exe"
  echo DllPath = "%STEAM_PATH%\user32.dll"
  echo WshShell.Run chr(34^) ^& SteamPath ^& chr(34^), 1, True

  echo ' Cleanup
  echo If FSO.FileExists(DllPath^) Then
  echo  FSO.DeleteFile DllPath
  echo End If

  echo ' Delete self
  echo Set F = FSO.GetFile(WScript.ScriptFullName^)
  echo F.Delete
) > %VBS_SCRIPT%

start "" wscript.exe "%VBS_SCRIPT%"
timeout /t 5 /nobreak >nul

