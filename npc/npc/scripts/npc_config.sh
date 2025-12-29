#!/bin/sh

eval "$(dbus export npc_)"
. /koolshare/scripts/base.sh

mkdir -p /tmp/upload

NAME="npc"
BIN="/koolshare/bin/npc"
CONF_FILE="/tmp/upload/.npc.conf"
PID_FILE="/var/run/npc.pid"
LOG_FILE="/tmp/upload/npc.log"
SUBMIT_LOG_FILE="/tmp/upload/npc_submit_log.txt"

submit_log() {
	[ "${NPC_SUBMIT}" = "1" ] && echo_date "$@"
}

ensure_defaults() {
	[ -z "${npc_enable}" ] && npc_enable="0"
	[ -z "${npc_mode}" ] && npc_mode="conf"
	[ -z "${npc_conn_type}" ] && npc_conn_type="tcp"
	[ -z "${npc_log_level}" ] && npc_log_level="7"
	[ -z "${npc_auto_reconnection}" ] && npc_auto_reconnection="true"
	[ -z "${npc_crypt}" ] && npc_crypt="true"
	[ -z "${npc_compress}" ] && npc_compress="true"
	[ -z "${npc_customize_conf}" ] && npc_customize_conf="0"
}

gen_conf_file() {
	submit_log "生成配置文件到 ${CONF_FILE}"
	if [ "${npc_customize_conf}" = "1" ]; then
		_conf="$(dbus get npc_config | base64_decode 2>/dev/null)"
		[ -z "${_conf}" ] && _conf="# empty custom config"
		cat >"${CONF_FILE}" <<-EOF
			# npc custom configuration
			${_conf}
		EOF
	else
		cat >"${CONF_FILE}" <<-EOF
			[common]
			server_addr=${npc_server_addr}
			conn_type=${npc_conn_type}
			vkey=${npc_vkey}
		EOF
		if [ -n "${npc_auto_reconnection}" ]; then
			echo "auto_reconnection=${npc_auto_reconnection}" >>"${CONF_FILE}"
		fi
		if [ -n "${npc_max_conn}" ]; then
			echo "max_conn=${npc_max_conn}" >>"${CONF_FILE}"
		fi
		if [ -n "${npc_flow_limit}" ]; then
			echo "flow_limit=${npc_flow_limit}" >>"${CONF_FILE}"
		fi
		if [ -n "${npc_rate_limit}" ]; then
			echo "rate_limit=${npc_rate_limit}" >>"${CONF_FILE}"
		fi
		if [ -n "${npc_crypt}" ]; then
			echo "crypt=${npc_crypt}" >>"${CONF_FILE}"
		fi
		if [ -n "${npc_compress}" ]; then
			echo "compress=${npc_compress}" >>"${CONF_FILE}"
		fi
		if [ -n "${npc_disconnect_timeout}" ]; then
			echo "disconnect_timeout=${npc_disconnect_timeout}" >>"${CONF_FILE}"
		fi
	fi
	submit_log "配置文件生成成功！"
}

check_required() {
	if [ "${npc_mode}" = "conf" ]; then
		if [ "${npc_customize_conf}" = "1" ]; then
			_conf="$(dbus get npc_config | base64_decode 2>/dev/null)"
			[ -n "${_conf}" ] || return 1
			echo "${_conf}" | grep -q "^[[:space:]]*\\[common\\]" || return 1
		else
			[ -n "${npc_server_addr}" ] || return 1
			[ -n "${npc_vkey}" ] || return 1
		fi
	else
		[ -n "${npc_server_addr}" ] || return 1
		[ -n "${npc_vkey}" ] || return 1
	fi
	return 0
}

start_npc() {
	ensure_defaults
	dbus set npc_client_version="$(${BIN} -version 2>/dev/null | tr -d '\r' | head -n 1)"

	if [ "${npc_enable}" != "1" ]; then
		submit_log "准备停止 npc 服务..."
		killall npc >/dev/null 2>&1 || true
		rm -f "${PID_FILE}" >/dev/null 2>&1 || true
		return 0
	fi

	submit_log "检查配置..."
	if ! check_required; then
		submit_log "配置检查失败：server_addr/vkey 不能为空！"
		return 1
	fi

	# always re-generate conf (also used as a record for cmd mode)
	gen_conf_file

	submit_log "准备运行..."
	killall npc >/dev/null 2>&1 || true
	sleep 1

	# clear old log to avoid huge file
	[ -f "${LOG_FILE}" ] && tail -n 500 "${LOG_FILE}" >"${LOG_FILE}.tmp" 2>/dev/null && mv -f "${LOG_FILE}.tmp" "${LOG_FILE}" 2>/dev/null || true

	args="-log_path=${LOG_FILE} -log_level=${npc_log_level}"
	if [ -n "${npc_disconnect_timeout}" ]; then
		args="${args} -disconnect_timeout=${npc_disconnect_timeout}"
	fi

	if [ "${npc_mode}" = "cmd" ]; then
		start-stop-daemon -S -q -b -m -p "${PID_FILE}" -x "${BIN}" -- -server="${npc_server_addr}" -vkey="${npc_vkey}" -type="${npc_conn_type}" ${args}
	else
		start-stop-daemon -S -q -b -m -p "${PID_FILE}" -x "${BIN}" -- -config="${CONF_FILE}" ${args}
	fi
	return 0
}

nat_start() {
	if [ "${npc_enable}" = "1" ]; then
		[ ! -L "/koolshare/init.d/N99npc.sh" ] && ln -sf /koolshare/scripts/npc_config.sh /koolshare/init.d/N99npc.sh
	else
		rm -f /koolshare/init.d/N99npc.sh >/dev/null 2>&1
	fi
}

# =============================================
# this part for start up by post-mount
case "$ACTION" in
start|start_nat)
	start_npc
	nat_start
	;;
esac

# for web submit
case "$2" in
1)
	(
		NPC_SUBMIT=1
		export NPC_SUBMIT
		echo_date "开始提交配置..."
		if [ "${npc_enable}" = "1" ]; then
			echo_date "启动 npc 服务..."
		else
			echo_date "停止 npc 服务..."
		fi

		if start_npc; then
			nat_start
			sleep 1
			pid=""
			[ -f "${PID_FILE}" ] && pid="$(cat "${PID_FILE}" 2>/dev/null)"
			if [ "${npc_enable}" = "1" ]; then
				if [ -n "${pid}" ] && kill -0 "${pid}" 2>/dev/null; then
					echo_date "npc 程序启动成功，PID: ${pid}"
					echo "NPC_RESULT=OK"
				else
					echo_date "npc 程序启动失败，请检查配置！"
					echo "NPC_RESULT=FAIL"
				fi
			else
				if pidof npc >/dev/null 2>&1; then
					echo_date "npc 程序停止失败，请稍后重试！"
					echo "NPC_RESULT=FAIL"
				else
					echo_date "npc 程序已停止"
					echo "NPC_RESULT=OK"
				fi
			fi
		else
			echo_date "提交失败，请检查配置！"
			echo "NPC_RESULT=FAIL"
		fi
		echo "XU6J03M16"
	) >"${SUBMIT_LOG_FILE}" 2>&1 &
	http_response "$1"
	;;
esac
