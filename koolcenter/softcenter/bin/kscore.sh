#!/bin/sh

source /koolshare/scripts/base.sh

get_model(){
	local ODMPID=$(nvram get odmpid)
	local PRODUCTID=$(nvram get productid)
	if [ -n "${ODMPID}" ];then
		MODEL="${ODMPID}"
	else
		MODEL="${PRODUCTID}"
	fi
}

get_fw_type() {
	local KS_TAG=$(nvram get extendno|grep koolshare)
	if [ -d "/koolshare" ];then
		if [ -n "${KS_TAG}" ];then
			FW_TYPE_CODE="2"
			FW_TYPE_NAME="koolshare官改固件"
		else
			FW_TYPE_CODE="4"
			FW_TYPE_NAME="koolshare梅林改版固件"
		fi
	else
		if [ "$(uname -o|grep Merlin)" ];then
			FW_TYPE_CODE="3"
			FW_TYPE_NAME="梅林原版固件"
		else
			FW_TYPE_CODE="1"
			FW_TYPE_NAME="华硕官方固件"
		fi
	fi
}

get_ui_type(){
	# default value
	UI_TYPE=ASUSWRT
	[ "${MODEL}" == "RT-AC86U" ] && local ROG_RTAC86U=0
	[ "${MODEL}" == "GT-AC2900" ] && local ROG_GTAC2900=1
	[ "${MODEL}" == "GT-AC5300" ] && local ROG_GTAC5300=1
	[ "${MODEL}" == "GT-AX11000" ] && local ROG_GTAX11000=1
	[ "${MODEL}" == "GT-AXE11000" ] && local ROG_GTAXE11000=1
	local KS_TAG=$(nvram get extendno|grep koolshare)
	local EXT_NU=$(nvram get extendno)
	local EXT_NU=$(echo ${EXT_NU%_*} | grep -Eo "^[0-9]{1,10}$")
	local BUILDNO=$(nvram get buildno)
	[ -z "${EXT_NU}" ] && EXT_NU="0"
	# RT-AC86U
	if [ -n "${KS_TAG}" -a "${MODEL}" == "RT-AC86U" -a "${EXT_NU}" -lt "81918" -a "${BUILDNO}" != "386" ];then
		# RT-AC86U的官改固件，在384_81918之前的固件都是ROG皮肤，384_81918及其以后的固件（包括386）为ASUSWRT皮肤
		ROG_RTAC86U=1
	fi
	# GT-AC2900
	if [ "${MODEL}" == "GT-AC2900" ] && [ "${FW_TYPE_CODE}" == "3" -o "${FW_TYPE_CODE}" == "4" ];then
		# GT-AC2900从386.1开始已经支持梅林固件，其UI是ASUSWRT
		ROG_GTAC2900=0
	fi
	# GT-AX11000
	if [ "${MODEL}" == "GT-AX11000" -o "${MODEL}" == "GT-AX11000_BO4" ] && [ "${FW_TYPE_CODE}" == "3" -o "${FW_TYPE_CODE}" == "4" ];then
		# GT-AX11000从386.2开始已经支持梅林固件，其UI是ASUSWRT
		ROG_GTAX11000=0
	fi
	# ROG UI
	if [ "${ROG_GTAC5300}" == "1" -o "${ROG_RTAC86U}" == "1" -o "${ROG_GTAC2900}" == "1" -o "${ROG_GTAX11000}" == "1" -o "${ROG_GTAXE11000}" == "1" ];then
		# GT-AC5300、RT-AC86U部分版本、GT-AC2900部分版本、GT-AX11000部分版本、GT-AXE11000全部版本，骚红皮肤
		UI_TYPE="ROG"
	fi
	# TUF UI
	if [ "${MODEL%-*}" == "TUF" ];then
		# 官改固件，橙色皮肤
		UI_TYPE="TUF"
	fi
}

check_start(){
	# check start up scripts 
	if [ ! -f "/jffs/scripts/wan-start" ];then
		cat > /jffs/scripts/wan-start <<-EOF
		#!/bin/sh
		/koolshare/bin/ks-wan-start.sh start
		EOF
	else
		STARTCOMAND1=$(cat /jffs/scripts/wan-start | grep -c "/koolshare/bin/ks-wan-start.sh start")
		[ "$STARTCOMAND1" -gt "1" ] && sed -i '/ks-wan-start.sh/d' /jffs/scripts/wan-start && sed -i '1a /koolshare/bin/ks-wan-start.sh start' /jffs/scripts/wan-start
		[ "$STARTCOMAND1" == "0" ] && sed -i '1a /koolshare/bin/ks-wan-start.sh start' /jffs/scripts/wan-start
	fi
	
	if [ ! -f "/jffs/scripts/nat-start" ];then
		cat > /jffs/scripts/nat-start <<-EOF
		#!/bin/sh
		/koolshare/bin/ks-nat-start.sh start_nat
		EOF
	else
		STARTCOMAND2=$(cat /jffs/scripts/nat-start | grep -c "/koolshare/bin/ks-nat-start.sh start_nat")
		[ "$STARTCOMAND2" -gt "1" ] && sed -i '/ks-nat-start.sh/d' /jffs/scripts/nat-start && sed -i '1a /koolshare/bin/ks-nat-start.sh start_nat' /jffs/scripts/nat-start
		[ "$STARTCOMAND2" == "0" ] && sed -i '1a /koolshare/bin/ks-nat-start.sh start_nat' /jffs/scripts/nat-start
	fi
	
	if [ ! -f "/jffs/scripts/post-mount" ];then
		cat > /jffs/scripts/post-mount <<-EOF
		#!/bin/sh
		/koolshare/bin/ks-mount-start.sh start \$1
		EOF
	else
		STARTCOMAND3=$(cat /jffs/scripts/post-mount | grep -c "/koolshare/bin/ks-mount-start.sh start \$1")
		[ "$STARTCOMAND3" -gt "1" ] && sed -i '/ks-mount-start.sh/d' /jffs/scripts/post-mount && sed -i '1a /koolshare/bin/ks-mount-start.sh start $1' /jffs/scripts/post-mount
		[ "$STARTCOMAND3" == "0" ] && sed -i '/ks-mount-start.sh/d' /jffs/scripts/post-mount && sed -i '1a /koolshare/bin/ks-mount-start.sh start $1' /jffs/scripts/post-mount
	fi
	
	if [ ! -f "/jffs/scripts/services-start" ];then
		cat > /jffs/scripts/services-start <<-EOF
		#!/bin/sh
		/koolshare/bin/ks-services-start.sh
		EOF
	else
		STARTCOMAND4=$(cat /jffs/scripts/services-start | grep -c "/koolshare/bin/ks-services-start.sh")
		[ "$STARTCOMAND4" -gt "1" ] && sed -i '/ks-services-start.sh/d' /jffs/scripts/services-start && sed -i '1a /koolshare/bin/ks-services-start.sh' /jffs/scripts/services-start
		[ "$STARTCOMAND4" == "0" ] && sed -i '1a /koolshare/bin/ks-services-start.sh' /jffs/scripts/services-start
	fi
	
	if [ ! -f "/jffs/scripts/services-stop" ];then
		cat > /jffs/scripts/services-stop <<-EOF
		#!/bin/sh
		/koolshare/bin/ks-services-stop.sh
		EOF
	else
		STARTCOMAND5=$(cat /jffs/scripts/services-stop | grep -c "/koolshare/bin/ks-services-stop.sh")
		[ "$STARTCOMAND5" -gt "1" ] && sed -i '/ks-services-stop.sh/d' /jffs/scripts/services-stop && sed -i '1a /koolshare/bin/ks-services-stop.sh' /jffs/scripts/services-stop
		[ "$STARTCOMAND5" == "0" ] && sed -i '1a /koolshare/bin/ks-services-stop.sh' /jffs/scripts/services-stop
	fi
	
	if [ ! -f "/jffs/scripts/unmount" ];then
		cat > /jffs/scripts/unmount <<-EOF
		#!/bin/sh
		/koolshare/bin/ks-unmount.sh \$1
		EOF
	else
		STARTCOMAND6=$(cat /jffs/scripts/unmount | grep -c "/koolshare/bin/ks-unmount.sh \$1")
		[ "$STARTCOMAND6" -gt "1" ] && sed -i '/ks-unmount.sh/d' /jffs/scripts/unmount && sed -i '1a /koolshare/bin/ks-unmount.sh $1' /jffs/scripts/unmount
		[ "$STARTCOMAND6" == "0" ] && sed -i '1a /koolshare/bin/ks-unmount.sh $1' /jffs/scripts/unmount
	fi
}

set_premissions(){
	chmod 755 /jffs/scripts/* >/dev/null 2>&1
	chmod 755 /koolshare/bin/* >/dev/null 2>&1
	chmod 755 /koolshare/scripts/* >/dev/null 2>&1
}

set_url(){
	# set url
	SC_URL=https://rogsoft.ddnsto.com
	local SC_URL=$(nvram get sc_url)
	if [ -n "${sc_url}" ];then
		return 0
	fi
	local LINUX_VER=$(uname -r|awk -F"." '{print $1$2}')
	if [ "${LINUX_VER}" -ge "41" ];then
		nvram set sc_url=https://rogsoft.ddnsto.com
		nvram commit
	fi

	if [ "${LINUX_VER}" -eq "26" ];then
		nvram set sc_url=https://armsoft.ddnsto.com
		nvram commit
	fi
}

set_skin(){
	get_model
	get_fw_type
	get_ui_type
	nvram set sc_skin=${UI_TYPE}
	nvram commit
}

init_core(){
	# prepare
	mkdir -p /tmp/upload

	# start software center
	sh /koolshare/perp/perp.sh

	# check start
	check_start

	# premission
	set_premissions

	# set some default value
	nvram set jffs2_scripts=1
	nvram commit

	# set koolcenter
	set_url
	set_skin
}

init_core
