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

platform_test(){
	local LINUX_VER=$(uname -r|awk -F"." '{print $1$2}')
	if [ -d "/koolshare" -a -f "/usr/bin/skipd" -a "${LINUX_VER}" -ge "41" ];then
		echo_date 机型："${MODEL} ${FW_TYPE_NAME} 符合安装要求，开始安装插件！"
	else
		exit_install 1
	fi
}

get_ui_type(){
	# default value
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
	if [ "${MODEL}" == "TUF-AX3000" ];then
		# 官改固件，橙色皮肤
		UI_TYPE="TUF"
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

install_ui(){
	# intall different UI
	get_ui_type
	if [ "${UI_TYPE}" == "ROG" ];then
		echo_date "安装ROG皮肤！"
		sed -i '/asuscss/d' /koolshare/webs/Module_${module}.asp >/dev/null 2>&1
	fi
	if [ "${UI_TYPE}" == "TUF" ];then
		echo_date "安装TUF皮肤！"
		sed -i '/asuscss/d' /koolshare/webs/Module_${module}.asp >/dev/null 2>&1
		sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /koolshare/webs/Module_${module}.asp >/dev/null 2>&1
	fi
	if [ "${UI_TYPE}" == "ASUSWRT" ];then
		echo_date "安装ASUSWRT皮肤！"
		sed -i '/rogcss/d' /koolshare/webs/Module_${module}.asp >/dev/null 2>&1
	fi
}
get_current_jffs_device(){
	# 查看当前/jffs的挂载点是什么设备，如/dev/mtdblock9, /dev/sda1；有usb2jffs的时候，/dev/sda1，无usb2jffs的时候，/dev/mtdblock9，出问题未正确挂载的时候，为空
	local cur_patition=$(df -h | /bin/grep /jffs | awk '{print $1}')
	if [ -n "${cur_patition}" ];then
		jffs_device=${cur_patition}
		return 0
	else
		jffs_device=""
		return 1
	fi
}

get_usb2jffs_status(){
	# 如果正在使用usb2jffs，使用USB磁盘挂载了/jffs分区，那么软件中心需要同时更新到/jffs和cifs2
	get_current_jffs_device
	if [ "$?" != "0" ]; then
		return 1
	fi
	
	local mounted_nu=$(mount | /bin/grep "${jffs_device}" | grep -E "/tmp/mnt/|/jffs"|/bin/grep -c "/dev/s")
	if [ "${mounted_nu}" != "2" ]; then
		return 1
	fi

	local CIFS_STATUS=$(df -h|grep "/cifs2"|awk '{print $1}'|grep "/dev/mtdblock")
	if [ -z "${CIFS_STATUS}" ];then
		return 1
	fi
		
	if [ ! -d "/cifs2/.koolshare" ];then
		return 1
	fi

	# user has mount USB disk to /jffs, and orgin jffs mount device: /dev/mtdblock? mounted on /cifs2
	return 0
}

usb2jffs_install(){
	# default value
	local KSHOME=$1
	local TITLE="USB2JFFS"
	local DESCR="使用U盘轻松挂载jffs"
	local PLVER=$(cat ${DIR}/version)

	# remove some file first
	find /${KSHOME}/.koolshare/res/ -name "ks-*.sh"|xargs rm -rf >/dev/null 2>&1

	# isntall file
	echo_date "安装插件相关文件..."
	find /${KSHOME}/.koolshare/init.d/ -name "*${module}*"|xargs rm -rf >/dev/null 2>&1
	cd /tmp
	cp -rf /tmp/${module}/bin/* /${KSHOME}/.koolshare/bin/
	cp -rf /tmp/${module}/res/* /${KSHOME}/.koolshare/res/
	cp -rf /tmp/${module}/scripts/* /${KSHOME}/.koolshare/scripts/
	cp -rf /tmp/${module}/webs/* /${KSHOME}/.koolshare/webs/
	cp -rf /tmp/${module}/init.d/* /${KSHOME}/.koolshare/init.d/
	cp -rf /tmp/${module}/uninstall.sh /${KSHOME}/.koolshare/scripts/uninstall_${module}.sh

	# post-mount
	if [ ! -f "/${KSHOME}/scripts/post-mount" ];then
		cat > /${KSHOME}/scripts/post-mount <<-EOF
		#!/bin/sh
		/koolshare/bin/ks-mount-start.sh start \$1
		EOF
	else
		STARTCOMAND3=$(cat /${KSHOME}/scripts/post-mount | grep -c "/koolshare/bin/ks-mount-start.sh start \$1")
		[ "$STARTCOMAND3" -gt "1" ] && sed -i '/ks-mount-start.sh/d' /${KSHOME}/scripts/post-mount && sed -i '1a /koolshare/bin/ks-mount-start.sh start $1' /${KSHOME}/scripts/post-mount
		[ "$STARTCOMAND3" == "0" ] && sed -i '/ks-mount-start.sh/d' /${KSHOME}/scripts/post-mount && sed -i '1a /koolshare/bin/ks-mount-start.sh start $1' /${KSHOME}/scripts/post-mount
	fi
	# services-stop
	if [ ! -f "/${KSHOME}/scripts/services-stop" ];then
		cat > /${KSHOME}/scripts/services-stop <<-EOF
		#!/bin/sh
		/koolshare/bin/ks-services-stop.sh
		EOF
	else
		STARTCOMAND5=$(cat /${KSHOME}/scripts/services-stop | grep -c "/koolshare/bin/ks-services-stop.sh")
		[ "$STARTCOMAND5" -gt "1" ] && sed -i '/ks-services-stop.sh/d' /${KSHOME}/scripts/services-stop && sed -i '1a /koolshare/bin/ks-services-stop.sh' /${KSHOME}/scripts/services-stop
		[ "$STARTCOMAND5" == "0" ] && sed -i '1a /koolshare/bin/ks-services-stop.sh' /${KSHOME}/scripts/services-stop
	fi
	# unmount
	if [ ! -f "/${KSHOME}/scripts/unmount" ];then
		cat > /${KSHOME}/scripts/unmount <<-EOF
		#!/bin/sh
		/koolshare/bin/ks-unmount.sh \$1
		EOF
	else
		STARTCOMAND6=$(cat /${KSHOME}/scripts/unmount | grep -c "/koolshare/bin/ks-unmount.sh \$1")
		[ "$STARTCOMAND6" -gt "1" ] && sed -i '/ks-unmount.sh/d' /${KSHOME}/scripts/unmount && sed -i '1a /koolshare/bin/ks-unmount.sh $1' /${KSHOME}/scripts/unmount
		[ "$STARTCOMAND6" == "0" ] && sed -i '1a /koolshare/bin/ks-unmount.sh $1' /${KSHOME}/scripts/unmount
	fi

	# Permissions
	chmod 755 /${KSHOME}/scripts/* >/dev/null 2>&1
	chmod 755 /${KSHOME}/.koolshare/bin/* >/dev/null 2>&1
	chmod 755 /${KSHOME}/.koolshare/scripts/* >/dev/null 2>&1
	chmod 755 /${KSHOME}/.koolshare/init.d/* >/dev/null 2>&1

	# intall different UI
	install_ui

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
}

install_now(){
	get_usb2jffs_status
	if [ "$?" == "0" ];then
		echo_date "检测到你使用USB磁盘挂载了/jffs！"
		echo_date "USB2JFFS插件此次将同时安装到系统jffs和usb jffs！"
		echo_date "-------------------- 更新插件到USB JFFS（/jffs）--------------------"
		usb2jffs_install jffs
		echo_date "----------------------------------------------------------------"
		echo_date "-------------------- 更新插件到系统 JFFS（/cifs2）------------------"
		usb2jffs_install cifs2
		echo_date "----------------------------------------------------------------"
	else
		echo_date "-------------------- 更新插件到系统 JFFS（/jffs）-------------------"
		usb2jffs_install jffs
		echo_date "----------------------------------------------------------------"
	fi
	exit_install 0
}

softver_check(){
	# 判断软件中心版本
	if [ -f "/koolshare/.soft_ver" ];then
		local CUR_VERSION=$(cat /koolshare/.soft_ver)
	else
		local CUR_VERSION="0"
	fi
	local NEED_VERSION="1.6.8"
	local COMP=$(/rom/etc/koolshare/bin/versioncmp ${CUR_VERSION} ${NEED_VERSION})
	if [ "${COMP}" == "1" ]; then
		echo_date "软件中心版本：${CUR_VERSION}，版本号过低，不支持本插件，请将软件中心更新到最新后重试！" 
		rm -rf /tmp/${module}* >/dev/null 2>&1
		exit 1
	fi
}

install(){
	softver_check
	get_model
	get_fw_type
	platform_test
	install_now
}

install
