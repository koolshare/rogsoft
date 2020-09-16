#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
module=qiandao
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
		if [ "$MODEL" == "TUF-AX3000" -o "$MODEL" == "RT-AX82U" -o "$MODEL" == "RT-AX95Q" ] && [ -d "/koolshare" ];then
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
cp -rf /tmp/qiandao/qiandao /koolshare/
cp -rf /tmp/qiandao/res/* /koolshare/res/
cp -rf /tmp/qiandao/scripts/* /koolshare/scripts/
cp -rf /tmp/qiandao/webs/* /koolshare/webs/
cp -rf /tmp/qiandao/uninstall.sh /koolshare/scripts/uninstall_qiandao.sh
if [ "$ROG" == "1" ];then
	continue
else
	if [ "$TUF" == "1" ];then
		sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /koolshare/webs/Module_${module}.asp >/dev/null 2>&1
	else
		sed -i '/rogcss/d' /koolshare/webs/Module_${module}.asp >/dev/null 2>&1
	fi
fi
rm -rf /koolshare/init.d/*qiandao.sh
[ ! -L "/koolshare/init.d/S99qiandao.sh" ] && ln -sf /koolshare/scripts/qiandao_config.sh /koolshare/init.d/S99qiandao.sh
chmod 755 /koolshare/qiandao/*
chmod 755 /koolshare/scripts/qiandao*
dbus set qiandao_action="2"

# 离线安装用
dbus set qiandao_version="$(cat $DIR/version)"
dbus set softcenter_module_qiandao_version="$(cat $DIR/version)"
dbus set softcenter_module_qiandao_description="自动签到"
dbus set softcenter_module_qiandao_install="1"
dbus set softcenter_module_qiandao_name="qiandao"
dbus set softcenter_module_qiandao_title="自动签到"

# 完成
echo_date "自动签到插件安装完毕！"
exit_install
