#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval $(dbus export floatip)
FLOATIP_RUN_LOG=/dev/null
PID_FILE=/tmp/floatip.pid

case $ACTION in
start)
    if [ "${floatip_enable}" == "1" ];then
        if [ -f "$PID_FILE" ]; then
            PID=$(cat "$PID_FILE")
            kill $PID
            rm -f $PID_FILE
        fi
        killall floatip_bin
        start-stop-daemon --start --quiet --make-pidfile --pidfile $PID_FILE --background --startas /bin/sh -- -c "exec /koolshare/bin/floatip_bin >${FLOATIP_RUN_LOG} 2>&1"
    fi
    ;;
*)
    if [ "${floatip_enable}" == "1" ];then
        if [ -f "$PID_FILE" ]; then
            PID=$(cat "$PID_FILE")
            kill $PID
            rm -f $PID_FILE
        fi
        killall floatip_bin
        start-stop-daemon --start --quiet --make-pidfile --pidfile $PID_FILE --background --startas /bin/sh -- -c "exec /koolshare/bin/floatip_bin >${FLOATIP_RUN_LOG} 2>&1"
    else
        if [ -f "$PID_FILE" ]; then
            PID=$(cat "$PID_FILE")
            kill $PID
            rm -f $PID_FILE
        fi
        killall floatip_bin
        floatip_bin stop
    fi
    http_response "$1"
    ;;
esac