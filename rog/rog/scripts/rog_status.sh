#!/bin/sh

#alias echo_date='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
. "$KSROOT/scripts/base.sh"
#=================================================

mhz_cache_to_refresh=
mtk_cache_to_refresh=
mtk_state_to_refresh=

_get_model(){
	local model
	model=$(nvram get odmpid)
	[ -n "$model" ] || model=$(nvram get productid)
	printf '%s\n' "$model"
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
	local interface_band0_isup interface_band1_isup interface_band2_isup interface_band3_isup

	# 1. get wireless eth info
	if [ "${model}" == "RAX80" -o "${model}" == "RAX50" -o "${model}" == "RAX70" ];then
		# netgear model
		interface_band0=$(nvram get wl0_ifname)
		interface_band1=$(nvram get wl1_ifname)
	else
		# asus model
		get_sta_info
	fi

	[ -z "$interface_band0" ] || interface_band0_isup=$(wl -i "$interface_band0" isup 2>/dev/null)
	[ -z "$interface_band1" ] || interface_band1_isup=$(wl -i "$interface_band1" isup 2>/dev/null)
	[ -z "$interface_band2" ] || interface_band2_isup=$(wl -i "$interface_band2" isup 2>/dev/null)
	[ -z "$interface_band3" ] || interface_band3_isup=$(wl -i "$interface_band3" isup 2>/dev/null)

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
status_uptime(){
	local seconds
	IFS=' ' read -r seconds _ < /proc/uptime || return 1
	printf '%s' "${seconds%%.*}"
}

write_status_cache(){
	local cache=$1 tmp=$1.$$
	shift
	if (umask 077; printf '%s\n' "$@" > "$tmp") && mv -f "$tmp" "$cache"; then
		return
	fi
	rm -f "$tmp"
	return 1
}

sample_status_with_lock(){
	(
		status_sample_lock=$1
		shift
		mkdir "$status_sample_lock" 2>/dev/null || exit 1
		trap 'rmdir "$status_sample_lock"' 0
		trap 'exit 1' HUP INT TERM
		"$@"
	)
}

start_status_sample(){
	# BusyBox ash can retain the result pipe when a function is
	# backgrounded directly. Redirect an explicit subshell instead.
	( sample_status_with_lock "$@" ) </dev/null >/dev/null 2>&1 &
}

read_mhz_cache(){
	local cache=$1 now=$2 max_age=$3 sampled value
	[ -r "$cache" ] || return 1
	IFS=' ' read -r sampled value < "$cache" || return 1
	case "$sampled" in ''|*[!0-9]*) return 1 ;; esac
	[ "$now" -ge "$sampled" ] && [ "$((now - sampled))" -lt "$max_age" ] || return 1
	printf '%s' "$value"
}

refresh_mhz_cache(){
	local cache=$1 now mhz
	now=$(status_uptime) || return
	read_mhz_cache "$cache" "$now" 30 >/dev/null && return
	mhz=$(/koolshare/bin/mhz -c 2>/dev/null | LC_ALL=C awk '
		/^[0-9]+(\.[0-9]+)?$/ && $0 + 0 > 0 {print; exit}')
	write_status_cache "$cache" "$now ${mhz:-null}"
}

get_mhz(){
	local file khz cache=/tmp/rog_cpu_mhz.cache now
	cpu_mhz=null
	for file in /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq \
	            /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq; do
		[ -r "$file" ] && IFS= read -r khz < "$file" || continue
		case "$khz" in ''|*[!0-9]*) continue ;; esac
		[ "$khz" -gt 0 ] || continue
		cpu_mhz=$(((khz + 500) / 1000))
		return
	done

	[ -x /koolshare/bin/mhz ] || return
	now=$(status_uptime) || return
	if cpu_mhz=$(read_mhz_cache "$cache" "$now" 30); then return; fi
	cpu_mhz=$(read_mhz_cache "$cache" "$now" 120) || cpu_mhz=null
	# The measurement binary runs a benchmark even for a status request.
	mhz_cache_to_refresh=$cache
}

get_system_info(){
	kernel_ver=$(uname -r 2>/dev/null)
	hardware_type=$(uname -m 2>/dev/null)

	local short_date=0
	case "$(nvram get odmpid)" in
		RT-AX89X|TUF-AX4200Q|TX-AX6000|ZenWiFi_BD4|TUF_6500|GS7|ZenWiFi_BT8P|GS7_Air|GS-BE7200X) short_date=1 ;;
		*) if get_mtk_power_backend; then short_date=1; fi ;;
	esac
	if [ "$short_date" = 1 ];then
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
	if [ "${mtk_power_backend}" = "mwctl" ];then
		mwctl dev "${iface}" show data_frame_pwr=0-0 >/dev/null 2>&1 || return 1
	else
		iwpriv "${iface}" show data_frame_pwr=0-0 >/dev/null 2>&1 || return 1
	fi
	for attempt in 1 2 3 4 5;do
		if result=$(dmesg | LC_ALL=C awk -v marker="${marker}" -v band="${band}" -v backend="${mtk_power_backend}" '
			index($0, marker) { fresh = 1; next }
			!fresh { next }
			/TX POWER INFO/ { in_band = 0; next }
			/Channel Band:/ {
				in_band = index($0, "Band Index: " band ",") != 0
				is_2g = $0 ~ /:2G/
				is_6g = $0 ~ /:6G/
				rate_max = ""
				next
			}
			in_band && backend == "mwctl" {
				line = $0
				while (match(line, /\[(CCK|OFDM|HT|VHT|HE|EHT)[A-Z0-9_]*\]:[[:space:]]*0x[[:xdigit:]]+[[:space:]]*\(-?[0-9]+\)/)) {
					rate = substr(line, RSTART, RLENGTH)
					line = substr(line, RSTART + RLENGTH)
					if ((!is_2g && rate ~ /^\[CCK_/) ||
					    (is_6g && rate ~ /^\[(OFDM|HT|VHT)/)) continue
					sub(/^.*\(/, "", rate)
					sub(/\)$/, "", rate)
					rate += 0
					if (rate > -128 && rate < 127 && (rate_max == "" || rate > rate_max))
						rate_max = rate
				}
			}
			in_band && index($0, "BandIdx: " band ", Max Base Pwr:") {
				value = $0
				sub(/^.*Max Base Pwr:[[:space:]]*/, "", value)
				sub(/[[:space:]].*$/, "", value)
				complete = value ~ /^-?[0-9]+(\.[0-9]+)?$/
				# The Wi-Fi 7 summary can miss higher entries in its own rate table.
				max = rate_max == "" ? value : rate_max / 2
				in_band = 0
			}
			END {
				if (!complete) exit 1
				printf "data:%.1f", max
			}');then
			printf '%s' "${result}"
			return
		fi
		[ "${attempt}" = "5" ] || sleep 1
	done
	return 1
}

# One MTK package contains both query paths; choose only at runtime.
get_mtk_power_backend(){
	mtk_power_bands=2
	mtk_power_5g2=
	case "$(_get_model)" in
		TUF-AX4200|TUF-AX4200Q|TUF-AX6000|TX-AX6000|RT-AX57_Go|RT-AX57-Go|"RT-AX57 Go"|PRT-AX57_GO)
			mtk_power_backend=iwpriv
			mtk_power_5g=rax0
			mtk_power_ifnames="ra0 rax0"
			;;
		GS7|GS7_Air|GS7_AIR|"GS7 Air"|GS7_MAGIC|GS-BE7200X)
			mtk_power_backend=mwctl
			mtk_power_5g=rai0
			mtk_power_ifnames="ra0 rai0"
			;;
		ZenWiFi_BT8P|BT8P|"ZenWiFi BT8P")
			mtk_power_backend=mwctl
			mtk_power_5g=rai0
			mtk_power_5g2=rax0
			mtk_power_ifnames="ra0 rai0 rax0"
			mtk_power_bands=3
			;;
		*) return 1 ;;
	esac
}

get_mtk_band_label(){
	local band=$1 nband
	nband=$(nvram get "wl${band}_nband")
	case "${nband}" in
		4) printf '6 GHz'; return ;;
		2) printf '2.4 GHz'; return ;;
	esac
	if [ "${band}" = "0" ];then
		printf '2.4 GHz'
	elif [ "${mtk_power_bands}" = "3" ] && [ "$(nvram get wl2_nband)" != "4" ];then
		printf '5 GHz-%s' "${band}"
	else
		printf '5 GHz'
	fi
}

format_mtk_power_band(){
	local label=$1 value=$2 dbm milliwatts
	case "${value}" in
		data:*)
			dbm=${value#data:}
			milliwatts=$(LC_ALL=C awk -v dbm="${dbm}" 'BEGIN { printf "%.2f", 10^(dbm/10) }')
			printf '%s：%s dBm / %s mW' "${label}" "${dbm}" "${milliwatts}"
			;;
		off) printf '%s：无线已关闭' "${label}" ;;
		busy) printf '%s：正在查询…' "${label}" ;;
		*) printf '%s：无法读取' "${label}" ;;
	esac
}

format_mtk_power_status(){
	local band=0 iface separator=
	for iface in ${mtk_power_ifnames};do
		printf '%s%s' "${separator}" "$(format_mtk_power_band "$(get_mtk_band_label "${band}")" "$1")"
		separator='；'
		band=$((band + 1))
	done
}

get_mtk_power_state(){
	local band=0 iface
	printf 'mtk-v4|%s|%s' "$(_get_model)" "${mtk_power_ifnames}"
	for iface in ${mtk_power_ifnames};do
		printf '|%s|%s|%s|%s' "$(nvram get "wl${band}_radio")" \
			"$(nvram get "wl${band}_channel")" "$(nvram get "wl${band}_txpower")" "$(nvram get "wl${band}_nband")"
		iwconfig "${iface}" 2>/dev/null | LC_ALL=C awk '
			match($0, /Channel:[[:space:]]*[0-9]+|Frequency[=:][[:space:]]*[0-9.]+/) {
				printf "|%s", substr($0, RSTART, RLENGTH)
			}'
		band=$((band + 1))
	done
	printf '|%s|%s' "$(nvram get location_code)" "$(nvram get reg_spec)"
}

read_mtk_power_cache(){
	local cache=$1 state=$2 now=$3 max_age=${4:-30} cached_time cached_state cached_power
	[ -r "${cache}" ] || return 1
	{
		IFS= read -r cached_time && IFS= read -r cached_state && IFS= read -r cached_power
	} < "${cache}" || return 1
	case "${cached_time}" in ''|*[!0-9]*) return 1 ;; esac
	[ "${cached_state}" = "${state}" ] && [ -n "${cached_power}" ] || return 1
	[ "${now}" -ge "${cached_time}" ] && [ "$((now - cached_time))" -lt "$max_age" ] || return 1
	printf '%s' "${cached_power}"
}

refresh_mtk_target_power(){
	local cache=$1 state=${2:-} now band=0 iface value power= separator= complete=1
	[ -n "$state" ] || state=$(get_mtk_power_state)
	now=$(status_uptime) || return
	# A preceding request may have filled the cache before this worker got the lock.
	read_mtk_power_cache "$cache" "$state" "$now" >/dev/null && return
	read_mtk_power_cache "$cache.retry" "$state" "$now" 10 >/dev/null && return
	for iface in $mtk_power_ifnames; do
		value=$(get_mtk_target_power_band "$iface" "$band") || value=unavailable
		power="$power$separator$(format_mtk_power_band "$(get_mtk_band_label "$band")" "$value")"
		[ "$value" != unavailable ] || complete=0
		separator='；'
		band=$((band + 1))
	done
	now=$(status_uptime) || return
	if [ "$complete" = 1 ]; then
		write_status_cache "$cache" "$now" "$state" "$power"
	else
		# Leave the last successful report available and cool down failed queries.
		write_status_cache "$cache.retry" "$now" "$state" "$power"
	fi
}

get_mtk_target_power(){
	local cache=/tmp/rog_wifi_power.cache now state cached retry
	wl_txpwr=
	now=$(status_uptime) || return
	if [ ! -r "$cache" ] && [ ! -r "$cache.retry" ] && [ -w /dev/kmsg ]; then
		# No prior state to validate. Let the sampler read the active channel.
		mtk_cache_to_refresh=$cache
		mtk_state_to_refresh=
		wl_txpwr=$(format_mtk_power_status busy)
		return
	fi
	# iwconfig and temperature stat can stall behind a driver power report.
	state=$(sample_status_with_lock /tmp/mtk-txpwr-target.lock get_mtk_power_state) || {
		wl_txpwr=$(format_mtk_power_status busy)
		return
	}
	if cached=$(read_mtk_power_cache "$cache" "$state" "$now"); then
		wl_txpwr=$cached
		return
	fi

	if [ ! -w /dev/kmsg ]; then
		wl_txpwr=$(format_mtk_power_status unavailable)
		return
	fi
	retry=$(read_mtk_power_cache "$cache.retry" "$state" "$now" 10)
	if [ -z "$retry" ]; then
		mtk_cache_to_refresh=$cache
		mtk_state_to_refresh=$state
	fi
	# Only reuse a previous value when it describes the current radio state.
	if cached=$(read_mtk_power_cache "$cache" "$state" "$now" 120); then
		wl_txpwr=$cached
	elif [ -n "$retry" ]; then
		wl_txpwr=$retry
	else
		wl_txpwr=$(format_mtk_power_status busy)
	fi
}

refresh_status_samples(){
	if [ -n "$mtk_cache_to_refresh" ]; then
		start_status_sample /tmp/mtk-txpwr-target.lock refresh_mtk_target_power \
			"$mtk_cache_to_refresh" "$mtk_state_to_refresh"
		mtk_cache_to_refresh=
	fi
	if [ -n "$mhz_cache_to_refresh" ]; then
		start_status_sample "$mhz_cache_to_refresh.lock" refresh_mhz_cache "$mhz_cache_to_refresh"
		mhz_cache_to_refresh=
	fi
}

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

read_mtk_temperature(){
	local band=0 iface value separator= temperature=
	for iface in ${mtk_power_ifnames};do
		if [ "$(nvram get "wl${band}_radio")" = "0" ];then
			value="无线已关闭"
		else
			if [ "${mtk_power_backend}" = "mwctl" ];then
				value=$(mwctl dev "${iface}" stat 2>/dev/null)
			else
				value=$(iwpriv "${iface}" stat 2>/dev/null)
			fi
			value=$(printf '%s\n' "${value}" | LC_ALL=C awk '
				/CurrentTemperature/ {
					sub(/^.*CurrentTemperature[[:space:]]*[:=][[:space:]]*/, "")
					if (match($0, /^-?[0-9]+/)) print substr($0, RSTART, RLENGTH)
					exit
				}')
			if [ -n "${value}" ];then value="${value}°C";else value="无法读取";fi
		fi
		temperature="${temperature}${separator}$(get_mtk_band_label "${band}")：${value}"
		separator=' &nbsp;&nbsp;|&nbsp;&nbsp; '
		band=$((band + 1))
	done
	printf '%s' "$temperature"
}

get_mtk_temperature(){
	local cache=/tmp/rog_wifi_temperature.cache now state="$mtk_power_ifnames" band=0 iface
	for iface in $mtk_power_ifnames; do
		state="$state|$(nvram get "wl${band}_radio")"
		band=$((band + 1))
	done
	now=$(status_uptime) || now=0
	if wl_temp=$(sample_status_with_lock /tmp/mtk-txpwr-target.lock read_mtk_temperature); then
		write_status_cache "$cache" "$now" "$state" "$wl_temp"
		return
	fi
	# A concurrent power query owns the radio. Use the last temperature
	# only if it describes the same set of enabled radios.
	wl_temp=$(read_mtk_power_cache "$cache" "$state" "$now" 15) || wl_temp='正在查询…'
}

get_tmp_pwr(){
	# Reuse the exact-model power backend, including productid-only models.
	if get_mtk_power_backend;then
		get_mtk_temperature
		return
	fi
	case "$(_get_model)" in
		RT-AX57_Go) get_tmp_pwr_mtk ;;
		ZenWiFi_BT8P|GS7_Air|GS-BE7200X) get_tmp_pwr_MT7988X ;;
		ZenWiFi_BD4|TUF_6500) get_tmp_pwr_ipq ;;
		RT-AX89X) get_tmp_pwr_qca ;;
		*) get_tmp_pwr_hnd ;;
	esac
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


get_cpu_temp
get_tmp_pwr
if get_mtk_power_backend;then
	get_mtk_target_power
fi
get_mhz
get_system_info
#=================================================

# httpdb passes a numeric request ID and the status action.
status_result="${cpu_temp}@@${wl_temp}@@${wl_txpwr}@@${cpu_mhz}@@${kernel_ver}@@${hardware_type}@@${build_date}"
if [ "$#" -eq 2 ] && [ "$(number_test "$1")" = 0 ];then
	http_response "$status_result"
elif [ "$#" -eq 0 ];then
	printf '%s\n' "$status_result"
else
	exit 0
fi

# Respond before starting expensive driver and benchmark work.
refresh_status_samples
