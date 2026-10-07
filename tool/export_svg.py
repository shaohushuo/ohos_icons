#!/usr/bin/env python3
"""Export every HarmonyOS Symbol as a standalone, high-fidelity SVG file.

The website renders each "image" from the HMSymbol font; this script extracts
the exact glyph outlines and writes one filled SVG per icon, preserving the
original outline geometry (vector, resolution independent).

Usage:
  python3 tool/export_svg.py --meta tool/data/name_map_new.json \
      --font assets/fonts/HMSymbol.ttf --out tool/export/svg
"""

from __future__ import annotations

import argparse
import json
import pathlib

from fontTools.pens.svgPathPen import SVGPathPen
from fontTools.pens.transformPen import TransformPen
from fontTools.ttLib import TTFont

HEADER = (
    '<?xml version="1.0" encoding="UTF-8"?>\n'
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="{xmin} {ymin} {w} {h}" '
    'width="{w}" height="{h}"><path d="{d}" fill="black"/></svg>\n'
)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--meta", default="tool/data/name_map_new.json")
    parser.add_argument("--font", default="assets/fonts/HMSymbol.ttf")
    parser.add_argument("--out", default="tool/export/svg")
    args = parser.parse_args()

    with open(args.meta, encoding="utf-8") as fh:
        meta = json.load(fh)

    font = TTFont(args.font, lazy=True)
    glyf = font["glyf"]
    head = font["head"]
    upm = head.unitsPerEm
    pad = max(2, upm // 40)

    out = pathlib.Path(args.out)
    out.mkdir(parents=True, exist_ok=True)

    count = 0
    for icons in meta["data"].values():
        for icon in icons:
            name = icon["name"]
            codepoint = int(icon["unicode"], 16)
            glyph_name = font.getBestCmap().get(codepoint)
            if glyph_name is None:
                print(f"  skip {name}: no glyph for U+{codepoint:04X}")
                continue

            glyph = glyf[glyph_name]
            if glyph.numberOfContours == 0:
                print(f"  skip {name}: composite glyph")
                continue

            # Glyph space is y-up; SVG is y-down, so flip the Y axis.
            svg_pen = SVGPathPen(glyf)
            flipped = TransformPen(svg_pen, (1, 0, 0, -1, 0, 0))
            glyph.draw(flipped, glyf)
            d = svg_pen.getCommands()

            xmin, ymin = glyph.xMin - pad, -glyph.yMax - pad
            xmax, ymax = glyph.xMax + pad, -glyph.yMin + pad
            w, h = xmax - xmin, ymax - ymin

            (out / f"{name}.svg").write_text(
                HEADER.format(xmin=xmin, ymin=ymin, w=w, h=h, d=d),
                encoding="utf-8",
            )
            count += 1

    print(f"exported {count} SVGs to {out}")


if __name__ == "__main__":
    main()
