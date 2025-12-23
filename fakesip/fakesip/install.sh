#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date "+%Y年%m月%d日 %H:%M:%S")】:'

DIR=$(cd "$(dirname "$0")"; pwd)
module=${DIR##*/}

install_now() {
	TITLE="FakeSIP 伪装"
	DESCR="将 UDP 流量伪装为 SIP 协议（NFQUEUE），用于网络流量混淆"
	PLVER="$(cat "${DIR}/version" 2>/dev/null)"

	if [ -f "/koolshare/scripts/fakesip_config.sh" ]; then
		echo_date "安装前先停止 FakeSIP，以保证更新成功..."
		sh /koolshare/scripts/fakesip_config.sh stop >/dev/null 2>&1
	fi

	echo_date "安装插件相关文件..."
	cp -rf "${DIR}/res/"* /koolshare/res/ 2>/dev/null
	cp -rf "${DIR}/scripts/"* /koolshare/scripts/
	cp -rf "${DIR}/webs/"* /koolshare/webs/
	cp -rf "${DIR}/bin/"* /koolshare/bin/
	cp -rf "${DIR}/uninstall.sh" "/koolshare/scripts/uninstall_${module}.sh"

	chmod 755 /koolshare/bin/fakesip >/dev/null 2>&1
	chmod 755 /koolshare/scripts/${module}_*.sh >/dev/null 2>&1

	echo_date "设置插件默认参数..."
	dbus set ${module}_version="${PLVER}"
	dbus set softcenter_module_${module}_version="${PLVER}"
	dbus set softcenter_module_${module}_install="1"
	dbus set softcenter_module_${module}_name="${module}"
	dbus set softcenter_module_${module}_title="${TITLE}"
	dbus set softcenter_module_${module}_description="${DESCR}"

	# init defaults without overwriting existing user config
	[ -z "$(dbus get ${module}_enable 2>/dev/null)" ] && dbus set ${module}_enable="0"

	echo_date "安装完毕！"

	# auto start only if enabled
	if [ "$(dbus get ${module}_enable 2>/dev/null)" = "1" ]; then
		echo_date "检测到已启用，尝试启动 FakeSIP..."
		sh /koolshare/scripts/fakesip_config.sh start >/dev/null 2>&1
	fi
}

install_now
rm -rf "/tmp/${module}"* >/dev/null 2>&1
exit 0

