#!/bin/sh

MODULE="frpc"
VERSION="1.6"
TITLE="frpc内网穿透"
DESCRIPTION="支持多种协议的内网穿透软件"
HOME_URL="Module_frpc.asp"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result