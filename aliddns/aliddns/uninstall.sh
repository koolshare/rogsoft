#!/bin/sh

sh /koolshare/scripts/aliddns_config.sh stop

rm -rf /koolshare/scripts/uninstall_aliddns.sh
rm -rf /koolshare/res/icon-aliddns.png
rm -rf /koolshare/scripts/aliddns*
rm -rf /koolshare/webs/Module_aliddns.asp
rm -rf /koolshare/init.d/*aliddns.sh