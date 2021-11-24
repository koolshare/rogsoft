#!/bin/sh

# build script for rogsoft project

MODULE="serverchan"
VERSION="1.4.1"
TITLE="serverChan微信推送"
DESCRIPTION="从路由器推送状态及通知的工具"
HOME_URL="Module_serverchan.asp"
TAGS="推送"
AUTHOR="clang"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
