#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)

# 判断路由架构和平台
case $(uname -m) in
	aarch64)
		if [ "$(uname -o|grep Merlin)" ] && [ -d "/koolshare" ];then
			echo_date 固件平台【koolshare merlin hnd/axhnd aarch64】符合安装要求，开始安装插件！
		else
			echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的固件平台不能安装！！！
			echo_date 退出安装！
			rm -rf /tmp/aliddns* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/aliddns* >/dev/null 2>&1
		exit 1
	;;
esac

# stop aliddns first
enable=$(dbus get aliddns_enable)
if [ "$enable" == "1" ]; then
	sh /koolshare/scripts/aliddns_config.sh stop
fi

# delete some files
rm -rf /koolshare/init.d/*aliddns.sh

# install
cp -rf /tmp/aliddns/scripts/* /koolshare/scripts/
cp -rf /tmp/aliddns/webs/* /koolshare/webs/
cp -rf /tmp/aliddns/res/* /koolshare/res/
cp -rf /tmp/aliddns/uninstall.sh /koolshare/scripts/uninstall_aliddns.sh
chmod +x /koolshare/scripts/aliddns*
chmod +x /koolshare/init.d/*
if [ "$(nvram get model)" == "GT-AC5300" ] || [ "$(nvram get model)" == "GT-AX11000" ] || [ -n "$(nvram get extendno | grep koolshare)" -a "$(nvram get productid)" == "RT-AC86U" ];then
	continue
else
	sed -i '/rogcss/d' /koolshare/webs/Module_aliddns.asp >/dev/null 2>&1
fi
[ ! -L "/koolshare/init.d/S98Aliddns.sh" ] && ln -sf /koolshare/scripts/aliddns_config.sh /koolshare/init.d/S98Aliddns.sh

# 离线安装需要向skipd写入安装信息
dbus set aliddns_version="$(cat $DIR/version)"
dbus set softcenter_module_aliddns_version="$(cat $DIR/version)"
dbus set softcenter_module_aliddns_install="1"
dbus set softcenter_module_aliddns_name="aliddns"
dbus set softcenter_module_aliddns_title="阿里DDNS"
dbus set softcenter_module_aliddns_description="aliddns"

# re-enable aliddns
if [ "$enable" == "1" ];then
	sh /koolshare/scripts/aliddns_config.sh ks 1
fi

# 完成
echo_date 阿里ddns插件安装完毕！
rm -rf /tmp/aliddns* >/dev/null 2>&1
exit 0
