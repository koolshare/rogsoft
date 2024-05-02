#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=
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
	local KS_TAG=$(nvram get extendno|grep -Eo "kool.+")
	if [ -d "/koolshare" ];then
		if [ -n "${KS_TAG}" ];then
			FW_TYPE_CODE="2"
			FW_TYPE_NAME="${KS_TAG}官改固件"
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

platform_test(){
	local LINUX_VER=$(uname -r|awk -F"." '{print $1$2}')
	if [ -d "/koolshare" -a -f "/usr/bin/skipd" -a "${LINUX_VER}" -ge "41" ];then
		echo_date 机型："${MODEL} ${FW_TYPE_NAME} 符合安装要求，开始安装插件！"
	else
		exit_install 1
	fi
}

set_skin(){
	local UI_TYPE=ASUSWRT
	local SC_SKIN=$(nvram get sc_skin)
	local ROG_FLAG=$(grep -o "680516" /www/form_style.css 2>/dev/null|head -n1)
	local TUF_FLAG=$(grep -o "D0982C" /www/form_style.css 2>/dev/null|head -n1)
	local TS_FLAG=$(grep -o "2ED9C3" /www/css/difference.css 2>/dev/null|head -n1)
	if [ -n "${ROG_FLAG}" ];then
		UI_TYPE="ROG"
	fi
	if [ -n "${TUF_FLAG}" ];then
		UI_TYPE="TUF"
	fi
	if [ -n "${TS_FLAG}" ];then
		UI_TYPE="TS"
	fi

	if [ -z "${SC_SKIN}" -o "${SC_SKIN}" != "${UI_TYPE}" ];then
		nvram set sc_skin="${UI_TYPE}"
		nvram commit
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

install_now(){
	# default value
	local TITLE="Tailscale"
	local DESCR="基于wiregurad协议的零配置内网穿透安全组网工具！"
	local PLVER=$(cat ${DIR}/version)

	# stop before install
	if [ "$(dbus get tailscale_enable)" == "1" -a -f "/koolshare/scripts/tailscale_config" ];then
		echo_date "安装前先关闭插件..."
		/koolshare/scripts/tailscale_config stop
	fi

	# remove before install
	rm -rf /koolshare/bin/tailscale* >/dev/null 2>&1
	rm -rf /koolshare/res/icon-tailscale.png >/dev/null 2>&1
	rm -rf /koolshare/scripts/tailscale_* >/dev/null 2>&1
	rm -rf /koolshare/scripts/uninstall_tailscale.sh >/dev/null 2>&1
	rm -rf /koolshare/webs/Module_tailscale.asp >/dev/null 2>&1
	find /koolshare/init.d -name "*tailscale*" | xargs rm -rf	

	# install file
	echo_date "安装插件相关文件..."
	cd /tmp
	cp -rf /tmp/${module}/bin/* /koolshare/bin/
	cp -rf /tmp/${module}/init.d/* /koolshare/init.d/
	cp -rf /tmp/${module}/res/* /koolshare/res/
	cp -rf /tmp/${module}/scripts/* /koolshare/scripts/
	cp -rf /tmp/${module}/webs/* /koolshare/webs/
	cp -rf /tmp/${module}/uninstall.sh /koolshare/scripts/uninstall_${module}.sh

	# Permissions
	chmod 755 /koolshare/bin/tailscale* >/dev/null 2>&1
	chmod 755 /koolshare/scripts/tailscale*.sh >/dev/null 2>&1
	chmod 755 /koolshare/init.d/*tailscale.sh >/dev/null 2>&1

	# intall different UI
	set_skin

	# set default value, incase in upgrade, newer script can't get latest key-value from web
	if [ -z "$(dbus get tailscale_accept_routes)" ];then
		dbus set tailscale_accept_routes="1"
	fi

	if [ -z "$(dbus get tailscale_advertise_routes)" ];then
		dbus set tailscale_advertise_routes="1"
	fi

	if [ -z "$(dbus get tailscale_exit_node)" ];then
		dbus set tailscale_exit_node="0"
	fi
	
	# dbus value
	echo_date "设置插件默认参数..."
	dbus set ${module}_version="${PLVER}"
	dbus set softcenter_module_${module}_version="${PLVER}"
	dbus set softcenter_module_${module}_install="1"
	dbus set softcenter_module_${module}_name="${module}"
	dbus set softcenter_module_${module}_title="${TITLE}"
	dbus set softcenter_module_${module}_description="${DESCR}"

	# start after install
	if [ "$(dbus get tailscale_enable)" == "1" -a -f "/koolshare/scripts/tailscale_config" ];then
		echo_date "重新开启插件..."
		/koolshare/scripts/tailscale_config start
	fi

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
