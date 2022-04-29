#!/bin/sh
source /koolshare/scripts/base.sh
eval $(dbus export rog)

fan_control(){
	local RFL=$rog_fan_level
	case $rog_fan_level in
	0)
		logger "[软件中心]手动控制：关闭${model}风扇！"
		killall fanCtl >/dev/null 2>&1
		LD_PRELOAD=/rom/libnvram.so fanCtl 0 >/dev/null 2>&1 &
		;;
	1|2|3|4)
		logger "[软件中心]手动控制：将${model}风扇调节至${rog_fan_level}挡！"
		killall fanCtl >/dev/null 2>&1
		LD_PRELOAD=/rom/libnvram.so fanCtl $rog_fan_level >/dev/null 2>&1 &
		;;
	5|*)
		logger "[软件中心]手动控制：将${model}风扇调节至自动控制策略！"
		killall fanCtl >/dev/null 2>&1
		LD_PRELOAD=/rom/libnvram.so fanCtl -d >/dev/null 2>&1 &
		;;
	esac
}

case $2 in
1)
	# mem clean
	sync
	echo 1 > /proc/sys/vm/drop_caches
	http_response "$1"
	;;
2)
	# fan control
	http_response "$1"
	fan_control
	;;
esac
