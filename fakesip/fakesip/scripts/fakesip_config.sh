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

ipt4_cleanup() {
	while iptables -t mangle -D PREROUTING -j FAKESIP_S >/dev/null 2>&1; do :; done
	while iptables -t mangle -D POSTROUTING -j FAKESIP_D >/dev/null 2>&1; do :; done

	iptables -t mangle -F FAKESIP_R >/dev/null 2>&1
	iptables -t mangle -F FAKESIP_S >/dev/null 2>&1
	iptables -t mangle -F FAKESIP_D >/dev/null 2>&1

	iptables -t mangle -X FAKESIP_R >/dev/null 2>&1
	iptables -t mangle -X FAKESIP_S >/dev/null 2>&1
	iptables -t mangle -X FAKESIP_D >/dev/null 2>&1
}

ipt6_cleanup() {
	while ip6tables -t mangle -D PREROUTING -j FAKESIP_S >/dev/null 2>&1; do :; done
	while ip6tables -t mangle -D POSTROUTING -j FAKESIP_D >/dev/null 2>&1; do :; done

	ip6tables -t mangle -F FAKESIP_R >/dev/null 2>&1
	ip6tables -t mangle -F FAKESIP_S >/dev/null 2>&1
	ip6tables -t mangle -F FAKESIP_D >/dev/null 2>&1

	ip6tables -t mangle -X FAKESIP_R >/dev/null 2>&1
	ip6tables -t mangle -X FAKESIP_S >/dev/null 2>&1
	ip6tables -t mangle -X FAKESIP_D >/dev/null 2>&1
}

normalize_ifaces() {
	echo "$1" | tr ',' ' ' | tr -s ' ' | sed 's/^ *//;s/ *$//'
}

normalize_list() {
	# normalize_list "<string>" => space-separated tokens
	echo "$1" | tr ',\r\n\t' ' ' | tr -s ' ' | sed 's/^ *//;s/ *$//'
}

ipt4_setup() {
	inbound="$1"
	outbound="$2"
	alliface="$3"
	ifaces="$4"
	nfqnum="$5"
	xmark="$6"

	iptables -t mangle -N FAKESIP_S >/dev/null 2>&1
	iptables -t mangle -N FAKESIP_D >/dev/null 2>&1
	iptables -t mangle -N FAKESIP_R >/dev/null 2>&1

	[ "${inbound}" = "1" ] && iptables -t mangle -I PREROUTING -j FAKESIP_S >/dev/null 2>&1
	[ "${outbound}" = "1" ] && iptables -t mangle -I POSTROUTING -j FAKESIP_D >/dev/null 2>&1

	# drop ICMP time-exceeded packets (best-effort)
	[ "${inbound}" = "1" ] && iptables -t mangle -A FAKESIP_S -p icmp --icmp-type 11 -j DROP >/dev/null 2>&1

	# exclude local IPs (from source)
	if [ "${inbound}" = "1" ]; then
		for cidr in 0.0.0.0/8 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12 192.168.0.0/16 224.0.0.0/3; do
			iptables -t mangle -A FAKESIP_S -s "${cidr}" -j RETURN >/dev/null 2>&1
		done
	fi

	# exclude local IPs (to destination)
	if [ "${outbound}" = "1" ]; then
		for cidr in 0.0.0.0/8 10.0.0.0/8 100.64.0.0/10 127.0.0.0/8 169.254.0.0/16 172.16.0.0/12 192.168.0.0/16 224.0.0.0/3; do
			iptables -t mangle -A FAKESIP_D -d "${cidr}" -j RETURN >/dev/null 2>&1
		done
	fi

	iptables -t mangle -A FAKESIP_R -m mark --mark "${xmark}" -j RETURN >/dev/null 2>&1
	iptables -t mangle -A FAKESIP_R -p udp -m connbytes --connbytes 1:5 --connbytes-dir both --connbytes-mode packets -j NFQUEUE --queue-bypass --queue-num "${nfqnum}" >/dev/null 2>&1

	if [ "${alliface}" = "1" ]; then
		[ "${inbound}" = "1" ] && iptables -t mangle -A FAKESIP_S -j FAKESIP_R >/dev/null 2>&1
		[ "${outbound}" = "1" ] && iptables -t mangle -A FAKESIP_D -j FAKESIP_R >/dev/null 2>&1
	else
		for i in ${ifaces}; do
			[ "${inbound}" = "1" ] && iptables -t mangle -A FAKESIP_S -i "${i}" -j FAKESIP_R >/dev/null 2>&1
			[ "${outbound}" = "1" ] && iptables -t mangle -A FAKESIP_D -o "${i}" -j FAKESIP_R >/dev/null 2>&1
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

	ip6tables -t mangle -N FAKESIP_S >/dev/null 2>&1
	ip6tables -t mangle -N FAKESIP_D >/dev/null 2>&1
	ip6tables -t mangle -N FAKESIP_R >/dev/null 2>&1

	[ "${inbound}" = "1" ] && ip6tables -t mangle -I PREROUTING -j FAKESIP_S >/dev/null 2>&1
	[ "${outbound}" = "1" ] && ip6tables -t mangle -I POSTROUTING -j FAKESIP_D >/dev/null 2>&1

	# drop ICMPv6 time-exceeded packets (best-effort)
	[ "${inbound}" = "1" ] && ip6tables -t mangle -A FAKESIP_S -p icmpv6 --icmpv6-type time-exceeded -j DROP >/dev/null 2>&1

	# exclude non-GUA IPv6 addresses (match upstream behavior)
	[ "${inbound}" = "1" ] && ip6tables -t mangle -A FAKESIP_S ! -s 2000::/3 -j RETURN >/dev/null 2>&1
	[ "${outbound}" = "1" ] && ip6tables -t mangle -A FAKESIP_D ! -d 2000::/3 -j RETURN >/dev/null 2>&1

	ip6tables -t mangle -A FAKESIP_R -m mark --mark "${xmark}" -j RETURN >/dev/null 2>&1
	ip6tables -t mangle -A FAKESIP_R -p udp -m connbytes --connbytes 1:5 --connbytes-dir both --connbytes-mode packets -j NFQUEUE --queue-bypass --queue-num "${nfqnum}" >/dev/null 2>&1

	if [ "${alliface}" = "1" ]; then
		[ "${inbound}" = "1" ] && ip6tables -t mangle -A FAKESIP_S -j FAKESIP_R >/dev/null 2>&1
		[ "${outbound}" = "1" ] && ip6tables -t mangle -A FAKESIP_D -j FAKESIP_R >/dev/null 2>&1
	else
		for i in ${ifaces}; do
			[ "${inbound}" = "1" ] && ip6tables -t mangle -A FAKESIP_S -i "${i}" -j FAKESIP_R >/dev/null 2>&1
			[ "${outbound}" = "1" ] && ip6tables -t mangle -A FAKESIP_D -o "${i}" -j FAKESIP_R >/dev/null 2>&1
		done
	fi
}

apply_firewall_rules() {
	inbound="${fakesip_inbound}"
	outbound="${fakesip_outbound}"
	[ -z "${inbound}" ] && inbound="0"
	[ -z "${outbound}" ] && outbound="1"
	[ "${inbound}" != "1" ] && [ "${outbound}" != "1" ] && outbound="1"

	alliface="${fakesip_alliface}"
	[ -z "${alliface}" ] && alliface="0"
	ifaces="$(normalize_ifaces "${fakesip_iface}")"

	nfqnum="${fakesip_nfqnum}"
	[ -z "${nfqnum}" ] && nfqnum="513"

	fwmark="${fakesip_fwmark}"
	[ -z "${fwmark}" ] && fwmark="0x10000"
	fwmask="${fakesip_fwmask}"
	[ -z "${fwmask}" ] && fwmask="${fwmark}"
	xmark="${fwmark}/${fwmask}"

	[ "${fakesip_ipv4}" = "1" ] && ipt4_cleanup
	[ "${fakesip_ipv6}" = "1" ] && ipt6_cleanup

	[ "${fakesip_ipv4}" = "1" ] && ipt4_setup "${inbound}" "${outbound}" "${alliface}" "${ifaces}" "${nfqnum}" "${xmark}"
	[ "${fakesip_ipv6}" = "1" ] && ipt6_setup "${inbound}" "${outbound}" "${alliface}" "${ifaces}" "${nfqnum}" "${xmark}"
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

	apply_firewall_rules
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

	# IMPORTANT: -f skips FakeSIP firewall rules (workaround for Asus iptables lacking -w)
	args="${args} -f"
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
	ipt4_cleanup
	ipt6_cleanup
	nat_start_link
	echo_date "FakeSIP 已停止。" >>"${LOG_FILE}"
}

start_nat() {
	ensure_defaults
	eval "$(dbus export fakesip_)"
	[ "${fakesip_enable}" != "1" ] && return 0
	apply_firewall_rules
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
