#!/bin/sh
source /koolshare/scripts/base.sh

# remove files
rm -rf /koolshare/bin/wifiboost
rm -rf /koolshare/scripts/wifiboost*
rm -rf /koolshare/webs/Module_wifiboost.asp
rm -rf /koolshare/res/icon-wifiboost.png
rm -rf /tmp/wifiboost*
rm -rf /tmp/upload/wifiboost_log.txt

# remove keys
dbus list softcenter_module_wifiboost|cut -d "=" -f1|sed 's/^/dbus remove /g' | sed '1i\#!/bin/sh' > /tmp/remove_wifiboost.sh
dbus list wifiboost|cut -d "=" -f1|sed 's/^/dbus remove /g' >> /tmp/remove_wifiboost.sh
chmod +x /tmp/remove_wifiboost.sh
sh /tmp/remove_wifiboost.sh
rm -rf /tmp/remove_wifiboost.sh

# remove myself
rm -rf /koolshare/scripts/uninstall_wifiboost.sh

