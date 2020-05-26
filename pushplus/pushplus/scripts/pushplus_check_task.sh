#!/bin/sh
source /koolshare/scripts/base.sh
eval $(dbus export pushplus)
/koolshare/scripts/pushplus_check.sh task
