#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export reboothelper`

create_Cron(){
	cru a reboothelper_schedule "$reboothelper_minute $reboothelper_hour $reboothelper_day * $reboothelper_week echo b > /proc/sysrq-trigger"
	[ ! -L "/koolshare/init.d/S99Reboothelper.sh" ] && ln -sf /koolshare/scripts/reboothelper_config.sh /koolshare/init.d/S99Reboothelper.sh
}

delete_Cron(){
	jobexist=`cru l | grep reboothelper_schedule`
	# kill crontab job
	[ -n "$jobexist" ] && cru d reboothelper_schedule
}

case $1 in
start)
	if [ "$reboothelper_enable" == "1" ];then
		logger "[软件中心]: 添加自动重启任务"
		create_Cron
	fi
	;;
stop)
	delete_Cron
	;;
2)
	if [ "$reboothelper_enable" == "1" ];then
		logger "[软件中心]: 添加自动重启任务"
		create_Cron
	else
		delete_Cron
	fi
	http_response "$1"
	;;
esac