#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo [$(TZ=UTC-8 date "+%Y-%m-%d %H:%M:%S")]:'

eval "$(dbus export natmap_)"

MODULE="natmap"
BIN="/koolshare/bin/natmap"
LOG_DIR="/tmp/upload"
ACTION="$1"

LOCK_DIR="/tmp/natmap_lock"

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

# serialize all actions to prevent duplicate natmap processes
lock_or_exit "$@"

is_plugin_natmap_pid() {
	# is_plugin_natmap_pid <pid>
	p="$1"
	cmd="$(tr '\0' ' ' </proc/"${p}"/cmdline 2>/dev/null)"
	echo "${cmd}" | grep -q "/koolshare/bin/natmap"
}

kill_plugin_natmap_by_rule() {
	# kill_plugin_natmap_by_rule <id>
	rid="$1"
	pids="$(pidof natmap 2>/dev/null)"
	[ -z "${pids}" ] && return 0
	for p in ${pids}; do
		cmd="$(tr '\0' ' ' </proc/"${p}"/cmdline 2>/dev/null)"
		echo "${cmd}" | grep -q "/koolshare/bin/natmap" || continue
		echo "${cmd}" | grep -q "natmap_notify_${rid}\\.sh" || continue
		kill "${p}" >/dev/null 2>&1
	done
	sleep 1
	for p in ${pids}; do
		cmd="$(tr '\0' ' ' </proc/"${p}"/cmdline 2>/dev/null)"
		echo "${cmd}" | grep -q "/koolshare/bin/natmap" || continue
		echo "${cmd}" | grep -q "natmap_notify_${rid}\\.sh" || continue
		kill -9 "${p}" >/dev/null 2>&1
	done
}

kill_all_plugin_natmap() {
	pids="$(pidof natmap 2>/dev/null)"
	[ -z "${pids}" ] && return 0
	for p in ${pids}; do
		is_plugin_natmap_pid "${p}" || continue
		cmd="$(tr '\0' ' ' </proc/"${p}"/cmdline 2>/dev/null)"
		echo "${cmd}" | grep -q "natmap_notify_" || continue
		kill "${p}" >/dev/null 2>&1
	done
	sleep 1
	for p in ${pids}; do
		is_plugin_natmap_pid "${p}" || continue
		cmd="$(tr '\0' ' ' </proc/"${p}"/cmdline 2>/dev/null)"
		echo "${cmd}" | grep -q "natmap_notify_" || continue
		kill -9 "${p}" >/dev/null 2>&1
	done
	rm -f /tmp/natmap_*.pid >/dev/null 2>&1
}

kill_orphaned_plugin_natmap_not_in_ids() {
	ids_csv="$(dbus get natmap_rule_ids 2>/dev/null)"
	[ "${ids_csv}" = "null" ] && ids_csv=""
	pids="$(pidof natmap 2>/dev/null)"
	[ -z "${pids}" ] && return 0
	for p in ${pids}; do
		is_plugin_natmap_pid "${p}" || continue
		cmd="$(tr '\0' ' ' </proc/"${p}"/cmdline 2>/dev/null)"
		echo "${cmd}" | grep -q "natmap_notify_" || continue
		rid="$(echo "${cmd}" | sed -n 's/.*natmap_notify_\\([0-9][0-9]*\\)\\.sh.*/\\1/p' | head -n 1)"
		if [ -z "${rid}" ]; then
			continue
		fi
		if [ -z "${ids_csv}" ] || ! echo ",${ids_csv}," | grep -q ",${rid},"; then
			kill "${p}" >/dev/null 2>&1
		fi
	done
	sleep 1
	for p in ${pids}; do
		is_plugin_natmap_pid "${p}" || continue
		cmd="$(tr '\0' ' ' </proc/"${p}"/cmdline 2>/dev/null)"
		echo "${cmd}" | grep -q "natmap_notify_" || continue
		rid="$(echo "${cmd}" | sed -n 's/.*natmap_notify_\\([0-9][0-9]*\\)\\.sh.*/\\1/p' | head -n 1)"
		if [ -z "${rid}" ]; then
			continue
		fi
		if [ -z "${ids_csv}" ] || ! echo ",${ids_csv}," | grep -q ",${rid},"; then
			kill -9 "${p}" >/dev/null 2>&1
		fi
	done
}

get_rule_ids() {
	ids="$(dbus get natmap_rule_ids 2>/dev/null)"
	if [ -z "${ids}" ] || [ "${ids}" = "null" ]; then
		echo ""
		return 0
	fi
	echo "${ids}" | tr ',' ' '
}

set_rule_ids() {
	local ids="$1"
	ids="$(echo "${ids}" | tr ' ' ',' | sed 's/^,*//;s/,*$//;s/,,*/,/g')"
	dbus set natmap_rule_ids="${ids}"
}

json_get() {
	# json_get "<json>" "<key>"
	# expects string value: "key":"value"
	echo "$1" | sed -n "s/.*\\\"$2\\\"[[:space:]]*:[[:space:]]*\\\"\\([^\\\"]*\\)\\\".*/\\1/p" | head -n 1
}

ensure_defaults() {
	# cleanup deprecated dbus keys (older versions)
	dbus remove natmap_enable >/dev/null 2>&1
	dbus remove natmap_default_stun >/dev/null 2>&1
	dbus remove natmap_default_http >/dev/null 2>&1
	dbus remove natmap_next_id >/dev/null 2>&1
}

log_file_for_id() {
	echo "${LOG_DIR}/natmap_$1.log"
}

pid_file_for_id() {
	echo "/tmp/natmap_$1.pid"
}

notify_script_for_id() {
	echo "/koolshare/scripts/natmap_notify_$1.sh"
}

fw_comment_for_id() {
	echo "natmap:$1"
}

fw_iptables_add() {
	# fw_iptables_add <proto> <port> <comment>
	_proto="$1"
	_port="$2"
	_cmt="$3"
	[ -z "${_proto}" ] || [ -z "${_port}" ] && return 0

	iptables -t filter -C INPUT -p "${_proto}" --dport "${_port}" -m comment --comment "${_cmt}" -j ACCEPT >/dev/null 2>&1 && return 0
	iptables -t filter -I INPUT -p "${_proto}" --dport "${_port}" -m comment --comment "${_cmt}" -j ACCEPT >/dev/null 2>&1 && return 0

	# fallback without comment
	iptables -t filter -C INPUT -p "${_proto}" --dport "${_port}" -j ACCEPT >/dev/null 2>&1 && return 0
	iptables -t filter -I INPUT -p "${_proto}" --dport "${_port}" -j ACCEPT >/dev/null 2>&1
}

fw_iptables_del() {
	# fw_iptables_del <proto> <port> <comment>
	_proto="$1"
	_port="$2"
	_cmt="$3"
	[ -z "${_proto}" ] || [ -z "${_port}" ] && return 0

	# delete all duplicates (with comment first)
	while iptables -t filter -D INPUT -p "${_proto}" --dport "${_port}" -m comment --comment "${_cmt}" -j ACCEPT >/dev/null 2>&1; do :; done
	while iptables -t filter -D INPUT -p "${_proto}" --dport "${_port}" -j ACCEPT >/dev/null 2>&1; do :; done
}

fw_cleanup_rule() {
	# fw_cleanup_rule <id>
	_id="$1"
	_old_port="$(dbus get natmap_rule_${_id}_fw_port 2>/dev/null)"
	_old_proto="$(dbus get natmap_rule_${_id}_fw_proto 2>/dev/null)"
	_cmt="$(fw_comment_for_id "${_id}")"
	if [ -n "${_old_port}" ] && [ -n "${_old_proto}" ]; then
		fw_iptables_del "${_old_proto}" "${_old_port}" "${_cmt}"
	fi
	dbus remove natmap_rule_${_id}_fw_port >/dev/null 2>&1
	dbus remove natmap_rule_${_id}_fw_proto >/dev/null 2>&1
}

fw_apply_all() {
	for _id in $(get_rule_ids); do
		_p="$(dbus get natmap_rule_${_id}_fw_port 2>/dev/null)"
		_pr="$(dbus get natmap_rule_${_id}_fw_proto 2>/dev/null)"
		_cmt="$(fw_comment_for_id "${_id}")"
		if [ -n "${_p}" ] && [ -n "${_pr}" ]; then
			fw_iptables_add "${_pr}" "${_p}" "${_cmt}"
		fi
	done
}

write_notify_script() {
	local id="$1"
	local user_script="$2"
	local script
	script="$(notify_script_for_id "${id}")"
	user_script_esc="$(printf "%s" "${user_script}" | sed "s/'/'\\\\''/g")"
	cat >"${script}" <<-EOF
		#!/bin/sh
		source /koolshare/scripts/base.sh
		ID="${id}"
		LOG_FILE="$(log_file_for_id "${id}")"

		alias echo_date='echo [\$(TZ=UTC-8 date "+%Y-%m-%d %H:%M:%S")]:'

		USER_SCRIPT='${user_script_esc}'
		FW_COMMENT='$(fw_comment_for_id "${id}")'

		public_addr="\$1"
		public_port="\$2"
		ip4p="\$3"
		bind_port="\$4"
		protocol="\$5"
		bind_addr="\$6"
		[ -z "\${bind_addr}" ] && bind_addr="0.0.0.0"

	dbus set natmap_rule_\${ID}_public="\${public_addr}:\${public_port}"
	dbus set natmap_rule_\${ID}_ip4p="\${ip4p}"
	dbus set natmap_rule_\${ID}_last="\$(date +%Y-%m-%d_%H:%M:%S)"

		# mirror to log for UI
		if [ -n "\${ip4p}" ]; then
			echo_date "mapped: \${public_addr}:\${public_port} (\${protocol}) -> \${bind_addr}:\${bind_port}, ip4p=\${ip4p}" >>"\${LOG_FILE}"
		else
			echo_date "mapped: \${public_addr}:\${public_port} (\${protocol}) -> \${bind_addr}:\${bind_port}" >>"\${LOG_FILE}"
		fi

		# open firewall port when bind_port is known (and persist for NAT/firewall restart restore)
		if [ -n "\${bind_port}" ] && [ -n "\${protocol}" ]; then
			old_port="\$(dbus get natmap_rule_\${ID}_fw_port 2>/dev/null)"
			old_proto="\$(dbus get natmap_rule_\${ID}_fw_proto 2>/dev/null)"
			if [ -n "\${old_port}" ] && [ -n "\${old_proto}" ]; then
				if [ "\${old_port}" != "\${bind_port}" ] || [ "\${old_proto}" != "\${protocol}" ]; then
					while iptables -t filter -D INPUT -p "\${old_proto}" --dport "\${old_port}" -m comment --comment "\${FW_COMMENT}" -j ACCEPT >/dev/null 2>&1; do :; done
					while iptables -t filter -D INPUT -p "\${old_proto}" --dport "\${old_port}" -j ACCEPT >/dev/null 2>&1; do :; done
				fi
			fi
			iptables -t filter -C INPUT -p "\${protocol}" --dport "\${bind_port}" -m comment --comment "\${FW_COMMENT}" -j ACCEPT >/dev/null 2>&1 || \
				iptables -t filter -I INPUT -p "\${protocol}" --dport "\${bind_port}" -m comment --comment "\${FW_COMMENT}" -j ACCEPT >/dev/null 2>&1 || \
				iptables -t filter -C INPUT -p "\${protocol}" --dport "\${bind_port}" -j ACCEPT >/dev/null 2>&1 || \
				iptables -t filter -I INPUT -p "\${protocol}" --dport "\${bind_port}" -j ACCEPT >/dev/null 2>&1
			dbus set natmap_rule_\${ID}_fw_port="\${bind_port}"
			dbus set natmap_rule_\${ID}_fw_proto="\${protocol}"
		fi

		# optional user notify script (non-invasive background call)
		if [ -n "\${USER_SCRIPT}" ] && [ -x "\${USER_SCRIPT}" ]; then
			# use start-stop-daemon to prevent blocking natmap
			start-stop-daemon -S -b -q -x "\${USER_SCRIPT}" -- "\$@" >/dev/null 2>&1
		fi
		EOF
	chmod 755 "${script}" >/dev/null 2>&1
}

rule_is_running() {
	local id="$1"
	local pid_file
	pid_file="$(pid_file_for_id "${id}")"
	if [ ! -f "${pid_file}" ]; then
		return 1
	fi
	pid="$(cat "${pid_file}" 2>/dev/null)"
	[ -n "${pid}" ] && kill -0 "${pid}" >/dev/null 2>&1
}

stop_rule() {
	local id="$1"
	local pid_file pid
	pid_file="$(pid_file_for_id "${id}")"
	if [ -f "${pid_file}" ]; then
		pid="$(cat "${pid_file}" 2>/dev/null)"
		if [ -n "${pid}" ] && kill -0 "${pid}" >/dev/null 2>&1; then
			kill "${pid}" >/dev/null 2>&1
		fi
		rm -f "${pid_file}"
	fi
	# cleanup orphaned/duplicated natmap processes after reinstall or concurrent starts
	kill_plugin_natmap_by_rule "${id}"
	# cleanup firewall rules
	fw_cleanup_rule "${id}"
	dbus set natmap_rule_${id}_status="stopped"
}

start_rule() {
	local id="$1"
	local b64 json
	b64="$(dbus get natmap_rule_${id} 2>/dev/null)"
	if [ -z "${b64}" ] || [ "${b64}" = "null" ]; then
		return 0
	fi

	mkdir -p "${LOG_DIR}"
	local log_file pid_file
	log_file="$(log_file_for_id "${id}")"
	pid_file="$(pid_file_for_id "${id}")"

	if [ ! -x "${BIN}" ]; then
		echo_date "rule ${id}: 未找到可执行文件 ${BIN}" >>"${log_file}"
		dbus set natmap_rule_${id}_status="error"
		return 0
	fi

	# stop old
	stop_rule "${id}"

	json="$(echo "${b64}" | base64_decode 2>/dev/null)"
	if [ -z "${json}" ]; then
		echo_date "rule ${id}: 配置解析失败（base64/json）" >>"${log_file}"
		dbus set natmap_rule_${id}_status="error"
		return 0
	fi

	enable="$(json_get "${json}" "enable")"
	if [ "${enable}" != "1" ]; then
		fw_cleanup_rule "${id}"
		dbus set natmap_rule_${id}_status="disabled"
		return 0
	fi

	name="$(json_get "${json}" "name")"
	proto="$(json_get "${json}" "proto")"
	ipver="$(json_get "${json}" "ipver")"
	dbus set natmap_rule_${id}_proto="${proto}"
	dbus set natmap_rule_${id}_ipver="${ipver}"
	iface="$(json_get "${json}" "iface")"
	bind="$(json_get "${json}" "bind")"
	stun="$(json_get "${json}" "stun")"
	http="$(json_get "${json}" "http")"
	keep="$(json_get "${json}" "keep")"
	cycle="$(json_get "${json}" "cycle")"
	fwmark="$(json_get "${json}" "fwmark")"
	target_mode="$(json_get "${json}" "target_mode")"
	target_addr="$(json_get "${json}" "target_addr")"
	target_port="$(json_get "${json}" "target_port")"
	dbus set natmap_rule_${id}_target_mode="${target_mode}"
	dbus set natmap_rule_${id}_target_addr="${target_addr}"
	dbus set natmap_rule_${id}_target_port="${target_port}"
	timeout="$(json_get "${json}" "timeout")"
	ccalgo="$(json_get "${json}" "ccalgo")"
	user_notify="$(json_get "${json}" "notify_script")"

	[ -z "${bind}" ] && bind="0"

	args=""
	if [ "${ipver}" = "6" ]; then
		args="${args} -6"
	else
		args="${args} -4"
	fi
	if [ "${proto}" = "udp" ]; then
		args="${args} -u"
	fi
	if [ -n "${iface}" ]; then
		args="${args} -i ${iface}"
	fi
	if [ -n "${keep}" ]; then
		args="${args} -k ${keep}"
	fi
	if [ -n "${cycle}" ]; then
		args="${args} -c ${cycle}"
	fi
	if [ -z "${stun}" ]; then
		if [ "${proto}" = "tcp" ]; then
			stun="stun.nextcloud.com:3478"
		else
			stun="stun.miwifi.com:3478"
		fi
	fi
	args="${args} -s ${stun}"
	if [ "${proto}" = "tcp" ]; then
		# natmap TCP needs http server
		[ -z "${http}" ] && http="www.baidu.com:80"
		args="${args} -h ${http}"
		if [ -n "${ccalgo}" ]; then
			args="${args} -C ${ccalgo}"
		fi
	fi
	if [ -n "${fwmark}" ]; then
		args="${args} -f ${fwmark}"
	fi
	if [ -n "${bind}" ]; then
		args="${args} -b ${bind}"
	fi
	if [ "${target_mode}" = "relay" ] && [ -n "${target_addr}" ] && [ -n "${target_port}" ]; then
		args="${args} -t ${target_addr} -p ${target_port}"
		if [ -n "${timeout}" ]; then
			args="${args} -T ${timeout}"
		fi
	fi

		write_notify_script "${id}" "${user_notify}"
		args="${args} -e $(notify_script_for_id "${id}")"

	echo_date "rule ${id} (${name}): starting..." >>"${log_file}"
	echo_date "cmd: ${BIN}${args}" >>"${log_file}"

	# shellcheck disable=SC2086
	${BIN} ${args} >>"${log_file}" 2>&1 &
	pid="$!"
	echo "${pid}" >"${pid_file}"

	sleep 1
	if kill -0 "${pid}" >/dev/null 2>&1; then
		dbus set natmap_rule_${id}_status="running"
	else
		dbus set natmap_rule_${id}_status="error"
	fi
}

start_all() {
	# cleanup old rules not in current ids (e.g. after reinstall)
	kill_orphaned_plugin_natmap_not_in_ids
	for id in $(get_rule_ids); do
		start_rule "${id}"
	done
}

stop_all() {
	for id in $(get_rule_ids); do
		stop_rule "${id}"
	done
	# also stop orphaned natmap processes (rules deleted or dbus reset)
	kill_all_plugin_natmap
}

restart_rule() {
	local id="$1"
	stop_rule "${id}"
	start_rule "${id}"
}

delete_rule() {
	local id="$1"
	stop_rule "${id}"
	dbus remove natmap_rule_${id} >/dev/null 2>&1
	dbus remove natmap_rule_${id}_status >/dev/null 2>&1
	dbus remove natmap_rule_${id}_public >/dev/null 2>&1
	dbus remove natmap_rule_${id}_ip4p >/dev/null 2>&1
	dbus remove natmap_rule_${id}_last >/dev/null 2>&1
	dbus remove natmap_rule_${id}_proto >/dev/null 2>&1
	dbus remove natmap_rule_${id}_ipver >/dev/null 2>&1
	dbus remove natmap_rule_${id}_target_mode >/dev/null 2>&1
	dbus remove natmap_rule_${id}_target_addr >/dev/null 2>&1
	dbus remove natmap_rule_${id}_target_port >/dev/null 2>&1
	rm -f "$(notify_script_for_id "${id}")" >/dev/null 2>&1
	rm -f "$(log_file_for_id "${id}")" >/dev/null 2>&1

	new_ids=""
	for rid in $(get_rule_ids); do
		if [ "${rid}" != "${id}" ]; then
			new_ids="${new_ids} ${rid}"
		fi
	done
	set_rule_ids "${new_ids}"
}

add_rule() {
	payload="$(dbus get natmap_rule_payload 2>/dev/null)"
	if [ -z "${payload}" ] || [ "${payload}" = "null" ]; then
		http_response "{\"ok\":0,\"msg\":\"payload empty\"}"
		return 0
	fi

	ids_csv="$(dbus get natmap_rule_ids 2>/dev/null)"
	if [ -z "${ids_csv}" ] || [ "${ids_csv}" = "null" ]; then
		ids_csv=""
	fi
	i=1
	while :; do
		if echo ",${ids_csv}," | grep -q ",${i},"; then
			i=$((i + 1))
		else
			id="${i}"
			break
		fi
	done

	dbus set natmap_rule_${id}="${payload}"
	ids="$(get_rule_ids)"
	if [ -z "${ids}" ]; then
		set_rule_ids "${id}"
	else
		set_rule_ids "${ids} ${id}"
	fi

	dbus remove natmap_rule_payload >/dev/null 2>&1
	dbus set natmap_rule_${id}_status="stopped"
	start_rule "${id}"

	http_response "{\"ok\":1,\"id\":\"${id}\"}"
}

edit_rule() {
	id="$1"
	payload="$(dbus get natmap_rule_payload 2>/dev/null)"
	if [ -z "${id}" ] || [ -z "${payload}" ] || [ "${payload}" = "null" ]; then
		http_response "{\"ok\":0}"
		return 0
	fi
	dbus set natmap_rule_${id}="${payload}"
	dbus remove natmap_rule_payload >/dev/null 2>&1

	# apply immediately
	if rule_is_running "${id}"; then
		restart_rule "${id}"
	else
		start_rule "${id}"
	fi
	http_response "{\"ok\":1}"
}

save_global() { :; }

clear_log() {
	id="$1"
	log_file="$(log_file_for_id "${id}")"
	: >"${log_file}"
	http_response "{\"ok\":1}"
}

start_rule_if_needed() {
	local id="$1"
	local b64 json enable user_notify
	b64="$(dbus get natmap_rule_${id} 2>/dev/null)"
	if [ -z "${b64}" ] || [ "${b64}" = "null" ]; then
		return 0
	fi
	json="$(echo "${b64}" | base64_decode 2>/dev/null)"
	enable="$(json_get "${json}" "enable")"
	user_notify="$(json_get "${json}" "notify_script")"
	# always refresh notify script in case of upgrade/nat-restart
	write_notify_script "${id}" "${user_notify}"
	if [ "${enable}" != "1" ]; then
		dbus set natmap_rule_${id}_status="disabled"
		fw_cleanup_rule "${id}"
		return 0
	fi
	# if pidfile is valid, keep running
	if rule_is_running "${id}"; then
		return 0
	fi
	# try adopt existing process (avoid restart on nat-start)
	pids="$(pidof natmap 2>/dev/null)"
	found=""
	cnt=0
	for p in ${pids}; do
		cmd="$(tr '\0' ' ' </proc/"${p}"/cmdline 2>/dev/null)"
		echo "${cmd}" | grep -q "/koolshare/bin/natmap" || continue
		echo "${cmd}" | grep -q "natmap_notify_${id}\\.sh" || continue
		found="${p}"
		cnt=$((cnt + 1))
	done
	if [ "${cnt}" -eq 1 ] && [ -n "${found}" ]; then
		echo "${found}" >"$(pid_file_for_id "${id}")" 2>/dev/null
		dbus set natmap_rule_${id}_status="running"
		return 0
	fi
	# if multiple, cleanup and restart
	if [ "${cnt}" -gt 1 ]; then
		kill_plugin_natmap_by_rule "${id}"
	fi
	start_rule "${id}"
}

start_all_if_needed() {
	for id in $(get_rule_ids); do
		start_rule_if_needed "${id}"
	done
}

case "$ACTION" in
	start)
		ensure_defaults
		start_all
		;;
	stop)
		stop_all
		;;
	restart)
		stop_all
		start_all
		;;
	start_nat)
		# called by /koolshare/bin/ks-nat-start.sh, after firewall/NAT restart
		ensure_defaults
		kill_orphaned_plugin_natmap_not_in_ids
		start_all_if_needed
		fw_apply_all
		;;
esac

case "$2" in
	1)
		http_response "$1"
		;;
	2)
		add_rule
		;;
	3)
		edit_rule "$3"
		;;
	4)
		start_rule "$3"
		http_response "$1"
		;;
	5)
		stop_rule "$3"
		http_response "$1"
		;;
	6)
		restart_rule "$3"
		http_response "$1"
		;;
	7)
		delete_rule "$3"
		http_response "$1"
		;;
	8)
		clear_log "$3"
		;;
	9)
		start_all
		http_response "$1"
		;;
	10)
		stop_all
		http_response "$1"
		;;
esac
