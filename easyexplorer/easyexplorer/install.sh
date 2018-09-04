#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export easyexplorer_`

enable=`dbus get easyexplorer_enable`
[ "$enable" == "1" ] && killall	easy-explorer > /dev/null 2>&1

rm -rf /koolshare/init.d/*easyexplorer.sh
cp -rf /tmp/easyexplorer/bin/* /koolshare/bin/
cp -rf /tmp/easyexplorer/scripts/* /koolshare/scripts/
cp -rf /tmp/easyexplorer/webs/* /koolshare/webs/
cp -rf /tmp/easyexplorer/res/* /koolshare/res/
cp -rf /tmp/easyexplorer/uninstall.sh /koolshare/scripts/uninstall_easyexplorer.sh
if [ "`nvram get model`" == "GT-AC5300" ] || [ -n "`nvram get extendno | grep koolshare`" -a "`nvram get productid`" == "RT-AC86U" ];then
	cp -rf /tmp/easyexplorer/GT-AC5300/webs/* /koolshare/webs/
fi
chmod +x /koolshare/bin/easyexplorer
chmod +x /koolshare/scripts/*
[ ! -L "/koolshare/init.d/S99easyexplorer.sh" ] && ln -sf /koolshare/scripts/easyexplorer_config.sh /koolshare/init.d/S99easyexplorer.sh
[ ! -L "/koolshare/init.d/N99easyexplorer.sh" ] && ln -sf /koolshare/scripts/easyexplorer_config.sh /koolshare/init.d/N99easyexplorer.sh
sleep 1
rm -rf /tmp/easyexplorer* >/dev/null 2>&1
[ "$enable" == "1" ] &&/koolshare/scripts/easyexplorer_config.sh start
