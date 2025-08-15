@echo off
setlocal ENABLEEXTENSIONS
setlocal ENABLEDELAYEDEXPANSION

:: Collect the whole commit message (all args)
set "MSG=%*"
if "%MSG%"=="" set "MSG=chore: site update"

:: Always run from repo root (this script lives in repo root)
pushd "%~dp0"

:: Fast-forward local first (safer history)
git pull --rebase

:: Stage everything
git add -A

:: Commit; if nothing to commit, continue without error
git commit -m "%MSG%"
if errorlevel 1 (
  echo No changes to commit or commit failed. Continuing to push...
) else (
  echo Commit created successfully.
)

:: Push to default upstream (origin/main)
git push

popd
endlocal
