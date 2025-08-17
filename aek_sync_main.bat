@echo off
setlocal
for /f %%%%%%B in ('git rev-parse --abbrev-ref HEAD') do set "branch=%%%%%%B"
echo Current branch: %%branch%%
git fetch origin
git merge --no-edit origin/main
git status
endlocal
