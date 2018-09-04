#!/bin/sh

# stop aliddns first
enable=`dbus get aliddns_enable`
if [ "$enable" == "1" ];then
	sh /koolshare/scripts/aliddns_config.sh stop
fi

# delete some files
rm -rf /koolshare/init.d/*aliddns.sh

# install
cp -rf /tmp/aliddns/scripts/* /koolshare/scripts/
cp -rf /tmp/aliddns/webs/* /koolshare/webs/
cp -rf /tmp/aliddns/res/* /koolshare/res/
cp -rf /tmp/aliddns/install.sh /koolshare/scripts/uninstall_aliddns.sh
chmod +x /koolshare/scripts/aliddns*
chmod +x /koolshare/init.d/*
[ ! -L "/koolshare/init.d/S98Aliddns.sh" ] && ln -sf /koolshare/scripts/aliddns_config.sh /koolshare/init.d/S98Aliddns.sh

# delete install tar
rm -rf /tmp/aliddns* >/dev/null 2>&1

# re-enable aliddns
if [ "$enable" == "1" ];then
	sh /koolshare/scripts/aliddns_config.sh
fi
