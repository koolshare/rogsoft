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
			rm -rf /tmp/aria2* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/aria2* >/dev/null 2>&1
		exit 1
	;;
esac

#重建 /dev/null
rm /dev/null 
mknod /dev/null c 1 3 
chmod 666 /dev/null

# stop first
aria2_enable=`dbus get aria2_enable`
aria2_version=`dbus get aria2_version`
if [ "$aria2_enable" == "1" ] && [ -f "/koolshare/scripts/aria2_config.sh" ];then
	sh /koolshare/scripts/aria2_config.sh stop
fi

cp -rf /tmp/aria2/bin/* /koolshare/bin/
cp -rf /tmp/aria2/scripts/* /koolshare/scripts/
cp -rf /tmp/aria2/webs/* /koolshare/webs/
cp -rf /tmp/aria2/res/* /koolshare/res/
cp -rf /tmp/aria2/aria2 /koolshare
cp -rf /tmp/aria2/uninstall.sh /koolshare/scripts/uninstall_aria2.sh
if [ "`nvram get model`" == "GT-AC5300" ] || [ "`nvram get model`" == "GT-AX11000" ] || [ -n "`nvram get extendno | grep koolshare`" -a "`nvram get productid`" == "RT-AC86U" ];then
	cp -rf /tmp/aria2/ROG/webs/* /koolshare/webs/
fi
chmod +x /koolshare/bin/*
chmod +x /koolshare/scripts/aria2*.sh
chmod +x /koolshare/scripts/uninstall_aria2.sh
[ ! -L "/koolshare/init.d/M99Aria2.sh" ] && ln -sf /koolshare/scripts/aria2_config.sh /koolshare/init.d/M99Aria2.sh
[ ! -L "/koolshare/init.d/N99Aria2.sh" ] && ln -sf /koolshare/scripts/aria2_config.sh /koolshare/init.d/N99Aria2.sh

#some modify
if [ "$aria2_version" == "1.5" ] || [ "$aria2_version" == "1.4" ] || [ "$aria2_version" == "1.3" ];then
	dbus set aria2_custom=Y2EtY2VydGlmaWNhdGU9L2V0Yy9zc2wvY2VydHMvY2EtY2VydGlmaWNhdGVzLmNydA==
fi

# for offline install
dbus set aria2_version="$(cat $DIR/version)"
dbus set softcenter_module_aria2_version="$(cat $DIR/version)"
dbus set softcenter_module_aria2_install="1"
dbus set softcenter_module_aria2_name="aria2"
dbus set softcenter_module_aria2_title="aria2"
dbus set softcenter_module_aria2_description="linux下载利器"

# re-enable
if [ "$aria2_enable" == "1" ] && [ -f "/koolshare/scripts/aria2_config.sh" ];then
	sh /koolshare/scripts/aria2_config.sh start
fi

# finish
echo_date aria2插件安装完毕！
rm -rf /tmp/aria2* >/dev/null 2>&1
exit 0
