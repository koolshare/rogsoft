#!/bin/sh

sh /koolshare/scripts/usb2jffs_config.sh stop 3

rm -rf /koolshare/res/icon-usb2jffs.png >/dev/null 2>&1
rm -rf /koolshare/scripts/usb2jffs* >/dev/null 2>&1
rm -rf /koolshare/webs/Module_usb2jffs.asp >/dev/null 2>&1
rm -rf /koolshare/scripts/uninstall_usb2jffs.sh >/dev/null 2>&1
find /koolshare/init.d -name "*usb2jffs*" | xargs rm -rf >/dev/null 2>&1
