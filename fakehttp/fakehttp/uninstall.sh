#!/bin/sh
source /koolshare/scripts/base.sh

module="fakehttp"

if [ -f "/koolshare/scripts/fakehttp_config.sh" ]; then
	sh /koolshare/scripts/fakehttp_config.sh stop >/dev/null 2>&1
fi

rm -f /koolshare/webs/Module_fakehttp.asp
rm -f /koolshare/scripts/fakehttp_*.sh
rm -f /koolshare/scripts/uninstall_fakehttp.sh
rm -f /koolshare/bin/fakehttp
rm -f /koolshare/res/icon-fakehttp.png
rm -f /koolshare/init.d/N97FakeHTTP.sh >/dev/null 2>&1
rm -f /tmp/upload/fakehttp.log >/dev/null 2>&1
rm -f /tmp/fakehttp.pid >/dev/null 2>&1

values=$(dbus list ${module}_ | cut -d "=" -f 1)
for value in $values; do
	dbus remove "$value"
done

exit 0

