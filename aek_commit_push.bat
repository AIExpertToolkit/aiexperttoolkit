@echo off
cd /d C:\AIExpertToolkit\aiexperttoolkit
set msg=%%*
if "%%msg%%"=="" set msg=chore: quick commit
git add -A
git commit -m "%%msg%%"
git push -u origin HEAD
git status
