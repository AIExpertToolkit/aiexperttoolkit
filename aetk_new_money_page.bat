@echo off
setlocal
set "ROOT=C:\AIExpertToolkit\aiexperttoolkit"
cd /d "%ROOT%" || (echo repo missing && exit /b 1)

set /p SLUG=Enter slug (e.g., writesonic-review or jasper-vs-writesonic):
if "%SLUG%"=="" (echo slug required && exit /b 1)

set /p TYPE=Type (review/vs):
if /I "%TYPE%"=="vs" (set TITLE=%SLUG% & set ARTICLE=true) else (set TITLE=%SLUG% & set ARTICLE=true)

powershell -NoProfile -Command ^
  "$p='%SLUG%.html';" ^
  "$t='---`nlayout: default`npermalink: /%SLUG%.html`narticle: true`ntitle: %SLUG%`ndescription: TODO`n---`n`n<div class=""wrap"">`n  {% include breadcrumbs.html %}`n  {% include toc.html %}`n  <header class=""section"" style=""padding-top:8px"">`n    <h1>%SLUG%</h1>`n    <p class=""muted"">One-line promise.</p>`n    <p><a class=""btn"" href=""https://writesonic.com"" target=""_blank"" rel=""nofollow noopener"" data-aff=""true"">Try Writesonic Free →</a></p>`n  </header>`n</div>`n';" ^
  "Set-Content -Encoding utf8 $p $t"

echo Created %SLUG%.html
endlocal
