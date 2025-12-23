#!/bin/sh

eval `dbus export frpc_`
. /koolshare/scripts/base.sh
mkdir -p /tmp/upload

NAME=frpc
BIN=/koolshare/bin/frpc
INI_FILE=/tmp/upload/.frpc.ini
STCP_INI_FILE=/tmp/upload/.frpc_stcp.ini
PID_FILE=/var/run/frpc.pid
lan_ip=`nvram get lan_ipaddr`
lan_port="80"
ddns_flag=false

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
		if [ "$(dbus get frpc_customize_conf)" = "1" ]; then
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
			cat >"${INI_FILE}" <<-EOF
				# frpc configuration
				[common]
				server_addr = ${frpc_common_server_addr}
				server_port = ${frpc_common_server_port}
				token = ${frpc_common_privilege_token}
				log_file = ${frpc_common_log_file}
				log_level = ${frpc_common_log_level}
				log_max_days = ${frpc_common_log_max_days}
				tcp_mux = ${frpc_common_tcp_mux}
				protocol = ${frpc_common_protocol}
				login_fail_exit = ${frpc_common_login_fail_exit}
				user = ${frpc_common_user}
			EOF

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
					token = ${frpc_common_privilege_token}
				EOF
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
							server_name = ${frpc_common_user}.${array_subname}
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
		killall frpc >/dev/null 2>&1 || true
		sleep 1
		export GOGC=40
		start-stop-daemon -S -q -b -m -p "${PID_FILE}" -x "${BIN}" -- -c "${INI_FILE}"
	else
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
fun_ddns_stop(){
	nvram unset ddns_hostname_x
    nvram set ddns_enable_x=0
    nvram commit
}
fun_ddns_start(){
    # ddns setting
    if [ "${frpc_enable}"x = "1"x ];then
        # ddns setting
        if [ "${frpc_common_ddns}" = "1" ] && [ -n "${frpc_domain}" ]; then
            nvram set ddns_enable_x=1
            nvram set ddns_hostname_x=${frpc_domain}
            ddns_custom_updated 1
            nvram commit
        elif [ "${frpc_common_ddns}" = "2" ]; then
            echo "ddns no setting"
        else
            fun_ddns_stop
        fi
    else
        fun_ddns_stop
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
    fun_ddns_start
    ;;
start_nat)
    fun_ntp_sync
    fun_start_stop
    fun_crontab
    fun_ddns_start
    ;;
esac

# for web submit
case $2 in
1)
	fun_ntp_sync
	fun_start_stop
	fun_nat_start
	fun_crontab
	fun_ddns_start
	http_response "$1"
    ;;
esac
