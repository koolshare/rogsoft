#!/bin/sh
source /koolshare/scripts/base.sh
eval `dbus export serverchan`
/koolshare/serverchan/serverchan_ifup_trigger