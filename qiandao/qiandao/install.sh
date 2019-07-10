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
			rm -rf /tmp/qiandao* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/qiandao* >/dev/null 2>&1
		exit 1
	;;
esac

# 安装插件
cd /tmp
cp -rf /tmp/qiandao/qiandao /koolshare/
cp -rf /tmp/qiandao/res/* /koolshare/res/
cp -rf /tmp/qiandao/scripts/* /koolshare/scripts/
cp -rf /tmp/qiandao/webs/* /koolshare/webs/
cp -rf /tmp/qiandao/uninstall.sh /koolshare/scripts/uninstall_qiandao.sh
if [ "`nvram get model`" == "GT-AC5300" ] || [ "`nvram get model`" == "GT-AX11000" ] || [ -n "`nvram get extendno | grep koolshare`" -a "`nvram get productid`" == "RT-AC86U" ];then
	cp -rf /tmp/qiandao/ROG/webs/* /koolshare/webs/
fi
rm -rf /koolshare/init.d/*qiandao.sh
[ ! -L "/koolshare/init.d/S99qiandao.sh" ] && ln -sf /koolshare/scripts/qiandao_config.sh /koolshare/init.d/S99qiandao.sh
chmod 755 /koolshare/qiandao/*
chmod 755 /koolshare/scripts/qiandao*
dbus set qiandao_action="2"

# 离线安装用
dbus set qiandao_version="$(cat $DIR/version)"
dbus set softcenter_module_qiandao_version="$(cat $DIR/version)"
dbus set softcenter_module_qiandao_description="自动签到"
dbus set softcenter_module_qiandao_install="1"
dbus set softcenter_module_qiandao_name="qiandao"
dbus set softcenter_module_qiandao_title="自动签到"

# 完成
echo_date "自动签到插件安装完毕！"
rm -rf /tmp/qiandao* >/dev/null 2>&1
exit 0
