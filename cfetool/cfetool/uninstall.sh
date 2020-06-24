#!/bin/sh
source /koolshare/scripts/base.sh

# remove files
rm -rf /koolshare/bin/cfetool
rm -rf /koolshare/scripts/cfetool*
rm -rf /koolshare/webs/Module_cfetool.asp
rm -rf /koolshare/res/icon-cfetool.png
rm -rf /tmp/cfetool*
rm -rf /tmp/upload/cfetool_log.txt

# remove keys
dbus list softcenter_module_cfetool|cut -d "=" -f1|sed 's/^/dbus remove /g' | sed '1i\#!/bin/sh' > /tmp/remove_cfetool.sh
dbus list cfetool|cut -d "=" -f1|sed 's/^/dbus remove /g' >> /tmp/remove_cfetool.sh
chmod +x /tmp/remove_cfetool.sh
sh /tmp/remove_cfetool.sh
rm -rf /tmp/remove_cfetool.sh
