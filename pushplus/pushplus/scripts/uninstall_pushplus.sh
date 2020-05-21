#!/bin/sh
eval $(dbus export pushplus_)
source /koolshare/scripts/base.sh
logger "[软件中心]: 正在卸载pushplus..."
MODULE=pushplus
cd /
sh /koolshare/scripts/pushplus_config.sh stop >/dev/null 2>&1
rm -rf /koolshare/init.d/*pushplus.sh >/dev/null 2>&1
rm -rf /koolshare/scripts/*pushplus.sh >/dev/null 2>&1
rm -rf /koolshare/scripts/pushplus* >/dev/null 2>&1
rm -rf /koolshare/pushplus >/dev/null 2>&1
rm -rf /koolshare/res/icon-pushplus.png >/dev/null 2>&1
rm -rf /koolshare/webs/Module_pushplus.asp >/dev/null 2>&1
rm -rf /tmp/pushplus* >/dev/null 2>&1

values=$(dbus list pushplus | cut -d "=" -f 1)
for value in $values; do
    dbus remove $value
done

cru d pushplus_check >/dev/null 2>&1
logger "[软件中心]: 完成pushplus卸载"
rm -f /koolshare/scripts/uninstall_pushplus.sh
