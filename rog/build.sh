#!/bin/sh

# build script for rogsoft project

MODULE="rog"
VERSION="4.7"
TITLE="ROG工具箱"
DESCRIPTION="一些小功能的插件"
HOME_URL="Module_rog.asp"
TAGS="系统 工具"
AUTHOR="sadog"
LINK="https://koolshare.cn/thread-179110-1-5.html"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
