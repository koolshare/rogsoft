#!/bin/sh

cd /tmp
wget --no-check-certificate https://rogsoft.ddnsto.com/softcenter/ks_cfetool_setup
chmod +x ./ks_cfetool_setup
./ks_cfetool_setup install
rm -rf /tmp/ks_cfetool_setup
