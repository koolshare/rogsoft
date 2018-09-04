#!/bin/sh
eval `dbus export serverchan_`
source /koolshare/scripts/base.sh
logger "[软件中心]: 正在卸载serverChan..."
MODULE=serverchan
cd /
/koolshare/serverchan/serverchan_config stop
rm -f /koolshare/scripts/serverchan_check.sh
rm -f /koolshare/scripts/serverchan_check_task.sh
rm -f /koolshare/scripts/serverchan_dhcp_trigger.sh
rm -f /koolshare/scripts/serverchan_ifup_trigger.sh
rm -f /koolshare/scripts/serverchan_config.sh
rm -f /koolshare/webs/Module_serverchan.asp
rm -f /koolshare/res/icon-serverchan.png
rm -fr /koolshare/serverchan/ >/dev/null 2>&1
rm -fr /tmp/serverchan* >/dev/null 2>&1
values=`dbus list serverchan | cut -d "=" -f 1`

for value in $values
do
dbus remove $value 
done
cru d serverchan_check
logger "[软件中心]: 完成serverChan卸载"
rm -f /koolshare/scripts/uninstall_serverchan.sh