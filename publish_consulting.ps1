# publish_consulting.ps1 — adds Consulting to header, commits consulting pages, pushes a PR branch, opens it
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

# Ensure we're in a git repo
git rev-parse --is-inside-work-tree | Out-Null

# Work on a fresh branch from main
$branch = 'feat/consulting-publish'
git fetch --all --prune
git checkout -B $branch origin/main 2>$null; if ($LASTEXITCODE -ne 0) { git checkout -B $branch }

# 1) Ensure a Consulting link appears in the primary nav (once)
$headerPath = '_includes/header.html'
if (Test-Path $headerPath) {
  $h = Get-Content -Raw $headerPath

  if ($h -notmatch '/consulting\.html') {
    $li = '        <li><a href="{{ site.baseurl }}/consulting.html" class="nav-accent" {% if page.url contains ''/consulting'' %}aria-current="page"{% endif %}>Consulting</a></li>'

    if ($h -match '(?s)(<ul[^>]*class="[^"]*nav-list[^"]*"[^>]*>)(.*?)(</ul>)') {
      # Insert before the closing </ul> of the primary nav list
      $h = [regex]::Replace($h, '(?s)(<ul[^>]*class="[^"]*nav-list[^"]*"[^>]*>)(.*?)(</ul>)', {
        param($m) $m.Groups[1].Value + $m.Groups[2].Value + "`r`n" + $li + "`r`n" + $m.Groups[3].Value
      }, 1)
    }
    else {
      # Fallback: inject right before </nav> if no <ul.nav-list> was found
      $h = [regex]::Replace($h, '(?s)</nav>', $li + "`r`n" + '</nav>', 1)
    }

    Set-Content -Encoding utf8 -NoNewline $headerPath $h
  }
}
else {
  Write-Host "WARNING: $headerPath not found. Skipping nav insertion."
}

# 2) Stage your pages + header
git add consulting.html consulting-terms.html 2>$null
if (Test-Path $headerPath) { git add $headerPath }

# 3) Commit if there are staged changes
$staged = git diff --cached --name-only
if ([string]::IsNullOrWhiteSpace($staged)) {
  Write-Host "No changes to commit. (If you already committed, we’ll just push/open PR.)"
} else {
  git commit -m "feat(consulting): add consulting + terms pages; add header nav link"
}

# 4) Push branch & open PR
git push -u origin $branch
$origin = (git remote get-url origin) -replace '\.git$','' -replace '^git@github\.com:','https://github.com/'
$pr = "$origin/pull/new/$branch"
Write-Host "Open PR: $pr"
Start-Process $pr
