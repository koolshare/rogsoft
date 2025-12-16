#!/bin/sh

# build script for rogsoft project

MODULE="fullcone"
VERSION="1.0.5"
TITLE="Fullcone NAT"
DESCRIPTION="使用此插件可以让你的网络轻松变为Full Cone（全锥形）即NAT1"
HOME_URL="Module_fullcone.asp"
SERVER="42.192.18.234"
PORT="8083"
TAGS="系统 工具"
AUTHOR="sadog"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"
ME=$(basename "$0")
PLATFORM=$(echo "${ME}" | awk -F"." '{print $1}' | sed 's/build_//g')

if [ "${ME}" = "build.sh" ];then
	echo "build error!"
	exit 1
fi

do_build() {
	#-----------------------------------------------------------------------
	# prepare to build
    rm -rf ${DIR}/${MODULE}.tar.gz
	rm -rf ${DIR}/build && mkdir -p ${DIR}/build
	cp -rf ${DIR}/${MODULE} ${DIR}/build/ && cd ${DIR}/build
	echo "build ${MODULE} for ${PLATFORM}"
	echo ${PLATFORM} >${DIR}/build/${MODULE}/.valid
	# different architecture of binary/script go to coresponding folder
	cp -rf ${DIR}/build/${MODULE}/bin-${PLATFORM} ${DIR}/build/${MODULE}/bin/
	cp -rf ${DIR}/build/${MODULE}/scripts-${PLATFORM} ${DIR}/build/${MODULE}/scripts/
	cp -rf ${DIR}/build/${MODULE}/install-${PLATFORM}.sh ${DIR}/build/${MODULE}/install.sh
	cp -rf ${DIR}/build/${MODULE}/uninstall-${PLATFORM}.sh ${DIR}/build/${MODULE}/uninstall.sh
	# remove extra folder
	rm -rf ${DIR}/build/${MODULE}/bin-*
	rm -rf ${DIR}/build/${MODULE}/scripts-*
	rm -rf ${DIR}/build/${MODULE}/install-*.sh
	rm -rf ${DIR}/build/${MODULE}/uninstall-*.sh

	# different pkg use different files
	if [ "${PLATFORM}" == "hnd" ];then
		rm -rf ${DIR}/build/fullcone/fullcone/qca* 2>/dev/null
	fi

	if [ "${PLATFORM}" == "qca" -o "${PLATFORM}" == "ipq32" -o "${PLATFORM}" == "ipq64" ];then
		rm -rf ${DIR}/build/fullcone/fullcone/bcmhnd* 2>/dev/null
	fi

	if [ "${PLATFORM}" == "mtk" ];then
		rm -rf ${DIR}/build/fullcone/fullcone 2>/dev/null
	fi

	# make tar
	tar -zcf ${MODULE}.tar.gz ${MODULE}
	if [ "$?" = "0" ];then
		echo "build success!"
		mv ${DIR}/build/${MODULE}.tar.gz ${DIR}
	fi
	cd ${DIR} && rm -rf ${DIR}/build
	#-----------------------------------------------------------------------
	
	# add version to the package
	echo ${VERSION} >${MODULE}/version
	md5value=$(md5sum ${MODULE}.tar.gz | tr " " "\n" | sed -n 1p)
	cat > ./version <<-EOF
	${VERSION}
	${md5value}
	EOF
	cat version
	
	DATE=$(date +%Y-%m-%d_%H:%M:%S)
	cat > ./config.json.js <<-EOF
	{
	"version":"$VERSION",
	"md5":"$md5value",
	"home_url":"$HOME_URL",
	"title":"$TITLE",
	"description":"$DESCRIPTION",
	"changelog":"$CHANGELOG",
	"tags":"$TAGS",
	"author":"$AUTHOR",
	"link":"$LINK",
	"build_date":"$DATE",
	"server":"$SERVER",
	"port":"$PORT"
	}
	EOF
	
	#update md5
	python ../softcenter/gen_install.py stage2
}


# do build
cd $DIR
do_build
