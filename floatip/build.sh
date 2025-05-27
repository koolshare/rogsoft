#!/bin/sh

# build script for rogsoft project

MODULE="floatip"
VERSION="0.7.1"
TITLE="floatip"
DESCRIPTION="浮动网关"
HOME_URL="Module_floatip.asp"
TAGS="穿透 DDNS"
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
