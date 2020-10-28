#!/bin/sh

source /koolshare/scripts/base.sh
eval $(dbus export frps_)
INI_FILE=/koolshare/configs/frps.ini
LOG_FILE=/tmp/upload/frps_log.txt
LOCK_FILE=/var/lock/frps.lock
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
true > $LOG_FILE

set_lock() {
	exec 1000>"$LOCK_FILE"
	flock -x 1000
}

unset_lock() {
	flock -u 1000
	rm -rf "$LOCK_FILE"
}

sync_ntp(){
	# START_TIME=$(date +%Y/%m/%d-%X)
	echo_date "尝试从ntp服务器：ntp1.aliyun.com 同步时间..."
	ntpclient -h ntp1.aliyun.com -i3 -l -s >/tmp/ali_ntp.txt 2>&1
	SYNC_TIME=$(cat /tmp/ali_ntp.txt|grep -E "\[ntpclient\]"|grep -Eo "[0-9]+"|head -n1)
	if [ -n "${SYNC_TIME}" ];then
		SYNC_TIME=$(date +%Y/%m/%d-%X @${SYNC_TIME})
		echo_date "完成！时间同步为：${SYNC_TIME}"
	else
		echo_date "时间同步失败，跳过！"
	fi
}
fun_nat_start(){
	if [ "${frps_enable}" == "1" ];then
		if [ ! -L "/koolshare/init.d/N95Frps.sh" ];then
			echo_date "添加nat-start触发..."
			ln -sf /koolshare/scripts/frps_config.sh /koolshare/init.d/N95Frps.sh
		fi
	else
		if [ -L "/koolshare/init.d/N95Frps.sh" ];then
			echo_date "删除nat-start触发..."
			rm -rf /koolshare/init.d/N95Frps.sh >/dev/null 2>&1
		fi
	fi
}
onstart() {
	# 插件开启的时候同步一次时间
	if [ "${frps_enable}" == "1" -a -n "$(which ntpclient)" ];then
		sync_ntp
	fi

	# 关闭frps进程
	if [ -n "$(pidof frps)" ];then
		echo_date "关闭当前frps进程..."
		killall frps >/dev/null 2>&1
	fi
	
	# 插件安装的时候移除frps_client_version，插件第一次运行的时候设置一次版本号即可
	if [ -z "${frps_client_version}" ];then
		dbus set frps_client_version=$(/koolshare/bin/frps --version)
		frps_client_version=$(/koolshare/bin/frps --version)
	fi
	echo_date "当前插件frps主程序版本号：${frps_client_version}"

	# frps配置文件
	echo_date "生成frps配置文件到 /koolshare/configs/frps.ini"
	cat >${INI_FILE} <<-EOF
	# [common] is integral section
	[common]
	# A literal address or host name for IPv6 must be enclosed
	# in square brackets, as in "[::1]:80", "[ipv6-host]:http" or "[ipv6-host%zone]:80"
	bind_addr = 0.0.0.0
	bind_port = ${frps_common_bind_port}
	# udp port used for kcp protocol, it can be same with 'bind_port'
	# if not set, kcp is disabled in frps
	kcp_bind_port = ${frps_common_bind_port}
	# if you want to configure or reload frps by dashboard, dashboard_port must be set
	dashboard_port = ${frps_common_dashboard_port}
	# dashboard user and pwd for basic auth protect, if not set, both default value is admin
	dashboard_user = ${frps_common_dashboard_user}
	dashboard_pwd = ${frps_common_dashboard_pwd}
	
	vhost_http_port = ${frps_common_vhost_http_port}
	vhost_https_port = ${frps_common_vhost_https_port}
	# console or real logFile path like ./frps.log
	log_file = ${frps_common_log_file}
	# debug, info, warn, error
	log_level = ${frps_common_log_level}
	log_max_days = ${frps_common_log_max_days}
	# if you enable privilege mode, frpc can create a proxy without pre-configure in frps when privilege_token is correct
	token = ${frps_common_privilege_token}
	# only allow frpc to bind ports you list, if you set nothing, there won't be any limit
	#allow_ports = 1-65535
	# pool_count in each proxy will change to max_pool_count if they exceed the maximum value
	max_pool_count = ${frps_common_max_pool_count}
	tcp_mux = ${frps_common_tcp_mux}
	
	EOF

	# 定时任务
	if [ "${frps_common_cron_time}" == "0" ]; then
		cru d frps_monitor >/dev/null 2>&1
	else
		if [ "${frps_common_cron_hour_min}" == "min" ]; then
			echo_date "设置定时任务：每隔${frps_common_cron_time}分钟注册一次frps服务..."
			cru a frps_monitor "*/"${frps_common_cron_time}" * * * * /bin/sh /koolshare/scripts/frps_config.sh"
		elif [ "${frps_common_cron_hour_min}" == "hour" ]; then
			echo_date "设置定时任务：每隔${frps_common_cron_time}小时注册一次frps服务..."
			cru a frps_monitor "0 */"${frps_common_cron_time}" * * * /bin/sh /koolshare/scripts/frps_config.sh"
		fi
		echo_date "定时任务设置完成！"
	fi

	# 开启frps
	if [ "$frps_enable" == "1" ]; then
		echo_date "启动frps主程序..."
		export GOGC=40
		start-stop-daemon -S -q -b -m -p /var/run/frps.pid -x /koolshare/bin/frps -- -c ${INI_FILE}

		local FRPSPID
		local i=10
		until [ -n "$FRPSPID" ]; do
			i=$(($i - 1))
			FRPSPID=$(pidof frps)
			if [ "$i" -lt 1 ]; then
				echo_date "frps进程启动失败！"
				echo_date "可能是内存不足造成的，建议使用虚拟内存后重试！"
				close_in_five
			fi
			usleep 250000
		done
		echo_date "frps启动成功，pid：${FRPSPID}"
		fun_nat_start
		open_port
	else
		stop
	fi
	echo_date "frps插件启动完毕，本窗口将在5s内自动关闭！"
}
check_port(){
	local prot=$1
	local port=$2
	local open=$(iptables -S -t filter | grep INPUT | grep dport | grep ${prot} | grep ${port})
	if [ -n "${open}" ];then
		echo 0
	else
		echo 1
	fi
}
open_port(){
	local t_port
	local u_port
	[ "$(check_port tcp ${frps_common_vhost_http_port})" == "1" ] && iptables -I INPUT -p tcp --dport ${frps_common_vhost_http_port} -j ACCEPT >/tmp/ali_ntp.txt 2>&1 && t_port="${frps_common_vhost_http_port}"
	[ "$(check_port tcp ${frps_common_vhost_https_port})" == "1" ] && iptables -I INPUT -p tcp --dport ${frps_common_vhost_https_port} -j ACCEPT >/tmp/ali_ntp.txt 2>&1 && t_port="${t_port} ${frps_common_vhost_https_port}"
	[ "$(check_port tcp ${frps_common_bind_port})" == "1" ] && iptables -I INPUT -p tcp --dport ${frps_common_bind_port} -j ACCEPT >/tmp/ali_ntp.txt 2>&1 && t_port="${t_port} ${frps_common_bind_port}"
	[ "$(check_port tcp ${frps_common_dashboard_port})" == "1" ] && iptables -I INPUT -p tcp --dport ${frps_common_dashboard_port} -j ACCEPT >/tmp/ali_ntp.txt 2>&1 && t_port="${t_port} ${frps_common_dashboard_port}"
	[ "$(check_port udp ${frps_common_vhost_http_port})" == "1" ] && iptables -I INPUT -p udp --dport ${frps_common_vhost_http_port} -j ACCEPT >/tmp/ali_ntp.txt 2>&1 && u_port="${frps_common_vhost_http_port}"
	[ "$(check_port udp ${frps_common_vhost_https_port})" == "1" ] && iptables -I INPUT -p udp --dport ${frps_common_vhost_https_port} -j ACCEPT >/tmp/ali_ntp.txt 2>&1 && u_port="${u_port} ${frps_common_vhost_https_port}"
	[ "$(check_port udp ${frps_common_bind_port})" == "1" ] && iptables -I INPUT -p udp --dport ${frps_common_bind_port} -j ACCEPT >/tmp/ali_ntp.txt 2>&1 && u_port="${u_port} ${frps_common_bind_port}"
	[ "$(check_port udp ${frps_common_dashboard_port})" == "1" ] && iptables -I INPUT -p udp --dport ${frps_common_dashboard_port} -j ACCEPT >/tmp/ali_ntp.txt 2>&1 && u_port="${u_port} ${frps_common_dashboard_port}"
	[ -n "${t_port}" ] && echo_date "开启TCP端口：${t_port}"
	[ -n "${u_port}" ] && echo_date "开启UDP端口：${u_port}"
}
close_port(){
	local t_port
	local u_port
	[ "$(check_port tcp ${frps_common_vhost_http_port})" == "0" ] && iptables -D INPUT -p tcp --dport ${frps_common_vhost_http_port} -j ACCEPT >/dev/null 2>&1 && t_port="${frps_common_vhost_http_port}"
	[ "$(check_port tcp ${frps_common_vhost_https_port})" == "0" ] && iptables -D INPUT -p tcp --dport ${frps_common_vhost_https_port} -j ACCEPT >/dev/null 2>&1 && t_port="${t_port} ${frps_common_vhost_https_port}"
	[ "$(check_port tcp ${frps_common_bind_port})" == "0" ] && iptables -D INPUT -p tcp --dport ${frps_common_bind_port} -j ACCEPT >/dev/null 2>&1 && t_port="${t_port} ${frps_common_bind_port}"
	[ "$(check_port tcp ${frps_common_dashboard_port})" == "0" ] && iptables -D INPUT -p tcp --dport ${frps_common_dashboard_port} -j ACCEPT >/dev/null 2>&1 && t_port="${t_port} ${frps_common_dashboard_port}"
	[ "$(check_port udp ${frps_common_vhost_http_port})" == "0" ] && iptables -D INPUT -p udp --dport ${frps_common_vhost_http_port} -j ACCEPT >/dev/null 2>&1 && u_port="${frps_common_vhost_http_port}"
	[ "$(check_port udp ${frps_common_vhost_https_port})" == "0" ] && iptables -D INPUT -p udp --dport ${frps_common_vhost_https_port} -j ACCEPT >/dev/null 2>&1 && u_port="${u_port} ${frps_common_vhost_https_port}"
	[ "$(check_port udp ${frps_common_bind_port})" == "0" ] && iptables -D INPUT -p udp --dport ${frps_common_bind_port} -j ACCEPT >/dev/null 2>&1 && u_port="${u_port} ${frps_common_bind_port}"
	[ "$(check_port udp ${frps_common_dashboard_port})" == "0" ] && iptables -D INPUT -p udp --dport ${frps_common_dashboard_port} -j ACCEPT >/dev/null 2>&1 && u_port="${u_port} ${frps_common_dashboard_port}"
	[ -n "${t_port}" ] && echo_date "关闭TCP端口：${t_port}"
	[ -n "${u_port}" ] && echo_date "关闭UDP端口：${u_port}"
}
close_in_five() {
	echo_date "插件将在5秒后自动关闭！！"
	local i=5
	while [ $i -ge 0 ]; do
		sleep 1
		echo_date $i
		let i--
	done
	dbus set ss_basic_enable="0"
	disable_ss >/dev/null
	echo_date "插件已关闭！！"
	unset_lock
	exit
}
stop() {
	# 关闭frps进程
	if [ -n "$(pidof frps)" ];then
		echo_date "停止frps主进程，pid：$(pidof frps)"
		killall frps >/dev/null 2>&1
	fi

	if [ -n "$(cru l|grep frps_monitor)" ];then
		echo_date "删除定时任务..."
		cru d frps_monitor >/dev/null 2>&1
	fi

	if [ -L "/koolshare/init.d/N95Frps.sh" ];then
		echo_date "删除nat触发..."
   		rm -rf /koolshare/init.d/N95Frps.sh >/dev/null 2>&1
   	fi

    close_port
}

case $1 in
start)
	set_lock
	if [ "${frps_enable}" == "1" ]; then
		logger "[软件中心]: 启动frps！"
		onstart
	fi
	unset_lock
	;;
restart)
	set_lock
	if [ "${frps_enable}" == "1" ]; then
		stop
		onstart
	fi
	unset_lock
	;;
stop)
	set_lock
	stop
	unset_lock
	;;
start_nat)
	set_lock
	if [ "${frps_enable}" == "1" ]; then
		onstart
	fi
	unset_lock
	;;
esac

case $2 in
web_submit)
	set_lock
	http_response "$1"
	if [ "${frps_enable}" == "1" ]; then
		stop | tee -a $LOG_FILE
		onstart | tee -a $LOG_FILE
	else
		stop | tee -a $LOG_FILE
	fi
	echo XU6J03M6 | tee -a $LOG_FILE
	unset_lock
	;;
esac
