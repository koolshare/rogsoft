#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export cfddns`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
CONFIG_FILE="/tmp/cfddns_status.json"
LOG_FILE="/tmp/upload/cfddns_log.txt"
LOGTIME=$(TZ=UTC-8 date -R "+%Y-%m-%d %H:%M:%S")
[ "$cfddns_method" = "" ] && cfddns_method="curl -s --interface ppp0 whatismyip.akamai.com"
[ "$cfddns_ttl" = "" ] && cfddns_ttl="1"
get_type="A"

get_bol() {
	case "$cfddns_proxied" in
		1)
			echo "true"
		;;
		0|*)
			echo "false"
		;;
	esac
}

get_record_response() {
	curl -kLsX GET "https://api.cloudflare.com/client/v4/zones/$cfddns_zid/dns_records?type=$get_type&name=$cfddns_name.$cfddns_domain&order=type&direction=desc&match=all" \
	-H "X-Auth-Email: $cfddns_email" \
	-H "X-Auth-Key: $cfddns_akey" \
	-H "Content-type: application/json"
}

update_record() {
	curl -kLsX PUT "https://api.cloudflare.com/client/v4/zones/$cfddns_zid/dns_records/$cfddns_id" \
	-H "X-Auth-Email: $cfddns_email" \
	-H "X-Auth-Key: $cfddns_akey" \
	-H "Content-Type: application/json" \
	--data '{"id":"'$cfddns_id'","type":"'$get_type'","name":"'$cfddns_name.$cfddns_domain'","content":"'$update_to_ip'","zone_id":"'$cfddns_zid'","zone_name":"'$cfddns_domain'","ttl":'$cfddns_ttl',"proxied":'$(get_bol)'}'
}

get_info(){
	get_type="A"
	cfddns_result=`get_record_response`
	if [ $(echo $cfddns_result | grep -c "\"success\":true") -gt 0 ];then
		# CFDDNS的A记录ID
		cfddns_id=`echo $cfddns_result | awk -F"","" '{print $1}' | sed 's/{.*://g' | sed 's/\"//g'`
		# CFDDNS的A记录IP
		current_ip=`echo $cfddns_result | awk -F"","" '{print $4}' | grep -oE '([0-9]{1,3}\.?){4}'`
		echo_date CloudFlare IP为 $current_ip
	else
		dbus set cfddns_status="【$LOGTIME】：获取IPV4解析记录错误！"
		exit 1
	fi
	
	localip=`$cfddns_method 2>&1`
	if [ $(echo $localip | grep -c "^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}$") -gt 0 ];then 
		echo_date 本地IP为 $localip
	else
		dbus set cfddns_status="【$LOGTIME】：获取本地IP错误！"
		exit 1
	fi
}

get_local_ipv6(){
	localipv6=`curl -s http://v4v6.ipv6-test.com/json/defaultproto.php | grep -oE '([a-f0-9]{1,4}(:[a-f0-9]{1,4}){7}|[a-f0-9]{1,4}(:[a-f0-9]{1,4}){0,7}::[a-f0-9]{0,4}(:[a-f0-9]{1,4}){0,7})' 2>&1`
}

get_info_ipv6(){
	get_type="AAAA"
	get_local_ipv6
	if [ "$localipv6" != "" ];then 
		echo_date 本地IP为 $localipv6
		# CFDDNS返回的JSON结果
		cfddns_result=`get_record_response`
		if [ $(echo $cfddns_result | grep -c "\"success\":true") -gt 0 ];then 
			# CFDDNS的AAAA记录ID
			cfddns_id=`echo $cfddns_result | awk -F"","" '{print $1}' | sed 's/{.*://g' | sed 's/\"//g'`
			# CFDDNS的AAAA记录IP
			current_ipv6=`echo $cfddns_result | awk -F"","" '{print $4}' | grep -oE '([a-f0-9]{1,4}(:[a-f0-9]{1,4}){7}|[a-f0-9]{1,4}(:[a-f0-9]{1,4}){0,7}::[a-f0-9]{0,4}(:[a-f0-9]{1,4}){0,7})'`
			echo_date CfddsnIP为 $current_ipv6
		else
			dbus set cfddns_status="【$LOGTIME】：获取IPV6解析记录错误！"
			exit 1
		fi
	else
		echo_date 没有IPV6地址！
	fi
}

update_ip(){
	update_result=`update_record`
	if [ $(echo $update_result | grep -c "\"success\":true") -gt 0 ];then 
		echo_date 更新成功！
	else
		echo_date 更新失败!请检查设置！
		echo $update_result
		exit 1
	fi
}

check_update(){
	echo_date "CloudFlare DDNS更新启动!"
	get_info
	if [ "$localip" == "$current_ip" ];then
		echo_date 两个IP相同，跳过更新！
		dbus set cfddns_status="【$LOGTIME】：IP地址：$localip 未发生变化，跳过！"
	else
		update_to_ip=$localip
		echo_date 两个IP不相同，开始更新！
		update_ip
		dbus set cfddns_status="【$LOGTIME】：IP地址：$localip 更新成功！"
	fi
	
	# if [ "$cfddns_ipv6" == "1" ];then
	# 	get_info_ipv6
	# 	if [ "$localipv6" == "$current_ipv6" ];then
	# 		echo_date 两个IPV6相同，跳过更新！
	# 	else
	# 		update_to_ip=$localipv6
	# 		echo_date 两个IPV6不相同，开始更新！
	# 		update_ip
	# 	fi
	# fi
	echo_date "======================================"
}

# add_cfddns_cru(){
# 	sed -i '/cfddns/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
# 	cru a cfddns "0 */$cfddns_refresh_time * * * /koolshare/scripts/cfddns_config.sh update"
# }
# 
# stop_cfddns(){
# 	sed -i '/cfddns/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
# }

# ====================================used by init or cru====================================
case $1 in
start)
	#此处为开机自启，wan重启动设计
	if [ "$cfddns_enable" == "1" ];then
		logger "[软件中心]: 启动CloudFlare DDNS！"

		until [ $(date +%Y) -gt 2018 ]
		do
			sleep 1
		done
		
		echo_date "======================================" >> $LOG_FILE
		echo_date "检测到网络拨号..." >> $LOG_FILE
		check_update >> $LOG_FILE
	else
		logger "[软件中心]: CloudFlare DDNS未设置开机启动，跳过！"
	fi
	;;
update)
	check_update >> $LOG_FILE
	;;
esac
# ====================================submit by web====================================
case $2 in
1)
	#此处为web提交动设计
	echo "" > $LOG_FILE
	http_response "$1"
	if [ "$cfddns_enable" == "1" ];then
		[ ! -L "/koolshare/init.d/S99cfddns.sh" ] && ln -sf /koolshare/scripts/cfddns_config.sh /koolshare/init.d/S99cfddns.sh
		echo_date "======================================" >> $LOG_FILE
		check_update >> $LOG_FILE
	else
		echo_date "关闭CloudFlare DDNS!" >> $LOG_FILE
		stop_cfddns
	fi
	echo XU6J03M6 >> $LOG_FILE
	;;
esac