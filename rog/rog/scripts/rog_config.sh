#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'

case $2 in
1)
	sync
	echo 1 > /proc/sys/vm/drop_caches
	http_response "$1"
	;;
esac
