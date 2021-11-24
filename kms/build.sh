#!/bin/sh

# build script for rogsoft project

MODULE="kms"
VERSION="1.6"
TITLE="系统工具"
DESCRIPTION="kms"
AUTHOR="anonymous"
HOME_URL="Module_kms.asp"
TAGS="辅助 工具"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
