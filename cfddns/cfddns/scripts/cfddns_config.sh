#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export cfddns`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
CONFIG_FILE="/tmp/cfddns_status.json"
LOG_FILE="/tmp/upload/cfddns_log.txt"
LOGTIME=$(TZ=UTC-8 date -R "+%Y-%m-%d %H:%M:%S")
MAX_RECORDS=10
IPv4Regex="^(25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})(.(25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})){3}$"
IPv6Regex="^(([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]).){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]).){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$"

[ "$cfddns_ttl" = "" ] && cfddns_ttl="1"
[ "$cfddns_method_v4" = "" ] && cfddns_method_v4="curl ifconfig.me"
[ "$cfddns_method_v6" = "" ] && cfddns_method_v6="curl -6 ifconfig.me"

trim_text(){
	echo "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

build_fqdn(){
	if [ "$1" = "@" ];then
		echo "$2"
	else
		echo "$1.$2"
	fi
}

append_status_line(){
	if [ -z "$1" ];then
		return
	fi
	if [ -z "$status_lines" ];then
		status_lines="$1"
	else
		status_lines="${status_lines}<br>$1"
	fi
}

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
	local current_fqdn="$1"
	curl -kLsG "https://api.cloudflare.com/client/v4/zones/${cfddns_zid}/dns_records" \
	-H "Authorization: Bearer ${cfddns_akey}" \
	-H "Content-type: application/json" \
	--data-urlencode "type=${record_type}" \
	--data-urlencode "name=${current_fqdn}" \
	--data-urlencode "order=type" \
	--data-urlencode "direction=desc" \
	--data-urlencode "match=all"
}

update_record() {
	local current_fqdn="$1"
	curl -kLsX PUT "https://api.cloudflare.com/client/v4/zones/${cfddns_zid}/dns_records/${cfddns_id}" \
	-H "Authorization: Bearer ${cfddns_akey}" \
	-H "Content-Type: application/json" \
	--data '{"type":"'${record_type}'","name":"'${current_fqdn}'","content":"'${update_to_ip}'","ttl":'${cfddns_ttl}',"proxied":'$(get_bol)'}'
}

get_info(){
	local current_fqdn="$1"
	cfddns_result=`get_record_response "$current_fqdn"`
	if [ $(echo "$cfddns_result" | grep -c "\"success\":true") -gt 0 ];then
		if [ $(echo "$cfddns_result" | grep -c "\"result\":\\[\\]") -gt 0 ];then
			record_error="【$LOGTIME】：${current_fqdn} 未找到IP${ip_type}解析记录！"
			return 1
		fi
		# CFDDNS的RECORD ID
		cfddns_id=`echo "$cfddns_result" | grep -o '"id":"[^"]*"' | head -n1 | cut -d'"' -f4`
		# CFDDNS的RECORD IP
		record_ip=`echo "$cfddns_result" | grep -o '"content":"[^"]*"' | head -n1 | cut -d'"' -f4`
		if [ -z "$cfddns_id" -o -z "$record_ip" -o $(echo "$cfddns_id" | grep -Ec '^[0-9a-fA-F]{32}$') -eq 0 ];then
			record_error="【$LOGTIME】：${current_fqdn} 获取IP${ip_type}解析记录错误！"
			return 1
		fi
		echo_date "${current_fqdn} CloudFlare IP${ip_type}为 $record_ip"
	else
		record_error="【$LOGTIME】：${current_fqdn} 获取IP${ip_type}解析记录错误！"
		return 1
	fi

	localip_raw=`$cfddns_method` 2>&1
	if [ "$ip_type" = "v4" ];then
		localip=`echo "$localip_raw" | tr '\r\t ' '\n\n\n' | grep -E "$IPv4Regex" | head -n1`
	else
		localip=`echo "$localip_raw" | tr '\r\t ' '\n\n\n' | grep -E "$IPv6Regex" | head -n1`
	fi
	if [ -n "$localip" ];then
		echo_date "${current_fqdn} 本地IP${ip_type}为 $localip"
	else
		echo_date "${current_fqdn} 获取本地IP${ip_type}错误，命令：$cfddns_method"
		echo_date "${current_fqdn} 命令输出：$localip_raw"
		record_error="【$LOGTIME】：${current_fqdn} 获取本地IP${ip_type}错误！"
		return 1
	fi
}

update_ip(){
	local current_fqdn="$1"
	update_result=`update_record "$current_fqdn"`
	if [ $(echo "$update_result" | grep -c "\"success\":true") -gt 0 ];then
		echo_date "${current_fqdn} 更新成功！"
	else
		echo_date "${current_fqdn} 更新失败!请检查设置！"
		echo "$update_result"
		record_error="【$LOGTIME】：${current_fqdn} 更新失败！请检查设置！"
		return 1
	fi
}

check_update(){
	local update_target=$1
	local current_fqdn="$2"
	record_status_line=""
	if [ "$update_target" -eq 4 ];then
		record_type="A"
		ip_type="v4"
		cfddns_method=$cfddns_method_v4
		[ "$cfddns_method" = "" ] && cfddns_method="curl ifconfig.me"
	else
		record_type="AAAA"
		cfddns_method=$cfddns_method_v6
		[ "$cfddns_method" = "" ] && cfddns_method="curl -6 ifconfig.me"
		ip_type="v6"
	fi
	echo_date "${current_fqdn} CloudFlare DDNS更新启动!"
	if ! get_info "$current_fqdn"; then
		echo_date "$record_error"
		record_status_line="$record_error"
		echo_date "======================================"
		return 1
	fi
	if [ "$localip" = "$record_ip" ];then
		echo_date "${current_fqdn} 两个IP${ip_type}相同，跳过更新！"
		record_status_line="【$LOGTIME】：${current_fqdn} IP${ip_type}地址：$localip 未发生变化，跳过！"
	else
		update_to_ip=$localip
		echo_date "${current_fqdn} 两个IP${ip_type}不相同，开始更新！"
		if update_ip "$current_fqdn"; then
			record_status_line="【$LOGTIME】：${current_fqdn} IP${ip_type}地址：$localip 更新成功！"
		else
			record_status_line="$record_error"
		fi
	fi
	echo_date "======================================"
}

run_updates_for_ip(){
	local update_target=$1
	local records_raw
	local records_count=0
	local records_overflow=0
	local record_name
	local record_domain
	local record_fqdn
	records_raw=$(printf '%b' "$cfddns_records" | tr '\r' '\n' | sed '/^[[:space:]]*$/d')
	status_lines=""
	if [ -z "$records_raw" ];then
		status_lines="【$LOGTIME】：未配置域名记录！"
		if [ "$update_target" -eq 4 ];then
			dbus set cfddns_status_v4="$status_lines"
		else
			dbus set cfddns_status_v6="$status_lines"
		fi
		echo_date "未配置域名记录，跳过IP${update_target}更新！"
		return 1
	fi

	while IFS='|' read -r record_name record_domain; do
		[ -z "$record_name$record_domain" ] && continue
		records_count=$((records_count + 1))
		if [ "$records_count" -gt "$MAX_RECORDS" ];then
			records_overflow=1
			break
		fi

		record_name=$(trim_text "$record_name")
		record_domain=$(trim_text "$record_domain")
		if [ -z "$record_name" -o -z "$record_domain" ];then
			echo_date "第${records_count}组域名记录格式错误，已跳过！"
			append_status_line "【$LOGTIME】：第${records_count}组域名记录格式错误，已跳过！"
			continue
		fi

		record_fqdn=$(build_fqdn "$record_name" "$record_domain")
		check_update "$update_target" "$record_fqdn"
		append_status_line "$record_status_line"
	done <<EOF
$records_raw
EOF

	if [ "$records_overflow" -eq 1 ];then
		echo_date "记录超过${MAX_RECORDS}组，超出部分已忽略！"
		append_status_line "【$LOGTIME】：记录超过${MAX_RECORDS}组，超出部分已忽略。"
	fi

	if [ -z "$status_lines" ];then
		status_lines="【$LOGTIME】：未找到有效域名记录！"
	fi

	if [ "$update_target" -eq 4 ];then
		dbus set cfddns_status_v4="$status_lines"
	else
		dbus set cfddns_status_v6="$status_lines"
	fi
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
		run_updates_for_ip 4 >> $LOG_FILE
		if [ "$cfddns_ipv6" == "1" ];then
			run_updates_for_ip 6 >> $LOG_FILE
		fi
	else
		logger "[软件中心]: CloudFlare DDNS未设置开机启动，跳过！"
	fi
	;;
update)
	if [ "$cfddns_enable" == "1" ];then
		echo_date "======================================" >> $LOG_FILE
		run_updates_for_ip 4 >> $LOG_FILE
		if [ "$cfddns_ipv6" == "1" ];then
			run_updates_for_ip 6 >> $LOG_FILE
		fi
	else
		echo_date "CloudFlare DDNS未启用，跳过更新！" >> $LOG_FILE
	fi
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
		run_updates_for_ip 4 >> $LOG_FILE
		if [ "$cfddns_ipv6" == "1" ];then
			run_updates_for_ip 6 >> $LOG_FILE
		fi
	else
		echo_date "关闭CloudFlare DDNS!" >> $LOG_FILE
		stop_cfddns
	fi
	echo XU6J03M6 >> $LOG_FILE
	;;
esac
