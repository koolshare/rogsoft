#!/bin/sh
set -e

# build script for rogsoft project

MODULE="frpc"
VERSION="2.2"
TITLE="frpc内网穿透"
DESCRIPTION="支持多种协议的内网穿透软件"
HOME_URL="Module_frpc.asp"
TAGS="网络 穿透"
AUTHOR="clang"
LINK="https://github.com/fatedier/frp"
CHANGELOG=""

DIR="$(cd "$(dirname "$0")" && pwd)"

if [ "$1" = "update" ]; then
	exec sh "${DIR}/update_bins.sh"
fi

PLATFORM="$1"
if [ -z "${PLATFORM}" ]; then
	ME=$(basename "$0")
	PLATFORM=$(echo "${ME}" | awk -F"." '{print $1}' | sed 's/build_//g')
	if [ "${ME}" = "build.sh" ]; then
		echo "build error! please run: sh build_hnd.sh|build_mtk.sh|build_qca.sh|build_ipq32.sh|build_ipq64.sh"
		exit 1
	fi
fi

do_build() {
	rm -rf "${DIR}/${MODULE}.tar.gz"
	rm -rf "${DIR}/build" && mkdir -p "${DIR}/build"

	# prepare build tree
	cp -rf "${DIR}/${MODULE}" "${DIR}/build/"
	echo "${PLATFORM}" >"${DIR}/build/${MODULE}/.valid"
	echo "${VERSION}" >"${DIR}/build/${MODULE}/version"

	# shrink package: keep only one binary and name it "frpc"
	rm -f "${DIR}/build/${MODULE}/bin/"*
	case "${PLATFORM}" in
		hnd|qca|ipq32)
			cp -f "${DIR}/${MODULE}/bin/frpc-arm" "${DIR}/build/${MODULE}/bin/frpc"
			;;
		mtk|ipq64)
			cp -f "${DIR}/${MODULE}/bin/frpc-arm64" "${DIR}/build/${MODULE}/bin/frpc"
			;;
		*)
			cp -f "${DIR}/${MODULE}/bin/frpc-arm" "${DIR}/build/${MODULE}/bin/frpc"
			;;
	esac
	chmod 755 "${DIR}/build/${MODULE}/bin/frpc"

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
