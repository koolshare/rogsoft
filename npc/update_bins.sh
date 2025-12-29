#!/bin/sh
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
UPX="/home/sadog/project/upx/upx-5.0.2"

if [ ! -x "${UPX}" ]; then
	echo "upx not found or not executable: ${UPX}"
	exit 1
fi

tmp="$(mktemp -d)"
cleanup() {
	rm -rf "${tmp}"
}
trap cleanup EXIT

tag="$(curl -fsSL https://api.github.com/repos/ehang-io/nps/releases/latest | python -c 'import sys,json; print(json.load(sys.stdin).get("tag_name",""))')"
if [ -z "${tag}" ]; then
	echo "failed to detect latest nps release tag"
	exit 1
fi

arm_url="https://github.com/ehang-io/nps/releases/download/${tag}/linux_arm_v7_client.tar.gz"
arm64_url="https://github.com/ehang-io/nps/releases/download/${tag}/linux_arm64_client.tar.gz"

echo "tag: ${tag}"
echo "downloading: ${arm_url}"
curl -fL "${arm_url}" -o "${tmp}/arm.tar.gz"
echo "downloading: ${arm64_url}"
curl -fL "${arm64_url}" -o "${tmp}/arm64.tar.gz"

mkdir -p "${tmp}/arm" "${tmp}/arm64"
tar -zxf "${tmp}/arm.tar.gz" -C "${tmp}/arm"
tar -zxf "${tmp}/arm64.tar.gz" -C "${tmp}/arm64"

if [ ! -f "${tmp}/arm/npc" ] || [ ! -f "${tmp}/arm64/npc" ]; then
	echo "npc binary not found in release archives"
	exit 1
fi

cp -f "${tmp}/arm/npc" "${DIR}/npc/bin/npc-arm"
cp -f "${tmp}/arm64/npc" "${DIR}/npc/bin/npc-arm64"
chmod 755 "${DIR}/npc/bin/npc-arm" "${DIR}/npc/bin/npc-arm64"

echo "compressing with upx: --lzma --brute"
"${UPX}" --no-backup --lzma --brute "${DIR}/npc/bin/npc-arm" >/dev/null
"${UPX}" --no-backup --lzma --brute "${DIR}/npc/bin/npc-arm64" >/dev/null

echo "done: ${DIR}/npc/bin/npc-arm"
echo "done: ${DIR}/npc/bin/npc-arm64"
