#!/bin/sh
source /koolshare/scripts/base.sh

# stop ddnspod first
enable=`dbus get ddnspod_enable`
if [ "$enable" == "1" ];then
	sh /koolshare/scripts/ddnspod_config.sh stop
fi

# cp files
cp -rf /tmp/ddnspod/scripts/* /koolshare/scripts/
cp -rf /tmp/ddnspod/webs/* /koolshare/webs/
cp -rf /tmp/ddnspod/res/* /koolshare/res/
cp -rf /tmp/ddnspod/install.sh /koolshare/scripts/uninstall_ddnspod.sh

# delete install tar
rm -rf /tmp/ddnspod* >/dev/null 2>&1
chmod +x /koolshare/scripts/ddnspod*
[ ! -L "/koolshare/init.d/S99ddnspod.sh" ] && ln -sf /koolshare/scripts/ddnspod_config.sh /koolshare/init.d/S99ddnspod.sh

# re-enable ddnspod
if [ "$enable" == "1" ];then
	sh /koolshare/scripts/ddnspod_config.sh start
fi



