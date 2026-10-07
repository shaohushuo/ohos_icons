# ohos_icons

[![pub package](https://img.shields.io/pub/v/ohos_icons.svg)](https://pub.dev/packages/ohos_icons)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![CI](https://github.com/shaohushuo/ohos_icons/actions/workflows/ci.yml/badge.svg)](https://github.com/shaohushuo/ohos_icons/actions/workflows/ci.yml)

HarmonyOS Symbol 图标库 for Flutter，用法与 [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) 一致：内置华为官方 **HM Symbol** 图标字体，每个图标对应一个 `IconData` 常量，开箱即用。

- 图标与元数据来源：华为开发者官网 [HarmonyOS Symbol](https://developer.huawei.com/consumer/cn/design/harmonyos-symbol/)（当前内置 **HarmonyOS Symbol 2.3**）
- 内置 **534 个唯一图标**，覆盖 17 个分类
- 面向鸿蒙生态：可直接运行在鸿蒙社区 Flutter 分叉 [CPF-Flutter/flutter_flutter](https://atomgit.com/CPF-Flutter/flutter_flutter) 上，也兼容官方 Flutter SDK

![ohos_icons gallery 运行在鸿蒙模拟器](https://cdn.jsdelivr.net/gh/shaohushuo/ohos_icons@main/doc/ohos_screen_small.png)

## 特性

- **`IconData` 常量**：`OhosIcons.airplane_fill`，与 Material Icons / cupertino_icons 相同的用法
- **富元数据**：每个图标带中文名、分类、所属模块、最低系统版本、码点、RTL 镜像码点
- **查询能力**：按名称动态取图标、按分类筛选、全量遍历（参考 font_awesome_flutter / fluent_ui 的包结构）
- **字体精简**：打包字体是官方 `HMSymbol.ttf` 的子集（约 360 KB），保留 `wght` 可变字重轴
- **零依赖**：仅依赖 `flutter` SDK，无平台相关代码

## 安装

```yaml
dependencies:
  ohos_icons: ^0.1.0
```

或命令行：

```bash
flutter pub add ohos_icons
```

## 快速开始

```dart
import 'package:flutter/material.dart';
import 'package:ohos_icons/ohos_icons.dart';

class Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(
          OhosIcons.airplane_fill,
          size: 48,
          color: Colors.blue,
        ),
      ),
    );
  }
}
```

`OhosIcons.<icon_name>` 中的 `icon_name` 使用官方的英文标识，如 `OhosIcons.battery_100percent`、`OhosIcons.person_2_fill`、`OhosIcons.wifi_6_badge_lock`。

## API 参考

### 常量

| 成员 | 说明 |
| --- | --- |
| `OhosIcons.<name>` | `IconData` 常量，直接给 `Icon` / `IconButton` 使用 |
| `OhosIcons.fontFamily` | 字体名，固定为 `HMSymbol` |
| `OhosIcons.fontPackage` | 包名 `ohos_icons`，跨包使用时自动生效 |

### 元数据

| 成员 | 说明 |
| --- | --- |
| `OhosIcons.info` | `Map<String, OhosIconMeta>`，按图标名查元数据 |
| `OhosIcons.values` | 全部 `OhosIconMeta` 的迭代器 |
| `OhosIcons.names` | 全部图标名（有序、唯一） |
| `OhosIcons.count` | 图标总数（534） |
| `OhosIcons.version` | 官方数据版本（2.3） |
| `OhosIcons.categories` | 全部分类（排序去重） |
| `OhosIcons.fromName(name)` | 按英文名动态获取 `IconData` |

### OhosIconMeta 字段

| 字段 | 说明 | 示例 |
| --- | --- | --- |
| `name` | 英文标识 | `airplane_fill` |
| `label` | 中文名 | `飞行模式` |
| `module` | 所属模块 | `状态栏` |
| `categories` | 所属分类 | `[系统UI]` |
| `supportVersion` | 最低系统版本 | `HarmonyOS 5.0+` |
| `codepoint` | 字体码点 | `0xF0113` |
| `mirrorCodepoint` | RTL 镜像码点（可为 null） | `0xF0A02` |
| `icon` | 该图标的 `IconData` | - |
| `mirrorIcon` | 镜像变体的 `IconData`（可为 null） | - |

## 使用教程

### 1. 动态获取图标（按名称）

数据驱动场景（如服务端下发图标名）可用 `fromName`：

```dart
Icon(
  OhosIcons.fromName(name),
  size: 32,
);
```

名称不存在时抛出 `ArgumentError`；先用 `OhosIcons.info.containsKey(name)` 判断更稳妥。

### 2. 遍历与展示（图标市场 / 选择器）

```dart
// 全部图标
for (final meta in OhosIcons.values) {
  // meta.icon 即 IconData
}

// 按分类筛选
final communication = OhosIcons.values
    .where((m) => m.categories.contains('通信'))
    .toList();
```

### 3. 展示中文名与版本信息

```dart
final meta = OhosIcons.info['wifi']!;
Tooltip(
  message: '${meta.label} · ${meta.supportVersion}',
  child: Icon(meta.icon),
);
```

### 4. RTL 镜像变体

部分图标（如 `airplane_fill`）提供 RTL 镜像字形。在 `TextDirection.rtl` 下可用 `mirrorIcon`：

```dart
final icon = meta.mirrorIcon ?? meta.icon;
Icon(icon);
```

### 5. 可变字重

打包的字体保留 `wght` 轴（40–900）。`IconData` 默认渲染 Regular（400）；需要其他字重时用 `Text` 渲染：

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

### 6. 完整示例（gallery）

仓库自带带搜索、分类筛选、点击查看详情的示例应用：

```bash
cd example
flutter pub get
flutter run          # 任意支持平台
```

鸿蒙模拟器可直接跑：`./tool/run_ohos.sh`（见下文）。

## 鸿蒙（HarmonyOS / OpenHarmony）使用

本包面向鸿蒙生态，兼容鸿蒙社区 Flutter 分叉 [CPF-Flutter/flutter_flutter](https://atomgit.com/CPF-Flutter/flutter_flutter)：

```bash
# 安装分叉（fvm 示例）
fvm fork add ohos https://atomgit.com/CPF-Flutter/flutter_flutter
fvm install ohos/oh-3.35.7-release
fvm use ohos/oh-3.35.7-release
```

构建/运行需要 DevEco Studio 工具链环境变量：

```bash
export DEVECO_SDK_HOME=/Applications/DevEco-Studio.app/Contents/sdk
export JAVA_HOME=/Applications/DevEco-Studio.app/Contents/jbr/Contents/Home
export PATH=/Applications/DevEco-Studio.app/Contents/tools/ohpm/bin:$PATH
export PATH=/Applications/DevEco-Studio.app/Contents/tools/node/bin:$PATH
export PATH=/Applications/DevEco-Studio.app/Contents/tools/hvigor/bin:$PATH
```

在 OpenHarmony 模拟器上直接运行示例（无需 DevEco 登录签名，模拟器接受未签名 debug HAP）：

```bash
./tool/run_ohos.sh
```

> 说明：`flutter run` 在 ohos 分叉上要求 DevEco 自动签名（需要华为账号）。如需热重载/调试，
> 请在 DevEco Studio 中打开 `example/ohos` 工程，勾选 Signing Configs 的自动签名后使用 `flutter run`。

## 从官网重新生成

图标与字体都可以从官网脚本化重建（依赖 `python3` 与 `fonttools`）：

```bash
pip install fonttools    # 仅子集化/导出需要

python3 tool/download_source.py   # 下载最新 name_map_new.json + HMSymbol.ttf
python3 tool/subset_font.py       # 子集化字体 -> assets/fonts/HMSymbol.ttf
python3 tool/generate_icons.py    # 生成 lib/src/ohos_icons.dart
python3 tool/export_svg.py        # （可选）导出全部图标为高保真 SVG
```

| 工具 | 作用 |
| --- | --- |
| `tool/download_source.py` | 从华为官网下载图标元数据与字体 |
| `tool/subset_font.py` | 将 4.2MB 官方字体裁剪为仅含图标码点（约 360KB） |
| `tool/generate_icons.py` | 生成 `lib/src/ohos_icons.dart`（常量 + 元数据） |
| `tool/export_svg.py` | 导出每个图标的高保真矢量 SVG（`tool/export/svg/`） |
| `tool/run_ohos.sh` | 构建并运行 example 到鸿蒙模拟器 |

## 目录结构

```
lib/
  ohos_icons.dart            # 库入口
  src/ohos_icons.dart        # 生成的常量与元数据（勿手改）
assets/fonts/HMSymbol.ttf    # 子集化图标字体
example/                     # gallery 示例
tool/                        # 下载/生成/导出/运行脚本
test/                        # 一致性测试
```

## 常见问题

**Q: 图标显示为方块/问号？**
确保字体已声明（本包 pubspec 已内置 `HMSymbol` 字体，无需额外配置），且 `IconData` 的 `fontPackage` 未被覆盖。

**Q: 能按官方 17 个分类浏览吗？**
可以，`OhosIcons.categories` 返回全部分类，配合 `OhosIconMeta.categories` 筛选即可。

**Q: 图标数量为什么是 534 而不是官网的 579？**
官网同一图标会出现在多个分类（如 `wifi` 同时属于“系统UI”和“连接”），本包按名称去重后为 534 个唯一图标。

## 许可

- Dart 代码与工具脚本：MIT（见 [LICENSE](LICENSE)）
- 图标字体 `HM Symbol` 与图标元数据来自华为开发者官网“HarmonyOS Symbol”页面（免费下载），假定用于鸿蒙生态应用界面展示；字体资产不适用 MIT，详见 `LICENSE` 说明
