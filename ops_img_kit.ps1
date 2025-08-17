param(
  [string]$In = "assets\img\incoming",
  [string]$OutRoot = ".aetk\out\imgkit",
  [int[]]$Widths = @(480,640,768,960,1200,1280,1600,1920),
  [int]$Quality = 85
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (!(Test-Path $In)) { throw "Input folder not found: $In" }
Add-Type -AssemblyName System.Drawing

$stamp   = Get-Date -Format "yyyyMMdd_HHmmss"
$outDir  = Join-Path $OutRoot $stamp
New-Item -ItemType Directory -Force $outDir | Out-Null

$jpegCodec  = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | ? { $_.MimeType -eq 'image/jpeg' }
$encParams  = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [int64]$Quality)

$manifest = @()

Get-ChildItem -Path $In -Recurse -Include *.jpg,*.jpeg,*.png | ForEach-Object {
  $src = $_.FullName
  $img = [System.Drawing.Image]::FromFile($src)
  try {
    $base = [IO.Path]::GetFileNameWithoutExtension($_.Name)
    $origCopy = Join-Path $outDir "$base-original.jpg"
    $img.Save($origCopy, $jpegCodec, $encParams)
    $manifest += [pscustomobject]@{ source=$src; output=$origCopy; width=$img.Width; height=$img.Height }

    foreach ($w in $Widths) {
      if ($img.Width -le $w) { continue }
      $h   = [int][math]::Round($img.Height * ($w / $img.Width))
      $bmp = New-Object System.Drawing.Bitmap($w,$h)
      $g   = [System.Drawing.Graphics]::FromImage($bmp)
      try {
        $g.InterpolationMode  = "HighQualityBicubic"
        $g.CompositingQuality = "HighQuality"
        $g.SmoothingMode      = "HighQuality"
        $g.DrawImage($img, 0,0,$w,$h)
      } finally { $g.Dispose() }

      $outFile = Join-Path $outDir "$base-$w.jpg"
      $bmp.Save($outFile, $jpegCodec, $encParams)
      $bmp.Dispose()
      $manifest += [pscustomobject]@{ source=$src; output=$outFile; width=$w; height=$h }
    }
  } finally {
    $img.Dispose()
  }
}

$csv = Join-Path $outDir "manifest.csv"
$manifest | Export-Csv -NoTypeInformation -Path $csv -Encoding UTF8
Write-Host "Image kit ready:" $outDir
