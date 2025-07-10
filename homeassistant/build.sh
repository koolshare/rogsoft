#!/bin/sh

# build script for rogsoft project

MODULE="homeassistant"
VERSION="1.1.4"
TITLE="HA智能家居"
DESCRIPTION="HomeAssistant智能家居，统一管理以及编排你的家庭智能设备，让生活更智慧。"
HOME_URL="Module_homeassistant.asp"
TAGS="工具"
AUTHOR="xiaobao"
LINK="https://www.home-assistant.io/"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
