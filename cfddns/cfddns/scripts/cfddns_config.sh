#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export cfddns`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
CONFIG_FILE="/tmp/cfddns_status.json"
LOG_FILE="/tmp/upload/cfddns_log.txt"
LOGTIME=$(TZ=UTC-8 date -R "+%Y-%m-%d %H:%M:%S")
IPv4Regex="^(25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})(.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})){3}$"
IPv6Regex="^(([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]).){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]).){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$"

[ "$cfddns_ttl" = "" ] && cfddns_ttl="1"

if [ "$cfddns_name" = "@" ];then
	cfddns_name_domain=$cfddns_domain
else
	cfddns_name_domain=$cfddns_name.$cfddns_domain
fi

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
	curl -kLsX GET "https://api.cloudflare.com/client/v4/zones/${cfddns_zid}/dns_records?type=${record_type}&name=${cfddns_name_domain}&order=type&direction=desc&match=all" \
	-H "X-Auth-Email: ${cfddns_email}" \
	-H "X-Auth-Key: ${cfddns_akey}" \
	-H "Content-type: application/json"
}

update_record() {
	curl -kLsX PUT "https://api.cloudflare.com/client/v4/zones/${cfddns_zid}/dns_records/${cfddns_id}" \
	-H "X-Auth-Email: ${cfddns_email}" \
	-H "X-Auth-Key: ${cfddns_akey}" \
	-H "Content-Type: application/json" \
	--data '{"type":"'${record_type}'","name":"'${cfddns_name_domain}'","content":"'${update_to_ip}'","ttl":'${cfddns_ttl}',"proxied":'$(get_bol)'}'
}

get_info(){
	cfddns_result=`get_record_response`
	if [ $(echo $cfddns_result | grep -c "\"success\":true") -gt 0 ];then
		# CFDDNS的RECORD ID
		cfddns_id=`echo $cfddns_result | awk -F"","" '{print $1}' | sed 's/{.*://g' | sed 's/\"//g'`
		# CFDDNS的RECORD IP
		record_ip=`echo $cfddns_result | awk -F"","" '{print $6}' | sed -e 's/\"//g' -e 's/content://'`
		echo_date CloudFlare IP${ip_type}为 $record_ip
	else
		dbus set cfddns_status_${ip_type}="【$LOGTIME】：获取IP${ip_type}解析记录错误！"
		exit 1
	fi
	
	localip=`$cfddns_method` 2>&1
	if [ $(echo $localip | grep -Ec $IPv4Regex) -gt 0 -o $(echo $localip | grep -Ec $IPv6Regex) -gt 0 ];then 
		echo_date 本地IP${ip_type}为 $localip
	else
		dbus set cfddns_status_${ip_type}="【$LOGTIME】：获取本地IP${ip_type}错误！"
		exit 1
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
	if [ $1 -eq 4 ];then
		record_type="A"
		ip_type="v4"
		cfddns_method=$cfddns_method_v4
		[ "cfddns_method" == "" ] && cfddns_method="curl -s --interface ppp0 v4.ipip.net"
	else
		record_type="AAAA"
		cfddns_method=$cfddns_method_v6
		[ "cfddns_method" == "" ] && cfddns_method="curl -s --interface ppp0 v6.ipip.net"
		ip_type="v6"
	fi
	echo_date "CloudFlare DDNS更新启动!"
	get_info
	if [ "$localip" == "$record_ip" ];then
		echo_date 两个IP${ip_type}相同，跳过更新！
		dbus set cfddns_status_${ip_type}="【$LOGTIME】：IP${ip_type}地址：$localip 未发生变化，跳过！"
	else
		update_to_ip=$localip
		echo_date 两个IP${ip_type}不相同，开始更新！
		update_ip
		dbus set cfddns_status_${ip_type}="【$LOGTIME】：IP${ip_type}地址：$localip 更新成功！"
	fi
	echo_date "======================================"
}
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
		check_update 4 >> $LOG_FILE
		if [ "$cfddns_ipv6" == "1" ];then
			check_update 6 >> $LOG_FILE
		fi
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
		check_update 4 >> $LOG_FILE
		if [ "$cfddns_ipv6" == "1" ];then
			check_update 6 >> $LOG_FILE
		fi
	else
		echo_date "关闭CloudFlare DDNS!" >> $LOG_FILE
		stop_cfddns
	fi
	echo XU6J03M6 >> $LOG_FILE
	;;
esac
