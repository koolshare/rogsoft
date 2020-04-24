#!/bin/sh
eval $(dbus export routerhook_)
source /koolshare/scripts/base.sh
logger "[routerhook]: 正在卸载routerhook..."
MODULE=routerhook
cd /
sh /koolshare/scripts/routerhook_config.sh stop >/dev/null 2>&1
rm -rf /koolshare/init.d/*routerhook.sh >/dev/null 2>&1
rm -rf /koolshare/scripts/*routerhook.sh >/dev/null 2>&1
rm -rf /koolshare/scripts/routerhook* >/dev/null 2>&1
rm -rf /koolshare/routerhook >/dev/null 2>&1
rm -rf /koolshare/res/icon-routerhook.png >/dev/null 2>&1
rm -rf /koolshare/webs/Module_routerhook.asp >/dev/null 2>&1
rm -rf /tmp/routerhook* >/dev/null 2>&1

values=$(dbus list routerhook | cut -d "=" -f 1)
for value in $values; do
    dbus remove $value
done

cru d routerhook_check >/dev/null 2>&1
logger "[routerhook]: 完成routerhook卸载"
rm -f /koolshare/scripts/uninstall_routerhook.sh
