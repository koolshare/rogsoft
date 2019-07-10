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
			rm -rf /tmp/mdial* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/mdial* >/dev/null 2>&1
		exit 1
	;;
esac

# stop mdial first
enable=`dbus get mdial_enable`
if [ "$enable" == "1" ] && [ -f "/koolshare/scripts/mdial_config.sh" ];then
	sh /koolshare/scripts/mdial_config.sh stop
fi

# 安装插件
find /koolshare/init.d/ -name "*mdial*" | xargs rm -rf
find /koolshare/init.d/ -name "*mdial*" | xargs rm -rf
cp -rf /tmp/mdial/scripts/* /koolshare/scripts/
cp -rf /tmp/mdial/webs/* /koolshare/webs/
cp -rf /tmp/mdial/res/* /koolshare/res/
cp -rf /tmp/mdial/uninstall.sh /koolshare/scripts/uninstall_mdial.sh
if [ "`nvram get model`" == "GT-AC5300" ] || [ "`nvram get model`" == "GT-AX11000" ] || [ -n "`nvram get extendno | grep koolshare`" -a "`nvram get productid`" == "RT-AC86U" ];then
	cp -rf /tmp/mdial/ROG/webs/* /koolshare/webs/
fi
chmod +x /koolshare/scripts/mdial*.sh
chmod +x /koolshare/scripts/uninstall_mdial.sh
[ ! -L "/koolshare/init.d/S10mdial.sh" ] && ln -sf /koolshare/scripts/mdial_config.sh /koolshare/init.d/S10mdial.sh

# 离线安装用
dbus set mdial_version="$(cat $DIR/version)"
dbus set softcenter_module_mdial_version="$(cat $DIR/version)"
dbus set softcenter_module_mdial_description="pppoe单线多拨，带宽提升神器！"
dbus set softcenter_module_mdial_install="1"
dbus set softcenter_module_mdial_name="mdial"
dbus set softcenter_module_mdial_title="单线多拨"

# re-enable mdial
if [ "$enable" == "1" ] && [ -f "/koolshare/scripts/mdial_config.sh" ];then
	[ -f "/koolshare/scripts/mdial_config.sh" ] && sh /koolshare/scripts/mdial_config.sh start
fi

# 完成
echo_date "frpc内网穿透插件安装完毕！"
rm -rf /tmp/mdial* >/dev/null 2>&1
exit 0
