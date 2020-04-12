#! /bin/sh
source /koolshare/scripts/base.sh
eval `dbus export koolproxy`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
module=koolproxy
MODEL=$(nvram get productid)
DIR=$(cd $(dirname $0); pwd)
mkdir -p /tmp/upload
touch /tmp/upload/kp_log.txt

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

# stop koolproxy first
if [ "$koolproxy_enable" == "1" ] && [ -f "/koolshare/koolproxy/kp_config.sh" ];then
	sh /koolshare/koolproxy/kp_config.sh stop
fi

# remove old files, do not remove user.txt incase of upgrade
rm -rf /koolshare/bin/koolproxy >/dev/null 2>&1
rm -rf /koolshare/scripts/KoolProxy* >/dev/null 2>&1
rm -rf /koolshare/webs/Module_koolproxy.asp >/dev/null 2>&1
rm -rf /koolshare/res/icon-koolproxy.png >/dev/null 2>&1
rm -rf /koolshare/koolproxy/*.sh >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/dnsmasq.adblock >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/gen_ca.sh >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/koolproxy_ipset.conf >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/openssl.cnf >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/serial >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/version >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/rules/*.dat >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/rules/daily.txt >/dev/null 2>&1
rm -rf /koolshare/koolproxy/data/rules/koolproxy.txt >/dev/null 2>&1

# copy new files
cd /tmp
mkdir -p /koolshare/koolproxy
mkdir -p /koolshare/koolproxy/data
mkdir -p /koolshare/koolproxy/data/rules

cp -rf /tmp/koolproxy/scripts/* /koolshare/scripts/
cp -rf /tmp/koolproxy/webs/* /koolshare/webs/
cp -rf /tmp/koolproxy/res/* /koolshare/res/
if [ "$ROG" ];then
	cp -rf /tmp/koolproxy/ROG/webs/* /koolshare/webs/
fi
if [ "$TUF" ];then
	cp -rf /tmp/koolproxy/ROG/webs/* /koolshare/webs/
	sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /koolshare/webs/Module_koolproxy.asp >/dev/null 2>&1
fi
if [ ! -f /koolshare/koolproxy/data/rules/user.txt ];then
	cp -rf /tmp/koolproxy/koolproxy /koolshare/
else
	mv /koolshare/koolproxy/data/rules/user.txt /tmp/user.txt.tmp
	cp -rf /tmp/koolproxy/koolproxy /koolshare/
	mv /tmp/user.txt.tmp /koolshare/koolproxy/data/rules/user.txt
fi
cp -f /tmp/koolproxy/uninstall.sh /koolshare/scripts/uninstall_koolproxy.sh
#[ ! -L "/koolshare/bin/koolproxy" ] && ln -sf /koolshare/koolproxy/koolproxy /koolshare/bin/koolproxy
chmod 755 /koolshare/koolproxy/*
chmod 755 /koolshare/koolproxy/data/*
chmod 755 /koolshare/scripts/*

# 创建开机启动文件
find /koolshare/init.d/ -name "*koolproxy*" | xargs rm -rf
[ ! -L "/koolshare/init.d/S98koolproxy.sh" ] && ln -sf /koolshare/koolproxy/kp_config.sh /koolshare/init.d/S98koolproxy.sh
[ ! -L "/koolshare/init.d/N98koolproxy.sh" ] && ln -sf /koolshare/koolproxy/kp_config.sh /koolshare/init.d/N98koolproxy.sh

# 设置默认值
[ -z "$koolproxy_mode" ] && dbus set koolproxy_mode=1
[ -z "$koolproxy_acl_default" ] && dbus set koolproxy_acl_default=1

# 离线安装用
dbus set koolproxy_version="$(cat $DIR/version)"
dbus set softcenter_module_koolproxy_version="$(cat $DIR/version)"
dbus set softcenter_module_koolproxy_install="1"
dbus set softcenter_module_koolproxy_name="koolproxy"
dbus set softcenter_module_koolproxy_title="KidsProtect"
dbus set softcenter_module_koolproxy_description="KP: Kids Protect，互联网内容过滤，保护未成年人上网~"

# restart
if [ "$koolproxy_enable" == "1" ] && [ -f "/koolshare/koolproxy/kp_config.sh" ];then
	sh /koolshare/koolproxy/kp_config.sh restart
fi
# 完成
echo_date "koolproxy插件安装完毕！"
rm -rf /tmp/koolproxy* >/dev/null 2>&1
exit 0
