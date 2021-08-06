#!/bin/sh

sh /koolshare/scripts/ddnspod_config.sh stop >/dev/null 2>&1

rm /koolshare/res/icon-ddnspod.png >/dev/null 2>&1
rm /koolshare/scripts/ddnspod* >/dev/null 2>&1
rm /koolshare/scripts/uninstall_ddnspod.sh >/dev/null 2>&1
rm /koolshare/webs/Module_ddnspod.asp >/dev/null 2>&1
rm -rf /koolshare/init.d/*ddnspod.sh >/dev/null 2>&1