#!/bin/sh

MODULE="wifiboost"
VERSION="3.0"
TITLE="wifi boost"
DESCRIPTION="wifi boost 路由器功率增强，强过澳大利亚"
HOME_URL="Module_wifiboost.asp"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
