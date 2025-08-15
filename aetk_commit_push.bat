@echo off
setlocal enabledelayedexpansion

REM Collect the whole commit message (all args)
set "MSG=%*"
if "%MSG%"=="" set "MSG=chore: site update"

REM Always stay in repo root (script lives here)
pushd "%~dp0"

REM Fast-forward local first
git pull --rebase

REM Stage everything
git add -A

REM Commit (if nothing to commit, keep going)
git commit -m "%MSG%" || echo No changes to commit.

REM Push
git push

popd
endlocal
