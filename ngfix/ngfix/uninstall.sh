#!/bin/sh
source /koolshare/scripts/base.sh

# remove files
# rm -rf /koolshare/bin/xxd >/dev/null 2>&1
rm -rf /koolshare/ngfix >/dev/null 2>&1
rm -rf /koolshare/scripts/ngfix* >/dev/null 2>&1
rm -rf /koolshare/webs/Module_ngfix.asp >/dev/null 2>&1
rm -rf /koolshare/res/icon-ngfix.png >/dev/null 2>&1
rm -rf /tmp/ngfix* >/dev/null 2>&1
rm -rf /tmp/upload/ngfix_log.txt >/dev/null 2>&1

# remove keys
dbus list softcenter_module_ngfix|cut -d "=" -f1|sed 's/^/dbus remove /g' | sed '1i\#!/bin/sh' > /tmp/remove_ngfix.sh
dbus list ngfix|cut -d "=" -f1|sed 's/^/dbus remove /g' >> /tmp/remove_ngfix.sh
chmod 755 /tmp/remove_ngfix.sh
sh /tmp/remove_ngfix.sh
rm -rf /tmp/remove_ngfix.sh

# remove myself
rm -rf /koolshare/scripts/uninstall_ngfix.sh >/dev/null 2>&1
