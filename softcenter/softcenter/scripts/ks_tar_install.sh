#!/bin/sh
#
########################################################################
#
# Copyright (C) 2010/2021 kooldev
#
# 此脚为 hnd/axhnd/axhnd.675x/p1axhnd.675x 平台软件中心插件离线安装脚本。
# 软件中心地址: https://github.com/koolshare/rogsoft
#
########################################################################

source /koolshare/scripts/base.sh
MODEL=
UI_TYPE=ASUSWRT
NAME_PREFIX=
MODULE_NAME=
FW_TYPE_CODE=
FW_TYPE_NAME=
TAR_NAME=$(dbus get soft_name)
LOG_FILE=/tmp/upload/soft_log.txt
LOG_FILE_BACKUP=/tmp/upload/soft_install_log_backup.txt
TARGET_DIR=/tmp/upload

get_model(){
	local ODMPID=$(nvram get odmpid)
	local PRODUCTID=$(nvram get productid)
	if [ -n "${ODMPID}" ];then
		MODEL="${ODMPID}"
	else
		MODEL="${PRODUCTID}"
	fi
	echo_date "当前机型：$MODEL"
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
	echo_date "当前固件：$FW_TYPE_NAME"
}

get_ui_type(){
	# 获取机型
	get_model

	# 获取固件类型
	get_fw_type

	# 参数获取
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

	# UI类型判断
	# -------------------------------
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
	
	if [ "${ROG_GTAC5300}" == "1" -o "${ROG_RTAC86U}" == "1" -o "${ROG_GTAC2900}" == "1" -o "${ROG_GTAX11000}" == "1" -o "${ROG_GTAXE11000}" == "1" ];then
		# GT-AC5300、RT-AC86U部分版本、GT-AC2900部分版本、GT-AX11000部分版本、GT-AXE11000全部版本，骚红皮肤
		UI_TYPE="ROG"
	fi
	
	if [ "${MODEL}" == "TUF-AX3000" ];then
		# 官改固件，橙色皮肤
		UI_TYPE="TUF"
	fi
}

jffs_space(){
	local JFFS_AVAL=$(df | grep -w "/jffs" | awk '{print $4}')
	echo ${JFFS_AVAL}
}

clean(){
	if [ -n "${NAME_PREFIX}" -a -d "/tmp/${NAME_PREFIX}" ];then
		echo_date "删除文件夹-1：/tmp/${NAME_PREFIX}"
		rm -rf /tmp/${NAME_PREFIX} >/dev/null 2>&1
	fi
	if [ -n "${MODULE_NAME}" -a -d "/tmp/${MODULE_NAME}" ];then
		echo_date "删除文件夹-2：/tmp/${MODULE_NAME}"
		rm -rf /tmp/${MODULE_NAME} >/dev/null 2>&1
	fi
	if [ -n "${TAR_NAME}" -a -f "/tmp/${TAR_NAME}" ];then
		echo_date "删除文件：/tmp/${TAR_NAME}"
		rm -rf /tmp/${TAR_NAME} >/dev/null 2>&1
	fi
	
	# incase of delete install package delete failed
	rm -rf /tmp/*.tar.gz >/dev/null 2>&1
	rm -rf /tmp/upload/*.tar.gz >/dev/null 2>&1
	
	# remove some value if exist
	dbus remove soft_install_version
	dbus remove soft_name
}

detect_package(){
	local TEST_WORD="$1"
	local ILLEGAL_KEYWORDS="ss|ssr|shadowsocks|shadowsocksr|v2ray|trojan|clash|wireguard|koolss|brook|fuck"
	local KEY_MATCH=$(echo "${TEST_WORD}" | grep -vi "ssid" | grep -Eio "${ILLEGAL_KEYWORDS}")
	
	if [ -n "${KEY_MATCH}" ]; then
		echo_date "检测到离线安装包：${TAR_NAME} 含非法关键词！！！"
		echo_date "根据法律规定，koolshare软件中心将不会安装此插件！！！"
		echo_date "删除相关文件并退出..."
		exit_tar_install 1
	fi
}

exit_tar_install(){
	local CODE=$1
	local NAME=$2
	clean
	if [ -n "${NAME}" ];then
		dbus remove "softcenter_module_${NAME}_install"
	fi
	echo_date "============================ end ================================"
	echo "XU6J03M6"
	exit ${code}
}

install_tar(){
	echo_date "========================== step 1 ==============================="
	echo_date "开启插件离线安装！"
	local MAXDEPTH_SUPP=$(find --help 2>&1|grep -Eco maxdepth)
	if [ "${MAXDEPTH_SUPP}" == "1" ];then
		FARG="-maxdepth 2"
	else
		FARG=""
	fi
	
	# 1. incase of dbus value pass error, ${TAR_NAME}: xxx.tar.gz
	if [ -z "${TAR_NAME}" ];then
		echo_date "没有找到任何离线安装包！退出！"
		exit_tar_install 1
	fi

	# 2. detect if ks_tar_install.sh process is running
	local KS_PID=$$
	local KS_SCRIPT_PID=$(ps | grep "ks_tar_install.sh" | grep -vw "grep" | grep -vw "${KS_PID}")
	if [ -n "${KS_SCRIPT}" ];then
		# 如果有其它ks_tar_install.sh在运行，说明有插件正在离线安装，此时应该退出安装
		echo_date "-------------------------------------------------------------------"
		echo_date "软件中心：检测到ks_tar_install.sh脚本正在运行！"
		echo_date "可能是有插件正在进行离线安装，或者是上个离线安装的插件出现了问题导致的！"
		echo_date "如果尝试多次离线安装仍然报该错误，请重启路由后再试！"
		echo_date "-------------------------------------------------------------------"
		echo_date "退出本次插件安装！"
		exit_tar_install 1
	fi

	# 3. detect package name for special characters
	local S_MATCH=$(echo "${TAR_NAME}"|grep -Eo "\s|\%|\@|\#|\￥|\$|\#|\&|\*|\!")
	if [ -n "${S_MATCH}" ];then
		echo_date "检测到你的离线安装包名：${TAR_NAME}含有特殊字符！"
		echo_date "建议将离线安装名更改为全英文，且不要有空格等特殊字符！"
		echo_date "退出本次离线安装！"
		exit_tar_install 1
	fi

	# 4. get name prefix of xxx.tar.gz file, ie: xxx，name prefix should not contain any character like "-" and "_".
	NAME_PREFIX=$(echo "${TAR_NAME}"|sed 's/\.tar\.gz//g'|awk -F "_" '{print $1}'|awk -F "-" '{print $1}')
	if [ -z "${NAME_PREFIX}" ];then
		echo_date "插件安装包名：${TAR_NAME}错误！"
		echo_date "建议将离线安装名更改为全英文，且不要有空格等特殊字符！"
		echo_date "退出本次离线安装！"
		exit_tar_install 1
	fi	

	# 5. do something here for package name
	detect_package "${TAR_NAME}"

	# 6. check if xxx.tar.gz file exist.
	if [ ! -f "${TARGET_DIR}/${TAR_NAME}" ];then
		echo_date "没有找到任何离线安装包，可能是上传错误！退出！"
		exit_tar_install 1
	fi

	# 7. size & checksum
	local _FILESIZE=$(ls -lh "${TARGET_DIR}/${TAR_NAME}"|awk '{print $5}')
	local _CHECKSUM=$(md5sum "${TARGET_DIR}/${TAR_NAME}"|awk '{print $1}')
	echo_date "检测到你上传的离线安装包：${TAR_NAME}，安装包大小: ${_FILESIZE}"
	echo_date "安装包md5sum校验值：${_CHECKSUM}"

	# 8. before untar, remove some file/folder if exist：tar.gz file and folder contain install.sh
	rm -rf /tmp/*.tar.gz >/dev/null 2>&1
	local INSTALL_SCRIPT_TMP=$(find /tmp $FARG -name "install.sh")
	local SCRIPT_AB_DIR_TMP=$(dirname ${INSTALL_SCRIPT_TMP})
	rm -rf ${SCRIPT_AB_DIR_TMP} >/dev/null 2>&1

	# 9. move package to /tmp
	mv -f /tmp/upload/${TAR_NAME} /tmp
	if [ "$?" != "0" ];then
		echo_date "出现未知错误！退出离线安装，请重启路由器后重试！"
		exit_tar_install 1
	fi

	# 10. try to untar package
	echo_date "尝试解压离线安装包离线安装包..."
	cd /tmp
	tar -zxvf "${TAR_NAME}" >/dev/null 2>&1
	local TAR_CODE=$?
	if [ "${TAR_CODE}" != "0" ];then
		echo_date "解压错误，错误代码：${TAR_CODE}"
		echo_date "估计是错误或者不完整的的离线安装包！"
		echo_date "删除相关文件并退出！"
		exit_tar_install 1
	else
		echo_date "安装包解压成功！继续！"
	fi

	# 11. try to obtain the real package name, sometimes untar xxx.tar.gz get folder yyy
	if [ -f "/tmp/${NAME_PREFIX}/install.sh" ];then
		local INSTALL_SCRIPT=/tmp/${NAME_PREFIX}/install.sh
		local SCRIPT_AB_DIR=$(dirname ${INSTALL_SCRIPT})
		MODULE_NAME=${NAME_PREFIX}
	else
		local INSTALL_SCRIPT_NU=$(find /tmp $FARG -name "install.sh"|wc -l 2>/dev/null)
		if [ "${INSTALL_SCRIPT_NU}" == "1" ];then
			local INSTALL_SCRIPT=$(find /tmp $FARG -name "install.sh")
			local SCRIPT_AB_DIR=$(dirname ${INSTALL_SCRIPT})
			MODULE_NAME=${SCRIPT_AB_DIR##*/}
		elif [ "${INSTALL_SCRIPT_NU}" == "0" ];then
			echo_date "没有找到安装脚本：install.sh"
			echo_date "退出本次离线安装！"
			exit_tar_install 1
		elif [ "${INSTALL_SCRIPT_NU}" -gt "1" ];then
			echo_date "找到多个安装脚本：install.sh，情况如下："
			local INSTALL_SCRIPTS=$(find /tmp $FARG -name "install.sh")
			for INSTALL_SCRIPT in $INSTALL_SCRIPTS
			do
				echo_date "$INSTALL_SCRIPT"
			done
			echo_date "请删除这些安装脚本，或者重启路由器后重试！"
			echo_date "退出本次离线安装！"
			exit_tar_install 1
		fi
	fi

	# 12. do something here for package real name
	detect_package "${MODULE_NAME}"

	# 13. some package not come from koolshare
	if [ ! -f "/tmp/${MODULE_NAME}/webs/Module_${MODULE_NAME}.asp" -a "${MODULE_NAME}" != "softcenter" ];then
		# 插件必须有web页面，没有则不合规
		echo_date "没有找到插件的web页面！"
		echo_date "你上传的文件可能不是koolshare软件中心离线安装包！"
		echo_date "退出本次离线安装！"
		exit_tar_install 1
	fi
	if [ ! -d "/tmp/${MODULE_NAME}/scripts" ];then
		# 插件必须有scripts文件夹，没有则不合规
		echo_date "没有找到插件的相关脚本！"
		echo_date "你上传的文件可能不是koolshare软件中心离线安装包！"
		echo_date "退出本次离线安装！"
		exit_tar_install 1
	fi
	
	# 14. some package have evil scripts thar modify software center scripts
	local EVIL_MATCH_1=$(cat ${INSTALL_SCRIPT}|grep "detect_package")
	local EVIL_MATCH_2=$(cat ${INSTALL_SCRIPT}|grep "ks_tar_install")
	if [ -n "${EVIL_MATCH_1}" -o -n "${EVIL_MATCH_2}" ];then
		echo_date "发现当前插件的安装脚本会对软件中心文件进行修改操作！"
		echo_date "退出本次离线安装！"
		exit_tar_install 1
	fi

	# 15. 检查下安装包是否是hnd的
	if [ -f "${SCRIPT_AB_DIR}/.valid" -a -n "$(grep hnd ${SCRIPT_AB_DIR}/.valid)" ];then
		continue
	elif [ "${MODULE_NAME}" == "shadowsocks" ];then
		# hnd的不可描述包，有些版本没有校验字符串，避免安装失败
		continue
	else
		echo_date "你上传的离线安装包不是hnd/axhnd/axhnd.675x平台的离线包！！！"
		echo_date "请上传正确的离线安装包！！！"
		echo_date "删除相关文件并退出..."
		exit_tar_install 1
	fi

	# 16. check jffs space
	local JFFS_AVAIL1=$(jffs_space)
	local JFFS_AVAIL2=$((${JFFS_AVAIL1} - 2048))
	local JFFS_NEEDED=$(du -s /tmp/${MODULE_NAME} | awk '{print $1}')
	# local PLUGIN_SIZE=$(du -s /tmp/${TAR_NAME} | awk '{print $1}')
	# echo_date "JFFS剩余空间-1：${JFFS_AVAIL1}KB"
	# echo_date "JFFS剩余空间-2：${JFFS_AVAIL2}KB"
	# echo_date "插件文件夹大小：${JFFS_NEEDED}KB"
	# echo_date "插件压缩包大小：${PLUGIN_SIZE}KB"
	# 该插件之前没有安装，需要计算下插件安装需要的空间
	local MODULE_UPGRADE=$(dbus get softcenter_module_${MODULE_NAME}_install)
	[ "${MODULE_NAME}" == "shadowsocks" -o "${MODULE_NAME}" == "merlinclash" ] && local MODULE_UPGRADE="4"
	if [ -z "${MODULE_UPGRADE}" ];then
		# 可用空间小于2MB
		if [ "${JFFS_AVAIL1}" -lt "2048" ];then
			echo_date "-------------------------------------------------------------------"
			echo_date "当前jffs分区剩余：${JFFS_AVAIL1}KB, 剩余容量已经小于2MB！"
			echo_date "为了避免系统服务使用JFFS分区出现容量问题，不进行插件安装！"
			echo_date "请适当清理JFFS空间，或者建议使用USB2JFFS插件对JFFS进行扩容！"
			echo_date "-------------------------------------------------------------------"
			echo_date "退出本次离线安装！"
			exit_tar_install 1
		fi
		# 可用空间小于插件需要空间，保留2MB后自然也是小于插件空间，不安装
		if [ "${JFFS_AVAIL1}" -lt "${JFFS_NEEDED}" ];then
			echo_datec "-------------------------------------------------------------------"
			echo_date "当前jffs分区剩余：${JFFS_AVAIL1}KB, 插件安装大致需要${JFFS_NEEDED}KB，空间不足！"
			echo_date "请清理jffs分区内不要的文件，或者使用USB2JFFS插件对jffs分区进行扩容后再试！！"
			echo_date "-------------------------------------------------------------------"
			echo_date "退出本次离线安装！"
			exit_tar_install 1
		fi
		# 可用空间大于插件需要空间，保留2MB后却小于插件需要空间，不安装
		if [ "${JFFS_AVAIL1}" -gt "${JFFS_NEEDED}" -a "${JFFS_AVAIL2}" -lt "${JFFS_NEEDED}" ];then
			echo_date "-------------------------------------------------------------------"
			echo_date "当前jffs分区剩余：${JFFS_AVAIL1}KB, 插件安装大致需要${JFFS_NEEDED}KB！"
			echo_date "为了避免系统服务使用JFFS分区出现容量问题，软件中心会给jffs预留2MB的空间！"
			echo_date "如果安装此插件会导致JFFS可用空间小于2MB，因此本次不进行插件安装！"
			echo_date "请清理jffs分区内不要的文件，或者使用USB2JFFS插件对jffs分区进行扩容后再试！！"
			echo_date "-------------------------------------------------------------------"
			echo_date "退出本次离线安装！"
			exit_tar_install 1
		fi
		# 可用空间大于插件需要空间，保留2MB后仍然大于插件空间，安装
		if [ "${JFFS_AVAIL2}" -gt "${JFFS_NEEDED}" ];then
			echo_date "当前jffs分区剩余：${JFFS_AVAIL1}KB, 空间满足，继续安装！"
		fi
	fi
	# 插件升级情况下，可用容量大于2MB即可
	if [ "${MODULE_UPGRADE}" == "1" ];then
		if [ "${JFFS_AVAIL1}" -lt "2048" ];then
			echo_date "-------------------------------------------------------------------"
			echo_date "当前jffs分区剩余：${JFFS_AVAIL1}KB，可用容量已经小于2MB！"
			echo_date "为了避免系统服务使用JFFS分区出现容量问题，不进行插件安装！"
			echo_date "请适当清理JFFS空间，或者建议使用USB2JFFS插件对JFFS进行扩容！"
			echo_date "-------------------------------------------------------------------"
			echo_date "退出本次离线安装！"
			exit_tar_install 1
		else
			echo_date "当前jffs分区剩余：${JFFS_AVAIL1}KB, 空间满足，继续安装！"
		fi
	fi
	# 本脚本不检测jffs容量，插件自己检测
	if [ "${MODULE_UPGRADE}" == "4" ];then
		echo_date "安装此插件不进行JFFS空间检测，交由插件自行检测！请自行注意JFFS使用情况！"
	fi

	# 17. 开始安装
	if [ "${MODULE_NAME}" != "softcenter" ];then
		echo_date "准备安装插件：${MODULE_NAME}"
	else
		echo_date "准备更新软件中心！"
	fi
	
	# 18. 先移除版本号，后面再写
	dbus remove softcenter_module_${MODULE_NAME}_version

	# 19. 兼容旧的UI存放方式
	get_ui_type
	# -----------------------------------------------------------------------
	if [ -d "/tmp/${MODULE_NAME}/GT-AC5300" -a "${UI_TYPE}" == "ROG" ]; then
		echo_date "检测到ROG官改皮肤，安装中..."
		cp -rf /tmp/${MODULE_NAME}/GT-AC5300/* /tmp/${MODULE_NAME}/
	fi

	if [ -d "/tmp/${MODULE_NAME}/ROG" -a "${UI_TYPE}" == "ROG" ]; then
		echo_date "检测到ROG官改皮肤，安装中..."
		cp -rf /tmp/${MODULE_NAME}/ROG/* /tmp/${MODULE_NAME}/
	fi

	if [ -d "/tmp/${MODULE_NAME}/ROG" -a "${UI_TYPE}" == "TUF" ]; then
		# 骚红变橙色
		echo_date "检测到TUF官改皮肤，安装中..."
		find /tmp/${MODULE_NAME}/ROG/ -name "*.asp" | xargs sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g'
		find /tmp/${MODULE_NAME}/ROG/ -name "*.css" | xargs sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g'
		cp -rf /tmp/${MODULE_NAME}/ROG/* /tmp/${MODULE_NAME}/
	fi
	# -----------------------------------------------------------------------

	# 20. 运行安装脚本
	chmod +x ${INSTALL_SCRIPT} >/dev/null 2>&1
	echo_date "运行安装脚本..."
	echo_date "========================== step 2 ==============================="
	start-stop-daemon -S -q -x ${INSTALL_SCRIPT} 2>&1
	if [ "$?" != "0" ];then
		echo_date "========================== step 3 ==============================="
		echo_date "ks_tar_install.sh: 因为插件${MODULE_NAME}安装失败！退出离线安装！"
		exit_tar_install 1 ${MODULE_NAME}
	fi
	
	# 21. UI
	# -----------------------------------------------------------------------
	if [ "${UI_TYPE}" == "ROG" ];then
		continue
	else
		if [ "${UI_TYPE}" == "TUF" ];then
			sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /koolshare/webs/Module_${MODULE_NAME}.asp >/dev/null 2>&1
		else
			sed -i '/rogcss/d' /koolshare/webs/Module_${MODULE_NAME}.asp >/dev/null 2>&1
		fi
	fi
	# -----------------------------------------------------------------------
	sync
	echo_date "========================== step 3 ==============================="
	
	# 22. 写入安装信息
	if [ "${MODULE_NAME}" != "softcenter" ];then
		# name
		if [ -z "$(dbus get softcenter_module_${MODULE_NAME}_name)" ];then
			dbus set "softcenter_module_${MODULE_NAME}_name=${MODULE_NAME}"
		fi
		# title
		if [ -z "$(dbus get softcenter_module_${MODULE_NAME}_title)" ];then
			dbus set "softcenter_module_${MODULE_NAME}_title=${MODULE_NAME}"
		fi
		# install
		if [ -z "$(dbus get softcenter_module_${MODULE_NAME}_install)" ];then
			dbus set "softcenter_module_${MODULE_NAME}_install=1"
		fi
		# version
		if [ -z "$(dbus get softcenter_module_${MODULE_NAME}_version)" ];then
			dbus set "softcenter_module_${MODULE_NAME}_version=0.1"
			echo_date "插件安装脚本里没有找到版本号，设置默认版本号为0.1"
		else
			echo_date "插件安装脚本已经设置了插件版本号为：$(dbus get softcenter_module_${MODULE_NAME}_version)"
		fi
	else
		if [ -f "/koolshare/.soft_ver" ];then
			local SOFT_VER=$(cat /koolshare/.soft_ver)
			[ -n "${SOFT_VER}" ] && dbus set "softcenter_version=${SOFT_VER}"
		fi
	fi

	# 23. 安装完毕，打印剩余空间
	local JFFS_AVAIL3=$(jffs_space)
	local JFFS_USED=$((${JFFS_AVAIL1} - ${JFFS_AVAIL3}))
	if [ "${JFFS_USED}" -ge "0" ];then
		echo_date "软件中心：本次安装占用了${JFFS_USED}KB空间，目前jffs分区剩余容量：${JFFS_AVAIL3}KB"
	elif [ "${JFFS_USED}" -lt "0" ];then
		local JFFS_RELEASED=${JFFS_USED#-}
		echo_date "软件中心：本次安装释放了${JFFS_RELEASED}KB空间，目前jffs分区剩余容量：${JFFS_AVAIL3}KB"
	fi
	if [ "${JFFS_AVAIL3}" -lt "2000" ];then
		echo_date "软件中心：注意！目前jffs分区剩余容量只剩下：${JFFS_AVAIL3}KB，已不足2MB！"
	fi
	echo_date "完成！离线安装插件成功，现在你可以退出本页面~"
	exit_tar_install 0
}

clean_backup_log() {
	local LOG_MAX=1000
	[ $(wc -l "${LOG_FILE_BACKUP}" | awk '{print $1}') -le "$LOG_MAX" ] && return
	local logdata=$(tail -n 500 "${LOG_FILE_BACKUP}")
	echo "${logdata}" > ${LOG_FILE_BACKUP} 2> /dev/null
	unset logdata
}

true > ${LOG_FILE}
http_response "$1"
install_tar | tee -a ${LOG_FILE} ${LOG_FILE_BACKUP}
clean_backup_log
