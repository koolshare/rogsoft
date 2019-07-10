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
			rm -rf /tmp/cfddns* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/cfddns* >/dev/null 2>&1
		exit 1
	;;
esac

# 安装插件
find /koolshare/init.d/ -name "*cfddns*" | xargs rm -rf
cp -rf /tmp/cfddns/scripts/* /koolshare/scripts/
cp -rf /tmp/cfddns/webs/* /koolshare/webs/
cp -rf /tmp/cfddns/res/* /koolshare/res/
cp -rf /tmp/cfddns/uninstall.sh /koolshare/scripts/uninstall_cfddns.sh
if [ "`nvram get model`" == "GT-AC5300" ] || [ "`nvram get model`" == "GT-AX11000" ] || [ -n "`nvram get extendno | grep koolshare`" -a "`nvram get productid`" == "RT-AC86U" ];then
	cp -rf /tmp/cfddns/ROG/webs/* /koolshare/webs/
fi
chmod +x /koolshare/scripts/cfddns*.sh
chmod +x /koolshare/scripts/uninstall_cfddns.sh
[ ! -L "/koolshare/init.d/S99cfddns.sh" ] && ln -sf /koolshare/scripts/cfddns_config.sh /koolshare/init.d/S99cfddns.sh

# 离线安装用
dbus set cfddns_version="$(cat $DIR/version)"
dbus set softcenter_module_cfddns_version="$(cat $DIR/version)"
dbus set softcenter_module_cfddns_description="CloudFlare DDNS"
dbus set softcenter_module_cfddns_install="1"
dbus set softcenter_module_cfddns_name="cfddns"
dbus set softcenter_module_cfddns_title="CloudFlare DDNS"

# 完成
echo_date "CloudFlare DDNS插件安装完毕！"
rm -rf /tmp/cfddns* >/dev/null 2>&1
exit 0
