#!/bin/sh
# load path environment in dbus databse
eval `dbus export virtualhere`
source /koolshare/scripts/base.sh

start_virtualhere(){
  # 判断无进程才启动
  is_start=`ps | grep [v]husbdarm64 | wc -l`
	if [ "$is_start" == "1" ];then
	  echo_date "[virtualhere]: vhusbdarm64 已有运行实例，无需启动！"
  else
    /koolshare/bin/vhusbdarm64 -b
 	  echo_date "[virtualhere]: vhusbdarm64 启动成功！"
  fi
}

stop_virtualhere(){
	killall vhusbdarm64
}

open_port(){
  echo_date "[virtualhere]: open_port"
	ifopen=`iptables -S -t filter | grep INPUT | grep dport |grep 7575`
	[ -z "$ifopen" ] && iptables -t filter -I INPUT -p tcp --dport 7575 -j ACCEPT
}

close_port(){
  echo_date "[virtualhere]: close_port"
	ifopen=`iptables -S -t filter | grep INPUT | grep dport |grep 7575`
	[ -n "$ifopen" ] && iptables -t filter -D INPUT -p tcp --dport 7575 -j ACCEPT
}

echo_date "[virtualhere]: ACTION=$ACTION"
case $ACTION in
start)
	if [ "$virtualhere_enable" == "1" ]; then
		echo_date "[软件中心]: 启动virtualhere！"
		start_virtualhere
		[ "$virtualhere_wan_port" == "1" ] && open_port
	else
		echo_date "[软件中心]: virtualhere未设置开机启动，跳过！"
	fi
	;;
stop)
	close_port >/dev/null 2>&1
	stop_virtualhere
	;;
start_nat)
	if [ "$virtualhere_enable" == "1" ]; then
		close_port >/dev/null 2>&1
		[ "$virtualhere_wan_port" == "1" ] && open_port
	fi
	;;
*)
	if [ "$virtualhere_enable" == "1" ]; then
		close_port >/dev/null 2>&1
		start_virtualhere
		[ "$virtualhere_wan_port" == "1" ] && open_port
	else
		close_port >/dev/null 2>&1
		stop_virtualhere
	fi
	;;
esac
