#!/bin/sh

source /koolshare/scripts/base.sh

if [ ! -f "/tmp/ks_wanstart_flag" ];then
	touch /tmp/ks_wanstart_flag
fi
