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

copy() {
	# echo_date "$*" 2>&1
	"$@" 2>/dev/null
	# "$@" 2>&1
	if [ "$?" != "0" ];then
		#echo_date "$* 命令运行错误！可能是/jffs分区空间不足！"
		echo_date "复制文件错误！可能是/jffs分区空间不足！"
		echo_date "尝试删除本次已经安装的文件..."
		remove_files
		exit 1
	fi
}

remove_files(){
	# files should be removed before install
	echo_date "删除zerotier插件相关文件！"
	rm -rf /tmp/zerotier* >/dev/null 2>&1
	rm -rf /koolshare/bin/file >/dev/null 2>&1
	rm -rf /koolshare/bin/zerotier* >/dev/null 2>&1
	rm -rf /koolshare/res/icon-zerotier.png >/dev/null 2>&1
	rm -rf /koolshare/res/zt_*.png >/dev/null 2>&1
	rm -rf /koolshare/scripts/zerotier_* >/dev/null 2>&1
	rm -rf /koolshare/scripts/uninstall_zerotier.sh >/dev/null 2>&1
	rm -rf /koolshare/webs/Module_zerotier.asp >/dev/null 2>&1
	rm -rf /koolshare/share/misc/magic >/dev/null 2>&1
	find /koolshare/init.d -name "*zerotier*" | xargs rm -rf

	if [ -d "/koolshare/share" ];then
		local FLAG_1=$(ls -aelR /koolshare/share | sed '/:$/d' | sed '/^$/d' | sed '/^d/d' 2>/dev/null)
		if [ -z "$FLAG_1" ];then
			rm -rf /koolshare/share
		fi
	fi

	if [ -d "/koolshare/lib" ];then
		cd /koolshare/lib
		if [ -f "/koolshare/lib/.flag_zerotier.txt" ];then
			echo_date "删除zerotier插件相关依赖！"
			cat .flag_*.txt | sort -k2 | uniq -f1 -u | grep -E "^zerotier" | awk '{print $2}' | xargs rm -rf >/dev/null 2>&1
			rm -rf .flag_zerotier.txt
		fi
		if [ -z "$(ls)" ];then
			cd /
			rm -rf /koolshare/lib
		fi
	fi
}

install_now(){
	# default value
	local TITLE="ZeroTier"
	local DESCR="ZeroTier 内网穿透"
	local PLVER=$(cat ${DIR}/version)

	# stop first
	local ENABLE=$(dbus get ${module}_enable)
	if [ "${ENABLE}" == "1" -a -f "/koolshare/scripts/zerotier_config" ];then
		echo_date "先关闭zerotier插件，保证文件更新成功..."
		/koolshare/scripts/zerotier_config stop
	fi

	# remove some file first
	rm -rf /koolshare/scripts/zerotier*
	find /koolshare/init.d -name "*zerotier*" | xargs rm -rf

	rm -rf /koolshare/bin/file >/dev/null 2>&1
	rm -rf /koolshare/share/misc/magic >/dev/null 2>&1
	

	# isntall file
	echo_date "安装插件相关文件..."
	local ARCH=$(uname -m)
	cd /tmp
	copy cp -rf /tmp/${module}/res/* /koolshare/res/
	copy cp -rf /tmp/${module}/scripts/* /koolshare/scripts/
	copy cp -rf /tmp/${module}/init.d/* /koolshare/init.d/
	copy cp -rf /tmp/${module}/webs/* /koolshare/webs/
	copy cp -rf /tmp/${module}/uninstall.sh /koolshare/scripts/uninstall_${module}.sh
	mkdir -p /koolshare/lib/
	if [ ! -x "/koolshare/bin/jq" ]; then
		echo_date "安装jq..."
		copy cp -fP /tmp/${module}/bin/jq /koolshare/bin/
	fi
	if [ "$ARCH" == "aarch64" ]; then
		echo_date "安装64位zerotier-one..."
		copy cp -fP /tmp/${module}/lib64/.flag_*.txt /koolshare/lib/
		copy cp -fP /tmp/${module}/bin64/* /koolshare/bin/
		copy cp -fP /tmp/${module}/lib64/* /koolshare/lib/
	fi
	if [ "$ARCH" == "armv7l" ]; then
		echo_date "安装32位zerotier-one..."
		copy cp -fP /tmp/${module}/lib32/.flag_*.txt /koolshare/lib/
		copy cp -fP /tmp/${module}/bin32/* /koolshare/bin/
		copy cp -fP /tmp/${module}/lib32/* /koolshare/lib/
	fi

	# Permissions
	chmod 755 /koolshare/scripts/* >/dev/null 2>&1
	chmod 755 /koolshare/bin/* >/dev/null 2>&1

	# intall different UI
	set_skin

	# dbus value
	echo_date "设置插件默认参数..."
	dbus set ${module}_version="${PLVER}"
	dbus set softcenter_module_${module}_version="${PLVER}"
	dbus set softcenter_module_${module}_install="1"
	dbus set softcenter_module_${module}_name="${module}"
	dbus set softcenter_module_${module}_title="${TITLE}"
	dbus set softcenter_module_${module}_description="${DESCR}"

	# re-enable
	if [ "${ENABLE}" == "1" -a -f "/koolshare/scripts/zerotier_config" ];then
		echo_date "安装完毕，重新启用zerotier插件！"
		/koolshare/scripts/zerotier_config start
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
