#!/bin/sh

cd /tmp
rm -rf /jffs/ks_wifiboost_setup
wget --no-check-certificate https://rogsoft.ddnsto.com/softcenter/ks_wifiboost_setup
chmod +x ks_wifiboost_setup

case $1 in
uninstall)
	/tmp/ks_wifiboost_setup uninstall
	;;
install|*)
	/tmp/ks_wifiboost_setup install
	;;
esac

rm -rf /jffs/ks_wifiboost_setup*
