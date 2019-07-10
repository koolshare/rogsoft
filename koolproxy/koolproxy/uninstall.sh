#! /bin/sh

sh /koolshare/koolproxy/kp_config.sh stop

rm -rf /koolshare/bin/koolproxy >/dev/null 2>&1
rm -rf /koolshare/koolproxy >/dev/null 2>&1
rm -rf /koolshare/scripts/KoolProxy* >/dev/null 2>&1
rm -rf /koolshare/webs/Module_koolproxy.asp >/dev/null 2>&1
rm -rf /koolshare/res/icon-koolproxy.png >/dev/null 2>&1
find /koolshare/init.d/ -name "*koolproxy*" | xargs rm -rf
