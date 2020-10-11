#!/bin/sh

timestamp=$(date +'%Y/%m/%d %H:%M:%S')
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

pid=$(pidof fastd1ck_main.sh)

if [ -n "$pid" ]; then
	http_response "<font color=green>$(echo_date) 提速脚本运行中...(PID: $pid)</font>"
else
	http_response "<font color=red>$(echo_date) 提速脚本未运行...</font>"
fi
