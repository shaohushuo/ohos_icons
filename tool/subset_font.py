#!/usr/bin/env python3
"""Subset the variable HMSymbol.ttf to only the codepoints used by the package.

The full font is ~4.2 MB and contains thousands of glyphs (variations, layers)
beyond the named symbols in name_map_new.json. This script keeps only the
codepoints referenced by the icon metadata (plus their RTL mirror codepoints),
which dramatically reduces the bundled font size while preserving the variable
wght axis.

Requires: pip install fonttools

Usage:
  python3 tool/subset_font.py \
      --meta tool/data/name_map_new.json \
      --font tool/data/HMSymbol.ttf \
      --out assets/fonts/HMSymbol.ttf
"""

from __future__ import annotations

import argparse
import json
import pathlib

from fontTools import subset
from fontTools.ttLib import TTFont


def collect_codepoints(meta_path: pathlib.Path) -> set[int]:
    with open(meta_path, encoding="utf-8") as fh:
        meta = json.load(fh)

    codepoints: set[int] = set()
    for icons in meta["data"].values():
        for icon in icons:
            codepoints.add(int(icon["unicode"], 16))
            mirror = icon.get("mirror_unicode")
            if mirror:
                codepoints.add(int(mirror, 16))
    return codepoints


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--meta", default="tool/data/name_map_new.json")
    parser.add_argument("--font", default="tool/data/HMSymbol.ttf")
    parser.add_argument("--out", default="assets/fonts/HMSymbol.ttf")
    args = parser.parse_args()

    codepoints = collect_codepoints(pathlib.Path(args.meta))
    print(f"subsetting to {len(codepoints)} codepoints")

    options = subset.Options()
    options.name_IDs = ["*"]
    options.name_legacy = True
    options.recalc_bounds = True
    options.drop_tables += ["FFTM"]
    options.variable_fonts = True

    font = TTFont(args.font)
    subsetter = subset.Subsetter(options=options)
    subsetter.populate(unicodes=codepoints)
    subsetter.subset(font)

    out = pathlib.Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    font.save(out)
    print(f"wrote {out} ({out.stat().st_size / 1024:.1f} KiB)")

    check = TTFont(out)
    cmap = check.getBestCmap()
    missing = codepoints - set(cmap)
    if missing:
        raise SystemExit(f"missing codepoints after subset: {sorted(hex(c) for c in missing)}")
    print(f"verified {len(cmap)} glyphs in cmap of subset font")


if __name__ == "__main__":
    main()
