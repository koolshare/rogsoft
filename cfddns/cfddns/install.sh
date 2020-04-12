#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
module=cfddns
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
find /koolshare/init.d/ -name "*cfddns*" | xargs rm -rf
cp -rf /tmp/cfddns/scripts/* /koolshare/scripts/
cp -rf /tmp/cfddns/webs/* /koolshare/webs/
cp -rf /tmp/cfddns/res/* /koolshare/res/
cp -rf /tmp/cfddns/uninstall.sh /koolshare/scripts/uninstall_cfddns.sh
if [ "$ROG" == "1" ];then
	cp -rf /tmp/cfddns/ROG/webs/* /koolshare/webs/
fi
if [ "$TUF" == "1" ];then
	cp -rf /tmp/cfddns/ROG/webs/* /koolshare/webs/
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /koolshare/webs/Module_cfddns.asp >/dev/null 2>&1
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
remove_install_file
exit 0
