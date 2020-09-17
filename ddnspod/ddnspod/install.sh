#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
module=cfddns
DIR=$(cd $(dirname $0); pwd)

# 获取固件类型
_get_type() {
	local FWTYPE=$(nvram get extendno|grep koolshare)
	if [ -d "/koolshare" ];then
		if [ -n $FWTYPE ];then
			echo "koolshare官改固件"
		else
			echo "koolshare梅林改版固件"
		fi
	else
		if [ "$(uname -o|grep Merlin)" ];then
			echo "梅林原版固件"
		else
			echo "华硕官方固件"
		fi
	fi
}

exit_install(){
	local state=$1
	case $state in
		1)
			echo_date "本插件适用于适用于【koolshare 梅林改/官改 hnd/axhnd/axhnd.675x】固件平台，你的固件平台不能安装！！！"
			echo_date "本插件支持机型/平台：https://github.com/koolshare/rogsoft#rogsoft"
			echo_date "退出安装！"
			rm -rf /tmp/${module}* >/dev/null 2>&1
			exit 1
			;;
		0|*)
			rm -rf /tmp/${module}* >/dev/null 2>&1
			exit 0
			;;
	esac
}

# 判断路由架构和平台
case $(uname -m) in
	aarch64)
		if [ "$(uname -o|grep Merlin)" -a -d "/koolshare" ];then
			echo_date 机型：$MODEL $(_get_type) 符合安装要求，开始安装插件！
		else
			exit_install 1
		fi
		;;
	armv7l)
		if [ "$MODEL" == "TUF-AX3000" -o "$MODEL" == "RT-AX82U" -o "$MODEL" == "RT-AX95Q" -o "$MODEL" == "RT-AX56_XD4" ] && [ -d "/koolshare" ];then
			echo_date 机型：$MODEL $(_get_type) 符合安装要求，开始安装插件！
		else
			exit_install 1
		fi
		;;
	*)
		exit_install 1
	;;
esac

if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ -n "$(nvram get extendno | grep koolshare)" -a "$MODEL" == "RT-AC86U" ];then
	# 官改固件，骚红皮肤
	ROG=1
fi

if [ "$MODEL" == "TUF-AX3000" ];then
	# 官改固件，橙色皮肤
	TUF=1
fi

# stop ddnspod first
enable=`dbus get ddnspod_enable`
if [ "$enable" == "1" ] && [ -f "/koolshare/scripts/ddnspod_config.sh" ];then
	sh /koolshare/scripts/ddnspod_config.sh stop
fi

# cp files
cp -rf /tmp/ddnspod/scripts/* /koolshare/scripts/
cp -rf /tmp/ddnspod/webs/* /koolshare/webs/
cp -rf /tmp/ddnspod/res/* /koolshare/res/
cp -rf /tmp/ddnspod/uninstall.sh /koolshare/scripts/uninstall_ddnspod.sh
chmod +x /koolshare/scripts/ddnspod*
[ ! -L "/koolshare/init.d/S99ddnspod.sh" ] && ln -sf /koolshare/scripts/ddnspod_config.sh /koolshare/init.d/S99ddnspod.sh

# 离线安装用
dbus set ddnspod_version="$(cat $DIR/version)"
dbus set softcenter_module_ddnspod_version="$(cat $DIR/version)"
dbus set softcenter_module_ddnspod_description="ddnspod"
dbus set softcenter_module_ddnspod_install="1"
dbus set softcenter_module_ddnspod_name="ddnspod"
dbus set softcenter_module_ddnspod_title="ddnspod"

# re-enable ddnspod
if [ "$enable" == "1" ] && [ -f "/koolshare/scripts/ddnspod_config.sh" ];then
	sh /koolshare/scripts/ddnspod_config.sh start
fi

echo_date "ddnspod插件安装完毕！"
exit_install
