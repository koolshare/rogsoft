#!/bin/sh
. /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date "+%Y年%m月%d日 %H:%M:%S")】:'

DIR="$(cd "$(dirname "$0")" && pwd)"
module="${DIR##*/}"

install_now() {
	TITLE="Npc 内网穿透"
	DESCR="nps 客户端（npc），用于内网穿透"
	PLVER="$(cat "${DIR}/version" 2>/dev/null)"

	echo_date "安装插件相关文件..."
	cp -rf "${DIR}/res/"* /koolshare/res/ 2>/dev/null
	cp -rf "${DIR}/scripts/"* /koolshare/scripts/
	cp -rf "${DIR}/webs/"* /koolshare/webs/
	cp -rf "${DIR}/bin/"* /koolshare/bin/
	cp -rf "${DIR}/uninstall.sh" "/koolshare/scripts/uninstall_${module}.sh"

	chmod 755 /koolshare/bin/npc >/dev/null 2>&1
	chmod 755 /koolshare/scripts/${module}_*.sh >/dev/null 2>&1

	echo_date "设置插件默认参数..."
	dbus set ${module}_version="${PLVER}"
	dbus set softcenter_module_${module}_version="${PLVER}"
	dbus set softcenter_module_${module}_install="1"
	dbus set softcenter_module_${module}_name="${module}"
	dbus set softcenter_module_${module}_title="${TITLE}"
	dbus set softcenter_module_${module}_description="${DESCR}"

	# defaults
	if [ -z "$(dbus get ${module}_enable 2>/dev/null)" ]; then
		dbus set ${module}_enable="0"
	fi
	if [ -z "$(dbus get ${module}_mode 2>/dev/null)" ]; then
		dbus set ${module}_mode="conf"
	fi
	if [ -z "$(dbus get ${module}_conn_type 2>/dev/null)" ]; then
		dbus set ${module}_conn_type="tcp"
	fi
	if [ -z "$(dbus get ${module}_log_level 2>/dev/null)" ]; then
		dbus set ${module}_log_level="7"
	fi
	if [ -z "$(dbus get ${module}_auto_reconnection 2>/dev/null)" ]; then
		dbus set ${module}_auto_reconnection="true"
	fi

	[ ! -L "/koolshare/init.d/N99npc.sh" ] && ln -sf /koolshare/scripts/npc_config.sh /koolshare/init.d/N99npc.sh

	echo_date "安装完毕！"
}

install_now
rm -rf "/tmp/${module}"* >/dev/null 2>&1
exit 0

