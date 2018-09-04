#!/bin/sh
source /koolshare/scripts/base.sh
eval `dbus export serverchan`
if [ "$serverchan_enable" == "1" ]; then
    /koolshare/serverchan/serverchan_config start
else
    /koolshare/serverchan/serverchan_config stop
fi