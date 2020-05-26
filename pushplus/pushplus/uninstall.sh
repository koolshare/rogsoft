#!/bin/sh

sh /koolshare/scripts/pushplus_config.sh stop >/dev/null 2>&1
rm -rf /koolshare/init.d/*pushplus.sh >/dev/null 2>&1
rm -rf /koolshare/scripts/*pushplus.sh >/dev/null 2>&1
rm -rf /koolshare/scripts/pushplus* >/dev/null 2>&1
rm -rf /koolshare/pushplus >/dev/null 2>&1
rm -rf /koolshare/res/icon-pushplus.png >/dev/null 2>&1
rm -rf /koolshare/webs/Module_pushplus.asp >/dev/null 2>&1
