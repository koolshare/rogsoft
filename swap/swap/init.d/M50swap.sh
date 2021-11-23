#!/bin/sh

alias echo_date='echo $(date +%Y年%m月%d日\ %X)'
source /koolshare/scripts/base.sh

SWAPTOTAL=$(free|grep Swap|awk '{print $2}')
SWAPUSED=$(free|grep Swap|awk '{print $3}')

MOPATH=$1

if [ -f "${MOPATH}/swapfile" -a "${SWAPTOTAL}" == "0" ];then
	_LOG "[软件中心]-[M50swap.sh]: 在${MOPATH}下找到swapfile，开始挂载！"
	swapon "${MOPATH}/swapfile"
	if [ "$?" == "0" ];then
		_LOG "[软件中心]-[M50swap.sh]: 在${MOPATH}下找到swapfile，且已成功挂载！"
		dbus set swap_auto_mount="${MOPATH}/swapfile"
	fi
fi

