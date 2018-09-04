#!/bin/sh

# stop ssserver first
enable=`dbus get ssserver_enable`
if [ "$enable" == "1" ];then
	sh /koolshare/scripts/ssserver_config.sh stop
fi

# cp files
cp -rf /tmp/ssserver/scripts/* /koolshare/scripts/
cp -rf /tmp/ssserver/bin/* /koolshare/bin/
cp -rf /tmp/ssserver/webs/* /koolshare/webs/
cp -rf /tmp/ssserver/res/* /koolshare/res/
cp -rf /tmp/ssserver/init.d/* /koolshare/init.d/
cp -rf /tmp/ssserver/install.sh /koolshare/scripts/uninstall_ssserver.sh

# delete install tar
rm -rf /tmp/ssserver* >/dev/null 2>&1

chmod +x /koolshare/scripts/ssserver*
chmod +x /koolshare/bin/ss-server
chmod +x /koolshare/bin/obfs-server
chmod +x /koolshare/init.d/*

# re-enable ssserver
if [ "$enable" == "1" ];then
	sh /koolshare/scripts/ssserver_config.sh
fi



