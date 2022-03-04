#!/bin/sh
#
########################################################################
#
# Copyright (C) 2011/2022 kooldev
#
# 此脚本为 hnd/axhnd/axhnd.675x/p1axhnd.675x/504axhnd.675x平台软件中心插件在线安装脚本。
# 软件中心地址: https://github.com/koolshare/rogsoft
#
########################################################################
#
# softcenter_installing_todo		# 需要安装/卸载的插件，比如：linkease
# softcenter_installing_name		# 上一个/正在安装的插件的名字，比如【易有云】
# softcenter_installing_title		# 需要安装/卸载的插件名字，比如【易有云2.0】
# softcenter_installing_version		# 需要安装插件的版本
# softcenter_installing_md5			# 需要安装插件的md5值
# softcenter_installing_tar_url		# 需要安装插件对应的下载地址

source /koolshare/scripts/base.sh
eval $(dbus export softcenter_installing_)
LOG_FILE=/tmp/upload/soft_install_log.txt
LOG_FILE_BACKUP=/tmp/upload/soft_install_log_backup.txt
URL_SPLIT="/"
UI_TYPE=ASUSWRT

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
	[ "${MODEL}" == "GT-AX6000" ] && local ROG_GTAX6000=1
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
	
	if [ "${ROG_GTAC5300}" == "1" -o "${ROG_RTAC86U}" == "1" -o "${ROG_GTAC2900}" == "1" -o "${ROG_GTAX11000}" == "1" -o "${ROG_GTAXE11000}" == "1" -o "${ROG_GTAX6000}" == "1" ];then
		# GT-AC5300、RT-AC86U部分版本、GT-AC2900部分版本、GT-AX11000部分版本、GT-AXE11000全部版本， GT-AX6000 骚红皮肤
		UI_TYPE="ROG"
	fi
	
	if [ "${MODEL}" == "TUF-AX3000" ];then
		# 官改固件，橙色皮肤
		UI_TYPE="TUF"
	fi
}

quit_ks_install(){
	[ -n "${softcenter_installing_todo}" ] && rm -rf "/tmp/${softcenter_installing_todo}*"
	dbus set softcenter_installing_todo=""
	dbus set softcenter_installing_title=""
	dbus set softcenter_installing_name=""
	dbus set softcenter_installing_tar_url=""
	dbus set softcenter_installing_version=""
	dbus set softcenter_installing_md5=""
	echo_date "============================= end ================================="
	echo "XU6J03M6"
	exit
}

quit_ks_uninstall(){
	dbus set softcenter_installing_todo=""
	dbus set softcenter_installing_title=""
	echo_date "============================= end ================================="
	echo "XU6J03M6"
	exit
}

jffs_space(){
	local JFFS_AVAL=$(df | grep -w "/jffs" | awk '{print $4}')
	echo ${JFFS_AVAL}
}

install_ks_module() {
	# 0. if under koolcenter, dbus value of softcenter_home_url is not defined by default
	local LINUX_VER=$(uname -r|awk -F"." '{print $1$2}')
	if [ "${LINUX_VER}" -ge "41" ];then
		local SC_URL=https://rogsoft.ddnsto.com
	fi
	if [ "${LINUX_VER}" -eq "26" ];then
		local SC_URL=https://armsoft.ddnsto.com
	fi
	local SC_URL_NVRAM=$(nvram get sc_url)
	if [ -z "${SC_URL_NVRAM}" -o "${SC_URL_NVRAM}" != "${SC_URL}" ];then
		nvram set sc_url=${SC_URL}
		nvram commit
	fi
	local softcenter_home_url=$(dbus get softcenter_home_url)
	if [ -z "${softcenter_home_url}" ];then
		local softcenter_home_url=${SC_URL}
	fi

	# 1. before install, detect if some value (passed from web) exist.
	if [ -z "${softcenter_home_url}" -o -z "${softcenter_installing_md5}" -o -z "${softcenter_installing_version}" -o -z "${softcenter_installing_tar_url}" -o -z "${softcenter_installing_todo}" -o -z "${softcenter_installing_title}" ]; then
		echo_date "-------------------------------------------------------------------"
		echo_date "软件中心：参数错误，退出！"
		echo_date "这种情况是极少的，如果你遇到了，建议重启路由器后再尝试卸载操作！"
		echo_date "如果仍然不能解决，只能建议重置软件中心或者重置路由器已解决问题！"
		echo_date "-------------------------------------------------------------------"
		echo_date "退出本次插件安装！"
		quit_ks_install
	fi

	# 2. detect ks_app_install.sh process
	local KS_PID=$$
	local KS_SCRIPT_PID=$(ps | grep "ks_app_install.sh" | grep -vw "grep" | grep -vw "${KS_PID}")
	if [ -n "${KS_SCRIPT}" ];then
		if [ -n "${softcenter_installing_name}" ];then
			# 如果有其它ks_app_install.sh在运行，且${softcenter_installing_name}不为空，说明有插件正在安装/卸载，此时应该退出安装
			echo_date "-------------------------------------------------------------------"
			echo_date "软件中心：检测到上个插件：【${softcenter_installing_name}】正在安装/卸载..."
			echo_date "请等待上个插件安装/卸载完毕后再试！"
			echo_date "如果等待很久仍然是该错误，请重启路由后再试！"
			echo_date "-------------------------------------------------------------------"
			echo_date "退出本次插件安装！"
			quit_ks_install
		else
			# 如果有其它ks_app_install.sh在运行，且${softcenter_installing_name}为空，那么杀掉该进程，然后继续安装
			kill -9 ${KS_SCRIPT_PID}
		fi
	fi

	# 3. 检查上次插件安装是否正确，并且给与警告
	if [ -n "${softcenter_installing_name}" ];then
		echo_date "软件中心：检测到上次安装的插件【${softcenter_installing_name}】没有正确安装！"
		echo_date "软件中心：如果已安装里已经有【${softcenter_installing_name}】插件图标，建议将其卸载后重新安装！"
	fi

	# 4. 如果安装出现异常，比如 ks_app_install.sh进程被意外中断，$softcenter_installing_name值将得到保留，以进行上面第2、3步的检测。
	softcenter_installing_name=${softcenter_installing_title}
	dbus set softcenter_installing_name=${softcenter_installing_title}

	# 5. 比较版本号
	local OLD_VERSION=$(dbus get softcenter_module_${softcenter_installing_todo}_version)
	[ -z "${OLD_VERSION}" ] && OLD_VERSION=0
	local CMP=$(versioncmp ${softcenter_installing_version} ${OLD_VERSION})
	if [ "${softcenter_installing_todo}" == "softcenter" ]; then
		local CMP="-1"
	fi
	if [ "${CMP}" != "-1" ]; then
		echo_date "-------------------------------------------------------------------"
		echo_date "插件【${softcenter_installing_name}】本地版本号已经是最新版本，无须更新！"
		echo_date "插件【${softcenter_installing_name}】本地版本号：${OLD_VERSION}"
		echo_date "插件【${softcenter_installing_name}】在线版本号：${softcenter_installing_version}"
		echo_date "目前软件中心不支持插件降级为低版本，或者同版本平刷！"
		echo_date "可能是软件中心维护人员手残推送了错误的版本号！请无视或到koolshare论坛反馈。"
		echo_date "-------------------------------------------------------------------"
		echo_date "退出本次插件安装！"
		quit_ks_install
	fi

	# 6. 下载准备，再删除一次插件包，避免 xxx.tar.gz 下载为 xxx.tar.gz1等名字
	rm -rf /tmp/*.tar.gz* >/dev/null 2>&1
	local MAXDEPTH_SUPP=$(find --help 2>&1|grep -Eco maxdepth)
	if [ "${MAXDEPTH_SUPP}" == "1" ];then
		local INSTALL_SCRIPT_TMP=$(find /tmp -maxdepth 2 -name "install.sh")
	else
		local INSTALL_SCRIPT_TMP=$(find /tmp -name "install.sh")
	fi
	local SCRIPT_AB_DIR_TMP=$(dirname ${INSTALL_SCRIPT_TMP})
	rm -rf ${SCRIPT_AB_DIR_TMP} >/dev/null 2>&1
	echo_date "插件【${softcenter_installing_title}】将会被安装到/jffs文件夹..."
	
	# 7. 开始下载
	local FNAME=$(basename ${softcenter_installing_tar_url})
	local TAR_URL=${softcenter_home_url}${URL_SPLIT}${softcenter_installing_tar_url}
	echo_date "插件【${softcenter_installing_name}】的压缩包正在下载中，请稍候..."
	### echo_date "下载地址：${softcenter_home_url}${URL_SPLIT}${softcenter_installing_tar_url}"
	cd /tmp
	wget -t 2 -T 20 --dns-timeout=15 --no-check-certificate ${TAR_URL}
	RETURN_CODE=$?
	if [ "$RETURN_CODE" != "0" ]; then
		echo_date "-------------------------------------------------------------------"
		echo_date "压缩包下载错误，错误代码：$RETURN_CODE"
		echo_date "出现该错误一般是本地网络问题，比如本地DNS无法解析软件中心域名等..."
		echo_date "建议关闭代理、更换路由器DNS后再试，或者使用下方提供的插件地址手动下载后离线安装。"
		echo_date "下载地址：${softcenter_home_url}${URL_SPLIT}${softcenter_installing_tar_url}"
		echo_date "-------------------------------------------------------------------"
		echo_date "退出本次在线安装！"
		quit_ks_install
	else
		echo_date "插件【${softcenter_installing_title}】的安装包：${FNAME}下载成功！"
	fi

	# 8. 校验下载 
	echo_date "准备校验文件：${FNAME}"
	local md5sum_gz=$(md5sum /tmp/${FNAME} | awk '{print $1}')
	if [ "$md5sum_gz"x != "$softcenter_installing_md5"x ]; then
		echo_date "-------------------------------------------------------------------"
		echo_date "下载的插件压缩包文件校验不一致！退出本次插件安装！"
		echo_date "插件【${softcenter_installing_name}】在线版本md5：${softcenter_installing_md5}"
		echo_date "插件【${softcenter_installing_name}】下载版本md5：${md5sum_gz}"
		echo_date "建议重启/重置路由器后重试，或者使用下方提供的插件地址手动下载后离线安装。"
		echo_date "下载地址：${softcenter_home_url}${URL_SPLIT}${softcenter_installing_tar_url}"
		echo_date "-------------------------------------------------------------------"
		echo_date "退出本次在线安装！"
		quit_ks_install
	fi

	# 9. 解压插件
	echo_date "校验一致，准备解压..."
	tar -zxf ${FNAME}
	if [ "$?" != "0" ]; then
		echo_date "-------------------------------------------------------------------"
		echo_date "错误：插件压缩包解压失败！退出本次插件安装！"
		echo_date "建议重启/重置路由器后重试。"
		echo_date "-------------------------------------------------------------------"
		echo_date "退出本次在线安装！"
		quit_ks_install
	else
		echo_date "解压成功，寻找安装脚本！"
	fi

	# 10. 检查install.sh
	if [ ! -f /tmp/${softcenter_installing_todo}/install.sh ]; then
		echo_date "-------------------------------------------------------------------"
		echo_date "插件包内未找到 install.sh 安装脚本！退出本次安装！"
		echo_date "建议重启/重置路由器后重试，或者到koolshare论坛反馈！"
		echo_date "-------------------------------------------------------------------"
		echo_date "退出本次在线安装！"
		quit_ks_install
	else
		echo_date "找到安装脚本，准备安装！"
	fi

	# 11. 检查jffs空间
	local JFFS_AVAIL1=$(jffs_space)
	local JFFS_AVAIL2=$((${JFFS_AVAIL1} - 2048))
	local JFFS_NEEDED=$(du -s /tmp/${softcenter_installing_todo} | awk '{print $1}')
	# local PLUGIN_SIZE=$(du -s /tmp/${TAR_NAME} | awk '{print $1}')
	# echo_date "JFFS剩余空间-1：${JFFS_AVAIL1}KB"
	# echo_date "JFFS剩余空间-2：${JFFS_AVAIL2}KB"
	# echo_date "插件文件夹大小：${JFFS_NEEDED}KB"
	# echo_date "插件压缩包大小：${PLUGIN_SIZE}KB"
	local MODULE_UPGRADE=$(dbus get softcenter_module_${softcenter_installing_todo}_install)
	# 该插件之前没有安装，需要计算下插件安装需要的空间
	if [ -z "${MODULE_UPGRADE}" ];then
		# 可用空间小于2MB
		if [ "${JFFS_AVAIL1}" -lt "2048" ];then
			echo_date "-------------------------------------------------------------------"
			echo_date "当前jffs分区剩余：${JFFS_AVAIL1}KB, 剩余容量已经小于2MB！"
			echo_date "为了避免系统服务使用JFFS分区出现容量问题，不进行插件安装！"
			echo_date "请适当清理JFFS空间，或者建议使用USB2JFFS插件对JFFS进行扩容！"
			echo_date "-------------------------------------------------------------------"
			echo_date "退出插件在线安装！"
			quit_ks_install
		fi
		
		# 可用空间小于插件需要空间，保留2MB后自然也是小于插件空间，不安装
		if [ "${JFFS_AVAIL1}" -lt "${JFFS_NEEDED}" ];then
			echo_datec "-------------------------------------------------------------------"
			echo_date "当前jffs分区剩余：${JFFS_AVAIL1}KB, 插件安装大致需要${JFFS_NEEDED}KB，空间不足！"
			echo_date "请清理jffs分区内不要的文件，或者使用USB2JFFS插件对jffs分区进行扩容后再试！！"
			echo_date "-------------------------------------------------------------------"
			echo_date "退出插件在线安装！"
			quit_ks_install
		fi

		# 可用空间大于插件需要空间，保留2MB后却小于插件需要空间，不安装
		if [ "${JFFS_AVAIL1}" -gt "${JFFS_NEEDED}" -a "${JFFS_AVAIL2}" -lt "${JFFS_NEEDED}" ];then
			echo_date "-------------------------------------------------------------------"
			echo_date "当前jffs分区剩余：${JFFS_AVAIL1}KB, 插件安装大致需要${JFFS_NEEDED}KB！"
			echo_date "为了避免系统服务使用JFFS分区出现容量问题，软件中心会给jffs预留2MB的空间！"
			echo_date "如果安装此插件会导致JFFS可用空间小于2MB，因此本次不进行插件安装！"
			echo_date "请清理jffs分区内不要的文件，或者使用USB2JFFS插件对jffs分区进行扩容后再试！！"
			echo_date "-------------------------------------------------------------------"
			echo_date "退出插件在线安装！"
			quit_ks_install
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
			echo_date "退出插件在线安装！"
			exit_tar_install 1
		else
			echo_date "当前jffs分区剩余：${JFFS_AVAIL1}KB, 空间满足，继续安装！"
		fi
	fi

	# 本脚本不检测jffs容量，插件自己检测
	if [ "${MODULE_UPGRADE}" == "4" ];then
		echo_date "安装此插件不进行JFFS空间检测，交由插件自行检测！请自行注意JFFS使用情况！"
	fi	
	
	# 软件中心提供的插件已经明确区分了平台，但是某些以module形式存在的插件还没有加校验
	# 所以目前校验暂时在离线安装里做，避免用户装错插件，在线安装这里暂时不做校验
	# 12. 检查.valid
	# if [ ! -f "/tmp/${softcenter_installing_todo}/.valid" ];then
	# 	echo_date "软件中心：插件包内未找到 .valid 校验文件！退出本次安装！"
	# 	quit_ks_install
	# fi

	# 13. 检查.valid 字符串
	# if [ -z "$(grep -w hnd /tmp/${softcenter_installing_todo}/.valid)" ];then
	# 	echo_date "软件中心：该插件包不能在本平台安装！"
	# 	quit_ks_install
	# fi
	
	# 14. 复制uninstall.sh，在运行install.sh之前进行，避免安装包/文件夹被install.sh删掉
	if [ -f /tmp/${softcenter_installing_todo}/uninstall.sh ]; then
		chmod 755 /tmp/${softcenter_installing_todo}/uninstall.sh
		cp -rf /tmp/${softcenter_installing_todo}/uninstall.sh /koolshare/scripts/uninstall_${softcenter_installing_todo}.sh
	fi

	get_ui_type

	# 15. 皮肤预处理-1，目前softwarece center采用ROG文件夹方式存放皮肤
	if [ -d /tmp/${softcenter_installing_todo}/ROG -a "${UI_TYPE}" == "ROG" ]; then
		cp -rf /tmp/${softcenter_installing_todo}/ROG/* /tmp/${softcenter_installing_todo}/
	fi
	if [ -d /tmp/${softcenter_installing_todo}/ROG -a "${UI_TYPE}" == "TUF" ]; then
		find /tmp/${softcenter_installing_todo}/ROG/ -name "*.asp" | xargs sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g'
		find /tmp/${softcenter_installing_todo}/ROG/ -name "*.css" | xargs sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g'
		cp -rf /tmp/${softcenter_installing_todo}/ROG/* /tmp/${softcenter_installing_todo}/
	fi

	# 16. 皮肤预处理-2，一般来说插件的install.sh里会处理，但是避免一些插件没有处理，所以安装前先处理一次
	if [ "${UI_TYPE}" == "ROG" ];then
		echo_date "为插件【${softcenter_installing_name}】安装ROG风格皮肤..."
		sed -i '/asuscss/d' /tmp/${softcenter_installing_todo}/webs/Module_${softcenter_installing_todo}.asp >/dev/null 2>&1
	else
		if [ "${UI_TYPE}" == "TUF" ];then
			echo_date "为插件【${softcenter_installing_name}】安装TUF风格皮肤..."
			sed -i '/asuscss/d' /tmp/${softcenter_installing_todo}/webs/Module_${softcenter_installing_todo}.asp >/dev/null 2>&1
			sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /tmp/${softcenter_installing_todo}/webs/Module_${softcenter_installing_todo}.asp >/dev/null 2>&1
		else
			echo_date "为插件【${softcenter_installing_name}】安装ASUSWRT风格皮肤..."
			sed -i '/rogcss/d' /tmp/${softcenter_installing_todo}/webs/Module_${softcenter_installing_todo}.asp >/dev/null 2>&1
		fi
	fi

	# 17. 运行install.sh进行插件安装
	echo_date "使用插件【${softcenter_installing_name}】提供的install.sh脚本进行安装..."
	[ "${softcenter_installing_todo}" != "softcenter" ] && echo_date =========================== step 2 ================================
	chmod a+x /tmp/${softcenter_installing_todo}/install.sh
	# 使用start-stop-daemon，而不是shell fork，避免可能得install.sh问题导致ks_app_install.sh卡死
	# sh /tmp/${softcenter_installing_todo}/install.sh
	start-stop-daemon -S -q -x /tmp/${softcenter_installing_todo}/install.sh 2>&1
	if [ "$?" != "0" ];then
		rm -rf /koolshare/scripts/uninstall_${softcenter_installing_todo}.sh
		echo_date "-------------------------------------------------------------------"
		echo_date "软件中心：插件安装失败！请联系插件作者或者koolshare开发组以解决问题！"
		echo_date "-------------------------------------------------------------------"
		echo_date "本次插件安装失败！退出！"
		quit_ks_install
	fi
	[ "${softcenter_installing_todo}" != "softcenter" ] && echo_date =========================== step 3 ================================

	# 18. 安装完毕，写入安装相关的值
	if [ "$softcenter_installing_todo" != "softcenter" ]; then
		echo_date "为插件【${softcenter_installing_name}】设置版本号：${softcenter_installing_version}"
		dbus set softcenter_module_${softcenter_installing_todo}_md5=${softcenter_installing_md5}
		dbus set softcenter_module_${softcenter_installing_todo}_version=${softcenter_installing_version}
		dbus set softcenter_module_${softcenter_installing_todo}_install=1
		dbus set ${softcenter_installing_todo}_version=${softcenter_installing_version}
	else
		echo_date "为软件中心设置版本号：${softcenter_installing_version}"
		dbus set softcenter_version=${softcenter_installing_version}
		dbus set softcenter_md5=${softcenter_installing_md5}
	fi

	# 19. 安装完毕，打印剩余空间
	local JFFS_AVAIL3=$(jffs_space)
	local JFFS_USED=$((${JFFS_AVAIL1} - ${JFFS_AVAIL3}))
	if [ "${JFFS_USED}" -ge "0" ];then
		echo_date "本次安装占用了${JFFS_USED}KB空间，目前jffs分区剩余容量：${JFFS_AVAIL3}KB"
	elif [ "${JFFS_USED}" -lt "0" ];then
		local JFFS_RELEASED=${JFFS_USED#-}
		echo_date "本次安装释放了${JFFS_RELEASED}KB空间，目前jffs分区剩余容量：${JFFS_AVAIL3}KB"
	fi
	if [ "${JFFS_AVAIL3}" -lt "2000" ];then
		echo_date "注意！目前jffs分区剩余容量只剩下：${JFFS_AVAIL3}KB，已不足2MB！"
	fi
	
	# 20. 安装完毕，删除相关值和安装包
	echo_date "安装完毕！"
	quit_ks_install
}

uninstall_ks_module() {
	local JFFS_AVAL=$(df | grep -w "/jffs" | awk '{print $4}')
	
	# 1. before uninstall, detect if some value exist.
	if [ -z "${softcenter_installing_todo}" -o -z "${softcenter_installing_title}" -o "${softcenter_installing_todo}" == "softcenter" ]; then
		echo_date "-------------------------------------------------------------------"
		echo_date "软件中心：参数错误，退出！"
		echo_date "这种情况是极少的，如果你遇到了，建议重启路由器后再尝试卸载操作！"
		echo_date "如果仍然不能解决，只能建议重置软件中心或者重置路由器已解决问题！"
		echo_date "-------------------------------------------------------------------"
		echo_date "退出本次插件卸载！"
		quit_ks_uninstall
	fi

	# 2. detect if plugin is running
	local ENABLED=$(dbus get ${softcenter_installing_todo}_enable)
	if [ "${ENABLED}" == "1" ]; then
		echo_date "-------------------------------------------------------------------"
		echo_date "软件中心：插件【${softcenter_installing_title}】无法卸载！"
		echo_date "因为插件【${softcenter_installing_title}】已经开启！你必须先将其关闭后才能进行卸载操作！"
		echo_date "-------------------------------------------------------------------"
		echo_date "退出本次插件卸载！"
		quit_ks_uninstall
	fi

	# 3. try to call uninstall script
	echo_date "开始卸载【${softcenter_installing_title}】插件，请稍候！"
	if [ -f /koolshare/scripts/${softcenter_installing_todo}_uninstall.sh]; then
		echo_date "使用插件【${softcenter_installing_title}】自带卸载脚本：${softcenter_installing_todo}_uninstall.sh 卸载！"
 		# sh /koolshare/scripts/${softcenter_installing_todo}_uninstall.sh
 		start-stop-daemon -S -q -x /koolshare/scripts/${softcenter_installing_todo}_uninstall.sh 2>&1
	elif [ -f "/koolshare/scripts/uninstall_${softcenter_installing_todo}.sh" ]; then
		echo_date "使用插件【${softcenter_installing_title}】自带卸载脚本：uninstall_${softcenter_installing_todo}.sh 卸载！"
		# sh /koolshare/scripts/uninstall_${softcenter_installing_todo}.sh
 		start-stop-daemon -S -q -x /koolshare/scripts/uninstall_${softcenter_installing_todo}.sh 2>&1
 		if [ "$?" == "1" ];then
			echo_date "============================= end ================================="
 			echo "XU6J03M6"
			exit
 		fi
	else
		echo_date "没有找到插件【${softcenter_installing_title}】自带的卸载脚本，使用软件中心的卸载功能进行卸载！"
		rm -rf /koolshare/${softcenter_installing_todo} >/dev/null 2>&1
		rm -rf /koolshare/bin/${softcenter_installing_todo} >/dev/null 2>&1
		rm -rf /koolshare/init.d/*${softcenter_installing_todo}* >/dev/null 2>&1
		rm -rf /koolshare/scripts/${softcenter_installing_todo}*.sh >/dev/null 2>&1
		rm -rf /koolshare/res/icon-${softcenter_installing_todo}.png >/dev/null 2>&1
		rm -rf /koolshare/webs/Module_${softcenter_installing_todo}.asp >/dev/null 2>&1
	fi

	# 4. remove software center value for specific plugin
	if [ -n "$(dbus get softcenter_module_${softcenter_installing_todo}_install)" ];then
		echo_date "移除插件【${softcenter_installing_title}】储存的相关参数..."
		dbus remove softcenter_module_${softcenter_installing_todo}_md5
		dbus remove softcenter_module_${softcenter_installing_todo}_version
		dbus remove softcenter_module_${softcenter_installing_todo}_install
		dbus remove softcenter_module_${softcenter_installing_todo}_description
		dbus remove softcenter_module_${softcenter_installing_todo}_name
		dbus remove softcenter_module_${softcenter_installing_todo}_title
	fi
	
	# 5. remove plugin dbus value
	local txt=$(dbus list ${softcenter_installing_todo})
	printf "%s\n" "$txt" |
	while IFS= read -r line; do
		line2="${line%=*}"
		if [ "${line2}" != "" ]; then
			echo_date "移除参数：${line2}"
			dbus remove ${line2}
		fi
	done

	# 6. try to remove broken link
	local LINKS=$(ls -lh /koolshare/init.d|grep -E "^l"|awk '{print $9}')
	if [ -n "${LINKS}" ];then
		for link in ${LINKS}
		do
			if [ ! -f /koolshare/init.d/$link ];then
				echo_date "移除文件：/koolshare/init.d/$link"
				rm -rf /koolshare/init.d/$link
			fi
		done
	fi

	# 7. alert jffs_space uasge
	local JFFS_AVAL_2=$(jffs_space)
	local JFFS_RELEASED=$(($JFFS_AVAL_2 - $JFFS_AVAL))
	echo_date "软件中心：本次卸载释放了${JFFS_RELEASED}KB，目前jffs分区剩余容量：${JFFS_AVAL_2}KB"

	# 7. finish uninstall
	echo_date "卸载成功！"
	quit_ks_uninstall
}

download_softcenter_log(){
	rm -rf /tmp/files
	rm -rf /koolshare/webs/files
	mkdir -p /tmp/files
	ln -sf /tmp/files /koolshare/webs/files
	if [ -f "${LOG_FILE_BACKUP}" ];then
		cp -rf ${LOG_FILE_BACKUP} /tmp/files/softcenter_log.txt
		sed -i 's/XU6J03M6//g' /tmp/files/softcenter_log.txt
	else
		echo "日志为空" > /tmp/files/softcenter_log.txt
	fi
}

clean_backup_log() {
	local LOG_MAX=1000
	[ $(wc -l "${LOG_FILE_BACKUP}" | awk '{print $1}') -le "$LOG_MAX" ] && return
	local logdata=$(tail -n 500 "${LOG_FILE_BACKUP}")
	echo "${logdata}" > ${LOG_FILE_BACKUP} 2> /dev/null
	unset logdata
}

# echo_date \$2: $2 | tee -a $LOG_FILE
case $2 in
download_log)
	download_softcenter_log
	http_response $1
	;;
clean_log)
	echo XU6J03M6 | tee ${LOG_FILE_BACKUP}
	http_response $1
	;;
ks_app_remove)
	true > ${LOG_FILE}
	http_response $1
	echo_date "============================ start ================================" | tee -a ${LOG_FILE} ${LOG_FILE_BACKUP}
	uninstall_ks_module | tee -a ${LOG_FILE} ${LOG_FILE_BACKUP}
	clean_backup_log
	;;
install|update|ks_app_install|*)
	true > ${LOG_FILE}
	http_response $1
	echo_date "=========================== step 1 ================================" | tee -a ${LOG_FILE} ${LOG_FILE_BACKUP}
	install_ks_module | tee -a ${LOG_FILE} ${LOG_FILE_BACKUP}
 	clean_backup_log
	;;
esac
