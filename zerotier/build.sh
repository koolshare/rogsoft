#!/bin/sh

# build script for rogsoft project

MODULE="zerotier"
VERSION="1.5.0"
TITLE="ZeroTier"
DESCRIPTION="ZeroTier 内网穿透"
HOME_URL="Module_zerotier.asp"
TAGS="穿透 VPN"
AUTHOR="sadog"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# before tar
ls -lF ${DIR}/zerotier/lib32|awk '{print $9}'|sed '/^$/d'|sed 's/^/zerotier /g'|sed 's/*$//g' > ${DIR}/zerotier/lib32/.flag_zerotier.txt
ls -lF ${DIR}/zerotier/lib64|awk '{print $9}'|sed '/^$/d'|sed 's/^/zerotier /g'|sed 's/*$//g' > ${DIR}/zerotier/lib64/.flag_zerotier.txt

# do something here
do_build_result
