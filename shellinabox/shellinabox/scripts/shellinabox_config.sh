#!/bin/sh
source /koolshare/scripts/base.sh

case $2 in
1)
	PID=$(pidof shellinaboxd)
	if [ -z "$PID" ];then
		/koolshare/shellinabox/shellinaboxd --css=/koolshare/shellinabox/white-on-black.css -b
	fi
	http_response "$1"
	;;
esac
