#!/bin/sh

MODULE="cfetool"
VERSION="1.2"
TITLE="CFE工具箱"
DESCRIPTION="CFE工具箱，查看CFE信息，改机器为国区"
HOME_URL="Module_cfetool.asp"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
