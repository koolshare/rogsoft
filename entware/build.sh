#!/bin/sh

MODULE="entware"
VERSION="1.3"
TITLE="Entware"
DESCRIPTION="轻松安装/管理Entware环境"
HOME_URL="Module_entware.asp"
TAGS="Entware USB"
AUTHOR="sadog"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
