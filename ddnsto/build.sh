#!/bin/sh

# build script for rogsoft project

MODULE="ddnsto"
VERSION="3.0.5"
TITLE="ddnsto"
DESCRIPTION="ddnsto内网穿透"
HOME_URL="Module_ddnsto.asp"
TAGS="穿透 DDNS"
AUTHOR="xiaobao"
LINK="https://www.ddnsto.com"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
