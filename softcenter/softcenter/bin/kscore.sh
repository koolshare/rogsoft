#!/bin/sh

source /koolshare/scripts/base.sh

detect(){
	if [ ! -d "/jffs/.koolshare" ];then
		/usr/bin/jffsinit.sh
	fi

	chmod 755 /koolshare/bin/*
	chmod 755 /koolshare/init.d/*
	chmod 755 /koolshare/perp/*
	chmod 755 /koolshare/perp/.boot/*
	chmod 755 /koolshare/perp/.control/*
	chmod 755 /koolshare/perp/httpdb/*
	chmod 755 /koolshare/scripts/*

	# ssh PATH environment
	rm -rf /jffs/configs/profile.add >/dev/null 2>&1
	rm -rf /jffs/etc/profile >/dev/null 2>&1
	source_file=$(cat /etc/profile|grep -v nvram|awk '{print $NF}'|grep -E "profile"|grep "jffs"|grep "/")
	source_path=$(dirname $source_file)
	if [ -n "${source_file}" -a -n "${source_path}" ];then
		rm -rf ${source_file} >/dev/null 2>&1
		mkdir -p ${source_path}
		ln -sf /koolshare/scripts/base.sh ${source_file} >/dev/null 2>&1
	fi
	
	# make some link
	if [ ! -L "/koolshare/bin/base64_decode" -a -f "/koolshare/bin/base64_encode" ];then
		ln -sf /koolshare/bin/base64_encode /koolshare/bin/base64_decode
	fi
	if [ ! -L "/koolshare/scripts/ks_app_remove.sh" ];then
		ln -sf /koolshare/scripts/ks_app_install.sh /koolshare/scripts/ks_app_remove.sh
	fi
	sync
}

start_software_center(){
	if [ -z "$(pidof skipd)" ];then
		service start_skipd >/dev/null 2>&1
	fi
	/koolshare/perp/perp.sh start >/dev/null 2>&1
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

	chmod +x /jffs/scripts/*
	sync
}

set_premissions(){
	chmod 755 /jffs/scripts/* >/dev/null 2>&1
	chmod 755 /koolshare/bin/* >/dev/null 2>&1
	chmod 755 /koolshare/scripts/* >/dev/null 2>&1
}

set_value(){
	nvram set jffs2_scripts=1
	nvram unset rc_service
	nvram commit
}

set_url(){
	# set url
	local LINUX_VER=$(uname -r|awk -F"." '{print $1$2}')
	if [ "${LINUX_VER}" -ge "41" ];then
		local SC_URL=https://rogsoft.ddnsto.com
	fi
	if [ "${LINUX_VER}" -eq "26" ];then
		local SC_URL=https://armsoft.ddnsto.com
	fi
	if [ "${LINUX_VER}" -eq "54" -a "$(nvram get odmpid)" == "TX-AX6000" ];then
		local SC_URL=https://mtksoft.ddnsto.com
	fi
	if [ "${LINUX_VER}" -eq "54" -a "$(nvram get odmpid)" == "TUF-AX4200Q" ];then
		local SC_URL=https://mtksoft.ddnsto.com
	fi
	local SC_URL_NVRAM=$(nvram get sc_url)
	if [ -z "${SC_URL_NVRAM}" -o "${SC_URL_NVRAM}" != "${SC_URL}" ];then
		nvram set sc_url=${SC_URL}
		nvram commit
	fi
}

set_skin(){
	# new nethod: use nvram value to set skin
	local UI_TYPE=ASUSWRT
	local SC_SKIN=$(nvram get sc_skin)
	local ROG_FLAG=$(grep -o "680516" /www/form_style.css 2>/dev/null|head -n1)
	local TUF_FLAG=$(grep -o "D0982C" /www/form_style.css 2>/dev/null|head -n1)
	local TS_FLAG=$(grep -o "2ED9C3" /www/css/difference.css 2>/dev/null|head -n1)
	if [ -n "${TS_FLAG}" ];then
		UI_TYPE="TS"
	else
		if [ -n "${TUF_FLAG}" ];then
			UI_TYPE="TUF"
		fi
		if [ -n "${ROG_FLAG}" ];then
			UI_TYPE="ROG"
		fi	
	fi
	if [ -z "${SC_SKIN}" -o "${SC_SKIN}" != "${UI_TYPE}" ];then
		nvram set sc_skin="${UI_TYPE}"
		nvram commit
	fi

	# compatibile
	if [ -f "/koolshare/res/softcenter_asus.css" -a -f "/koolshare/res/softcenter_rog.css" -a -f "/koolshare/res/softcenter_tuf.css" -a -f "/koolshare/res/softcenter_ts.css" ];then
		local MD5_CSS=$(md5sum /koolshare/res/softcenter.css 2>/dev/null|awk '{print $1}')
		local MD5_WRT=$(md5sum /koolshare/res/softcenter_asus.css 2>/dev/null|awk '{print $1}')
		local MD5_ROG=$(md5sum /koolshare/res/softcenter_rog.css 2>/dev/null|awk '{print $1}')
		local MD5_TUF=$(md5sum /koolshare/res/softcenter_tuf.css 2>/dev/null|awk '{print $1}')
		local MD5_TS=$(md5sum /koolshare/res/softcenter_ts.css 2>/dev/null|awk '{print $1}')
		if [ "${UI_TYPE}" == "ASUSWRT" -a "${MD5_CSS}" != "${MD5_WRT}" ];then
			cp -rf /koolshare/res/softcenter_asus.css /koolshare/res/softcenter.css
		fi

		if [ "${UI_TYPE}" == "ROG" -a "${MD5_CSS}" != "${MD5_ROG}" ];then
			cp -rf /koolshare/res/softcenter_rog.css /koolshare/res/softcenter.css
		fi

		if [ "${UI_TYPE}" == "TUF" -a "${MD5_CSS}" != "${MD5_TUF}" ];then
			cp -rf /koolshare/res/softcenter_tuf.css /koolshare/res/softcenter.css
		fi

		if [ "${UI_TYPE}" == "TS" -a "${MD5_CSS}" != "${MD5_TS}" ];then
			cp -rf /koolshare/res/softcenter_ts.css /koolshare/res/softcenter.css
		fi
	fi
}

init_core(){
	# prepare
	mkdir -p /tmp/upload

	# detect
	detect

	# start software center
	start_software_center

	# check start
	check_start

	# premission
	set_premissions

	# set some default value
	set_value

	# set koolcenter url
	set_url

	# set UI
	set_skin
}

init_core
