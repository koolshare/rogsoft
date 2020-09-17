#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
module=acme
DIR=$(cd $(dirname $0); pwd)

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
			echo_date "本插件适用于适用于【koolshare 梅林改/官改 hnd/axhnd/axhnd.675x】固件平台，你的固件平台不能安装！！！"
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

# 判断路由架构和平台
case $(uname -m) in
	aarch64)
		if [ "$(uname -o|grep Merlin)" -a -d "/koolshare" ];then
			echo_date 机型：$MODEL $(_get_type) 符合安装要求，开始安装插件！
		else
			exit_install 1
		fi
		;;
	armv7l)
		if [ "$MODEL" == "TUF-AX3000" -o "$MODEL" == "RT-AX82U" -o "$MODEL" == "RT-AX95Q" -o "$MODEL" == "RT-AX56_XD4" ] && [ -d "/koolshare" ];then
			echo_date 机型：$MODEL $(_get_type) 符合安装要求，开始安装插件！
		else
			exit_install 1
		fi
		;;
	*)
		exit_install 1
	;;
esac

if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ -n "$(nvram get extendno | grep koolshare)" -a "$MODEL" == "RT-AC86U" ];then
	# 官改固件，骚红皮肤
	ROG=1
fi

if [ "$MODEL" == "TUF-AX3000" ];then
	# 官改固件，橙色皮肤
	TUF=1
fi

# 安装插件
cd /tmp
cp -rf /tmp/acme/acme /koolshare/
cp -rf /tmp/acme/res/* /koolshare/res/
cp -rf /tmp/acme/scripts/* /koolshare/scripts/
cp -rf /tmp/acme/webs/* /koolshare/webs/
cp -rf /tmp/acme/uninstall.sh /koolshare/scripts/uninstall_acme.sh
[ ! -L "/koolshare/init.d/S99acme.sh" ] && ln -sf /koolshare/scripts/acme_config.sh /koolshare/init.d/S99acme.sh
chmod 755 /koolshare/acme/*
chmod 755 /koolshare/init.d/*
chmod 755 /koolshare/scripts/acme*
if [ "$ROG" == "1" ];then
	echo_date "安装ROG皮肤！"
	continue
else
	if [ "$TUF" == "1" ];then
		echo_date "安装TUF皮肤！"
		sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /koolshare/webs/Module_${module}.asp >/dev/null 2>&1
	else
		echo_date "安装ASUSWRT皮肤！"
		sed -i '/rogcss/d' /koolshare/webs/Module_${module}.asp >/dev/null 2>&1
	fi
fi

# 离线安装需要向skipd写入安装信息
dbus set acme_version="$(cat $DIR/version)"
dbus set softcenter_module_acme_version="$(cat $DIR/version)"
dbus set softcenter_module_acme_install="1"
dbus set softcenter_module_acme_name="acme"
dbus set softcenter_module_acme_title="Let's Encrypt"
dbus set softcenter_module_acme_description="自动部署SSL证书"

# 完成
echo_date "Let's Encrypt插件安装完毕！"
exit_install
