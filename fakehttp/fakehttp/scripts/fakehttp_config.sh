#!/bin/sh
. /koolshare/scripts/base.sh

alias echo_date='echo [$(TZ=UTC-8 date "+%Y-%m-%d %H:%M:%S")]:'

eval "$(dbus export fakehttp_)"

ACTION="$1"

MODULE="fakehttp"
BIN="/koolshare/bin/fakehttp"
PID_FILE="/tmp/fakehttp.pid"
LOG_FILE="/tmp/upload/fakehttp.log"
LOCK_DIR="/tmp/fakehttp_lock"

acquire_lock() {
	if mkdir "${LOCK_DIR}" >/dev/null 2>&1; then
		echo "$$" >"${LOCK_DIR}/pid" 2>/dev/null
		return 0
	fi
	return 1
}

release_lock() {
	rm -rf "${LOCK_DIR}" >/dev/null 2>&1
}

lock_or_exit() {
	if acquire_lock; then
		trap 'release_lock' EXIT
		return 0
	fi
	# api call: return json so frontend won't hang
	if [ -n "$2" ]; then
		http_response "{\"ok\":0,\"msg\":\"busy\"}"
	fi
	exit 0
}

lock_or_exit "$@"

ensure_defaults() {
	[ -z "${fakehttp_enable}" ] && dbus set fakehttp_enable="0"
	[ -z "${fakehttp_alliface}" ] && dbus set fakehttp_alliface="0"
	[ -z "${fakehttp_iface}" ] && dbus set fakehttp_iface="ppp0"
	[ -z "${fakehttp_http_host}" ] && dbus set fakehttp_http_host="www.example.com"
	[ -z "${fakehttp_https_host}" ] && dbus set fakehttp_https_host=""
	[ -z "${fakehttp_payload}" ] && dbus set fakehttp_payload=""

	[ -z "${fakehttp_inbound}" ] && dbus set fakehttp_inbound="0"
	[ -z "${fakehttp_outbound}" ] && dbus set fakehttp_outbound="1"
	[ -z "${fakehttp_ipv4}" ] && dbus set fakehttp_ipv4="1"
	[ -z "${fakehttp_ipv6}" ] && dbus set fakehttp_ipv6="0"

	[ -z "${fakehttp_nfqnum}" ] && dbus set fakehttp_nfqnum="512"
	[ -z "${fakehttp_fwmark}" ] && dbus set fakehttp_fwmark="0x8000"
	[ -z "${fakehttp_fwmask}" ] && dbus set fakehttp_fwmask=""
	[ -z "${fakehttp_repeat}" ] && dbus set fakehttp_repeat="1"
	[ -z "${fakehttp_ttl}" ] && dbus set fakehttp_ttl="3"
	[ -z "${fakehttp_dynamic_pct}" ] && dbus set fakehttp_dynamic_pct=""
	[ -z "${fakehttp_nohopest}" ] && dbus set fakehttp_nohopest="0"
	[ -z "${fakehttp_silent}" ] && dbus set fakehttp_silent="0"
}

is_running() {
	if [ -f "${PID_FILE}" ]; then
		pid="$(cat "${PID_FILE}" 2>/dev/null)"
		[ -n "${pid}" ] && kill -0 "${pid}" >/dev/null 2>&1 && return 0
	fi
	return 1
}

stop_proc() {
	if [ -f "${PID_FILE}" ]; then
		start-stop-daemon -K -q -p "${PID_FILE}" >/dev/null 2>&1
		rm -f "${PID_FILE}" >/dev/null 2>&1
	fi
	# fallback
	pidof fakehttp >/dev/null 2>&1 && killall fakehttp >/dev/null 2>&1
}

nat_start_link() {
	if [ "$(dbus get fakehttp_enable 2>/dev/null)" = "1" ]; then
		[ ! -L "/koolshare/init.d/N97FakeHTTP.sh" ] && ln -sf /koolshare/scripts/fakehttp_config.sh /koolshare/init.d/N97FakeHTTP.sh
	else
		[ -L "/koolshare/init.d/N97FakeHTTP.sh" ] && rm -f /koolshare/init.d/N97FakeHTTP.sh >/dev/null 2>&1
	fi
}

normalize_ifaces() {
	echo "$1" | tr ',' ' ' | tr -s ' ' | sed 's/^ *//;s/ *$//'
}

clear_log() {
	: >"${LOG_FILE}"
	http_response "{\"ok\":1}"
}

trim_log() {
	[ ! -f "${LOG_FILE}" ] && http_response "{\"ok\":1}" && return 0
	lines="$(wc -l < "${LOG_FILE}" 2>/dev/null)"
	case "${lines}" in
		''|*[!0-9]*)
			http_response "{\"ok\":1}"
			return 0
			;;
	esac
	if [ "${lines}" -gt 500 ]; then
		tmp="${LOG_FILE}.tmp"
		tail -n 10 "${LOG_FILE}" >"${tmp}" 2>/dev/null
		cat "${tmp}" >"${LOG_FILE}" 2>/dev/null
		rm -f "${tmp}" >/dev/null 2>&1
	fi
	http_response "{\"ok\":1}"
}

normalize_hosts() {
	# normalize_hosts "<string>" => space-separated tokens
	# Supports:
	# - real newlines in textarea value
	# - literal "\n" sequences (some httpdb/json paths store as two chars)
	# - comma-separated hosts
	printf '%s' "$1" \
		| sed 's/\\\\n/ /g; s/\\n/ /g; s/\\\\r/ /g; s/\\r/ /g; s/\\\\t/ /g; s/\\t/ /g; s/,/ /g' \
		| awk 'BEGIN{out=""} {gsub(/\r/,""); for(i=1;i<=NF;i++){out = out (out==""?$i:" "$i)}} END{print out}'
}

start_fakehttp() {
	ensure_defaults
	eval "$(dbus export fakehttp_)"
	mkdir -p /tmp/upload >/dev/null 2>&1

	if [ "${fakehttp_enable}" != "1" ]; then
		stop_proc
		nat_start_link
		return 0
	fi

	if [ ! -x "${BIN}" ]; then
		echo_date "未找到可执行文件：${BIN}" >>"${LOG_FILE}"
		return 1
	fi

	http_hosts="$(normalize_hosts "${fakehttp_http_host}")"
	https_hosts="$(normalize_hosts "${fakehttp_https_host}")"
	payloads="$(normalize_hosts "${fakehttp_payload}")"

	if [ -z "${http_hosts}" ]; then
		echo_date "配置错误：HTTP Host 不能为空（-h）" >>"${LOG_FILE}"
		return 1
	fi

	if [ "${fakehttp_alliface}" != "1" ] && [ -z "$(normalize_ifaces "${fakehttp_iface}")" ]; then
		echo_date "配置错误：未指定接口（-i）" >>"${LOG_FILE}"
		return 1
	fi

	# restart process
	stop_proc

	args=""
	# direction
	[ "${fakehttp_inbound}" = "1" ] && args="${args} -0"
	[ "${fakehttp_outbound}" = "1" ] && args="${args} -1"
	# ip proto
	[ "${fakehttp_ipv4}" = "1" ] && args="${args} -4"
	[ "${fakehttp_ipv6}" = "1" ] && args="${args} -6"

	# interface
	if [ "${fakehttp_alliface}" = "1" ]; then
		args="${args} -a"
	else
		for i in $(normalize_ifaces "${fakehttp_iface}"); do
			args="${args} -i ${i}"
		done
	fi

	# payload
	for h in ${http_hosts}; do
		args="${args} -h ${h}"
	done
	for h in ${https_hosts}; do
		args="${args} -e ${h}"
	done
	for p in ${payloads}; do
		if [ ! -f "${p}" ]; then
			echo_date "配置错误：Payload 文件不存在（-b）：${p}" >>"${LOG_FILE}"
			return 1
		fi
		args="${args} -b ${p}"
	done

	# advanced
	[ "${fakehttp_silent}" = "1" ] && args="${args} -s"
	[ "${fakehttp_nohopest}" = "1" ] && args="${args} -g"
	[ -n "${fakehttp_nfqnum}" ] && args="${args} -n ${fakehttp_nfqnum}"
	[ -n "${fakehttp_fwmark}" ] && args="${args} -m ${fakehttp_fwmark}"
	[ -n "${fakehttp_fwmask}" ] && args="${args} -x ${fakehttp_fwmask}"
	[ -n "${fakehttp_repeat}" ] && args="${args} -r ${fakehttp_repeat}"
	[ -n "${fakehttp_ttl}" ] && args="${args} -t ${fakehttp_ttl}"
	[ -n "${fakehttp_dynamic_pct}" ] && args="${args} -y ${fakehttp_dynamic_pct}"

	args="${args} -w ${LOG_FILE}"

	echo_date "启动 FakeHTTP..." >>"${LOG_FILE}"
	echo_date "cmd: ${BIN}${args}" >>"${LOG_FILE}"

	# shellcheck disable=SC2086
	start-stop-daemon -S -q -b -m -p "${PID_FILE}" -x "${BIN}" -- ${args} >/dev/null 2>&1
	sleep 1

	if is_running; then
		echo_date "FakeHTTP 已启动（pid=$(cat "${PID_FILE}" 2>/dev/null)）" >>"${LOG_FILE}"
	else
		echo_date "FakeHTTP 启动失败，请查看日志排查。" >>"${LOG_FILE}"
		return 1
	fi

	nat_start_link
	return 0
}

stop_fakehttp() {
	stop_proc
	nat_start_link
	echo_date "FakeHTTP 已停止。" >>"${LOG_FILE}"
}

start_nat() {
	ensure_defaults
	eval "$(dbus export fakehttp_)"
	[ "${fakehttp_enable}" != "1" ] && return 0
	if ! is_running; then
		start_fakehttp
	fi
}

case "$ACTION" in
	start)
		start_fakehttp
		;;
	stop)
		stop_fakehttp
		;;
	restart)
		stop_fakehttp
		start_fakehttp
		;;
	start_nat)
		start_nat
		;;
esac

case "$2" in
	1)
		# apply from web (dbus values already written by httpdb)
		start_fakehttp
		http_response "$1"
		;;
	2)
		start_fakehttp
		http_response "$1"
		;;
	3)
		stop_fakehttp
		http_response "$1"
		;;
	4)
		clear_log
		;;
	5)
		trim_log
		;;
esac
