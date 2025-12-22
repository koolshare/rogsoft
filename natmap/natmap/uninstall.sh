#!/bin/sh
source /koolshare/scripts/base.sh

module="natmap"

if [ -f "/koolshare/scripts/natmap_config.sh" ]; then
	sh /koolshare/scripts/natmap_config.sh stop >/dev/null 2>&1
fi

stop_rule_by_id() {
	local id="$1"
	local pid_file="/tmp/natmap_${id}.pid"
	if [ -f "${pid_file}" ]; then
		local pid
		pid="$(cat "${pid_file}" 2>/dev/null)"
		if [ -n "${pid}" ] && kill -0 "${pid}" >/dev/null 2>&1; then
			kill "${pid}" >/dev/null 2>&1
		fi
		rm -f "${pid_file}"
	fi
	rm -f "/koolshare/scripts/natmap_notify_${id}.sh" >/dev/null 2>&1
}

ids="$(dbus get natmap_rule_ids | tr ',' ' ')"
for id in ${ids}; do
	stop_rule_by_id "${id}"
done

rm -f /koolshare/webs/Module_natmap.asp
rm -f /koolshare/scripts/natmap_*.sh
rm -f /koolshare/scripts/uninstall_natmap.sh
rm -f /koolshare/bin/natmap
rm -f /koolshare/res/icon-natmap.png
rm -f /koolshare/init.d/N99natmap.sh >/dev/null 2>&1

rm -f /tmp/upload/natmap_*.log >/dev/null 2>&1

values=$(dbus list natmap_ | cut -d "=" -f 1)
for value in $values; do
	dbus remove "$value"
done

exit 0
