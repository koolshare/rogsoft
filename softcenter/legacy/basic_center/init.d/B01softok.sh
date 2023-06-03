#!/bin/sh

source /koolshare/scripts/base.sh

detect_skipd(){
	i=120
	skipd=$(pidof skipd)
	until [ -n "$skipd" ]
	do
		i=$(($i-1))
		    skipd=$(pidof skipd)
		if [ "$i" -lt 1 ];then
		    logger "【basic_center】: 错误，skipd进程未能成功启动！"
		    exit
		fi
		sleep 1
	done
	logger "【basic_center】: skipd进程准备就绪！"
}

detect_httpdb(){
	i=120
	httpdb=$(pidof httpdb)
	until [ -n "$httpdb" ]
	do
		i=$(($i-1))
		    httpdb=$(pidof httpdb)
		if [ "$i" -lt 1 ];then
		    logger "【basic_center】: 错误，httpdb进程未能成功启动！"
		    exit
		fi
		sleep 1
	done
	logger "【basic_center】: httpdb进程准备就绪！"
}

start(){
	sh /koolshare/perp/perp.sh
	#detect_skipd
	#detect_httpdb
}

start
