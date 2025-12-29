#!/bin/sh

. /koolshare/scripts/base.sh

BIN="/koolshare/bin/npc"
pid="$(pidof npc 2>/dev/null)"
ver="$(${BIN} -version 2>/dev/null | tr -d '\r' | head -n 1)"
[ -z "${ver}" ] && ver="unknown"

if [ -n "${pid}" ]; then
	http_response "npc ${ver} 运行中，PID: ${pid}"
else
	http_response "npc ${ver} 未运行"
fi

