#! /bin/sh

killall shellinaboxd
rm -rf /koolshare/init.d/*shellinabox*
cp -rf /tmp/shellinabox/shellinabox /koolshare/
cp -rf /tmp/shellinabox/res/* /koolshare/res/
cp -rf /tmp/shellinabox/scripts/* /koolshare/scripts/
cp -rf /tmp/shellinabox/webs/* /koolshare/webs/
cp -rf /tmp/shellinabox/uninstall.sh /koolshare/scripts/uninstall_shellinabox
chmod 755 /koolshare/shellinabox/*	
chmod 755 /koolshare/scripts/*
# open in new window
dbus set softcenter_module_shellinabox_install="1"
dbus set softcenter_module_shellinabox_target="target=_blank"
rm -rf /tmp/shellinabox*