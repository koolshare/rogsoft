#!/bin/sh

# build script for rogsoft project

MODULE="tmux"
VERSION="1.0"
TITLE="tmux"
DESCRIPTION="tmux是一个终端复用器,它可以启动一系列终端会话。"
HOME_URL="Module_tmux.asp"
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
		echo "build tmux for mtk"
		rm -rf ./build
		mkdir -p ./build
		cp -rf ./tmux ./build/
		cd ./build
		echo mtk >tmux/.valid
		rm -rf tmux/scripts
		rm -rf tmux/install.sh
		rm -rf tmux/uninstall.sh
		mv -f tmux/scripts-mtk tmux/scripts/
		mv -f tmux/install_mtk.sh tmux/install.sh
		mv -f tmux/uninstall_mtk.sh tmux/uninstall.sh
		tar -zcf tmux.tar.gz tmux
		if [ "$?" = "0" ];then
			echo "build success!"
			mv tmux.tar.gz ..
		fi
		cd ..
		rm -rf ./build
	elif [ "$ME" = "build.sh" ];then
		echo "build tmux for hnd"
		rm -rf ./build
		mkdir -p ./build
		cp -rf ./tmux ./build/
		cd ./build
		echo hnd >tmux/.valid
		rm -rf tmux/scripts-mtk
		rm -rf tmux/install_mtk.sh
		rm -rf tmux/uninstall_mtk.sh
		tar -zcf tmux.tar.gz tmux
		if [ "$?" = "0" ];then
			echo "build success!"
			mv tmux.tar.gz ..
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