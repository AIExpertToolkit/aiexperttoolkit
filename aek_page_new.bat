@echo off
setlocal
set "slug=%%~1"
set "title=%%~2"
if "%%slug%%"=="" set /p slug=Enter slug (no spaces): 
if "%%title%%"=="" set /p title=Enter title: 
set "fname=%%slug%%.html"
( 
--- 
layout: default
title: %%title%%
description: TODO
permalink: /%%slug%%.html
---
ECHO is off.
<section class="section">
  <div class="wrap">
    <h1>%%title%%</h1>
    <p class="muted">Coming soon.</p>
  </div>
</section>
echo Wrote %%fname%%
git add "%%fname%%"
git commit -m "feat(page): add %%slug%%"
git push
endlocal
