#!/bin/sh
source /koolshare/scripts/base.sh

# stop before ubinstall
sh /koolshare/scripts/shiptv_config.sh stop >/dev/null 2>&1

# remove files
rm -rf /koolshare/res/icon-shiptv.png
rm -rf /koolshare/init.d/*Shiptv.sh
rm -rf /koolshare/scripts/shiptv*.sh
rm -rf /koolshare/webs/Module_shiptv.asp
rm -rf /tmp/shiptv*
rm -rf /tmp/upload/shiptv_log.txt

# remove keys
dbus list softcenter_module_shiptv|cut -d "=" -f1|sed 's/^/dbus remove /g' | sed '1i\#!/bin/sh' > /tmp/remove_shiptv.sh
chmod + x /tmp/remove_shiptv.sh
sh /tmp/remove_shiptv.sh
rm -rf /tmp/remove_shiptv.sh
