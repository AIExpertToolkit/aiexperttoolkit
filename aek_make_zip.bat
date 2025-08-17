@echo off
setlocal
set "outdir=C:\AIExpertToolkit\.aetk"
if not exist "%%outdir%%" mkdir "%%outdir%%"
for /f %%%%I in ('powershell -NoProfile -Command "$ts=Get-Date -Format ''yyyyMMdd_HHmmss''; $ts"') do set "stamp=%%%%I"
set "zip=%%outdir%%\aetk_%%stamp%%.zip"
cd /d C:\AIExpertToolkit\aiexperttoolkit
powershell -NoProfile -Command "Compress-Archive -Force -Path * -DestinationPath '%%zip%%'"
echo Wrote "%%zip%%"
endlocal
