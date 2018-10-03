#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
aria2_enable=`dbus get aria2_enable`
aria2_version=`dbus get aria2_version`

#重建 /dev/null
rm /dev/null 
mknod /dev/null c 1 3 
chmod 666 /dev/null

if [ "$aria2_enable" == "1" ];then
	[ -f "/koolshare/scripts/aria2_config.sh" ] && sh /koolshare/scripts/aria2_config.sh stop
fi

cp -rf /tmp/aria2/bin/* /koolshare/bin/
cp -rf /tmp/aria2/scripts/* /koolshare/scripts/
cp -rf /tmp/aria2/webs/* /koolshare/webs/
cp -rf /tmp/aria2/res/* /koolshare/res/
cp -rf /tmp/aria2/aria2 /koolshare
cp -rf /tmp/aria2/uninstall.sh /koolshare/scripts/uninstall_aria2.sh
if [ "`nvram get model`" == "GT-AC5300" ] || [ -n "`nvram get extendno | grep koolshare`" -a "`nvram get productid`" == "RT-AC86U" ];then
	cp -rf /tmp/aria2/GT-AC5300/webs/* /koolshare/webs/
fi
rm -fr /tmp/aria2* >/dev/null 2>&1
chmod +x /koolshare/bin/*
chmod +x /koolshare/scripts/aria2*.sh
chmod +x /koolshare/scripts/uninstall_aria2.sh
[ ! -L "/koolshare/init.d/M99Aria2.sh" ] && ln -sf /koolshare/scripts/aria2_config.sh /koolshare/init.d/M99Aria2.sh
[ ! -L "/koolshare/init.d/N99Aria2.sh" ] && ln -sf /koolshare/scripts/aria2_config.sh /koolshare/init.d/N99Aria2.sh

#some modify
if [ "$aria2_version" == "1.5" ] || [ "$aria2_version" == "1.4" ] || [ "$aria2_version" == "1.3" ];then
	dbus set aria2_custom=Y2EtY2VydGlmaWNhdGU9L2V0Yy9zc2wvY2VydHMvY2EtY2VydGlmaWNhdGVzLmNydA==
fi

dbus set aria2_version="2.1"
dbus set softcenter_module_aria2_version="2.1"
dbus set softcenter_module_aria2_install="1"
dbus set softcenter_module_aria2_name="aria2"
dbus set softcenter_module_aria2_title="aria2"
dbus set softcenter_module_aria2_description="linux下载利器"
sleep 1

if [ "$aria2_enable" == "1" ];then
	[ -f "/koolshare/scripts/aria2_config.sh" ] && sh /koolshare/scripts/aria2_config.sh start
fi

