#!/bin/sh
source /koolshare/scripts/base.sh
eval $(dbus export routerhook)
/koolshare/scripts/routerhook_check.sh task
