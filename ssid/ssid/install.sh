#! /bin/sh
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
			rm -rf /tmp/ssid* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/ssid* >/dev/null 2>&1
		exit 1
	;;
esac

# 安装
cd /tmp
cp -rf /tmp/ssid/ssid /koolshare/
cp -rf /tmp/ssid/scripts/* //koolshare/scripts/
cp -rf /tmp/ssid/webs/* /koolshare/webs/
cp -rf /tmp/ssid/res/* /koolshare/res/
cd /
chmod 755 /jffs/koolshare/ssid/*
chmod 755 /jffs/koolshare/scripts/ssid*

# 离线安装用
dbus set ssid_version="$(cat $DIR/version)"
dbus set softcenter_module_ssid_version="$(cat $DIR/version)"
dbus set softcenter_module_ssid_description="中文SSID"
dbus set softcenter_module_ssid_install="1"
dbus set softcenter_module_ssid_name="ssid"
dbus set softcenter_module_ssid_title="中文SSID"

# 完成
echo_date "中文SSID插件安装完毕！"
rm -rf /tmp/ssid* >/dev/null 2>&1
exit 0

