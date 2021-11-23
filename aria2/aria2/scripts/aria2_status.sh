#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

aria2_pid=`pidof aria2c`

if [ -n "$aria2_pid" ];then
    http_response "Aria2 1.34.0 进程运行正常！PID：$aria2_pid"
else
    http_response "aria2c进程未运行！"
fi
