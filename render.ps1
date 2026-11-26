# Render design.html to a 1024x1024 PNG with headless Edge.
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$design = Join-Path $root 'design.html'
$out = Join-Path $root 'entry.png'

$edge = 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
if (-not (Test-Path $edge)) { $edge = 'C:\Program Files\Microsoft\Edge\Application\msedge.exe' }
if (-not (Test-Path $edge)) { throw 'Microsoft Edge was not found in either Program Files path.' }
if (-not (Test-Path $design)) { throw "Missing design file: $design" }

if (Test-Path $out) { Remove-Item $out -Force }

$uri = [System.Uri]::new($design).AbsoluteUri
& $edge --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 --window-size=1024,1024 "--screenshot=$out" --virtual-time-budget=5000 $uri | Out-Null

# Edge returns before the renderer flushes the PNG, so wait for the file to land.
$deadline = (Get-Date).AddSeconds(20)
while (-not (Test-Path $out) -and (Get-Date) -lt $deadline) { Start-Sleep -Milliseconds 250 }
Start-Sleep -Milliseconds 400

if (-not (Test-Path $out)) { throw 'Screenshot was not created.' }
$item = Get-Item $out
Write-Output ("entry.png: {0} bytes" -f $item.Length)
