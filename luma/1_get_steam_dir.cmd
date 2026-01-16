@echo off

set OUTPUT_FILE=%~dp0steam_path.txt

rem Try 64-bit registry location first
for /f "tokens=2,*" %%A in (
    'reg query "HKLM\SOFTWARE\WOW6432Node\Valve\Steam" /v InstallPath 2^>nul ^| find "InstallPath"'
) do set STEAM_PATH=%%B

rem Fallback to 32-bit location
if not defined STEAM_PATH (
    for /f "tokens=2,*" %%A in (
        'reg query "HKLM\SOFTWARE\Valve\Steam" /v InstallPath 2^>nul ^| find "InstallPath"'
    ) do set STEAM_PATH=%%B
)

if not defined STEAM_PATH (
    echo Steam installation not found.
    exit /b 1
)

echo %STEAM_PATH%> "%OUTPUT_FILE%"
echo Found "%STEAM_PATH%"
echo Path saved to "%OUTPUT_FILE%"
pause
