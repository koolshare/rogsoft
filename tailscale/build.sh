#!/bin/sh

# build script for rogsoft project
MODULE="tailscale"
VERSION="1.9.2"
TITLE="Tailscale"
DESCRIPTION="基于wiregurad协议的零配置内网穿透安全组网工具！"
HOME_URL="Module_tailscale.asp"
TAGS="穿透 VPN"
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
		echo "build tailscale for mtk"
		rm -rf ./build
		mkdir -p ./build
		cp -rf ./tailscale ./build/
		cd ./build
		rm -rf tailscale/bin
		mv -f tailscale/bin-mtk tailscale/bin/
		rm -rf tailscale/scripts
		mv -f tailscale/scripts-mtk tailscale/scripts/
		tar -zcf tailscale.tar.gz tailscale
		if [ "$?" = "0" ];then
			echo "build success!"
			mv tailscale.tar.gz ..
		fi
		cd ..
		rm -rf ./build
	elif [ "$ME" = "build.sh" ];then
		echo "build tailscale for hnd"
		rm -rf ./build
		mkdir -p ./build
		cp -rf ./tailscale ./build/
		cd ./build
		rm -rf tailscale/bin-mtk
		rm -rf tailscale/scripts-mtk
		tar -zcf tailscale.tar.gz tailscale
		if [ "$?" = "0" ];then
			echo "build success!"
			mv tailscale.tar.gz ..
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
