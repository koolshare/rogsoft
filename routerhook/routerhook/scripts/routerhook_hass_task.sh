#!/bin/sh
source /koolshare/scripts/base.sh
eval $(dbus export routerhook)

#间隔的秒数，不能大于60
step=$routerhook_sm_cron
if [ "$step" -gt 0 ]; then
    i=0
    while [ "$i" -lt 60 ]; do
        /koolshare/scripts/routerhook_hass.sh task
        sleep $step
        i=$((i + step))
    done
fi
