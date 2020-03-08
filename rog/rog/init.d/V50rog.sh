#!/bin/sh

alias echo_date='echo $(date +%Y年%m月%d日\ %X)'
source /koolshare/scripts/base.sh
eval $(dbus export rog)
model=$(nvram get odmpid)

fan_control(){
	case $rog_fan_level in
	0)
		logger "[软件中心]开机控制：关闭${model}风扇！"
		killall fanCtl
		;;
	1|2|3|4)
		logger "[软件中心]开机控制：将${model}风扇调节至${rog_fan_level}挡！"
		killall fanCtl
		LD_PRELOAD=/rom/libnvram.so fanCtl $rog_fan_level 2>&1 &
		;;
	5|*)
		if [ -z "$(ps | grep fanCtl | grep -v grep)" ];then
			LD_PRELOAD=/rom/libnvram.so fanCtl -d >/dev/null 2>&1 &
		fi
		logger "[软件中心]开机控制：保持${model}风扇调节至自动控制策略！"
		;;
	esac
}

case $1 in
start)
	if [ -n "$model" ];then
		fan_control
	fi
	;;
esac
