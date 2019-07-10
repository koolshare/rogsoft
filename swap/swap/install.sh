#! /bin/sh
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
			rm -rf /tmp/swap* >/dev/null 2>&1
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于【koolshare merlin hnd/axhnd aarch64】固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/swap* >/dev/null 2>&1
		exit 1
	;;
esac

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
	/koolshare/bin/ks-mount-start.sh start
	EOF
	chmod +x /jffs/scripts/post-mount
else
	STARTCOMAND2=`cat /jffs/scripts/post-mount | grep ks-mount-start`
	[ -z "$STARTCOMAND2" ] && sed -i '1a /koolshare/bin/ks-mount-start.sh start' /jffs/scripts/post-mount
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
rm -rf /tmp/swap* >/dev/null 2>&1
exit 0
