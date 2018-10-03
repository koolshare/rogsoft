#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
MODEL=`nvram get model`
fastd1ck_enable=`dbus get fastd1ck_enable`

find /koolshare/init.d/ -name "*fastd1ck*" | xargs rm -rf
find /koolshare/init.d/ -name "*FastD1ck*" | xargs rm -rf

if [ "$fastd1ck_enable" == "1" ];then
	[ -f "/koolshare/scripts/fastd1ck_config.sh" ] && sh /koolshare/scripts/fastd1ck_config.sh stop
fi

cp -rf /tmp/fastd1ck/scripts/* /koolshare/scripts/
cp -rf /tmp/fastd1ck/webs/* /koolshare/webs/
cp -rf /tmp/fastd1ck/res/* /koolshare/res/
cp -rf /tmp/fastd1ck/uninstall.sh /koolshare/scripts/uninstall_fastd1ck.sh
if [ "$MODEL" == "GT-AC5300" ];then
	cp -rf /tmp/fastd1ck/GT-AC5300/webs/* /koolshare/webs/
fi
rm -fr /tmp/fastd1ck* >/dev/null 2>&1
chmod +x /koolshare/scripts/fastd1ck*.sh
chmod +x /koolshare/scripts/uninstall_fastd1ck.sh
[ ! -L "/koolshare/init.d/S99fastd1ck.sh" ] && ln -sf /koolshare/scripts/fastd1ck_config.sh /koolshare/init.d/S99fastd1ck.sh


dbus set fastd1ck_version="1.1"
dbus set softcenter_module_fastd1ck_version="1.1"
dbus set softcenter_module_fastd1ck_description=迅雷快鸟，上网必备神器
dbus set softcenter_module_fastd1ck_install=1
dbus set softcenter_module_fastd1ck_name=fastd1ck
dbus set softcenter_module_fastd1ck_title=迅雷快鸟
sleep 1

if [ "$fastd1ck_enable" == "1" ];then
	[ -f "/koolshare/scripts/fastd1ck_config.sh" ] && sh /koolshare/scripts/fastd1ck_config.sh start
fi

