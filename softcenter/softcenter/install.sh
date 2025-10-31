#!/bin/sh
#
########################################################################
#
# Copyright (C) 2011/2024 kooldev
#
# 此脚本为 hnd/axhnd/axhnd.675x/p1axhnd.675x平台软件中心安装脚本。
# 软件中心地址: https://github.com/koolshare/rogsoft
#
########################################################################
NEW_PATH=$(echo $PATH|tr ':' '\n'|sed '/opt/d;/mmc/d'|awk '!a[$0]++'|tr '\n' ':'|sed '$ s/:$//')
export PATH=${NEW_PATH}
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

	local CIFS_STATUS=$(df -h|grep "/cifs2"|awk '{print $1}'|grep -E "/dev/mtdblock|ubi:jffs")
	if [ -z "${CIFS_STATUS}" ];then
		return 1
	fi
		
	if [ ! -d "/cifs2/.koolshare" ];then
		return 1

	fi

	# user has mount USB disk to /jffs, and orgin jffs mount device: /dev/mtdblock? mounted on /cifs2
	return 0
}

cmcp(){
	# compare then copy
	local _source=$1
	local _target=$2
	local _origin=$3
	local _action=$4
	local _FILES=$(find ${_source}/* -type f 2>/dev/null)
	for _FILE in ${_FILES}
	do
		local _FILENAME=$(basename ${_FILE})
		local _FILEPATH=$(dirname ${_FILE})
		local _DESTPATH=$(echo ${_FILEPATH} | sed "s/\/tmp\/${module}/\/${KSHOME}\/\.koolshare/g")
		local _ORIGPATH=$(echo ${_FILEPATH} | sed "s/\/tmp\/${module}/\/rom\/etc\/koolshare/g")
		local _FILE_JFF="${_DESTPATH}/${_FILENAME}"
		local _FILE_TMP="${_FILEPATH}/${_FILENAME}"
		local _FILE_ROM="${_ORIGPATH}/${_FILENAME}"
		mkdir -p ${_DESTPATH}
		
		if [ -f "${_FILE_JFF}" ];then
			readlink -f ${_FILE_JFF} >/dev/null 2>&1
			if [ "$?" == "0" ];then
				# it's a link, we need to compare to its origin file then copy
				local _FILE_ORI=$(readlink -f ${_FILE_JFF})
				local _FILE_ORI_MD5=$(md5sum ${_FILE_ORI} | awk '{print $1}')
				local _FILE_TMP_MD5=$(md5sum ${_FILE_TMP} | awk '{print $1}')
				if [ "${_FILE_ORI_MD5}" != "${_FILE_TMP_MD5}" ];then
					# different md5, remove link and copy new file from source to target folder
					echo_date "copy | ${_FILE_TMP} ➡️ ${_FILE_JFF}"
					rm -rf ${_FILE_JFF} >/dev/null 2>&1
					cp -rf ${_FILE_TMP} ${_FILE_JFF}
					chmod +x ${_FILE_JFF} >/dev/null 2>&1
				else
					# same md5, do nothing, keep the link
					echo_date "jump | ${_FILE_JFF} link not change!"
					echo 1 >/dev/null 2>&1
				fi
			elif [ "$?" == "1" ];then
				# it's a file, we need to compare then copy
				local _FILE_JFF_MD5=$(md5sum ${_FILE_JFF} | awk '{print $1}')
				local _FILE_TMP_MD5=$(md5sum ${_FILE_TMP} | awk '{print $1}')
				local _FILE_ROM_MD5=$(md5sum ${_FILE_ROM} | awk '{print $1}')
				if [ "${_FILE_JFF_MD5}" != "${_FILE_TMP_MD5}" ];then
					if [ "${_FILE_TMP_MD5}" == "${_FILE_ROM_MD5}" ];then
						# same md5, file maybe change by user? or otehr malware, correct it with link
						if [ ${_action} == "link" ];then
							echo_date "link | ${_FILE_ROM} ➡️ ${_FILE_JFF}"
							rm -rf ${_FILE_JFF} >/dev/null 2>&1
							ln -sf ${_FILE_ROM} ${_FILE_JFF}
						else
							echo_date "copy | ${_FILE_ROM} ➡️ ${_FILE_JFF}"
							rm -rf ${_FILE_JFF} >/dev/null 2>&1
							cp -rf ${_FILE_ROM} ${_FILE_JFF}
							chmod +x ${_FILE_JFF} >/dev/null 2>&1
						fi
					else
						# different md5, file in target is newer, copry it to target
						echo_date "copy | ${_FILE_TMP} ➡️ ${_FILE_JFF}"
						cp -rf ${_FILE_TMP} ${_FILE_JFF}
						chmod +x ${_FILE_JFF} >/dev/null 2>&1
					fi
				else
					if [ "${_FILE_JFF_MD5}" == "${_FILE_ROM_MD5}" ];then
						if [ ${_action} == "link" ];then
							# same md5, remove file, make link
							echo_date "link | ${_FILE_ROM} ➡️ ${_FILE_JFF}"
							rm -rf ${_FILE_JFF} >/dev/null 2>&1
							ln -sf ${_FILE_ROM} ${_FILE_JFF}
						else
							# same md5, do nothing, keep the file
							echo_date "jump | ${_FILE_JFF} file not change!"
							echo 1 >/dev/null 2>&1
						fi
					else
						# keep it as file, because source file is newer than file in rom
						echo_date "jump | ${_FILE_JFF} file not change!"
						echo 1 >/dev/null 2>&1
					fi
				fi
			fi
		else
			if [ -f "${_FILE_ROM}" ];then
				# maybe lost in target, compare to source
				local _FILE_ROM_MD5=$(md5sum ${_FILE_ROM} | awk '{print $1}')
				local _FILE_TMP_MD5=$(md5sum ${_FILE_TMP} | awk '{print $1}')			
				if [ "${_FILE_ROM_MD5}" != "${_FILE_TMP_MD5}" ];then
					# different md5, copy new file from source to target folder
					echo_date "copy | ${_FILE_TMP} ➡️ ${_FILE_JFF}"
					cp -rf ${_FILE_TMP} ${_FILE_JFF}
					chmod +x ${_FILE_JFF} >/dev/null 2>&1
				else
					if [ ${_action} == "link" ];then
						# same md5, make a link
						echo_date "link | ${_FILE_ROM} ➡️ ${_FILE_JFF}"
						ln -sf ${_FILE_ROM} ${_FILE_JFF}
					else
						# same md5, copy file
						echo_date "copy | ${_FILE_TMP} ➡️ ${_FILE_JFF}"
						cp -rf ${_FILE_TMP} ${_FILE_JFF}
					fi
				fi
			else
				# only in /tmp folder, not in koolshare folder, copy file
				echo_date "copy | ${_FILE_TMP} ➡️ ${_FILE_JFF}"
				cp -rf ${_FILE_TMP} ${_FILE_JFF}
				chmod +x ${_FILE_JFF} >/dev/null 2>&1		
			fi
		fi
	done
	sync
}

check_device(){
	if [ ! -d "/data" ];then
		return "1"
	fi
	
	mkdir -p $1/rw_test 2>/dev/null
	sync
	if [ -d "$1/rw_test" ]; then
		echo "rwTest=OK" >"$1/rw_test/rw_test.txt"
		sync
		if [ -f "$1/rw_test/rw_test.txt" ]; then
			. "$1/rw_test/rw_test.txt"
			if [ "$rwTest" = "OK" ]; then
				rm -rf "$1/rw_test"
				return "0"
			else
				return "1"
			fi
		else
			return "1"
		fi
	else
		return "1"
	fi
}

ks_debug(){
	# detect if socat running correct
	local PID_TMP=$(ps | grep -E "socat" | grep 3032 | grep tmp | awk '{print $1}')
	if [ -n "${PID_TMP}" -a -x "/tmp/ks_debug.sh" ];then
		return 1
	fi

	local PID_DAT=$(ps | grep -E "socat" | grep 3032 | grep data | awk '{print $1}')
	if [ -n "${PID_DAT}" -a -x "/data/ks_debug.sh" ];then
		return 1
	fi

	# kill socat fist
	if [ -n "${PID_TMP}" ];then
		kill -9 ${PID_TMP}
	fi

	if [ -n "${PID_DAT}" ];then
		kill -9 ${PID_DAT}
	fi

	# start socat
	#local lan_ipaddr=$(nvram get lan_ipaddr)
	local lan_ipaddr=$(ifconfig br0 | grep "inet addr" | awk '{print $2}'|awk -F ":" '{print $2}')
	if [ -x "/data/ks_debug.sh" ];then
		socat TCP-LISTEN:3032,bind=${lan_ipaddr},reuseaddr,fork EXEC:/data/ks_debug.sh >/dev/null 2>&1 &
	elif [ -x "/tmp/ks_debug.sh" ];then
		socat TCP-LISTEN:3032,bind=${lan_ipaddr},reuseaddr,fork EXEC:/tmp/ks_debug.sh >/dev/null 2>&1 &
	else
		if [ -x "/koolshare/scripts/ks_debug.sh" ];then
			check_device "/data" 2>/dev/null
			if [ "$?" == "0" ];then
				cp -rf /koolshare/scripts/ks_debug.sh /data/
				socat TCP-LISTEN:3032,bind=${lan_ipaddr},reuseaddr,fork EXEC:/data/ks_debug.sh >/dev/null 2>&1 &
			else
				cp -rf /koolshare/scripts/ks_debug.sh /tmp/
				socat TCP-LISTEN:3032,bind=${lan_ipaddr},reuseaddr,fork EXEC:/tmp/ks_debug.sh >/dev/null 2>&1 &
			fi
		else
			echo "no ks_debug.sh found"
		fi
	fi
}

center_install() {
	local KSHOME=$1

	if [ ! -d "/tmp/${module}" ]; then
		echo_date "没有找到 /tmp/${module} 文件夹，退出！"
		return 1
	fi

	# remove some value discard exist
	nvram unset rc_service

	# set important value
	nvram set 3rd-party=merlin
	nvram commit

	local CENTER_TYPE_1=$(cat /tmp/${module}/webs/Module_Softcenter.asp | grep -Eo "/softcenter/app.json.js")
	if [ -z "${CENTER_TYPE_1}" ];then
		echo_date "准备安装软件中心：koolcenter ..."
	else
		echo_date "准备安装软件中心：softcenter ..."
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
	mkdir -p /${KSHOME}/.koolshare/perp/
	mkdir -p /${KSHOME}/.koolshare/webs/
	mkdir -p /${KSHOME}/.koolshare/res/
	mkdir -p /tmp/upload
	
	# remove useless files
	echo_date "尝试清除一些不需要的文件..."
	[ -L "/${KSHOME}/configs/profile" ] && rm -rf /${KSHOME}/configs/profile
	[ -L "/${KSHOME}/.koolshare/webs/files" ] && rm -rf /${KSHOME}/.koolshare/webs/files
	[ -d "/tmp/files" ] && rm -rf /tmp/files

	# remove possible broken symbol link
	find -L /koolshare/ -type l | xargs rm -rf

	# remove more files by legacy bug package
	rm -rf /${KSHOME}/.koolshare/bin/bin-hnd >/dev/null 2>&1
	rm -rf /${KSHOME}/.koolshare/bin/bin-mtk >/dev/null 2>&1
	rm -rf /${KSHOME}/.koolshare/bin/bin-ipq >/dev/null 2>&1
	rm -rf /${KSHOME}/.koolshare/bin/bin-ipq32 >/dev/null 2>&1
	rm -rf /${KSHOME}/.koolshare/bin/bin-ipq64 >/dev/null 2>&1

	# remove files no longer needed by softcenter
	# rm -rf /${KSHOME}/.koolshare/res/Browser.js

	# remove files form jffs
	if [ "${MODEL}" == "RT-AX56U_V2" -o "${MODEL}" == "RT-AX57" ];then
		rm -rf /jffs/syslog.log
		rm -rf /jffs/syslog.log-1
		rm -rf /jffs/wglist
		rm -rf /jffs/.sys/diag_db/*
	fi
	rm -rf /jffs/uu.tar.gz*
	echo 1 > /proc/sys/vm/drop_caches
	sync

	# do not install some file for some model
	JFFS_TOTAL=$(df|grep -Ew "/${KSHOME}" | awk '{print $2}')
	if [ -n "${JFFS_TOTAL}" -a "${JFFS_TOTAL}" -le "20000" ];then
		echo_date "JFFS空间已经不足2MB！进行精简安装！"
		rm -rf /tmp/${module}/bin/htop
	else
		echo_date "JFFS空间足够，开始安装！"
	fi

	# which center
	if [ -f "/${KSHOME}/.koolshare/webs/Module_Softcenter.asp" ];then
		local CENTER_TYPE_2=$(cat /${KSHOME}/.koolshare/webs/Module_Softcenter.asp | grep -Eo "/softcenter/app.json.js")
		if [ -z "${CENTER_TYPE_2}" -a -z "${CENTER_TYPE_1}" ];then
			echo_date "检测到当前软件中心为koolcenter，继续安装koolcenter！"
		elif [ -z "${CENTER_TYPE_2}" -a -n "${CENTER_TYPE_1}" ];then
			echo_date "检测到当前软件中心为koolcenter，将降级为softcenter！"
			rm -rf /${KSHOME}/.koolshare/webs/Module_Softcenter_old.asp
			rm -rf /${KSHOME}/.koolshare/.soft_ver_old
			mv /${KSHOME}/.koolshare/webs/Module_Softcenter.asp /${KSHOME}/.koolshare/webs/Module_Softcenter_new.asp >/dev/null 2>&1
			cp -rf /${KSHOME}/.koolshare/.soft_ver /${KSHOME}/.koolshare/.soft_ver_new
		elif [ -n "${CENTER_TYPE_2}" -a -z "${CENTER_TYPE_1}" ];then
			echo_date "检测到当前软件中心为softcenter，将升级为koolcenter！"
			rm -rf /${KSHOME}/.koolshare/webs/Module_Softcenter_new.asp
			rm -rf /${KSHOME}/.koolshare/.soft_ver_new
			mv /${KSHOME}/.koolshare/webs/Module_Softcenter.asp /${KSHOME}/.koolshare/webs/Module_Softcenter_old.asp >/dev/null 2>&1
			cp -rf /${KSHOME}/.koolshare/.soft_ver /${KSHOME}/.koolshare/.soft_ver_old
		elif [ -n "${CENTER_TYPE_2}" -a -n "${CENTER_TYPE_1}" ];then
			echo_date "检测到当前软件中心为softcenter，继续安装softcenter！"
		fi
	fi

	# remove before install
	if [ -z "${CENTER_TYPE_1}" ];then
		find /${KSHOME}/.koolshare/res/*/assets/*.js 2>/dev/null | xargs rm -rf >/dev/null 2>&1
		find /${KSHOME}/.koolshare/res/*/assets/*.css 2>/dev/null | xargs rm -rf >/dev/null 2>&1
	fi

	# coping files
	echo_date "开始复制软件中心相关文件..."
	cp -rf /tmp/${module}/webs/* /${KSHOME}/.koolshare/webs/
	cp -rf /tmp/${module}/res/* /${KSHOME}/.koolshare/res/

	# set ui for softcenter & koolcenter
	set_skin
	
	# start to install files
	cmcp /tmp/${module}/bin /${KSHOME}/.koolshare/bin /rom/etc/koolshare/bin link
	cmcp /tmp/${module}/init.d /${KSHOME}/.koolshare/init.d /rom/etc/koolshare/init.d file
	cmcp /tmp/${module}/perp /${KSHOME}/.koolshare/perp /rom/etc/koolshare/perp file
	cmcp /tmp/${module}/scripts /${KSHOME}/.koolshare/scripts /rom/etc/koolshare/scripts file
	if [ -f "/tmp/${module}/scripts/ks_debug.sh" ];then
		check_device "/data" 2>/dev/null
		if [ "$?" == "0" ];then
			cp -rf /tmp/${module}/scripts/ks_debug.sh /data/
			chmod +x /data/ks_debug.sh
		else
			cp -rf /tmp/${module}/scripts/ks_debug.sh /tmp/
			chmod +x /tmp/ks_debug.sh
		fi
	fi
	
	#cp -rf /tmp/${module}/init.d/* /${KSHOME}/.koolshare/init.d/
	#cp -rf /tmp/${module}/perp /${KSHOME}/.koolshare/
	#cp -rf /tmp/${module}/scripts /${KSHOME}/.koolshare/
	cp -rf /tmp/${module}/.soft_ver /${KSHOME}/.koolshare/

	echo_date "文件复制结束，开始创建相关的软连接..."
	
	# ssh PATH environment
	rm -rf /jffs/configs/profile.add >/dev/null 2>&1
	rm -rf /jffs/etc/profile >/dev/null 2>&1
	source_file=$(cat /etc/profile|awk '{print $NF}'|grep -E "profile"|grep "jffs"|grep "/"|head -n1)
	source_path=$(dirname $source_file)
	if [ -n "${source_file}" -a -n "${source_path}" -a -f "/jffs/.koolshare/scripts/base.sh" ];then
		rm -rf ${source_file} >/dev/null 2>&1
		mkdir -p ${source_path}
		ln -sf /jffs/.koolshare/scripts/base.sh ${source_file} >/dev/null 2>&1
	fi
	
	# make some link
	[ ! -L "/${KSHOME}/.koolshare/bin/base64_decode" ] && ln -sf /${KSHOME}/.koolshare/bin/base64_encode /${KSHOME}/.koolshare/bin/base64_decode
	[ ! -L "/${KSHOME}/.koolshare/scripts/ks_app_remove.sh" ] && ln -sf /${KSHOME}/.koolshare/scripts/ks_app_install.sh /${KSHOME}/.koolshare/scripts/ks_app_remove.sh
	[ ! -L "/${KSHOME}/.asusrouter" ] && ln -sf /${KSHOME}/.koolshare/bin/kscore.sh /${KSHOME}/.asusrouter
	[ -L "/${KSHOME}/.koolshare/bin/base64" ] && rm -rf /${KSHOME}/.koolshare/bin/base64

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
	#chmod 755 /${KSHOME}/.koolshare/bin/* >/dev/null 2>&1
	chmod 755 /${KSHOME}/.koolshare/init.d/* >/dev/null 2>&1
	chmod 755 /${KSHOME}/.koolshare/scripts/* >/dev/null 2>&1
	chmod 755 /${KSHOME}/.koolshare/perp/.boot/* >/dev/null 2>&1
	chmod 755 /${KSHOME}/.koolshare/perp/.control/* >/dev/null 2>&1

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

	local SOFTVER=$(cat /tmp/${module}/.soft_ver)
	if [ "${KSHOME}" == "cifs2" -a -f "/cifs2/ksdb/log" ];then
		killall skipd >/dev/null 2>&1
		kill -9 $(pidof skipd) >/dev/null 2>&1
		/usr/bin/skipd -d /cifs2/ksdb >/dev/null 2>&1 &
		sleep 2
		if [ -n "${SOFTVER}" ];then
			dbus set softcenter_version=${SOFTVER}
		fi
		sync
		sleep 1
		killall skipd >/dev/null 2>&1
		kill -9 $(pidof skipd) >/dev/null 2>&1
		service start_skipd >/dev/null 2>&1
		sleep 2
	fi
	if [ "${KSHOME}" == "jffs" -a -f "/cifs2/ksdb/log" ];then
		if [ -n "${SOFTVER}" ];then
			dbus set softcenter_version=${SOFTVER}
		fi
	fi

	# run something after install
	ks_debug
	#============================================
	# now try to reboot httpdb if httpdb not started
	# /koolshare/bin/start-stop-daemon -S -q -x /koolshare/perp/perp.sh
}

exit_install(){
	local state=$1
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
		center_install jffs
		echo_date "----------------------------------------------------------------"
		echo_date "------------------ 更新软件中心到系统 JFFS（/cifs2）----------------"
		center_install cifs2
		echo_date "----------------------------------------------------------------"
	else
		echo_date "------------------ 更新软件中心到系统 JFFS（/jffs）-----------------"
		center_install jffs
		echo_date "----------------------------------------------------------------"
	fi
	rm -rf /tmp/${module}* >/dev/null 2>&1
}

install(){
	get_model
	get_fw_type
	set_url
	platform_test
	install_now
}

install
