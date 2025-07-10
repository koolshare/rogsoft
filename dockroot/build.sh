#!/bin/sh

# build script for rogsoft project

MODULE="dockroot"
VERSION="1.20.0"
TITLE="dockroot"
DESCRIPTION="轻量版Docker"
HOME_URL="Module_dockroot.asp"
TAGS="系统"
AUTHOR="xiaobao"
LINK="https://www.asusgo.com"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
