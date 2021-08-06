#!/bin/sh

source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
eval $(dbus export usb2jffs_)
LOG_FILE=/tmp/upload/usb2jffs_log.txt
R_LIMIT=20
W_LIMIT=30
KSPATH=${usb2jffs_mount_path}
true > ${LOG_FILE}

stop_software_center(){
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
	local cur_patition=$(df -h | /bin/grep /jffs | awk '{print $1}')
	if [ -n "${cur_patition}" ];then
		jffs_device=${cur_patition}
		return 0
	else
		jffs_device=""
		return 1
	fi
}

get_current_usb_device(){
	local cur_patition=$(df -h | /bin/grep ${KSPATH} | awk '{print $1}'| /bin/grep "/dev/s")
	if [ -n "${cur_patition}" ];then
		usb_device=${cur_patition}
		return 0
	else
		usb_device=""
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
		dbus set usb2jffs_mtd_jffs="${mtd_jffs}"
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
	local time_r1=$(cat /tmp/upload/usb_read_speed_1.txt|/bin/grep -i "^real"|sed '1d'|awk '{print $3}'|sed 's/s//g')
	local time_r2=$(cat /tmp/upload/usb_read_speed_2.txt|/bin/grep -i "^real"|sed '1d'|awk '{print $3}'|sed 's/s//g')
	local time_r3=$(cat /tmp/upload/usb_read_speed_3.txt|/bin/grep -i "^real"|sed '1d'|awk '{print $3}'|sed 's/s//g')
	local time_r=$(awk -v x=${time_r1} -v y=${time_r2} -v z=${time_r3} 'BEGIN {printf "%.2f\n",x+y+z}')
	local speed_r=$(awk -v x=150 -v y=${time_r} 'BEGIN {printf "%.2f\n",x/y}')
	local speed_r_int=$(echo ${speed_r} | awk '{print int($1)}')

	write_speed 1
	write_speed 2
	write_speed 3
	echo_date "USB磁盘写入速度测试：完成！"
	local time_w1=$(cat /tmp/upload/usb_write_speed_1.txt|/bin/grep -i "^real"|sed '1d'|awk '{print $3}'|sed 's/s//g')
	local time_w2=$(cat /tmp/upload/usb_write_speed_2.txt|/bin/grep -i "^real"|sed '1d'|awk '{print $3}'|sed 's/s//g')
	local time_w3=$(cat /tmp/upload/usb_write_speed_3.txt|/bin/grep -i "^real"|sed '1d'|awk '{print $3}'|sed 's/s//g')
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
		return 2
	fi
}

start_usb2jffs(){
	# 判断软件中心版本
	if [ -f "/koolshare/.soft_ver" ];then
		local CUR_VERSION=$(cat /koolshare/.soft_ver)
	else
		local CUR_VERSION="0"
	fi
	local NEED_VERSION="1.6.8"
	local COMP=$(/rom/etc/koolshare/bin/versioncmp ${CUR_VERSION} ${NEED_VERSION})
	if [ "${COMP}" == "1" ]; then
		echo_date "软件中心版本：${CUR_VERSION}，版本号过低，不支持本插件，请将软件中心更新到最新后重试！" 
		return 1
	fi
	
	if [ -z "${KSPATH}" ]; then
		echo_date "发生错误，无法获取到USB分区名！请重启路由器后重试！"
	fi

	get_jffs_original_mount_device
	if [ -z "${mtd_disk}" ]; then
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
		if [ "$?" == "1" ]; then
			echo_date "请检查你的USB磁盘是否正常挂载！"
			return 1
		elif [ "$?" == "2" ]; then
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
		echo_date "将${mtd_disk}挂载在/cifs2"
		mount -t jffs2 -o rw,noatime ${mtd_disk} /cifs2
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
		mount -t jffs2 -o rw,noatime ${mtd_disk} /jffs
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
	
	# 检测是否有USB磁盘挂载在/jffs上
	get_current_jffs_device
	local mounted_nu=$(mount | /bin/grep "${jffs_device}" | grep -E "/tmp/mnt/|/jffs"|/bin/grep -c "/dev/s")
	if [ "$mounted_nu" == "2" ]; then
		local usb_path=$(mount | /bin/grep "${jffs_device}" | /bin/grep "/tmp/mnt/" | awk '{print $3}')
		echo_date "检测到USB磁盘的${usb_path}/.koolshare_jffs挂载在/jffs上"
	else
		echo_date "没有检测到USB磁盘挂载在/jffs上！"
		if [ -d "${KSPATH}/.koolshare_jffs" ];then
			echo_date "但是检测到USB磁盘：${KSPATH}里的.koolshare_jffs文件夹！"
			echo_date "开始删除..."
			rm -rf ${KSPATH}/.koolshare_jffs
			if [ "$?" == "0" ]; then
				echo_date "删除成功..."
				return 0
			else
				echo_date "删除失败！请重启路由器后重试！"
				return 1
			fi
		else
			return 0
		fi
	fi

	if [ "$usb2jffs_rsync" == "1" ];then
		if [ "${delete_flag}" == "1" ];then
			echo_date "删除前先同步一次文件..."
		else
			echo_date "卸载前先同步一次文件..."
		fi
		sync_usb_mtd
		echo_date "----------------------------------------------------------------------"
	fi	

	echo_date "获取原始JFFS挂载设备..."
	get_jffs_original_mount_device
	if [ -z "${mtd_disk}" ]; then
		echo_date "无法找到原始JFFS挂载设备！请重启后重试！"
		return 1
	else
		echo_date "成功！原始JFFS挂载设备：${mtd_disk}"
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
		echo_date "将文件系统${mtd_disk}挂载到jffs分区..."
		mount -t jffs2 -o rw,noatime ${mtd_disk} /jffs
		if [ "$?" == "0" ]; then
			echo_date "${mtd_disk} → /jffs挂载成功！"
			echo_date "重启软件中心相关进程..."
			start_software_center

			# 删除usb2jffs_flag nvram值
			nvram unset usb2jffs_flag
			nvram commit

			if [ "${delete_flag}" == "1" ]; then
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

	del_sync_job
	
	sync
}

sync_usb_mtd(){
	# 检测是否有USB磁盘挂载在/jffs上
	get_current_jffs_device
	local mounted_nu=$(mount | /bin/grep "${jffs_device}" | grep -E "/tmp/mnt/|/jffs"|/bin/grep -c "/dev/s")
	if [ "${mounted_nu}" == "2" ]; then
		local usb_path=$(mount | /bin/grep "${jffs_device}" | /bin/grep "/tmp/mnt/" | awk '{print $3}')
		#echo_date "检测到USB磁盘的${usb_path}/.koolshare_jffs挂载在/jffs上"
	else
		echo_date "没有检测到任何挂载在/jffs上的USB磁盘设备！"
		return 1
	fi
	
	# 检测cifs2是否有设备挂载，则可以开始复制
	local status_cifs=$(df -h|/bin/grep jffs|/bin/grep "/dev/s")
	if [ -z "${status_cifs}" ]; then
		echo_date "cifs2未挂载！文件同步无法进行！请重启路由器后重试！"
		return 1
	fi

	# 获取jffs原始设备
	get_jffs_original_mount_device
	if [ -z "${mtd_disk}" ]; then
		echo_date "无法找到原始/jffs挂载设备！请重启后重试！"
		return 1
	fi

	# 检查cifs2是否挂载
	local cifs2_device=$(df -h|/bin/grep cifs2|awk '{print $1}' 2>&1)
	if [ -z "${cifs2_device}" -o "${cifs2_device}" != "${mtd_disk}" ]; then
		echo_date "/cifs2未挂载！文件同步无法进行，请重启路由器后重试！"
		return 1
	fi

	# 检测jffs分区剩余空间...
	# 预留3.5MB的空间，避免报错
	local SPARE_MTD_SIZE="3584"
	local TOTAL_MTD_SIZE=$(df|/bin/grep cifs2 | awk '{print $2}')
	local AVALI_MTD_SIZE=$((${TOTAL_MTD_SIZE} - ${SPARE_MTD_SIZE}))
	local TOTAL_USB_SIZE=$(du -s ${usb_path}/.koolshare_jffs/ | awk '{print $1}')

	rm -rf /tmp/upload/jffs_folders.txt
	rm -rf /tmp/upload/cifs2_folders.txt
	rm -rf /tmp/upload/jffs_files.txt
	rm -rf /tmp/upload/cifs2_files.txt

	sleep 1
	sync
	
	if [ "${AVALI_MTD_SIZE}" -gt "${TOTAL_USB_SIZE}" ];then
		# echo_date "空间满足，继续下一步！"
		# 文件夹同步
		# ls 找出所有的目录，ksware除外，写入文件
		ls -aelR /jffs/|/bin/grep -i "^/"|sed 's/:$//g'|sed 's/^\/jffs\///g'|sed '/^$/d'|sed '/ksware/d' > /tmp/upload/jffs_folders.txt
		ls -aelR /cifs2/|/bin/grep -i "^/"|sed 's/:$//g'|sed 's/^\/cifs2\///g'|sed '/^$/d'|sed '/ksware/d' > /tmp/upload/cifs2_folders.txt
		# 文件同步
		# /usr/bin/find 找出/jffs下所有的文件+目录，ksware除外，ls列出来后，只取文件的名字，写入文件（因为固件的find不支持-type f，只能这么搞了）
		/usr/bin/find /jffs -exec ls -ael {} \;|sed '/^d/d'|awk '{print $11}'|sed '/^\//!d'|sed 's/^\/jffs\///g'|sed '/^$/d'|sed '/ksware/d'|sort > /tmp/upload/jffs_files.txt
		/usr/bin/find /cifs2 -exec ls -ael {} \;|sed '/^d/d'|awk '{print $11}'|sed '/^\//!d'|sed 's/^\/cifs2\///g'|sed '/^$/d'|sed '/ksware/d'|sort > /tmp/upload/cifs2_files.txt
		
	else
		echo_date "${mtd_disk}总容量为：${TOTAL_MTD_SIZE}KB, USB磁盘中.koolshare_jffs文件夹大小：${TOTAL_USB_SIZE}KB"
		echo_date "${mtd_disk}空间容量不够，只进行系统相关文件的同步，软件中心和插件文件不进行同步！"
		# 文件夹同步
		# ls 找出所有的目录，ksware除外，写入文件
		ls -aelR /jffs/|/bin/grep -i "^/"|sed 's/:$//g'|sed 's/^\/jffs\///g'|sed '/^$/d'|sed '/koolshare/d'|sed '/dnsmasq.d/d'|sed '/^db$/d'|sed '/^ksdb$/d'|sed '/ksware/d'|sort > /tmp/upload/jffs_folders.txt
		ls -aelR /cifs2/|/bin/grep -i "^/"|sed 's/:$//g'|sed 's/^\/cifs2\///g'|sed '/^$/d'|sed '/koolshare/d'|sed '/dnsmasq.d/d'|sed '/^db$/d'|sed '/^ksdb$/d'|sed '/ksware/d'|sort > /tmp/upload/cifs2_folders.txt
		# 文件同步
		# /usr/bin/find 找出/jffs下所有的文件+目录，ksware除外，ls列出来后，只取文件的名字，写入文件（因为固件的find不支持-type f，只能这么搞了）
		/usr/bin/find /jffs -exec ls -ael {} \;|sed '/^d/d'|awk '{print $11}'|sed '/^\//!d'|sed 's/^\/jffs\///g'|sed '/^$/d'|sed '/koolshare/d'|sed '/dnsmasq.d/d'|sed '/^db\/log$/d'|sed '/^ksdb\/log$/d'|sed '/ksware/d'|sort > /tmp/upload/jffs_files.txt
		/usr/bin/find /cifs2 -exec ls -ael {} \;|sed '/^d/d'|awk '{print $11}'|sed '/^\//!d'|sed 's/^\/cifs2\///g'|sed '/^$/d'|sed '/koolshare/d'|sed '/dnsmasq.d/d'|sed '/^db\/log$/d'|sed '/^ksdb\/log$/d'|sed '/ksware/d'|sort > /tmp/upload/cifs2_files.txt
	fi
	# 开始同步
	echo_date "文件同步：USB_JFFS → MTD_JFFS！（/jffs → /cifs2）"
	if [ -s /tmp/upload/cifs2_folders.txt -a -s /tmp/upload/jffs_folders.txt ]; then
		# /cifs2和/jffs下都有目录的情况下
		# MTD_JFFS目录下独有的目录
		local mtd_uniq_folders=$(awk 'NR==FNR{a[$1]=$1} NR>FNR{if(a[$1] == ""){print $1}}' /tmp/upload/jffs_folders.txt /tmp/upload/cifs2_folders.txt)
		if [ -n "${mtd_uniq_folders}" ];then
			for mtd_uniq_folder in ${mtd_uniq_folders}; do
				echo_date "删除文件夹：${mtd_uniq_folder}"
				rm -rf /cifs2/${mtd_uniq_folder}
			done
		fi
	
		# USB_JFFS目录下独有的目录
		local usb_uniq_folders=$(awk 'NR==FNR{a[$1]=$1} NR>FNR{if(a[$1] == ""){print $1}}' /tmp/upload/cifs2_folders.txt /tmp/upload/jffs_folders.txt)
		if [ -n "${usb_uniq_folders}" ];then
			for usb_uniq_folder in ${usb_uniq_folders}; do
				echo_date "添加文件夹：${usb_uniq_folder}"
				mkdir -p /cifs2/${usb_uniq_folder}
			done
		fi
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
	if [ -n "${mtd_uniq_files}" ];then
		for mtd_uniq_file in ${mtd_uniq_files}; do
			#echo_date "在MTD_JFFS中移除USB_JFFS中删除掉的文件：${mtd_uniq_file}"
			echo_date "删除文件：${mtd_uniq_file}"
			rm -rf /cifs2/${mtd_uniq_file}
		done
	fi
	# USB_JFFS目录下独有的文件
	local usb_uniq_files=$(awk 'NR==FNR{a[$1]=$1} NR>FNR{if(a[$1] == ""){print $1}}' /tmp/upload/cifs2_files.txt /tmp/upload/jffs_files.txt)
	if [ -n "${usb_uniq_files}" ];then
		for usb_uniq_file in ${usb_uniq_files}; do
			#echo_date "在MTD_JFFS中添加USB_JFFS中新增加的文件：${usb_uniq_file}"
			echo_date "添加文件：${usb_uniq_file}"
			cp -af /jffs/${usb_uniq_file} /cifs2/${usb_uniq_file}
		done
	fi

	# 更新变化的文件
	# 1. × 使用时间戳，在生成文件列表的时候附带生成时间戳，用以判断文件是否变化，但是实际测试但是很不准，但是可以告知用户哪些文件变化了
	# 2. √ 使用md5sum，每个文件都要比较，非常消耗！！但是这个至少比较准确，可以告知用户那些文件变化了
	local FILES=$(cat /tmp/upload/jffs_files.txt)
	for FILE in ${FILES}
	do
		local USB_MD5=$(md5sum /jffs/${FILE} | awk '{print $1}' 2>/dev/null)
		local MTD_MD5=$(md5sum /cifs2/${FILE} | awk '{print $1}' 2>/dev/null)
		if [ "${USB_MD5}" != "${MTD_MD5}" ];then
			#echo_date "在MTD_JFFS中更新USB_JFFS中较新的文件：${FILE}"
			echo_date "更新文件：${FILE}"
			cp -af /jffs/${FILE} /cifs2/${FILE}
		fi
	done

	sync
}

del_sync_job(){
	if [ -n "$(cru l|/bin/grep usb2jffs_sync)" ]; then
		echo_date "删除插件定时同步任务..."
		sed -i '/usb2jffs_sync/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}

set_sync_job(){
	get_current_jffs_device
	local mounted_nu=$(mount | /bin/grep "${jffs_device}" | grep -E "/tmp/mnt/|/jffs"|/bin/grep -c "/dev/s")
	if [ "${mounted_nu}" == "2" ]; then
		local usb_path=$(mount | /bin/grep "${jffs_device}" | /bin/grep "/tmp/mnt/" | awk '{print $3}')
		#echo_date "检测到USB磁盘的${usb_path}/.koolshare_jffs挂载在/jffs上"
	else
		echo_date "没有检测到任何挂载在/jffs上的USB磁盘设备！"
		del_sync_job
		echo_date "退出定时同步设定！"
		return 1
	fi
	
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
	get_current_jffs_device
	local mounted_nu=$(mount | /bin/grep "${jffs_device}" | grep -E "/tmp/mnt/|/jffs"|/bin/grep -c "/dev/s")
	if [ "${mounted_nu}" == "2" ]; then
		local usb_path=$(mount | /bin/grep "${jffs_device}" | /bin/grep "/tmp/mnt/" | awk '{print $3}')
		#echo_date "检测到USB磁盘的${usb_path}/.koolshare_jffs挂载在/jffs上"
	else
		echo_date "没有检测到任何挂载在/jffs上的USB磁盘设备！退出！"
		echo_date "不进行【卸载/删除时同步】设定！退出！"
		dbus remove usb2jffs_rsync
		return 1
	fi

	if [ "${usb2jffs_rsync}" == "1" ];then
		echo_date "设置卸载/删除时同步文件..."
	else
		echo_date "设置卸载/删除时不同步文件..."
	fi
}

make_backup(){
	if [ -z "${KSPATH}" ]; then
		echo_date "尚未设置usb2jffs插件挂载路径，无法备份！"
		return 1
	fi

	get_current_jffs_device
	if [ "$?" != "0" ]; then
		echo_date "错误！无法获取/jffs挂载设备，无法备份！"
		return 1
	fi
	
	local mounted_nu=$(mount | /bin/grep "${jffs_device}" | grep -E "/tmp/mnt/|/jffs"|/bin/grep -c "/dev/s")
	if [ "${mounted_nu}" != "2" ]; then
		echo_date "错误！没有检测到USB磁盘挂载在/jffs，无法备份！"
		echo_date "请先挂载USB磁盘到/jffs后再使用本功能！"
		return 1
	fi

	if [ ! -d "${KSPATH}/.koolshare_jffs" ];then
		echo_date "无法找到${KSPATH}/.koolshare_jffs文件夹，无法备份！"
		return 1
	fi
	
	echo_date "开始创建备份..."
	echo_date "备份存放路径：${KSPATH}"
	mkdir -p ${KSPATH}
	
	local TIMESTAMP=$(date -R +%Y%m%d_%H%M%S)
	cd ${KSPATH}
	tar -cf .koolshare_jffs_${TIMESTAMP}.tar .koolshare_jffs
	if [ "$?" != "0" ];then
		echo_date "备份失败！"
		return 1
	fi
	
	echo_date "备份成功，备份文件：${KSPATH}/.koolshare_jffs_${TIMESTAMP}.tar"
	sync
	sleep 1
		
	local SNAPS_COUNT=$(ls -alrh ${KSPATH}/.koolshare_jffs_*.tar|awk '{print $NF}'|wc -l)

	if [ "${SNAPS_COUNT}" -gt "15" ];then
		until [ "${SNAPS_COUNT}" -eq "15" ]; do
			local OLDEST_SNAP=$(ls -alrh ${KSPATH}/.koolshare_jffs_*.tar | head -n1 | awk '{print $NF}')
			echo_date "移除旧备份文件：${OLDEST_SNAP}"
			rm -rf ${OLDEST_SNAP}
			sync
			local SNAPS_COUNT=$(ls -alrh ${KSPATH}/.koolshare_jffs_*.tar|awk '{print $NF}'|wc -l)
		done
	fi
	
	local SNAPS_FILES=$(ls -alrh ${KSPATH}/.koolshare_jffs_*.tar|awk '{print "\t"$NF"\t"$5}')
	if [ "${SNAPS_COUNT}" -gt "0" ];then
		echo_date "目前共有备份${SNAPS_COUNT}个，如下："
		echo "${SNAPS_FILES}"
	else
		echo_date "目前没有任何可用备份！"
	fi
}

restore_backup(){
	# 恢复备份按钮
	# 没有备份文件选项，点击了备份按钮
	if [ -z "${usb2jffs_backup_file}" ];then
		echo_date "没有备份文件，恢复失败！"
		return 1
	fi

	# 可能是没有插入U盘
	if [ -z "${KSPATH}" ]; then
		echo_date "尚未设置usb2jffs插件挂载路径，无法恢复备份！"
		return 1
	fi	

	# 可能是没有插入U盘
	if [ ! -d "${KSPATH}" ]; then
		echo_date "尚未设置usb2jffs插件挂载路径，无法恢复备份！"
		return 1
	fi	

	if [ ! -f "${KSPATH}/${usb2jffs_backup_file}" ]; then
		echo_date "没有该备份文件：${KSPATH}/${usb2jffs_backup_file}，无法恢复备份！"
		return 1
	fi

	get_current_jffs_device
	if [ "$?" != "0" ]; then
		echo_date "错误！无法获取/jffs挂载设备，无法恢复！"
		return 1
	fi
	
	local mounted_nu=$(mount | /bin/grep "${jffs_device}" | grep -E "/tmp/mnt/|/jffs"|/bin/grep -c "/dev/s")
	if [ "${mounted_nu}" != "2" ]; then
		echo_date "错误！没有检测到USB磁盘挂载在/jffs，无法恢复！"
		echo_date "请先挂载USB磁盘到/jffs后再使用本功能！"
		return 1
	fi

	echo_date "使用备份文件：${KSPATH}/${usb2jffs_backup_file}进行恢复！"
	echo_date "开始恢复备份..."

	cd ${KSPATH}
	# 恢复前，先备份一次
	cp -rf .koolshare_jffs .koolshare_jffs_tmp

	# 移除.koolshare_jffs里的所有文件
	cd .koolshare_jffs
	rm -r .[a-zA-Z_]* *
	cd ..
	sync

	# 恢复
	tar -xf ${usb2jffs_backup_file}
	if [ "$?" == "0" ];then
		echo_date "恢复成功！"
		rm -rf .koolshare_jffs_tmp
	else
		echo_date "恢复失败！"
		mv -f .koolshare_jffs_tmp .koolshare_jffs
	fi
	sync

	# 重启软件中心
	echo_date "重启软件中心！"
	start_software_center
}

remove_backup(){
	if [ -z "${usb2jffs_backup_file}" ];then
		echo_date "没有备份文件，恢复失败！"
		return 1
	fi
	
	if [ ! -f "${KSPATH}/${usb2jffs_backup_file}" ];then
		echo_date "找不到指定的备份，退出！"
		return 1
	fi

	echo_date "移除备份：${KSPATH}/${usb2jffs_backup_file}！"
	rm -rf ${KSPATH}/${usb2jffs_backup_file}
	if [ "$?" != "0" ];then
		echo_date "删除失败！"
		return 1
	fi
	echo_date "删除成功！"
	sync
	local SNAPS_COUNT=$(ls -alrh ${KSPATH}/.koolshare_jffs_*.tar|awk '{print $NF}'|wc -l)
	local SNAPS_FILES=$(ls -alrh ${KSPATH}/.koolshare_jffs_*.tar|awk '{print "\t"$NF"\t"$5}')
	if [ "${SNAPS_COUNT}" == "0" ];then
		echo_date "目前共有尚无任何备份！"
	else
		echo_date "目前共有备份${SNAPS_COUNT}个，如下："
		echo "${SNAPS_FILES}"
	fi
}

download_backup(){
	if [ -z "${usb2jffs_backup_file}" ];then
		echo_date "没有此备份文件，下载失败！"
		return 1
	fi
	
	if [ ! -f "${KSPATH}/${usb2jffs_backup_file}" ];then
		echo_date "找不到指定的备份，退出！"
		return 1
	fi
	
	echo_date "备份文件准备中..."
	rm -rf /koolshare/webs/files
	mkdir -p /koolshare/webs/files
	ln -sf ${KSPATH}/${usb2jffs_backup_file} /koolshare/webs/files/${usb2jffs_backup_file}

	echo_date "此备份文件可用于以后的恢复操作，请勿更改备份文件名..."
}

upload_backup(){
	echo_date "文件上传完毕！"
	if [ -f "/tmp/upload/${usb2jffs_backupfile_name}" ];then
		echo_date "找到上传的备份文件：${usb2jffs_backupfile_name}"
	else
		echo_date "没有找到上传的备份文件：${usb2jffs_backupfile_name}，请检查USB磁盘！"
		return 1
	fi

	if [ -d "${KSPATH}" ];then
		echo_date "将备份文件移动到USB磁盘：${KSPATH}"
	else
		echo_date "没有找到！${KSPATH}，，请检查USB磁盘！"
		return 1
	fi

	mv /tmp/upload/${usb2jffs_backupfile_name} ${KSPATH}
	if [ "$?"  == "0" ];then
		echo_date "成功！你可以在备份文件列表里选择其进行恢复！"
	fi
}

number_test(){
	case $1 in
		''|*[!0-9]*)
			echo 1
			;;
		*) 
			echo 0
			;;
	esac
}

if [ $# == 2 -a $(number_test $1) == 0 ];then
	http_response "$1"
fi

case $1 in
sync)
	# by crontab
	sync_usb_mtd | tee -a ${LOG_FILE}
	exit 0
	;;
stop)
	# called by uninstall.sh
	stop_usb2jffs 1 | tee -a ${LOG_FILE}
	exit 0
	;;
esac

# by web
case $2 in
1)
	# 挂载
	echo_date "========================= USB2JFFS - 手动挂载 ========================" | tee -a ${LOG_FILE}
	start_usb2jffs | tee -a ${LOG_FILE}
	echo_date "========================= USB2JFFS - 运行完成 ========================" | tee -a ${LOG_FILE}
	echo "XU6J03M6" >> ${LOG_FILE}
	;;
2)
	# 卸载
	echo_date "========================= USB2JFFS - 手动卸载 ========================" | tee -a ${LOG_FILE}
	stop_usb2jffs | tee -a ${LOG_FILE}
	echo_date "========================= USB2JFFS - 运行完成 ========================" | tee -a ${LOG_FILE}
	echo "XU6J03M6" | tee -a ${LOG_FILE}
	;;
3)
	# 删除
	echo_date "========================= USB2JFFS - 手动删除 ========================" | tee -a ${LOG_FILE}
	stop_usb2jffs 1 | tee -a ${LOG_FILE}
	echo_date "========================= USB2JFFS - 运行完成 ========================" | tee -a ${LOG_FILE}
	echo "XU6J03M6" >> ${LOG_FILE}
	;;
4)
	# 清理日志
	echo "XU6J03M6" >> ${LOG_FILE}
	;;
5)
	# 同步
	echo_date "========================= USB2JFFS - 手动同步 ========================" | tee -a ${LOG_FILE}
	sync_usb_mtd | tee -a ${LOG_FILE}
	echo_date "========================= USB2JFFS - 运行完成 ========================" | tee -a ${LOG_FILE}
	echo "XU6J03M6" >> ${LOG_FILE}
	;;
6)
	# 设定定时同步
	echo_date "========================= USB2JFFS - 定时设定 ========================" | tee -a ${LOG_FILE}
	set_sync_job | tee -a ${LOG_FILE}
	echo_date "========================= USB2JFFS - 设定完成 ========================" | tee -a ${LOG_FILE}
	echo "XU6J03M6" >> ${LOG_FILE}
	;;
7)
	# 设定是否卸载/删除时同步
	echo_date "========================= USB2JFFS - 同步设定 ========================" | tee -a ${LOG_FILE}
	set_stop_sync | tee -a ${LOG_FILE}
	echo_date "========================= USB2JFFS - 设定完成 ========================" | tee -a ${LOG_FILE}
	echo "XU6J03M6" >> ${LOG_FILE}
	;;
8)
	# 创建备份按钮
	echo_date "========================= USB2JFFS - 创建备份 ========================" | tee -a ${LOG_FILE}
	make_backup | tee -a ${LOG_FILE}
	echo_date "========================= USB2JFFS - 备份完成 ========================" | tee -a ${LOG_FILE}
	echo "XU6J03M6" >> ${LOG_FILE}
	;;
9)
	# 恢复备份按钮
	echo_date "========================= USB2JFFS - 备份恢复 ========================" | tee -a ${LOG_FILE}
	restore_backup | tee -a ${LOG_FILE}
	echo_date "========================= USB2JFFS - 恢复完成 ========================" | tee -a ${LOG_FILE}
	echo "XU6J03M6" >> ${LOG_FILE}
	;;
10)
	# 删除备份按钮
	echo_date "========================= USB2JFFS - 备份删除 ========================" | tee -a ${LOG_FILE}
	remove_backup | tee -a ${LOG_FILE}
	echo_date "========================= USB2JFFS - 删除完成 ========================" | tee -a ${LOG_FILE}
	echo "XU6J03M6" >> ${LOG_FILE}
	;;
11)
	# 删除备份按钮
	echo_date "========================= USB2JFFS - 下载备份 ========================" | tee -a ${LOG_FILE}
	download_backup | tee -a ${LOG_FILE}
	echo_date "========================= USB2JFFS - 下载完成 ========================" | tee -a ${LOG_FILE}
	echo "XU6J03M6" >> ${LOG_FILE}
	;;
12)
	# 删除备份按钮
	echo_date "========================= USB2JFFS - 上传备份 ========================" | tee -a ${LOG_FILE}
	upload_backup | tee -a ${LOG_FILE}
	echo_date "========================= USB2JFFS - 上传完成 ========================" | tee -a ${LOG_FILE}
	echo "XU6J03M6" >> ${LOG_FILE}
	;;
esac
