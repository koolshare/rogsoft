#!/bin/sh

MODULE="koolproxy"
VERSION="3.8.4.1"
TITLE="KidsProtect"
DESCRIPTION="KP: Kids Protect，互联网内容过滤，保护未成年人上网~"
HOME_URL="Module_koolproxy.asp"

#  # get latest binary
#  cd koolproxy/koolproxy/
#  mkdir -p data
#  mkdir -p data/rules
#  wget https://koolproxy.com/downloads/arm
#  if [ "$?" == "0" ];then
#  	mv arm koolproxy && chmod +x koolproxy
#  else
#  	rm -rf arm
#  fi
#  
#  # get latest rules
#  cd data/rules
#  rm -rf *
#  wget https://kprule.com/koolproxy.txt
#  wget https://kprule.com/daily.txt
#  wget https://kprule.com/kp.dat
#  wget https://kprule.com/user.txt
#  
#  cd ../../../..
# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
