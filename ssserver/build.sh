#!/bin/sh

MODULE="ssserver"
VERSION="1.2"
TITLE="ss-server"
DESCRIPTION="ss-server"
HOME_URL="Module_ssserver.asp"
TAGS="网络 工具"
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
