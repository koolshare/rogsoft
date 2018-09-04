#! /bin/sh
cd /tmp
cp -rf /tmp/ssid/ssid /koolshare/
cp -rf /tmp/ssid/scripts/* //koolshare/scripts/
cp -rf /tmp/ssid/webs/* /koolshare/webs/
cp -rf /tmp/ssid/res/* /koolshare/res/
#cp -rf /tmp/ssid/init.d/* /jffs/koolshare/init.d/
cd /
rm -rf /tmp/ssid* >/dev/null 2>&1


chmod 755 /jffs/koolshare/ssid/*
chmod 755 /jffs/koolshare/scripts/ssid*
#chmod 755 /jffs/koolshare/init.d/ssid*


dbus set softcenter_module_ssid_install=1
dbus set softcenter_module_ssid_name=ssid
dbus set softcenter_module_ssid_title="中文SSID"

