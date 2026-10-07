#!/usr/bin/env bash
# Build (unsigned, debug) + install + launch the example app on a connected
# HarmonyOS/OpenHarmony device or emulator using the CPF Flutter (ohos) fork.
#
# Why unsigned: `flutter run` on ohos requires a DevEco signing config
# (Huawei account / auto signature). An OpenHarmony emulator accepts unsigned
# debug HAPs, so we use `flutter build hap --no-codesign` and then `hdc`.
#
# Usage:
#   flutter fvm run:  fvm flutter build hap ... (see below)
#   ./tool/run_ohos.sh [device-id]
#
# Env overrides:
#   DEVECO_APP=/Applications/DevEco-Studio.app
#   OHOS_SDK=<root of a DevEco sdk, containing sdk-pkg.json>
#   HDC=<path to hdc binary>
#   BUNDLE_NAME=com.example.ohos_icons_example
set -euo pipefail

DEVECO_APP="${DEVECO_APP:-/Applications/DevEco-Studio.app}"
CONTENTS="$DEVECO_APP/Contents"
DEVECO_SDK_HOME="${DEVECO_SDK_HOME:-$CONTENTS/sdk}"
JAVA_HOME="${JAVA_HOME:-$CONTENTS/jbr/Contents/Home}"
HDC="${HDC:-/Users/zacksleo/Library/OpenHarmony/Sdk/26.0.0/toolchains/hdc}"
BUNDLE_NAME="${BUNDLE_NAME:-com.example.ohos_icons_example}"

export DEVECO_SDK_HOME JAVA_HOME
export PATH="$CONTENTS/tools/ohpm/bin:$CONTENTS/tools/node/bin:$CONTENTS/tools/hvigor/bin:$(dirname "$HDC"):$PATH"

cd "$(dirname "$0")/../example"

echo "==> building unsigned debug hap..."
fvm flutter build hap --debug --no-codesign

HAP="$(pwd)/build/ohos/hap/entry-default-unsigned.hap"

echo "==> installing $HAP"
"$HDC" install -r "$HAP"

echo "==> starting $BUNDLE_NAME"
"$HDC" shell aa start -a EntryAbility -b "$BUNDLE_NAME"

echo "==> done. check the emulator; logs: $HDC shell hilog -x | grep -i flutter"
