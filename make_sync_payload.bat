@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

REM --- paths (edit if needed) ---
set CFG=_config.yml
set LYT=_layouts\default.html
set INC=_includes\header.html
set CSS=assets\css\base.css
if not exist "%CSS%" set CSS=assets\base.css
set IDX=index.html

set OUT=sync_payload.txt
del "%OUT%" 2>nul

call :emit "=== BEGIN %CFG% ===" "%CFG%"
call :emit "=== BEGIN %LYT% ===" "%LYT%"
call :emit "=== BEGIN %INC% ===" "%INC%"
call :emit "=== BEGIN %CSS% ===" "%CSS%"
call :emit "=== BEGIN %IDX% ===" "%IDX%"

echo.>>"%OUT%"
echo === END SYNC PAYLOAD ===>>"%OUT%"

echo Created %OUT%. Open it and paste the contents here.
goto :eof

:emit
set "LABEL=%~1"
set "FILE=%~2"
echo %LABEL%>>"%OUT%"
if exist "%FILE%" (
  type "%FILE%" >>"%OUT%"
) else (
  echo [MISSING: %FILE%]>>"%OUT%"
)
echo.>>"%OUT%"
echo === END %FILE% ===>>"%OUT%"
echo.>>"%OUT%"
exit /b
