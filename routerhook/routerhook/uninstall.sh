#!/bin/sh

sh /koolshare/scripts/routerhook_config.sh stop >/dev/null 2>&1
rm -rf /koolshare/init.d/*routerhook.sh >/dev/null 2>&1
rm -rf /koolshare/scripts/*routerhook.sh >/dev/null 2>&1
rm -rf /koolshare/scripts/routerhook* >/dev/null 2>&1
rm -rf /koolshare/routerhook >/dev/null 2>&1
rm -rf /koolshare/res/icon-routerhook.png >/dev/null 2>&1
rm -rf /koolshare/webs/Module_routerhook.asp >/dev/null 2>&1
