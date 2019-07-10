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
			rm -rf /tmp/ssserver* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/ssserver* >/dev/null 2>&1
		exit 1
	;;
esac

# stop ssserver first
enable=`dbus get ssserver_enable`
if [ "$enable" == "1" ];then
	sh /koolshare/scripts/ssserver_config.sh stop
fi

# cp files
cp -rf /tmp/ssserver/scripts/* /koolshare/scripts/
cp -rf /tmp/ssserver/bin/* /koolshare/bin/
cp -rf /tmp/ssserver/webs/* /koolshare/webs/
cp -rf /tmp/ssserver/res/* /koolshare/res/
cp -rf /tmp/ssserver/init.d/* /koolshare/init.d/
cp -rf /tmp/ssserver/install.sh /koolshare/scripts/uninstall_ssserver.sh
chmod +x /koolshare/scripts/ssserver*
chmod +x /koolshare/bin/ss-server
chmod +x /koolshare/bin/obfs-server
chmod +x /koolshare/init.d/*

# 离线安装用
dbus set ssserver_version="$(cat $DIR/version)"
dbus set softcenter_module_ssserver_version="$(cat $DIR/version)"
dbus set softcenter_module_ssserver_description="ss-server"
dbus set softcenter_module_ssserver_install="1"
dbus set softcenter_module_ssserver_name="ssserver"
dbus set softcenter_module_ssserver_title="ss-server"

# re-enable ssserver
if [ "$enable" == "1" ];then
	sh /koolshare/scripts/ssserver_config.sh
fi

# 完成
echo_date "ss-server插件安装完毕！"
rm -rf /tmp/ssserver* >/dev/null 2>&1
exit 0
