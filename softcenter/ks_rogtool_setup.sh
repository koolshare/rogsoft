#!/bin/sh

cd /tmp
wget --no-check-certificate https://rogsoft.ddnsto.com/softcenter/ks_rogtool_setup
chmod +x ./ks_rogtool_setup
./ks_rogtool_setup install
rm -rf /tmp/ks_rogtool_setup
