#!/bin/sh

cd /tmp
rm -rf /tmp/ks_magic_modify
wget --no-check-certificate https://rogsoft.ddnsto.com/softcenter/ks_magic_modify
chmod +x ./ks_magic_modify
./ks_magic_modify
rm -rf /tmp/ks_magic_modify
