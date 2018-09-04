#!/bin/sh
source /koolshare/scripts/base.sh
eval `dbus export shellinabox`

case $2 in
1)
	PID=`pidof shellinaboxd`
	[ -z "$PID" ] && /koolshare/shellinabox/shellinaboxd --css=/koolshare/shellinabox/white-on-black.css -b
	http_response "$1"
	;;
esac
