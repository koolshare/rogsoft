#!/bin/sh
export KSROOT=/koolshare
. $KSROOT/scripts/base.sh

killall frpc >/dev/null 2>&1
find /koolshare/init.d/ -name "*frpc*" -exec rm -rf {} \; >/dev/null 2>&1
rm -rf /koolshare/res/icon-frpc.png
rm -rf /koolshare/bin/frpc
rm -rf /koolshare/scripts/frpc*.sh
rm -rf /koolshare/webs/Module_frpc.asp
rm -rf /koolshare/scripts/uninstall_frpc.sh
