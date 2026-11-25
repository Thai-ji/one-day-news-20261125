# Render design.html to entry.png with headless Microsoft Edge.
# Usage: pwsh -File .\render.ps1
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$candidates = @(
  'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe',
  'C:\Program Files\Microsoft\Edge\Application\msedge.exe'
)
$edge = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $edge) { throw 'Microsoft Edge not found.' }

$design = Join-Path $root 'design.html'
$out = Join-Path $root 'entry.png'
if (Test-Path $out) { Remove-Item $out -Force }
$url = 'file:///' + ($design -replace '\\', '/')

$args = @(
  '--headless=new','--disable-gpu','--hide-scrollbars','--force-device-scale-factor=1',
  '--window-size=1024,1024',"--screenshot=$out",'--virtual-time-budget=5000',$url
)
Start-Process -FilePath $edge -ArgumentList $args -Wait -NoNewWindow
for ($i = 0; $i -lt 50 -and -not (Test-Path $out); $i++) { Start-Sleep -Milliseconds 100 }
if (-not (Test-Path $out)) { throw 'Edge produced no screenshot.' }
$bytes = (Get-Item $out).Length
Write-Host "Rendered $out ($bytes bytes)"
