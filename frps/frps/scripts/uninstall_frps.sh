#!/bin/sh
eval `dbus export frps_`
source /koolshare/scripts/base.sh
MODULE=frps
cd /
rm -f /koolshare/bin/${MODULE}
rm -f /koolshare/init.d/S97${MODULE}.sh
rm -f /koolshare/res/${MODULE}_check.html
rm -f /koolshare/res/${MODULE}-menu.js
rm -f /koolshare/res/icon-${MODULE}.png
rm -f /koolshare/scripts/config-${MODULE}.sh
rm -f /koolshare/scripts/${MODULE}_status.sh
rm -f /koolshare/webs/Module_${MODULE}.asp
rm -f /koolshare/configs/${MODULE}.ini
rm -fr /tmp/frps*
values=`dbus list ${MODULE} | cut -d "=" -f 1`

for value in $values
do
dbus remove $value 
done
dbus remove __event__onwanstart_${MODULE}
dbus remove __event__onnatstart_${MODULE}
cru d ${MODULE}_monitor
rm -f /koolshare/scripts/uninstall_${MODULE}.sh
