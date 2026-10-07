#!/usr/bin/env python3
"""Download the HarmonyOS Symbol icon data and font from Huawei's website.

Sources (reverse-engineered from the HarmonyOS Symbol gallery page):
  https://developer.huawei.com/consumer/cn/design/harmonyos-symbol/

Assets live under:
  /allianceCmsResource/resource/HUAWEI_Developer_VUE/template/resources/hm-symbol/

The page loads:
  * data_versions.json      - list of symbol versions
  * name_map_new.json       - icon metadata (names, codepoints, categories)
  * layer_config.json       - layer/animation config (not needed for the icon font)
  * HMSymbol.ttf            - the icon font itself

Usage:
  python3 tool/download_source.py [--out tool/data]
"""

from __future__ import annotations

import argparse
import json
import pathlib
import urllib.request

BASE_URL = (
    "https://developer.huawei.com/allianceCmsResource/resource/"
    "HUAWEI_Developer_VUE/template/resources/hm-symbol/"
)

FILES = (
    "data_versions.json",
    "name_map_new.json",
    "layer_config.json",
    "HMSymbol.ttf",
)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--out", default="tool/data", help="output directory")
    args = parser.parse_args()

    out_dir = pathlib.Path(args.out)
    out_dir.mkdir(parents=True, exist_ok=True)

    for name in FILES:
        url = BASE_URL + name
        target = out_dir / name
        print(f"downloading {url} -> {target}")
        with urllib.request.urlopen(url) as resp, open(target, "wb") as fh:
            fh.write(resp.read())

        if name.endswith(".json"):
            with open(target, encoding="utf-8") as fh:
                data = json.load(fh)
            if isinstance(data, dict) and "data" in data:
                print(
                    f"  version: {data.get('version')}, "
                    f"icons: {sum(len(v) for v in data['data'].values())}"
                )
            else:
                print(
                    f"  loaded json: {data[:3]!r}"
                    if isinstance(data, list)
                    else "  loaded json"
                )
        else:
            print(f"  saved {target.stat().st_size} bytes")


if __name__ == "__main__":
    main()
