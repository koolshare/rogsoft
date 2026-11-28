#!/bin/sh
. /koolshare/scripts/base.sh
if [ -x /koolshare/cdn/endpoint.sh ]; then
    /koolshare/cdn/endpoint.sh remove || exit 1
fi
rm -f /koolshare/init.d/S99cdn.sh /koolshare/scripts/cdn_config.sh \
      /koolshare/webs/Module_cdn.asp /koolshare/res/icon-cdn.png \
      /koolshare/cdn/endpoint.sh /koolshare/cdn/cdn-watch /koolshare/cdn/platform /koolshare/scripts/uninstall_cdn.sh
rmdir /koolshare/cdn 2>/dev/null || :
rm -f /tmp/.softcenter-cdn/lock
rmdir /tmp/.softcenter-cdn 2>/dev/null || :
for key in name version install title description md5; do
    dbus remove "softcenter_module_cdn_$key"
done
