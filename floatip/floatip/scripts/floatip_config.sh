#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval $(dbus export floatip)
FLOATIP_RUN_LOG=/dev/null

case $ACTION in
start)
    if [ "${floatip_enable}" == "1" ];then
        start-stop-daemon --start --quiet --make-pidfile --pidfile /tmp/floatip.pid --background --startas /bin/sh -- -c "exec /koolshare/bin/floatip_bin >${FLOATIP_RUN_LOG} 2>&1"
    fi
    ;;
*)
    if [ "${floatip_enable}" == "1" ];then
        killall floatip_bin
        start-stop-daemon --start --quiet --make-pidfile --pidfile /tmp/floatip.pid --background --startas /bin/sh -- -c "exec /koolshare/bin/floatip_bin >${FLOATIP_RUN_LOG} 2>&1"
    else
        killall floatip
    fi
    http_response "$1"
    ;;
esac