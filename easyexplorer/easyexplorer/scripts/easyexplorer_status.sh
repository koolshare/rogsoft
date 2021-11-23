#! /bin/sh
source /koolshare/scripts/base.sh

easyexplorer_status=`pidof easy-explorer`
easyexplorer_pid=`ps | grep -w easy-explorer | grep -v grep | awk '{print $1}'`
easyexplorer_info=`/koolshare/bin/easy-explorer -vv`
easyexplorer_ver=`echo ${easyexplorer_info} | awk '{print $1}'`
easyexplorer_rid=`echo ${easyexplorer_info} | awk '{print $2}'`
if [ -n "$easyexplorer_status" ];then
    http_response  "进程运行正常！版本：${easyexplorer_ver} 路由器ID：${easyexplorer_rid} （PID：$easyexplorer_pid）"
else
    http_response  "【警告】：进程未运行！版本：${easyexplorer_ver} 路由器ID：${easyexplorer_rid}"
fi
