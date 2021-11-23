#!/bin/sh

MODULE="ngfix"
VERSION="1.8"
TITLE="RAX80 Toolbox"
DESCRIPTION="帮助RAX80刷回网件原厂固件，修复RAX80网件原厂分区"
HOME_URL="Module_ngfix.asp"
TAGS="系统 工具"
AUTHOR="sadog"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result

