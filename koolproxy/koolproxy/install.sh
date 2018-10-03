#! /bin/sh
source $KSROOT/scripts/base.sh
eval `dbus export koolproxy`
mkdir -p /tmp/upload
touch /tmp/upload/kp_log.txt

# stop first
[ "$koolproxy_enable" == "1" ] && sh /koolshare/koolproxy/kp_config.sh stop

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
if [ "`nvram get model`" == "GT-AC5300" ] || [ -n "`nvram get extendno | grep koolshare`" -a "`nvram get productid`" == "RT-AC86U" ];then
	cp -rf /tmp/koolproxy/GT-AC5300/webs/* /koolshare/webs/
	cp -rf /tmp/koolproxy/GT-AC5300/res/* /koolshare/res/
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

# 删除安装包
rm -rf /tmp/koolproxy* >/dev/null 2>&1

[ -z "$koolproxy_mode" ] && dbus set koolproxy_mode=1
[ -z "$koolproxy_acl_default" ] && dbus set koolproxy_acl_default=1

dbus set softcenter_module_koolproxy_install=1
dbus set softcenter_module_koolproxy_version=3.8.3
dbus set koolproxy_version=3.8.3

# restart
[ "$koolproxy_enable" == "1" ] && sh /koolshare/koolproxy/kp_config.sh restart

