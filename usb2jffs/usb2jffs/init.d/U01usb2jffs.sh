#!/bin/sh

# U01usb2jffs.sh，本脚本会被/jffs/scripts/unmount脚本触发，例如：U01usb2jffs.sh /tmp/mnt/sda1
#
# 当用户通过web界面卸载USB磁盘的时候，会触发/jffs/scripts/unmount运行，继而触发U01usb2jffs.sh运行
# 当使用USB，列如：/dev/sda1挂载了/tmp/mnt/sda1，同时还挂载了/jffs
# 当使用web界面右上角的卸载USB磁盘功能时，系统会卸载掉/dev/sda1设备上挂载的所有路径，此例中就是：/tmp/mnt/sda1和/jffs
# 所以/jffs/scripts/unmount会触发U01usb2jffs.sh运行两次，第一次：U01usb2jffs.sh /tmp/mnt/sda1 第二次：/tmp/mnt/sda1 jffs
# 第一次，运行：U01usb2jffs.sh /tmp/mnt/sda1，然后系统卸载掉/tmp/mnt/sda1
# 第二次，运行：U01usb2jffs.sh /jffs，然后系统卸载掉/jffs
# 虽然在U01usb2jffs.sh里将jffs的挂在从usb切换回了系统mtdblock分区，但是这仍然不能阻止第二次U01usb2jffs.sh运行，并且将/jffs再次卸载掉！
#
# 弹出U盘：
# 在用户使用USB挂载了/jffs的情况下，此时弹出U盘后，恢复系统分区mtdblock?与/jffs的挂载关系，并且重启软件中心
# 
# 重启路由：
# 重启的时候由T50usb2jffs.sh（services-stop触发）将/jffs的挂载方式复原，unmount脚本运行会晚于services-stop脚本十几秒，所以等到本脚本运行的时候，已经不需要其来恢复挂载关系
#
#	1. 检测/tmp/usb2jffs_restore.sh，没有则将/koolshare/scripts/usb2jffs_restore.sh复制到/tmp
#	2. 检测/tmp/usb2jffs_restore.sh文件和usb2jffs_restore.sh进程，没有的话使用start-stop-daemon运行/tmp/usb2jffs_restore.sh
#	3. usb2jffs_restore.sh对进程和jffs状态进行监测（设置检测时长），当检测到/jffs被卸载掉后，对其重新挂载并重启软件中心
#	4. 系统行为：卸载/dev/sda1, /jffs目录
#	5. usb2jffs_restore.sh重新挂载/jffs

alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】'
LOG_FILE=/tmp/upload/usb2jffs_log.txt
#LOG_FILE=/data/usb2jffs_log_u.txt
eval $(dbus export usb2jffs_)
KSPATH=${usb2jffs_mount_path}
UNPATH=$1

echo_date "USB2JFFS：系统即将卸载磁盘：$1" | tee -a $LOG_FILE

test(){
	# test
	echo_date ""
	echo_date "-----------------------------------------------------------------------------------------------"
	echo_date "-------------------------------------------- mount --------------------------------------------"
	mount
	echo_date "-------------------------------------------- df -h --------------------------------------------"
	df -h
	echo_date "-----------------------------------------------------------------------------------------------"
	echo_date ""
}

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
	sleep 1
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

get_current_usb_device(){
	local cur_patition=$(df -h | /bin/grep ${UNPATH} |awk '{print $1}'|/bin/grep "/dev/s")
	if [ -n "$cur_patition" ];then
		usb_device=${cur_patition}
		return 0
	else
		usb_device=""
		return 1
	fi
}

start(){
	# 获取${jffs_device}
	get_current_jffs_device
	if [ "$?" != "0" ]; then
		echo_date "USB2JFFS：/jffs没有磁盘设备挂载，无需卸载，退出！"
		return 1
	fi

	# 获取${usb_device}
	get_current_usb_device
	if [ "$?" != "0" ]; then
		echo_date "USB2JFFS：${UNPATH}没有找到对应挂载的USB磁盘设备，退出！"
		return 1
	fi

	if [ "${jffs_device}" == "${usb_device}" ]; then
		echo_date "USB2JFFS：检测到你的USB磁盘${usb_device}挂载在/jffs，继续！"
	else
		echo_date "USB2JFFS：设备分区${usb_device}挂载在${UNPATH}"
		echo_date "USB2JFFS：设备分区${jffs_device}挂载在/jffs"
		echo_date "USB2JFFS：/jffs和${UNPATH}的挂载设备不同，退出！"
		return 1		
	fi
	
	if [ ! -f "/tmp/usb2jffs_restore.sh" ];then
		cp -rf /koolshare/scripts/usb2jffs_restore.sh /tmp/usb2jffs_restore.sh
		chmod +x /tmp/usb2jffs_restore.sh
		sync
	fi

	local RESTORE_PROCESS=$(ps|/bin/grep "usb2jffs_restore.sh"|/bin/grep -v grep)
	if [ -z "${RESTORE_PROCESS}" ];then
		start-stop-daemon -S -b -q -x /tmp/usb2jffs_restore.sh >/dev/null 2>&1
	fi
}

start | tee -a $LOG_FILE