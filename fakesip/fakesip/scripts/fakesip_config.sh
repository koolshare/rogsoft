#!/bin/sh
source /koolshare/scripts/base.sh

alias echo_date='echo [$(TZ=UTC-8 date "+%Y-%m-%d %H:%M:%S")]:'

eval "$(dbus export fakesip_)"

ACTION="$1"

MODULE="fakesip"
BIN="/koolshare/bin/fakesip"
PID_FILE="/tmp/fakesip.pid"
LOG_FILE="/tmp/upload/fakesip.log"
LOCK_DIR="/tmp/fakesip_lock"

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
	[ -z "${fakesip_enable}" ] && dbus set fakesip_enable="0"
	[ -z "${fakesip_alliface}" ] && dbus set fakesip_alliface="0"
	[ -z "${fakesip_iface}" ] && dbus set fakesip_iface="ppp0"

	[ -z "${fakesip_sip_uri}" ] && dbus set fakesip_sip_uri=""
	[ -z "${fakesip_payload_file}" ] && dbus set fakesip_payload_file=""

	[ -z "${fakesip_inbound}" ] && dbus set fakesip_inbound="0"
	[ -z "${fakesip_outbound}" ] && dbus set fakesip_outbound="1"
	[ -z "${fakesip_ipv4}" ] && dbus set fakesip_ipv4="1"
	[ -z "${fakesip_ipv6}" ] && dbus set fakesip_ipv6="0"

	[ -z "${fakesip_nfqnum}" ] && dbus set fakesip_nfqnum="513"
	[ -z "${fakesip_fwmark}" ] && dbus set fakesip_fwmark="0x10000"
	[ -z "${fakesip_fwmask}" ] && dbus set fakesip_fwmask=""
	[ -z "${fakesip_repeat}" ] && dbus set fakesip_repeat="1"
	[ -z "${fakesip_ttl}" ] && dbus set fakesip_ttl="3"
	[ -z "${fakesip_dynamic_pct}" ] && dbus set fakesip_dynamic_pct=""
	[ -z "${fakesip_nohopest}" ] && dbus set fakesip_nohopest="0"
	[ -z "${fakesip_silent}" ] && dbus set fakesip_silent="0"
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
	pidof fakesip >/dev/null 2>&1 && killall fakesip >/dev/null 2>&1
}

nat_start_link() {
	if [ "$(dbus get fakesip_enable 2>/dev/null)" = "1" ]; then
		[ ! -L "/koolshare/init.d/N98FakeSIP.sh" ] && ln -sf /koolshare/scripts/fakesip_config.sh /koolshare/init.d/N98FakeSIP.sh
	else
		[ -L "/koolshare/init.d/N98FakeSIP.sh" ] && rm -f /koolshare/init.d/N98FakeSIP.sh >/dev/null 2>&1
	fi
}

normalize_ifaces() {
	echo "$1" | tr ',' ' ' | tr -s ' ' | sed 's/^ *//;s/ *$//'
}

normalize_list() {
	# normalize_list "<string>" => space-separated tokens
	echo "$1" | tr ',\r\n\t' ' ' | tr -s ' ' | sed 's/^ *//;s/ *$//'
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

start_fakesip() {
	ensure_defaults
	eval "$(dbus export fakesip_)"

	mkdir -p /tmp/upload >/dev/null 2>&1
	[ ! -f "${LOG_FILE}" ] && : >"${LOG_FILE}"

	if [ "${fakesip_dynamic_pct}" ] && [ "${fakesip_nohopest}" = "1" ]; then
		echo_date "动态 TTL（-y）不能与禁用跳数估计（-g）同时使用！" >>"${LOG_FILE}"
		return 1
	fi

	if [ "${fakesip_alliface}" != "1" ] && [ -z "${fakesip_iface}" ]; then
		echo_date "未指定接口（-i），请先在页面设置接口名或勾选所有接口（-a）。" >>"${LOG_FILE}"
		return 1
	fi

	stop_proc

	sip_uris="$(normalize_list "${fakesip_sip_uri}")"
	payload_files="$(normalize_list "${fakesip_payload_file}")"

	args=""
	[ "${fakesip_inbound}" = "1" ] && args="${args} -0"
	[ "${fakesip_outbound}" = "1" ] && args="${args} -1"
	[ "${fakesip_ipv4}" = "1" ] && args="${args} -4"
	[ "${fakesip_ipv6}" = "1" ] && args="${args} -6"

	if [ "${fakesip_alliface}" = "1" ]; then
		args="${args} -a"
	else
		for i in $(normalize_ifaces "${fakesip_iface}"); do
			args="${args} -i ${i}"
		done
	fi

	for u in ${sip_uris}; do
		args="${args} -u ${u}"
	done
	for f in ${payload_files}; do
		args="${args} -b ${f}"
	done

	[ "${fakesip_silent}" = "1" ] && args="${args} -s"
	[ "${fakesip_nohopest}" = "1" ] && args="${args} -g"
	[ -n "${fakesip_nfqnum}" ] && args="${args} -n ${fakesip_nfqnum}"
	[ -n "${fakesip_fwmark}" ] && args="${args} -m ${fakesip_fwmark}"
	[ -n "${fakesip_fwmask}" ] && args="${args} -x ${fakesip_fwmask}"
	[ -n "${fakesip_repeat}" ] && args="${args} -r ${fakesip_repeat}"
	[ -n "${fakesip_ttl}" ] && args="${args} -t ${fakesip_ttl}"
	[ -n "${fakesip_dynamic_pct}" ] && args="${args} -y ${fakesip_dynamic_pct}"

	args="${args} -w ${LOG_FILE}"

	echo_date "启动 FakeSIP..." >>"${LOG_FILE}"
	echo_date "cmd: ${BIN}${args}" >>"${LOG_FILE}"

	# shellcheck disable=SC2086
	start-stop-daemon -S -q -b -m -p "${PID_FILE}" -x "${BIN}" -- ${args} >/dev/null 2>&1
	sleep 1

	if is_running; then
		echo_date "FakeSIP 已启动（pid=$(cat "${PID_FILE}" 2>/dev/null)）" >>"${LOG_FILE}"
	else
		echo_date "FakeSIP 启动失败，请查看日志排查。" >>"${LOG_FILE}"
		return 1
	fi

	nat_start_link
	return 0
}

stop_fakesip() {
	stop_proc
	nat_start_link
	echo_date "FakeSIP 已停止。" >>"${LOG_FILE}"
}

start_nat() {
	ensure_defaults
	eval "$(dbus export fakesip_)"
	[ "${fakesip_enable}" != "1" ] && return 0
	if ! is_running; then
		start_fakesip
	fi
}

case "$ACTION" in
	start)
		start_fakesip
		;;
	stop)
		stop_fakesip
		;;
	restart)
		stop_fakesip
		start_fakesip
		;;
	start_nat)
		start_nat
		;;
esac

case "$2" in
	1)
		start_fakesip
		http_response "$1"
		;;
	2)
		start_fakesip
		http_response "$1"
		;;
	3)
		stop_fakesip
		http_response "$1"
		;;
	4)
		clear_log
		;;
	5)
		trim_log
		;;
esac
