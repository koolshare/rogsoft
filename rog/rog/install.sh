#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
#eval `dbus export rog_`
MODULE="rog"
title="ROG工具箱"
VERSION="1.0"

cd /
cp -rf /tmp/$MODULE/scripts/* /koolshare/scripts/
cp -rf /tmp/$MODULE/webs/* /koolshare/webs/
if [ "`nvram get model`" == "GT-AC5300" ] || [ -n "`nvram get extendno | grep koolshare`" -a "`nvram get productid`" == "RT-AC86U" ];then
	cp -rf /tmp/$MODULE/GT-AC5300/webs/* /koolshare/webs/
fi
cp -rf /tmp/$MODULE/res/* /koolshare/res/
cp -rf /tmp/$MODULE/uninstall.sh /koolshare/scripts/uninstall_rog.sh
rm -fr /tmp/rog* >/dev/null 2>&1
chmod +x /koolshare/scripts/rog*
chmod +x /koolshare/scripts/uninstall_rog.sh

dbus set softcenter_module_rog_install=1
dbus set softcenter_module_rog_name=${MODULE}
dbus set softcenter_module_rog_title="ROG工具箱"
dbus set softcenter_module_rog_description="一些小功能的插件"
