#!/bin/sh

MODULE="reboothelper"
VERSION="0.6"
TITLE="重启助手"
DESCRIPTION="解决重启Bug"
HOME_URL="Module_reboothelper.asp"
TAGS="系统 工具"
AUTHOR="Lonlykids"
LINK="https://koolshare.cn/thread-167906-1-1.html"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
