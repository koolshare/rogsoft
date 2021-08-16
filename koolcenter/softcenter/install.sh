#!/bin/sh
#
########################################################################
#
# Copyright (C) 2010/2021 kooldev
#
# 此脚本为 hnd/axhnd/axhnd.675x/p1axhnd.675x 平台软件中心安装脚本。
# 软件中心地址: https://github.com/koolshare/rogsoft
#
########################################################################

alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=
UI_TYPE=ASUSWRT
FW_TYPE_CODE=
FW_TYPE_NAME=

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

softcenter_install() {
	local KSHOME=$1

	if [ ! -d "/tmp/softcenter" ]; then
		echo_date "没有找到 /tmp/softcenter 文件夹，退出！"
		return 1
	fi
	
	# make some folders
	echo_date "创建软件中心相关的文件夹..."
	mkdir -p /${KSHOME}/configs/dnsmasq.d
	mkdir -p /${KSHOME}/scripts
	mkdir -p /${KSHOME}/etc
	mkdir -p /${KSHOME}/.koolshare/bin/
	mkdir -p /${KSHOME}/.koolshare/init.d/
	mkdir -p /${KSHOME}/.koolshare/scripts/
	mkdir -p /${KSHOME}/.koolshare/configs/
	mkdir -p /${KSHOME}/.koolshare/webs/
	mkdir -p /${KSHOME}/.koolshare/res/
	mkdir -p /tmp/upload
	
	# remove useless files
	echo_date "尝试清除一些不需要的文件..."
	[ -L "/${KSHOME}/configs/profile" ] && rm -rf /${KSHOME}/configs/profile
	[ -L "/${KSHOME}/.koolshare/webs/files" ] && rm -rf /${KSHOME}/.koolshare/webs/files
	[ -d "/tmp/files" ] && rm -rf /tmp/files

	# do not install some file for some model
	JFFS_TOTAL=$(df|grep -Ew "/${KSHOME}" | awk '{print $2}')
	if [ -n "${JFFS_TOTAL}" -a "${JFFS_TOTAL}" -le "20000" ];then
		echo_date "JFFS空间已经不足2MB！进行精简安装！"
		rm -rf /tmp/softcenter/bin/htop
	else
		echo_date "JFFS空间足够，开始安装！"
	fi
	
	# coping files
	echo_date "开始复制软件中心相关文件..."
	cp -rf /tmp/softcenter/webs/* /${KSHOME}/.koolshare/webs/
	cp -rf /tmp/softcenter/res/* /${KSHOME}/.koolshare/res/
	# ----ui------
	echo_date "获取当前固件UI类型，UI_TYPE: ${UI_TYPE}"
	if [ "${UI_TYPE}" == "ROG" ]; then
		echo_date "为软件中心安装ROG风格的皮肤..."
		cp -rf /tmp/softcenter/ROG/res/* /${KSHOME}/.koolshare/res/
	elif [ "${UI_TYPE}" == "TUF" ]; then
		echo_date "为软件中心安装TUF风格的皮肤..."
		sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /tmp/softcenter/ROG/res/*.css >/dev/null 2>&1
		sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /tmp/softcenter/webs/*.asp >/dev/null 2>&1
		cp -rf /tmp/softcenter/ROG/res/* /${KSHOME}/.koolshare/res/
	elif [ "${UI_TYPE}" == "ASUSWRT" ]; then
		echo_date "为软件中心安装ASUSWRT风格的皮肤..."
		sed -i '/rogcss/d' /${KSHOME}/.koolshare/webs/Module_Softsetting.asp >/dev/null 2>&1
	fi
	# -------------
	cp -rf /tmp/softcenter/init.d/* /${KSHOME}/.koolshare/init.d/
	cp -rf /tmp/softcenter/bin/* /${KSHOME}/.koolshare/bin/
	#for axhnd
	if [ "${MODEL}" == "RT-AX88U" ] || [ "${MODEL}" == "GT-AX11000" ];then
		cp -rf /tmp/softcenter/axbin/* /${KSHOME}/.koolshare/bin/
	fi
	cp -rf /tmp/softcenter/perp /${KSHOME}/.koolshare/
	cp -rf /tmp/softcenter/scripts /${KSHOME}/.koolshare/
	cp -rf /tmp/softcenter/.soft_ver /${KSHOME}/.koolshare/
	echo_date "文件复制结束，开始创建相关的软连接..."
	# make some link
	[ ! -L "/${KSHOME}/.koolshare/bin/base64_decode" ] && ln -sf /${KSHOME}/.koolshare/bin/base64_encode /${KSHOME}/.koolshare/bin/base64_decode
	[ ! -L "/${KSHOME}/.koolshare/scripts/ks_app_remove.sh" ] && ln -sf /${KSHOME}/.koolshare/scripts/ks_app_install.sh /${KSHOME}/.koolshare/scripts/ks_app_remove.sh
	[ ! -L "/${KSHOME}/.asusrouter" ] && ln -sf /${KSHOME}/.koolshare/bin/kscore.sh /${KSHOME}/.asusrouter
	[ -L "/${KSHOME}/.koolshare/bin/base64" ] && rm -rf /${KSHOME}/.koolshare/bin/base64
	if [ -n "$(nvram get extendno | grep koolshare)" ];then
		# for offcial mod, RT-AC86U, GT-AC5300, TUF-AX3000, RT-AX86U, etc
		[ ! -L "/${KSHOME}/etc/profile" ] && ln -sf /${KSHOME}/.koolshare/scripts/base.sh /${KSHOME}/etc/profile
	else
		# for Merlin mod, RT-AX88U, RT-AC86U, etc
		[ ! -L "/${KSHOME}/configs/profile.add" ] && ln -sf /${KSHOME}/.koolshare/scripts/base.sh /${KSHOME}/configs/profile.add
	fi
	echo_date "软连接创建完成！"

	#============================================
	# check start up scripts 
	echo_date "开始检查软件中心开机启动项！"
	if [ ! -f "/${KSHOME}/scripts/wan-start" ];then
		cat > /${KSHOME}/scripts/wan-start <<-EOF
		#!/bin/sh
		/koolshare/bin/ks-wan-start.sh start
		EOF
	else
		STARTCOMAND1=$(cat /${KSHOME}/scripts/wan-start | grep -c "/koolshare/bin/ks-wan-start.sh start")
		[ "$STARTCOMAND1" -gt "1" ] && sed -i '/ks-wan-start.sh/d' /${KSHOME}/scripts/wan-start && sed -i '1a /koolshare/bin/ks-wan-start.sh start' /${KSHOME}/scripts/wan-start
		[ "$STARTCOMAND1" == "0" ] && sed -i '1a /koolshare/bin/ks-wan-start.sh start' /${KSHOME}/scripts/wan-start
	fi
	
	if [ ! -f "/${KSHOME}/scripts/nat-start" ];then
		cat > /${KSHOME}/scripts/nat-start <<-EOF
		#!/bin/sh
		/koolshare/bin/ks-nat-start.sh start_nat
		EOF
	else
		STARTCOMAND2=$(cat /${KSHOME}/scripts/nat-start | grep -c "/koolshare/bin/ks-nat-start.sh start_nat")
		[ "$STARTCOMAND2" -gt "1" ] && sed -i '/ks-nat-start.sh/d' /${KSHOME}/scripts/nat-start && sed -i '1a /koolshare/bin/ks-nat-start.sh start_nat' /${KSHOME}/scripts/nat-start
		[ "$STARTCOMAND2" == "0" ] && sed -i '1a /koolshare/bin/ks-nat-start.sh start_nat' /${KSHOME}/scripts/nat-start
	fi
	
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
	
	if [ ! -f "/${KSHOME}/scripts/services-start" ];then
		cat > /${KSHOME}/scripts/services-start <<-EOF
		#!/bin/sh
		/koolshare/bin/ks-services-start.sh
		EOF
	else
		STARTCOMAND4=$(cat /${KSHOME}/scripts/services-start | grep -c "/koolshare/bin/ks-services-start.sh")
		[ "$STARTCOMAND4" -gt "1" ] && sed -i '/ks-services-start.sh/d' /${KSHOME}/scripts/services-start && sed -i '1a /koolshare/bin/ks-services-start.sh' /${KSHOME}/scripts/services-start
		[ "$STARTCOMAND4" == "0" ] && sed -i '1a /koolshare/bin/ks-services-start.sh' /${KSHOME}/scripts/services-start
	fi
	
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
	echo_date "开机启动项检查完毕！"

	chmod 755 /${KSHOME}/scripts/* >/dev/null 2>&1
	chmod 755 /${KSHOME}/.koolshare/bin/* >/dev/null 2>&1
	chmod 755 /${KSHOME}/.koolshare/init.d/* >/dev/null 2>&1
	chmod 755 /${KSHOME}/.koolshare/perp/* >/dev/null 2>&1
	chmod 755 /${KSHOME}/.koolshare/perp/.boot/* >/dev/null 2>&1
	chmod 755 /${KSHOME}/.koolshare/perp/.control/* >/dev/null 2>&1
	chmod 755 /${KSHOME}/.koolshare/perp/httpdb/* >/dev/null 2>&1
	chmod 755 /${KSHOME}/.koolshare/scripts/* >/dev/null 2>&1

	# reset some default value
	echo_date "设定一些默认值..."
	if [ -n "$(pidof skipd)" -a -f "/usr/bin/dbus" ];then
		/usr/bin/dbus set softcenter_installing_todo=""
		/usr/bin/dbus set softcenter_installing_title=""
		/usr/bin/dbus set softcenter_installing_name=""
		/usr/bin/dbus set softcenter_installing_tar_url=""
		/usr/bin/dbus set softcenter_installing_version=""
		/usr/bin/dbus set softcenter_installing_md5=""
	fi
	#============================================
	# now try to reboot httpdb if httpdb not started
	# /koolshare/bin/start-stop-daemon -S -q -x /koolshare/perp/perp.sh
}

exit_install(){
	local state=$1
	local module=softcenter
	case $state in
		1)
			echo_date "本软件中心适用于【koolshare 梅林改/官改 hnd/axhnd/axhnd.675x】固件平台！"
			echo_date "你的固件平台不能安装！！!"
			echo_date "本软件中心支持机型/平台：https://github.com/koolshare/rogsoft#rogsoft"
			echo_date "退出安装！"
			rm -rf /tmp/${module}* >/dev/null 2>&1
			echo_date "----------------------------------------------------------------"
			exit 1
			;;
		0|*)
			rm -rf /tmp/${module}* >/dev/null 2>&1
			echo_date "----------------------------------------------------------------"
			exit 0
			;;
	esac
}

platform_test(){
	local LINUX_VER=$(uname -r|awk -F"." '{print $1$2}')
	if [ -d "/koolshare" -a -f "/usr/bin/skipd" -a "${LINUX_VER}" -ge "41" ];then
		echo_date 机型："${MODEL} ${FW_TYPE_NAME} 符合安装要求，开始安装软件中心！"
	else
		exit_install 1
	fi
}

install_now(){
	get_usb2jffs_status
	if [ "$?" == "0" ];then
		echo_date "检测到你使用USB磁盘挂载了/jffs！"
		echo_date "软件中心此次将同时安装到系统jffs和usb jffs！"
		echo_date "------------------ 更新软件中心到USB JFFS（/jffs）------------------"
		softcenter_install jffs
		echo_date "----------------------------------------------------------------"
		echo_date "------------------ 更新软件中心到系统 JFFS（/cifs2）----------------"
		softcenter_install cifs2
		echo_date "----------------------------------------------------------------"
	else
		echo_date "------------------ 更新软件中心到系统 JFFS（/jffs）-----------------"
		softcenter_install jffs
		echo_date "----------------------------------------------------------------"
	fi
	rm -rf /tmp/softcenter*
}

install(){
	get_model
	get_fw_type
	platform_test
	get_ui_type
	install_now
}

install
