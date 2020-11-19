#!/bin/sh

MODULE="easyexplorer"
VERSION="2.4.1"
TITLE="易有云"
DESCRIPTION="易有云 （EasyExplorer） 跨平台文件同步，支持双向同步！"
HOME_URL="Module_easyexplorer.asp"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
