#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

get_current_jffs_status(){
	local cur_patition=$(df -h | grep /jffs)
	if [ -n "$cur_patition" ];then
		local used=$(echo $cur_patition | awk '{print $3}')
		local total=$(echo $cur_patition | awk '{print $2}')
		echo "$used&nbsp;/&nbsp;$total"
	else
		echo "jffs分区未挂载！"
	fi
}

get_current_jffs_device(){
	local cur_patition=$(df -h | grep /jffs | awk '{print $1}')
	if [ -n "$cur_patition" ];then
		jffs_device=$cur_patition
		return 0
	else
		jffs_device=""
		return 1
	fi
}

start(){
	get_current_jffs_device
	local mounted_nu=$(mount | grep "${jffs_device}" | grep -c "/dev/s")
	local usb_path=$(mount | grep "${jffs_device}" | grep "/tmp/mnt/" | awk '{print $3}')
	if [ "$mounted_nu" -gt "1" ]; then
		http_response "$(get_current_jffs_status)@@jffs挂载路径：${usb_path}/.koolshare_jffs → /jffs@@1"
	else
		http_response "$(get_current_jffs_status)@@尚未挂载USB到jffs，需要创建！@@0"
	fi
}

start
