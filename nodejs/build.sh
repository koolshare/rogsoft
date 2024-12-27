#!/bin/sh

# build script for rogsoft project

MODULE="nodejs"
VERSION="1.5"
TITLE="Node.js"
DESCRIPTION="Node.js"
HOME_URL="Module_nodejs.asp"
TAGS="Entware"
AUTHOR="sadog"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"
ME=$(basename "$0")

do_build() {
	rm -f ${MODULE}.tar.gz

	if [ -z "$TAGS" ];then
		TAGS="其它"
	fi

	if [ "$ME" = "build_mtk.sh" ];then
		echo "build nodejs for mtk"
		rm -rf ./build
		mkdir -p ./build
		cp -rf ./nodejs ./build/
		cd ./build
		echo mtk >nodejs/.valid
		rm -rf nodejs/scripts
		rm -rf nodejs/install.sh
		rm -rf nodejs/uninstall.sh
		mv -f nodejs/scripts-mtk nodejs/scripts/
		mv -f nodejs/install_mtk.sh nodejs/install.sh
		mv -f nodejs/uninstall_mtk.sh nodejs/uninstall.sh
		tar -zcf nodejs.tar.gz nodejs
		if [ "$?" = "0" ];then
			echo "build success!"
			mv nodejs.tar.gz ..
		fi
		cd ..
		rm -rf ./build
	elif [ "$ME" = "build.sh" ];then
		echo "build nodejs for hnd"
		rm -rf ./build
		mkdir -p ./build
		cp -rf ./nodejs ./build/
		cd ./build
		echo hnd >nodejs/.valid
		rm -rf nodejs/scripts-mtk
		rm -rf nodejs/install_mtk.sh
		rm -rf nodejs/uninstall_mtk.sh
		tar -zcf nodejs.tar.gz nodejs
		if [ "$?" = "0" ];then
			echo "build success!"
			mv nodejs.tar.gz ..
		fi
		cd ..
		rm -rf ./build
	fi
	
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
