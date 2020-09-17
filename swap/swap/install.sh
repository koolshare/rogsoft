#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)
module=swap
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
find /koolshare/init.d/ -name "*swap.sh*"|xargs rm -rf
cd /tmp
cp -rf /tmp/swap/bin/* /koolshare/bin/
cp -rf /tmp/swap/scripts/* /koolshare/scripts/
cp -rf /tmp/swap/init.d/* /koolshare/init.d/
cp -rf /tmp/swap/webs/* /koolshare/webs/
cp -rf /tmp/swap/res/* /koolshare/res/
cd /

if [ ! -f "/jffs/scripts/post-mount" ];then
	cat > /jffs/scripts/post-mount <<-EOF
	#!/bin/sh
	/koolshare/bin/ks-mount-start.sh start \$1
	EOF
else
	STARTCOMAND3=$(cat /jffs/scripts/post-mount | grep -c "/koolshare/bin/ks-mount-start.sh start \$1")
	[ "$STARTCOMAND3" -gt "1" ] && sed -i '/ks-mount-start.sh/d' /jffs/scripts/post-mount && sed -i '1a /koolshare/bin/ks-mount-start.sh start $1' /jffs/scripts/post-mount
	[ "$STARTCOMAND3" == "0" ] && sed -i '/ks-mount-start.sh/d' /jffs/scripts/post-mount && sed -i '1a /koolshare/bin/ks-mount-start.sh start $1' /jffs/scripts/post-mount
fi
chmod +x /jffs/scripts/post-mount
chmod +X /koolshare/bin/*
chmod +X /koolshare/scripts/swap*
chmod +X /koolshare/init.d/*

# 离线安装用
dbus set swap_version="$(cat $DIR/version)"
dbus set softcenter_module_swap_version="$(cat $DIR/version)"
dbus set softcenter_module_swap_description="让路由器运行更稳定~"
dbus set softcenter_module_swap_install="1"
dbus set softcenter_module_swap_name="swap"
dbus set softcenter_module_swap_title="虚拟内存"

# 完成
echo_date "虚拟内存插件安装完毕！"
exit_install
