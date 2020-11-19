#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

sh /koolshare/scripts/frps_config.sh stop >/dev/null 2>&1

rm -f /koolshare/bin/frps
find /koolshare/init.d/ -name "*frps*" | xargs rm -rf
rm -rf /koolshare/res/icon-frps.png
rm -rf /koolshare/scripts/frps_*.sh
rm -rf /koolshare/webs/Module_frps.asp
rm -f /koolshare/scripts/uninstall_frps.sh
rm -f /koolshare/configs/frps.ini

values=$(dbus list frps | cut -d "=" -f 1)
for value in $values
do
	dbus remove $value
done