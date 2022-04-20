#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=
UI_TYPE=ASUSWRT
FW_TYPE_CODE=
FW_TYPE_NAME=
DIR=$(cd $(dirname $0); pwd)
module=${DIR##*/}

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

set_skin(){
	# new nethod: use nvram value to set skin
	local UI_TYPE=ASUSWRT
	local SC_SKIN=$(nvram get sc_skin)
	local ROG_FLAG=$(grep -o "680516" /www/form_style.css|head -n1)
	local TUF_FLAG=$(grep -o "D0982C" /www/form_style.css|head -n1)
	if [ -n "${ROG_FLAG}" ];then
		UI_TYPE="ROG"
	fi
	if [ -n "${TUF_FLAG}" ];then
		UI_TYPE="TUF"
	fi
	
	if [ -z "${SC_SKIN}" -o "${SC_SKIN}" != "${UI_TYPE}" ];then
		nvram set sc_skin="${UI_TYPE}"
		nvram commit
	fi

	# compatibile
	if [ -f "/koolshare/res/softcenter_asus.css" -a -f "/koolshare/res/softcenter_rog.css" -a -f "/koolshare/res/softcenter_tuf.css" ]
		local MD5_CSS=$(md5sum /koolshare/res/softcenter.css|awk '{print $1}')
		local MD5_WRT=$(md5sum /koolshare/res/softcenter_asus.css|awk '{print $1}')
		local MD5_ROG=$(md5sum /koolshare/res/softcenter_rog.css|awk '{print $1}')
		local MD5_TUF=$(md5sum /koolshare/res/softcenter_tuf.css|awk '{print $1}')
		if [ "${UI_TYPE}" == "ASUSWRT" -a "${MD5_CSS}" != "${MD5_WRT}" ];then
			cp -rf /koolshare/res/softcenter_asus.css /koolshare/res/softcenter.css
		fi

		if [ "${UI_TYPE}" == "ROG" -a "${MD5_CSS}" != "${MD5_ROG}" ];then
			cp -rf /koolshare/res/softcenter_rog.css /koolshare/res/softcenter.css
		fi

		if [ "${UI_TYPE}" == "TUF" -a "${MD5_CSS}" != "${MD5_TUF}" ];then
			cp -rf /koolshare/res/softcenter_tuf.css /koolshare/res/softcenter.css
		fi
	fi
}

platform_test(){
	local LINUX_VER=$(uname -r|awk -F"." '{print $1$2}')
	if [ -d "/koolshare" -a -f "/usr/bin/skipd" -a "${LINUX_VER}" -ge "41" ];then
		echo_date 机型："${MODEL} ${FW_TYPE_NAME} 符合安装要求，开始安装插件！"
	else
		exit_install 1
	fi
}

exit_install(){
	local state=$1
	case $state in
		1)
			echo_date "本插件适用于【koolshare 梅林改/官改 hnd/axhnd/axhnd.675x】固件平台！"
			echo_date "你的固件平台不能安装！！!"
			echo_date "本插件支持机型/平台：https://github.com/koolshare/rogsoft#rogsoft"
			echo_date "退出安装！"
			rm -rf /tmp/${module}* >/dev/null 2>&1
			exit 1
			;;
		0|*)
			rm -rf /tmp/${module}* >/dev/null 2>&1
			exit 0
			;;
	esac
}

set_kc_value(){
	local SC_URL=$(nvram get sc_url)

	if [ -z "${SC_URL}" ];then
		local LINUX_VER=$(uname -r|awk -F"." '{print $1$2}')
		if [ "${LINUX_VER}" -ge "41" ];then
			nvram set sc_url=https://rogsoft.ddnsto.com
			nvram commit
		fi
		if [ "${LINUX_VER}" -eq "26" ];then
			nvram set sc_url=https://armsoft.ddnsto.com
			nvram commit
		fi
	fi

	local SC_SKN=$(nvram get sc_skin)
	if [ -z "${SC_SKN}" ];then
		nvram set sc_skin="${UI_TYPE}"
		nvram commit
	fi
}

install_now(){
	# default value
	CENTER_TYPE=$(cat /jffs/.koolshare/webs/Module_Softcenter.asp | grep -Eo "/softcenter/app.json.js")
	if [ -z "$CENTER_TYPE" ];then
		local TITLE="softcenter 一键切换"
		local DESCR="softcenter → koolcenter 一键切换！"
	else
		local TITLE="koolcenter 一键切换"
		local DESCR="koolcenter → softcenter 一键切换！"
	fi	
	local PLVER=$(cat ${DIR}/version)

	# set koolcenter val
	set_kc_value

	# install file
	echo_date "安装插件相关文件..."
	cd /tmp
	cp -rf /tmp/${module}/res/icon-center.png /koolshare/res/
	cp -rf /tmp/${module}/scripts/center_config.sh /koolshare/scripts/
	cp -rf /tmp/${module}/webs/Module_center.asp /koolshare/webs/
	cp -rf /tmp/${module}/uninstall.sh /koolshare/scripts/uninstall_${module}.sh

	# install softcenter/koolcenter web files
	if [ -z "$CENTER_TYPE" ];then
		# koolcenter is use, install softcenter
		cp -rf /tmp/${module}/webs/Module_Softcenter_old.asp /koolshare/webs/
		cp -rf /tmp/${module}/webs/Module_Softsetting.asp /koolshare/webs/
		cp -rf /tmp/${module}/res/softcenter_*.css /koolshare/res/
		cp -rf /tmp/${module}/.soft_ver_old /koolshare/
	else
		# softcenter is use, install koolcenter
		soft_folder=$(dirname /tmp/${module}/res/soft-v*/assets)
		rm -rf /koolshare/res/soft-v*
		cp -rf /tmp/${module}/webs/Module_Softcenter_new.asp /koolshare/webs/
		cp -rf $soft_folder /koolshare/res/
		cp -rf /tmp/${module}/scripts/ks_home_status.sh /koolshare/scripts/
		cp -rf /tmp/${module}/.soft_ver_new /koolshare/
	fi
	
	# Permissions
	chmod 755 /koolshare/scripts/*.sh >/dev/null 2>&1

	# skin
	set_skin

	# dbus value
	echo_date "设置插件默认参数..."
	dbus set ${module}_version="${PLVER}"
	dbus set softcenter_module_${module}_version="${PLVER}"
	dbus set softcenter_module_${module}_install="1"
	dbus set softcenter_module_${module}_name="${module}"
	dbus set softcenter_module_${module}_title="${TITLE}"
	dbus set softcenter_module_${module}_description="${DESCR}"
	
	# finish
	echo_date "${TITLE}插件安装完毕！"
	exit_install
}

install(){
	get_model
	get_fw_type
	platform_test
	install_now
}

install
