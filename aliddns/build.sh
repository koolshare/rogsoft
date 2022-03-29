#!/bin/sh

# build script for rogsoft project

MODULE="aliddns"
VERSION="2.2"
TITLE="阿里DDNS"
DESCRIPTION="aliddns"
HOME_URL="Module_aliddns.asp"
TAGS="DDNS"
AUTHOR="kyrios, sadog"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
