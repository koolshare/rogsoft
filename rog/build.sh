#!/bin/sh

# build script for rogsoft project
MODULE="rog"
VERSION="5.9.2"
TITLE="ROG工具箱"
DESCRIPTION="一些小功能的插件"
HOME_URL="Module_rog.asp"
TAGS="系统 工具"
AUTHOR="sadog"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"
ME=$(basename "$0")

do_build() {
	rm -f ${MODULE}.tar.gz

	if [ "$ME" = "build_mtk.sh" ];then
		echo "build rog for mtk"
		rm -rf ./build
		mkdir -p ./build
		cp -rf ./rog ./build/
		cd ./build
		
		rm -rf rog/bin
		mv -f rog/bin-mtk rog/bin/

		echo mtk >rog/.valid
		
		tar -zcf rog.tar.gz rog
		if [ "$?" = "0" ];then
			echo "build success!"
			mv rog.tar.gz ..
		fi
		cd ..
		rm -rf ./build
	elif [ "$ME" = "build.sh" ];then
		echo "build rog for hnd"
		rm -rf ./build
		mkdir -p ./build
		cp -rf ./rog ./build/
		cd ./build
		
		rm -rf rog/bin-mtk

		echo hnd >rog/.valid
		
		tar -zcf rog.tar.gz rog
		if [ "$?" = "0" ];then
			echo "build success!"
			mv rog.tar.gz ..
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

