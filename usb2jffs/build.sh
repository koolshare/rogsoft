#!/bin/sh

MODULE="usb2jffs"
VERSION="1.9.8"
TITLE="USB2JFFS"
DESCRIPTION="使用U盘轻松挂载jffs"
HOME_URL="Module_usb2jffs.asp"
TAGS="USB"
AUTHOR="sadog"

# Check and include base
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ "$MODULE" == "" ]; then
	echo "module not found"
	exit 1
fi

if [ -f "$DIR/$MODULE/$MODULE/install.sh" ]; then
	echo "install script not found"
	exit 2
fi

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
