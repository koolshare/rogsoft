#!/bin/sh

# build script for rogsoft project

MODULE="pushplus"
VERSION="0.4"
TITLE="pushplus全能推送"
DESCRIPTION="通过pushplus将路由器状态推送到微信上"
HOME_URL="Module_pushplus.asp"
TAGS="推送"
AUTHOR="囍冯总囍"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
