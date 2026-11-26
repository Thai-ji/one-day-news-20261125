# news-25 — THE WORLD IN ONE DAY (Wednesday 25 November 2026)

![competition](https://img.shields.io/badge/news--image-20261125-b02418)
![owner](https://img.shields.io/badge/owner-Thai--ji-1e4a74)
![repo](https://img.shields.io/badge/repo-one--day--news--20261125-2c6a4d)

A one-page, 1024×1024 newspaper front page for the make.fun `news-image-20261125`
competition: **35 stories, 7 regions, 15 fields**, with 13 original flat SVG
illustrations (3 large cards + 10 small cards), a world map with 13 numbered pins,
22 one-line briefs, a six-box stats strip and a DATE CHECK box.

## Files

| File | Purpose |
| --- | --- |
| `design.html` | The page. All CSS and all 13 SVG scenes are inline; no external fonts or images. |
| `render.ps1` | Renders `design.html` to `entry.png` with Microsoft Edge headless. |
| `main.ts` | Validates `entry.png` (PNG signature, IHDR size ≤1024×1024, ≤1,048,576 bytes) and copies it to `MAKEFUN_OUTPUT_DIR` (default `/output`). |
| `entry.png` | The rendered 1024×1024 submission image. |
| `LICENSE` | Repository licence. |

## Render

```powershell
.\render.ps1
```

If the machine's execution policy blocks local scripts:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\render.ps1
```

The script deletes the old `entry.png`, launches Edge with
`--headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1
--window-size=1024,1024 --screenshot=entry.png --virtual-time-budget=5000`
and waits for the PNG to land. Requires Microsoft Edge on Windows.

## Validate and copy the output

```powershell
$env:MAKEFUN_OUTPUT_DIR = "out"
node main.ts
```

`main.ts` prints the PNG dimensions and byte size, rejects anything larger than
1024×1024 or 1,048,576 bytes, and writes the accepted file to the output
directory as `entry.png`.

## Layout

1. Kicker — `THE WORLD IN ONE DAY` / `35 STORIES · 7 REGIONS · 15 FIELDS`
2. Masthead — `WEDNESDAY 25 NOVEMBER 2026` (68 px, the largest element)
3. Italic subhead — the three lead stories in one sentence
4. Stats strip — six real numbers from the fact sheet
5. Region strip — seven proportional colour segments, 35 stories total
6. Three large cards — Hormuz tanker, Solomon Islands treaty, Bangladesh garment pay
7. Two rows of five small cards — Estonia border, Taiwan stocks, CIA cyberattack,
   Hodeidah, DR Congo cobalt, UN women, Mississippi crash, Russian ships,
   Indonesian mine, Cuba life expectancy
8. Map band — dotted Natural Earth 110m world map with pins 1–13 plus `ALSO — STORIES 14–35`
9. DATE CHECK — four stories that are *not* 25 November
10. Footer — credibility legend and story count

## Sources and credibility

Every story and number comes from the fact sheet
`facts-20261125.md` (40 verified candidates, 7 regions). Each card carries its
source name and a credibility tag: CONFIRMED / OFFICIAL / REPORTED / CLAIM /
ONGOING. The three CONFIRMED cards are the three items whose original articles
were read end-to-end during collection.

The world map is generated from Natural Earth 110m land polygons (public domain)
and inlined as dots and SVG pins; the page needs no external assets.

The date is **Wednesday 25 November 2026** — checked against a calendar; the
fact sheet's "Tuesday" template line was wrong.
