#!/bin/sh

eval `dbus export frpc_`
. /koolshare/scripts/base.sh
mkdir -p /tmp/upload

NAME=frpc
BIN=/koolshare/bin/frpc
INI_FILE=/tmp/upload/.frpc.ini
STCP_INI_FILE=/tmp/upload/.frpc_stcp.ini
PID_FILE=/var/run/frpc.pid
SUBMIT_LOG_FILE=/tmp/upload/frpc_submit_log.txt
lan_ip=`nvram get lan_ipaddr`
lan_port="80"

router_model="$(nvram get odmpid 2>/dev/null)"
[ -z "${router_model}" ] && router_model="$(nvram get productid 2>/dev/null)"

submit_log(){
	[ "${FRPC_SUBMIT}" = "1" ] && echo_date "$@"
}

check_ini_file(){
	[ -s "${INI_FILE}" ] || return 1
	grep -q "\[common\]" "${INI_FILE}" || return 1
	grep -q "server_addr" "${INI_FILE}" || return 1
	grep -q "server_port" "${INI_FILE}" || return 1
	return 0
}

fun_ntp_sync(){
	ntp_server="$(nvram get ntp_server0)"
	start_time="$(date +%Y%m%d)"
	ntpclient -h "${ntp_server}" -i3 -l -s >/dev/null 2>&1
	if [ "${start_time}" = "$(date +%Y%m%d)" ]; then
		ntpclient -h ntp1.aliyun.com -i3 -l -s >/dev/null 2>&1
	fi
}
fun_start_stop(){
	dbus set frpc_client_version="$(${BIN} --version 2>/dev/null)"
	if [ "${frpc_enable}" = "1" ]; then
		is_custom="$(dbus get frpc_customize_conf 2>/dev/null)"
		submit_log "生成配置文件到 ${INI_FILE}"
		if [ "${is_custom}" = "1" ]; then
			_frpc_customize_conf="$(dbus get frpc_config | base64_decode 2>/dev/null)"
			if [ -z "${_frpc_customize_conf}" ]; then
				_frpc_customize_conf="# empty custom config"
			fi
			cat >"${INI_FILE}" <<-EOF
				# frpc custom configuration
				${_frpc_customize_conf}
			EOF
		else
			stcp_en="$(dbus list frpc_proto_node | grep stcp)"
			common_user="${frpc_common_user}"
			if [ -z "${common_user}" ]; then
				common_user="${router_model}"
			fi
			cat >"${INI_FILE}" <<-EOF
				# frpc configuration
				[common]
				server_addr = ${frpc_common_server_addr}
				server_port = ${frpc_common_server_port}
				log_file = ${frpc_common_log_file}
				log_level = ${frpc_common_log_level}
				log_max_days = ${frpc_common_log_max_days}
				tcp_mux = ${frpc_common_tcp_mux}
				protocol = ${frpc_common_protocol}
				user = ${common_user}
			EOF
			if [ -n "${frpc_common_privilege_token}" ]; then
				echo "token = ${frpc_common_privilege_token}" >>"${INI_FILE}"
			fi

			if [ -n "${frpc_common_vhost_http_port}" ]; then
				echo "vhost_http_port = ${frpc_common_vhost_http_port}" >>"${INI_FILE}"
			fi
			if [ -n "${frpc_common_vhost_https_port}" ]; then
				echo "vhost_https_port = ${frpc_common_vhost_https_port}" >>"${INI_FILE}"
			fi
			echo "" >>"${INI_FILE}"

			if [ -n "${stcp_en}" ]; then
				cat >"${STCP_INI_FILE}" <<-EOF
					[common]
					server_addr = ${frpc_common_server_addr}
					server_port = ${frpc_common_server_port}
				EOF
				if [ -n "${frpc_common_privilege_token}" ]; then
					echo "token = ${frpc_common_privilege_token}" >>"${STCP_INI_FILE}"
				fi
			fi

			server_nu="$(dbus list frpc_localhost_node | sort -n -t "_" -k 4 | cut -d "=" -f 1 | cut -d "_" -f 4)"
			for nu in ${server_nu}; do
				array_subname="$(dbus get frpc_subname_node_${nu})"
				array_type="$(dbus get frpc_proto_node_${nu})"
				array_local_ip="$(dbus get frpc_localhost_node_${nu})"
				array_local_port="$(dbus get frpc_localport_node_${nu})"
				array_remote_port="$(dbus get frpc_remoteport_node_${nu})"
				array_custom_domains="$(dbus get frpc_subdomain_node_${nu})"
				array_use_encryption="$(dbus get frpc_encryption_node_${nu})"
				array_use_gzip="$(dbus get frpc_gzip_node_${nu})"

				if [ "${array_type}" = "tcp" ] || [ "${array_type}" = "udp" ]; then
					cat >>"${INI_FILE}" <<-EOF
						[${array_subname}]
						type = ${array_type}
						local_ip = ${array_local_ip}
						local_port = ${array_local_port}
						remote_port = ${array_remote_port}
						use_encryption = ${array_use_encryption}
						use_compression = ${array_use_gzip}
					EOF
				elif [ "${array_type}" = "stcp" ]; then
					cat >>"${INI_FILE}" <<-EOF
						[${array_subname}]
						type = ${array_type}
						sk = ${array_custom_domains}
						local_ip = ${array_local_ip}
						local_port = ${array_local_port}
					EOF
					if [ -n "${stcp_en}" ]; then
						cat >>"${STCP_INI_FILE}" <<-EOF
							[${array_subname}_visitor]
							# frpc role visitor -> frps -> frpc role server
							role = visitor
							type = stcp
							# the server name you want to visit
							server_name = ${common_user}.${array_subname}
							sk = ${array_custom_domains}
							# connect this address to visitor stcp server
							bind_addr = 127.0.0.1
							bind_port = 9000
						EOF
					fi
				else
					cat >>"${INI_FILE}" <<-EOF
						[${array_subname}]
						type = ${array_type}
						local_ip = ${array_local_ip}
						local_port = ${array_local_port}
						remote_port = ${array_remote_port}
						custom_domains = ${array_custom_domains}
						use_encryption = ${array_use_encryption}
						use_compression = ${array_use_gzip}
					EOF
				fi
			done
		fi
		submit_log "配置文件生成成功！"
		submit_log "检查配置文件..."
		if [ "${is_custom}" = "1" ]; then
			if [ -s "${INI_FILE}" ]; then
				submit_log "配置文件检查ok（自定义配置未做完整校验），准备运行..."
			else
				submit_log "配置文件检查失败，请检查配置内容！"
				return 1
			fi
		else
			if check_ini_file; then
				submit_log "配置文件检查ok，准备运行..."
			else
				submit_log "配置文件检查失败，请检查配置内容！"
				return 1
			fi
		fi
		killall frpc >/dev/null 2>&1 || true
		sleep 1
		export GOGC=40
		start-stop-daemon -S -q -b -m -p "${PID_FILE}" -x "${BIN}" -- -c "${INI_FILE}"
	else
		submit_log "准备停止 frpc 服务..."
		killall frpc >/dev/null 2>&1 || true
	fi
}
fun_nat_start(){
    if [ "${frpc_enable}"x = "1"x ];then
		[ ! -L "/koolshare/init.d/N99frpc.sh" ] && ln -sf /koolshare/scripts/frpc_config.sh /koolshare/init.d/N99frpc.sh
    else
        rm -rf /koolshare/init.d/N99frpc.sh >/dev/null 2>&1
    fi
}
fun_crontab(){
    if [ "${frpc_enable}"x = "1"x ];then
        if [ "${frpc_common_cron_time}"x = "0"x ]; then
            cru d frpc_monitor
        else
            if [ "${frpc_common_cron_hour_min}"x = "min"x ]; then
                cru a frpc_monitor "*/"${frpc_common_cron_time}" * * * * /bin/sh /koolshare/scripts/frpc_config.sh start"
            elif [ "${frpc_common_cron_hour_min}"x = "hour"x ]; then
                cru a frpc_monitor "0 */"${frpc_common_cron_time}" * * * /bin/sh /koolshare/scripts/frpc_config.sh start"
            fi
        fi
    else
        cru d frpc_monitor
    fi
}
# =============================================
# this part for start up by post-mount
case $ACTION in
start)
    fun_ntp_sync
    fun_start_stop
    fun_nat_start
    fun_crontab
    ;;
start_nat)
    fun_ntp_sync
    fun_start_stop
    fun_crontab
    ;;
esac

# for web submit
case $2 in
1)
	(
		FRPC_SUBMIT=1
		export FRPC_SUBMIT
		echo_date "开始提交配置..."
		fun_ntp_sync
		if [ "${frpc_enable}" = "1" ]; then
			echo_date "启动 frpc 服务..."
		else
			echo_date "停止 frpc 服务..."
		fi
		fun_start_stop
		fun_nat_start
		fun_crontab
		if [ "${frpc_enable}" = "1" ]; then
			sleep 1
			pid=""
			[ -f "${PID_FILE}" ] && pid="$(cat "${PID_FILE}" 2>/dev/null)"
			if [ -n "${pid}" ] && kill -0 "${pid}" 2>/dev/null; then
				echo_date "frpc 程序启动成功，PID: ${pid}"
				echo "FRPC_RESULT=OK"
			else
				echo_date "frpc 程序启动失败，请检查配置！"
				echo "FRPC_RESULT=FAIL"
			fi
		else
			sleep 1
			if pidof frpc >/dev/null 2>&1; then
				echo_date "frpc 程序停止失败，请稍后重试！"
				echo "FRPC_RESULT=FAIL"
			else
				echo_date "frpc 程序已停止"
				echo "FRPC_RESULT=OK"
			fi
		fi
		echo "XU6J03M16"
	) >"${SUBMIT_LOG_FILE}" 2>&1 &
	http_response "$1"
    ;;
esac
