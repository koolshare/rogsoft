#!/bin/sh

alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'

P1=$(pidof httpdb)
P2=$(pidof skipd)

if [ -n "${P1}" -a -n "${P2}" ];then
	continue
	#echo_date "【basic_center】已经成功启动！"
else
	echo_date "【basic_center】开始启动！"
	/koolshare/bin/start-stop-daemon -S -q -b -x /koolshare/bin/ks-bcm-start.sh -- start
fi