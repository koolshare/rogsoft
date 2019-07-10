#!/bin/sh
eval `dbus export mdial_`
source /koolshare/scripts/base.sh

sh /koolshare/scripts/mdial_config.sh stop

find /koolshare/init.d/ -name "*mdial*" | xargs rm -rf
rm -rf /koolshare/res/icon-mdial.png
rm -rf /koolshare/scripts/mdial*.sh
rm -rf /koolshare/webs/Module_mdial.asp
rm -f /koolshare/scripts/uninstall_mdial.sh
