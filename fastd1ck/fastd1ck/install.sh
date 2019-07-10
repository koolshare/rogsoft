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
			rm -rf /tmp/fastd1ck* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/fastd1ck* >/dev/null 2>&1
		exit 1
	;;
esac

# stop fastd1ck first
enable=`dbus get fastd1ck_enable`
if [ "$enable" == "1" ];then
	[ -f "/koolshare/scripts/fastd1ck_config.sh" ] && sh /koolshare/scripts/fastd1ck_config.sh stop
fi

# 安装插件
find /koolshare/init.d/ -name "*fastd1ck*" | xargs rm -rf
find /koolshare/init.d/ -name "*FastD1ck*" | xargs rm -rf
cp -rf /tmp/fastd1ck/scripts/* /koolshare/scripts/
cp -rf /tmp/fastd1ck/webs/* /koolshare/webs/
cp -rf /tmp/fastd1ck/res/* /koolshare/res/
cp -rf /tmp/fastd1ck/uninstall.sh /koolshare/scripts/uninstall_fastd1ck.sh
if [ "`nvram get model`" == "GT-AC5300" ] || [ "`nvram get model`" == "GT-AX11000" ] || [ -n "`nvram get extendno | grep koolshare`" -a "`nvram get productid`" == "RT-AC86U" ];then
	cp -rf /tmp/fastd1ck/ROG/webs/* /koolshare/webs/
fi
chmod +x /koolshare/scripts/fastd1ck*.sh
chmod +x /koolshare/scripts/uninstall_fastd1ck.sh
[ ! -L "/koolshare/init.d/S99fastd1ck.sh" ] && ln -sf /koolshare/scripts/fastd1ck_config.sh /koolshare/init.d/S99fastd1ck.sh

# 离线安装用
dbus set fastd1ck_version="$(cat $DIR/version)"
dbus set softcenter_module_fastd1ck_version="$(cat $DIR/version)"
dbus set softcenter_module_fastd1ck_description="迅雷快鸟，上网必备神器"
dbus set softcenter_module_fastd1ck_install="1"
dbus set softcenter_module_fastd1ck_name="fastd1ck"
dbus set softcenter_module_fastd1ck_title="迅雷快鸟"

# re-enable fastd1ck
if [ "$enable" == "1" ];then
	[ -f "/koolshare/scripts/fastd1ck_config.sh" ] && sh /koolshare/scripts/fastd1ck_config.sh start
fi

# 完成
echo_date "迅雷快鸟插件安装完毕！"
rm -rf /tmp/fastd1ck* >/dev/null 2>&1
exit 0
