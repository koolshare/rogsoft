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
			rm -rf /tmp/ddnsto* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/ddnsto* >/dev/null 2>&1
		exit 1
	;;
esac

# stop ddnsto first
enable=`dbus get ddnsto_enable`
if [ -n "$enable" ];then
	killall ddnsto >/dev/null 2>&1
fi

# 安装插件
rm -rf /koolshare/init.d/S70ddnsto.sh
cp -rf /tmp/ddnsto/bin/* /koolshare/bin/
cp -rf /tmp/ddnsto/scripts/* /koolshare/scripts/
cp -rf /tmp/ddnsto/webs/* /koolshare/webs/
cp -rf /tmp/ddnsto/res/* /koolshare/res/
cp -rf /tmp/ddnsto/uninstall.sh /koolshare/scripts/uninstall_ddnsto.sh
if [ "`nvram get model`" == "GT-AC5300" ] || [ "`nvram get model`" == "GT-AX11000" ] || [ -n "`nvram get extendno | grep koolshare`" -a "`nvram get productid`" == "RT-AC86U" ];then
	cp -rf /tmp/$MODULE/ROG/webs/* /koolshare/webs/
fi
chmod +x /koolshare/bin/ddnsto
chmod +x /koolshare/scripts/ddnsto*
chmod +x /koolshare/scripts/uninstall_ddnsto.sh
[ ! -L "/koolshare/init.d/S70ddnsto.sh" ] && ln -sf /koolshare/scripts/ddnsto_config.sh /koolshare/init.d/S70ddnsto.sh

# 离线安装用
dbus set ddnsto_version="$(cat $DIR/version)"
dbus set softcenter_module_ddnsto_version="$(cat $DIR/version)"
dbus set ddnsto_title="DDNSTO远程控制"
dbus set ddnsto_client_version=`/koolshare/bin/ddnsto -v`
dbus set softcenter_module_ddnsto_install="1"
dbus set softcenter_module_ddnsto_name="ddnsto"
dbus set softcenter_module_ddnsto_title="ddnsto远程控制"
dbus set softcenter_module_ddnsto_description="ddnsto内网穿透"

# re-enable ddnsto
if [ "$enable" == "1" ];then
	sh /koolshare/scripts/ddnsto_config.sh start
fi

echo_date "ddnsto插件安装完毕！"
rm -rf /tmp/ddnsto* >/dev/null 2>&1
exit 0
