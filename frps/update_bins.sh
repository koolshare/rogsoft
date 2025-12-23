#!/bin/sh
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="${DIR}/frps/bin"

UPX_BIN="${UPX_BIN:-/home/sadog/project/upx/upx-5.0.2}"
UPX_ARGS="--lzma --ultra-brute"

if [ ! -x "${UPX_BIN}" ]; then
	echo "upx not found or not executable: ${UPX_BIN}" >&2
	exit 1
fi

TMPDIR="$(mktemp -d)"
trap 'rm -rf "${TMPDIR}"' EXIT

latest_tag="$(curl -fsSL https://api.github.com/repos/fatedier/frp/releases/latest | sed -n 's/.*\"tag_name\"[[:space:]]*:[[:space:]]*\"\\([^\"]*\\)\".*/\\1/p' | head -n 1)"
if [ -z "${latest_tag}" ]; then
	echo "failed to detect latest frp release tag" >&2
	exit 1
fi

version="${latest_tag#v}"
echo "frp latest: ${latest_tag}"

fetch_one() {
	arch="$1"    # arm / arm64
	out="$2"     # frps-arm / frps-arm64

	pkg="frp_${version}_linux_${arch}.tar.gz"
	url="https://github.com/fatedier/frp/releases/download/${latest_tag}/${pkg}"

	echo "downloading: ${url}"
	curl -fsSL -o "${TMPDIR}/${pkg}" "${url}"
	( cd "${TMPDIR}" && tar -zxf "${pkg}" )

	src="${TMPDIR}/frp_${version}_linux_${arch}/frps"
	if [ ! -f "${src}" ]; then
		echo "missing frps in tarball: ${src}" >&2
		exit 1
	fi

	mkdir -p "${BIN_DIR}"
	cp -f "${src}" "${BIN_DIR}/${out}"
	chmod 755 "${BIN_DIR}/${out}"

	echo "upx: ${BIN_DIR}/${out}"
	"${UPX_BIN}" ${UPX_ARGS} "${BIN_DIR}/${out}" >/dev/null
}

fetch_one arm frps-arm
fetch_one arm64 frps-arm64

ls -lh "${BIN_DIR}/frps-arm" "${BIN_DIR}/frps-arm64"
