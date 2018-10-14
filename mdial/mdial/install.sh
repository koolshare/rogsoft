#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
mdial_enable=`dbus get mdial_enable`

find /koolshare/init.d/ -name "*mdial*" | xargs rm -rf
find /koolshare/init.d/ -name "*mdial*" | xargs rm -rf

if [ "$mdial_enable" == "1" ];then
	[ -f "/koolshare/scripts/mdial_config.sh" ] && sh /koolshare/scripts/mdial_config.sh stop
fi

cp -rf /tmp/mdial/scripts/* /koolshare/scripts/
cp -rf /tmp/mdial/webs/* /koolshare/webs/
cp -rf /tmp/mdial/res/* /koolshare/res/
cp -rf /tmp/mdial/uninstall.sh /koolshare/scripts/uninstall_mdial.sh
if [ "`nvram get model`" == "GT-AC5300" ] || [ -n "`nvram get extendno | grep koolshare`" -a "`nvram get productid`" == "RT-AC86U" ];then
	cp -rf /tmp/mdial/GT-AC5300/webs/* /koolshare/webs/
fi
rm -fr /tmp/mdial* >/dev/null 2>&1
chmod +x /koolshare/scripts/mdial*.sh
chmod +x /koolshare/scripts/uninstall_mdial.sh
[ ! -L "/koolshare/init.d/S10mdial.sh" ] && ln -sf /koolshare/scripts/mdial_config.sh /koolshare/init.d/S10mdial.sh


dbus set mdial_version="1.0"
dbus set softcenter_module_mdial_version="1.0"
dbus set softcenter_module_mdial_description="pppoe单线多拨，带宽提升神器！"
dbus set softcenter_module_mdial_install=1
dbus set softcenter_module_mdial_name=mdial
dbus set softcenter_module_mdial_title="单线多拨"
sleep 1

if [ "$mdial_enable" == "1" ];then
	[ -f "/koolshare/scripts/mdial_config.sh" ] && sh /koolshare/scripts/mdial_config.sh start
fi

