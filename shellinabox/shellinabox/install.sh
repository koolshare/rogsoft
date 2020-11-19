#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
module=shellinabox
DIR=$(cd $(dirname $0); pwd)
ROG_86U=0
EXT_NU=$(nvram get extendno)
EXT_NU=${EXT_NU%_*}
odmpid=$(nvram get odmpid)
productid=$(nvram get productid)
[ -n "${odmpid}" ] && MODEL="${odmpid}" || MODEL="${productid}"
LINUX_VER=$(uname -r|awk -F"." '{print $1$2}')

# 获取固件类型
_get_type() {
	local FWTYPE=$(nvram get extendno|grep koolshare)
	if [ -d "/koolshare" ];then
		if [ -n $FWTYPE ];then
			echo "koolshare官改固件"
		else
			echo "koolshare梅林改版固件"
		fi
	else
		if [ "$(uname -o|grep Merlin)" ];then
			echo "梅林原版固件"
		else
			echo "华硕官方固件"
		fi
	fi
}

exit_install(){
	local state=$1
	case $state in
		1)
			echo_date "本插件适用于【koolshare 梅林改/官改 hnd/axhnd/axhnd.675x】固件平台！"
			echo_date "你的固件平台不能安装！！!"
			echo_date "本插件支持机型/平台：https://github.com/koolshare/rogsoft#rogsoft"
			echo_date "退出安装！"
			rm -rf /tmp/${module}* >/dev/null 2>&1
			exit 1
			;;
		0|*)
			rm -rf /tmp/${module}* >/dev/null 2>&1
			exit 0
			;;
	esac
}

# 判断路由架构和平台：koolshare固件，并且linux版本大于等于4.1
if [ -d "/koolshare" -a -f "/usr/bin/skipd" -a "${LINUX_VER}" -ge "41" ];then
	echo_date 机型：${MODEL} $(_get_type) 符合安装要求，开始安装插件！
else
	exit_install 1
fi

# 判断固件UI类型
if [ -n "$(nvram get extendno | grep koolshare)" -a "$(nvram get productid)" == "RT-AC86U" -a "${EXT_NU}" -lt "81918" ];then
	ROG_86U=1
fi

if [ "${MODEL}" == "GT-AC5300" -o "${MODEL}" == "GT-AX11000" -o "${MODEL}" == "GT-AX11000_BO4"  -o "$ROG_86U" == "1" ];then
	# 官改固件，骚红皮肤
	ROG=1
fi

if [ "${MODEL}" == "TUF-AX3000" ];then
	# 官改固件，橙色皮肤
	TUF=1
fi

# stop shellinaboxd
killall shellinaboxd >/dev/null 2>&1

# 安装插件
rm -rf /koolshare/init.d/*shellinabox*
cp -rf /tmp/shellinabox/shellinabox /koolshare/
cp -rf /tmp/shellinabox/res/* /koolshare/res/
cp -rf /tmp/shellinabox/scripts/* /koolshare/scripts/
cp -rf /tmp/shellinabox/webs/* /koolshare/webs/
cp -rf /tmp/shellinabox/uninstall.sh /koolshare/scripts/uninstall_shellinabox
chmod 755 /koolshare/shellinabox/*	
chmod 755 /koolshare/scripts/*
# open in new window
dbus set softcenter_module_shellinabox_install="1"
dbus set softcenter_module_shellinabox_target="target=_blank"
dbus remove shellinabox_enable

# enable shellinaboxd
PID=`pidof shellinaboxd`
[ -z "$PID" ] && /koolshare/shellinabox/shellinaboxd --css=/koolshare/shellinabox/white-on-black.css -b

# 离线安装用
dbus set shellinabox_version="$(cat $DIR/version)"
dbus set softcenter_module_shellinabox_version="$(cat $DIR/version)"
dbus set softcenter_module_shellinabox_description="超强的SSH网页客户端~"
dbus set softcenter_module_shellinabox_install="1"
dbus set softcenter_module_shellinabox_name="shellinabox"
dbus set softcenter_module_shellinabox_title="shellinabox工具箱"

# 完成
echo_date "shellinabox插件安装完毕！"
exit_install
