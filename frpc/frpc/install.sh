#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
frpc_enable=`dbus get frpc_enable`

if [ "$frpc_enable" == "1" ];then
	killall frpc
fi

cp -rf /tmp/frpc/bin/* /koolshare/bin/
cp -rf /tmp/frpc/scripts/* /koolshare/scripts/
cp -rf /tmp/frpc/webs/* /koolshare/webs/
cp -rf /tmp/frpc/res/* /koolshare/res/
cp -rf /tmp/frpc/uninstall.sh /koolshare/scripts/uninstall_frpc.sh
if [ "`nvram get model`" == "GT-AC5300" ] || [ -n "`nvram get extendno | grep koolshare`" -a "`nvram get productid`" == "RT-AC86U" ];then
	cp -rf /tmp/frpc/GT-AC5300/webs/* /koolshare/webs/
fi
rm -fr /tmp/frpc* >/dev/null 2>&1
chmod +x /koolshare/bin/*
chmod +x /koolshare/scripts/frpc*.sh
chmod +x /koolshare/scripts/uninstall_frpc.sh

# for offline install
dbus set frpc_version="1.4"
dbus set softcenter_module_frpc_install="1"
dbus set softcenter_module_frpc_name="frpc"
dbus set softcenter_module_frpc_title="frpc内网穿透"
dbus set softcenter_module_frpc_description="支持多种协议的内网穿透软件"
sleep 1

if [ "$frpc_enable" == "1" ];then
	[ -f "/koolshare/scripts/frpc_config.sh" ] && sh /koolshare/scripts/frpc_config.sh start
fi

