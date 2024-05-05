#!/bin/sh

# build script for zerotier project
MODULE="zerotier"
VERSION="1.5.1"
TITLE="ZeroTier"
DESCRIPTION="ZeroTier 内网穿透"
HOME_URL="Module_zerotier.asp"
TAGS="穿透 VPN"
AUTHOR="sadog"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"
ME=$(basename "$0")

do_build() {
	rm -f ${MODULE}.tar.gz
	ls -lF ${DIR}/zerotier/lib64|awk '{print $9}'|sed '/^$/d'|sed 's/^/zerotier /g'|sed 's/*$//g' > ${DIR}/zerotier/lib64/.flag_zerotier.txt

	if [ "$ME" = "build_mtk.sh" ];then
		echo "build zerotier for mtk"
		rm -rf ./build
		mkdir -p ./build
		cp -rf ./zerotier ./build/
		cd ./build
		
		rm -rf zerotier/bin32
		rm -rf zerotier/lib32
		rm -rf zerotier/scripts-hnd
		mv -f zerotier/scripts-mtk zerotier/scripts

		echo mtk >zerotier/.valid

		tar -zcf zerotier.tar.gz zerotier
		if [ "$?" = "0" ];then
			echo "build success!"
			mv zerotier.tar.gz ..
		fi
		cd ..
		rm -rf ./build
	elif [ "$ME" = "build.sh" ];then
		echo "build zerotier for hnd"
		rm -rf ./build
		mkdir -p ./build
		cp -rf ./zerotier ./build/
		cd ./build

		rm -rf zerotier/scripts-mtk
		mv -f zerotier/scripts-hnd zerotier/scripts
		
		echo hnd >zerotier/.valid
		
		tar -zcf zerotier.tar.gz zerotier
		if [ "$?" = "0" ];then
			echo "build success!"
			mv zerotier.tar.gz ..
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


