#!/bin/sh

source /koolshare/scripts/base.sh

fan_control(){
	local rog_fan_level=$(dbus get rog_fan_level)
	case ${rog_fan_level} in
	0)
		_LOG "[软件中心]开机控制：关闭${model}风扇！"
		killall fanCtl
		;;
	1|2|3|4)
		_LOG "[软件中心]开机控制：将${model}风扇调节至${rog_fan_level}挡！"
		killall fanCtl >/dev/null 2>&1
		LD_PRELOAD=/rom/libnvram.so fanCtl ${rog_fan_level} 2>&1 &
		;;
	5|*)
		if [ -z "$(ps | grep fanCtl | grep -v grep)" ];then
			LD_PRELOAD=/rom/libnvram.so fanCtl -d >/dev/null 2>&1 &
		fi
		_LOG "[软件中心]开机控制：保持${model}风扇调节至自动控制策略！"
		;;
	esac
}

start(){
	local model=$(nvram get odmpid)
	local fanct=$(which fanCtl)
	if [ -n "${model}" -a -n "${fanct}" -f "/rom/libnvram.so" ];then
		fan_control
	fi
}

start
