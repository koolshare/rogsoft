#!/bin/sh
source /koolshare/scripts/base.sh

# remove files
rm -rf /koolshare/bin/cfetool >/dev/null 2>&1
rm -rf /koolshare/scripts/cfetool* >/dev/null 2>&1
rm -rf /koolshare/webs/Module_cfetool.asp >/dev/null 2>&1
rm -rf /koolshare/res/icon-cfetool.png >/dev/null 2>&1
rm -rf /tmp/cfetool* >/dev/null 2>&1
rm -rf /tmp/upload/cfetool_log.txt >/dev/null 2>&1

# remove keys
dbus list softcenter_module_cfetool|cut -d "=" -f1|sed 's/^/dbus remove /g' | sed '1i\#!/bin/sh' > /tmp/remove_cfetool.sh
dbus list cfetool|cut -d "=" -f1|sed 's/^/dbus remove /g' >> /tmp/remove_cfetool.sh
chmod 755 /tmp/remove_cfetool.sh
sh /tmp/remove_cfetool.sh
rm -rf /tmp/remove_cfetool.sh

# remove myself
rm -rf /koolshare/scripts/uninstall_cfetool.sh >/dev/null 2>&1
