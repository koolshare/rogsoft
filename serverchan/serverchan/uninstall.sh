#!/bin/sh
eval $(dbus export serverchan_)
source /koolshare/scripts/base.sh
logger "[软件中心]: 正在卸载serverChan..."
MODULE=serverchan
cd /
sh /koolshare/scripts/serverchan_config.sh stop >/dev/null 2>&1
rm -rf /koolshare/init.d/*serverchan.sh >/dev/null 2>&1
rm -rf /koolshare/scripts/*serverchan.sh >/dev/null 2>&1
rm -rf /koolshare/scripts/serverchan* >/dev/null 2>&1
rm -rf /koolshare/serverchan >/dev/null 2>&1
rm -rf /koolshare/res/icon-serverchan.png >/dev/null 2>&1
rm -rf /koolshare/webs/Module_serverchan.asp >/dev/null 2>&1
rm -rf /tmp/serverchan* >/dev/null 2>&1

values=$(dbus list serverchan | cut -d "=" -f 1)
for value in $values; do
    dbus remove $value
done

cru d serverchan_check >/dev/null 2>&1
logger "[软件中心]: 完成serverChan卸载"
rm -f /koolshare/scripts/uninstall_serverchan.sh
