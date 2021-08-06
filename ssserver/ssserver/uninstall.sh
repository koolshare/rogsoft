#!/bin/sh

sh /koolshare/scripts/ssserver_config.sh stop
rm /koolshare/bin/ss-server
rm /koolshare/bin/obfs-server
rm /koolshare/scripts/uninstall_ssserver.sh
rm /koolshare/res/icon-ssserver.png
rm /koolshare/scripts/ssserver*
rm /koolshare/webs/Module_ssserver.asp