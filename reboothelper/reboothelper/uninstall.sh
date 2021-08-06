#!/bin/sh
source /koolshare/scripts/base.sh

dbus set reboothelper_enable=0

/koolshare/scripts/reboothelper_config.sh stop

rm -rf /koolshare/res/icon-reboothelper.png
rm -rf /koolshare/scripts/reboothelper_*.sh
rm -rf /koolshare/webs/Module_reboothelper.asp
rm -rf /tmp/reboothelper*
rm -rf /koolshare/init.d/*Reboothelper*
rm -rf /koolshare/scripts/uninstall_reboothelper.sh
