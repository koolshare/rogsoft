#!/bin/sh
eval `dbus export aria2_`
source /koolshare/scripts/base.sh

sh /koolshare/scripts/aria2_config.sh stop

find /koolshare/init.d/ -name "*Aria2*" | xargs rm -rf
rm -rf /koolshare/bin/cpulimit
rm -rf /koolshare/aria2
rm -rf /koolshare/res/icon-aria2.png
rm -rf /koolshare/scripts/aria2*.sh
rm -rf /koolshare/webs/Module_aria2.asp
rm -f /koolshare/scripts/uninstall_aria2.sh
