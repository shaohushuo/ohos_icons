> Template version: v0.0.1

<p align="center">
  <h1 align="center"> <code>harmony_icons</code> </h1>
</p>

[简体中文](README.OpenHarmony_CN.md) · [English](README.OpenHarmony.md) · [Changelog](CHANGELOG.OpenHarmony.md) · [Project README](README.md)

This project is a **zero-dependency** Flutter icon package for the OpenHarmony / HarmonyOS ecosystem. It bundles Huawei's official HM Symbol icon font with metadata for 534 icons. Every icon is exposed as a standard `IconData` constant. It runs on the OpenHarmony community Flutter fork [oh-flutter/flutter_flutter](https://atomgit.com/oh-flutter/flutter_flutter) and remains compatible with the official Flutter SDK.

- Icon & metadata source: Huawei Developer [HarmonyOS Symbol](https://developer.huawei.com/consumer/cn/design/harmonyos-symbol/) (currently shipping **HarmonyOS Symbol 2.3**)
- **534 unique icons** built in, covering 17 categories
- Pure Dart + font implementation: no platform channels, no plugins, no `ohos/` platform code

![harmony_icons gallery running on an OpenHarmony emulator](https://raw.gitcode.com/oh-flutter/harmony_icons/main/doc/ohos_screen_small.png)

## 1. Installation and Usage

### 1.1 Installation

#### Option 1: Install from pub.dev (recommended)

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  harmony_icons: ^0.1.0
```

Then run:

```bash
flutter pub get
```

The `HMSymbol` font is already declared in the package's own `pubspec.yaml`; no font configuration is required in your project.

#### Option 2: Install from AtomGit source

To track the latest repository code, use a git dependency:

```yaml
dependencies:
  harmony_icons:
    git:
      url: https://atomgit.com/oh-flutter/harmony_icons.git
      # The repository currently maintains the main branch; pin a release TAG
      # such as v0.1.0 once it is published.
      ref: main
```

```bash
flutter pub get
```

> TAG notes: this is an original library with no upstream project to adapt, so versions follow the semantic versions published on pub.dev (e.g. `v0.1.0`). It does not use `upstream-version-ohos-version` adaptation TAGs. Verified framework version and branch:

| Flutter Framework Version | TAG / Ref | Branch Name |
| :---: | :---: | :---: |
| 3.47.7-ohos-1.0.1 | `main` (pin `v0.1.0` after release) | main |

### 1.2 Usage

```dart
import 'package:flutter/material.dart';
import 'package:harmony_icons/harmony_icons.dart';

class IconDemo extends StatelessWidget {
  const IconDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      OhosIcons.airplane_fill,
      size: 48,
      color: Colors.blue,
    );
  }
}
```

A complete gallery (search, category filter, tap to copy icon name) is available at [example/lib/main.dart](example/lib/main.dart). On an OpenHarmony emulator, run it with:

```bash
./tool/run_ohos.sh
```

See section 6 for the run flow, environment variables, and manual build steps.

## 2. Constraints

### 2.1 Compatibility

Verified in the following environment:

| Item | Version / Notes |
| --- | --- |
| Flutter (OpenHarmony community fork) | [oh-flutter/flutter_flutter](https://atomgit.com/oh-flutter/flutter_flutter) `3.47.7-ohos-1.0.1` |
| DevEco Studio | 26.0.0 |
| OpenHarmony SDK | 26.0.0 |
| Device | OpenHarmony emulator (Phone) |
| Official Flutter SDK | stable channel in CI (`flutter analyze` and `flutter test`) |

The package contains no platform-specific code. Icons are rendered through Flutter's generic font + codepoint mechanism, so the library does not depend on any OpenHarmony system API level; platform compatibility is determined by the Flutter fork itself.

### 2.2 Permission Requirements

The library **requires no system permissions**.

The example app declares `ohos.permission.INTERNET` in `example/ohos/entry/src/main/module.json5` for debugging purposes only. It is not required by the icon library; integrating `harmony_icons` needs no permission declarations.

### 2.3 Usage Constraints

1. The bundled `HMSymbol` font must be used as-is. Do not override `IconData.fontPackage`, or icons will render as tofu boxes.
2. `Icon` always renders at Regular (`wght=400`). Use `Text` with a codepoint for other weights; see 5.1.
3. RTL mirror glyphs are not applied automatically. Select `mirrorIcon` based on `Directionality`; see 5.2.
4. Chinese labels, categories, and minimum system versions come from the official dataset and are not re-translated.

## 3. API

> [!TIP] **ohos Support = yes** means the capability is supported on OpenHarmony. Every API here is pure Dart and behaves identically across platforms.

| Name | Description | Type | Input | Output | ohos Support |
| --- | --- | --- | --- | --- | --- |
| `OhosIcons.<name>` | Icon constant, e.g. `OhosIcons.wifi` | `IconData` | / | `IconData` | yes |
| `OhosIcons.fontFamily` | Font family, fixed to `HMSymbol` | `String` | / | `HMSymbol` | yes |
| `OhosIcons.fontPackage` | Package name used to resolve the font asset | `String` | / | `harmony_icons` | yes |
| `OhosIcons.info` | Metadata indexed by English name | `Map<String, OhosIconMeta>` | / | metadata map | yes |
| `OhosIcons.values` | Iterate over all icon metadata | `Iterable<OhosIconMeta>` | / | metadata iterable | yes |
| `OhosIcons.names` | All icon names (ordered, unique) | `List<String>` | / | name list | yes |
| `OhosIcons.count` | Total icon count | `int` | / | `534` | yes |
| `OhosIcons.version` | Official icon data version | `String` | / | `2.3` | yes |
| `OhosIcons.categories` | All categories (sorted, deduplicated) | `List<String>` | / | category list | yes |
| `OhosIcons.fromName(name)` | Resolve an icon by English name | `IconData` | `String name` | `IconData` | yes |

`fromName` throws `ArgumentError` for unknown names. For data-driven scenarios, check `OhosIcons.info.containsKey(name)` first.

## 4. Properties

`OhosIconMeta` exposes the following fields, all usable on OpenHarmony:

| Field | Description | Type | Example | ohos Support |
| --- | --- | --- | --- | --- |
| `name` | Official English identifier | `String` | `airplane_fill` | yes |
| `label` | Official Chinese label | `String` | `飞行模式` | yes |
| `module` | Owning module | `String` | `状态栏` | yes |
| `categories` | Categories (may be multiple) | `List<String>` | `[系统UI]` | yes |
| `supportVersion` | Minimum HarmonyOS version | `String` | `HarmonyOS 5.0+` | yes |
| `codepoint` | Font codepoint | `int` | `0xF0113` | yes |
| `mirrorCodepoint` | RTL mirror codepoint, nullable | `int?` | `0xF0A02` | yes |
| `icon` | The icon's `IconData` | `IconData` | / | yes |
| `mirrorIcon` | Mirror variant, `null` when unavailable | `IconData?` | / | yes |

## 5. Known Issues

### 5.1 `Icon` does not support variable font weights

The bundled font keeps the `wght` axis (40–900), but Flutter's `Icon` widget does not support `fontVariations` and always renders Regular (400). To use another weight, render the codepoint with `Text`:

```dart
Text(
  String.fromCharCode(OhosIcons.info['wifi']!.codepoint),
  style: const TextStyle(
    fontFamily: 'HMSymbol',
    fontSize: 48,
    color: Colors.black,
    fontVariations: [FontVariation('wght', 700)],
  ),
)
```

### 5.2 RTL mirror variants require manual selection

Some icons provide an RTL mirror glyph, but Flutter does not swap icons based on text direction:

```dart
final meta = OhosIcons.info['airplane_fill']!;
final icon = Directionality.of(context) == TextDirection.rtl
    ? (meta.mirrorIcon ?? meta.icon)
    : meta.icon;
```

### 5.3 Icon count differs from the official site

The official category page lists 579 entries because some icons appear in multiple categories (e.g. `wifi` belongs to both "系统UI" and "连接"). This package deduplicates by English name, yielding **534 unique icons**.

### 5.4 `flutter run` requires signing

On the ohos fork, `flutter run` requires DevEco auto-signing (a Huawei account). The OpenHarmony emulator accepts unsigned debug HAPs, so `tool/run_ohos.sh` builds, installs, and launches the app without signing. For hot reload or debugging, open `example/ohos` in DevEco Studio, enable Signing Configs auto-signing, and then use `flutter run`.

## 6. Others

### 6.1 Running the example on OpenHarmony

The build uses the toolchain bundled with DevEco Studio (ohpm, node, hvigor, hdc, etc.). Example for the default macOS install path:

```bash
export DEVECO_SDK_HOME=/Applications/DevEco-Studio.app/Contents/sdk
export JAVA_HOME=/Applications/DevEco-Studio.app/Contents/jbr/Contents/Home
export PATH=/Applications/DevEco-Studio.app/Contents/tools/ohpm/bin:$PATH
export PATH=/Applications/DevEco-Studio.app/Contents/tools/node/bin:$PATH
export PATH=/Applications/DevEco-Studio.app/Contents/tools/hvigor/bin:$PATH

./tool/run_ohos.sh              # default device
./tool/run_ohos.sh <device-id>  # when multiple devices are connected
```

The script runs `flutter build hap --debug --no-codesign`, `hdc install -r`, and `hdc shell aa start` in sequence; no Huawei account login is needed. Override defaults with `DEVECO_APP`, `OHOS_SDK`, `HDC`, or `BUNDLE_NAME`.

### 6.2 Regenerating icon data from the official site

Requires `python3`; subsetting and SVG export additionally require `fonttools`:

```bash
pip install fonttools

python3 tool/download_source.py   # download name_map_new.json + HMSymbol.ttf
python3 tool/subset_font.py       # subset the font -> assets/fonts/HMSymbol.ttf
python3 tool/generate_icons.py    # generate lib/src/harmony_icons.dart
python3 tool/export_svg.py        # (optional) export every icon as SVG
```

| Tool | Purpose |
| --- | --- |
| `tool/download_source.py` | Download icon metadata and font from the Huawei official site |
| `tool/subset_font.py` | Trim the official font to icon codepoints only (~360 KB) |
| `tool/generate_icons.py` | Generate constants and metadata (do not edit generated output) |
| `tool/export_svg.py` | Export high-fidelity SVG per icon |
| `tool/run_ohos.sh` | Build and run the example on an OpenHarmony device/emulator |

### 6.3 Repository Structure

```text
lib/
  harmony_icons.dart          # library entry
  src/harmony_icons.dart      # generated constants & metadata (do not edit)
assets/fonts/HMSymbol.ttf     # subset icon font
example/                      # gallery example
example/ohos/                 # OpenHarmony project shell (openable in DevEco Studio)
tool/                         # download / generate / export / run scripts
test/                         # consistency tests
README.OpenHarmony_CN.md      # Chinese platform docs
README.OpenHarmony.md         # this document
CHANGELOG.OpenHarmony.md      # OpenHarmony changelog
```

### 6.4 Tests and CI

```bash
flutter analyze
flutter test
```

CI runs format checks, static analysis, unit tests, and example analysis on every push and pull request. See [.github/workflows/ci.yml](.github/workflows/ci.yml).

### 6.5 Related Documents and Repositories

- Main project README (Chinese): [README.md](README.md)
- OpenHarmony Chinese docs: [README.OpenHarmony_CN.md](README.OpenHarmony_CN.md)
- OpenHarmony changelog: [CHANGELOG.OpenHarmony.md](CHANGELOG.OpenHarmony.md)
- AtomGit repository: [oh-flutter/harmony_icons](https://atomgit.com/oh-flutter/harmony_icons)
- pub.dev package: [pub.dev/packages/harmony_icons](https://pub.dev/packages/harmony_icons)
- OpenHarmony Flutter fork: [oh-flutter/flutter_flutter](https://atomgit.com/oh-flutter/flutter_flutter)
- Huawei HarmonyOS Symbol: [developer.huawei.com](https://developer.huawei.com/consumer/cn/design/harmonyos-symbol/)

## 7. License

- Dart code and tooling scripts: MIT, see [LICENSE](LICENSE)
- The `HM Symbol` font and icon metadata come from the Huawei Developer "HarmonyOS Symbol" page (free download) and are intended for use in HarmonyOS-ecosystem app UIs. The font assets are **not covered by MIT**; see the note at the end of [LICENSE](LICENSE).
