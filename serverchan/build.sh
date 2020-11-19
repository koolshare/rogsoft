#!/bin/sh

MODULE="serverchan"
VERSION="1.4"
TITLE="serverChan微信推送"
DESCRIPTION="从路由器推送状态及通知的工具"
HOME_URL="Module_serverchan.asp"

# Check and include base
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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
