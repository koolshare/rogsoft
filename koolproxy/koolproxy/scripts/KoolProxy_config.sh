#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export koolproxy_`
LOG_FILE=/tmp/upload/kp_log.txt
mkdir -p /tmp/upload
echo "" > $LOG_FILE
http_response "$1"
#==================================================

case $2 in
1)
	if [ "$koolproxy_enable" == "1" ];then
		sh /koolshare/koolproxy/kp_config.sh restart >> $LOG_FILE 2>&1
	else
		sh /koolshare/koolproxy/kp_config.sh stop >> $LOG_FILE 2>&1
	fi
	echo XU6J03M6 >> $LOG_FILE
	;;
esac
