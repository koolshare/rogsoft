#!/bin/sh
source /koolshare/scripts/base.sh

# remove files
# rm -rf /koolshare/bin/xxd >/dev/null 2>&1
rm -rf /koolshare/scripts/uamas* >/dev/null 2>&1
rm -rf /koolshare/webs/Module_uamas.asp >/dev/null 2>&1
rm -rf /koolshare/res/icon-uamas.png >/dev/null 2>&1
rm -rf /tmp/uamas* >/dev/null 2>&1
rm -rf /tmp/upload/uamas_log.txt >/dev/null 2>&1

# remove keys
dbus list softcenter_module_uamas|cut -d "=" -f1|sed 's/^/dbus remove /g' | sed '1i\#!/bin/sh' > /tmp/remove_uamas.sh
dbus list uamas|cut -d "=" -f1|sed 's/^/dbus remove /g' >> /tmp/remove_uamas.sh
chmod 755 /tmp/remove_uamas.sh
sh /tmp/remove_uamas.sh
rm -rf /tmp/remove_uamas.sh

# remove myself
rm -rf /koolshare/scripts/uninstall_uamas.sh >/dev/null 2>&1
