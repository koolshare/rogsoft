#!/bin/sh

# build script for rogsoft project

MODULE="sftpserver"
VERSION="1.4"
TITLE="Sftp Server"
DESCRIPTION="Sftp Server"
HOME_URL="Module_sftpserver.asp"
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
		echo "build sftpserver for mtk"
		rm -rf ./build
		mkdir -p ./build
		cp -rf ./sftpserver ./build/
		cd ./build
		echo mtk >sftpserver/.valid
		rm -rf sftpserver/scripts
		rm -rf sftpserver/install.sh
		rm -rf sftpserver/uninstall.sh
		mv -f sftpserver/scripts-mtk sftpserver/scripts/
		mv -f sftpserver/install_mtk.sh sftpserver/install.sh
		mv -f sftpserver/uninstall_mtk.sh sftpserver/uninstall.sh
		tar -zcf sftpserver.tar.gz sftpserver
		if [ "$?" = "0" ];then
			echo "build success!"
			mv sftpserver.tar.gz ..
		fi
		cd ..
		rm -rf ./build
	elif [ "$ME" = "build.sh" ];then
		echo "build sftpserver for hnd"
		rm -rf ./build
		mkdir -p ./build
		cp -rf ./sftpserver ./build/
		cd ./build
		echo hnd >sftpserver/.valid
		rm -rf sftpserver/scripts-mtk
		rm -rf sftpserver/install_mtk.sh
		rm -rf sftpserver/uninstall_mtk.sh
		tar -zcf sftpserver.tar.gz sftpserver
		if [ "$?" = "0" ];then
			echo "build success!"
			mv sftpserver.tar.gz ..
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