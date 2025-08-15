@echo off
setlocal
git pull --ff-only || (echo [ERROR] Pull failed.& exit /b 1)
echo Up to date.
