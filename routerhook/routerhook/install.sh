#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
module=routerhook
DIR=$(
	cd $(dirname $0)
	pwd
)

remove_install_file() {
	rm -rf /tmp/${module}* >/dev/null 2>&1
}

# 判断路由架构和平台
case $(uname -m) in
aarch64)
	if [ "$(uname -o | grep Merlin)" -a -d "/koolshare" ]; then
		echo_date 固件平台【koolshare merlin hnd/axhnd aarch64】符合安装要求，开始安装插件！
	else
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的固件平台不能安装！！！
		echo_date 退出安装！
		remove_install_file
		exit 1
	fi
	;;
armv7l)
	if [ "$MODEL" == "TUF-AX3000" -a -d "/koolshare" ]; then
		echo_date 固件TUF-AX3000 koolshare官改固件符合安装要求，开始安装插件！
	else
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的固件平台不能安装！！！
		echo_date 退出安装！
		remove_install_file
		exit 1
	fi
	;;
*)
	echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
	echo_date 退出安装！
	remove_install_file
	exit 1
	;;
esac

if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ -n "$(nvram get extendno | grep koolshare)" -a "$MODEL" == "RT-AC86U" ]; then
	# 官改固件，骚红皮肤
	ROG=1
fi

if [ "$MODEL" == "TUF-AX3000" ]; then
	# 官改固件，橙色皮肤
	TUF=1
fi

echo_date "STOP RouterHook FIRST"

# stop routerhook first
enable=$(dbus get routerhook_enable)
if [ "$enable" == "1" ] && [ -f "/koolshare/scripts/routerhook_config.sh" ]; then
	/koolshare/scripts/routerhook_config.sh stop >/dev/null 2>&1
fi

# 安装
echo_date "开始安装RouterHook通知回调..."
cd /tmp
if [[ ! -x /koolshare/bin/jq ]]; then
	cp -f /tmp/routerhook/bin/jq /koolshare/bin/jq
	chmod +x /koolshare/bin/jq
fi
rm -rf /koolshare/init.d/*routerhook.sh
rm -rf /koolshare/routerhook >/dev/null 2>&1
rm -rf /koolshare/scripts/routerhook_*
cp -rf /tmp/routerhook/res/icon-routerhook.png /koolshare/res/
cp -rf /tmp/routerhook/scripts/* /koolshare/scripts/
cp -rf /tmp/routerhook/webs/Module_routerhook.asp /koolshare/webs/
if [ "$ROG" == "1" ]; then
	continue
else
	if [ "$TUF" == "1" ]; then
		sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /koolshare/webs/Module_${module}.asp >/dev/null 2>&1
	else
		sed -i '/rogcss/d' /koolshare/webs/Module_${module}.asp >/dev/null 2>&1
	fi
fi
chmod +x /koolshare/scripts/*

# 设置默认值
router_name=$(echo $(nvram get model) | base64_encode)
router_name_get=$(dbus get routerhook_config_name)
if [ -z "${router_name_get}" ]; then
	dbus set routerhook_config_name="${router_name}"
fi
router_ntp_get=$(dbus get routerhook_config_ntp)
if [ -z "${router_ntp_get}" ]; then
	dbus set routerhook_config_ntp="ntp1.aliyun.com"
fi
bwlist_en_get=$(dbus get routerhook_dhcp_bwlist_en)
if [ -z "${bwlist_en_get}" ]; then
	dbus set routerhook_dhcp_bwlist_en="1"
fi
_sckey=$(dbus get routerhook_config_sckey)
if [ -n "${_sckey}" ]; then
	dbus set routerhook_config_sckey_1=$(dbus get routerhook_config_sckey)
	dbus remove routerhook_config_sckey
fi
[ -z "$(dbus get routerhook_info_lan_macoff)" ] && dbus set routerhook_info_lan_macoff="1"
[ -z "$(dbus get routerhook_info_dhcp_macoff)" ] && dbus set routerhook_info_dhcp_macoff="1"
[ -z "$(dbus get routerhook_trigger_dhcp_macoff)" ] && dbus set routerhook_trigger_dhcp_macoff="1"

# 离线安装用
dbus set routerhook_version="$(cat $DIR/version)"
dbus set softcenter_module_routerhook_version="$(cat $DIR/version)"
dbus set softcenter_module_routerhook_install="1"
dbus set softcenter_module_routerhook_name="routerhook"
dbus set softcenter_module_routerhook_title="RouterHook通知回调"
dbus set softcenter_module_routerhook_description="从路由器推送状态及通知的工具。"

# re-enable routerhook
if [ "$enable" == "1" ] && [ -f "/koolshare/scripts/routerhook_config.sh" ]; then
	/koolshare/scripts/routerhook_config.sh start >/dev/null 2>&1
fi

# 完成
remove_install_file
echo_date "routerhook通知回调插件安装完毕！"
exit 0
