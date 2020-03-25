#!/bin/sh

sh /koolshare/scripts/serverchan_config.sh stop >/dev/null 2>&1
rm -rf /koolshare/init.d/*serverchan.sh >/dev/null 2>&1
rm -rf /koolshare/scripts/*serverchan.sh >/dev/null 2>&1
rm -rf /koolshare/scripts/serverchan* >/dev/null 2>&1
rm -rf /koolshare/serverchan >/dev/null 2>&1
rm -rf /koolshare/res/icon-serverchan.png >/dev/null 2>&1
rm -rf /koolshare/webs/Module_serverchan.asp >/dev/null 2>&1