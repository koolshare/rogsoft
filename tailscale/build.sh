#!/bin/sh

# build script for rogsoft project

MODULE="tailscale"
VERSION="1.5"
TITLE="Tailscale"
DESCRIPTION="基于wiregurad协议的零配置内网穿透安全组网工具！"
HOME_URL="Module_tailscale.asp"
TAGS="穿透 VPN"
AUTHOR="sadog"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
