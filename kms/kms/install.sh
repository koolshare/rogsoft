#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
module=kms
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

# stop kms first
enable=`dbus get kms_enable`
if [ "$enable" == "1" ];then
	sh /koolshare/scripts/kms.sh stop
fi

# 安装插件
cp -rf /tmp/kms/scripts/* /koolshare/scripts/
cp -rf /tmp/kms/bin/* /koolshare/bin/
cp -rf /tmp/kms/webs/* /koolshare/webs/
cp -rf /tmp/kms/res/* /koolshare/res/
chmod +x /koolshare/scripts/kms*
chmod +x /koolshare/bin/vlmcsd

# 离线安装用
dbus set kms_version="$(cat $DIR/version)"
dbus set softcenter_module_kms_version="$(cat $DIR/version)"
dbus set softcenter_module_kms_install="1"
dbus set softcenter_module_kms_name="kms"
dbus set softcenter_module_kms_title="系统工具"
dbus set softcenter_module_kms_description="kms"

# re-enable kms
if [ "$enable" == "1" ];then
	sh /koolshare/scripts/kms.sh start
fi

# 完成
echo_date "kms插件安装完毕！"
remove_install_file
exit 0
