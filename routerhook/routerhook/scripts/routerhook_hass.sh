#!/bin/sh

source /koolshare/scripts/base.sh
eval $(dbus export routerhook_)
if [ "${routerhook_config_ntp}" == "" ]; then
    ntp_server="ntp1.aliyun.com"
else
    ntp_server=${routerhook_config_ntp}
fi
ntpclient -h ${ntp_server} -i3 -l -s >/dev/null 2>&1
routerhook_hass_text=/tmp/.routerhook_hass.json
dnsmasq_leases_file="/var/lib/misc/dnsmasq.leases"
rm -rf ${routerhook_hass_text}
if [[ "${routerhook_enable}" != "1" ]]; then
    exit
fi
clang_action="$1"
if [[ "${clang_action}" == "task" ]]; then
    if [[ "${routerhook_info_silent_send}" == "0" ]]; then
        if [[ "${routerhook_silent_time}" == "1" ]]; then
            router_now_hour=$(date "+%H")
            if [[ "${router_now_hour}" -ge "${routerhook_silent_time_start_hour}" ]] || [[ "${router_now_hour}" -lt "${routerhook_silent_time_end_hour}" ]]; then
                [ "${routerhook_info_logger}" == "1" ] && logger "[routerhook]: 推送时间在消息免打扰时间内，推送任务通道静默！"
                exit
            fi
        fi
    fi
fi
[ ! -L "/koolshare/bin/base64_decode" ] && ln -s /koolshare/bin/base64_encode /koolshare/bin/base64_decode

# 系统负载1min
if [ "${routerhook_sm_load1}" == "1" ]; then
    msg_type='rh_load'
    unit='1min'
    friendly_name='Router SystemLoad'
    value=$(cat /proc/loadavg | awk '{print $1}')
    echo '{' >${routerhook_hass_text}
    echo '"state":'$value >>${routerhook_hass_text}
    echo ',"value1":'$value >>${routerhook_hass_text}
    echo ',"value2":"'$unit'"' >>${routerhook_hass_text}
    echo ',"value3":"'$friendly_name'"' >>${routerhook_hass_text}
    echo ',"attributes":{"unit_of_measurement":"'$unit'","friendly_name":"'$friendly_name'"}' >>${routerhook_hass_text}
    echo '}' >>${routerhook_hass_text}
    routerhook_send_content=$(jq -c . ${routerhook_hass_text})
    source /koolshare/scripts/routerhook_sender.sh
fi

# 系统负载5min
if [ "${routerhook_sm_load2}" == "1" ]; then
    msg_type='rh_load'
    unit='5min'
    friendly_name='Router SystemLoad'
    value=$(cat /proc/loadavg | awk '{print $2}')
    echo '{' >${routerhook_hass_text}
    echo '"state":'$value >>${routerhook_hass_text}
    echo ',"value1":'$value >>${routerhook_hass_text}
    echo ',"value2":"'$unit'"' >>${routerhook_hass_text}
    echo ',"value3":"'$friendly_name'"' >>${routerhook_hass_text}
    echo ',"attributes":{"unit_of_measurement":"'$unit'","friendly_name":"'$friendly_name'"}' >>${routerhook_hass_text}
    echo '}' >>${routerhook_hass_text}
    routerhook_send_content=$(jq -c . ${routerhook_hass_text})
    source /koolshare/scripts/routerhook_sender.sh
fi

# 系统负载15min
if [ "${routerhook_sm_load3}" == "1" ]; then
    msg_type='rh_load'
    unit='15min'
    friendly_name='Router SystemLoad'
    value=$(cat /proc/loadavg | awk '{print $3}')
    echo '{' >${routerhook_hass_text}
    echo '"state":'$value >>${routerhook_hass_text}
    echo ',"value1":'$value >>${routerhook_hass_text}
    echo ',"value2":"'$unit'"' >>${routerhook_hass_text}
    echo ',"value3":"'$friendly_name'"' >>${routerhook_hass_text}
    echo ',"attributes":{"unit_of_measurement":"'$unit'","friendly_name":"'$friendly_name'"}' >>${routerhook_hass_text}
    echo '}' >>${routerhook_hass_text}
    routerhook_send_content=$(jq -c . ${routerhook_hass_text})
    source /koolshare/scripts/routerhook_sender.sh
fi

# 空闲内存
if [ "${routerhook_sm_mem}" == "1" ]; then
    msg_type='rh_mem_free'
    unit='MB'
    friendly_name='Router Memory Available'
    value=$(awk 'BEGIN{printf ("%.2f\n",'$(cat /proc/meminfo | grep "MemFree" | awk '{print $2}')'/1024)}')
    echo '{' >${routerhook_hass_text}
    echo '"state":'$value >>${routerhook_hass_text}
    echo ',"value1":'$value >>${routerhook_hass_text}
    echo ',"value2":"'$unit'"' >>${routerhook_hass_text}
    echo ',"value3":"'$friendly_name'"' >>${routerhook_hass_text}
    echo ',"attributes":{"unit_of_measurement":"'$unit'","friendly_name":"'$friendly_name'"}' >>${routerhook_hass_text}
    echo '}' >>${routerhook_hass_text}
    routerhook_send_content=$(jq -c . ${routerhook_hass_text})
    source /koolshare/scripts/routerhook_sender.sh
fi

# 空闲SWAP
if [ "${routerhook_sm_swap}" == "1" ]; then
    msg_type='rh_swap_free'
    unit='MB'
    friendly_name='Router SWAP Available'
    value=$(awk 'BEGIN{printf ("%.2f\n",'$(cat /proc/meminfo | grep "SwapFree" | awk '{print $2}')'/1024)}')
    echo '{' >${routerhook_hass_text}
    echo '"state":'$value >>${routerhook_hass_text}
    echo ',"value1":'$value >>${routerhook_hass_text}
    echo ',"value2":"'$unit'"' >>${routerhook_hass_text}
    echo ',"value3":"'$friendly_name'"' >>${routerhook_hass_text}
    echo ',"attributes":{"unit_of_measurement":"'$unit'","friendly_name":"'$friendly_name'"}' >>${routerhook_hass_text}
    echo '}' >>${routerhook_hass_text}
    routerhook_send_content=$(jq -c . ${routerhook_hass_text})
    source /koolshare/scripts/routerhook_sender.sh
fi

# CPU温度
if [ "${routerhook_sm_cpu}" == "1" ]; then
    msg_type='rh_cpu_temp'
    unit='\u00b0C'
    friendly_name='Router CPU Temperature'
    cpu_temperature_origin=$(cat /sys/class/thermal/thermal_zone0/temp)
    value=$(awk 'BEGIN{printf "%.1f\n",('$cpu_temperature_origin'/'1000')}')
    echo '{' >${routerhook_hass_text}
    echo '"state":'$value >>${routerhook_hass_text}
    echo ',"value1":'$value >>${routerhook_hass_text}
    echo ',"value2":"'$unit'"' >>${routerhook_hass_text}
    echo ',"value3":"'$friendly_name'"' >>${routerhook_hass_text}
    echo ',"attributes":{"unit_of_measurement":"'$unit'","friendly_name":"'$friendly_name'"}' >>${routerhook_hass_text}
    echo '}' >>${routerhook_hass_text}
    routerhook_send_content=$(jq -c . ${routerhook_hass_text})
    source /koolshare/scripts/routerhook_sender.sh
fi

# 2.4G温度
if [ "${routerhook_sm_24g}" == "1" ]; then
    interface_2g=$(nvram get wl0_ifname)
    interface_2g_temperature=$(wl -i ${interface_2g} phy_tempsense | awk '{print $1}') 2>/dev/null
    [ -n "${interface_2g_temperature}" ] && interface_2g_temperature_c=$(expr ${interface_2g_temperature} / 2 + 20) || interface_2g_temperature_c="null"

    msg_type='rh_24g_temp'
    unit='\u00b0C'
    friendly_name='Router 2.4G Temperature'
    value=$interface_2g_temperature
    echo '{' >${routerhook_hass_text}
    echo '"state":'$value >>${routerhook_hass_text}
    echo ',"value1":'$value >>${routerhook_hass_text}
    echo ',"value2":"'$unit'"' >>${routerhook_hass_text}
    echo ',"value3":"'$friendly_name'"' >>${routerhook_hass_text}
    echo ',"attributes":{"unit_of_measurement":"'$unit'","friendly_name":"'$friendly_name'"}' >>${routerhook_hass_text}
    echo '}' >>${routerhook_hass_text}
    routerhook_send_content=$(jq -c . ${routerhook_hass_text})
    source /koolshare/scripts/routerhook_sender.sh
fi

# 5G1温度
if [ "${routerhook_sm_5g1}" == "1" ]; then
    interface_5g1=$(nvram get wl1_ifname)
    interface_5g1_temperature=$(wl -i ${interface_5g1} phy_tempsense | awk '{print $1}') 2>/dev/null
    [ -n "${interface_5g1_temperature}" ] && interface_5g1_temperature_c=$(expr ${interface_5g1_temperature} / 2 + 20) || interface_5g1_temperature_c="null"

    msg_type='rh_5g1_temp'
    unit='\u00b0C'
    friendly_name='Router 5G-1 Temperature'
    value=$interface_5g1_temperature
    echo '{' >${routerhook_hass_text}
    echo '"state":'$value >>${routerhook_hass_text}
    echo ',"value1":'$value >>${routerhook_hass_text}
    echo ',"value2":"'$unit'"' >>${routerhook_hass_text}
    echo ',"value3":"'$friendly_name'"' >>${routerhook_hass_text}
    echo ',"attributes":{"unit_of_measurement":"'$unit'","friendly_name":"'$friendly_name'"}' >>${routerhook_hass_text}
    echo '}' >>${routerhook_hass_text}
    routerhook_send_content=$(jq -c . ${routerhook_hass_text})
    source /koolshare/scripts/routerhook_sender.sh
fi

# 设备在线状态
if [ "${routerhook_sm_bwlist_en}" == "1" ]; then
    [[ "${routerhook_sm_bwlist_and}" == "1" ]] && union_device_value="ON" || union_device_value="OFF"
    unit='OL'
    # 获取用户配置的设备mac列表（全部转为小写）
    bwlist=$(dbus get routerhook_sm_bwlist | base64_decode | cut -d# -f2)
    if [[ -n "${bwlist}" ]]; then
        echo "${bwlist}" | while read line; do
            msg_type="rh_dev_${line//:/}"
            friendly_name="Router Device ${line}"
            arp_check=$(arp | grep "br0" | grep -v "incomplete" | grep -i "${line}")
            [[ "${arp_check}" == "" ]] && value="OFF" || value="ON"
            if [ "${routerhook_sm_bwlist_or}" == "1" ]; then
                if [ "${union_device_value}" == "ON" ] || [ "${value}" == "ON" ]; then
                    union_device_value="ON"
                else
                    union_device_value="OFF"
                fi
            else
                if [ "${union_device_value}" == "ON" ] && [ "${value}" == "ON" ]; then
                    union_device_value="ON"
                else
                    union_device_value="OFF"
                fi
            fi
            echo '{' >${routerhook_hass_text}
            echo '"state":"'$value'"' >>${routerhook_hass_text}
            echo ',"value1":"'$value'"' >>${routerhook_hass_text}
            echo ',"value2":"'$unit'"' >>${routerhook_hass_text}
            echo ',"value3":"'$friendly_name'"' >>${routerhook_hass_text}
            echo ',"attributes":{"unit_of_measurement":"'$unit'","friendly_name":"'$friendly_name'"}' >>${routerhook_hass_text}
            echo '}' >>${routerhook_hass_text}
            routerhook_send_content=$(jq -c . ${routerhook_hass_text})
            source /koolshare/scripts/routerhook_sender.sh
            # 由于read line为管道模式，所以while中对union_device_value的更改不会传递到外面去，需要通过文件进行值传递
            echo $union_device_value >${routerhook_hass_text}
        done
        if [ "${routerhook_sm_bwlist_or}" == "1" -o "${routerhook_sm_bwlist_and}" == "1" ]; then
            msg_type="rh_dev"
            friendly_name="Router Device Union"
            value=$(cat ${routerhook_hass_text})
            echo '{' >${routerhook_hass_text}
            echo '"state":"'$value'"' >>${routerhook_hass_text}
            echo ',"value1":"'$value'"' >>${routerhook_hass_text}
            echo ',"value2":"'$unit'"' >>${routerhook_hass_text}
            echo ',"value3":"'$friendly_name'"' >>${routerhook_hass_text}
            echo ',"attributes":{"unit_of_measurement":"'$unit'","friendly_name":"'$friendly_name'"}' >>${routerhook_hass_text}
            echo '}' >>${routerhook_hass_text}
            routerhook_send_content=$(jq -c . ${routerhook_hass_text})
            source /koolshare/scripts/routerhook_sender.sh
        fi
    fi
fi
