#!/bin/sh

alias echo_date='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval $(dbus export swap_)
R_LIMIT=20
W_LIMIT=30
mkdir -p /tmp/upload
LOG_FILE=/tmp/upload/swap_log.txt
true > $LOG_FILE
http_response "$1"

get_current_usb_device(){
	local cur_patition=$(df -h | grep "/tmp/mnt/${swap_make_part_partname}" |awk '{print $1}')
	if [ -n "$cur_patition" ];then
		usb_device=$cur_patition
		return 0
	else
		usb_device=""
		return 1
	fi
}

read_speed(){
	echo_date "USB磁盘读取速度测试：第${1}次..."
	sync
	echo 3 > /proc/sys/vm/drop_caches
	time sh -c "time dd if=${usb_device} of=/dev/null bs=1M count=50 && sync" >/tmp/upload/usb_read_speed_${1}.txt 2>&1
	sleep 1
}

write_speed(){
	echo_date "USB磁盘写入速度测试：第${1}次..."
	sync
	echo 3 > /proc/sys/vm/drop_caches
	time sh -c "time dd if=/dev/zero of=/tmp/mnt/${swap_make_part_partname}/write bs=1M count=50 && sync" >/tmp/upload/usb_write_speed_${1}.txt 2>&1
	rm -rf /tmp/mnt/${swap_make_part_partname}/write >/dev/null 2>&1
	sleep 1
}

speed_test(){
	# 参考：RT-AX88U的FLASH读取速度大约10MB/s, 写入速度大约30MB/s
	get_current_usb_device
	if [ -z "${usb_device}" ]; then
		echo_date "无法找到USB设备！退出速度测试！"
		return 1
	fi
	
	echo_date "【虚拟内存】插件将对你的USB磁盘读写速度进行测试！"
	sleep 1
	
	read_speed 1
	read_speed 2
	read_speed 3
	echo_date "USB磁盘读取速度测试：完成！"
	local time_r1=$(cat /tmp/upload/usb_read_speed_1.txt|grep -i "^real"|sed '1d'|awk '{print $3}'|sed 's/s//g')
	local time_r2=$(cat /tmp/upload/usb_read_speed_2.txt|grep -i "^real"|sed '1d'|awk '{print $3}'|sed 's/s//g')
	local time_r3=$(cat /tmp/upload/usb_read_speed_3.txt|grep -i "^real"|sed '1d'|awk '{print $3}'|sed 's/s//g')
	local time_r=$(awk -v x=${time_r1} -v y=${time_r2} -v z=${time_r3} 'BEGIN {printf "%.2f\n",x+y+z}')
	local speed_r=$(awk -v x=150 -v y=${time_r} 'BEGIN {printf "%.2f\n",x/y}')
	local speed_r_int=$(echo ${speed_r} | awk '{print int($1)}')

	write_speed 1
	write_speed 2
	write_speed 3
	echo_date "USB磁盘写入速度测试：完成！"
	local time_w1=$(cat /tmp/upload/usb_write_speed_1.txt|grep -i "^real"|sed '1d'|awk '{print $3}'|sed 's/s//g')
	local time_w2=$(cat /tmp/upload/usb_write_speed_2.txt|grep -i "^real"|sed '1d'|awk '{print $3}'|sed 's/s//g')
	local time_w3=$(cat /tmp/upload/usb_write_speed_3.txt|grep -i "^real"|sed '1d'|awk '{print $3}'|sed 's/s//g')
	local time_w=$(awk -v x=${time_w1} -v y=${time_w2} -v z=${time_w3} 'BEGIN {printf "%.2f\n",x+y+z}')
	local speed_w=$(awk -v x=150 -v y=${time_w} 'BEGIN {printf "%.2f\n",x/y}')
	local speed_w_int=$(echo ${speed_w} | awk '{print int($1)}')

	echo_date "USB磁盘[${usb_device}]的三次平均顺序读取速度大约为：${speed_r} MB/s"
	echo_date "USB磁盘[${usb_device}]的三次平均顺序写入速度大约为：${speed_w} MB/s"

	rm -f /tmp/upload/usb_read_speed*.txt
	rm -f /tmp/upload/usb_write_speed*.txt


	if [ "${speed_r_int}" -ge "${R_LIMIT}" -a "${speed_w_int}" -ge "${W_LIMIT}" ]; then
		echo_date "USB磁盘[${usb_device}]的读写速度符合【虚拟内存】插件要求！"
		#echo_date "此测试速度和USB磁盘实际速度可能有一定差别，以上读写速度仅供参考！"
		#echo_date "在同等测试条件下，RT-AC86U, RT-AX88U等机型的flash读为10MB/s, 写为30MB/s"
		return 0
	else
		echo_date "USB磁盘[${usb_device}]的读写速度太低，不符合插件要求！"
		echo_date "【虚拟内存】插件要求USB磁盘设备读取不低于${R_LIMIT}MB/s, 写入速度不低于为${W_LIMIT}MB/s"
		echo_date "此测试速度和USB磁盘实际速度可能有一定差别，以上读写速度仅供参考！"
		echo_date "在同等测试条件下，RT-AC86U, RT-AX88U等机型的flash读为10MB/s, 写为30MB/s"
		echo_date "如果你的USB磁盘读写速度较低，使用本插件将会得到更差的实际体验！"
		echo_date "本次虚拟内存创建失败！！！请更换读写速度更好的USB磁盘后重试！"
		echo_date "退出！本次操作没有进行任何变更！"
		return 1
	fi
}

make_swap(){
	echo_date "开始创建虚拟内存，此过程时间可能较长，请一定耐心等待！"
	dd if=/dev/zero of=/tmp/mnt/${swap_make_part_partname}/swapfile bs=1024 count="$swap_size" >/dev/null 2>&1
	mkswap /tmp/mnt/${swap_make_part_partname}/swapfile >/dev/null 2>&1
	chmod 0600 /tmp/mnt/${swap_make_part_partname}/swapfile
	swapon /tmp/mnt/${swap_make_part_partname}/swapfile >/dev/null 2>&1
	if [ "$?" == "0" ];then
		echo_date "创建完毕并成功挂载！"
		dbus set swap_auto_mount=/tmp/mnt/${swap_make_part_partname}/swapfile
	else
		echo_date "创建完毕，但是挂载失败！请刷新本页后重新尝试创建虚拟内存！！"
		rm -rf /tmp/mnt/${swap_make_part_partname}/swapfile
		dbus remove swap_auto_mount
		echo XU6J03M6
		exit
	fi
}

start_make(){
	# 检测是否已经挂载
	SWAPSTATUS=$(free|grep Swap|awk '{print $2}')
	if [ "${SWAPSTATUS}" != "0" ];then
		echo_date "发现当前系统下已经挂载了虚拟内存！！"
		echo_date "如果你需要重新制作虚拟内存，请删除原来的虚拟内存文件！"
		echo XU6J03M6
		exit
	fi

	# 速度测试
	speed_test
	if [ "$?" != "0" ];then
		echo XU6J03M6
		exit 1
	fi
	
	# 卸载磁盘
	echo_date "你选择了${swap_make_part_partname}分区，该分区挂载点为${swap_make_part_mount}分区,格式为${swap_make_part_format}"
	FORMAT=$(echo ${swap_make_part_format}|grep ext)
	if [ -n "$FORMAT" ];then
		echo_date "你要创建虚拟内存的磁盘分区是${swap_make_part_format}格式，符合要求~"
		if [ -f /tmp/mnt/${swap_make_part_partname}/swapfile ];then
			echo_date "发现该分区下已经有虚拟内存文件swapfile了，将尝试用其进行挂载。"
			swapon /tmp/mnt/${swap_make_part_partname}/swapfile
			if [ "$?" == "0" ];then
				echo_date "成功挂载！"
				dbus set swap_auto_mount=/tmp/mnt/${swap_make_part_partname}/swapfile
				echo XU6J03M6
				exit
			else
				echo_date "挂载失败！"
				rm -rf /tmp/mnt/${swap_make_part_partname}/swapfile
				dbus remove swap_auto_mount
				echo_date "删除有问题的虚拟内存文件，尝试重新制作！"
				make_swap
			fi
		else
			echo_date "开始创建虚拟内存到/tmp/mnt/${swap_make_part_partname}/swapfile"
			make_swap
		fi
	else
		echo_date "你要创建虚拟内存的磁盘分区是${swap_make_part_format}格式，不符合要求，将尝试转换格式！"
		echo_date "先卸载磁盘/tmp/mnt/${swap_make_part_partname}"
		#umount /tmp/mnt/${swap_make_part_partname}
		ejusb ${swap_diskorder}
		if [ "$?" == "0" ];then
			echo_date "卸载成功，尝试将磁盘格式化为ext3格式，磁盘内的数据将会全部丢失！"
			mkfs.ext3 -F /dev/${swap_make_part_mount}
			sleep 1
			echo_date "格式化完成，尝试重新挂载磁盘"
			mkdir -p /tmp/mnt/${swap_make_part_mount}
			mount /dev/${swap_make_part_mount} /tmp/mnt/${swap_make_part_mount}
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
	swapoff ${swap_auto_mount}
	echo_date "删除虚拟内存"
	rm -rf ${swap_auto_mount}
	sleep 1
	dbus remove swap_auto_mount
	echo_date "完成！"
	echo XU6J03M6
}

case $2 in
1)
	sleep 1
	start_make | tee -a $LOG_FILE
	;;

2)
	sleep 1
	start_del | tee -a $LOG_FILE
	;;
esac
