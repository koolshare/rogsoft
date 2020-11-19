#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
module=fastd1ck
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

# 安装插件
find /koolshare/init.d/ -name "*fastd1ck*" | xargs rm -rf
find /koolshare/init.d/ -name "*FastD1ck*" | xargs rm -rf
cp -rf /tmp/fastd1ck/scripts/* /koolshare/scripts/
cp -rf /tmp/fastd1ck/webs/* /koolshare/webs/
cp -rf /tmp/fastd1ck/res/* /koolshare/res/
cp -rf /tmp/fastd1ck/uninstall.sh /koolshare/scripts/uninstall_fastd1ck.sh
if [ "$ROG" == "1" ];then
	continue
else
	if [ "$TUF" == "1" ];then
		sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /koolshare/webs/Module_${module}.asp >/dev/null 2>&1
	else
		sed -i '/rogcss/d' /koolshare/webs/Module_${module}.asp >/dev/null 2>&1
	fi
fi
chmod +x /koolshare/scripts/fastd1ck*.sh
chmod +x /koolshare/scripts/uninstall_fastd1ck.sh
[ ! -L "/koolshare/init.d/S99fastd1ck.sh" ] && ln -sf /koolshare/scripts/fastd1ck_config.sh /koolshare/init.d/S99fastd1ck.sh

# 离线安装用
dbus set fastd1ck_version="$(cat $DIR/version)"
dbus set softcenter_module_fastd1ck_version="$(cat $DIR/version)"
dbus set softcenter_module_fastd1ck_description="迅雷快鸟，上网必备神器"
dbus set softcenter_module_fastd1ck_install="1"
dbus set softcenter_module_fastd1ck_name="fastd1ck"
dbus set softcenter_module_fastd1ck_title="迅雷快鸟"

# re-enable fastd1ck
if [ "$enable" == "1" ];then
	[ -f "/koolshare/scripts/fastd1ck_config.sh" ] && sh /koolshare/scripts/fastd1ck_config.sh start
fi

# 完成
echo_date "迅雷快鸟插件安装完毕！"
exit_install
