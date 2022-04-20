#!/bin/sh

# build script for rogsoft project

MODULE="center"
VERSION="1.6"
TITLE="软件中心一键切换"
DESCRIPTION="koolcenter/softcenter 一键来回切换！"
HOME_URL="Module_center.asp"
TAGS="辅助 工具"
AUTHOR="sadog"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# prepare, copy koolcenter necessary file
rm -rf $DIR/center/res/soft-v*

soft_folder=$(dirname $DIR/../koolcenter/softcenter/res/soft-v*/assets)

cp $DIR/../koolcenter/softcenter/webs/Module_Softcenter.asp $DIR/center/webs/Module_Softcenter_new.asp
cp -rf $soft_folder $DIR/center/res/
cp $DIR/../koolcenter/softcenter/scripts/ks_home_status.sh $DIR/center/scripts/
cp $DIR/../koolcenter/softcenter/.soft_ver $DIR/center/.soft_ver_new

cp $DIR/../softcenter/softcenter/webs/Module_Softcenter.asp $DIR/center/webs/Module_Softcenter_old.asp
cp $DIR/../softcenter/softcenter/webs/Module_Softsetting.asp $DIR/center/webs/Module_Softsetting.asp
cp $DIR/../softcenter/softcenter/.soft_ver $DIR/center/.soft_ver_old

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
