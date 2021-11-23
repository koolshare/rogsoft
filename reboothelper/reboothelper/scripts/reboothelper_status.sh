#!/bin/sh

source /koolshare/scripts/base.sh

case $1 in
*)
	echo b > /proc/sysrq-trigger
	http_response "$1"
	;;
esac