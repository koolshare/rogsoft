#!/bin/sh

MODULE="center"
VERSION="1.1"
TITLE="koolcenter 一键切换"
DESCRIPTION="Node.js"
HOME_URL="koolcenter → softcenter 一键切换！"
TAGS="辅助 工具"
AUTHOR="xiaobao"
LINK="https://www.ddnsto.com"

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
