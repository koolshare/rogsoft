#!/bin/sh
source /koolshare/scripts/base.sh
logger "[软件中心]: 正在安装serverChan..."
MODULE=serverchan
cd /tmp
if [[ ! -x /koolshare/bin/base64_encode ]]; then
    cp -f /tmp/serverchan/bin/base64_encode /koolshare/bin/base64_encode
    chmod +x /koolshare/bin/base64_encode
    [ ! -L /koolshare/bin/base64_decode ] && ln -sf /koolshare/bin/base64_encode /koolshare/bin/base64_decode
fi
if [[ ! -x /koolshare/bin/jq ]]; then
    cp -f /tmp/serverchan/bin/jq /koolshare/bin/jq
    chmod +x /koolshare/bin/jq
fi
rm -rf /koolshare/init.d/*serverchan.sh
rm -rf /koolshare/scripts/serverchan_*
rm -rf /koolshare/serverchan/
cp -rf /tmp/serverchan/res/icon-serverchan.png /koolshare/res/
cp -rf /tmp/serverchan/scripts/* /koolshare/scripts/
cp -rf /tmp/serverchan/serverchan /koolshare/
if [ "`nvram get model`" == "GT-AC5300" ] || [ -n "`nvram get extendno | grep koolshare`" -a "`nvram get productid`" == "RT-AC86U" ];then
	cp -rf /tmp/serverchan/GT-AC5300/webs/Module_serverchan.asp /koolshare/webs/
else
	cp -rf /tmp/serverchan/webs/Module_serverchan.asp /koolshare/webs/
fi

chmod +x /koolshare/scripts/*
chmod +x /koolshare/serverchan/*
sleep 1
router_name=`echo $(nvram get model) | base64_encode`
router_name_get=`dbus get serverchan_config_name`
if [ -z "${router_name_get}" ]; then
    dbus set serverchan_config_name="${router_name}"
fi
router_ntp_get=`dbus get serverchan_config_ntp`
if [ -z "${router_ntp_get}" ]; then
    dbus set serverchan_config_ntp="ntp1.aliyun.com"
fi
bwlist_en_get=`dbus get serverchan_dhcp_bwlist_en`
if [ -z "${bwlist_en_get}" ]; then
    dbus set serverchan_dhcp_bwlist_en="1"
fi
_sckey=`dbus get serverchan_config_sckey`
if [ -n "${_sckey}" ]; then
    dbus set serverchan_config_sckey_1=`dbus get serverchan_config_sckey`
    dbus remove serverchan_config_sckey
fi

dbus set softcenter_module_serverchan_install=1
dbus set softcenter_module_serverchan_name=${MODULE}
dbus set softcenter_module_serverchan_title="ServerChan(微信推送)"
dbus set softcenter_module_serverchan_description="从路由器推送状态及通知的工具。"
dbus set softcenter_module_serverchan_version="0.1.16"
sh /koolshare/scripts/serverchan_config.sh
rm -fr /tmp/serverchan* >/dev/null 2>&1
logger "[软件中心]: 完成serverChan安装"
exit
