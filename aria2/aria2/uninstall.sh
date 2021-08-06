#!/bin/sh

# stop
sh /koolshare/scripts/aria2_config.sh stop

# remove files
find /koolshare/init.d/ -name "*Aria2*" | xargs rm -rf
find /koolshare/init.d/ -name "*aria2*" | xargs rm -rf
rm -rf /koolshare/bin/cpulimit >/dev/null 2>&1
rm -rf /koolshare/aria2 >/dev/null 2>&1
rm -rf /koolshare/res/icon-aria2.png >/dev/null 2>&1
rm -rf /koolshare/scripts/aria2*.sh >/dev/null 2>&1
rm -rf /koolshare/webs/Module_aria2.asp >/dev/null 2>&1

# remove myself
rm -rf /koolshare/scripts/uninstall_aria2.sh >/dev/null 2>&1
