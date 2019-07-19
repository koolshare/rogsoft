#!/bin/sh

alias echo_date='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export swap_`
mkdir -p /tmp/upload
echo "" > /tmp/upload/swap_log.txt
http_response "$1"

make_swap(){
	echo_date "开始创建虚拟内存，此过程时间可能较长，请一定耐心等待！"
	dd if=/dev/zero of=/tmp/mnt/$swap_make_part_partname/swapfile bs=1024 count="$swap_size"
	mkswap /tmp/mnt/$swap_make_part_partname/swapfile
	chmod 0600 /tmp/mnt/$swap_make_part_partname/swapfile
	swapon /tmp/mnt/$swap_make_part_partname/swapfile
	if [ "$?" == "0" ];then
		echo_date "创建完毕并成功挂载！"
		dbus set swap_auto_mount=/tmp/mnt/$swap_make_part_partname/swapfile
	else
		echo_date "创建完毕，但是挂载失败！请刷新本页后重新尝试创建虚拟内存！！"
		rm -rf /tmp/mnt/$swap_make_part_partname/swapfile
		dbus remove swap_auto_mount
		echo XU6J03M6
		exit
	fi
}

start_make(){
	# 检测是否已经挂载
	SWAPSTATUS=`free|grep Swap|awk '{print $2}'`
	if [ "$SWAPSTATUS" != "0" ];then
		echo_date "发现当前系统下已经挂载了虚拟内存！！"
		echo_date "如果你需要重新制作虚拟内存，请删除原来的虚拟内存文件！"
		echo XU6J03M6
		exit
	fi
	# 卸载磁盘
	echo_date "你选择了$swap_make_part_partname分区，该分区挂载点为$swap_make_part_mount分区,格式为$swap_make_part_format"
	FORMAT=`echo $swap_make_part_format|grep ext`
	if [ -n "$FORMAT" ];then
		echo_date "你要创建虚拟内存的磁盘分区是$swap_make_part_format格式，符合要求~"
		if [ -f /tmp/mnt/$swap_make_part_partname/swapfile ];then
			echo_date "发现该分区下已经有虚拟内存文件swapfile了，将尝试用其进行挂载。"
			swapon /tmp/mnt/$swap_make_part_partname/swapfile
			if [ "$?" == "0" ];then
				echo_date "成功挂载！"
				dbus set swap_auto_mount=/tmp/mnt/$swap_make_part_partname/swapfile
				echo XU6J03M6
				exit
			else
				echo_date "挂载失败！"
				rm -rf /tmp/mnt/$swap_make_part_partname/swapfile
				dbus remove swap_auto_mount
				echo_date "删除有问题的虚拟内存文件，尝试重新制作！"
				make_swap
			fi
		else
			echo_date "开始创建虚拟内存到/tmp/mnt/$swap_make_part_partname/swapfile"
			make_swap
		fi
	else
		echo_date "你要创建虚拟内存的磁盘分区是$swap_make_part_format格式，不符合要求，将尝试转换格式！"
		echo_date "先卸载磁盘/tmp/mnt/$swap_make_part_partname"
		#umount /tmp/mnt/$swap_make_part_partname
		ejusb $swap_diskorder
		if [ "$?" == "0" ];then
			echo_date "卸载成功，尝试将磁盘格式化为ext3格式，磁盘内的数据将会全部丢失！"
			mkfs.ext3 -F /dev/$swap_make_part_mount
			sleep 1
			echo_date "格式化完成，尝试重新挂载磁盘"
			mkdir -p /tmp/mnt/$swap_make_part_mount
			mount /dev/$swap_make_part_mount /tmp/mnt/$swap_make_part_mount
			if [ "$?" == "0" ];then
				echo_date "重新挂载磁盘成功，"
				make_swap
			else
				echo_date "重新挂载磁盘失败，本插件已经不知道怎么办了，请检查下你的U盘！！"
				echo XU6J03M6
				exit
			fi
		else
			echo_date "卸载失败，可能是磁盘正在被系统所使用！"
			echo_date "请尝试拔出磁盘后重新插入，然后再次尝试！"
			echo XU6J03M6
			exit
		fi
	fi
	echo_date "日志窗口将在10秒内自动关闭，鼠标点击日志窗口将停止倒计时~"
	echo XU6J03M6
}

start_del(){
	echo_date "停止虚拟内存"
	swapoff $swap_auto_mount
	echo_date "删除虚拟内存"
	rm -rf $swap_auto_mount
	sleep 1
	dbus remove swap_auto_mount
	echo_date "完成！"
	echo XU6J03M6
}

case $2 in
1)
	sleep 1
	start_make >> /tmp/upload/swap_log.txt
	;;

2)
	sleep 1
	start_del >> /tmp/upload/swap_log.txt
	;;
esac
