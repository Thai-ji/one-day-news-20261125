# The World Today — Wednesday 25 November 2026

[![make.fun news image](https://make.fun/badge/news-image-20261125.svg)](https://make.fun/bounty/news-image-20261125)
[![rank](https://make.fun/badge/news-image-20261125/Thai-ji/one-day-news-20261125/rank.svg)](https://make.fun/bounty/news-image-20261125)
[![reward](https://make.fun/badge/news-image-20261125/Thai-ji/one-day-news-20261125/reward.svg)](https://make.fun/bounty/news-image-20261125)

A one-page newspaper image summing up the world news of Wednesday 25 November 2026. Every story is an event of that day, or was first reported on that day; the date-check bar states that scope.

The page carries 35 stories from seven regions: three illustrated leads, twelve illustrated cards and twenty one-line briefs, plus a five-number strip and a dotted world map with fifteen pins.

## Files

- `design.html` — the page, all styling and inline SVG artwork.
- `entry.png` — the rendered 1024 × 1024 PNG entry.
- `render.ps1` — renders `design.html` to `entry.png` with headless Microsoft Edge.
- `main.ts` — validates the PNG and copies it to `MAKEFUN_OUTPUT_DIR` (default `/output`).
- `LICENSE` — MIT.

## Build and check

```powershell
pwsh -File .\render.ps1
mkdir out
$env:MAKEFUN_OUTPUT_DIR = "out"
node main.ts
```

`main.ts` checks the PNG signature, IHDR dimensions (at most 1024 × 1024) and the 1 MiB cap, then copies the file. It uses only the Node standard library and runs on Node 22.18 or later.

## Sources

The edition is compiled from the supplied 25 November 2026 facts sheet; each story carries its outlet abbreviation in the page (`ATLAS360`, `CNA`, `DAWN`, `MEDUZA`, `SCMP`, `MEE`, `EURONEWS`, `RIO TIMES`, `PREMIUM TIMES`, and others). The page does not add facts beyond that sheet.
