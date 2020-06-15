#!/bin/sh
source /koolshare/scripts/base.sh
eval $(dbus export shiptv_)
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
LOG_FILE=/tmp/upload/shiptv_log.txt
DHCP_CONF=/jffs/configs/dnsmasq.d/shiptv.conf
FLAG=0

# ------ old dhcp backup only-------
#dhcp-option-force=125,00:00:00:00:1a:02:06:48:47:57:2d:43:54:0a:02:20:00:0b:02:00:55:0d:02:00:2e
#dhcp-option=60,00:00:01:00:02:03:43:50:45:03:0e:45:38:20:47:50:4f:4e:20:52:4f:55:54:45:52:04:03:31:2e:30
#dhcp-option=15
#dhcp-option=28
# ----------------------------------

true > $LOG_FILE
http_response "$1"

load_dhcp(){
	echo_date "┌ 加载 DHCP OPTION..."
	rm -rf $DHCP_CONF
	cat >$DHCP_CONF <<-EOF
		dhcp-option-force=125,00:00:00:00:1a:02:06:48:47:57:2d:43:54:03:04:5a:58:48:4e:0a:02:20:00:0b:02:00:55:0d:02:00:2e:3c:1e:00:00:01:00:02:03:43:50:45:03:0e:45:38:20:45:50:4f:4e:20:52:4f:55:54:45:52:04:03:31:2e:30
		dhcp-option=60,00:00:01:06:68:75:61:71:69:6e:02:0a:48:47:55:34:32:31:4e:20:76:33:03:0a:48:47:55:34:32:31:4e:20:76:33:04:10:32:30:30:2e:55:59:59:2e:30:2e:41:2e:30:2e:53:48:05:04:00:01:00:50
		dhcp-option=15
		dhcp-option=28
	EOF
	echo_date "├ 重启dnsmasq服务..."
	service restart_dnsmasq >/dev/null 2>&1
	echo_date "└ 完成！"
}

unload_dhcp(){
	if [ -f "$DHCP_CONF" ];then
		echo_date "┌ 移除 DHCP OPTION"
		rm -rf $DHCP_CONF
		echo_date "├ 重启dnsmasq服务..."
		service restart_dnsmasq >/dev/null 2>&1
		echo_date "└ 完成！"
	else
		[ "$shiptv_dhcp" == "0" ] && echo_date "DHCP OPTION未开启！"
	fi
}

load_vlan(){
	echo_date "┌ 设置 VLAN 穿透..."
	
	echo_date "├ 添加虚拟网卡接口..."
	vconfig set_name_type DEV_PLUS_VID_NO_PAD
	vconfig add eth0 85
	vconfig add br0 85
	
	echo_date "├ 添加网桥并绑定虚拟网卡..."
	brctl addbr vlan85
	brctl addif vlan85 eth0.85
	brctl addif vlan85 br0.85

	echo_date "├ 设定嗅探模式协议为igmp，模式为标准..."
	bcmmcastctl mode -i vlan85 -p 1 -m 1
	
	echo_date "├ 启动虚拟网卡和网桥..."
	ifconfig eth0.85 up
	ifconfig br0.85 up
	ifconfig vlan85 up
	echo_date "└ 完成！"
}

unload_vlan(){
	if [ -n "$(ip addr show br0.85)" -o -n "$(ip addr show eth0.85)" -o -n "$(brctl show|grep vlan85)" ];then
		echo_date "┌ 移除 VLAN 穿透..."
		local val_1=$(ip addr show vlan85|grep -o "state UP")
		local val_2=$(ip addr show br0.85|grep -o "state UP")
		local val_3=$(ip addr show eth0.85|grep -o "state UP")
		[ -n "$val_1" -o -n "$val_2" -o -n "$val_2" ] && echo_date "├ 关闭虚拟网卡和网桥..."
		[ -n "$val_1" ] && ifconfig vlan85 down >/dev/null 2>&1
		[ -n "$val_2" ] && ifconfig br0.85 down >/dev/null 2>&1
		[ -n "$val_3" ] && ifconfig eth0.85 down >/dev/null 2>&1

		# 删除vlan
		if [ -n "$(brctl show|grep vlan85)" ];then
			echo_date "├ 删除虚拟网桥..."
			brctl delbr vlan85 >/dev/null 2>&1
		fi
		
		# 删除虚拟接口
		local val_4=$(ip addr show br0.85)
		local val_5=$(ip addr show eth0.85)
		[ -n "$val_4" -o -n "$val_5" ] && echo_date "├ 删除虚拟网卡接口..."
		[ -n "$val_4" ] && vconfig rem br0.85 >/dev/null 2>&1
		[ -n "$val_5" ] && vconfig rem eth0.85 >/dev/null 2>&1
		echo_date "└ 完成！"
	else
		[ "$shiptv_vlan" == "0" ] && echo_date "VLAN穿透未开启！"
	fi
}


start_iptv(){
	echo_date "============================= 上海电信 IPTV ============================"
	# 先尝试关闭
	unload_dhcp
	unload_vlan
	
	if [ "$shiptv_dhcp" == "1" ];then
		load_dhcp
	fi

	if [ "$shiptv_vlan" == "1" ];then
		load_vlan
	fi

	if [ ! -L "/koolshare/init.d/S95Shiptv.sh" ];then
		ln -sf /koolshare/scripts/shiptv_config.sh /koolshare/init.d/S95Shiptv.sh
	fi
	echo_date "======================================================================="
}

# 开机自启
case $1 in
start)
	[ "$shiptv_dhcp" == "1" -o "$shiptv_vlan" == "1" ] && start_iptv | tee -a $LOG_FILE
	;;
stop)
	unload_dhcp | tee -a $LOG_FILE
	unload_vlan | tee -a $LOG_FILE
	;;
esac

# web提交启动
case $2 in
web_apply)
	#echo_date "$0 $@" | tee -a $LOG_FILE
	start_iptv | tee -a $LOG_FILE
	echo "XU6J03M6" >> $LOG_FILE
	;;
esac
