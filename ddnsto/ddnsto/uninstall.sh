#!/bin/sh
source /koolshare/scripts/base.sh

cd /tmp
killall ddnsto >/dev/null 2>&1

find /koolshare/init.d/ -name "*ddnsto.sh*"|xargs rm -rf >/dev/null 2>&1
find /koolshare/bin/ -name "*ddnsto*"|xargs rm -rf >/dev/null 2>&1
rm -rf /koolshare/bin/ddnsto
rm -rf /koolshare/res/icon-ddnsto.png
rm -rf /koolshare/scripts/ddnsto*.sh
rm -rf /koolshare/scripts/uninstall_ddnsto.sh
rm -rf /koolshare/webs/Module_ddnsto.asp

values=$(dbus list ddnsto_ | cut -d "=" -f 1)
for value in $values
do
	dbus remove $value
done
