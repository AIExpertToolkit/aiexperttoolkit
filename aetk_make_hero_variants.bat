@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

set "ASSETS_ROOT=C:\AIExpertToolkit_Assets"
set "SRC=%ASSETS_ROOT%\_source"
set "OUT_HOME=%ASSETS_ROOT%\home"
set "WORK=%ASSETS_ROOT%\_working"

if not exist "%OUT_HOME%" mkdir "%OUT_HOME%"
if not exist "%WORK%" mkdir "%WORK%"

set "IN=%SRC%\hero-original.jpg"
if not exist "%IN%" (
  echo [ERROR] Missing input: %IN%
  echo Drop your original hero into: %SRC%\hero-original.jpg
  pause
  exit /b 1
)

set SIZES=1920 1600 1366 1200 960 768 640 480
for %%S in (%SIZES%) do (
  set "OUTFILE=%OUT_HOME%\hero-%%S.jpg"
  magick "%IN%" -filter Lanczos -resize %%Sx -unsharp 0x0.5+0.5+0.02 -quality 82 "%OUTFILE%"
  if errorlevel 1 (echo [ERROR] Resize %%S failed.& exit /b 1)
  echo Wrote %%S: "%OUTFILE%"
)

echo Copy these into your repo under assets\img\home\
echo hero-1920.jpg hero-1600.jpg hero-1366.jpg hero-1200.jpg hero-960.jpg hero-768.jpg hero-640.jpg hero-480.jpg
exit /b 0
