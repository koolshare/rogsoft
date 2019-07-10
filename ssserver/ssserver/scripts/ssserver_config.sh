#!/bin/sh
# load path environment in dbus databse
eval `dbus export ssserver`
source /koolshare/scripts/base.sh

start_ssserver(){
	[ "$ssserver_udp" -ne 1 ] && ARG_UDP="" || ARG_UDP="-u";
	if [ "$ssserver_obfs" == "http" ];then
		ARG_OBFS="--plugin obfs-server --plugin-opts obfs=http"
	elif [ "$ssserver_obfs" == "tls" ];then
		ARG_OBFS="--plugin obfs-server --plugin-opts obfs=tls"
	else
		ARG_OBFS=""
	fi

	#ss-server -c /koolshare/ssserver/ss.json $ARG_UDP $ARG_OBFS -f /tmp/ssserver.pid
	ss-server -s 0.0.0.0 -p $ssserver_port -k $ssserver_password -m $ssserver_method -t $ssserver_time $ARG_UDP $ARG_OBFS -f /tmp/ssserver.pid 

	# creat start_up file
	if [ ! -L "/koolshare/init.d/N98ssserver.sh" ]; then 
		ln -sf /koolshare/scripts/ssserver_config.sh /koolshare/init.d/N97ssserver.sh
	fi

	# creat start_up file
	if [ ! -L "/koolshare/init.d/S98ssserver.sh" ]; then 
		ln -sf /koolshare/scripts/ssserver_config.sh /koolshare/init.d/S97ssserver.sh
	fi
}

stop_ssserver(){
	killall ss-server >/dev/null 2>&1
	killall obfs-server >/dev/null 2>&1
}

open_port(){
	ifopen=`iptables -S -t filter | grep INPUT | grep dport |grep $ssserver_port`
	[ -z "$ifopen" ] && iptables -t filter -I INPUT -p tcp --dport $ssserver_port -j ACCEPT >/dev/null 2>&1
	[ -z "$ifopen" ] && iptables -t filter -I INPUT -p udp --dport $ssserver_port -j ACCEPT >/dev/null 2>&1
}

close_port(){
	ifopen=`iptables -S -t filter | grep INPUT | grep dport |grep $ssserver_port`
	[ -n "$ifopen" ] && iptables -t filter -D INPUT -p tcp --dport $ssserver_port -j ACCEPT >/dev/null 2>&1
	[ -n "$ifopen" ] && iptables -t filter -D INPUT -p udp --dport $ssserver_port -j ACCEPT >/dev/null 2>&1
}

write_output(){
	ss_enable=`dbus get ss_basic_enable`
	if [ "$ssserver_use_ss" == "1" ] && [ "$ss_enable" == "1" ];then
		if [ ! -L "/jffs/configs/dnsmasq.d/gfwlist.conf" ];then
			echo link gfwlist.conf
			ln -sf /koolshare/ss/rules/gfwlist.conf /jffs/configs/dnsmasq.d/gfwlist.conf
		fi
		service restart_dnsmasq
		iptables -t nat -A OUTPUT -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-ports 3333
	fi
}

del_output(){
	iptables -t nat -D OUTPUT -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-ports 3333 >/dev/null 2>&1
}

case $ACTION in
start)
	if [ "$ssserver_enable" == "1" ]; then
		logger "[软件中心]: 启动ssserver！"
		start_ssserver
		open_port
		write_output
	else
		logger "[软件中心]: ssserver未设置开机启动，跳过！"
	fi
	;;
stop)
	close_port >/dev/null 2>&1
	stop_ssserver
	del_output
	;;
start_nat)
	if [ "$ssserver_enable" == "1" ]; then
		close_port >/dev/null 2>&1
		open_port
		write_output
	fi
	;;
*)
	if [ "$ssserver_enable" == "1" ]; then
		close_port >/dev/null 2>&1
		stop_ssserver
		sleep 1
		start_ssserver
		open_port
		write_output
	else
		close_port >/dev/null 2>&1
		stop_ssserver
		del_output
	fi
	;;
esac