#!/bin/sh

# build script for rogsoft project
MODULE="fixit"
VERSION="1.2"
TITLE="安全检查"
DESCRIPTION="检测软件中心重要文件是否被篡改，如果检测到恶意篡改，将其修复"
HOME_URL="Module_fixit.asp"
TAGS="系统 工具"
AUTHOR="sadog"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"
ME=$(basename "$0")

do_build() {
	rm -f ${MODULE}.tar.gz

	if [ "$ME" = "build_mtk.sh" ];then
		echo "build fixit for mtk"
		rm -rf ./build
		mkdir -p ./build
		cp -rf ./fixit ./build/
		cd ./build
		
		rm -rf fixit/bin
		mv -f fixit/bin-mtk fixit/bin/
		rm -rf fixit/scripts
		mv -f fixit/scripts-mtk fixit/scripts

		echo mtk >fixit/.valid
		
		tar -zcf fixit.tar.gz fixit
		if [ "$?" = "0" ];then
			echo "build success!"
			mv fixit.tar.gz ..
		fi
		cd ..
		rm -rf ./build
	elif [ "$ME" = "build.sh" ];then
		echo "build fixit for hnd"
		rm -rf ./build
		mkdir -p ./build
		cp -rf ./fixit ./build/
		cd ./build
		
		rm -rf fixit/bin-mtk
		rm -rf fixit/scripts-mtk

		echo hnd >fixit/.valid
		
		tar -zcf fixit.tar.gz fixit
		if [ "$?" = "0" ];then
			echo "build success!"
			mv fixit.tar.gz ..
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

