#!/bin/sh

#alias echo_date='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
#=================================================

_get_model(){
	local odmpid=$(nvram get odmpid)
	local MODEL=$(nvram get productid)
	if [ -n "${odmpid}" ];then
		echo "${odmpid}"
	else
		echo "${MODEL}"
	fi
}

get_cpu_temp(){
	# CPU温度
	if [ "$(nvram get odmpid)" == "RT-AX89X" ];then
		cpu_temp_origin=$(cat /sys/class/thermal/thermal_zone0/temp)
		cpu_temp="$(awk 'BEGIN{printf "%.0f\n",('$cpu_temp_origin')}')°C"
	else
		cpu_temp_origin=$(cat /sys/class/thermal/thermal_zone0/temp)
		cpu_temp="$(awk 'BEGIN{printf "%.1f\n",('$cpu_temp_origin'/'1000')}')°C"
	fi
}

get_sta_info(){
	local ifnames=$(nvram get sta_ifnames)
	if [ -n "${ifnames}" ];then
		interface_band0=$(echo "${ifnames}" | sed 's/[[:space:]]/\n/g' | sed -n '1p')
		interface_band1=$(echo "${ifnames}" | sed 's/[[:space:]]/\n/g' | sed -n '2p')
		interface_band2=$(echo "${ifnames}" | sed 's/[[:space:]]/\n/g' | sed -n '3p')
		interface_band3=$(echo "${ifnames}" | sed 's/[[:space:]]/\n/g' | sed -n '4p')
	else
		# 对于华硕路由器，其2.4G的mac地址和br0相等，5G-1 mac地址需要加4，5G-2mac地址需要需要加8
		# 如 br0 mac：A0:36:BC:70:33:C0
		# 2.4G mac：A0:36:BC:70:33:C0
		# 5.2G mac：A0:36:BC:70:33:C4
		# 5.8G mac：A0:36:BC:70:33:D8
		local raido_type=$1

		local ifname_0=$(nvram get wl0_ifname)
		local ifname_1=$(nvram get wl1_ifname)
		local ifname_2=$(nvram get wl2_ifname)
		local ifname_3=$(nvram get wl3_ifname)
		
		[ -n "${ifname_0}" ] && local mac_tail_if0=$(ifconfig ${ifname_0} | grep HWaddr | awk '{print $5}' | awk -F":" '{print $NF}' | grep -o . | tail -n1)
		[ -n "${ifname_1}" ] && local mac_tail_if1=$(ifconfig ${ifname_1} | grep HWaddr | awk '{print $5}' | awk -F":" '{print $NF}' | grep -o . | tail -n1)
		[ -n "${ifname_2}" ] && local mac_tail_if2=$(ifconfig ${ifname_2} | grep HWaddr | awk '{print $5}' | awk -F":" '{print $NF}' | grep -o . | tail -n1)
		[ -n "${ifname_3}" ] && local mac_tail_if3=$(ifconfig ${ifname_3} | grep HWaddr | awk '{print $5}' | awk -F":" '{print $NF}' | grep -o . | tail -n1)
		
		[ -n "${ifname_0}" ] && local mac_tail_band0=$(ifconfig br0 | grep HWaddr | awk '{print $5}' | awk -F":" '{print $NF}' | grep -o . | tail -n1)
		[ -n "${ifname_1}" ] && local mac_tail_band1=$(awk -v x=${mac_tail_band0} 'BEGIN { printf "%02X\n", x + 4}' | grep -o . | tail -n1)
		[ -n "${ifname_2}" ] && local mac_tail_band2=$(awk -v x=${mac_tail_band0} 'BEGIN { printf "%02X\n", x + 8}' | grep -o . | tail -n1)
		[ -n "${ifname_3}" ] && local mac_tail_band3=$(awk -v x=${mac_tail_band0} 'BEGIN { printf "%02X\n", x + 8}' | grep -o . | tail -n1)

		### [ -n "${ifname_0}" ] && echo mac_tail_if0 $mac_tail_if0
		### [ -n "${ifname_1}" ] && echo mac_tail_if1 $mac_tail_if1
		### [ -n "${ifname_2}" ] && echo mac_tail_if2 $mac_tail_if2
		### [ -n "${ifname_3}" ] && echo mac_tail_if3 $mac_tail_if3

		### [ -n "${ifname_0}" ] && echo mac_tail_band0 $mac_tail_band0
		### [ -n "${ifname_1}" ] && echo mac_tail_band1 $mac_tail_band1
		### [ -n "${ifname_2}" ] && echo mac_tail_band2 $mac_tail_band2
		### [ -n "${ifname_3}" ] && echo mac_tail_band3 $mac_tail_band3

		if [ -n "${ifname_0}" ];then
			[ "${mac_tail_if0}" == "${mac_tail_band0}" ] && interface_band0=${ifname_0}
			[ "${mac_tail_if1}" == "${mac_tail_band0}" ] && interface_band0=${ifname_1}
			[ "${mac_tail_if2}" == "${mac_tail_band0}" ] && interface_band0=${ifname_2}
			[ "${mac_tail_if3}" == "${mac_tail_band0}" ] && interface_band0=${ifname_3}
		fi
		if [ -n "${ifname_1}" ];then
			[ "${mac_tail_if0}" == "${mac_tail_band1}" ] && interface_band1=${ifname_0}
			[ "${mac_tail_if1}" == "${mac_tail_band1}" ] && interface_band1=${ifname_1}
			[ "${mac_tail_if2}" == "${mac_tail_band1}" ] && interface_band1=${ifname_2}
			[ "${mac_tail_if3}" == "${mac_tail_band1}" ] && interface_band1=${ifname_3}
		fi
		if [ -n "${ifname_2}" ];then
			[ "${mac_tail_if0}" == "${mac_tail_band2}" ] && interface_band2=${ifname_0}
			[ "${mac_tail_if1}" == "${mac_tail_band2}" ] && interface_band2=${ifname_1}
			[ "${mac_tail_if2}" == "${mac_tail_band2}" ] && interface_band2=${ifname_2}
			[ "${mac_tail_if3}" == "${mac_tail_band2}" ] && interface_band2=${ifname_3}
		fi
		if [ -n "${ifname_3}" ];then
			[ "${mac_tail_if0}" == "${mac_tail_band3}" ] && interface_band3=${ifname_0}
			[ "${mac_tail_if1}" == "${mac_tail_band3}" ] && interface_band3=${ifname_1}
			[ "${mac_tail_if2}" == "${mac_tail_band3}" ] && interface_band3=${ifname_2}
			[ "${mac_tail_if3}" == "${mac_tail_band3}" ] && interface_band3=${ifname_3}
		fi
	fi
}

get_tmp_pwr_hnd(){
	local __spilt__="&nbsp;&nbsp;|&nbsp;&nbsp"
	local model=$(_get_model)

	# 1. get wireless eth info
	if [ "${model}" == "RAX80" -o "${model}" == "RAX50" -o "${model}" == "RAX70" ];then
		# netgear model
		interface_band0=$(nvram get wl0_ifname)
		interface_band1=$(nvram get wl1_ifname)
	else
		# asus model
		get_sta_info
	fi

	interface_band0_isup=$(wl -i ${interface_band0} isup)
	interface_band1_isup=$(wl -i ${interface_band1} isup)
	interface_band2_isup=$(wl -i ${interface_band2} isup)
	interface_band3_isup=$(wl -i ${interface_band3} isup)

	# band0 info
	if [ "${interface_band0_isup}" == "1" ];then
		interface_band0_temp_o=$(wl -i ${interface_band0} phy_tempsense | awk '{print $1}')
		interface_band0_temp_c="$(expr ${interface_band0_temp_o} / 2 + 20)°C"
		interface_band0_pwer_o=$(wl -i ${interface_band0} txpwr_target_max | awk -F":" '{print $3}' | awk '{print $1}')
		interface_band0_pwer_d="${interface_band0_pwer_o} dBm"
		interface_band0_pwer_p="$(awk -v x=${interface_band0_pwer_o} 'BEGIN { printf "%.2f\n", 10^(x/10)}') mw"
	else
		interface_band0_temp_c="offline"
		interface_band0_pwer_d="offline"
		interface_band0_pwer_p="offline"
	fi	

	# band1 info
	if [ "${interface_band1_isup}" == "1" ];then
		interface_band1_temp_o=$(wl -i ${interface_band1} phy_tempsense | awk '{print $1}')
		interface_band1_temp_c="$(expr ${interface_band1_temp_o} / 2 + 20)°C"
		interface_band1_pwer_o=$(wl -i ${interface_band1} txpwr_target_max | awk -F":" '{print $3}' | awk '{print $1}')
		interface_band1_pwer_d="${interface_band1_pwer_o} dBm"
		interface_band1_pwer_p="$(awk -v x=${interface_band1_pwer_o} 'BEGIN { printf "%.2f\n", 10^(x/10)}') mw"
	else
		interface_band1_temp_c="offline"
		interface_band1_pwer_d="offline"
		interface_band1_pwer_p="offline"
	fi

	# band2 info
	if [ "${interface_band2_isup}" == "1" ];then
		interface_band2_temp_o=$(wl -i ${interface_band2} phy_tempsense | awk '{print $1}')
		interface_band2_temp_c="$(expr ${interface_band2_temp_o} / 2 + 20)°C"
		interface_band2_pwer_o=$(wl -i ${interface_band2} txpwr_target_max | awk -F":" '{print $3}' | awk '{print $1}')
		interface_band2_pwer_d="${interface_band2_pwer_o} dBm"
		interface_band2_pwer_p="$(awk -v x=${interface_band2_pwer_o} 'BEGIN { printf "%.2f\n", 10^(x/10)}') mw"
	else
		interface_band2_temp_c="offline"
		interface_band2_pwer_d="offline"
		interface_band2_pwer_p="offline"
	fi

	# band3 info
	if [ "${interface_band3_isup}" == "1" ];then
		interface_band3_temp_o=$(wl -i ${interface_band3} phy_tempsense | awk '{print $1}')
		interface_band3_temp_c="$(expr ${interface_band3_temp_o} / 2 + 20)°C"
		interface_band3_pwer_o=$(wl -i ${interface_band3} txpwr_target_max | awk -F":" '{print $3}' | awk '{print $1}')
		interface_band3_pwer_d="${interface_band3_pwer_o} dBm"
		interface_band3_pwer_p="$(awk -v x=${interface_band3_pwer_o} 'BEGIN { printf "%.2f\n", 10^(x/10)}') mw"
	else
		interface_band3_temp_c="offline"
		interface_band3_pwer_d="offline"
		interface_band3_pwer_p="offline"
	fi

	if [ -n "${interface_band0}" -a -n "${interface_band1}" -a -n "${interface_band2}" -a -n "${interface_band3}" ];then
		# 四频路由器
		if [ "${model}" == "GT-BE98" ];then
			# 2 + 5 + 5 + 6
			wl_temp="2.4G：${interface_band0_temp_c} ${__spilt__} 5G-1：&nbsp;${interface_band1_temp_c} ${__spilt__} 5G-2：&nbsp;${interface_band2_temp_c} ${__spilt__} 6G1： &nbsp;${interface_band3_temp_c}"
		fi
		if [ "${model}" == "GT-BE98_PRO" ];then
			# 2 + 5 + 6 + 6
			wl_temp="2.4G：${interface_band0_temp_c} ${__spilt__} 5G：&nbsp;${interface_band1_temp_c} ${__spilt__} 6G-1：&nbsp;${interface_band2_temp_c} ${__spilt__} 6G-2：&nbsp;${interface_band3_temp_c}"
		fi
		
		if [ -n "${interface_band0_pwer_o}" -o -n "${interface_band1_pwer_o}" -o -n "${interface_band2_pwer_o}" -o -n "${interface_band2_pwer_o}" ];then
			if [ "${model}" == "GT-BE98" ];then
				# 2 + 5 + 5 + 6
				wl_txpwr="2.4G：&nbsp;${interface_band0_pwer_d} / ${interface_band0_pwer_p} <br /> 5G-1：&nbsp;${interface_band1_pwer_d} / ${interface_band1_pwer_p} <br /> 5G-2：&nbsp;${interface_band2_pwer_d} / ${interface_band2_pwer_p} <br /> 6G：&nbsp;&nbsp;&nbsp;&nbsp;${interface_band3_pwer_d} / ${interface_band3_pwer_p}"
			elif [ "${model}" == "GT-BE98_PRO" ];then
				# 2 + 5 + 6 + 6
				wl_txpwr="2.4G：&nbsp;${interface_band0_pwer_d} / ${interface_band0_pwer_p} <br /> 5G：&nbsp;&nbsp;&nbsp;&nbsp;${interface_band1_pwer_d} / ${interface_band1_pwer_p} <br /> 6G-1：&nbsp;${interface_band2_pwer_d} / ${interface_band2_pwer_p} <br /> 6G-2：&nbsp;${interface_band3_pwer_d} / ${interface_band3_pwer_p}"
			fi
		else
			wl_txpwr=""
		fi
	elif [ -n "${interface_band0}" -a -n "${interface_band1}" -a -n "${interface_band2}" -a -z "${interface_band3}" ];then
		# 三频路由器
		if [ "${model}" == "GT-AXE11000" -o "${model}" == "ET8" -o "${model}" == "ET12" -o "${model}" == "RT-BE96U" ];then
			# 2 + 5 + 6
			wl_temp="2.4G：${interface_band0_temp_c} ${__spilt__} 5G：&nbsp;${interface_band1_temp_c} ${__spilt__} 6G：&nbsp;${interface_band2_temp_c}"
		else
			# 2 + 5 + 5
			wl_temp="2.4G：${interface_band0_temp_c} ${__spilt__} 5G-1：${interface_band1_temp_c} ${__spilt__} 5G-2：${interface_band2_temp_c}"
		fi
		
		if [ -n "${interface_band0_pwer_o}" -o -n "${interface_band1_pwer_o}" -o -n "${interface_band2_pwer_o}" ];then
			if [ "${model}" == "GT-AXE11000" -o "${model}" == "ET8" -o "${model}" == "ET12" -o "${model}" == "RT-BE96U" ];then
				wl_txpwr="2.4G：${interface_band0_pwer_d} / ${interface_band0_pwer_p} <br /> 5G：&nbsp;${interface_band1_pwer_d} / ${interface_band1_pwer_p} <br /> 6G：&nbsp;${interface_band2_pwer_d} / ${interface_band2_pwer_p}"
			else
				wl_txpwr="2.4G：${interface_band0_pwer_d} / ${interface_band0_pwer_p} <br /> 5G-1：${interface_band1_pwer_d} / ${interface_band1_pwer_p} <br /> 5G-2：${interface_band2_pwer_d} / ${interface_band2_pwer_p}"
			fi
		else
			wl_txpwr=""
		fi
	elif [ -n "${interface_band0}" -a -n "${interface_band1}" -a -z "${interface_band2}" -a -z "${interface_band3}" ];then
		# 双频路由器
		wl_temp="2.4G：${interface_band0_temp_c} ${__spilt__} 5G： ${interface_band1_temp_c}"

		if [ -n "${interface_band0_pwer_o}" -o -n "${interface_band1_pwer_o}" ];then
			wl_txpwr="2.4G：${interface_band0_pwer_d} / ${interface_band0_pwer_p} <br /> 5G：&nbsp;&nbsp;&nbsp;${interface_band1_pwer_d} / ${interface_band1_pwer_p}"
		fi
	fi
}
get_mhz(){
	cpu_mhz="null"
	if [ -x "/koolshare/bin/mhz" ];then
		cpu_mhz=$(/koolshare/bin/mhz -c)
	fi
}

get_system_info(){
	kernel_ver=$(uname -r 2>/dev/null)
	hardware_type=$(uname -m 2>/dev/null)

	if [ "$(nvram get odmpid)" == "RT-AX89X" -o "$(nvram get odmpid)" == "TUF-AX4200Q" -o "$(nvram get odmpid)" == "TX-AX6000" -o "$(nvram get odmpid)" == "ZenWiFi_BD4" -o "$(nvram get odmpid)" == "TUF_6500" -o "$(nvram get odmpid)" == "GS7" -o "$(nvram get odmpid)" == "ZenWiFi_BT8P" -o "$(nvram get odmpid)" == "GS7_Air" -o "$(nvram get odmpid)" == "GS-BE7200X" ];then
		build_date_cst=$(uname -v | awk '{print $(NF-5),$(NF-4),$(NF-3),$(NF-2),$NF}')
		build_date=$(date -D "%a %b %d %H:%M:%S %Y" -d "${build_date_cst}" +"%Y-%m-%d %H:%M:%S")
	else
		build_date_cst=$(uname -v | awk '{print $(NF-5),$(NF-4),$(NF-3),$(NF-2),$(NF-1),$NF}')
		build_date=$(date -D "%a %b %d %H:%M:%S %Z %Y" -d "${build_date_cst}" +"%Y-%m-%d %H:%M:%S")
	fi

	# BCM: #1 SMP PREEMPT Wed Jan 22 22:58:22 CST 2025
	# MTK: #1 SMP Mon May 6 18:18:06 CST 2024
	if [ -z "${kernel_ver}" ];then
		kernel_ver="null"
	fi

	if [ -z "${hardware_type}" ];then
		hardware_type="null"
	fi
	
	if [ -z "${build_date}" ];then
		build_date="null"
	fi
}
get_tmp_pwr_mtk(){
	local __spilt__="&nbsp;&nbsp;|&nbsp;&nbsp"
	interface_band0_temp_c=$(iwpriv ra0 stat | grep "CurrentTemperature" | head -n1 | awk -F '= ' '{print $2}')°C
	interface_band1_temp_c=$(iwpriv rax0 stat | grep "CurrentTemperature" | head -n1 | awk -F '= ' '{print $2}')°C

	wl_temp="2.4G：${interface_band0_temp_c} ${__spilt__} 5G： ${interface_band1_temp_c}"
}

get_mtk_target_power_band(){
	local iface=$1 band=$2 marker result attempt
	if [ "$(nvram get "wl${band}_radio")" = "0" ];then
		printf 'off'
		return
	fi
	[ -d "/sys/class/net/${iface}" ] || return 1

	# Only accept a complete report produced after this query's marker.
	marker="rog-txpwr:$(date +%s):$$:${iface}"
	printf '<6>%s\n' "${marker}" > /dev/kmsg || return 1
	if [ "${mtk_power_model}" = "GS7" ];then
		mwctl dev "${iface}" show data_frame_pwr=0-0 >/dev/null 2>&1 || return 1
	else
		iwpriv "${iface}" show data_frame_pwr=0-0 >/dev/null 2>&1 || return 1
		iwpriv "${iface}" show mgmt_frame_pwr >/dev/null 2>&1 || return 1
	fi
	for attempt in 1 2 3 4 5;do
		if result=$(dmesg | LC_ALL=C awk -v marker="${marker}" -v band="${band}" -v model="${mtk_power_model}" '
			index($0, marker) { fresh = 1; next }
			!fresh { next }
			/TX POWER INFO/ { in_band = 0; next }
			/Channel Band:/ { in_band = index($0, "Band Index: " band ",") != 0 }
			in_band && index($0, "BandIdx: " band ", Max Base Pwr:") {
				value = $0
				sub(/^.*Max Base Pwr:[[:space:]]*/, "", value)
				sub(/[[:space:]].*$/, "", value)
				max = value
			}
			max != "" && /\[show_mgmt_frame_power\] Tx_Pwr =/ {
				value = $0
				sub(/^.*Tx_Pwr =[[:space:]]*/, "", value)
				sub(/[[:space:]].*$/, "", value)
				mgmt = value
			}
			END {
				if (max !~ /^-?[0-9]+(\.[0-9]+)?$/) exit 1
				if (model == "GS7") {
					# MT7992 management-power output is not verified as an absolute target.
					printf "data:%.1f", max
				} else {
					if (mgmt !~ /^-?[0-9]+(\.[0-9]+)?$/) exit 1
					printf "%.1f,%.1f", max, mgmt
				}
			}');then
			printf '%s' "${result}"
			return
		fi
		[ "${attempt}" = "5" ] || sleep 1
	done
	return 1
}

get_mtk_target_power() (
	mtk_power_model=$(_get_model)
	case "${mtk_power_model}" in
		TX-AX6000) mtk_power_5g=rax0 ;;
		GS7) mtk_power_5g=rai0 ;;
		*) printf 'unavailable@@unavailable'; return ;;
	esac
	[ -w /dev/kmsg ] || { printf 'unavailable@@unavailable'; return; }

	# Both radios share driver query state; reject overlapping requests.
	lock=/tmp/mtk-txpwr-target.lock
	if ! mkdir "${lock}" 2>/dev/null;then
		printf 'busy@@busy'
		return
	fi
	trap 'rmdir "${lock}"' EXIT
	trap 'exit 1' HUP INT TERM
	band0=$(get_mtk_target_power_band ra0 0) || band0=unavailable
	band1=$(get_mtk_target_power_band "${mtk_power_5g}" 1) || band1=unavailable
	printf '%s@@%s' "${band0}" "${band1}"
)

get_tmp_pwr_MT7988X(){
	local __spilt__="&nbsp;&nbsp;|&nbsp;&nbsp"
	if [ "$(nvram get wl0_radio)" = "0" ];then
		interface_band0_temp_c="无线已关闭"
	else
		interface_band0_temp_c=$(mwctl ra0 stat | grep "CurrentTemperature" | awk '{print $3}')°C
	fi
	if [ "$(nvram get wl1_radio)" = "0" ];then
		interface_band1_temp_c="无线已关闭"
	else
		interface_band1_temp_c=$(mwctl rai0 stat | grep "CurrentTemperature" | awk '{print $3}')°C
	fi
	wl_temp="2.4G：${interface_band0_temp_c} ${__spilt__} 5G： ${interface_band1_temp_c}"
}

get_tmp_pwr_ipq(){
	#网卡温度
	WIFI_2G_DISABLE=$(iwconfig ath0|grep "Encryption key:off")
	WIFI_5G_DISABLE=$(iwconfig ath1|grep "Encryption key:off")
	
	interface_2g_temperature=$(thermaltool -i wifi0 -get|sed -n 's/.*temperature: \([0-9][0-9]\).*/\1/p') 2>/dev/null
	interface_5g1_temperature=$(thermaltool -i wifi1 -get|sed -n 's/.*temperature: \([0-9][0-9]\).*/\1/p') 2>/dev/null
	[ -z "${WIFI_2G_DISABLE}" ] && interface_2g_temperature_c="${interface_2g_temperature}°C" || interface_2g_temperature_c="offline"
	[ -z "${WIFI_5G_DISABLE}" ] && interface_5g1_temperature_c="${interface_5g1_temperature}°C" || interface_5g1_temperature_c="offline"
	wl_temp="2.4G：${interface_2g_temperature_c} &nbsp;&nbsp;|&nbsp;&nbsp; 5G：${interface_5g1_temperature_c}"
	
	interface_2g_power=$(iwconfig ath0|sed -n 's/.*Tx-Power.*\([0-9][0-9]\).*/\1/p') 2>/dev/null
	interface_5g1_power=$(iwconfig ath1|sed -n 's/.*Tx-Power.*\([0-9][0-9]\).*/\1/p') 2>/dev/null
	[ -z "${WIFI_2G_DISABLE}" ] && interface_2g_power_d="${interface_2g_power} dBm" || interface_2g_power_d="offline"
	[ -z "${WIFI_2G_DISABLE}" ] && interface_2g_power_p="$(awk -v x=${interface_2g_power} 'BEGIN { printf "%.2f\n", 10^(x/10)}') mw" || interface_2g_power_p="offline"
	[ -z "${WIFI_5G_DISABLE}" ] && interface_5g1_power_d="${interface_5g1_power} dBm" || interface_5g1_power_d="offline"
	[ -z "${WIFI_5G_DISABLE}" ] && interface_5g1_power_p="$(awk -v x=${interface_5g1_power} 'BEGIN { printf "%.2f\n", 10^(x/10)}') mw" || interface_5g1_power_p="offline"
	wl_txpwr="2.4G：${interface_2g_power_d} / ${interface_2g_power_p} <br /> 5G：&nbsp;&nbsp;&nbsp;${interface_5g1_power_d} / ${interface_5g1_power_p}"
}

get_tmp_pwr_qca(){
	WIFI_2G_DISABLE=$(iwconfig ath1|grep "Not-Associated")
	WIFI_5G_DISABLE=$(iwconfig ath0|grep "Not-Associated")
	
	interface_2g_temperature=$(thermaltool -i wifi1 -get|sed -n 's/.*temperature: \([0-9][0-9]\).*/\1/p') 2>/dev/null
	interface_5g1_temperature=$(thermaltool -i wifi0 -get|sed -n 's/.*temperature: \([0-9][0-9]\).*/\1/p') 2>/dev/null
	[ -z "${WIFI_2G_DISABLE}" ] && interface_2g_temperature_c="${interface_2g_temperature}°C" || interface_2g_temperature_c="offline"
	[ -z "${WIFI_5G_DISABLE}" ] && interface_5g1_temperature_c="${interface_5g1_temperature}°C" || interface_5g1_temperature_c="offline"
	wl_temp="2.4G：${interface_2g_temperature_c} &nbsp;&nbsp;|&nbsp;&nbsp; 5G：${interface_5g1_temperature_c}"
	
	interface_2g_power=$(iwconfig ath1|sed -n 's/.*Tx-Power.*\([0-9][0-9]\).*/\1/p') 2>/dev/null
	interface_5g1_power=$(iwconfig ath0|sed -n 's/.*Tx-Power.*\([0-9][0-9]\).*/\1/p') 2>/dev/null
	[ -z "${WIFI_2G_DISABLE}" ] && interface_2g_power_d="${interface_2g_power} dBm" || interface_2g_power_d="offline"
	[ -z "${WIFI_2G_DISABLE}" ] && interface_2g_power_p="$(awk -v x=${interface_2g_power} 'BEGIN { printf "%.2f\n", 10^(x/10)}') mw" || interface_2g_power_p="offline"
	[ -z "${WIFI_5G_DISABLE}" ] && interface_5g1_power_d="${interface_5g1_power} dBm" || interface_5g1_power_d="offline"
	[ -z "${WIFI_5G_DISABLE}" ] && interface_5g1_power_p="$(awk -v x=${interface_5g1_power} 'BEGIN { printf "%.2f\n", 10^(x/10)}') mw" || interface_5g1_power_p="offline"
	wl_txpwr="2.4G：${interface_2g_power_d} / ${interface_2g_power_p} <br /> 5G：&nbsp;&nbsp;&nbsp;${interface_5g1_power_d} / ${interface_5g1_power_p}"
}

get_tmp_pwr(){
	if [ "$(nvram get odmpid)" == "TX-AX6000" -o "$(nvram get odmpid)" == "TUF-AX4200Q" -o "$(nvram get odmpid)" == "RT-AX57_Go" ];then
		get_tmp_pwr_mtk
	elif [ "$(nvram get odmpid)" == "GS7" -o "$(nvram get odmpid)" == "ZenWiFi_BT8P" -o "$(nvram get odmpid)" == "GS7_Air" -o "$(nvram get odmpid)" == "GS-BE7200X" ];then
		get_tmp_pwr_MT7988X
	elif [ "$(nvram get odmpid)" == "ZenWiFi_BD4" -o "$(nvram get odmpid)" == "TUF_6500" ];then
		get_tmp_pwr_ipq
	elif [ "$(nvram get odmpid)" == "RT-AX89X" ];then
		get_tmp_pwr_qca
	else
		get_tmp_pwr_hnd
	fi
}

number_test(){
	case $1 in
		''|*[!0-9]*)
			echo 1
			;;
		*) 
			echo 0
			;;
	esac
}

# Wi-Fi 功率按需查询，避免两秒一次的温度轮询请求整张功率表。
if [ "$#" -eq 2 ] && [ "$2" = "wifi_power" ] && [ "$(number_test "$1")" = "0" ];then
	http_response "$(get_mtk_target_power)"
	exit $?
fi

get_cpu_temp
get_tmp_pwr
get_mhz
get_system_info
#=================================================

# when called by web (two args, $2 is pure nu)，run http_response
if [ $# == 2 -a $(number_test $1) == 0 ];then
	http_response "${cpu_temp}@@${wl_temp}@@${wl_txpwr}@@${cpu_mhz}@@${kernel_ver}@@${hardware_type}@@${build_date}"
fi

if [ $# == 0 ];then
	echo "${cpu_temp}@@${wl_temp}@@${wl_txpwr}@@${cpu_mhz}@@${kernel_ver}@@${hardware_type}@@${build_date}"
fi
