#!/bin/sh

# build script for rogsoft project

MODULE="ssserver"
VERSION="1.3"
TITLE="ss-server"
DESCRIPTION="ss-server"
HOME_URL="Module_ssserver.asp"
TAGS="网络 工具"
AUTHOR="sadog"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
