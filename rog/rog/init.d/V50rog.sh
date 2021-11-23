#!/bin/sh

source /koolshare/scripts/base.sh

fan_control(){
	local RFL=$(dbus get rog_fan_level)
	case $RFL in
	0)
		logger "[软件中心]开机控制：关闭${model}风扇！"
		killall fanCtl >/dev/null 2>&1
		LD_PRELOAD=/rom/libnvram.so fanCtl 0 >/dev/null 2>&1 &
		;;
	1|2|3|4)
		logger "[软件中心]开机控制：将${model}风扇调节至${RFL}挡！"
		killall fanCtl  >/dev/null 2>&1
		LD_PRELOAD=/rom/libnvram.so fanCtl $RFL >/dev/null 2>&1 &
		;;
	5|*)
		logger "[软件中心]开机控制：将${model}风扇调节至自动控制策略！"
		killall fanCtl
		LD_PRELOAD=/rom/libnvram.so fanCtl -d >/dev/null 2>&1 &
		;;
	esac
}

start(){
	local model=$(nvram get odmpid)
	local fanct=$(which fanCtl)
	if [ "${model}" == "RAX80" -a -n "${fanct}" -a -f "/rom/libnvram.so" ];then
		fan_control
	fi
}

start
