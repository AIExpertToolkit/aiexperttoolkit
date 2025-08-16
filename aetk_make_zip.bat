@echo off
setlocal ENABLEDELAYEDEXPANSION
chcp 65001 >nul

REM AETK — One-click full repo zip for ChatGPT analysis (excludes .git, _site, node_modules, vendor, .cache)
REM Usage: double-click this file, or run from Command Prompt at the repo root.

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
REM Use PowerShell to gather files and compress with excludes
powershell -NoProfile -Command ^
  "$r='%ROOT%'.TrimEnd('\'); $z='%ZIP%';" ^
  "if (Test-Path $z) { Remove-Item $z -Force };" ^
  "$items = Get-ChildItem -LiteralPath $r -Recurse -Force | Where-Object { $_.FullName -notmatch '\\\.git\\|\\node_modules\\|\\vendor\\|\\_site\\|\\\.cache\\' };" ^
  "$paths = $items | Select-Object -ExpandProperty FullName;" ^
  "if($paths.Count -eq 0){ throw 'No files found to zip' };" ^
  "Compress-Archive -Path $paths -DestinationPath $z -Force"

if exist "%ZIP%" (
  echo Created: "%ZIP%"
  powershell -NoProfile -Command "Set-Clipboard -Value '%ZIP%'; Start-Process explorer.exe '%EXPORT%';"
  echo.
  echo ✅ Zip path copied to clipboard. Drag-and-drop it into ChatGPT.
  echo    (If Explorer opened, the newest zip is already selected.)
  exit /b 0
) else (
  echo [X] Failed to create zip at "%ZIP%"
  exit /b 1
)

endlocal
