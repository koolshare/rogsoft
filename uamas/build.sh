#!/bin/sh

MODULE="uamas"
VERSION="1.0"
TITLE="Unlock AiMesh"
DESCRIPTION="网件梅林固件解锁AiMesh"
HOME_URL="Module_uamas.asp"
TAGS="系统 工具"
AUTHOR="sadog"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# change to module directory
cd $DIR

# do something here
do_build_result() {
	rm -rf ${MODULE}/.DS_Store
	rm -rf ${MODULE}/*/.DS_Store
	rm -rf ${MODULE}.tar.gz
	
	# add version to the package
	cat > ${MODULE}/version <<-EOF
	${VERSION}
	EOF
	
	tar -zcvf ${MODULE}.tar.gz $MODULE
	local md5value=$(md5sum ${MODULE}.tar.gz | tr " " "\n" | sed -n 1p)
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
	"changelog":"$CHANGELOG",
	"build_date":"$DATE",
	}
	EOF
	#update md5
	python ../softcenter/gen_install.py stage2
}

do_build_result
