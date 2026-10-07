# ohos_icons 示例（图标画廊）

运行在鸿蒙模拟器上的图标画廊：支持名称搜索、分类筛选、点击复制图标名。

![图标画廊](https://cdn.jsdelivr.net/gh/shaohushuo/ohos_icons@main/doc/ohos_screen_small.png)

## 运行（HarmonyOS）

需要鸿蒙社区 Flutter 分叉（CPF-Flutter `oh-3.35.7-release`，推荐 fvm 管理），
以及 DevEco Studio 的 node / ohpm / hvigor 工具链：

```bash
export DEVECO_SDK_HOME=/Applications/DevEco-Studio.app/Contents/sdk
export JAVA_HOME=/Applications/DevEco-Studio.app/Contents/jbr/Contents/Home
export PATH=/Applications/DevEco-Studio.app/Contents/tools/node/bin:/Applications/DevEco-Studio.app/Contents/tools/ohpm/bin:/Applications/DevEco-Studio.app/Contents/tools/hvigor/bin:$PATH

fvm flutter pub get
fvm flutter build hap --debug --no-codesign
hdc install -r build/ohos/hap/entry-default-unsigned.hap
hdc shell aa start -a EntryAbility -b com.example.ohos_icons_example
```

## 其他平台

```bash
fvm flutter run -d macos   # 或 -d chrome 等
```
