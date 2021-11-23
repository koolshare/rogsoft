#!/bin/sh

MODULE="softether"
VERSION="1.9"
TITLE="SoftEther_VPN_Server"
DESCRIPTION="VPN全家桶, ver 4.29 build 9680"
HOME_URL="Module_softether.asp"
TAGS="网络 VPN"
AUTHOR="sadog"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
