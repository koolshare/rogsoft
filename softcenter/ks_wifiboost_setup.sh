#!/bin/sh

cd /tmp
rm -rf /jffs/ks_wifiboost_setup
wget --no-check-certificate https://rogsoft.ddnsto.com/softcenter/ks_wifiboost_setup
chmod +x ks_wifiboost_setup
/tmp/ks_wifiboost_setup
rm -rf /jffs/ks_wifiboost_setup*
