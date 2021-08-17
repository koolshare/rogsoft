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
	elif [ -f /jffs/.koolshare/webs/Module_Softcenter_new.asp -a -f /jffs/.koolshare/.soft_ver_new ];then
		switch_new jffs
	fi
}

if [ $# == 2 -a $(number_test $1) == 0 ];then
	http_response "$1"
	switch_center
	exit 0
fi

if [ $# == 1 -a "$1" == "remove" ];then
	remove_center
	exit 0
fi

switch_center

