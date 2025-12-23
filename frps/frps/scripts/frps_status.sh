#! /bin/sh

export KSROOT=/koolshare
. $KSROOT/scripts/base.sh
frps_version="$(dbus get frps_client_version)"
if [ -z "${frps_version}" ]; then
	frps_version="$(/koolshare/bin/frps --version 2>/dev/null)"
fi
frps_pid="$(pidof frps)"
LOGTIME=$(TZ=UTC-8 date -R "+%Y-%m-%d %H:%M:%S")
if [ -n "$frps_pid" ];then
	http_response "【$LOGTIME】frps ${frps_version} 进程运行正常！（PID：$frps_pid）"
else
	http_response "【$LOGTIME】frps ${frps_version} 进程未运行！"
fi
