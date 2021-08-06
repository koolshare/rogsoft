#!/bin/sh
source /koolshare/scripts/base.sh
eval $(dbus export serverchan)
/koolshare/scripts/serverchan_check.sh task
