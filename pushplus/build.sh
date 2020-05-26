#!/bin/sh

MODULE="pushplus"
VERSION="0.2"
TITLE="pushplus全能推送"
DESCRIPTION="通过pushplus将路由器状态推送到微信上"
HOME_URL="Module_pushplus.asp"

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
