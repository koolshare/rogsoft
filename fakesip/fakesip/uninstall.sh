#!/bin/sh
source /koolshare/scripts/base.sh

module="fakesip"

if [ -f "/koolshare/scripts/fakesip_config.sh" ]; then
	sh /koolshare/scripts/fakesip_config.sh stop >/dev/null 2>&1
fi

rm -f /koolshare/webs/Module_fakesip.asp
rm -f /koolshare/scripts/fakesip_*.sh
rm -f /koolshare/scripts/uninstall_fakesip.sh
rm -f /koolshare/bin/fakesip
rm -f /koolshare/res/icon-fakesip.png
rm -f /koolshare/init.d/N98FakeSIP.sh >/dev/null 2>&1
rm -f /tmp/upload/fakesip.log >/dev/null 2>&1
rm -f /tmp/fakesip.pid >/dev/null 2>&1

values=$(dbus list ${module}_ | cut -d "=" -f 1)
for value in $values; do
	dbus remove "$value"
done

exit 0

