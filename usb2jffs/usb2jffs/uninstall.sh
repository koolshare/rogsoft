#!/bin/sh

sh /koolshare/scripts/usb2jffs_configs.sh stop 3

sleep 1

rm -rf /koolshare/scripts/uninstall_usb2jffs.sh
rm -rf /koolshare/res/icon-usb2jffs.png
rm -rf /koolshare/res/sadog.png
rm -rf /koolshare/scripts/usb2jffs*
rm -rf /koolshare/webs/Module_usb2jffs.asp
rm -rf /koolshare/init.d/*usb2jffs