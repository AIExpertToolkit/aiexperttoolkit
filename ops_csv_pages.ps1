param(
  [string]$Csv      = ".aetk\sample_pages.csv",
  [string]$OutDir   = "use-cases",
  [string]$SlugCol  = "slug",
  [string]$TitleCol = "title",
  [string]$BodyCol  = "body"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (!(Test-Path $Csv)) { throw "CSV not found: $Csv" }
if (!(Test-Path $OutDir)) { New-Item -ItemType Directory -Force $OutDir | Out-Null }

function Get-Slug([string]$s) {
  if ([string]::IsNullOrWhiteSpace($s)) { return $null }
  $s = $s.ToLowerInvariant()
  $s = [regex]::Replace($s,'[^a-z0-9]+','-').Trim('-')
  return $s
}

$rows = Import-Csv -Path $Csv
$made = 0
foreach ($r in $rows) {
  $title = $r.$TitleCol
  $slug  = if ($r.PSObject.Properties.Name -contains $SlugCol -and $r.$SlugCol) { $r.$SlugCol } else { Get-Slug $title }
  if ([string]::IsNullOrWhiteSpace($slug)) { continue }
  $body  = $r.$BodyCol

  $fm = @"
---
layout: default
title: $title
permalink: /$slug.html
---
"@

  $html = @"
<section class="section">
  <div class="wrap">
    <h1>$title</h1>
    <p class="muted">$body</p>
  </div>
</section>
"@

  $outFile = Join-Path $OutDir "$slug.html"
  Set-Content -Path $outFile -Encoding UTF8 -Value ($fm + $html)
  $made++
}

Write-Host "Generated $made page(s) in $OutDir"
