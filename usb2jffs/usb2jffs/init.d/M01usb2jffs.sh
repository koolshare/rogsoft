#!/bin/sh

# usb2jffs 开机自动挂载脚本

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval $(dbus export usb2jffs_)
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】'
#LOG_FILE=/data/usb2jffs_log_m.txt
LOG_FILE=/tmp/upload/usb2jffs_log.txt
LINUX_VER=$(uname -r|awk -F"." '{print $1$2}')

MTPATH=$1

stop_software_center(){
	killall skipd >/dev/null 2>&1
	killall skipd >/dev/null 2>&1
	killall perpboot >/dev/null 2>&1
	killall tinylog >/dev/null 2>&1
	killall perpd >/dev/null 2>&1
	killall httpdb >/dev/null 2>&1
	[ -n "$(pidof httpdb)" ] && kill -9 $(pidof httpdb) >/dev/null 2>&1
}

start_software_center(){
	stop_software_center
	service start_skipd >/dev/null 2>&1
	/koolshare/perp/perp.sh start >/dev/null 2>&1
}

get_current_jffs_device(){
	# 查看当前/jffs的挂载点是什么设备，如/dev/mtdblock9, /dev/sda1；有usb2jffs的时候，/dev/sda1，无usb2jffs的时候，/dev/mtdblock9，出问题未正确挂载的时候，为空
	local cur_patition=$(df -h | /bin/grep /jffs |awk '{print $1}')
	if [ -n "${cur_patition}" ];then
		jffs_device=${cur_patition}
		return 0
	else
		jffs_device=""
		return 1
	fi
}

_get_model(){
	local odmpid=$(nvram get odmpid)
	local MODEL=$(nvram get productid)
	if [ -n "${odmpid}" ];then
		echo "${odmpid}"
	else
		echo "${MODEL}"
	fi
}

get_jffs_original_mount_device(){
	local mtd_jffs=$(df -h | /bin/grep -E "/jffs|cifs2" | awk '{print $1}' | /bin/grep -E "/dev/mtd|ubi:jffs" | head -n1)
	if [ -n "${mtd_jffs}" ];then
		mtd_disk="${mtd_jffs}"
		return 0
	else
		local model=$(_get_model)
		case ${model} in
			RT-AC86U|GT-AC5300)
				mtd_disk="/dev/mtdblock8"
				return 0
				;;
			RT-AX88U|GT-AX11000|TUF-AX3000|RT-AX56U)
				mtd_disk="/dev/mtdblock9"
				return 0
				;;
			RT-AC5300|RT-AC88U)
				mtd_disk="/dev/mtdblock4"
				return 0
				;;
			GT-AX6000|XT12)
				mtd_disk="ubi:jffs2"
				;;
			TX-AX6000|TUF-AX4200Q)
				mtd_disk="/dev/ubi0_5"
				;;
			*)
				mtd_disk=""
				return 1
				;;
		esac
	fi
}

set_sync_job(){
	if [ "${usb2jffs_sync}" == "0" ]; then
		echo_date "USB2JFFS：删除插件定时同步任务..."
		sed -i '/usb2jffs_sync/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	elif [ "${usb2jffs_sync}" == "1" ]; then
		echo_date "USB2JFFS：设置每天${usb2jffs_time_hour}时${usb2jffs_time_min}分同步文件..."
		cru a usb2jffs_sync ${usb2jffs_time_min} ${usb2jffs_time_hour}" * * * sh /koolshare/scripts/usb2jffs_config.sh sync"
	elif [ "${usb2jffs_sync}" == "2" ]; then
		echo_date "USB2JFFS：设置每周${usb2jffs_week}的${usb2jffs_time_hour}时${usb2jffs_time_min}分同步文件..."
		cru a usb2jffs_sync ${usb2jffs_time_min} ${usb2jffs_time_hour}" * * "${usb2jffs_week}" sh /koolshare/scripts/usb2jffs_config.sh sync"
	elif [ "${usb2jffs_sync}" == "3" ]; then
		echo_date "USB2JFFS：设置每月${usb2jffs_day}日${usb2jffs_time_hour}时${usb2jffs_time_min}分同步文件..."
		cru a usb2jffs_sync ${usb2jffs_time_min} ${usb2jffs_time_hour} ${usb2jffs_day}" * * sh /koolshare/scripts/usb2jffs_config.sh sync"
	elif [ "${usb2jffs_sync}" == "4" ]; then
		if [ "${usb2jffs_inter_pre}" == "1" ]; then
			echo_date "USB2JFFS：设置每隔${usb2jffs_inter_min}分钟同步文件..."
			cru a usb2jffs_sync "*/"${usb2jffs_inter_min}" * * * * sh /koolshare/scripts/usb2jffs_config.sh sync"
		elif [ "${usb2jffs_inter_pre}" == "2" ]; then
			echo_date "USB2JFFS：设置每隔${usb2jffs_inter_hour}小时同步文件..."
			cru a usb2jffs_sync "0 */"${usb2jffs_inter_hour}" * * * sh /koolshare/scripts/usb2jffs_config.sh sync"
		elif [ "${usb2jffs_inter_pre}" == "3" ]; then
			echo_date "USB2JFFS：设置每隔${usb2jffs_inter_day}天${usb2jffs_inter_hour}小时${usb2jffs_time_min}分钟同步文件..."
			cru a usb2jffs_sync ${usb2jffs_time_min} ${usb2jffs_time_hour}" */"${usb2jffs_inter_day} " * * sh /koolshare/scripts/usb2jffs_config.sh sync"
		fi
	elif [[ "${usb2jffs_sync}" == "5" ]]; then
		check_custom_time=`dbus get usb2jffs_custom | base64_decode`
		echo_date "USB2JFFS：设置每天${check_custom_time}时的${usb2jffs_time_min}分同步文件..."
		cru a usb2jffs_sync ${usb2jffs_time_min} ${check_custom_time}" * * * sh /koolshare/scripts/usb2jffs_config.sh sync"
	fi
}

JFFS2USB(){
	# 某些没有安装在原始JFFS中的，却在USBJFFS中安装了的，且赖mount-start的插件，比如swap，aria2等，无法开机启动
	# 所以需要原始JFFS中的M01usb2jffs.sh运行完毕后，再次运行一次所有的 /koolshare/init.d/Mxxxx.sh的脚本
	# 但是又不需要运行到USBJFFS中的M01usb2jffs.sh
	if [ -f "/tmp/ks_postmount_flag" ];then
		rm -rf /tmp/ks_postmount_flag
		return 1
	fi

	# 开始主逻辑
	echo "======================== USB2JFFS - 开机自动挂载 ========================"
	echo_date "USB2JFFS：${0##*/} $@"
	
	# 检测是否已经有USB设备挂载了jffs，如果JFFS的挂载设备有多个，说明已经挂在
	# 防止用户在路由器开机状态，并且已经替换了JFFS为USB的情况下，再插入一个有.koolshare_jffs目录的USB储存设备导致重复挂载
	get_current_jffs_device
	local mounted_nu=$(mount | /bin/grep "${jffs_device}" | grep -E "/tmp/mnt/|/jffs"|/bin/grep -c "/dev/s")
	if [ "${mounted_nu}" == "2" ]; then
		# echo_date "USB2JFFS：检测到你的USB磁盘${jffs_device}已经挂载在/jffs上了，跳过！"
		return 1
	fi
	
	# 判断插入USB磁盘设备的格式
	local format=$(mount | /bin/grep "${MTPATH}" | awk '{print $5}')
	if [ "${format}" == "ext2" -o "${format}" == "ext3" -o "${format}" == "ext4" ];then
		echo_date "USB2JFFS：USB磁盘${MTPATH}格式为${format}，符合USB2JFFS要求！"
	else
		# echo_date "USB2JFFS：USB磁盘${MTPATH}格式为${format}，不符合USB2JFFS要求！"
		return 1
	fi
	
	# 寻找是否已经安装有软件中心
	if [ -d "${MTPATH}/.koolshare_jffs/.koolshare" ]; then
		echo_date "USB2JFFS：USB磁盘${MTPATH}内找到jffs目录：.koolshare_jffs"
	else
		# U盘里没有软件中心
		# echo_date "USB2JFFS：USB磁盘${MTPATH}内没有找到jffs目录：.koolshare_jffs，不进行任何操作，跳过！"
		return 1
	fi

	# 获取jffs原始设备
	get_jffs_original_mount_device
	if [ -z "${mtd_disk}" ]; then
		echo_date "无法找到原始/jffs挂载设备！请重启后重试！"
		return 1
	fi

	# 检测是否有不挂载的标记文件
	if [ -f "${MTPATH}/.koolshare_jffs/.usb2jffs_flag" ]; then
		echo_date "USB2JFFS：因为你上次手动卸载了USB jffs的挂载，本次开机启动不进行挂载操作！"
		echo_date "USB2JFFS：如需继续挂载，请使用USB2JFFS插件重新手动挂载！"
		return 1
	fi

	# 检测用户是否重置了路由器，如果是，则用重置后的nvram替换
	if [ -z "$(nvram get usb2jffs_flag)" -o "$(nvram get usb2jffs_flag)" != "1" ]; then
		rm -f ${MTPATH}/.koolshare_jffs/nvram/*
		cp -af /jffs/nvram/* ${MTPATH}/.koolshare_jffs/nvram/
	fi

	# 检测并重写挂载点，因为重启路由等操作可能导致设备挂载路点字改变，比如 /tmp/mnt/sda1 → /tmp/mnt/sdb1
	if [ "${usb2jffs_mount_path}" != "${MTPATH}" ]; then
		echo_date "USB2JFFS：检测到挂载点发生改变：${usb2jffs_mount_path} → ${MTPATH}，更新挂载点记录！"
		dbus set usb2jffs_mount_path=${MTPATH}
	fi
	
	# 关闭skipd和httpdb进程
	# 1. 因为rc service运行了skipd，而skipd的数据库位于/jffs/db
	# 2. 因为.asusrouter已经运行了/jffs里的httpdb
	echo_date "USB2JFFS：停止软件中心相关进程！"
	stop_software_center

	# --------------------
	
	echo_date "USB2JFFS：卸载/jffs！"
	umount -l /jffs
	if [ "$?" == "0" ]; then
		echo_date "USB2JFFS：/jffs卸载成功！"
	else
		echo_date "USB2JFFS：/jffs卸载失败！退出！"
		echo_date "USB2JFFS：重启软件中心相关进程！"
		start_software_center
		return 1
	fi
	
	echo_date "USB2JFFS：挂载USB磁盘目录：${MTPATH}/.koolshare_jffs → /jffs"
	mount -o rbind ${MTPATH}/.koolshare_jffs /jffs
	if [ "$?" == "0" ]; then
		# 如果用户使用的软件中心版本为1.0，但是用户刚刷了固件，固件内置的是1.1
		# 如果用户没使用usb2jffs插件，那么固件的jffsinit.sh会为用户更新jffs内的软件中心，但是无法更新USB内的软件中心
		# 所以需要usb2jffs插件在启动挂载的时候，检测下rom内是否有更加新的软件中心，如果有则更新
		# 此时更新的话要避免将softcenter更新成koolcenter，导致出现双koolcenter的情况
		# --------------------------------------------------------
		CENTER_TYPE=$(cat /jffs/.koolshare/webs/Module_Softcenter.asp 2>/dev/null| grep -Eo "/softcenter/app.json.js")
		if [ -f "/koolshare/.soft_ver" ];then
			if [ -n "${CENTER_TYPE}" ];then
				# softceter in use
				CUR_VERSION=$(cat /koolshare/.soft_ver)
				ROM_VERSION=$(cat /rom/etc/koolshare/.soft_ver_old)
			else
				# koolcenter in use
				CUR_VERSION=$(cat /koolshare/.soft_ver)
				ROM_VERSION=$(cat /rom/etc/koolshare/.soft_ver)
			fi
		else
			CUR_VERSION="0"
			ROM_VERSION=$(cat /rom/etc/koolshare/.soft_ver)
		fi
		COMP=$(/rom/etc/koolshare/bin/versioncmp $CUR_VERSION $ROM_VERSION)
		if [ ! -d "/jffs/.koolshare" -o "$COMP" == "1" ]; then
			echo_date "更新软件中心！"
			# remove before install
			rm -rf /koolshare/res/soft-v19 >/dev/null 2>&1
			
			# start to install
			mkdir -p /jffs/.koolshare
			cp -rf /rom/etc/koolshare/* /jffs/.koolshare/
			cp -rf /rom/etc/koolshare/.soft_ver* /jffs/.koolshare/
		
			# switch to softceter
			if [ -n "${CENTER_TYPE}" ];then
				sync
				mv /koolshare/.soft_ver /koolshare/.soft_ver_new
				sync
				mv /koolshare/.soft_ver_old /koolshare/.soft_ver
		
				mv /koolshare/webs/Module_Softcenter.asp /koolshare/webs/Module_Softcenter_new.asp
				sync
				mv /koolshare/webs/Module_Softcenter_old.asp /koolshare/webs/Module_Softcenter.asp
			fi
			
			mkdir -p /jffs/.koolshare/configs/
			chmod 755 /koolshare/bin/*
			chmod 755 /koolshare/init.d/*
			chmod 755 /koolshare/perp/*
			chmod 755 /koolshare/perp/.boot/*
			chmod 755 /koolshare/perp/.control/*
			chmod 755 /koolshare/perp/httpdb/*
			chmod 755 /koolshare/scripts/*
		
			# ssh PATH environment
			rm -rf /jffs/configs/profile.add >/dev/null 2>&1
			rm -rf /jffs/etc/profile >/dev/null 2>&1
			source_file=$(cat /etc/profile|grep -v nvram|awk '{print $NF}'|grep -E "profile"|grep "jffs"|grep "/")
			source_path=$(dirname /jffs/etc/profile)
			if [ -n "${source_file}" -a -n "${source_path}" ];then
				rm -rf ${source_file} >/dev/null 2>&1
				mkdir -p ${source_path}
				ln -sf /koolshare/scripts/base.sh ${source_file} >/dev/null 2>&1
			fi
			
			# make some link
			[ ! -L "/koolshare/bin/base64_decode" ] && ln -sf /koolshare/bin/base64_encode /koolshare/bin/base64_decode
			[ ! -L "/koolshare/scripts/ks_app_remove.sh" ] && ln -sf /koolshare/scripts/ks_app_install.sh /koolshare/scripts/ks_app_remove.sh
			[ ! -L "/jffs/.asusrouter" ] && ln -sf /koolshare/bin/kscore.sh /jffs/.asusrouter
		fi
	
		echo_date "USB2JFFS：挂载成功！继续！" 
		echo_date "USB2JFFS：重启软件中心相关进程！"
		if [ -z "$(pidof skipd)" ];then
			service start_skipd >/dev/null 2>&1
		fi
		sh /jffs/.koolshare/bin/kscore.sh
		echo_date "USB2JFFS：启动完毕，一点点扫尾工作..."

		# 在系统nvram中写入一个值，如果检测不到该值，则说明用户重置了路由器，如果此时又安装了本插件再次手动挂载
		# 则需要删除${MTPATH}/.koolshare_jffs/nvram文件夹下相关内容，避免重置路由无用
		# 虽然在插件里配置USB替换JFFS时候已经写入了，但是为了保险还是写入一次
		nvram set usb2jffs_flag=1
		nvram commit

		# 把原来的jffs分区挂载到cifs
		if [ "${LINUX_VER}" == "419" -o "${LINUX_VER}" == "54" ];then
			mount -t ubifs ${mtd_disk} /cifs2
		else
			mount -t jffs2 -o rw,noatime ${mtd_disk} /cifs2
		fi

		# 重新弄获取skipd值
		eval $(dbus export usb2jffs_)

		# 再次检测并重写挂载点，因为重启路由等操作可能导致设备挂载路点字改变，比如 /tmp/mnt/sda1 → /tmp/mnt/sdb1
		if [ "${usb2jffs_mount_path}" != "${MTPATH}" ]; then
			echo_date "USB2JFFS：检测到挂载点发生改变：${usb2jffs_mount_path} → ${MTPATH}，更新挂载点记录！"
			dbus set usb2jffs_mount_path=${MTPATH}
		fi
		
		# 设定定时同步
		set_sync_job

		# 1. [service-start]
		# 因为service-start启动太早，所以要在这里再启动一次
		start-stop-daemon -S -q -b -x /jffs/.koolshare/bin/ks-services-start.sh

		# 2. [wan-start]
		# 某些插件只存在于usbjffs中，并不在原始jffs，导致无法随wan-start启动，需要再启动一次
		if [ -f "/tmp/ks_wanstart_flag" ];then
			start-stop-daemon -S -q -b -x /jffs/.koolshare/bin/ks-wan-start.sh -- start
			rm -rf /tmp/ks_wanstart_flag
		fi

		# 3. [post-mount]
		# 某些插件只存在于usbjffs中，并不在原始jffs，导致无法随post-mount启动，需要再启动一次
		start-stop-daemon -S -q -b -x /jffs/.koolshare/bin/ks-mount-start.sh -- start $@
		touch /tmp/ks_postmount_flag
		echo_date "USB2JFFS：完成！"
	fi
	echo "========================================================================"
}

JFFS2USB $@ | tee -a ${LOG_FILE}
