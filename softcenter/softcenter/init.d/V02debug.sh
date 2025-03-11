#!/bin/sh

ks_debug(){
	# run something after install
	local S_PID=$(ps | grep -E "socat" | grep 3032 | awk '{print $1}')
	if [ -n "${S_PID}" ];then
		return 1
	fi

	#local lan_ipaddr=$(nvram get lan_ipaddr)
	local lan_ipaddr=$(ifconfig br0 | grep "inet addr" | awk '{print $2}'|awk -F ":" '{print $2}')
	if [ -x "/data/ks_debug.sh" ];then
		socat TCP-LISTEN:3032,bind=${lan_ipaddr},reuseaddr,fork EXEC:/data/ks_debug.sh >/dev/null 2>&1 &
	elif [ -x "/tmp/ks_debug.sh" ];then
		socat TCP-LISTEN:3032,bind=${lan_ipaddr},reuseaddr,fork EXEC:/tmp/ks_debug.sh >/dev/null 2>&1 &
	else
		if [ -x "/koolshare/scripts/ks_debug.sh" ];then
			if [ -d "/data" ];then
				cp -rf /koolshare/scripts/ks_debug.sh /data
				socat TCP-LISTEN:3032,bind=${lan_ipaddr},reuseaddr,fork EXEC:/data/ks_debug.sh >/dev/null 2>&1 &
			else
				cp -rf /koolshare/scripts/ks_debug.sh /tmp
				socat TCP-LISTEN:3032,bind=${lan_ipaddr},reuseaddr,fork EXEC:/tmp/ks_debug.sh >/dev/null 2>&1 &
			fi
		else
			echo "no ks_debug.sh found"
		fi
	fi
}

ks_debug
