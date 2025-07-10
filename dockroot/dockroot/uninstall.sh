#!/bin/sh
source /koolshare/scripts/base.sh

cd /tmp
find /koolshare/init.d/ -name "*dockroot.sh*"|xargs rm -rf >/dev/null 2>&1
find /koolshare/bin/ -name "*DockRoot*"|xargs rm -rf >/dev/null 2>&1
rm -rf /koolshare/res/icon-dockroot.png
rm -rf /koolshare/scripts/uninstall_dockroot.sh
rm -rf /koolshare/webs/Module_dockroot.asp

values=$(dbus list dockroot_ | cut -d "=" -f 1)
for value in $values
do
	dbus remove $value
done
