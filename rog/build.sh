#!/bin/sh

# build script for rogsoft project
MODULE="rog"
VERSION="5.9.12"
TITLE="ROG工具箱"
DESCRIPTION="一些小功能的插件"
HOME_URL="Module_rog.asp"
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
	# remove extra folder
	rm -rf ${DIR}/build/${MODULE}/bin-*
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
	"tags":"$TAGS",
	"author":"$AUTHOR",
	"link":"$LINK",
	"changelog":"$CHANGELOG",
	"build_date":"$DATE"
	}
	EOF
	
	#update md5
	python ../softcenter/gen_install.py stage2
}


# do build
cd $DIR
do_build

