#!/bin/sh

# build script for rogsoft project

MODULE="center"
VERSION="1.4"
TITLE="软件中心一键切换"
DESCRIPTION="koolcenter/softcenter 一键来回切换！"
HOME_URL="Module_center.asp"
TAGS="辅助 工具"
AUTHOR="sadog"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
