# Changelog (OpenHarmony)

[简体中文](CHANGELOG.OpenHarmony.md) · [中文 README](README.OpenHarmony_CN.md) · [English README](README.OpenHarmony.md) · [通用变更日志](CHANGELOG.md)

本文件记录 `harmony_icons` 在 OpenHarmony / HarmonyOS 平台上的支持情况与版本变更。与平台无关的通用变更同时记录在 [CHANGELOG.md](CHANGELOG.md)。

## [Unreleased]

- 暂无

## [0.1.0] - 2026-10-13

### 新增

- 首发版本：内置 HarmonyOS Symbol 2.3 图标数据与 HM Symbol 字体子集（约 360 KB，保留 `wght` 可变字重轴）
- 534 个唯一图标常量（`OhosIcons.<name>`），覆盖 17 个分类
- 查询 API：`OhosIcons.info` / `values` / `names` / `categories` / `fromName`
- `OhosIconMeta` 元数据：中文名、分类、所属模块、最低系统版本、码点、RTL 镜像码点
- gallery 示例应用：支持名称搜索、分类筛选、点击查看/复制图标名

### OpenHarmony 适配

- 纯 Dart + 字体实现，无平台通道、无插件、无 `ohos/` 平台代码，图标通过 Flutter 通用字体渲染机制显示
- 已验证兼容鸿蒙社区 Flutter 分叉 [oh-flutter/flutter_flutter](https://atomgit.com/oh-flutter/flutter_flutter) `3.47.7-ohos-1.0.1`
- 提供 `example/ohos` 工程壳，可直接用 DevEco Studio 打开
- 提供 `tool/run_ohos.sh`：构建未签名 debug HAP、通过 `hdc` 安装并启动，无需华为账号签名
- 图标库本身不需要任何系统权限；示例工程的 `INTERNET` 权限仅用于调试

### 验证

- 534 个图标在 OpenHarmony 模拟器上全量渲染成功，无缺字形
- `flutter analyze` 与 `flutter test` 通过（官方 Flutter stable 通道，CI）
- example 工程 `flutter analyze` 通过（CI）
- 验证环境：DevEco Studio 26.0.0、OpenHarmony SDK 26.0.0、OpenHarmony Phone 模拟器

### 已知限制

- `Icon` 不支持 `fontVariations`，默认以 `wght=400` 渲染；其他字重需用 `Text` + 码点
- RTL 镜像字形不会自动切换，需业务侧根据 `Directionality` 选择 `mirrorIcon`
- 官网 579 个分类条目按名称去重后为 534 个唯一图标
- `flutter run` 需要 DevEco 自动签名；模拟器调试建议使用 `tool/run_ohos.sh`

[Unreleased]: https://atomgit.com/oh-flutter/harmony_icons
[0.1.0]: https://pub.dev/packages/harmony_icons/versions/0.1.0
