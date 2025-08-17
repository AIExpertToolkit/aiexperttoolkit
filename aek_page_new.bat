@echo off
setlocal
if "%~1"=="" (
  echo Usage: %~nx0 slug "Title"
  exit /b 1
)
set "slug=%~1"
set "title=%~2"
if "%title%"=="" set "title=%slug%"
set "fname=%slug%.html"
> "%fname%" echo ---
>>"%fname%" echo layout: default
>>"%fname%" echo title: %title%
>>"%fname%" echo permalink: /%slug%.html
>>"%fname%" echo ---
>>"%fname%" echo ^<section class="section"^>
>>"%fname%" echo   ^<div class="wrap"^>
>>"%fname%" echo     ^<h1^>%title%^</h1^>
>>"%fname%" echo     ^<p class="muted"^>Coming soon.^</p^>
>>"%fname%" echo   ^</div^>
>>"%fname%" echo ^</section^>
git add "%fname%"
git commit -m "feat(page): add %slug%"
git push
endlocal
