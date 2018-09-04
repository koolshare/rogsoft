#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export aria2`

perpare(){
	usb_disk1=`/bin/mount | grep -E 'mnt' | sed -n 1p | cut -d" " -f3`
	if [ "$aria2_dir" == "downloads" ];then
		if [ -n "$usb_disk1" ];then
			dbus set aria2_dir="$usb_disk1"
		else
			dbus set aria2_dir="/tmp"
		fi
	fi
	[ ! -f "/koolshare/aria2/aria2.session" ] && touch /koolshare/aria2/aria2.session
	[ ! -L "/koolshare/init.d/M99Aria2.sh" ] && ln -sf /koolshare/scripts/aria2_config.sh /koolshare/init.d/M99Aria2.sh
	[ ! -L "/koolshare/init.d/N99Aria2.sh" ] && ln -sf /koolshare/scripts/aria2_config.sh /koolshare/init.d/N99Aria2.sh
	
	sleep 1

	cat > /tmp/aria2.conf <<-EOF
	`dbus list aria2 | grep -vw aria2_enable | grep -vw aria2_version | grep -vw aria2_title | grep -vw aria2_cpulimit_enable | grep -vw aria2_cpulimit_value | grep -vw aria2_custom | grep -vw aria2_bt_tracker | grep -vw aria2_dir| sed 's/aria2_//g' | sed 's/_/-/g'`
	`dbus list aria2|grep -w aria2_dir|sed 's/aria2_//g'`
	`dbus get aria2_custom|base64_decode`
	EOF
	if [ -n "`dbus get aria2_bt_tracker`" ];then
		cat >> /tmp/aria2.conf <<-EOF
			bt-tracker=`dbus get aria2_bt_tracker|base64_decode`
		EOF
	fi
	cat /tmp/aria2.conf|sort > /koolshare/aria2/aria2.conf
}

start_aria2(){
	/koolshare/aria2/aria2c --conf-path=/koolshare/aria2/aria2.conf -D >/dev/null 2>&1 &
}

# open firewall port
open_port(){
	iptables -I INPUT -p tcp --dport $aria2_rpc_listen_port -j ACCEPT >/dev/null 2>&1
	iptables -I INPUT -p tcp --dport 8088 -j ACCEPT >/dev/null 2>&1
	iptables -I INPUT -p tcp --dport 6881:6889 -j ACCEPT >/dev/null 2>&1
	iptables -I INPUT -p tcp --dport 51413 -j ACCEPT >/dev/null 2>&1
	iptables -I INPUT -p tcp --dport 52413 -j ACCEPT >/dev/null 2>&1
	iptables -I INPUT -p udp --dport 52413 -j ACCEPT >/dev/null 2>&1
}

# close firewall port
close_port(){
	iptables -D INPUT -p tcp --dport $aria2_rpc_listen_port -j ACCEPT >/dev/null 2>&1
	iptables -D INPUT -p tcp --dport 8088 -j ACCEPT >/dev/null 2>&1
	iptables -D INPUT -p tcp --dport 6881:6889 -j ACCEPT >/dev/null 2>&1
	iptables -D INPUT -p tcp --dport 51413 -j ACCEPT >/dev/null 2>&1
	iptables -D INPUT -p tcp --dport 52413 -j ACCEPT >/dev/null 2>&1
	iptables -D INPUT -p udp --dport 52413 -j ACCEPT >/dev/null 2>&1
}

add_cpulimit(){
	cores=`grep 'processor' /proc/cpuinfo | sort -u | wc -l`
	if [ "$aria2_cpulimit_enable" = "1" ];then
		limit=`expr $aria2_cpulimit_value \* $cores`
		cpulimit -e aria2c -l $limit  >/dev/null 2>&1 &
	fi
}

# ==========================================================
# this part for start up by post-mount
case $1 in
start)
	# startup by post-mount
	if [ "$aria2_enable" == "1" ];then
		logger "[软件中心]: 启动aria2！"
		# incase disk re-plug
		killall aria2c >/dev/null 2>&1
		killall cpulimit >/dev/null 2>&1
		close_port
		sleep 1
		# start
		perpare
		start_aria2
		open_port
		add_cpulimit
	else
		logger "[软件中心]: aria2插件未开启！"
	fi
	;;
stop)
	# startup by post-mount
	if [ "$aria2_enable" == "1" ];then
		killall aria2c >/dev/null 2>&1
		killall cpulimit >/dev/null 2>&1
		close_port
	fi
	;;
start_nat)
	# nat restart by nat-start
	if [ "$aria2_enable" == "1" ];then
		close_port
		open_port
	fi
	;;
esac

# for web submit
case $2 in
1)
	if [ "$aria2_enable" == "1" ];then
		# try stop first
		killall aria2c >/dev/null 2>&1
		killall cpulimit >/dev/null 2>&1
		close_port
		sleep 1
		# start
		perpare
		start_aria2
		open_port
		add_cpulimit
	else
	 	# stop
		killall aria2c >/dev/null 2>&1
		killall cpulimit >/dev/null 2>&1
		close_port
	fi
	http_response "$1"
	;;
2)
	# clean configure
	killall aria2c >/dev/null 2>&1
	killall cpulimit >/dev/null 2>&1
	rm -rf /koolshare/aria2/aria2.session
	close_port
	sleep 1
	http_response "$1"
	;;
esac