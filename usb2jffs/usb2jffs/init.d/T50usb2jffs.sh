#!/bin/sh

# T50usb2jffs.sh，本脚本会被/jffs/scripts/services-stop脚本触发，例如：T50usb2jffs.sh

# services-stop脚本通常在路由器软重启的时候运行，所以本脚本也在路由器软重启的时候运行
# services-stop运行的时候，系统刚刚进入重启状态，所有相关的一些系统服务还没有被关闭，网络等都还是正常的
# usb2jffs因为使用U盘替代了jffs分区，不知道什么原因，导致了在web界面和使用reboot重启命令，无法重启路由器
# 所以此脚本运行的时候，需要将usb2jffs的挂载给去掉，保证路由器能够成功软重启

alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】'
LOG_FILE=/tmp/upload/usb2jffs_log.txt
#LOG_FILE=/data/usb2jffs_log_t.txt
eval $(dbus export usb2jffs_)

echo_date "USB2JFFS：路由器重启，关闭相关进程..."

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
	local mtd_jffs=$(df -h | /bin/grep -E "/jffs|cifs2" | awk '{print $1}' | /bin/grep "/dev/mtd" | head -n1)
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
			*)
				mtd_disk=""
				return 1
				;;
		esac
	fi
}

start(){
	# 获取jffs原始挂载设备
	get_jffs_original_mount_device
	if [ "$?" != "0" ];then
		echo_date "USB2JFFS：没有获取到jffs的原始挂载设备，退出！"
		return 1
	fi
	
	# 获取${jffs_device}
	get_current_jffs_device
	if [ "$?" != "0" ]; then
		echo_date "USB2JFFS：/jffs没有磁盘设备挂载，退出！"
		return 1
	fi

	# 如果挂在数量为2，则${jffs_device}挂载在${usb_path}，也挂载在/jffs
	# 如：/dev/sda1挂载在/tmp/mnt/sda1，同时挂载在/jffs
	local mounted_nu=$(mount | /bin/grep "${jffs_device}" | grep -E "/tmp/mnt/|/jffs"|/bin/grep -c "/dev/s")
	local usb_path=$(mount | /bin/grep "${jffs_device}" | /bin/grep "/tmp/mnt/" | awk '{print $3}')
	if [ "${mounted_nu}" == "2" ]; then
		echo_date "USB2JFFS：${jffs_device}挂载在${usb_path}，同时也挂载在/jffs！"
	else
		return 1
	fi

	# 方法1：此时应该将其还原为原始的挂载方式
	# 方法2：反正都要重启，直接关闭相关进程后尝试卸载USB2JFFS即可，无需将/jffs重新挂载了
	echo_date "USB2JFFS：关闭软件中心！"
	killall skipd >/dev/null 2>&1
	killall perpboot >/dev/null 2>&1
	killall tinylog >/dev/null 2>&1
	killall perpd >/dev/null 2>&1
	killall httpdb >/dev/null 2>&1
	[ -n "$(pidof httpdb)" ] && kill -9 $(pidof httpdb) >/dev/null 2>&1
	
	# 写入缓存
	sync
	sleep 1

	echo_date "USB2JFFS：卸载/cifs2！"
	umount -l /cifs2 >/dev/null 2>&1
	if [ "$?" != "0" ]; then
		echo_date "USB2JFFS：卸载/cifs2失败！继续！"
	else
		echo_date "USB2JFFS：卸载/cifs2成功！继续！"
	fi

	echo_date "USB2JFFS：卸载/jffs！"
	umount -l /jffs >/dev/null 2>&1
	if [ "$?" != "0" ]; then
		echo_date "USB2JFFS：卸载/jffs失败！退出！"
		return 1
	else
		echo_date "USB2JFFS：卸载/jffs成功！继续！"
	
	fi

	# 恢复jffs分区原始挂载方式
	echo_date "USB2JFFS：重新挂载${mtd_disk}到/jffs..."
	mount -t jffs2 -o rw,noatime ${mtd_disk} /jffs
	if [ "$?" == "0" ]; then
		echo_date "USB2JFFS：重新挂载${mtd_disk}到/jffs成功！"

		# echo_date "USB2JFFS：开启软件中心！"
		# start_software_center
	else
		echo_date "USB2JFFS：重新挂载${mtd_disk}到/jffs失败！退出！"
	fi


}

start | tee -a $LOG_FILE