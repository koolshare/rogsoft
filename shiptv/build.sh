#!/bin/sh

MODULE="shiptv"
VERSION="1.1"
TITLE="上海电信IPTV"
DESCRIPTION="上海电信IPTV，4K IPTV 一键开启"
HOME_URL="Module_shiptv.asp"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
