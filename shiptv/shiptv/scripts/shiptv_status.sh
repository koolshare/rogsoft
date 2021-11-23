#!/bin/sh

#alias echo_date='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
model=$(nvram get productid)
eval $(dbus export shiptv_)
DHCP_CONF=/jffs/configs/dnsmasq.d/shiptv.conf
#=================================================
#	错误代码表：
#	1		/jffs/configs/dnsmasq.d/shiptv.conf 文件没有
#	2		dnsmasq进程没有启动
#	4		br0.85虚拟接口未创建
#	8		eth0.85虚拟接口未创建
#	16		vlan85网桥接口未创建
#	32		br0.85虚拟接口未启动
#	64		eth0.85虚拟接口未启动
#	128		vlan85网桥接口未启动
#	256		vlan85网桥未创建
#	512		嗅探功能未启用
#	错误代码3（3=1+2），表示错误1和错误2都发生了
#	错误代码18（18=2+16），表示错误2和错误16都发生了
#	错误代码1020（1020=4+8+16+32+64+128+256+512），表示VLAN穿透相关的设置均未生效
#	其它错误代码均可用二进制换算找到出错的地方
#=================================================
STATUS=0

get_dhcp_status(){
	[ ! -f "$DHCP_CONF" ] && let STATUS+=1
	[ -z "$(pidof dnsmasq)" ] && let STATUS+=2
}

get_vlan_status(){
	val_1=$(ip addr show br0.85 2>/dev/null)
	val_2=$(ip addr show eth0.85 2>/dev/null)
	val_3=$(ip addr show vlan85 2>/dev/null)
	
	val_4=$(ip addr show br0.85|grep -o "state UP" 2>/dev/null)
	val_5=$(ip addr show eth0.85|grep -o "state UP" 2>/dev/null)
	val_6=$(ip addr show vlan85|grep -o "state UP" 2>/dev/null)

	val_7=$(brctl show|grep vlan85)
	val_8=$(bcmmcastctl show|grep -E "br0.85|vlan85")

	[ -z "$val_1" ] && let STATUS+=4
	[ -z "$val_2" ] && let STATUS+=8
	[ -z "$val_3" ] && let STATUS+=16
	[ -z "$val_4" ] && let STATUS+=32
	[ -z "$val_5" ] && let STATUS+=64
	[ -z "$val_6" ] && let STATUS+=128
	[ -z "$val_7" ] && let STATUS+=256
	[ -z "$val_8" ] && let STATUS+=512
}

if [ "$shiptv_dhcp" != "1" -a "$shiptv_vlan" != "1" ];then
	[ "$#" == "2" ] && http_response "${STATUS}@@等待插件开启..."
	exit
elif [ "$shiptv_dhcp" == "1" -a "$shiptv_vlan" != "1" ];then
	get_dhcp_status
elif [ "$shiptv_dhcp" != "1" -a "$shiptv_vlan" == "1" ];then
	get_vlan_status
elif [ "$shiptv_dhcp" == "1" -a "$shiptv_vlan" == "1" ];then
	get_dhcp_status
	get_vlan_status
fi

if [ "$STATUS" == "0" ];then
	[ "$#" == "2" ] && http_response "0@@运行中..."
else
	[ "$#" == "2" ] && http_response "$STATUS@@运行错误"
fi

[ "$#" == "0" ] && echo STATUS CODE: $STATUS
