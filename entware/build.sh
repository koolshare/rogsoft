#!/bin/sh

# build script for rogsoft project

MODULE="entware"
VERSION="1.7.1"
TITLE="Entware"
DESCRIPTION="轻松安装/管理Entware环境"
HOME_URL="Module_entware.asp"
TAGS="Entware USB"
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
		echo "build entware for mtk"
		rm -rf ./build
		mkdir -p ./build
		cp -rf ./entware ./build/
		cd ./build
		echo mtk >entware/.valid
		rm -rf entware/scripts
		rm -rf entware/install.sh
		rm -rf entware/uninstall.sh
		mv -f entware/scripts-mtk entware/scripts/
		mv -f entware/install_mtk.sh entware/install.sh
		mv -f entware/uninstall_mtk.sh entware/uninstall.sh
		tar -zcf entware.tar.gz entware
		if [ "$?" = "0" ];then
			echo "build success!"
			mv entware.tar.gz ..
		fi
		cd ..
		rm -rf ./build
	elif [ "$ME" = "build.sh" ];then
		echo "build entware for hnd"
		rm -rf ./build
		mkdir -p ./build
		cp -rf ./entware ./build/
		cd ./build
		echo hnd >entware/.valid
		rm -rf entware/scripts-mtk
		rm -rf entware/install_mtk.sh
		rm -rf entware/uninstall_mtk.sh
		tar -zcf entware.tar.gz entware
		if [ "$?" = "0" ];then
			echo "build success!"
			mv entware.tar.gz ..
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
