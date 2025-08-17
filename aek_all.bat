@echo off
setlocal
set "msg=%%*"
if "%%msg%%"=="" set "msg=chore: quick commit"
call aek_make_zip.bat
call aek_commit_push.bat %%msg%%
call aek_open_pr.bat
endlocal
