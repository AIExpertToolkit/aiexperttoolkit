@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 > nul

REM --- output file (absolute path) ---
set "OUT=%CD%\sync_payload.txt"
del "%OUT%" 2>nul

call :emit "_config.yml"
call :emit "_layouts\default.html"
call :emit "_includes\header.html"
if exist "assets\css\base.css" ( call :emit "assets\css\base.css" ) else ( call :emit "assets\base.css" )
call :emit "index.html"

>>"%OUT%" echo === END SYNC PAYLOAD ===
echo Created: "%OUT%"
start "" notepad "%OUT%"
exit /b 0

:emit
set "F=%~1"
>>"%OUT%" echo === BEGIN %F% ===
if exist "%F%" (
  type "%F%" >>"%OUT%"
) else (
  >>"%OUT%" echo [MISSING: %F%]
)
>>"%OUT%" echo.
>>"%OUT%" echo === END %F% ===
>>"%OUT%" echo.
exit /b 0
