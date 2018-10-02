#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export aliddns`

start_aliddns(){
	cru a aliddns_checker "*/$aliddns_interval * * * * /koolshare/scripts/aliddns_update.sh"
	sh /koolshare/scripts/aliddns_update.sh

	if [ ! -L "/koolshare/init.d/S98Aliddns.sh" ]; then 
		ln -sf /koolshare/scripts/aliddns_config.sh /koolshare/init.d/S98Aliddns.sh
	fi
}

stop_aliddns(){
	jobexist=`cru l|grep aliddns_checker`
	# kill crontab job
	if [ -n "$jobexist" ];then
		sed -i '/aliddns_checker/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
	nvram set ddns_hostname_x=`nvram get ddns_hostname_old`
}

case $ACTION in
start)
	if [ "$aliddns_enable" == "1" ];then
		logger "[软件中心]: 启动阿里DDNS！"
		start_aliddns
	else
		logger "[软件中心]: 阿里DDNS未设置开机启动，跳过！"
	fi
	;;
stop)
	stop_aliddns
	;;
*)
	if [ "$aliddns_enable" == "1" ];then
		start_aliddns
	else
		stop_aliddns
	fi
	http_response "$1"
	;;
esac
