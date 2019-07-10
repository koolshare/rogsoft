#!/bin/sh

MODULE="fastd1ck"
VERSION="1.6"
TITLE="迅雷快鸟"
DESCRIPTION="迅雷快鸟，上网必备神器"
HOME_URL="Module_fastd1ck.asp"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
