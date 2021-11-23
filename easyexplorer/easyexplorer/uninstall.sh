#!/bin/sh
eval `dbus export easyexplorer_`
source /koolshare/scripts/base.sh

cd /tmp
killall	easy-explorer > /dev/null 2>&1

rm -rf /koolshare/init.d/*easyexplorer.sh
rm -rf /koolshare/bin/easy-explorer
rm -rf /koolshare/res/icon-easyexplorer.png
rm -rf /koolshare/scripts/easyexplorer*.sh
rm -rf /koolshare/webs/Module_easyexplorer.asp
rm -rf /koolshare/scripts/uninstall_easyexplorer.sh
rm -rf /tmp/easyexplorer*
