#!/bin/sh

# build script for rogsoft project

MODULE="virtualhere"
VERSION="1.0"
TITLE="virtualhere"
DESCRIPTION="usb over ip"
AUTHOR="jeremy"
HOME_URL="Module_virtualhere.asp"
TAGS="辅助 工具"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
