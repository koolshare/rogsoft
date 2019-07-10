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
			rm -rf /tmp/easyexplorer* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/easyexplorer* >/dev/null 2>&1
		exit 1
	;;
esac

# stop easyexplorer first
enable=`dbus get easyexplorer_enable`
if [ "$enable" == "1" ];then
	killall	easy-explorer > /dev/null 2>&1
fi

rm -rf /koolshare/init.d/*easyexplorer.sh
cp -rf /tmp/easyexplorer/bin/* /koolshare/bin/
cp -rf /tmp/easyexplorer/scripts/* /koolshare/scripts/
cp -rf /tmp/easyexplorer/webs/* /koolshare/webs/
cp -rf /tmp/easyexplorer/res/* /koolshare/res/
cp -rf /tmp/easyexplorer/uninstall.sh /koolshare/scripts/uninstall_easyexplorer.sh
if [ "`nvram get model`" == "GT-AC5300" ] || [ "`nvram get model`" == "GT-AX11000" ] || [ -n "`nvram get extendno | grep koolshare`" -a "`nvram get productid`" == "RT-AC86U" ];then
	cp -rf /tmp/easyexplorer/ROG/webs/* /koolshare/webs/
fi
chmod +x /koolshare/bin/easy-explorer
chmod +x /koolshare/scripts/*
[ ! -L "/koolshare/init.d/S99easyexplorer.sh" ] && ln -sf /koolshare/scripts/easyexplorer_config.sh /koolshare/init.d/S99easyexplorer.sh
[ ! -L "/koolshare/init.d/N99easyexplorer.sh" ] && ln -sf /koolshare/scripts/easyexplorer_config.sh /koolshare/init.d/N99easyexplorer.sh

# 离线安装用
dbus set easyexplorer_version="$(cat $DIR/version)"
dbus set softcenter_module_easyexplorer_version="$(cat $DIR/version)"
dbus set softcenter_module_easyexplorer_description="易有云 （EasyExplorer） 跨平台文件同步，支持双向同步！"
dbus set softcenter_module_easyexplorer_install="1"
dbus set softcenter_module_easyexplorer_name="easyexplorer"
dbus set softcenter_module_easyexplorer_title="易有云"

# re-enable easyexplorer
if [ "$enable" == "1" ];then
	sh /koolshare/scripts/easyexplorer_config.sh start
fi

# 完成
echo_date "易有云插件安装完毕！"
rm -rf /tmp/easyexplorer* >/dev/null 2>&1
exit 0
