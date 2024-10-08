#!/bin/sh

# build script for rogsoft project

MODULE="swap"
VERSION="2.9"
TITLE="虚拟内存"
DESCRIPTION="让路由器运行更稳定~"
HOME_URL="Module_swap.asp"
TAGS="USB"
AUTHOR="sadog"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
