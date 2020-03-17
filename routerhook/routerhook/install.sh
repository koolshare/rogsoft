#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
DIR=$(cd $(dirname $0); pwd)

# 判断路由架构和平台
case $(uname -m) in
	aarch64)
		if [ "`uname -o|grep Merlin`" ] && [ -d "/koolshare" ];then
			echo_date 固件平台【koolshare merlin hnd/axhnd aarch64】符合安装要求，开始安装插件！
		else
			echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的固件平台不能安装！！！
			echo_date 退出安装！
			rm -rf /tmp/routerhook* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/routerhook* >/dev/null 2>&1
		exit 1
	;;
esac

echo_date "STOP RouterHook FIRST"

# stop routerhook first
enable=`dbus get routerhook_enable`
if [ "$enable" == "1" ] && [ -f "/koolshare/scripts/routerhook_config.sh" ];then
	/koolshare/routerhook/routerhook_config stop >/dev/null 2>&1
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
if [ "`nvram get model`" == "GT-AC5300" ] || [ "`nvram get model`" == "GT-AX11000" ] || [ -n "`nvram get extendno | grep koolshare`" -a "`nvram get productid`" == "RT-AC86U" ];then
	cp -rf /tmp/routerhook/ROG/webs/Module_routerhook.asp /koolshare/webs/
fi
chmod +x /koolshare/scripts/*

# 设置默认值
router_name=`echo $(nvram get model) | base64_encode`
router_name_get=`dbus get routerhook_config_name`
if [ -z "${router_name_get}" ]; then
    dbus set routerhook_config_name="${router_name}"
fi
router_ntp_get=`dbus get routerhook_config_ntp`
if [ -z "${router_ntp_get}" ]; then
    dbus set routerhook_config_ntp="ntp1.aliyun.com"
fi
bwlist_en_get=`dbus get routerhook_dhcp_bwlist_en`
if [ -z "${bwlist_en_get}" ]; then
    dbus set routerhook_dhcp_bwlist_en="1"
fi
_sckey=`dbus get routerhook_config_sckey`
if [ -n "${_sckey}" ]; then
    dbus set routerhook_config_sckey_1=`dbus get routerhook_config_sckey`
    dbus remove routerhook_config_sckey
fi
[ -z "`dbus get routerhook_info_lan_macoff`" ] && dbus set routerhook_info_lan_macoff="1"
[ -z "`dbus get routerhook_info_dhcp_macoff`" ] && dbus set routerhook_info_dhcp_macoff="1"
[ -z "`dbus get routerhook_trigger_dhcp_macoff`" ] && dbus set routerhook_trigger_dhcp_macoff="1"

# 离线安装用
dbus set routerhook_version="$(cat $DIR/version)"
dbus set softcenter_module_routerhook_version="$(cat $DIR/version)"
dbus set softcenter_module_routerhook_install="1"
dbus set softcenter_module_routerhook_name="routerhook"
dbus set softcenter_module_routerhook_title="routerhook通知回调"
dbus set softcenter_module_routerhook_description="从路由器推送状态及通知的工具。"

# re-enable routerhook
if [ "$enable" == "1" ] && [ -f "/koolshare/scripts/routerhook_config.sh" ];then
	/koolshare/routerhook/routerhook_config start >/dev/null 2>&1
fi

# 完成
rm -rf /tmp/routerhook* >/dev/null 2>&1
echo_date "routerhook通知回调插件安装完毕！"
exit 0
