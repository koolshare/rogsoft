#!/bin/sh

# use this scripts to switch between softcenter and koolcenter

source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
TITLE=$(dbus get softcenter_module_center_title)

number_test(){
	case $1 in
		''|*[!0-9]*)
			echo 1
			;;
		*)
			echo 0
			;;
	esac
}

remove_center(){
	# switch
	if [ -f /jffs/.koolshare/webs/Module_Softcenter_old.asp -a -f /jffs/.koolshare/.soft_ver_old ];then
		switch_old jffs
	fi

	if [ -f /cifs2/.koolshare/webs/Module_Softcenter_old.asp -a -f /cifs2/.koolshare/.soft_ver_old ];then
		switch_old cifs2
	fi

	# remove
	rm -rf /jffs/.koolshare/webs/Module_Softcenter_new.asp >/dev/null 2>&1
	rm -rf /jffs/.koolshare/res/soft-v19 >/dev/null 2>&1
	rm -rf /jffs/.koolshare/.soft_ver_new >/dev/null 2>&1
	rm -rf /cifs2/.koolshare/webs/Module_Softcenter_new.asp >/dev/null 2>&1
	rm -rf /cifs2/.koolshare/res/soft-v19 >/dev/null 2>&1
	rm -rf /cifs2/.koolshare/.soft_ver_new >/dev/null 2>&1
	echo_date "移除koolcenter！"
}

switch_old(){
	local kshome=$1
	local SVER_1=$(cat /${kshome}/.koolshare/.soft_ver_old)
	[ -n "${SVER_1}" ] && echo_date "切换到softcenter ${SVER_1}！"
	[ "$kshome" == "jffs" ] && dbus set softcenter_version=${SVER_1}
	mv /${kshome}/.koolshare/.soft_ver /${kshome}/.koolshare/.soft_ver_new
	mv /${kshome}/.koolshare/.soft_ver_old /${kshome}/.koolshare/.soft_ver
	mv /${kshome}/.koolshare/webs/Module_Softcenter.asp /${kshome}/.koolshare/webs/Module_Softcenter_new.asp
	mv /${kshome}/.koolshare/webs/Module_Softcenter_old.asp /${kshome}/.koolshare/webs/Module_Softcenter.asp
	if [ -n "${TITLE}" ];then
		dbus set softcenter_module_center_title="koolcenter 一键切换"
		dbus set softcenter_module_center_description="softcenter → koolcenter 一键切换！"
	fi
}

switch_new(){
	local kshome=$1
	local SVER_2=$(cat /${kshome}/.koolshare/.soft_ver_new)
	[ -n "${SVER_2}" ] && echo_date "切换到koolcenter ${SVER_2}！"
	dbus set softcenter_version=${SVER_2}
	mv /${kshome}/.koolshare/.soft_ver /${kshome}/.koolshare/.soft_ver_old
	mv /${kshome}/.koolshare/.soft_ver_new /${kshome}/.koolshare/.soft_ver
	mv /${kshome}/.koolshare/webs/Module_Softcenter.asp /${kshome}/.koolshare/webs/Module_Softcenter_old.asp
	mv /${kshome}/.koolshare/webs/Module_Softcenter_new.asp /${kshome}/.koolshare/webs/Module_Softcenter.asp
	if [ -n "${TITLE}" ];then
		dbus set softcenter_module_center_title="softcenter 一键切换"
		dbus set softcenter_module_center_description="koolcenter → softcenter 一键切换！"
	fi
}

switch_center(){
	if [ -f /jffs/.koolshare/webs/Module_Softcenter_old.asp -a -f /jffs/.koolshare/.soft_ver_old ];then
		switch_old jffs
		CENTER_TYPE=$(cat /koolshare/webs/Module_Softcenter.asp | grep -Eo "/softcenter/app.json.js")
		if [ -z "$CENTER_TYPE" ];then
			return 1
		else
			return 0
		fi
	elif [ -f /jffs/.koolshare/webs/Module_Softcenter_new.asp -a -f /jffs/.koolshare/.soft_ver_new ];then
		switch_new jffs
		CENTER_TYPE=$(cat /koolshare/webs/Module_Softcenter.asp | grep -Eo "/softcenter/app.json.js")
		if [ -z "$CENTER_TYPE" ];then
			return 0
		else
			return 1
		fi
	else
		return 1
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

if [ $# == 2 -a $(number_test $1) == 0 ];then
	switch_center
	if [ "$?" == "0" ];then
		http_response "$1"
	else
		CENTER_TYPE=$(cat /koolshare/webs/Module_Softcenter.asp | grep -Eo "/softcenter/app.json.js")
		if [ -z "$CENTER_TYPE" ];then
			http_response "错误：没有检测到softcenter，不切换！"
		else
			http_response "错误：没有检测到koolcenter，不切换！"
		fi
	fi
	set_skin
	exit 0
fi

if [ $# == 1 -a "$1" == "remove" ];then
	remove_center
	exit 0
fi

switch_center

