#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo [$(TZ=UTC-8 date "+%Y年%m月%d日 %H:%M:%S")]:'

eval "$(dbus export gostun_)"

LOG_FILE="/tmp/upload/gostun_log.txt"
PID_FILE="/tmp/gostun_detect.pid"

run_detect() {
	mkdir -p /tmp/upload
	: >"${LOG_FILE}"

	if [ -f "${PID_FILE}" ]; then
		OLD_PID="$(cat "${PID_FILE}" 2>/dev/null)"
		if [ -n "${OLD_PID}" ] && kill -0 "${OLD_PID}" >/dev/null 2>&1; then
			kill "${OLD_PID}" >/dev/null 2>&1
		fi
		rm -f "${PID_FILE}"
	fi

	dbus set gostun_running="1"

	(
		echo_date "Gostun NAT检测开始..."

		REMOVED_FORWARD_DROP="0"
		REMOVED_INPUT_DROP="0"
		FW_ADJUSTED="0"
		restore_fw_rules() {
			if [ "${REMOVED_INPUT_DROP}" = "1" ]; then
				iptables -t filter -A INPUT -j DROP >/dev/null 2>&1
			fi
			if [ "${REMOVED_FORWARD_DROP}" = "1" ]; then
				iptables -t filter -A FORWARD -j DROP >/dev/null 2>&1
			fi
			if [ "${FW_ADJUSTED}" = "1" ]; then
				echo_date "检测结束，恢复防火墙规则"
			else
				echo_date "检测结束"
			fi
			echo "XU6J03M6"
			dbus set gostun_running="0"
			if [ -f "${PID_FILE}" ] && [ "$(cat "${PID_FILE}" 2>/dev/null)" = "$$" ]; then
				rm -f "${PID_FILE}"
			fi
		}
		trap restore_fw_rules EXIT
		echo $$ >"${PID_FILE}"

		if [ ! -x "/koolshare/bin/gostun" ]; then
			echo_date "错误：未找到 /koolshare/bin/gostun"
			exit 0
		fi

		if [ -z "${gostun_server}" ] || [ "${gostun_server}" = "null" ]; then
			gostun_server="auto"
			dbus set gostun_server="${gostun_server}"
		fi
		if [ -z "${gostun_custom}" ] || [ "${gostun_custom}" = "null" ]; then
			gostun_custom=""
			dbus set gostun_custom=""
		fi

		dbus set gostun_last_run="$(date +%Y-%m-%d_%H:%M:%S)"

		if iptables -t filter -S 2>/dev/null | grep -q -e "-A INPUT -j DROP"; then
			if iptables -t filter -D INPUT -j DROP >/dev/null 2>&1; then
				REMOVED_INPUT_DROP="1"
				FW_ADJUSTED="1"
			fi
		fi

		if iptables -t filter -S 2>/dev/null | grep -q -e "-A FORWARD -j DROP"; then
			if iptables -t filter -D FORWARD -j DROP >/dev/null 2>&1; then
				REMOVED_FORWARD_DROP="1"
				FW_ADJUSTED="1"
			fi
		fi

		if [ "${FW_ADJUSTED}" = "1" ]; then
			echo_date "调整防火墙规则，以保证检测准确性"
		fi

		server=""
		TMP_GOSTUN_OUT="/tmp/gostun_out_$$.txt"
		run_gostun() {
			echo_date "-------------------- gostun 输出开始 --------------------"
			/koolshare/bin/gostun "$@" >"${TMP_GOSTUN_OUT}" 2>&1
			GOSTUN_RET=$?
			sed 's/^/[gostun] /' "${TMP_GOSTUN_OUT}"
			rm -f "${TMP_GOSTUN_OUT}"
			echo_date "-------------------- gostun 输出结束（exit=${GOSTUN_RET}） --------------------"
			return 0
		}

		if [ -z "${gostun_server}" ] || [ "${gostun_server}" = "auto" ]; then
			echo_date "STUN服务器：gostun自动选择"
			run_gostun -type ipv4 -timeout 3
			server="auto"
		elif [ "${gostun_server}" = "custom" ]; then
			server="${gostun_custom}"
			if [ -z "${server}" ]; then
				echo_date "错误：自定义STUN服务器不能为空！"
				exit 0
			fi
			echo_date "STUN服务器：${server}"
			run_gostun -type ipv4 -timeout 3 -server "${server}"
		else
			server="${gostun_server}"
			echo_date "STUN服务器：${server}"
			run_gostun -type ipv4 -timeout 3 -server "${server}"
		fi
	) >>"${LOG_FILE}" 2>&1 &
}

case "$2" in
1)
	run_detect
	;;
2)
	mkdir -p /tmp/upload
	echo "" >"${LOG_FILE}"
	echo "XU6J03M6" >>"${LOG_FILE}"
	rm -f "${PID_FILE}"
	dbus set gostun_running="0"
	;;
*)
	;;
esac

http_response "$1"
