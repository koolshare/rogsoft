#!/bin/sh

source /koolshare/scripts/base.sh

detect(){
	if [ ! -d "/jffs/.koolshare" ];then
		/usr/bin/jffsinit.sh
	fi

	chmod 755 /koolshare/bin/* >/dev/null 2>&1
	chmod 755 /koolshare/init.d/* >/dev/null 2>&1
	chmod 755 /koolshare/perp/* >/dev/null 2>&1
	chmod 755 /koolshare/perp/.boot/* >/dev/null 2>&1
	chmod 755 /koolshare/perp/.control/* >/dev/null 2>&1
	chmod 755 /koolshare/perp/httpdb/* >/dev/null 2>&1
	chmod 755 /koolshare/scripts/* >/dev/null 2>&1

	# ssh PATH environment
	rm -rf /jffs/configs/profile.add >/dev/null 2>&1
	rm -rf /jffs/etc/profile >/dev/null 2>&1
	source_file=$(cat /etc/profile|awk '{print $NF}'|grep -E "profile"|grep "jffs"|grep "/"|head -n1)
	source_path=$(dirname $source_file)
	if [ -n "${source_file}" -a -n "${source_path}" ];then
		rm -rf ${source_file} >/dev/null 2>&1
		mkdir -p ${source_path}
		ln -sf /koolshare/scripts/base.sh ${source_file} >/dev/null 2>&1
	fi

	# make sure software center install script exist
	if [ ! -f "/koolshare/scripts/ks_app_install.sh" ];then
		ln -sf /rom/etc/koolshare/scripts/ks_app_install.sh /koolshare/scripts/ks_app_install.sh
	fi
	if [ ! -f "/koolshare/scripts/ks_tar_install.sh" ];then
		ln -sf /rom/etc/koolshare/scripts/ks_tar_install.sh /koolshare/scripts/ks_tar_install.sh
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

	chmod +x /jffs/scripts/* >/dev/null 2>&1
	sync
}

set_premissions(){
	# remove broken links
	/usr/bin/find -L /koolshare/ -type l | xargs rm -rf

	# set_premissions
	chmod 755 /jffs/scripts/* 2>/dev/null
	chmod 755 /koolshare/bin/* 2>/dev/null
	chmod 755 /koolshare/scripts/* 2>/dev/null
}

set_value(){
	nvram set 3rd-party=merlin
	nvram set jffs2_scripts=1
	nvram unset rc_service
	nvram commit
}

set_url(){
	local LINUX_VER=$(uname -r | awk -F"." '{print $1$2}')
	if [ "${LINUX_VER}" -ge "41" ];then
		local SC_URL=https://rogsoft.ddnsto.com
	fi
	if [ "${LINUX_VER}" -eq "26" ];then
		local SC_URL=https://armsoft.ddnsto.com
	fi
	local RO_MODEL=$(nvram get odmpid)
	if [ "${RO_MODEL}" == "TX-AX6000" -o "${RO_MODEL}" == "TUF-AX4200Q" -o "${RO_MODEL}" == "RT-AX57_Go" -o "${RO_MODEL}" == "GS7" -o "${RO_MODEL}" == "ZenWiFi_BT8P" ];then
		local SC_URL=https://mtksoft.ddnsto.com
	fi
	if [ "${RO_MODEL}" == "ZenWiFi_BD4" ];then
		local SC_URL=https://ipq32soft.ddnsto.com
	fi
	if [ "${RO_MODEL}" == "TUF_6500" ];then
		local SC_URL=https://ipq64soft.ddnsto.com
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
	local TS_FLAG=$(grep -o "2ED9C3" /www/css/difference.css 2>/dev/null|head -n1)
	local ROG_FLAG=$(cat /www/form_style.css|grep -A1 ".tab_NW:hover{"|grep "background"|sed 's/,//g'|grep -o "2071044")
	local TUF_FLAG=$(cat /www/form_style.css|grep -A1 ".tab_NW:hover{"|grep "background"|sed 's/,//g'|grep -o "D0982C")
	local WRT_FLAG=$(cat /www/form_style.css|grep -A1 ".tab_NW:hover{"|grep "background"|sed 's/,//g'|grep -o "4F5B5F")
	if [ -n "${TS_FLAG}" ];then
		UI_TYPE="TS"
	else
		if [ -n "${TUF_FLAG}" ];then
			UI_TYPE="TUF"
		fi
		if [ -n "${ROG_FLAG}" ];then
			UI_TYPE="ROG"
		fi
		if [ -n "${WRT_FLAG}" ];then
			UI_TYPE="ASUSWRT"
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
