#!/bin/sh
source /koolshare/scripts/base.sh

cd /tmp
killall floatip >/dev/null 2>&1

find /koolshare/init.d/ -name "*floatip.sh*"|xargs rm -rf >/dev/null 2>&1
find /koolshare/bin/ -name "*floatip*"|xargs rm -rf >/dev/null 2>&1
rm -f /koolshare/bin/floatip_bin
rm -f /koolshare/res/icon-floatip.png
rm -f /koolshare/scripts/floatip*.sh
rm -f /koolshare/scripts/uninstall_floatip.sh
rm -f /koolshare/webs/Module_floatip.asp

values=$(dbus list floatip_ | cut -d "=" -f 1)
for value in $values
do
	dbus remove $value
done
