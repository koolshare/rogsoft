#!/bin/sh

source /koolshare/scripts/base.sh
eval $(dbus export usb2jffs_)

get_current_jffs_status(){
	local cur_patition=$(df -h | /bin/grep /jffs)
	if [ -n "${cur_patition}" ];then
		local used=$(echo ${cur_patition} | awk '{print $3}')
		local total=$(echo ${cur_patition} | awk '{print $2}')
		echo "${used}&nbsp;/&nbsp;${total}"
	else
		echo "jffs分区未挂载！"
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

start(){
	get_current_jffs_device
	local mounted_nu=$(mount | /bin/grep "${jffs_device}" | grep -E "/tmp/mnt/|/jffs"|/bin/grep -c "/dev/s")
	if [ "${mounted_nu}" -eq "2" ]; then
		local usb_path=$(mount | /bin/grep "${jffs_device}" | /bin/grep "/tmp/mnt/" | awk '{print $3}')
		http_response "$(get_current_jffs_status)@@jffs挂载路径：<em>${usb_path}/.koolshare_jffs → /jffs</em>@@1"
	else
		if [ -d "${usb2jffs_mount_path}/.koolshare_jffs" ];then
			if [ -f "${usb2jffs_mount_path}/.koolshare_jffs/.usb2jffs_flag" ];then
				http_response "$(get_current_jffs_status)@@检测到USB磁盘：<em>${usb2jffs_mount_path}</em>中的<em>.koolshare_jffs</em>文件夹，但尚未挂载！<br />这是因为你上次进行过手动卸载操作，所以本次没有进行自动挂载！<br />点击下方<i>应用</i>按钮，可以重新将<em>.koolshare_jffs</em>文件夹挂载为/jffs。@@2"
			else
				http_response "$(get_current_jffs_status)@@检测到USB磁盘：<em>${usb2jffs_mount_path}</em>中的<em>.koolshare_jffs</em>文件夹，但尚未挂载！<br />这可能是开机自动挂载出现了问题，或者USB磁盘出现错误导致的！<br />点击下方<i>应用</i>按钮，可以尝试重新将<em>.koolshare_jffs</em>文件夹挂载为/jffs。@@2"
			fi
		else
			http_response "$(get_current_jffs_status)@@尚未挂载USB到jffs，需要创建！@@0"
		fi
	fi
}

start
