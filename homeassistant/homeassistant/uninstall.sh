#!/bin/sh
source /koolshare/scripts/base.sh

cd /tmp
find /koolshare/init.d/ -name "*homeassistant.sh*"|xargs rm -rf >/dev/null 2>&1
find /koolshare/bin/ -name "*homeassistant*"|xargs rm -rf >/dev/null 2>&1
rm -rf /koolshare/res/icon-homeassistant.png
rm -rf /koolshare/scripts/uninstall_homeassistant.sh
rm -rf /koolshare/webs/Module_homeassistant.asp

values=$(dbus list homeassistant_ | cut -d "=" -f 1)
for value in $values
do
	dbus remove $value
done
