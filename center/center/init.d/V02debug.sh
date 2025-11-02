#!/bin/sh

check_device(){
	if [ ! -d "/data" ];then
		return "1"
	fi
	
	mkdir -p $1/rw_test 2>/dev/null
	sync
	if [ -d "$1/rw_test" ]; then
		echo "rwTest=OK" >"$1/rw_test/rw_test.txt"
		sync
		if [ -f "$1/rw_test/rw_test.txt" ]; then
			. "$1/rw_test/rw_test.txt"
			if [ "$rwTest" = "OK" ]; then
				rm -rf "$1/rw_test"
				return "0"
			else
				return "1"
			fi
		else
			return "1"
		fi
	else
		return "1"
	fi
}

ks_debug(){
	# detect if socat running correct
	local PID_TMP=$(ps | grep -E "socat" | grep 3032 | grep tmp | awk '{print $1}')
	if [ -n "${PID_TMP}" -a -x "/tmp/ks_debug.sh" ];then
		return 1
	fi

	local PID_DAT=$(ps | grep -E "socat" | grep 3032 | grep data | awk '{print $1}')
	if [ -n "${PID_DAT}" -a -x "/data/ks_debug.sh" ];then
		return 1
	fi

	# kill socat fist
	if [ -n "${PID_TMP}" ];then
		kill -9 ${PID_TMP}
	fi

	if [ -n "${PID_DAT}" ];then
		kill -9 ${PID_DAT}
	fi

	# start socat
	#local lan_ipaddr=$(nvram get lan_ipaddr)
	local lan_ipaddr=$(ifconfig br0 | grep "inet addr" | awk '{print $2}'|awk -F ":" '{print $2}')
	if [ -x "/data/ks_debug.sh" ];then
		socat TCP-LISTEN:3032,bind=${lan_ipaddr},reuseaddr,fork EXEC:/data/ks_debug.sh >/dev/null 2>&1 &
	elif [ -x "/tmp/ks_debug.sh" ];then
		socat TCP-LISTEN:3032,bind=${lan_ipaddr},reuseaddr,fork EXEC:/tmp/ks_debug.sh >/dev/null 2>&1 &
	else
		if [ -x "/koolshare/scripts/ks_debug.sh" ];then
			check_device "/data" 2>/dev/null
			if [ "$?" == "0" ];then
				cp -rf /koolshare/scripts/ks_debug.sh /data/
				socat TCP-LISTEN:3032,bind=${lan_ipaddr},reuseaddr,fork EXEC:/data/ks_debug.sh >/dev/null 2>&1 &
			else
				cp -rf /koolshare/scripts/ks_debug.sh /tmp/
				socat TCP-LISTEN:3032,bind=${lan_ipaddr},reuseaddr,fork EXEC:/tmp/ks_debug.sh >/dev/null 2>&1 &
			fi
		else
			echo "no ks_debug.sh found"
		fi
	fi
}

ks_debug
