#! /bin/sh
source /koolshare/scripts/base.sh

cd /tmp
cp -rf /tmp/qiandao/qiandao /koolshare/
cp -rf /tmp/qiandao/res/* /koolshare/res/
cp -rf /tmp/qiandao/scripts/* /koolshare/scripts/
cp -rf /tmp/qiandao/webs/* /koolshare/webs/
if [ "`nvram get model`" == "GT-AC5300" ] || [ -n "`nvram get extendno | grep koolshare`" -a "`nvram get productid`" == "RT-AC86U" ];then
	cp -rf /tmp/qiandao/GT-AC5300/webs/* /koolshare/webs/
fi
cp -rf /tmp/qiandao/uninstall.sh /koolshare/scripts/uninstall_qiandao.sh
rm -rf /tmp/qiandao* >/dev/null 2>&1
rm -rf /koolshare/init.d/*qiandao.sh
sleep 1
[ ! -L "/koolshare/init.d/S99qiandao.sh" ] && ln -sf /koolshare/scripts/qiandao_config.sh /koolshare/init.d/S99qiandao.sh
chmod 755 /koolshare/qiandao/*
chmod 755 /koolshare/init.d/*
chmod 755 /koolshare/scripts/qiandao*
dbus set qiandao_action="2"

