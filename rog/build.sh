#!/bin/sh

MODULE="rog"
VERSION="3.4"
TITLE="ROG工具箱"
DESCRIPTION="一些小功能的插件"
HOME_URL="Module_rog.asp"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
