#!/bin/bash

# build script for rogsoft project

MODULE="center"
VERSION="2.0"
TITLE="软件中心一键切换"
DESCRIPTION="koolcenter/softcenter 一键来回切换！"
HOME_URL="Module_center.asp"
TAGS="辅助 工具"
AUTHOR="sadog"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# prepare, copy koolcenter necessary file
rm -rf $DIR/center/res/soft-v*

# get VERSION
soft_ver=$(cat $DIR/../softcenter/build.sh |grep "VERSION=" | cut -d "=" -f2)
kool_ver=$(cat $DIR/../koolcenter/build.sh |grep "VERSION=" | cut -d "=" -f2)

soft_folder=$(dirname $DIR/../koolcenter/softcenter/res/soft-v*/assets)

cp $DIR/../koolcenter/softcenter/webs/Module_Softcenter.asp $DIR/center/webs/Module_Softcenter_new.asp
cp -rf $soft_folder $DIR/center/res/
cp $DIR/../koolcenter/softcenter/scripts/ks_home_status.sh $DIR/center/scripts/
echo ${kool_ver} >$DIR/center/.soft_ver_new

cp $DIR/../softcenter/softcenter/webs/Module_Softcenter.asp $DIR/center/webs/Module_Softcenter_old.asp
cp $DIR/../softcenter/softcenter/webs/Module_Softsetting.asp $DIR/center/webs/Module_Softsetting.asp
echo ${soft_ver} >$DIR/center/.soft_ver_old

cp $DIR/../softcenter/softcenter/init.d/* $DIR/center/init.d/

cp $DIR/../softcenter/softcenter/res/softcenter_*.css $DIR/center/res/

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
