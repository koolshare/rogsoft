#!/bin/sh

# use this scripts to switch between softcenter and koolcenter

source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'


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

get_usb2jffs_status(){
	# 如果正在使用usb2jffs，使用USB磁盘挂载了/jffs分区，那么软件中心需要同时更新到/jffs和cifs2
	get_current_jffs_device
	if [ "$?" != "0" ]; then
		return 1
	fi
	
	local mounted_nu=$(mount | /bin/grep "${jffs_device}" | grep -E "/tmp/mnt/|/jffs"|/bin/grep -c "/dev/s")
	if [ "${mounted_nu}" != "2" ]; then
		return 1
	fi

	local CIFS_STATUS=$(df -h|grep "/cifs2"|awk '{print $1}'|grep "/dev/mtdblock")
	if [ -z "${CIFS_STATUS}" ];then
		return 1
	fi
		
	if [ ! -d "/cifs2/.koolshare" ];then
		return 1

	fi

	# user has mount USB disk to /jffs, and orgin jffs mount device: /dev/mtdblock? mounted on /cifs2
	return 0
}

switch_center_jffs(){
	if [ -f /jffs/.koolshare/webs/Module_Softcenter_old.asp -a -f /jffs/.koolshare/.soft_ver_old ];then
		local SVER_1=$(cat /jffs/.koolshare/.soft_ver_old)
		[ -n "${SVER_1}" ] && echo_date "切换到softcenter ${SVER_1}！"
		dbus set softcenter_version=${SVER_1}
		#start-stop-daemon -S -q -b -m -p /tmp/var/dbus1.pid -x /usr/bin/dbus -- set softcenter_version=${SVER_1}
		mv /jffs/.koolshare/.soft_ver /jffs/.koolshare/.soft_ver_new
		mv /jffs/.koolshare/.soft_ver_old /jffs/.koolshare/.soft_ver
		mv /jffs/.koolshare/webs/Module_Softcenter.asp /jffs/.koolshare/webs/Module_Softcenter_new.asp
		mv /jffs/.koolshare/webs/Module_Softcenter_old.asp /jffs/.koolshare/webs/Module_Softcenter.asp
		switch_flag=1
	elif [ -f /jffs/.koolshare/webs/Module_Softcenter_new.asp -a -f /jffs/.koolshare/.soft_ver_new ];then
		local SVER_2=$(cat /jffs/.koolshare/.soft_ver_new)
		[ -n "${SVER_2}" ] && echo_date "切换到koolcenter ${SVER_2}！"
		dbus set softcenter_version=${SVER_2}
		#start-stop-daemon -S -q -b -m -p /tmp/var/dbus1.pid -x /usr/bin/dbus -- set softcenter_version=${SVER_2}
		mv /jffs/.koolshare/.soft_ver /jffs/.koolshare/.soft_ver_old
		mv /jffs/.koolshare/.soft_ver_new /jffs/.koolshare/.soft_ver
		mv /jffs/.koolshare/webs/Module_Softcenter.asp /jffs/.koolshare/webs/Module_Softcenter_old.asp
		mv /jffs/.koolshare/webs/Module_Softcenter_new.asp /jffs/.koolshare/webs/Module_Softcenter.asp
		switch_flag=2
	fi

	sleep 1
	sync
}

switch_center_cifs(){
	killall skipd >/dev/null 2>&1
	kill -9 $(pidof skipd) >/dev/null 2>&1
	rm -rf /tmp/.skipd_server_sock >/dev/null 2>&1
	rm -rf /tmp/.skipd_pid >/dev/null 2>&1
	cd /cifs2/ksdb
	/usr/bin/skipd -d /cifs2/ksdb >/dev/null 2>&1 &
	local SKIPDPID_1
	local i=10
	until [ -n "$SKIPDPID_1" ]; do
		i=$(($i - 1))
		SKIPDPID_1=$(pidof skipd)
		if [ "$i" -lt 1 ]; then
			echo_date "skipd进程启动失败！"
			close_in_five
		fi
		usleep 250000
	done
	sleep 1
	sync
	
	if [ -f /cifs2/.koolshare/webs/Module_Softcenter_old.asp -a -f /cifs2/.koolshare/.soft_ver_old ];then
		if [ "$switch_flag" == "1" ];then
			local SVER_1=$(cat /cifs2/.koolshare/.soft_ver_old)
			[ -n "${SVER_1}" ] && echo_date "切换到softcenter ${SVER_1}！"
			dbus set softcenter_version=${SVER_1}
			#start-stop-daemon -S -q -b -m -p /tmp/var/dbus1.pid -x /usr/bin/dbus -- set softcenter_version=${SVER_1}
			mv /cifs2/.koolshare/.soft_ver /cifs2/.koolshare/.soft_ver_new
			mv /cifs2/.koolshare/.soft_ver_old /cifs2/.koolshare/.soft_ver
			mv /cifs2/.koolshare/webs/Module_Softcenter.asp /cifs2/.koolshare/webs/Module_Softcenter_new.asp
			mv /cifs2/.koolshare/webs/Module_Softcenter_old.asp /cifs2/.koolshare/webs/Module_Softcenter.asp
		fi
	elif [ -f /cifs2/.koolshare/webs/Module_Softcenter_new.asp -a -f /cifs2/.koolshare/.soft_ver_new ];then
		if [ "$switch_flag" == "2" ];then
			local SVER_2=$(cat /cifs2/.koolshare/.soft_ver_new)
			[ -n "${SVER_2}" ] && echo_date "切换到koolcenter ${SVER_2}！"
			dbus set softcenter_version=${SVER_2}
			#start-stop-daemon -S -q -b -m -p /tmp/var/dbus1.pid -x /usr/bin/dbus -- set softcenter_version=${SVER_2}
			mv /cifs2/.koolshare/.soft_ver /cifs2/.koolshare/.soft_ver_old
			mv /cifs2/.koolshare/.soft_ver_new /cifs2/.koolshare/.soft_ver
			mv /cifs2/.koolshare/webs/Module_Softcenter.asp /cifs2/.koolshare/webs/Module_Softcenter_old.asp
			mv /cifs2/.koolshare/webs/Module_Softcenter_new.asp /cifs2/.koolshare/webs/Module_Softcenter.asp
		fi
	fi

	sync
	sleep 1

	killall skipd >/dev/null 2>&1
	kill -9 $(pidof skipd) >/dev/null 2>&1
	rm -rf /tmp/.skipd_server_sock >/dev/null 2>&1
	rm -rf /tmp/.skipd_pid >/dev/null 2>&1
	# service start_skipd >/dev/null 2>&1

	# bring skipd up
	cd /jffs/ksdb
	/usr/bin/skipd -d /jffs/ksdb >/dev/null 2>&1 &
	local SKIPDPID_2
	local i=10
	until [ -n "$SKIPDPID_2" ]; do
		i=$(($i - 1))
		SKIPDPID_2=$(pidof skipd)
		if [ "$i" -lt 1 ]; then
			echo_date "skipd进程启动失败！"
			close_in_five
		fi
		usleep 250000
	done
	sleep 1
	sync
}

get_usb2jffs_status
if [ "$?" == "0" -a "/cifs2/ksdb/log" ];then
	echo_date "检测到你使用USB磁盘挂载了/jffs！"
	echo_date "将同时切换系统jffs和usb jffs中的的软件中心！"
	echo_date "------------------ 切换USB JFFS中的软件中心（/jffs）------------------"
	switch_center_jffs
	echo_date "----------------------------------------------------------------"
	echo_date "------------------ 切换系统JFFS中的软件中心（/cifs2）----------------"
	switch_center_cifs
	echo_date "----------------------------------------------------------------"
else
	echo_date "------------------ 切换系统JFFS中的软件中心（/jffs）-----------------"
	switch_center_jffs
	echo_date "----------------------------------------------------------------"
fi
