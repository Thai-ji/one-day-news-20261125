# Renders design.html to entry.png with Microsoft Edge headless.
# Usage: .\render.ps1
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$out  = Join-Path $root 'entry.png'
$html = Join-Path $root 'design.html'

if (-not (Test-Path $html)) { throw "design.html not found at $html" }

$edgeCandidates = @(
    'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe',
    'C:\Program Files\Microsoft\Edge\Application\msedge.exe',
    "$env:LOCALAPPDATA\Microsoft\Edge\Application\msedge.exe"
)
$edge = $edgeCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $edge) { throw 'Microsoft Edge not found (msedge.exe).' }

if (Test-Path $out) { Remove-Item $out -Force }

$url = 'file:///' + ($html -replace '\\', '/')

$edgeArgs = @(
    '--headless=new',
    '--disable-gpu',
    '--hide-scrollbars',
    '--force-device-scale-factor=1',
    '--window-size=1024,1024',
    "--screenshot=$out",
    '--virtual-time-budget=5000',
    $url
)
$proc = Start-Process -FilePath $edge -ArgumentList $edgeArgs -Wait -PassThru -WindowStyle Hidden

# Wait for the file to land (Edge writes it asynchronously).
$deadline = (Get-Date).AddSeconds(30)
while (-not (Test-Path $out) -and (Get-Date) -lt $deadline) {
    Start-Sleep -Milliseconds 250
}
if (-not (Test-Path $out)) { throw 'entry.png was not produced.' }
Start-Sleep -Milliseconds 300

$item = Get-Item $out
if ($item.Length -lt 10000) { throw "entry.png looks empty ($($item.Length) bytes)." }
Write-Host ("entry.png  {0:N0} bytes  {1}" -f $item.Length, $out)
