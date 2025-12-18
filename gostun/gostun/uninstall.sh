#!/bin/sh
source /koolshare/scripts/base.sh

module="gostun"

rm -f /koolshare/res/icon-gostun.png
rm -f /koolshare/webs/Module_gostun.asp
rm -f /koolshare/scripts/gostun_*.sh
rm -f /koolshare/scripts/uninstall_gostun.sh
rm -f /koolshare/bin/gostun

values=$(dbus list gostun_ | cut -d "=" -f 1)
for value in $values; do
	dbus remove "$value"
done

exit 0
