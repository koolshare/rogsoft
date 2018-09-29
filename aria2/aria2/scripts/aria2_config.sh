#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export aria2`
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'
LOG_FILE=/tmp/upload/aria2_log.txt

perpare(){
	# ddnsto pathrough
	if [ "`dbus get aria2_ddnsto`" == "1" ] && [ -f "/koolshare/bin/ddnsto" ] && [ -n "`pidof ddnsto`" ]; then
		echo_date 开启aria2的远程穿透连接!
		ddnsto_route_id=`/koolshare/bin/ddnsto -w | awk '{print $2}'`
		aria2_ddnsto_token=`echo $(dbus get ddnsto_token)-${ddnsto_route_id}`
		dbus set aria2_ddnsto_token=$aria2_ddnsto_token
	else
		echo_date 开启aria2的远程穿透连接失败！开启传统非穿透模式！
		dbus set aria2_ddnsto=0
	fi
	# check disk
	usb_disk1=`/bin/mount | grep -E 'mnt' | sed -n 1p | cut -d" " -f3`
	if [ -n "$usb_disk1" ];then
		if [ "$aria2_dir" == "downloads" ];then
			echo_date aira2没有设置磁盘路径，设置默认下载路径为"$usb_disk1" ！
			dbus set aria2_dir="$usb_disk1"
		else
			echo_date 使用"$aria2_dir"作为aria2下载路径！
		fi
	else
		echo_date aira2没有找到可用磁盘，设置默认下载路径为/tmp ！
		dbus set aria2_dir="/tmp"
	fi
	# creat links
	[ ! -f "/koolshare/aria2/aria2.session" ] && touch /koolshare/aria2/aria2.session
	[ ! -L "/koolshare/init.d/M99Aria2.sh" ] && ln -sf /koolshare/scripts/aria2_config.sh /koolshare/init.d/M99Aria2.sh
	[ ! -L "/koolshare/init.d/N99Aria2.sh" ] && ln -sf /koolshare/scripts/aria2_config.sh /koolshare/init.d/N99Aria2.sh
	sleep 1
	# generate conf
	echo_date 生成aria2c配置文件到/koolshare/aria2/aria2.conf
	cat > /tmp/aria2.conf <<-EOF
	`dbus list aria2 | grep -vw aria2_enable | grep -vw aria2_version | grep -vw aria2_title | grep -vw aria2_cpulimit_enable | grep -vw aria2_rpc_secret | grep -vw aria2_ddnsto | grep -vw aria2_ddnsto_token | grep -vw aria2_cpulimit_value | grep -vw aria2_custom | grep -vw aria2_bt_tracker | grep -vw aria2_dir| sed 's/aria2_//g' | sed 's/_/-/g'`
	`dbus list aria2|grep -w aria2_dir|sed 's/aria2_//g'`
	`dbus get aria2_custom|base64_decode`
	EOF
	if [ -n "`dbus get aria2_bt_tracker`" ];then
		cat >> /tmp/aria2.conf <<-EOF
			bt-tracker=`dbus get aria2_bt_tracker|base64_decode|sed '/^\s*$/d'|sed ":a;N;s/\n/,/g;ta"`
		EOF
	fi
	if [ "`dbus get aria2_ddnsto`" == "1" ] && [ -f "/koolshare/bin/ddnsto" ]; then
		cat >> /tmp/aria2.conf <<-EOF
			rpc-secret=$aria2_ddnsto_token
		EOF
	else
		cat >> /tmp/aria2.conf <<-EOF
			rpc-secret=$aria2_rpc_secret
		EOF
	fi
	cat /tmp/aria2.conf|sort > /koolshare/aria2/aria2.conf
}

start_aria2(){
	echo_date 开启aria2c主进程！
	/koolshare/aria2/aria2c --conf-path=/koolshare/aria2/aria2.conf >/dev/null 2>&1 &
}

stop_aria2(){
	if [ "$(pidof aria2c)" ];then
		echo_date 关闭aria2c进程！
		kill -9 $(pidof aria2c) >/dev/null 2>&1
	fi
	if [ "$(pidof cpulimit)" ];then
		echo_date 关闭cpulimit进程！
		kill -9 $(pidof cpulimit) >/dev/null 2>&1
	fi
}

open_port(){
	cm=`lsmod | grep xt_comment`
	OS=$(uname -r)
	if [ -z "$cm" ] && [ -f "/lib/modules/${OS}/kernel/net/netfilter/xt_comment.ko" ];then
		echo_date 加载xt_comment.ko内核模块！
		insmod /lib/modules/${OS}/kernel/net/netfilter/xt_comment.ko
	fi
	
	echo_date 在防火墙上打开RPC监听端口：$aria2_rpc_listen_port！
	iptables -I INPUT -p tcp --dport $aria2_rpc_listen_port -j ACCEPT -m comment --comment "aria2_rpc_port" >/dev/null 2>&1
	
	echo_date 在防火墙上打开BT监听端口：$aria2_listen_port！
	aria2_listen_port=`echo $aria2_listen_port |sed 's/-/:/g'`
	iptables -I INPUT -p tcp -m multiport --dport $aria2_listen_port -j ACCEPT -m comment --comment "aria2_bt_port" >/dev/null 2>&1
	
	echo_date 在防火墙上打开DHT监听端口：$aria2_dht_listen_port！
	iptables -I INPUT -p tcp --dport $aria2_dht_listen_port -j ACCEPT -m comment --comment "aria2_dht_port" >/dev/null 2>&1
	iptables -I INPUT -p udp --dport $aria2_dht_listen_port -j ACCEPT -m comment --comment "aria2_dht_port" >/dev/null 2>&1
}

close_port(){
	echo_date 关闭本插件在防火墙上打开的所有端口!
	cd /tmp
	iptables -S INPUT|grep aria2|sed 's/-A/iptables -D/g' > clean.sh && chmod 777 clean.sh && ./clean.sh > /dev/null 2>&1 && rm clean.sh
}

add_cpulimit(){
	cores=`grep 'processor' /proc/cpuinfo | sort -u | wc -l`
	if [ "$aria2_cpulimit_enable" = "1" ];then
		echo_date 检测到$cores核心CPU，启用CPU占用限制：$aria2_cpulimit_value%!
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
		stop_aria2
		close_port
		perpare
		start_aria2
		open_port
		add_cpulimit
	else
		logger "[软件中心]: aria2插件未开启！"
	fi
	;;
start_nat)
	if [ "$aria2_enable" == "1" ];then
		close_port
		open_port
	fi
	;;
esac

# for web submit
case $2 in
restart)
	# submit buttom
	echo " " > $LOG_FILE
	http_response "$1"
	echo 1111 > /jffs/ss.txt
	if [ "$aria2_enable" == "1" ];then
		echo_date =============================== aria2启用 ============================ >> $LOG_FILE
		stop_aria2 >> $LOG_FILE
		close_port >> $LOG_FILE
		perpare >> $LOG_FILE
		start_aria2 >> $LOG_FILE
		open_port >> $LOG_FILE
		add_cpulimit >> $LOG_FILE
		echo_date aria2插件成功开启！ >> $LOG_FILE
		echo_date ===================================================================== >> $LOG_FILE
	else
		echo_date ================================ 关闭 =============================== >> $LOG_FILE
		stop_aria2 >> $LOG_FILE
		close_port >> $LOG_FILE
		echo_date aria2插件已关闭！ >> $LOG_FILE
		echo_date ===================================================================== >> $LOG_FILE
	fi
	echo XU6J03M6 >> $LOG_FILE
	;;
clean)
	# clean configure
	echo " " > $LOG_FILE
	echo_date ============================= aria2配置恢复 ========================== >> $LOG_FILE
	http_response "$1"
	stop_aria2 >> $LOG_FILE
	close_port >> $LOG_FILE
	echo_date 清空所有用户配置，恢复插件默认设置！ >> $LOG_FILE
	echo_date 删除文件：/koolshare/aria2/aria2.session！ >> $LOG_FILE
	rm -rf /koolshare/aria2/aria2.session
	echo_date 恢复完毕！ >> $LOG_FILE
	echo_date ===================================================================== >> $LOG_FILE
	echo XU6J03M6 >> $LOG_FILE
	;;
esac

echo $2 >> /jffs/ss.txt