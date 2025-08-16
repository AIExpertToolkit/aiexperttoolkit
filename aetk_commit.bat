@echo off
setlocal enabledelayedexpansion

:: --- 0) Go to your repo ---
cd /d C:\AIExpertToolkit\aiexperttoolkit

:: --- 1) Safety checks ---
where git >NUL 2>&1
if errorlevel 1 (
  echo ERROR: Git is not installed or not on PATH.
  pause
  exit /b 1
)

git rev-parse --is-inside-work-tree >NUL 2>&1
if errorlevel 1 (
  echo ERROR: This folder is not a Git repository.
  pause
  exit /b 1
)

:: --- 2) Figure out the current branch ---
for /f "delims=" %%B in ('git rev-parse --abbrev-ref HEAD') do set BR=%%B

:: --- 3) Get commit message from args or prompt ---
set MSG=%*
if "%MSG%"=="" (
  set /p MSG=Enter commit message (e.g., feat(seo): add breadcrumbs):
)
if "%MSG%"=="" set MSG=chore: quick update

echo.
echo Branch: %BR%
echo Message: %MSG%
echo.

:: --- 4) Stage everything (adds/mods/deletes) ---
git add -A

:: (One-time safety: if sitemap.xml was ever tracked, ensure it's removed)
git rm -f --ignore-unmatch sitemap.xml >NUL 2>&1

:: --- 5) Commit only if there are staged changes ---
git diff --cached --quiet
if %ERRORLEVEL%==0 (
  echo No staged changes to commit.
) else (
  git commit -m "%MSG%"
)

:: --- 6) Push to the same branch (set upstream on first push) ---
git push -u origin %BR%

echo.
if /I "%BR%"=="main" (
  echo ✅ Pushed directly to main.
) else (
  echo ✅ Pushed branch: %BR%
  echo Open PR (if needed): https://github.com/AIExpertToolkit/aiexperttoolkit/pull/new/%BR%
)
echo Done.
pause
endlocal
