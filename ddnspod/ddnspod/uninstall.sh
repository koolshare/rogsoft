#!/bin/sh

sh /koolshare/scripts/ddnspod_config.sh stop

rm /koolshare/scripts/uninstall_ddnspod.sh
rm /koolshare/res/icon-ddnspod.png
rm /koolshare/scripts/ddnspod*
rm /koolshare/webs/Module_ddnspod.asp
rm -rf /koolshare/init.d/*ddnspod.sh