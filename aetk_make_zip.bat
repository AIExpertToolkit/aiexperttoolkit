@echo off
setlocal
REM AETK — One-click full repo zip for ChatGPT analysis (excludes .git, _site, node_modules, vendor, .cache)

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

REM Create the zip using a single-line PowerShell call (no line continuations)
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$r='%ROOT%'.TrimEnd('\'); $z='%ZIP%';" ^
  "if (Test-Path $z) { Remove-Item $z -Force };" ^
  "$items = Get-ChildItem -LiteralPath $r -Recurse -Force | Where-Object { $_.FullName -notmatch '\\\.git\\|\\node_modules\\|\\vendor\\|\\_site\\|\\\.cache\\' };" ^
  "if (-not $items -or $items.Count -eq 0) { throw 'No files found to zip' };" ^
  "Compress-Archive -Path ($items | Select-Object -ExpandProperty FullName) -DestinationPath $z -Force"

if not exist "%ZIP%" (
  echo [X] Failed to create zip.
  exit /b 1
)

REM Copy path to clipboard and open folder (done separately to avoid quotes/escaping issues)
powershell -NoProfile -Command "Set-Clipboard -Value '%ZIP%'"
start "" "%EXPORT%"

echo Created: "%ZIP%"
echo (Path copied to clipboard. Drag-and-drop it into this chat.)
exit /b 0
