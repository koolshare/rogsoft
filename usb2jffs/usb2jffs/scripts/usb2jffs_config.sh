#!/bin/sh

source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】'
eval $(dbus export usb2jffs_)
LOG_FILE=/tmp/upload/usb2jffs_log.txt
R_LIMIT=20
W_LIMIT=35
KSPATH=${usb2jffs_mount_path}
true > $LOG_FILE
http_response "$1"

stop_software_center(){
	killall skipd >/dev/null 2>&1
	/koolshare/perp/perp.sh stop >/dev/null 2>&1
}

start_software_center(){
	killall skipd >/dev/null 2>&1
	/koolshare/perp/perp.sh stop >/dev/null 2>&1
	service start_skipd >/dev/null 2>&1
	/koolshare/perp/perp.sh start >/dev/null 2>&1
}

get_current_jffs_device(){
	local cur_patition=$(df -h | grep /jffs |awk '{print $1}')
	if [ -n "$cur_patition" ];then
		jffs_device=$cur_patition
		return 0
	else
		jffs_device=""
		return 1
	fi
}

get_current_usb_device(){
	local cur_patition=$(df -h | grep ${KSPATH} |awk '{print $1}')
	if [ -n "$cur_patition" ];then
		usb_device=$cur_patition
		return 0
	else
		usb_device=""
		return 1
	fi
}

get_jffs_original_mount_device(){
	# 查看原始JFFS分区是用FLASH里的哪个分区挂载的
	local mtd_jffs=$(df -h | grep -E "/jffs|cifs2" | awk '{print $1}' | grep "/dev/mtd")
	if [ -n "$mtd_jffs" ];then
		# 没有载了USB jffs的时候，可以获取到
		mtd_disk="$mtd_jffs"
		dbus set usb2jffs_mtd_jffs="$mtd_jffs"
		return 0
	else
		# 防止意外
		local model=$(nvram get productid)
		case $model in
			RT-AC86U|GT-AC5300)
				mtd_disk="/dev/mtdblock8"
				return 0
				;;
			RT-AX88U|GT-AX11000|TUF-AX3000)
				mtd_disk="/dev/mtdblock9"
				return 0
				;;
			RT-AC5300)
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
	time sh -c "time dd if=/dev/zero of=${KSPATH}/write bs=1M count=50 && sync" >/tmp/upload/usb_write_speed_${1}.txt 2>&1
	rm -rf ${KSPATH}/write >/dev/null 2>&1
	sleep 1
}

speed_test(){
	# 参考：RT-AX88U的FLASH读取速度大约10MB/s, 写入速度大约30MB/s
	get_current_usb_device
	if [ -z "${usb_device}" ]; then
		echo_date "无法找到USB设备！退出速度测试！"
		return 1
	fi
	
	echo_date "USB2JFFS插件将对你的磁盘读写速度进行测试！"
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


	if [ "${speed_r_int}" -gt "${R_LIMIT}" -a "${speed_w_int}" -gt "${W_LIMIT}" ]; then
		echo_date "USB磁盘[${usb_device}]的读写速度符合USB2JFFS插件要求！"
		#echo_date "此测试速度和USB磁盘实际速度可能有一定差别，以上读写速度仅供参考！"
		#echo_date "在同等测试条件下，RT-AC86U, RT-AX88U等机型的flash读为10MB/s, 写为30MB/s"
		return 0
	else
		echo_date "USB磁盘[${usb_device}]的读写速度太低，不符合插件要求！"
		echo_date "USB2JFFS插件要求USB磁盘设备读取不低于${R_LIMIT}MB/s, 写入速度不低于为${W_LIMIT}MB/s"
		echo_date "此测试速度和USB磁盘实际速度可能有一定差别，以上读写速度仅供参考！"
		echo_date "在同等测试条件下，RT-AC86U, RT-AX88U等机型的flash读为10MB/s, 写为30MB/s"
		echo_date "如果你的USB磁盘读写速度较低，使用本插件将会得到更差的实际体验！"
		return 1
	fi
}

start_usb2jffs(){
	# 判断软件中心版本
	if [ -f "/koolshare/.soft_ver" ];then
		local CUR_VERSION=$(cat /koolshare/.soft_ver)
	else
		local CUR_VERSION="0"
	fi
	NEED_VERSION="1.5.4"
	COMP=$(/rom/etc/koolshare/bin/versioncmp $CUR_VERSION $NEED_VERSION )
	if [ "$COMP" == "1" ]; then
		echo_date "软件中心版本：$CUR_VERSION，版本号过低，不支持本插件，请将软件中心更新到最新后重试！" 
		return 1
	fi
	
	if [ -z "${KSPATH}" ]; then
		echo_date "发生错误，无法获取到USB分区名！请重启路由器后重试！"
	fi

	get_jffs_original_mount_device
	if [ -z "$mtd_disk" ]; then
		echo_date "无法找到原始/jffs挂载设备！请重启后重试！"
		return 1
	fi

	echo_date "开启USB2JFFS服务！请不要在此期间拔掉U盘！！" 
	if [ -d "${KSPATH}/.koolshare_jffs" ]; then
		echo_date "找到${KSPATH}/.koolshare_jffs！"
		echo_date "发现你以前使用本插件挂载过USB型JFFS分区！"
		echo_date "将为你重新挂载！"
	else
		# 先测速
		speed_test
		if [ "$?" != "0" ]; then
			echo_date "请更换速度更快的USB磁盘后重新尝试！"
			return 1
		fi
		echo_date "将/jffs目录下的所有文件复制到：${KSPATH}/.koolshare_jffs"
		cp -a /jffs/ ${KSPATH}/.koolshare_jffs
		echo_date "即将开始挂载操作，接下来日志会丢失，请等待日志恢复！"
		sleep 5
	fi
	
	echo_date "停止软件中心相关进程！"
	stop_software_center
	
	echo_date "卸载JFFS分区..."
	umount -l /jffs
	
	echo_date "将${KSPATH}/.koolshare_jffs挂载到JFFS分区..."
	mount -o rbind ${KSPATH}/.koolshare_jffs /jffs
	if [ "$?" == "0" ]; then
		echo_date "USB型JFFS分区挂载成功！"
		echo_date "重启软件中心相关进程..."
		start_software_center
		
		# 在系统nvram中写入一个值，如果检测不到该值，则说明用户重置了路由器，如果此时又安装了本插件再次手动挂载
		# 则需要删除${KSPATH}/.koolshare_jffs/nvram文件夹下相关内容（此操作由M01KsUSB进行），避免重置路由无用
		nvram set usb2jffs_flag=1
		nvram commit

		# 移除标记flag
		rm -rf ${KSPATH}/.koolshare_jffs/.usb2jffs_flag
	
		# 把原来的jffs分区挂载到cifs2
		echo_date "将$mtd_disk挂载在/cifs2"
		mount -t jffs2 -o rw,noatime $mtd_disk /cifs2
		if [ "$?" == "0" ]; then
			echo_date "/cifs2挂载成功！"
		else
			echo_date "/cifs2挂载失败，将无法使用同步功能！！"
		fi
		set_stop_sync
		set_sync_job
		echo_date "完成！"
	else
		echo_date "USB型JFFS挂载失败！！"
		echo_date "尝试恢复原始挂载方式！"
		mount -t jffs2 -o rw,noatime $mtd_disk /jffs
		if [ "$?" == "0" ]; then
			echo_date "已经恢复到原始挂载方式！"
			echo_date "重启软件中心！！"
			start_software_center
		else
			echo_date "恢复原始挂载方式失败，请重启路由器后重试！"
		fi
	fi
	sync
}

stop_usb2jffs(){
	local delete_flag=$1
	sync
	
	echo_date "获取原始JFFS挂载设备..."
	get_jffs_original_mount_device
	if [ -z "$mtd_disk" ]; then
		echo_date "无法找到原始JFFS挂载设备！请重启后重试！"
		return 1
	else
		echo_date "成功！原始JFFS挂载设备：$mtd_disk"
	fi

	# 检测是否有USB磁盘挂载在/jffs上
	get_current_jffs_device
	local mounted_nu=$(mount | grep "${jffs_device}" | grep -c "/dev/s")
	if [ "$mounted_nu" -gt "1" ]; then
		local usb_path=$(mount | grep "${jffs_device}" | grep "/tmp/mnt/" | awk '{print $3}')
		echo_date "检测到USB磁盘的${usb_path}/.koolshare_jffs挂载在/jffs上"
	else
		echo_date "没有检测到任何挂载在/jffs上的USB磁盘设备！"
		return 1
	fi
	
	echo_date "开始关闭USB2JFFS服务！"
	echo_date "停止软件中心相关进程！"
	stop_software_center

	echo_date "卸载/cifs2..."
	umount -l /cifs2
	if [ "$?" == "0" ]; then
		echo_date "/cifs2卸载成功..."
	else
		echo_date "/cifs2卸载失败！请重启路由器后重试！！"
		return 1
	fi
	
	echo_date "卸载/jffs..."
	umount -l /jffs
	if [ "$?" == "0" ]; then
		echo_date "/jffs卸载成功..."
		echo_date "将文件系统$mtd_disk挂载到jffs分区..."
		mount -t jffs2 -o rw,noatime $mtd_disk /jffs
		if [ "$?" == "0" ]; then
			echo_date "$mtd_disk → /jffs挂载成功！"
			echo_date "重启软件中心相关进程..."
			start_software_center

			# 删除usb2jffs_flag nvram值
			nvram unset usb2jffs_flag
			nvram commit

			if [ "$delete_flag" == "1" ]; then
				rm -rf ${usb_path}/.koolshare_jffs
				echo_date "成功卸载并恢复原始jffs挂载方式，并且删除了${usb_path}/.koolshare_jffs文件夹！"
			else
				# {usb_path}/.koolshare_jffs下写入一个标记文件
				# 因为是用户点击了卸载按钮，所以用户暂时不需要USB替换jffs
				# 那么开机启动的时候通过该标识符判断是否要挂在
				echo 0 > ${usb_path}/.koolshare_jffs/.usb2jffs_flag
				echo_date "成功卸载并恢复原始jffs挂载方式！"
			fi
		else
			echo_date "/jffs分区挂载失败！请重启后再试！"
		fi
	else
		echo_date "/jffs卸载失败！请重启后再试！"
	fi
	sync
}

sync_usb_mtd(){
	# 检测是否有USB磁盘挂载在/jffs上
	get_current_jffs_device
	local mounted_nu=$(mount | grep "${jffs_device}" | grep -c "/dev/s")
	if [ "$mounted_nu" -gt "1" ]; then
		local usb_path=$(mount | grep "${jffs_device}" | grep "/tmp/mnt/" | awk '{print $3}')
		#echo_date "检测到USB磁盘的${usb_path}/.koolshare_jffs挂载在/jffs上"
	else
		echo_date "没有检测到任何挂载在/jffs上的USB磁盘设备！"
		return 1
	fi
	
	# 检测cifs2是否有设备挂载，则可以开始复制
	local status_cifs=$(df -h|grep jffs|grep "/dev/s")
	if [ -z "$status_cifs" ]; then
		echo_date "cifs2未挂载！文件同步无法进行！请重启路由器后重试！"
		return 1
	fi

	# 获取jffs原始设备
	get_jffs_original_mount_device
	if [ -z "$mtd_disk" ]; then
		echo_date "无法找到原始/jffs挂载设备！请重启后重试！"
		return 1
	fi

	# 检查cifs2是否挂载
	local cifs2_device=$(df -h|grep cifs2|awk '{print $1}' 2>&1)
	if [ -z "${cifs2_device}" -o "${cifs2_device}" != "${mtd_disk}" ]; then
		echo_date "/cifs2未挂载！文件同步无法进行，请重启路由器后重试！"
		return 1
	fi

	# 检测jffs分区剩余空间...
	local TOTAL_MTD_SIZE=$(df|grep cifs2 | awk '{print $2}')
	local SPACE_USB_JFFS=$(du -s ${usb_path}/.koolshare_jffs/ | awk '{print $1}')
	if [ "${TOTAL_MTD_SIZE}" -gt "${SPACE_USB_JFFS}" ];then
		# echo_date "空间满足，继续下一步！"
		# 文件夹同步
		# ls 找出所有的目录，写入文件
		ls -aelR /jffs/|grep -i "^/"|sed 's/:$//g'|sed 's/^\/jffs\///g'|sed '/^$/d' > /tmp/upload/jffs_folders.txt
		ls -aelR /cifs2/|grep -i "^/"|sed 's/:$//g'|sed 's/^\/cifs2\///g'|sed '/^$/d' > /tmp/upload/cifs2_folders.txt
		# 文件同步
		# find 找出/jffs下所有的文件+目录，ls列出来后，只取文件的名字，写入文件（因为固件不支持-type f，只能这么搞了）
		find /jffs -exec ls -ael {} \;|sed '/^d/d'|awk '{print $11}'|sed '/^\//!d'|sed 's/^\/jffs\///g'|sed '/^$/d'|sort > /tmp/upload/jffs_files.txt
		find /cifs2 -exec ls -ael {} \;|sed '/^d/d'|awk '{print $11}'|sed '/^\//!d'|sed 's/^\/cifs2\///g'|sed '/^$/d'|sort > /tmp/upload/cifs2_files.txt
		
	else
		echo_date "${mtd_disk}总容量为：${TOTAL_MTD_SIZE}KB, USB磁盘中.koolshare_jffs文件夹大小：${SPACE_USB_JFFS}KB"
		echo_date "${mtd_disk}空间容量不够，只进行系统相关文件的同步，软件中心和插件文件不进行同步！"
		# 文件夹同步
		# ls 找出所有的目录，写入文件
		ls -aelR /jffs/|grep -i "^/"|sed 's/:$//g'|sed 's/^\/jffs\///g'|sed '/^$/d'|sed '/koolshare/d'|sed '/dnsmasq.d/d'|sort > /tmp/upload/jffs_folders.txt
		ls -aelR /cifs2/|grep -i "^/"|sed 's/:$//g'|sed 's/^\/cifs2\///g'|sed '/^$/d'|sed '/koolshare/d'|sed '/dnsmasq.d/d'|sort > /tmp/upload/cifs2_folders.txt
		# 文件同步
		# find 找出/jffs下所有的文件+目录，ls列出来后，只取文件的名字，写入文件（因为固件不支持-type f，只能这么搞了）
		find /jffs -exec ls -ael {} \;|sed '/^d/d'|awk '{print $11}'|sed '/^\//!d'|sed 's/^\/jffs\///g'|sed '/^$/d'|sed '/koolshare/d'|sed '/dnsmasq.d/d'|sort > /tmp/upload/jffs_files.txt
		find /cifs2 -exec ls -ael {} \;|sed '/^d/d'|awk '{print $11}'|sed '/^\//!d'|sed 's/^\/cifs2\///g'|sed '/^$/d'|sed '/koolshare/d'|sed '/dnsmasq.d/d'|sort > /tmp/upload/cifs2_files.txt
	fi
	# 开始同步
	echo_date "文件同步：USB_JFFS → MTD_JFFS！（/jffs → /cifs2）"
	if [ -s /tmp/upload/cifs2_folders.txt -a -s /tmp/upload/jffs_folders.txt ]; then
		# /cifs2和/jffs下都有目录的情况下
		# MTD_JFFS目录下独有的目录
		local mtd_uniq_folders=$(awk 'NR==FNR{a[$1]=$1} NR>FNR{if(a[$1] == ""){print $1}}' /tmp/upload/jffs_folders.txt /tmp/upload/cifs2_folders.txt)
		for mtd_uniq_folder in ${mtd_uniq_folders}; do
			echo_date "删除文件夹：${mtd_uniq_folder}"
			rm -rf /cifs2/${mtd_uniq_folder}
		done
	
		# USB_JFFS目录下独有的目录
		local usb_uniq_folders=$(awk 'NR==FNR{a[$1]=$1} NR>FNR{if(a[$1] == ""){print $1}}' /tmp/upload/cifs2_folders.txt /tmp/upload/jffs_folders.txt)
		for usb_uniq_folder in ${usb_uniq_folders}; do
			echo_date "添加文件夹：${usb_uniq_folder}"
			mkdir -p /cifs2/${usb_uniq_folder}
		done
	elif [ ! -s /tmp/upload/cifs2_folders.txt -a -s /tmp/upload/jffs_folders.txt ]; then
		# CIFS2下没有任何目录，USB_JFFS所有目录都是独有的
		local usb_uniq_folders=$(cat /tmp/upload/jffs_folders.txt)
		for usb_uniq_folder in ${usb_uniq_folders}; do
			echo_date "添加文件夹：${usb_uniq_folder}"
			mkdir -p /cifs2/${usb_uniq_folder}
		done
	else
		echo_date "文件同步：未知错误，请重启或者格式化USB磁盘后重试！"
		return 1
	fi		
	
	# MTD_JFFS目录下独有的文件
	local mtd_uniq_files=$(awk 'NR==FNR{a[$1]=$1} NR>FNR{if(a[$1] == ""){print $1}}' /tmp/upload/jffs_files.txt /tmp/upload/cifs2_files.txt)
	for mtd_uniq_file in ${mtd_uniq_files}; do
		#echo_date "在MTD_JFFS中移除USB_JFFS中删除掉的文件：${mtd_uniq_file}"
		echo_date "删除文件：${mtd_uniq_file}"
		rm -rf /cifs2/${mtd_uniq_file}
	done

	# USB_JFFS目录下独有的文件
	local usb_uniq_files=$(awk 'NR==FNR{a[$1]=$1} NR>FNR{if(a[$1] == ""){print $1}}' /tmp/upload/cifs2_files.txt /tmp/upload/jffs_files.txt)
	for usb_uniq_file in ${usb_uniq_files}; do
		#echo_date "在MTD_JFFS中添加USB_JFFS中新增加的文件：${usb_uniq_file}"
		echo_date "添加文件：${usb_uniq_file}"
		cp -af /jffs/${usb_uniq_file} /cifs2/${usb_uniq_file}
	done

	# 更新变化的文件
	# 1. × 使用时间戳，在生成文件列表的时候附带生成时间戳，用以判断文件是否变化，但是实际测试但是很不准，但是可以告知用户哪些文件变化了
	# 2. √ 使用md5sum，每个文件都要比较，非常消耗！！但是这个至少比较准确，可以告知用户那些文件变化了
	local FILES=$(cat /tmp/upload/jffs_files.txt)
	for FILE in $FILES
	do
		USB_MD5=$(md5sum /jffs/$FILE | awk '{print $1}' 2>/dev/null)
		MTD_MD5=$(md5sum /cifs2/$FILE | awk '{print $1}' 2>/dev/null)
		if [ "$USB_MD5" != "$MTD_MD5" ];then
			#echo_date "在MTD_JFFS中更新USB_JFFS中较新的文件：$FILE"
			echo_date "更新文件：$FILE"
			cp -af /jffs/$FILE /cifs2/$FILE
		fi
	done

	rm -rf /tmp/upload/jffs_folders.txt
	rm -rf /tmp/upload/cifs2_folders.txt
	rm -rf /tmp/upload/jffs_files.txt
	rm -rf /tmp/upload/cifs2_files.txt
	sync
}

del_sync_job(){
	if [ -n "$(cru l|grep usb2jffs_sync)" ]; then
		echo_date "删除插件定时同步任务..."
		sed -i '/usb2jffs_sync/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}

set_sync_job(){
	if [ "${usb2jffs_sync}" == "0" ]; then
		echo_date "删除插件定时同步任务..."
		sed -i '/usb2jffs_sync/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	elif [ "${usb2jffs_sync}" == "1" ]; then
		echo_date "设置每天${usb2jffs_time_hour}时${usb2jffs_time_min}分同步文件..."
		cru a usb2jffs_sync ${usb2jffs_time_min} ${usb2jffs_time_hour}" * * * sh /koolshare/scripts/usb2jffs_config.sh sync"
	elif [ "${usb2jffs_sync}" == "2" ]; then
		echo_date "设置每周${usb2jffs_week}的${usb2jffs_time_hour}时${usb2jffs_time_min}分同步文件..."
		cru a usb2jffs_sync ${usb2jffs_time_min} ${usb2jffs_time_hour}" * * "${usb2jffs_week}" sh /koolshare/scripts/usb2jffs_config.sh sync"
	elif [ "${usb2jffs_sync}" == "3" ]; then
		echo_date "设置每月${usb2jffs_day}日${usb2jffs_time_hour}时${usb2jffs_time_min}分同步文件..."
		cru a usb2jffs_sync ${usb2jffs_time_min} ${usb2jffs_time_hour} ${usb2jffs_day}" * * sh /koolshare/scripts/usb2jffs_config.sh sync"
	elif [ "${usb2jffs_sync}" == "4" ]; then
		if [ "${usb2jffs_inter_pre}" == "1" ]; then
			echo_date "设置每隔${usb2jffs_inter_min}分钟同步文件..."
			cru a usb2jffs_sync "*/"${usb2jffs_inter_min}" * * * * sh /koolshare/scripts/usb2jffs_config.sh sync"
		elif [ "${usb2jffs_inter_pre}" == "2" ]; then
			echo_date "设置每隔${usb2jffs_inter_hour}小时同步文件..."
			cru a usb2jffs_sync "0 */"${usb2jffs_inter_hour}" * * * sh /koolshare/scripts/usb2jffs_config.sh sync"
		elif [ "${usb2jffs_inter_pre}" == "3" ]; then
			echo_date "设置每隔${usb2jffs_inter_day}天${usb2jffs_inter_hour}小时${usb2jffs_time_min}分钟同步文件..."
			cru a usb2jffs_sync ${usb2jffs_time_min} ${usb2jffs_time_hour}" */"${usb2jffs_inter_day} " * * sh /koolshare/scripts/usb2jffs_config.sh sync"
		fi
	elif [[ "${usb2jffs_sync}" == "5" ]]; then
		check_custom_time=`dbus get usb2jffs_custom | base64_decode`
		echo_date "设置每天${check_custom_time}时的${usb2jffs_time_min}分同步文件..."
		cru a usb2jffs_sync ${usb2jffs_time_min} ${check_custom_time}" * * * sh /koolshare/scripts/usb2jffs_config.sh sync"
	fi
}

set_stop_sync(){
	if [ "$usb2jffs_rsync" == "1" ];then
		echo_date "设置卸载/删除时同步文件..."
	else
		echo_date "设置卸载/删除时不同步文件..."
	fi
}

# by crontab
case $1 in
sync)
	sync_usb_mtd | tee -a $LOG_FILE
	;;
esac

# by web
case $2 in
1)
	# 挂载
	echo_date "========================= USB2JFFS - 手动挂载 ========================" | tee -a $LOG_FILE
	start_usb2jffs | tee -a $LOG_FILE
	echo_date "========================= USB2JFFS - 运行完成 ========================" | tee -a $LOG_FILE
	echo "XU6J03M6" >> $LOG_FILE
	;;
2)
	# 卸载
	echo_date "========================= USB2JFFS - 手动卸载 ========================" | tee -a $LOG_FILE
	if [ "$usb2jffs_rsync" == "1" ];then
		echo_date "卸载前先同步一次文件..." | tee -a $LOG_FILE
		sync_usb_mtd | tee -a $LOG_FILE
		echo_date "----------------------------------------------------------------------" | tee -a $LOG_FILE
	fi
	stop_usb2jffs | tee -a $LOG_FILE
	del_sync_job | tee -a $LOG_FILE
	echo_date "========================= USB2JFFS - 运行完成 ========================" | tee -a $LOG_FILE
	echo "XU6J03M6" | tee -a $LOG_FILE
	;;
3)
	# 删除
	echo_date "========================= USB2JFFS - 手动删除 ========================" | tee -a $LOG_FILE
	if [ "$usb2jffs_rsync" == "1" ];then
		echo_date "删除前先同步一次文件..." | tee -a $LOG_FILE
		sync_usb_mtd | tee -a $LOG_FILE
		echo_date "----------------------------------------------------------------------" | tee -a $LOG_FILE
	fi
	stop_usb2jffs 1 | tee -a $LOG_FILE
	del_sync_job | tee -a $LOG_FILE
	echo_date "========================= USB2JFFS - 运行完成 ========================" | tee -a $LOG_FILE
	echo "XU6J03M6" >> $LOG_FILE
	;;
4)
	# 清理日志
	echo "XU6J03M6" >> $LOG_FILE
	;;
5)
	# 同步
	echo_date "========================= USB2JFFS - 手动同步 ========================" | tee -a $LOG_FILE
	sync_usb_mtd | tee -a $LOG_FILE
	echo_date "========================= USB2JFFS - 运行完成 ========================" | tee -a $LOG_FILE
	echo "XU6J03M6" >> $LOG_FILE
	;;
6)
	# 设定定时同步
	echo_date "========================= USB2JFFS - 定时设定 ========================" | tee -a $LOG_FILE
	set_sync_job | tee -a $LOG_FILE
	echo_date "========================= USB2JFFS - 设定完成 ========================" | tee -a $LOG_FILE
	echo "XU6J03M6" >> $LOG_FILE
	;;
7)
	# 设定是否卸载/删除时同步
	echo_date "========================= USB2JFFS - 同步设定 ========================" | tee -a $LOG_FILE
	set_stop_sync | tee -a $LOG_FILE
	echo_date "========================= USB2JFFS - 设定完成 ========================" | tee -a $LOG_FILE
	echo "XU6J03M6" >> $LOG_FILE
	;;
esac

