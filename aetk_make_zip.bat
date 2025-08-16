@echo off
setlocal
REM AETK — One-click full repo zip for ChatGPT analysis (tar-based; excludes .git, _site, node_modules, vendor, .cache)

REM Resolve repo root to this script’s folder
set "ROOT=%~dp0"
for %%I in ("%ROOT%") do set "ROOT=%%~fI"

REM Export folder on Desktop
set "EXPORT=%USERPROFILE%\Desktop\AETK_Zips"
if not exist "%EXPORT%" mkdir "%EXPORT%"

REM Timestamp (yyyyMMdd-HHmmss)
for /f %%t in ('powershell -NoProfile -Command "(Get-Date).ToString(\"yyyyMMdd-HHmmss\")"') do set "TS=%%t"

set "ZIP=%EXPORT%\AETK-%TS%.zip"
echo Creating: "%ZIP%"

pushd "%ROOT%"
tar -a -c -f "%ZIP%" --exclude=.git --exclude=_site --exclude=node_modules --exclude=vendor --exclude=.cache .
popd

if not exist "%ZIP%" (
  echo [X] Failed to create zip.
  exit /b 1
)

start "" "%EXPORT%"
echo Created: "%ZIP%"
echo (Drag-and-drop this zip into ChatGPT.)
exit /b 0
