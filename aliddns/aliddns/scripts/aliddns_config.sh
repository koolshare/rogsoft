#!/bin/sh

source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
eval $(dbus export aliddns_)
LOG_FILE=/tmp/upload/aliddns_log.txt

firmware_ddns_service(){
	if [ "$aliddns_show" == "1" -a "$aliddns_enable" == "1" ];then
		if [ -z "$(nvram get asus_ddns_service)" -o "$(nvram get asus_ddns_service)" == "Aliddns" ]; then
		
			# backup asus ddns servic value
			nvram set ddns_enable_x_bak="$(nvram get ddns_enable_x)"
			nvram set le_enable_bak="$(nvram get le_enable)"
			nvram set ddns_ipcheck_bak="$(nvram get ddns_ipcheck)"
			nvram set ddns_server_x_bak="$(nvram get ddns_server_x)"
			nvram set ddns_hostname_x_bak="$(nvram get ddns_hostname_x)"

			# stop le and asus ddns service
			if [ "$(nvram get le_enable)" == "1" -a  "$(nvram get ddns_enable_x)" == "1" -a "$(nvram get ddns_server_x)" != "CUSTOM" ]; then
				echo_date "Aliddns：停止华硕DDNS服务，稍后路由web服务可能会自动重启！"
				service stop_ddns_le >/dev/null 2>&1
			fi
			if [ "$(nvram get le_enable)" != "1" -a  "$(nvram get ddns_enable_x)" == "1" -a "$(nvram get ddns_server_x)" != "CUSTOM" ]; then
				echo_date "Aliddns：停止华硕DDNS服务！"
				service stop_ddns >/dev/null 2>&1
			fi
			
			# set new value to disable asus ddns service, use custom insted
			[ "$(nvram get ddns_enable_x)" != "1" ] && nvram set ddns_enable_x="1"
			[ "$(nvram get ddns_ipcheck)" != "1" ] && nvram set ddns_ipcheck="1"
			[ "$(nvram get ddns_server_x)" != "CUSTOM" ] && nvram set ddns_server_x="CUSTOM" && echo_date "Aliddns：设置华硕DDNS服务为Custom ！"
			[ "$(nvram get le_enable)" != "0" ] && nvram set le_enable="0" && echo_date "Aliddns：关闭华硕DDNS服务和华硕Let's Encrypt服务 ！"
			case "$aliddns_name" in
				\*)
					[ "$(nvram get ddns_hostname_x)" != "${aliddns_domain}" ] && \
					nvram set ddns_hostname_x="${aliddns_domain}" && \
					echo_date "Aliddns：设置Aliddns域名在【网络地图】首页显示：${aliddns_domain}！"
				;;
				\@)
					[ "$(nvram get ddns_hostname_x)" != "${aliddns_domain}" ] && \
					nvram set ddns_hostname_x="${aliddns_domain}" && \
					echo_date "Aliddns：设置Aliddns域名在【网络地图】首页显示：${aliddns_domain}"
				;;
				*)
					[ "$(nvram get ddns_hostname_x)" != "${aliddns_name}.${aliddns_domain}" ] && \
					nvram set ddns_hostname_x="${aliddns_name}.${aliddns_domain}" && \
					echo_date "Aliddns：设置Aliddns域名在【网络地图】首页显示：${aliddns_name}.${aliddns_domain}"
				;;
			esac

			# set asusddns custom update status ok anyway
			ddns_custom_updated 1

			# set a asus ddns occupy flag, to annoce other ddns plugin
			nvram set asus_ddns_service="Aliddns"
			nvram commit
		else
			echo_date "Aliddns：无法在【网络地图】首页显示DDNS名字，因为$(nvram get asus_ddns_service)正在使用该功能！"
		fi
	elif [ "$aliddns_show" == "1" -a "$aliddns_enable" != "1" ];then
		if [ "$(nvram get asus_ddns_service)" == "Aliddns" ]; then
		
			echo_date "Aliddns：移除Aliddns域名在【网络地图】首页的显示！"
			
			# resote asus ddns servic value if any
			nvram set ddns_enable_x="$(nvram get ddns_enable_x_bak)"
			nvram set ddns_ipcheck="$(nvram get ddns_ipcheck_bak)"
			nvram set ddns_server_x="$(nvram get ddns_server_x_bak)"
			nvram set ddns_hostname_x="$(nvram get ddns_hostname_x_bak)"
			nvram set le_enable="$(nvram get le_enable_bak)"
			nvram commit

			# restart asus ddns service
			if [ "$(nvram get ddns_enable_x)" == "1" -a "$(nvram get ddns_server_x)" != "CUSTOM" -a "$(nvram get le_enable)" != "1" ]; then
				echo_date "Aliddns：恢复固件自带华硕DDNS服务，稍后路由web服务可能会自动重启！"
				service restart_ddns >/dev/null 2>&1
			fi
			if [ "$(nvram get ddns_enable_x)" == "1" -a "$(nvram get ddns_server_x)" != "CUSTOM" -a "$(nvram get le_enable)" == "1" ]; then
				echo_date "Aliddns：恢复固件自带华硕DDNS服务和华硕Let's Encrypt服务，，稍后路由web服务可能会自动重启！"
				service restart_ddns_le >/dev/null 2>&1
			fi
		fi
	fi
}

start_aliddns(){
	echo_date "Aliddns：开启Aliddns服务！"
	
	# prepare
	# firmware_ddns_service

	# try to delete first
	sed -i '/aliddns_checker/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	
	# add cru job
	echo_date "Aliddns：创建Aliddns定时检测任务..."
	cru a aliddns_checker "*/$aliddns_interval * * * * /koolshare/scripts/aliddns_update.sh"

	# start update now
	echo_date "Aliddns：运行aliddns_update.sh，更新DDNS..."
	sh /koolshare/scripts/aliddns_update.sh >/dev/null 2>&1

	# check startup file
	if [ ! -L "/koolshare/init.d/S98Aliddns.sh" ]; then 
		ln -sf /koolshare/scripts/aliddns_config.sh /koolshare/init.d/S98Aliddns.sh
	fi
}

stop_aliddns(){
	# prepare
	# firmware_ddns_service

	# kill crontab job
	jobexist=$(cru l|grep aliddns_checker)
	if [ -n "$jobexist" ];then
		echo_date "Aliddns：删除Aliddns定时检测任务..."
		sed -i '/aliddns_checker/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi

	# remove last state
	echo_date "Aliddns：插件已关闭！"
	dbus remove aliddns_last_act
}

case $1 in
start)
	if [ "$aliddns_enable" == "1" ]; then
		logger "[软件中心]: 启动阿里DDNS！"
		echo_date "======================= Aliddns - WAN拨号触发启动 ========================" | tee -a $LOG_FILE
		start_aliddns | tee -a $LOG_FILE
	else
		logger "[软件中心]: 阿里DDNS未设置开机启动，跳过！"
	fi
	;;
stop)
	stop_aliddns | tee -a $LOG_FILE
	;;
esac

case $2 in
1)
	# submit
	http_response "$1"
	if [ "$aliddns_enable" == "1" ]; then
		echo_date "========================= Aliddns - 手动启动 ========================" | tee -a $LOG_FILE
		start_aliddns | tee -a $LOG_FILE
	else
		echo_date "========================= Aliddns - 关闭 ===========================" | tee -a $LOG_FILE
		stop_aliddns | tee -a $LOG_FILE
	fi
	;;
2)
	# clean log
	echo "" > $LOG_FILE
	http_response "$1"
	;;
esac
