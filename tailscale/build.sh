#!/bin/sh

# build script for rogsoft project
MODULE="tailscale"
VERSION="2.0.3"
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

	#----------------------------------------------------
	# start to make tar
	rm -rf ./build && mkdir -p ./build
	cp -rf ./tailscale ./build/ && cd ./build
	if [ "$ME" = "build_mtk.sh" ];then
		# mtk platform use 64 bit version of bianry
		echo "build tailscale for mtk"
		
		# valid string
		echo "mtk" >tailscale/.valid
		
		# binary
		rm -rf tailscale/bin_32
		mv -f tailscale/bin_64 tailscale/bin/
		
		# scripts (encrypted)
		cp -rf tailscale/scripts-mtk tailscale/scripts/
	elif [ "$ME" = "build_ipq64.sh" ];then
		# ipq64 use mtk's 64 bit binary
		echo "build tailscale for ipq64"
		
		# valid string
		echo "ipq64" >tailscale/.valid

		# binary
		rm -rf tailscale/bin_32
		mv -f tailscale/bin_64 tailscale/bin/
		
		# scripts (encrypted)
		cp -rf tailscale/scripts-ipq64 tailscale/scripts/
	elif [ "$ME" = "build_ipq32.sh" ];then
		# ipq32 use hnd's 32 bit binary and it's own scripts
		echo "build tailscale for ipq32"
		
		# valid string
		echo "ipq32" >tailscale/.valid

		# binary
		rm -rf tailscale/bin_64
		mv -f tailscale/bin_32 tailscale/bin/

		# scripts (encrypted)
		cp -rf tailscale/scripts-ipq32 tailscale/scripts/
	elif [ "$ME" = "build.sh" ];then
		# hnd platform use 32 bit version of bianry
		echo "build tailscale for hnd"
		
		# valid string
		echo "hnd" >tailscale/.valid
		
		# binary
		rm -rf tailscale/bin_64
		mv -f tailscale/bin_32 tailscale/bin/
		
		# scripts (encrypted)
		cp -rf tailscale/scripts-hnd tailscale/scripts/
	fi
	rm -rf tailscale/scripts-hnd
	rm -rf tailscale/scripts-mtk
	rm -rf tailscale/scripts-ipq32
	rm -rf tailscale/scripts-ipq64
	# make tar
	tar -zcf tailscale.tar.gz tailscale
	if [ "$?" = "0" ];then
		echo "build success!"
		mv tailscale.tar.gz ..
	fi
	cd .. && rm -rf ./build

	#----------------------------------------------------
	
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
