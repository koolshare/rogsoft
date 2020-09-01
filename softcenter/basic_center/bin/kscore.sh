#!/bin/sh

JFFS=$(mount|grep /jffs)
echo ${JFFS} >> /tmp/jffs_mount_status.txt

LINE=$(cat /tmp/jffs_mount_status.txt|wc -l)
P1=$(pidof httpdb)
P2=$(pidof skipd)

#if [ "${LINE}" == "1" ];then
#	if [ -n "${P1}" -a -n "${P2}" ];then
#		echo "插件底层程序已经启动！"
#	else
#		echo "启动插件底层程序！"
#		/koolshare/bin/start-stop-daemon -S -q -b -x /koolshare/bin/ks-bcm-start.sh -- start
#	fi
#else
#	if [ -n "${P1}" -a -n "${P2}" ];then
#		echo "插件底层程序已经启动！"
#	else
#		echo "启动插件底层程序！"
#		/koolshare/bin/start-stop-daemon -S -q -b -x /koolshare/bin/ks-bcm-start.sh -- start
#	fi
#fi

if [ -n "${P1}" -a -n "${P2}" ];then
	echo "插件底层程序已经启动！"
else
	echo "启动插件底层程序！"
	/koolshare/bin/start-stop-daemon -S -q -b -x /koolshare/bin/ks-bcm-start.sh -- start
fi