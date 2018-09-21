#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

ddnsto_status=`ps | grep -w ddnsto | grep -cv grep`
ddnsto_pid=`pidof ddnsto`
ddnsto_version=`/koolshare/bin/ddnsto -v`
ddnsto_route_id=`/koolshare/bin/ddnsto -w | awk '{print $2}'`
if [ "$ddnsto_status" == "2" ];then
    http_response "ddnsto  $ddnsto_version 进程运行正常！路由器ID： $ddnsto_route_id PID：$ddnsto_pid"
else
    http_response "ddnsto  $ddnsto_version 【警告】：进程未运行！路由器ID：$ddnsto_route_id"
fi
