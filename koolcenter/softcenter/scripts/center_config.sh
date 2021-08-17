#!/bin/sh

# use this scripts to switch between softcenter and koolcenter

source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
TITLE=$(dbus get softcenter_module_center_title)

switch_center(){
	if [ -f /jffs/.koolshare/webs/Module_Softcenter_old.asp -a -f /jffs/.koolshare/.soft_ver_old ];then
		local SVER_1=$(cat /jffs/.koolshare/.soft_ver_old)
		[ -n "${SVER_1}" ] && echo_date "切换到softcenter ${SVER_1}！"
		dbus set softcenter_version=${SVER_1}
		mv /jffs/.koolshare/.soft_ver /jffs/.koolshare/.soft_ver_new
		mv /jffs/.koolshare/.soft_ver_old /jffs/.koolshare/.soft_ver
		mv /jffs/.koolshare/webs/Module_Softcenter.asp /jffs/.koolshare/webs/Module_Softcenter_new.asp
		mv /jffs/.koolshare/webs/Module_Softcenter_old.asp /jffs/.koolshare/webs/Module_Softcenter.asp
		if [ -n "${TITLE}" ];then
			dbus set softcenter_module_center_title="koolcenter 一键切换"
			dbus set softcenter_module_center_description="softcenter → koolcenter 一键切换！"
		fi
	elif [ -f /jffs/.koolshare/webs/Module_Softcenter_new.asp -a -f /jffs/.koolshare/.soft_ver_new ];then
		local SVER_2=$(cat /jffs/.koolshare/.soft_ver_new)
		[ -n "${SVER_2}" ] && echo_date "切换到koolcenter ${SVER_2}！"
		dbus set softcenter_version=${SVER_2}
		mv /jffs/.koolshare/.soft_ver /jffs/.koolshare/.soft_ver_old
		mv /jffs/.koolshare/.soft_ver_new /jffs/.koolshare/.soft_ver
		mv /jffs/.koolshare/webs/Module_Softcenter.asp /jffs/.koolshare/webs/Module_Softcenter_old.asp
		mv /jffs/.koolshare/webs/Module_Softcenter_new.asp /jffs/.koolshare/webs/Module_Softcenter.asp
		if [ -n "${TITLE}" ];then
			dbus set softcenter_module_center_title="softcenter 一键切换"
			dbus set softcenter_module_center_description="koolcenter → softcenter 一键切换！"
		fi
	fi
}

switch_center
if [ "$#" == "2" ];then
	http_response $1
fi
