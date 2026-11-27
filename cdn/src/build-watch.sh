#!/bin/sh
# Build once per userspace ABI and populate the software center's platform inputs.
set -eu
cd "$(dirname "$0")"
armcc=${ARM_CC:-/opt/openwrt-gcc750_musl1124.arm/bin/arm-openwrt-linux-gcc}
arm64cc=${ARM64_CC:-/opt/openwrt-gcc750_musl1124.aarch64/bin/aarch64-openwrt-linux-gcc}
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
build() {
    cc=$1; elf=$2
    shift 2
    STAGING_DIR=${STAGING_DIR:-$(dirname "$cc")/..} \
        "$cc" -std=c11 -Os -Wall -Wextra -Werror -static -s -ffunction-sections -fdata-sections \
        -Wl,--gc-sections -Wl,--build-id=none "$@" cdn-watch.c -o "$work/$elf"
}
build "$armcc" arm -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard
build "$arm64cc" arm64 -march=armv8-a
for platform in hnd qca ipq32 mtk ipq64; do
    case "$platform" in mtk|ipq64) elf=arm64 ;; *) elf=arm ;; esac
    install -Dm755 "$work/$elf" "../cdn/bin-$platform/cdn-watch"
done
