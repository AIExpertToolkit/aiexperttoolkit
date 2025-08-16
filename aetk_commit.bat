@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem --- 1) Ensure we’re in the repo root ---
pushd %~dp0

rem --- 2) Figure out branch name (or default to main) ---
for /f "tokens=*" %%b in ('git rev-parse --abbrev-ref HEAD 2^>NUL') do set BR=%%b
if not defined BR set BR=main

rem --- 3) Get commit message (support special chars) ---
set "MSG=%*"
if not defined MSG set "MSG=chore: quick update"

echo.
echo Branch: !BR!
echo Message: !MSG!
echo.

rem --- 4) Stage everything ---
git add -A

rem --- Safety: if sitemap.xml was ever tracked, ensure it’s removed ---
git rm -f --ignore-unmatch sitemap.xml >NUL 2>&1

rem --- 5) Commit only if there are staged changes ---
git diff --cached --quiet
if errorlevel 1 (
  git commit -m "!MSG!"
) else (
  echo No staged changes to commit.
)

rem --- 6) Push to same branch (sets upstream on first push) ---
git push -u origin !BR!

echo.
if /I "!BR!"=="main" (
  echo ✅  Pushed directly to main.
) else (
  echo ✅  Pushed branch: !BR!
  echo 🔗  Open PR (if needed): https://github.com/AIExpertToolkit/aiexperttoolkit/pull/new/!BR!
)

echo Done.
pause
endlocal
