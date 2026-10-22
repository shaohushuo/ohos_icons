> 模板版本：v0.0.1

<p align="center">
  <h1 align="center"> <code>harmony_icons</code> </h1>
</p>

[简体中文](README.OpenHarmony_CN.md) · [English](README.OpenHarmony.md) · [变更日志](CHANGELOG.OpenHarmony.md) · [项目主 README](README.md)

本项目是面向 OpenHarmony / HarmonyOS 生态的 Flutter 三方图标库，把华为官方 HM Symbol 图标字体与 534 个图标的元数据打包成**零依赖**的 Flutter 包。每个图标都是一个标准 `IconData` 常量，可直接运行在 OpenHarmony 社区 Flutter 分叉 [oh-flutter/flutter_flutter](https://atomgit.com/oh-flutter/flutter_flutter) 上，同时兼容官方 Flutter SDK。

- 图标与元数据来源：华为开发者官网 [HarmonyOS Symbol](https://developer.huawei.com/consumer/cn/design/harmonyos-symbol/)（当前内置 **HarmonyOS Symbol 2.3**）
- 内置 **534 个唯一图标**，覆盖 17 个分类
- 纯 Dart + 字体实现：无平台通道、无插件、无 `ohos/` 平台代码

![harmony_icons gallery 运行在 OpenHarmony 模拟器](https://raw.gitcode.com/oh-flutter/harmony_icons/main/doc/ohos_screen_small.png)

## 1. 安装与使用

### 1.1 安装方式

#### 方式一：从 pub.dev 安装（推荐）

在工程的 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  harmony_icons: ^0.1.0
```

执行：

```bash
flutter pub get
```

字体 `HMSymbol` 已在包内 `pubspec.yaml` 中声明，业务工程无需额外配置字体资源。

#### 方式二：从 AtomGit 源码安装

需要使用仓库最新代码时，可改为 git 依赖：

```yaml
dependencies:
  harmony_icons:
    git:
      url: https://atomgit.com/oh-flutter/harmony_icons.git
      # 仓库当前维护 main 分支；发布 TAG 后建议固定到 v0.1.0 等版本号
      ref: main
```

```bash
flutter pub get
```

> TAG 说明：本库为原创实现，没有需要适配的上游库，版本号直接沿用 pub.dev 语义化版本（如 `v0.1.0`），不使用 `原库版本-ohos-版本号` 形式的适配 TAG。当前已验证的框架版本与分支：

| Flutter 框架版本 | TAG / 引用 | 分支名 |
| :---: | :---: | :---: |
| 3.47.7-ohos-1.0.1 | `main`（发布后可固定 `v0.1.0`） | main |

### 1.2 使用案例

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

完整示例（搜索、分类筛选、点击复制图标名）见 [example/lib/main.dart](example/lib/main.dart)。在 OpenHarmony 模拟器上可直接运行：

```bash
./tool/run_ohos.sh
```

运行原理、环境变量与手动构建步骤见第 6 节。

## 2. 约束与限制

### 2.1 兼容性

已在以下环境完整验证：

| 项目 | 版本 / 说明 |
| --- | --- |
| Flutter（鸿蒙社区分叉） | [oh-flutter/flutter_flutter](https://atomgit.com/oh-flutter/flutter_flutter) `3.47.7-ohos-1.0.1` |
| DevEco Studio | 26.0.0 |
| OpenHarmony SDK | 26.0.0 |
| 运行设备 | OpenHarmony 模拟器（Phone） |
| 官方 Flutter SDK | CI 使用 stable 通道执行 `flutter analyze` 与 `flutter test` |

本库不包含任何平台相关代码，图标通过 Flutter 通用的“字体 + 码点”机制渲染，因此不依赖 OpenHarmony 系统 API 版本；平台兼容性主要取决于 Flutter 分叉本身。

### 2.2 权限要求

本库**不需要任何系统权限**。

示例工程 `example/ohos/entry/src/main/module.json5` 中声明了 `ohos.permission.INTERNET`，该权限仅用于调试场景，不属于图标库的运行要求；接入本库无需申请权限。

### 2.3 使用约束

1. 必须使用包内自带的 `HMSymbol` 字体，不要覆盖 `IconData` 的 `fontPackage`，否则图标会显示为方块。
2. `Icon` 固定以 Regular（`wght=400`）渲染；需要其他字重时改用 `Text` + 码点，见 5.1。
3. RTL 镜像不会自动生效，需要业务侧根据 `Directionality` 选择 `mirrorIcon`，见 5.2。
4. 中文名、分类、最低系统版本等元数据来自官方数据，本包不做二次翻译。

## 3. API

> [!TIP] “ohos Support”列为 yes 表示 OpenHarmony 平台支持该能力；本库全部 API 均为纯 Dart 实现，跨平台行为一致。

| 名称 | 说明 | 类型 | 输入 | 输出 | ohos Support |
| --- | --- | --- | --- | --- | --- |
| `OhosIcons.<name>` | 图标常量，如 `OhosIcons.wifi` | `IconData` | / | `IconData` | yes |
| `OhosIcons.fontFamily` | 字体名，固定为 `HMSymbol` | `String` | / | `HMSymbol` | yes |
| `OhosIcons.fontPackage` | 包名，跨包解析字体资源 | `String` | / | `harmony_icons` | yes |
| `OhosIcons.info` | 按英文名索引全部元数据 | `Map<String, OhosIconMeta>` | / | 元数据映射 | yes |
| `OhosIcons.values` | 遍历全部图标元数据 | `Iterable<OhosIconMeta>` | / | 元数据迭代器 | yes |
| `OhosIcons.names` | 全部图标英文名（有序、唯一） | `List<String>` | / | 名称列表 | yes |
| `OhosIcons.count` | 图标总数 | `int` | / | `534` | yes |
| `OhosIcons.version` | 官方图标数据版本 | `String` | / | `2.3` | yes |
| `OhosIcons.categories` | 全部分类（排序、去重） | `List<String>` | / | 分类列表 | yes |
| `OhosIcons.fromName(name)` | 按英文名动态获取图标 | `IconData` | `String name` | `IconData` | yes |

`fromName` 在名称不存在时抛出 `ArgumentError`；数据驱动场景可先用 `OhosIcons.info.containsKey(name)` 判断。

## 4. 属性

`OhosIconMeta` 的字段如下，均可直接在 OpenHarmony 上使用：

| 字段 | 说明 | 类型 | 示例 | ohos Support |
| --- | --- | --- | --- | --- |
| `name` | 官方英文标识 | `String` | `airplane_fill` | yes |
| `label` | 官方中文名 | `String` | `飞行模式` | yes |
| `module` | 所属模块 | `String` | `状态栏` | yes |
| `categories` | 所属分类（可多个） | `List<String>` | `[系统UI]` | yes |
| `supportVersion` | 最低 HarmonyOS 版本 | `String` | `HarmonyOS 5.0+` | yes |
| `codepoint` | 字体码点 | `int` | `0xF0113` | yes |
| `mirrorCodepoint` | RTL 镜像码点，可为 `null` | `int?` | `0xF0A02` | yes |
| `icon` | 该图标的 `IconData` | `IconData` | / | yes |
| `mirrorIcon` | 镜像变体，无镜像时为 `null` | `IconData?` | / | yes |

## 5. 遗留问题

### 5.1 `Icon` 不支持可变字重

打包字体保留了 `wght` 轴（40–900），但 Flutter 的 `Icon` 组件不支持 `fontVariations`，默认只渲染 Regular（400）。需要其他字重时请改用 `Text` 渲染码点：

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

### 5.2 RTL 镜像需要业务侧手动切换

部分图标提供 RTL 镜像字形，但 Flutter 不会根据文本方向自动替换图标：

```dart
final meta = OhosIcons.info['airplane_fill']!;
final icon = Directionality.of(context) == TextDirection.rtl
    ? (meta.mirrorIcon ?? meta.icon)
    : meta.icon;
```

### 5.3 图标数量与官网口径不同

官网分类页共列出 579 个条目，同一图标会出现在多个分类中（如 `wifi` 同时属于“系统UI”和“连接”）。本包按英文名去重后为 **534 个唯一图标**。

### 5.4 `flutter run` 需要签名配置

在 ohos 分叉上，`flutter run` 要求 DevEco 自动签名（需要华为账号）。OpenHarmony 模拟器接受未签名 debug HAP，因此仓库提供 `tool/run_ohos.sh` 完成构建、安装与启动；如需热重载/断点调试，请在 DevEco Studio 中打开 `example/ohos` 并启用 Signing Configs 自动签名。

## 6. 其他

### 6.1 在 OpenHarmony 上运行示例

依赖 DevEco Studio 自带工具链（ohpm、node、hvigor、hdc 等），以 macOS 默认安装路径为例：

```bash
export DEVECO_SDK_HOME=/Applications/DevEco-Studio.app/Contents/sdk
export JAVA_HOME=/Applications/DevEco-Studio.app/Contents/jbr/Contents/Home
export PATH=/Applications/DevEco-Studio.app/Contents/tools/ohpm/bin:$PATH
export PATH=/Applications/DevEco-Studio.app/Contents/tools/node/bin:$PATH
export PATH=/Applications/DevEco-Studio.app/Contents/tools/hvigor/bin:$PATH

./tool/run_ohos.sh              # 默认设备
./tool/run_ohos.sh <device-id>  # 多设备时指定
```

脚本依次执行 `flutter build hap --debug --no-codesign`、`hdc install -r`、`hdc shell aa start`，无需登录华为账号。可通过 `DEVECO_APP`、`OHOS_SDK`、`HDC`、`BUNDLE_NAME` 环境变量覆盖默认路径与包名。

### 6.2 从官网重新生成图标数据

依赖 `python3`，子集化与 SVG 导出还需要 `fonttools`：

```bash
pip install fonttools

python3 tool/download_source.py   # 下载最新 name_map_new.json + HMSymbol.ttf
python3 tool/subset_font.py       # 子集化字体 -> assets/fonts/HMSymbol.ttf
python3 tool/generate_icons.py    # 生成 lib/src/harmony_icons.dart
python3 tool/export_svg.py        # （可选）导出全部图标为 SVG
```

| 工具 | 作用 |
| --- | --- |
| `tool/download_source.py` | 从华为官网下载图标元数据与字体 |
| `tool/subset_font.py` | 将官方字体裁剪为仅含图标码点（约 360 KB） |
| `tool/generate_icons.py` | 生成常量与元数据（勿手改生成文件） |
| `tool/export_svg.py` | 导出每个图标的高保真 SVG |
| `tool/run_ohos.sh` | 构建并运行示例到 OpenHarmony 设备/模拟器 |

### 6.3 目录结构

```text
lib/
  harmony_icons.dart          # 库入口
  src/harmony_icons.dart      # 生成的常量与元数据（勿手改）
assets/fonts/HMSymbol.ttf     # 子集化图标字体
example/                      # gallery 示例
example/ohos/                 # OpenHarmony 工程壳（DevEco Studio 可打开）
tool/                         # 下载/生成/导出/运行脚本
test/                         # 一致性测试
README.OpenHarmony_CN.md      # 本文档
README.OpenHarmony.md         # 英文平台文档
CHANGELOG.OpenHarmony.md      # OpenHarmony 变更记录
```

### 6.4 测试与持续集成

```bash
flutter analyze
flutter test
```

CI 在每次 push / pull request 时执行格式检查、静态分析、单元测试与示例工程分析，配置见 [.github/workflows/ci.yml](.github/workflows/ci.yml)。

### 6.5 相关文档与仓库

- 项目主文档（中文）：[README.md](README.md)
- OpenHarmony 英文文档：[README.OpenHarmony.md](README.OpenHarmony.md)
- OpenHarmony 变更日志：[CHANGELOG.OpenHarmony.md](CHANGELOG.OpenHarmony.md)
- AtomGit 仓库：[oh-flutter/harmony_icons](https://atomgit.com/oh-flutter/harmony_icons)
- pub.dev 发布页：[pub.dev/packages/harmony_icons](https://pub.dev/packages/harmony_icons)
- 鸿蒙社区 Flutter 分叉：[oh-flutter/flutter_flutter](https://atomgit.com/oh-flutter/flutter_flutter)
- 华为 HarmonyOS Symbol：[developer.huawei.com](https://developer.huawei.com/consumer/cn/design/harmonyos-symbol/)

## 7. 开源协议

- Dart 代码与工具脚本：MIT，见 [LICENSE](LICENSE)
- 图标字体 `HM Symbol` 与图标元数据来自华为开发者官网“HarmonyOS Symbol”页面（免费下载），用于鸿蒙生态应用界面展示；字体资产**不适用 MIT**，详见 [LICENSE](LICENSE) 末尾说明
