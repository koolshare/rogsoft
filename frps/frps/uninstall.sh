#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

killall frps
find /koolshare/init.d/ -name "*frps*" | xargs rm -rf
rm -rf /koolshare/res/icon-frps.png
rm -rf /koolshare/scripts/frps*.sh
rm -rf /koolshare/webs/Module_frps.asp
rm -f /koolshare/scripts/uninstall_frps.sh
