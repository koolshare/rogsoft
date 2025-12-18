#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date "+%Y年%m月%d日 %H:%M:%S")】:'

DIR=$(cd "$(dirname "$0")"; pwd)
module=${DIR##*/}

install_now() {
	TITLE="Gostun NAT检测"
	DESCR="本机NAT类型检测工具，测得你路由网络的NAT类型上限"
	PLVER="$(cat "${DIR}/version" 2>/dev/null)"

	echo_date "安装插件相关文件..."
	cp -rf "${DIR}/res/"* /koolshare/res/ 2>/dev/null
	cp -rf "${DIR}/scripts/"* /koolshare/scripts/
	cp -rf "${DIR}/webs/"* /koolshare/webs/
	cp -rf "${DIR}/bin/"* /koolshare/bin/
	cp -rf "${DIR}/uninstall.sh" "/koolshare/scripts/uninstall_${module}.sh"

	chmod 755 /koolshare/bin/gostun >/dev/null 2>&1
	chmod 755 /koolshare/scripts/${module}_*.sh >/dev/null 2>&1

	echo_date "设置插件默认参数..."
	dbus set ${module}_version="${PLVER}"
	dbus set softcenter_module_${module}_version="${PLVER}"
	dbus set softcenter_module_${module}_install="1"
	dbus set softcenter_module_${module}_name="${module}"
	dbus set softcenter_module_${module}_title="${TITLE}"
	dbus set softcenter_module_${module}_description="${DESCR}"

	# keep user config on upgrade; treat "null" as empty
	old_server="$(dbus get gostun_server)"
	if [ -z "${old_server}" ] || [ "${old_server}" = "null" ]; then
		dbus set gostun_server="auto"
	elif [ "${old_server}" != "auto" ] && [ "${old_server}" != "custom" ]; then
		# migrate old fixed server selection to custom
		old_custom="$(dbus get gostun_custom)"
		if [ -z "${old_custom}" ] || [ "${old_custom}" = "null" ]; then
			dbus set gostun_custom="${old_server}"
		fi
		dbus set gostun_server="custom"
	fi
	old_custom="$(dbus get gostun_custom)"
	if [ -z "${old_custom}" ] || [ "${old_custom}" = "null" ]; then
		dbus set gostun_custom=""
	fi

	echo_date "${TITLE}插件安装完毕！"
}

install_now
rm -rf "/tmp/${module}"* >/dev/null 2>&1
exit 0
