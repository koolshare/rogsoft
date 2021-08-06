#!/bin/sh

# 当用户通过web界面卸载USB磁盘的时候，会触发/jffs/scripts/unmount运行，继而触发U01usb2jffs.sh运行
# 当使用USB，列如：/dev/sda1挂载了/tmp/mnt/sda1，同时还挂载了/jffs
# 当使用web界面右上角的卸载USB磁盘功能时，系统会卸载掉/dev/sda1设备上挂载的所有路径，此例中就是：/tmp/mnt/sda1和/jffs
# 所以/jffs/scripts/unmount会触发U01usb2jffs.sh运行两次，第一次：U01usb2jffs.sh /tmp/mnt/sda1 第二次：/tmp/mnt/sda1 jffs
# 第一次，运行：U01usb2jffs.sh /tmp/mnt/sda1，然后系统卸载掉/tmp/mnt/sda1
# 第二次，运行：U01usb2jffs.sh /tmp/mnt/sda1，然后系统卸载掉/jffs
# 虽然在U01usb2jffs.sh里将jffs的挂在从usb切换回了系统mtdblock分区，但是这仍然不能阻止第二次U01usb2jffs.sh运行，并且将/jffs再次卸载掉！
# 本脚本：usb2jffs_restore.sh对进程和jffs状态进行监测（设置检测时长），当检测到/jffs被卸载掉后，对其重新挂载并重启软件中心

source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】'
#LOG_FILE=/tmp/upload/usb2jffs_log.txt
LOG_FILE=/data/usb2jffs_log_u.txt

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
		rm -rf /tmp/usb2jffs_restore.sh
		exit 1
	fi
	
	local i=120
	get_current_jffs_device
	until [ -z "${jffs_device}" ]; do
		i=$(($i - 1))
		get_current_jffs_device
		if [ "$i" -lt 1 ]; then
			echo_date "USB2JFFS: usb2jffs_restore.sh 运行超时！"
			rm -rf /tmp/usb2jffs_restore.sh
			exit 1
		fi
		sleep 1
	done

	echo_date "USB2JFFS: 检测到/jffs被系统卸载了！"

	# 恢复jffs分区原始挂载方式
	echo_date "USB2JFFS：重新挂载${mtd_disk}到/jffs..."
	mount -t jffs2 -o rw,noatime ${mtd_disk} /jffs
	if [ "$?" == "0" ]; then
		echo_date "USB2JFFS：重新挂载${mtd_disk}到/jffs成功！"
		echo_date "USB2JFFS：开启软件中心！"
		start_software_center
	else
		echo_date "USB2JFFS：重新挂载${mtd_disk}到/jffs失败！退出！"
	fi

	# 自毁
	rm -rf /tmp/usb2jffs_restore.sh
}



start | tee -a ${LOG_FILE}
