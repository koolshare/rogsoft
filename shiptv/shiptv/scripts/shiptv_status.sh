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
#	8		ethX.85虚拟接口未创建（X为动态检测的WAN口号）
#	16		vlan85网桥接口未创建
#	32		br0.85虚拟接口未启动
#	64		ethX.85虚拟接口未启动（X为动态检测的WAN口号）
#	128		vlan85网桥接口未启动
#	256		vlan85网桥未创建
#	512		嗅探功能未启用
#	1024	WAN口已变更，VLAN配置绑定到错误的接口
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
	# 动态检测现有的 VLAN 接口
	local existing_eth_vlan=$(ip addr 2>/dev/null | grep -o 'eth[0-9]\+\.85' | head -1)
	
	# 检测当前的WAN口
	local current_wan_port=""
	for iface in $(ip addr | grep -o 'eth[0-9]\+' | sort -u); do
		if ! ip addr show $iface | grep -q "master br0"; then
			current_wan_port=$iface
			break
		fi
	done
	
	val_1=$(ip addr show br0.85 2>/dev/null)
	val_2=""
	val_3=$(ip addr show vlan85 2>/dev/null)
	
	# 如果找到了 ethX.85 接口，检查其状态
	if [ -n "$existing_eth_vlan" ]; then
		val_2=$(ip addr show $existing_eth_vlan 2>/dev/null)
	fi
	
	val_4=$(ip addr show br0.85 2>/dev/null | grep -o "state UP")
	val_5=""
	val_6=$(ip addr show vlan85 2>/dev/null | grep -o "state UP")
	
	# 如果找到了 ethX.85 接口，检查其UP状态
	if [ -n "$existing_eth_vlan" ]; then
		val_5=$(ip addr show $existing_eth_vlan 2>/dev/null | grep -o "state UP")
	fi

	val_7=$(brctl show 2>/dev/null | grep vlan85)
	val_8=$(bcmmcastctl show 2>/dev/null | grep -E "br0.85|vlan85")

	[ -z "$val_1" ] && let STATUS+=4
	[ -z "$val_2" ] && let STATUS+=8
	[ -z "$val_3" ] && let STATUS+=16
	[ -z "$val_4" ] && let STATUS+=32
	[ -z "$val_5" ] && let STATUS+=64
	[ -z "$val_6" ] && let STATUS+=128
	[ -z "$val_7" ] && let STATUS+=256
	[ -z "$val_8" ] && let STATUS+=512
	
	# 检查WAN口是否已变更 - 如果存在VLAN配置但WAN口不匹配
	if [ -n "$existing_eth_vlan" -a -n "$current_wan_port" ]; then
		local existing_wan_port=$(echo $existing_eth_vlan | cut -d'.' -f1)
		if [ "$existing_wan_port" != "$current_wan_port" ]; then
			let STATUS+=1024
		fi
	fi
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
