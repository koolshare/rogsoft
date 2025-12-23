#!/bin/sh
set -e

# build script for rogsoft project

MODULE="fakesip"
VERSION="1.0"
TITLE="FakeSIP 伪装"
DESCRIPTION="将 UDP 流量伪装为 SIP 协议（NFQUEUE），用于网络流量混淆"
HOME_URL="Module_fakesip.asp"
TAGS="网络 工具"
AUTHOR="sadog"
LINK="https://github.com/MikeWang000000/FakeSIP"
CHANGELOG=""

DIR="$(cd "$(dirname "$0")" && pwd)"

do_update_bins() {
	UPX_BIN="${HOME}/project/upx/upx-5.0.2"
	if [ ! -x "${UPX_BIN}" ]; then
		echo "upx not found or not executable: ${UPX_BIN}"
		exit 1
	fi

	TMPDIR="$(mktemp -d /tmp/fakesip_update_XXXXXX)"
	trap 'rm -rf "${TMPDIR}" >/dev/null 2>&1' EXIT

	API="https://api.github.com/repos/MikeWang000000/FakeSIP/releases/latest"
	echo "fetch: ${API}"

	python3 - <<'PY' "${API}" "${TMPDIR}"
import json, sys, urllib.request, os
api=sys.argv[1]
tmpdir=sys.argv[2]
data=json.load(urllib.request.urlopen(api, timeout=30))
tag=data.get("tag_name") or ""
assets={a["name"]:a["browser_download_url"] for a in data.get("assets", []) if "name" in a and "browser_download_url" in a}
need=[
    ("fakesip-linux-arm32v7hf.tar.gz", "arm32"),
    ("fakesip-linux-arm64.tar.gz", "arm64"),
]
print("tag:", tag)
for name, key in need:
    url=assets.get(name)
    if not url:
        raise SystemExit(f"missing asset: {name}")
    print("asset:", name, url)
    out=os.path.join(tmpdir, name)
    urllib.request.urlretrieve(url, out)
PY

	mkdir -p "${TMPDIR}/arm32" "${TMPDIR}/arm64"
	tar -zxf "${TMPDIR}/fakesip-linux-arm32v7hf.tar.gz" -C "${TMPDIR}/arm32"
	tar -zxf "${TMPDIR}/fakesip-linux-arm64.tar.gz" -C "${TMPDIR}/arm64"

	ARM32_BIN="$(find "${TMPDIR}/arm32" -maxdepth 3 -type f -name fakesip | head -n 1)"
	ARM64_BIN="$(find "${TMPDIR}/arm64" -maxdepth 3 -type f -name fakesip | head -n 1)"
	if [ -z "${ARM32_BIN}" ] || [ -z "${ARM64_BIN}" ]; then
		echo "fakesip binary not found in release archives"
		exit 1
	fi

	install -m 0755 "${ARM32_BIN}" "${DIR}/${MODULE}/bin/fakesip-arm"
	install -m 0755 "${ARM64_BIN}" "${DIR}/${MODULE}/bin/fakesip-arm64"

	"${UPX_BIN}" --best "${DIR}/${MODULE}/bin/fakesip-arm" >/dev/null 2>&1 || true
	"${UPX_BIN}" --best "${DIR}/${MODULE}/bin/fakesip-arm64" >/dev/null 2>&1 || true

	echo "updated:"
	file "${DIR}/${MODULE}/bin/fakesip-arm" "${DIR}/${MODULE}/bin/fakesip-arm64"
}

PLATFORM="$1"
if [ -z "${PLATFORM}" ]; then
	ME=$(basename "$0")
	PLATFORM=$(echo "${ME}" | awk -F"." '{print $1}' | sed 's/build_//g')
	if [ "${ME}" = "build.sh" ]; then
		echo "build error! please run: sh build_hnd.sh|build_mtk.sh|build_qca.sh|build_ipq32.sh|build_ipq64.sh"
		exit 1
	fi
fi

if [ "${PLATFORM}" = "update" ]; then
	do_update_bins
	exit 0
fi

do_build() {
	rm -rf "${DIR}/${MODULE}.tar.gz"
	rm -rf "${DIR}/build" && mkdir -p "${DIR}/build"

	# prepare build tree
	cp -rf "${DIR}/${MODULE}" "${DIR}/build/"
	echo "${PLATFORM}" >"${DIR}/build/${MODULE}/.valid"
	echo "${VERSION}" >"${DIR}/build/${MODULE}/version"

	# shrink package: keep only one binary and name it "fakesip"
	rm -f "${DIR}/build/${MODULE}/bin/"*
	case "${PLATFORM}" in
		hnd|qca|ipq32)
			cp -f "${DIR}/${MODULE}/bin/fakesip-arm" "${DIR}/build/${MODULE}/bin/fakesip"
			;;
		mtk|ipq64)
			cp -f "${DIR}/${MODULE}/bin/fakesip-arm64" "${DIR}/build/${MODULE}/bin/fakesip"
			;;
		*)
			cp -f "${DIR}/${MODULE}/bin/fakesip-arm" "${DIR}/build/${MODULE}/bin/fakesip"
			;;
	esac
	chmod 755 "${DIR}/build/${MODULE}/bin/fakesip"

	# pack
	( cd "${DIR}/build" && tar -zcf "${MODULE}.tar.gz" "${MODULE}" )
	mv -f "${DIR}/build/${MODULE}.tar.gz" "${DIR}/"
	rm -rf "${DIR}/build"

	md5value=$(md5sum "${DIR}/${MODULE}.tar.gz" | tr " " "\n" | sed -n 1p)

	cat >"${DIR}/version" <<-EOF
	${VERSION}
	${md5value}
	EOF

	DATE=$(date +%Y-%m-%d_%H:%M:%S)
	cat >"${DIR}/config.json.js" <<-EOF
	{
	"version":"${VERSION}",
	"md5":"${md5value}",
	"home_url":"${HOME_URL}",
	"title":"${TITLE}",
	"description":"${DESCRIPTION}",
	"tags":"${TAGS}",
	"author":"${AUTHOR}",
	"link":"${LINK}",
	"changelog":"${CHANGELOG}",
	"build_date":"${DATE}"
	}
	EOF

	# update app.json.js
	python "${DIR}/../softcenter/gen_install.py" stage2
}

do_build

