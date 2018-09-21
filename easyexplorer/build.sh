#!/bin/sh

MODULE="easyexplorer"
VERSION=1.3
TITLE="easyexplorer"
DESCRIPTION="EasyExplorer 跨设备文件同步+DLNA流媒体"
HOME_URL=Module_easyexplorer.asp

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here

do_build_result

sh backup.sh $MODULE
