#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date "+%Y年%m月%d日 %H:%M:%S")】:'

DIR=$(cd "$(dirname "$0")"; pwd)
module=${DIR##*/}

install_now() {
	TITLE="NATMap 端口映射"
	DESCR="NAT1 打洞端口映射工具，支持TCP/UDP，多任务管理"
	PLVER="$(cat "${DIR}/version" 2>/dev/null)"

	if [ -f "/koolshare/scripts/natmap_config.sh" ]; then
		echo_date "安装前先停止 NATMap 任务，以保证更新成功..."
		sh /koolshare/scripts/natmap_config.sh stop >/dev/null 2>&1
	fi

	echo_date "安装插件相关文件..."
	cp -rf "${DIR}/res/"* /koolshare/res/ 2>/dev/null
	cp -rf "${DIR}/scripts/"* /koolshare/scripts/
	cp -rf "${DIR}/webs/"* /koolshare/webs/
	cp -rf "${DIR}/bin/"* /koolshare/bin/
	cp -rf "${DIR}/uninstall.sh" "/koolshare/scripts/uninstall_${module}.sh"

	chmod 755 /koolshare/bin/natmap >/dev/null 2>&1
	chmod 755 /koolshare/scripts/${module}_*.sh >/dev/null 2>&1

	# cleanup deprecated dbus keys (older versions)
	dbus remove ${module}_enable >/dev/null 2>&1
	dbus remove ${module}_default_stun >/dev/null 2>&1
	dbus remove ${module}_default_http >/dev/null 2>&1
	dbus remove ${module}_next_id >/dev/null 2>&1

	# use the newly installed script to stop again, to cleanup orphan natmap processes created by older versions
	echo_date "清理旧版本残留进程..."
	sh /koolshare/scripts/natmap_config.sh stop >/dev/null 2>&1

	echo_date "设置插件默认参数..."
	dbus set ${module}_version="${PLVER}"
	dbus set softcenter_module_${module}_version="${PLVER}"
	dbus set softcenter_module_${module}_install="1"
	dbus set softcenter_module_${module}_name="${module}"
	dbus set softcenter_module_${module}_title="${TITLE}"
	dbus set softcenter_module_${module}_description="${DESCR}"

	# always enable boot auto-start (enabled rules only)
	[ ! -L "/koolshare/init.d/N99natmap.sh" ] && ln -sf /koolshare/scripts/natmap_config.sh /koolshare/init.d/N99natmap.sh

	echo_date "安装完毕，启动已启用的 NATMap 任务..."
	sh /koolshare/scripts/natmap_config.sh start >/dev/null 2>&1

	echo_date "${TITLE}插件安装完毕！"
}

install_now
rm -rf "/tmp/${module}"* >/dev/null 2>&1
exit 0
