#!/bin/sh

#alias echo_date='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
model=$(nvram get productid)
#=================================================

# CPU温度
cpu_temperature_origin=$(cat /sys/class/thermal/thermal_zone0/temp)
#cpu_temperature=$(expr $cpu_temperature_origin / 1000)
cpu_temperature="CPU：$(awk 'BEGIN{printf "%.1f\n",('$cpu_temperature_origin'/'1000')}')°C"

#网卡温度
case "$model" in
GT-AC5300|GT-AX11000|RT-AX95Q|RT-AX92U)
	interface_2g=$(nvram get wl0_ifname)
	interface_5g1=$(nvram get wl1_ifname)
	interface_5g2=$(nvram get wl2_ifname)
	interface_2g_temperature=$(wl -i ${interface_2g} phy_tempsense | awk '{print $1}') 2>/dev/null
	interface_5g1_temperature=$(wl -i ${interface_5g1} phy_tempsense | awk '{print $1}') 2>/dev/null
	interface_5g2_temperature=$(wl -i ${interface_5g2} phy_tempsense | awk '{print $1}') 2>/dev/null
	interface_2g_power=$(wl -i ${interface_2g} txpwr_target_max | awk '{print $NF}') 2>/dev/null
	interface_5g1_power=$(wl -i ${interface_5g1} txpwr_target_max | awk '{print $NF}') 2>/dev/null
	interface_5g2_power=$(wl -i ${interface_5g2} txpwr_target_max | awk '{print $NF}') 2>/dev/null
	[ -n "${interface_2g_temperature}" ] && interface_2g_temperature_c="$(expr ${interface_2g_temperature} / 2 + 20)°C" || interface_2g_temperature_c="offline"
	[ -n "${interface_5g1_temperature}" ] && interface_5g1_temperature_c="$(expr ${interface_5g1_temperature} / 2 + 20)°C" || interface_5g1_temperature_c="offline"
	[ -n "${interface_5g2_temperature}" ] && interface_5g2_temperature_c="$(expr ${interface_5g2_temperature} / 2 + 20)°C" || interface_5g2_temperature_c="offline"
	wl_temperature="2.4G：${interface_2g_temperature_c} &nbsp;&nbsp;|&nbsp;&nbsp; 5G-1：${interface_5g1_temperature_c} &nbsp;&nbsp;|&nbsp;&nbsp; 5G-2：${interface_5g2_temperature_c}"
	if [ -n "${interface_2g_power}" -o -n "${interface_5g1_power}" -o -n "${interface_5g2_power}" ];then
		[ -n "${interface_2g_power}" ] && interface_2g_power_d="${interface_2g_power} dBm" || interface_2g_power_d="offline"
		[ -n "${interface_2g_power}" ] && interface_2g_power_p="$(awk -v x=${interface_2g_power} 'BEGIN { printf "%.2f\n", 10^(x/10)}') mw" || interface_2g_power_p="offline"
		
		[ -n "${interface_5g1_power}" ] && interface_5g1_power_d="${interface_5g1_power} dBm" || interface_5g1_power_d="offline"
		[ -n "${interface_5g1_power}" ] && interface_5g1_power_p="$(awk -v x=${interface_5g1_power} 'BEGIN { printf "%.2f\n", 10^(x/10)}') mw" || interface_5g1_power_p="offline"
		
		[ -n "${interface_5g2_power}" ] && interface_5g2_power_d="${interface_5g2_power} dBm" || interface_5g2_power_d="offline"
		[ -n "${interface_5g2_power}" ] && interface_5g2_power_p="$(awk -v x=${interface_5g2_power} 'BEGIN { printf "%.2f\n", 10^(x/10)}') mw" || interface_5g2_power_p="offline"
		wl_txpwr="2.4G：${interface_2g_power_d} / ${interface_2g_power_p} <br /> 5G-1：${interface_5g1_power_d} / ${interface_5g1_power_p} <br /> 5G-2：${interface_5g2_power_d} / ${interface_5g2_power_p}"
	else
		wl_txpwr=""
	fi
	;;
RT-AC86U|RT-AX88U|TUF-AX3000|*)
	interface_2g=$(nvram get wl0_ifname)
	interface_5g1=$(nvram get wl1_ifname)
	interface_2g_temperature=$(wl -i ${interface_2g} phy_tempsense | awk '{print $1}') 2>/dev/null
	interface_5g1_temperature=$(wl -i ${interface_5g1} phy_tempsense | awk '{print $1}') 2>/dev/null
	[ -n "${interface_2g_temperature}" ] && interface_2g_temperature_c="$(expr ${interface_2g_temperature} / 2 + 20)°C" || interface_2g_temperature_c="offline"
	[ -n "${interface_5g1_temperature}" ] && interface_5g1_temperature_c="$(expr ${interface_5g1_temperature} / 2 + 20)°C" || interface_5g1_temperature_c="offline"
	wl_temperature="2.4G：${interface_2g_temperature_c} &nbsp;&nbsp;|&nbsp;&nbsp; 5G：${interface_5g1_temperature_c}"
	
	interface_2g_power=$(wl -i ${interface_2g} txpwr_target_max | awk '{print $NF}') 2>/dev/null
	interface_5g1_power=$(wl -i ${interface_5g1} txpwr_target_max | awk '{print $NF}') 2>/dev/null
	if [ -n "${interface_2g_power}" -o -n "${interface_5g1_power}" ];then
		[ -n "${interface_2g_power}" ] && interface_2g_power_d="${interface_2g_power} dBm" || interface_2g_power_d="offline"
		[ -n "${interface_2g_power}" ] && interface_2g_power_p="$(awk -v x=${interface_2g_power} 'BEGIN { printf "%.2f\n", 10^(x/10)}') mw" || interface_2g_power_p="offline"
		
		[ -n "${interface_5g1_power}" ] && interface_5g1_power_d="${interface_5g1_power} dBm" || interface_5g1_power_d="offline"
		[ -n "${interface_5g1_power}" ] && interface_5g1_power_p="$(awk -v x=${interface_5g1_power} 'BEGIN { printf "%.2f\n", 10^(x/10)}') mw" || interface_5g1_power_p="offline"
		wl_txpwr="2.4G：${interface_2g_power_d} / ${interface_2g_power_p} <br /> 5G：&nbsp;&nbsp;&nbsp;${interface_5g1_power_d} / ${interface_5g1_power_p}"
	else
		wl_txpwr=""
	fi
	;;
esac
#=================================================
http_response "${cpu_temperature}@@${wl_temperature}@@${wl_txpwr}"
