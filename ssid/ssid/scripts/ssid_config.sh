#!/bin/sh
eval `dbus export ssid`
source /koolshare/scripts/base.sh

ssid_24_origin=`nvram get wl0_ssid`
ssid_50_origin=`nvram get wl1_ssid`

set_ssid(){
	if [ "$ssid_24_origin" != "$ssid_24" ] || [ "$ssid_50_origin" != "$ssid_50" ] && [ ! -z "$ssid_24" ] && [ ! -z "$ssid_50" ];then
		# set 2.4G wireless ssid
		nvram set wl0_ssid="$ssid_24"
		
		# set 5G wireless ssid
		nvram set wl1_ssid="$ssid_50"
		
		# restart wifi
		service restart_wireless
	fi
}

set_ssid
