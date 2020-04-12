#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
module=ddnsto
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
if [ "$ROG" == "1" ];then
	continue
else
	if [ "$TUF" == "1" ];then
		sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /koolshare/webs/Module_${module}.asp >/dev/null 2>&1
	else
		sed -i '/rogcss/d' /koolshare/webs/Module_${module}.asp >/dev/null 2>&1
	fi
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
