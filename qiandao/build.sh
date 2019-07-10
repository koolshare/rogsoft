#!/bin/sh

MODULE="qiandao"
VERSION="1.5"
TITLE="自动签到"
DESCRIPTION="自动签到"
HOME_URL="Module_qiandao.asp"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
