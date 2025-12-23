#!/bin/sh
source /koolshare/scripts/base.sh

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

ipt4_cleanup() {
	while iptables -t mangle -D PREROUTING -j FAKEHTTP_S >/dev/null 2>&1; do :; done
	while iptables -t mangle -D POSTROUTING -j FAKEHTTP_D >/dev/null 2>&1; do :; done

	iptables -t mangle -F FAKEHTTP_R >/dev/null 2>&1
	iptables -t mangle -F FAKEHTTP_S >/dev/null 2>&1
	iptables -t mangle -F FAKEHTTP_D >/dev/null 2>&1

	iptables -t mangle -X FAKEHTTP_R >/dev/null 2>&1
	iptables -t mangle -X FAKEHTTP_S >/dev/null 2>&1
	iptables -t mangle -X FAKEHTTP_D >/dev/null 2>&1
}

ipt6_cleanup() {
	while ip6tables -t mangle -D PREROUTING -j FAKEHTTP_S >/dev/null 2>&1; do :; done
	while ip6tables -t mangle -D POSTROUTING -j FAKEHTTP_D >/dev/null 2>&1; do :; done

	ip6tables -t mangle -F FAKEHTTP_R >/dev/null 2>&1
	ip6tables -t mangle -F FAKEHTTP_S >/dev/null 2>&1
	ip6tables -t mangle -F FAKEHTTP_D >/dev/null 2>&1

	ip6tables -t mangle -X FAKEHTTP_R >/dev/null 2>&1
	ip6tables -t mangle -X FAKEHTTP_S >/dev/null 2>&1
	ip6tables -t mangle -X FAKEHTTP_D >/dev/null 2>&1
}

normalize_ifaces() {
	echo "$1" | tr ',' ' ' | tr -s ' ' | sed 's/^ *//;s/ *$//'
}

ipt4_setup() {
	inbound="$1"
	outbound="$2"
	alliface="$3"
	ifaces="$4"
	nfqnum="$5"
	xmark="$6"

	iptables -t mangle -N FAKEHTTP_S >/dev/null 2>&1
	iptables -t mangle -N FAKEHTTP_D >/dev/null 2>&1
	iptables -t mangle -N FAKEHTTP_R >/dev/null 2>&1

	[ "${inbound}" = "1" ] && iptables -t mangle -I PREROUTING -j FAKEHTTP_S >/dev/null 2>&1
	[ "${outbound}" = "1" ] && iptables -t mangle -I POSTROUTING -j FAKEHTTP_D >/dev/null 2>&1

	# exclude local IPs (from source)
	if [ "${inbound}" = "1" ]; then
		for cidr in 0.0.0.0/8 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12 192.168.0.0/16 224.0.0.0/3; do
			iptables -t mangle -A FAKEHTTP_S -s "${cidr}" -j RETURN >/dev/null 2>&1
		done
	fi

	# exclude local IPs (to destination)
	if [ "${outbound}" = "1" ]; then
		for cidr in 0.0.0.0/8 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12 192.168.0.0/16 224.0.0.0/3; do
			iptables -t mangle -A FAKEHTTP_D -d "${cidr}" -j RETURN >/dev/null 2>&1
		done
	fi

	iptables -t mangle -A FAKEHTTP_R -m mark --mark "${xmark}" -j RETURN >/dev/null 2>&1
	iptables -t mangle -A FAKEHTTP_R -p tcp --tcp-flags SYN,FIN,RST SYN -j NFQUEUE --queue-bypass --queue-num "${nfqnum}" >/dev/null 2>&1

	# optional early ACK rule
	iptables -t mangle -A FAKEHTTP_R -p tcp --tcp-flags SYN,ACK,FIN,RST ACK -m connbytes --connbytes 2:4 --connbytes-dir both --connbytes-mode packets -j NFQUEUE --queue-bypass --queue-num "${nfqnum}" >/dev/null 2>&1

	if [ "${alliface}" = "1" ]; then
		[ "${inbound}" = "1" ] && iptables -t mangle -A FAKEHTTP_S -j FAKEHTTP_R >/dev/null 2>&1
		[ "${outbound}" = "1" ] && iptables -t mangle -A FAKEHTTP_D -j FAKEHTTP_R >/dev/null 2>&1
	else
		for i in ${ifaces}; do
			[ "${inbound}" = "1" ] && iptables -t mangle -A FAKEHTTP_S -i "${i}" -j FAKEHTTP_R >/dev/null 2>&1
			[ "${outbound}" = "1" ] && iptables -t mangle -A FAKEHTTP_D -o "${i}" -j FAKEHTTP_R >/dev/null 2>&1
		done
	fi
}

ipt6_setup() {
	inbound="$1"
	outbound="$2"
	alliface="$3"
	ifaces="$4"
	nfqnum="$5"
	xmark="$6"

	ip6tables -t mangle -N FAKEHTTP_S >/dev/null 2>&1
	ip6tables -t mangle -N FAKEHTTP_D >/dev/null 2>&1
	ip6tables -t mangle -N FAKEHTTP_R >/dev/null 2>&1

	[ "${inbound}" = "1" ] && ip6tables -t mangle -I PREROUTING -j FAKEHTTP_S >/dev/null 2>&1
	[ "${outbound}" = "1" ] && ip6tables -t mangle -I POSTROUTING -j FAKEHTTP_D >/dev/null 2>&1

	if [ "${inbound}" = "1" ]; then
		for cidr in ::/127 ::ffff:0:0/96 64:ff9b::/96 64:ff9b:1::/48 2002::/16 fc00::/7 fe80::/10; do
			ip6tables -t mangle -A FAKEHTTP_S -s "${cidr}" -j RETURN >/dev/null 2>&1
		done
	fi

	if [ "${outbound}" = "1" ]; then
		for cidr in ::/127 ::ffff:0:0/96 64:ff9b::/96 64:ff9b:1::/48 2002::/16 fc00::/7 fe80::/10; do
			ip6tables -t mangle -A FAKEHTTP_D -d "${cidr}" -j RETURN >/dev/null 2>&1
		done
	fi

	ip6tables -t mangle -A FAKEHTTP_R -m mark --mark "${xmark}" -j RETURN >/dev/null 2>&1
	ip6tables -t mangle -A FAKEHTTP_R -p tcp --tcp-flags SYN,FIN,RST SYN -j NFQUEUE --queue-bypass --queue-num "${nfqnum}" >/dev/null 2>&1
	ip6tables -t mangle -A FAKEHTTP_R -p tcp --tcp-flags SYN,ACK,FIN,RST ACK -m connbytes --connbytes 2:4 --connbytes-dir both --connbytes-mode packets -j NFQUEUE --queue-bypass --queue-num "${nfqnum}" >/dev/null 2>&1

	if [ "${alliface}" = "1" ]; then
		[ "${inbound}" = "1" ] && ip6tables -t mangle -A FAKEHTTP_S -j FAKEHTTP_R >/dev/null 2>&1
		[ "${outbound}" = "1" ] && ip6tables -t mangle -A FAKEHTTP_D -j FAKEHTTP_R >/dev/null 2>&1
	else
		for i in ${ifaces}; do
			[ "${inbound}" = "1" ] && ip6tables -t mangle -A FAKEHTTP_S -i "${i}" -j FAKEHTTP_R >/dev/null 2>&1
			[ "${outbound}" = "1" ] && ip6tables -t mangle -A FAKEHTTP_D -o "${i}" -j FAKEHTTP_R >/dev/null 2>&1
		done
	fi
}

apply_firewall_rules() {
	inbound="${fakehttp_inbound}"
	outbound="${fakehttp_outbound}"
	[ -z "${inbound}" ] && inbound="0"
	[ -z "${outbound}" ] && outbound="1"
	[ "${inbound}" != "1" ] && [ "${outbound}" != "1" ] && outbound="1"

	alliface="${fakehttp_alliface}"
	[ -z "${alliface}" ] && alliface="0"
	ifaces="$(normalize_ifaces "${fakehttp_iface}")"

	nfqnum="${fakehttp_nfqnum}"
	[ -z "${nfqnum}" ] && nfqnum="512"

	fwmark="${fakehttp_fwmark}"
	[ -z "${fwmark}" ] && fwmark="0x8000"
	fwmask="${fakehttp_fwmask}"
	[ -z "${fwmask}" ] && fwmask="${fwmark}"
	xmark="${fwmark}/${fwmask}"

	# remove old first (idempotent)
	[ "${fakehttp_ipv4}" = "1" ] && ipt4_cleanup
	[ "${fakehttp_ipv6}" = "1" ] && ipt6_cleanup

	[ "${fakehttp_ipv4}" = "1" ] && ipt4_setup "${inbound}" "${outbound}" "${alliface}" "${ifaces}" "${nfqnum}" "${xmark}"
	[ "${fakehttp_ipv6}" = "1" ] && ipt6_setup "${inbound}" "${outbound}" "${alliface}" "${ifaces}" "${nfqnum}" "${xmark}"
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
	echo "$1" | tr ',\r\n\t' ' ' | tr -s ' ' | sed 's/^ *//;s/ *$//'
}

start_fakehttp() {
	ensure_defaults
	eval "$(dbus export fakehttp_)"
	mkdir -p /tmp/upload >/dev/null 2>&1

	if [ "${fakehttp_enable}" != "1" ]; then
		stop_proc
		ipt4_cleanup
		ipt6_cleanup
		nat_start_link
		return 0
	fi

	if [ ! -x "${BIN}" ]; then
		echo_date "未找到可执行文件：${BIN}" >>"${LOG_FILE}"
		return 1
	fi

	http_hosts="$(normalize_hosts "${fakehttp_http_host}")"
	https_hosts="$(normalize_hosts "${fakehttp_https_host}")"

	if [ -z "${http_hosts}" ]; then
		echo_date "配置错误：HTTP Host 不能为空（-h）" >>"${LOG_FILE}"
		return 1
	fi

	if [ "${fakehttp_alliface}" != "1" ] && [ -z "$(normalize_ifaces "${fakehttp_iface}")" ]; then
		echo_date "配置错误：未指定接口（-i）" >>"${LOG_FILE}"
		return 1
	fi

	# ensure firewall rules (Asus: skip FakeHTTP built-in rules, avoid iptables -w)
	apply_firewall_rules

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

	# advanced
	[ "${fakehttp_silent}" = "1" ] && args="${args} -s"
	[ "${fakehttp_nohopest}" = "1" ] && args="${args} -g"
	[ -n "${fakehttp_nfqnum}" ] && args="${args} -n ${fakehttp_nfqnum}"
	[ -n "${fakehttp_fwmark}" ] && args="${args} -m ${fakehttp_fwmark}"
	[ -n "${fakehttp_fwmask}" ] && args="${args} -x ${fakehttp_fwmask}"
	[ -n "${fakehttp_repeat}" ] && args="${args} -r ${fakehttp_repeat}"
	[ -n "${fakehttp_ttl}" ] && args="${args} -t ${fakehttp_ttl}"
	[ -n "${fakehttp_dynamic_pct}" ] && args="${args} -y ${fakehttp_dynamic_pct}"

	# IMPORTANT: -f skips FakeHTTP firewall rules (workaround for Asus iptables lacking -w)
	args="${args} -f"
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
	ipt4_cleanup
	ipt6_cleanup
	nat_start_link
	echo_date "FakeHTTP 已停止。" >>"${LOG_FILE}"
}

start_nat() {
	ensure_defaults
	eval "$(dbus export fakehttp_)"
	[ "${fakehttp_enable}" != "1" ] && return 0
	apply_firewall_rules
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
