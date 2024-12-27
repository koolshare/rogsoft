#!/bin/sh

# build script for rogsoft project

MODULE="routerhook"
VERSION="1.3"
TITLE="RouterHook事件回调"
DESCRIPTION="从路由器推送状态及通知的工具"
HOME_URL="Module_routerhook.asp"
TAGS="推送"
AUTHOR="囍冯总囍"
LINK="https://koolshare.cn/thread-178114-1-1.html"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
