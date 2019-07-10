#!/bin/sh

MODULE="mdial"
VERSION="1.3"
TITLE="单线多拨"
DESCRIPTION="pppoe单线多拨，带宽提升神器！"
HOME_URL="Module_mdial.asp"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result

