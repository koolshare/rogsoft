#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

killall frpc
find /koolshare/init.d/ -name "*frpc*" | xargs rm -rf
rm -rf /koolshare/res/icon-frpc.png
rm -rf /koolshare/scripts/frpc*.sh
rm -rf /koolshare/webs/Module_frpc.asp
rm -f /koolshare/scripts/uninstall_frpc.sh
