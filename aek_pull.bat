@echo off
setlocal enabledelayedexpansion
echo > Pulling latest main...
git checkout main && git pull --ff-only
echo.
git status
endlocal
