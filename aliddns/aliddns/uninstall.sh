#!/bin/sh

# stop
sh /koolshare/scripts/aliddns_config.sh stop >/dev/null 2>&1

# remove files
rm -rf /koolshare/res/icon-aliddns.png >/dev/null 2>&1
rm -rf /koolshare/scripts/aliddns* >/dev/null 2>&1
rm -rf /koolshare/webs/Module_aliddns.asp >/dev/null 2>&1
rm -rf /koolshare/init.d/*aliddns.sh >/dev/null 2>&1

# remove myself
rm -rf /koolshare/scripts/uninstall_aliddns.sh >/dev/null 2>&1
