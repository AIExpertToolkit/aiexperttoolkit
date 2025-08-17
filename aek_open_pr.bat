@echo off
setlocal
set "owner=AIExpertToolkit"
set "repo=aiexperttoolkit"
for /f %%%%B in ('git rev-parse --abbrev-ref HEAD') do set "branch=%%%%B"
set "base=main"
set "url=https://github.com/%%owner%%/%%repo%%/compare/%%base%%...%%branch%%?expand=1"
start "" "%%url%%"
echo Opened: %%url%%
endlocal
