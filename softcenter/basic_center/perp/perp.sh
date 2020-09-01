#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

[ -f "/koolshare/bin/skipd" ] && MOD=0
[ -f "/usr/bin/skipd" ] && MOD=1

kill_all_process(){
	killall perpboot >/dev/null 2>&1
	killall tinylog >/dev/null 2>&1
	killall perpd >/dev/null 2>&1

	if [ "${MOD}" == "0" ];then
		killall skipd >/dev/null 2>&1
		[ -n $(pidof skipd) ] && kill -9 $(pidof skipd) >/dev/null 2>&1
	fi
	
	killall httpdb >/dev/null 2>&1
	[ -n $(pidof httpdb) ] && kill -9 $(pidof httpdb) >/dev/null 2>&1
}

case $ACTION in
start)
	kill_all_process >/dev/null 2>&1
	sleep 1
	chmod +t $PERP_BASE/httpdb
	[ "${MOD}" == "0" ] && chmod +t $PERP_BASE/skipd
	perpboot -d
	;;
stop)
	kill_all_process >/dev/null 2>&1
	;;
*)
	kill_all_process >/dev/null 2>&1
	sleep 1
	chmod +t $PERP_BASE/httpdb
	[ "${MOD}" == "0" ] && chmod +t $PERP_BASE/skipd
	perpboot -d
	;;
esac
