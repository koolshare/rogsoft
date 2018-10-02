#!/bin/sh
eval `dbus export fastd1ck_`
source /koolshare/scripts/base.sh

sh /koolshare/scripts/fastd1ck_config.sh stop

find /koolshare/init.d/ -name "*fastd1ck*" | xargs rm -rf
find /koolshare/init.d/ -name "*FastD1ck*" | xargs rm -rf
rm -rf /koolshare/res/icon-fastd1ck.png
rm -rf /koolshare/scripts/fastd1ck*.sh
rm -rf /koolshare/webs/Module_fastd1ck.asp
rm -f /koolshare/scripts/uninstall_fastd1ck.sh
