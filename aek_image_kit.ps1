param(
  [string]$In      = "$env:USERPROFILE\Dropbox\AIExpertToolkit\ImageKit\Incoming",
  [string]$OutRoot = "$PWD\.aetk\imgkit",
  [switch]$WebP
)

$ErrorActionPreference = "Stop"
$stamp  = Get-Date -Format "yyyyMMdd_HHmmss"
$outdir = Join-Path $OutRoot $stamp
New-Item -ItemType Directory -Force -Path $outdir | Out-Null

$manifest = Join-Path $outdir 'manifest.csv'
'original,basename,width,format,output' | Out-File $manifest -Encoding UTF8

# Common responsive widths you already use on the site
$widths = 480,640,768,960,1200,1600,1920

# Helper to slugify filenames
function Get-SafeBase([string]$name) {
  $base = [IO.Path]::GetFileNameWithoutExtension($name)
  $base = $base -replace '[^\w\-]+','-'
  return $base.ToLower()
}

# Process each image
$images = Get-ChildItem -Path $In -File -Include *.jpg,*.jpeg,*.png
if (-not $images) {
  Write-Host "No images found in: $In" -ForegroundColor Yellow
  exit 0
}

foreach ($img in $images) {
  $base = Get-SafeBase $img.Name
  foreach ($w in $widths) {
    $jpg = Join-Path $outdir "$base-$w.jpg"
    & magick "$($img.FullName)" -auto-orient -strip -filter Lanczos -resize "${w}x>" -quality 82 "$jpg"
    "$($img.Name),$base,$w,jpg,$jpg" | Out-File $manifest -Append -Encoding UTF8

    if ($WebP) {
      $webp = Join-Path $outdir "$base-$w.webp"
      & magick "$($img.FullName)" -auto-orient -strip -filter Lanczos -resize "${w}x>" -quality 82 "$webp"
      "$($img.Name),$base,$w,webp,$webp" | Out-File $manifest -Append -Encoding UTF8
    }
  }
}

# Zip the delivery
New-Item -ItemType Directory -Force -Path $OutRoot | Out-Null
$zip = Join-Path $OutRoot "imagekit_$stamp.zip"
Compress-Archive -Path (Join-Path $outdir '*') -DestinationPath $zip -Force

Write-Host ""
Write-Host "DONE ✔" -ForegroundColor Green
Write-Host "Output folder: $outdir"
Write-Host "Manifest:     $manifest"
Write-Host "ZIP:          $zip"