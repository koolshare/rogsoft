#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
module=reboothelper
DIR=$(cd $(dirname $0); pwd)

remove_install_file(){
	rm -rf /tmp/${module}* >/dev/null 2>&1
}

# 判断路由架构和平台
case $(uname -m) in
	aarch64)
		if [ "$(uname -o|grep Merlin)" -a -d "/koolshare" ];then
			echo_date 固件平台【koolshare merlin hnd/axhnd aarch64】符合安装要求，开始安装插件！
		else
			echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的固件平台不能安装！！！
			echo_date 退出安装！
			remove_install_file
			exit 1
		fi
		;;
	armv7l)
		if [ "$MODEL" == "TUF-AX3000" -a -d "/koolshare" ];then
			echo_date 固件TUF-AX3000 koolshare官改固件符合安装要求，开始安装插件！
		else
			echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的固件平台不能安装！！！
			echo_date 退出安装！
			remove_install_file
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		remove_install_file
		exit 1
	;;
esac

if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ -n "$(nvram get extendno | grep koolshare)" -a "$MODEL" == "RT-AC86U" ];then
	# 官改固件，骚红皮肤
	ROG=1
fi

if [ "$MODEL" == "TUF-AX3000" ];then
	# 官改固件，橙色皮肤
	TUF=1
fi

# 安装插件
cp -rf /tmp/reboothelper/scripts/* /koolshare/scripts/
cp -rf /tmp/reboothelper/webs/* /koolshare/webs/
cp -rf /tmp/reboothelper/res/* /koolshare/res/
cp -rf /tmp/reboothelper/uninstall.sh /koolshare/scripts/uninstall_reboothelper.sh

chmod +x /koolshare/scripts/reboothelper*
chmod +x /koolshare/scripts/uninstall_reboothelper.sh
[ -L "/koolshare/init.d/S99Reboothelper.sh" ] && rm -rf /koolshare/init.d/S99Reboothelper.sh
[ ! -L "/koolshare/init.d/V99Reboothelper.sh" ] && ln -sf /koolshare/scripts/reboothelper_config.sh /koolshare/init.d/V99Reboothelper.sh
chmod +x /koolshare/init.d/*

# 离线安装用
dbus set reboothelper_version="$(cat $DIR/version)"
dbus set softcenter_module_reboothelper_version="$(cat $DIR/version)"
dbus set softcenter_module_reboothelper_description="解决重启Bug"
dbus set softcenter_module_reboothelper_install="1"
dbus set softcenter_module_reboothelper_name="reboothelper"
dbus set softcenter_module_reboothelper_title="重启助手"

# 完成
echo_date "重启助手安装完毕！"
rm -rf /tmp/reboothelper* >/dev/null 2>&1
exit 0
