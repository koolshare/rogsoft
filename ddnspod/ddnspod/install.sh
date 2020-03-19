#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)

# 判断路由架构和平台
case $(uname -m) in
	aarch64)
		if [ "`uname -o|grep Merlin`" ] && [ -d "/koolshare" ];then
			echo_date 固件平台【koolshare merlin hnd/axhnd aarch64】符合安装要求，开始安装插件！
		else
			echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的固件平台不能安装！！！
			echo_date 退出安装！
			rm -rf /tmp/ddnspod* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/ddnspod* >/dev/null 2>&1
		exit 1
	;;
esac

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
rm -rf /tmp/ddnspod* >/dev/null 2>&1
exit 0
