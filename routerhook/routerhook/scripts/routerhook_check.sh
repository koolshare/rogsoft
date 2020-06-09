#!/bin/sh

source /koolshare/scripts/base.sh
eval $(dbus export routerhook_)
model=$(nvram get model)
if [ "${routerhook_config_ntp}" == "" ]; then
    ntp_server="ntp1.aliyun.com"
else
    ntp_server=${routerhook_config_ntp}
fi
ntpclient -h ${ntp_server} -i3 -l -s >/dev/null 2>&1
routerhook_info_text=/tmp/.routerhook_info.json
app_file=/tmp/.app.json.js
dnsmasq_leases_file="/var/lib/misc/dnsmasq.leases"
rm -rf ${routerhook_info_text} ${app_file}

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

msg_type="cronINFO"
case "${clang_action}" in
task)
    [ "${routerhook_info_logger}" == "1" ] && logger "[routerhook]: 启动定时推送任务！"
    msg_type="cronINFO"
    ;;
*)
    [ "${routerhook_info_logger}" == "1" ] && logger "[routerhook]: 启动手动推送任务！"
    msg_type="manuINFO"
    ;;
esac
dnsmasq_pid=$(ps | grep "dnsmasq" | grep "nobody" | grep -v grep | awk '{print $1}')
kill -12 ${dnsmasq_pid}
sleep 1
[ ! -L "/koolshare/bin/base64_decode" ] && ln -s /koolshare/bin/base64_encode /koolshare/bin/base64_decode

echo '{' >${routerhook_info_text}
echo '"msgTYPE":"'${msg_type}'"' >>${routerhook_info_text}

# 系统运行状态
if [ "${routerhook_info_system}" == "1" ]; then
    router_name=$(nvram get computer_name)
    router_firmware=$(echo $(nvram get buildno)_$(nvram get extendno))
    router_get_mode=$(nvram get sw_mode)
    if [[ "${router_get_mode}" == "1" ]]; then
        router_mode="无线路由器"
    elif [[ "${router_get_mode}" == "2" ]]; then
        router_mode="无线桥接模式"
    elif [[ "${router_get_mode}" == "3" ]]; then
        router_mode="无线访问点 (Access Point)"
    elif [[ "${router_get_mode}" == "4" ]]; then
        router_mode="Media Bridge"
    else
        router_mode="本次未获取到"
    fi
    router_time=$(echo $(TZ=UTC-8 date "+%Y年%m月%d日 %H点%M分%S秒"))
    router_upseconds=$(cat /proc/uptime | awk '{print int($1)}')
    router_uptime=$(cat /proc/uptime | awk '{print $1}' | awk '{print int($1/86400)"天"int($1%86400/3600)"时"int(($1%3600)/60)"分"int($1%60)"秒"}')
    router_cpu_loadavg_1min=$(cat /proc/loadavg | awk '{print $1}')
    router_cpu_loadavg_5min=$(cat /proc/loadavg | awk '{print $2}')
    router_cpu_loadavg_15min=$(cat /proc/loadavg | awk '{print $3}')
    router_memtotal=$(awk 'BEGIN{printf ("%.2f\n",'$(cat /proc/meminfo | grep "MemTotal" | awk '{print $2}')'/1024)}')
    router_memfree=$(awk 'BEGIN{printf ("%.2f\n",'$(cat /proc/meminfo | grep "MemFree" | awk '{print $2}')'/1024)}')
    router_swaptotal=$(awk 'BEGIN{printf ("%.2f\n",'$(cat /proc/meminfo | grep "SwapTotal" | awk '{print $2}')'/1024)}')
    router_swapfree=$(awk 'BEGIN{printf ("%.2f\n",'$(cat /proc/meminfo | grep "SwapFree" | awk '{print $2}')'/1024)}')
    router_jffs_total=$(df -h | grep "/jffs" | grep -v grep | awk '{print $2}')
    router_jffs_used=$(df -h | grep "/jffs" | grep -v grep | awk '{print $3}')
    router_jffs_available=$(df -h | grep "/jffs" | grep -v grep | awk '{print $4}')
    router_jffs_use=$(df -h | grep "/jffs" | grep -v grep | awk '{print $5}')
    echo ',"sysINFO":{' >>${routerhook_info_text}
    echo '"routerNAME":"'${router_name}'",' >>${routerhook_info_text}
    echo '"routerTIME":"'${router_time}'",' >>${routerhook_info_text}
    echo '"routerFIRMWARE":"'${router_firmware}'",' >>${routerhook_info_text}
    echo '"routerMODE":"'${router_mode}'",' >>${routerhook_info_text}
    echo '"routerUPTIME":"'${router_uptime}'",' >>${routerhook_info_text}
    echo '"routerUPSECONDS":'${router_upseconds}',' >>${routerhook_info_text}
    echo '"routerAVGLOAD":['${router_cpu_loadavg_1min}', '${router_cpu_loadavg_5min}', '${router_cpu_loadavg_15min}'],' >>${routerhook_info_text}
    echo '"routerMEM":{"unit":"MB","all":'${router_memtotal}', "free":'${router_memfree}'},' >>${routerhook_info_text}
    echo '"routerSWAP":{"free":'${router_swapfree}',"total":'${router_swaptotal}'},' >>${routerhook_info_text}
    echo '"routerJFFS":{"used":"'${router_jffs_used}'","total":"'${router_jffs_total}'","available":"'${router_jffs_available}'","use":"'${router_jffs_use}'"}' >>${routerhook_info_text}
    echo '}' >>${routerhook_info_text}
fi

# 温度传感器
if [[ "${routerhook_info_temp}" == "1" ]]; then
    cpu_temperature_origin=$(cat /sys/class/thermal/thermal_zone0/temp)
    router_cpu_temperature=$(awk 'BEGIN{printf "%.1f\n",('$cpu_temperature_origin'/'1000')}')

    echo ',"tempINFO":{"unit":"°C",' >>${routerhook_info_text}
    case "$model" in
    GT-AC5300 | GT-AX11000)
        interface_2g=$(nvram get wl0_ifname)
        interface_5g1=$(nvram get wl1_ifname)
        interface_5g2=$(nvram get wl2_ifname)
        interface_2g_temperature=$(wl -i ${interface_2g} phy_tempsense | awk '{print $1}') 2>/dev/null
        interface_5g1_temperature=$(wl -i ${interface_5g1} phy_tempsense | awk '{print $1}') 2>/dev/null
        interface_5g2_temperature=$(wl -i ${interface_5g2} phy_tempsense | awk '{print $1}') 2>/dev/null
        [ -n "${interface_2g_temperature}" ] && interface_2g_temperature_c=$(expr ${interface_2g_temperature} / 2 + 20) || interface_2g_temperature_c="null"
        [ -n "${interface_5g1_temperature}" ] && interface_5g1_temperature_c=$(expr ${interface_5g1_temperature} / 2 + 20) || interface_5g1_temperature_c="null"
        [ -n "${interface_5g2_temperature}" ] && interface_5g2_temperature_c=$(expr ${interface_5g2_temperature} / 2 + 20) || interface_5g2_temperature_c="null"
        # router_temperature="2.4G: ${interface_2g_temperature_c} | 5G-1: ${interface_5g1_temperature_c} | 5G-2: ${interface_5g2_temperature_c} | CPU: ${router_cpu_temperature}°C"
        echo '"CPU":'${router_cpu_temperature}',' >>${routerhook_info_text}
        echo '"5G2":'${interface_5g2_temperature_c}',' >>${routerhook_info_text}
        echo '"5G1":'${interface_5g1_temperature_c}',' >>${routerhook_info_text}
        echo '"24G":'${interface_2g_temperature_c} >>${routerhook_info_text}
        ;;
    *)
        interface_2g=$(nvram get wl0_ifname)
        interface_5g1=$(nvram get wl1_ifname)
        interface_2g_temperature=$(wl -i ${interface_2g} phy_tempsense | awk '{print $1}') 2>/dev/null
        interface_5g1_temperature=$(wl -i ${interface_5g1} phy_tempsense | awk '{print $1}') 2>/dev/null
        [ -n "${interface_2g_temperature}" ] && interface_2g_temperature_c=$(expr ${interface_2g_temperature} / 2 + 20) || interface_2g_temperature_c="null"
        [ -n "${interface_5g1_temperature}" ] && interface_5g1_temperature_c=$(expr ${interface_5g1_temperature} / 2 + 20) || interface_5g1_temperature_c="null"
        #router_temperature="2.4G：${interface_2g_temperature_c} &nbsp;&nbsp;|&nbsp;&nbsp; 5G-1：${interface_5g1_temperature_c} &nbsp;&nbsp;|&nbsp;&nbsp; CPU: ${router_cpu_temperature}°C"
        # router_temperature="2.4GHz: ${interface_2g_temperature_c} | 5GHz: ${interface_5g1_temperature_c} | CPU: ${router_cpu_temperature}°C"
        echo '"CPU":'${router_cpu_temperature}',' >>${routerhook_info_text}
        echo '"5G1":'${interface_5g1_temperature_c}',' >>${routerhook_info_text}
        echo '"24G":'${interface_2g_temperature_c}'' >>${routerhook_info_text}
        ;;
    esac
    echo '}' >>${routerhook_info_text}
fi

# 网络运行状态
if [[ "${routerhook_info_wan}" == "1" ]]; then
    # 网络信息
    router_wan0_proto=$(nvram get wan0_proto)
    router_wan0_ifname=$(nvram get wan0_ifname)
    router_wan0_gw=$(nvram get wan0_gw_ifname)
    router_wan0_ip=$(nvram get wan0_ipaddr)
    if [[ "${routerhook_info_pub}" == "1" ]]; then
        router_wan0_ip4=$(curl -4 --interface ${router_wan0_gw} -s http://api.ip.sb/ip 2>&1)
        router_wan0_ip6=$(curl -6 --interface ${router_wan0_gw} -s http://api.ip.sb/ip 2>&1)
    else
        router_wan0_ip4=${router_wan0_ip}
        router_wan0_ip6=""
    fi
    router_wan0_dns1=$(nvram get wan0_dns | awk '{print $1}')
    router_wan0_dns2=$(nvram get wan0_dns | awk '{print $2}')
    router_wan0_rx=$(ifconfig ${router_wan0_ifname} | grep 'RX bytes' | cut -d\( -f2 | cut -d\) -f1)
    router_wan0_tx=$(ifconfig ${router_wan0_ifname} | grep 'TX bytes' | cut -d\( -f3 | cut -d\) -f1)
    echo ',"netINFO":{' >>${routerhook_info_text}

    echo '"WAN":[' >>${routerhook_info_text}
    echo '{' >>${routerhook_info_text}
    echo '"proto":"'${router_wan0_proto}'",' >>${routerhook_info_text}
    echo '"pubIPv4":"'${router_wan0_ip4}'",' >>${routerhook_info_text}
    echo '"pubIPv6":"'${router_wan0_ip6}'",' >>${routerhook_info_text}
    echo '"wanIPv4":"'${router_wan0_ip}'",' >>${routerhook_info_text}
    echo '"wanDNS":["'${router_wan0_dns1}'","'${router_wan0_dns2}'"],' >>${routerhook_info_text}
    echo '"wanRX":"'${router_wan0_rx}'",' >>${routerhook_info_text}
    echo '"wanTX":"'${router_wan0_tx}'"' >>${routerhook_info_text}
    echo '}' >>${routerhook_info_text}

    router_wan1_ifname=$(nvram get wan1_ifname)
    router_wan1_gw=$(nvram get wan1_gw_ifname)
    if [ -n "${router_wan1_ifname}" ] && [ -n "${router_wan1_gw}" ]; then
        router_wan1_proto=$(nvram get wan1_proto)
        router_wan1_ip=$(nvram get wan1_ipaddr)
        if [[ "${routerhook_info_pub}" == "1" ]]; then
            router_wan1_ip4=$(curl -4 --interface ${router_wan1_gw} -s http://api.ip.sb/ip 2>&1)
            router_wan1_ip6=$(curl -6 --interface ${router_wan1_gw} -s http://api.ip.sb/ip 2>&1)
        else
            router_wan1_ip4=${router_wan1_ip}
            router_wan1_ip6=""
        fi
        router_wan1_dns1=$(nvram get wan1_dns | awk '{print $1}')
        router_wan1_dns2=$(nvram get wan1_dns | awk '{print $2}')
        router_wan1_rx=$(ifconfig ${router_wan1_ifname} | grep 'RX bytes' | cut -d\( -f2 | cut -d\) -f1)
        router_wan1_tx=$(ifconfig ${router_wan1_ifname} | grep 'TX bytes' | cut -d\( -f3 | cut -d\) -f1)
        echo ',{' >>${routerhook_info_text}
        echo '"proto":"'${router_wan1_proto}'",' >>${routerhook_info_text}
        echo '"pubIPv4":"'${router_wan1_ip4}'",' >>${routerhook_info_text}
        echo '"pubIPv6":"'${router_wan1_ip6}'",' >>${routerhook_info_text}
        echo '"wanIPv4":"'${router_wan1_ip}'",' >>${routerhook_info_text}
        echo '"wanDNS":["'${router_wan1_dns1}'","'${router_wan1_dns2}'"],' >>${routerhook_info_text}
        echo '"wanRX":"'${router_wan1_rx}'",' >>${routerhook_info_text}
        echo '"wanTX":"'${router_wan1_tx}'"' >>${routerhook_info_text}
        echo '}' >>${routerhook_info_text}
    fi
    echo ']' >>${routerhook_info_text}

    # ddns状态
    ddns_enable=$(nvram get ddns_enable_x)
    if [[ "${routerhook_info_wan}" == "1" ]]; then
        echo ',"DDNS":"'$(nvram get ddns_hostname_x)'"' >>${routerhook_info_text}
    fi

    # ss状态
    net_check_time=$(date "+%Y-%m-%d %H:%M:%S")
    get_china_status() {
        local ret=$(httping www.baidu.com -s -Z -c1 -f -t 3 2>/dev/null | sed -n '2p' | sed 's/seq=0//g' | sed 's/([0-9]\+\sbytes),\s//g')
        local S1=$(echo $ret | grep -Eo "200 OK")
        if [ -n "$S1" ]; then
            local S2=$(echo $ret | sed 's/time=//g' | awk '{printf "%.0f ms\n",$(NF -3)}')
            echo ',"chinaSTATUS":"国内链接 【'${net_check_time}'】 ✓ '$S2'"' >>${routerhook_info_text}
        else
            echo ',"chinaSTATUS":"国内链接 【'${net_check_time}'】 X"' >>${routerhook_info_text}
        fi
    }
    get_foreign_status() {
        local ret=$(httping www.google.com.tw -s -Z -c1 -f -t 3 2>/dev/null | sed -n '2p' | sed 's/seq=0//g' | sed 's/([0-9]\+\sbytes),\s//g')
        local S1=$(echo $ret | grep -Eo "200 OK")
        if [ -n "$S1" ]; then
            local S2=$(echo $ret | sed 's/time=//g' | awk '{printf "%.0f ms\n",$(NF -3)}')
            echo ',"foreignSTATUS":"国外链接 【'${net_check_time}'】 ✓ '$S2'"' >>${routerhook_info_text}
        else
            echo ',"foreignSTATUS":"国外链接 【'${net_check_time}'】 X"' >>${routerhook_info_text}
        fi
    }
    ss_status=$(dbus get ss_basic_enable)
    if [[ "${ss_status}" == "1" ]]; then
        get_china_status >>${routerhook_info_text}
        get_foreign_status >>${routerhook_info_text}
    fi

    # 路由器局域网地址
    router_lan_ip=$(nvram get lan_ipaddr_rt)
    echo ',"routerLANIP":"'${router_lan_ip}'"' >>${routerhook_info_text}

    # 无线网络信息
    router_smart_connect=$(nvram get smart_connect_x)
    echo ',"wifiINFO":{' >>${routerhook_info_text}
    if [[ "${router_smart_connect}" == "1" ]]; then
        router_ssid=$(nvram get wl_ssid)
        echo '"SmartConnect":"'${router_ssid}'"' >>${routerhook_info_text}
    else
        if [[ "$(nvram get wl0_bss_enabled)" == "1" ]]; then
            router_wl0_ssid=$(nvram get wl0_ssid)
            echo '"24G":"'${router_wl0_ssid}'"' >>${routerhook_info_text}
        fi
        if [[ "$(nvram get wl1_bss_enabled)" == "1" ]]; then
            router_wl1_ssid=$(nvram get wl1_ssid)
            echo ',"5G1":"'${router_wl1_ssid}'"' >>${routerhook_info_text}
        fi
        if [[ "$(nvram get wl2_bss_enabled)" == "1" ]]; then
            router_wl2_ssid=$(nvram get wl2_ssid)
            echo ',"5G2":"'${router_wl2_ssid}'"' >>${routerhook_info_text}
        fi
    fi
    echo '}' >>${routerhook_info_text}

    # 访客网络信息
    echo ',"guestINFO":{' >>${routerhook_info_text}
    wlg_lists="0.1 0.2 0.3 1.1 1.2 1.3 2.1 2.2 2.3"
    for wlg_status in ${wlg_lists}; do
        if [[ "$(nvram get wl${wlg_status}_bss_enabled)" == "1" ]]; then
            [ "${wlg_status}" == "0.1" ] && wlg_name="24G1"
            [ "${wlg_status}" == "0.2" ] && wlg_name="24G2"
            [ "${wlg_status}" == "0.3" ] && wlg_name="24G3"
            [ "${wlg_status}" == "1.1" ] && wlg_name="5G11"
            [ "${wlg_status}" == "1.2" ] && wlg_name="5G12"
            [ "${wlg_status}" == "1.3" ] && wlg_name="5G13"
            [ "${wlg_status}" == "2.1" ] && wlg_name="5G21"
            [ "${wlg_status}" == "2.2" ] && wlg_name="5G22"
            [ "${wlg_status}" == "2.3" ] && wlg_name="5G23"
            echo '"'${wlg_name}'":"'$(nvram get wl${wlg_status}_ssid)'",' >>${routerhook_info_text}
        fi
    done
    echo '"end":null}' >>${routerhook_info_text}

    echo '}' >>${routerhook_info_text}
fi

# USB设备列表
if [[ "${routerhook_info_usb}" == "1" ]]; then
    echo ',"usbINFO":[' >>${routerhook_info_text}
    usb1_fs_path=$(nvram get usb_path1_fs_path0)
    if [ -n "${usb1_fs_path}" ]; then
        usb1_product=$(echo $(nvram get usb_path1_manufacturer) $(nvram get usb_path1_product))
        usb1_removed=$(nvram get usb_path1_removed)
        usb1_total=$(df -h | grep "${usb1_fs_path}" | head -n1 | awk '{print $2}')
        usb1_used=$(df -h | grep "${usb1_fs_path}" | head -n1 | awk '{print $3}')
        usb1_available=$(df -h | grep "${usb1_fs_path}" | head -n1 | awk '{print $4}')
        usb1_use=$(df -h | grep "${usb1_fs_path}" | head -n1 | awk '{print $5}')
        [ "${usb1_removed}" == "1" ] && usb1_status="removed" || usb1_status="mounted"
        [ -n "${usb1_total}"] && usb1_total || usb1_total=0
        [ -n "${usb1_used}"] && usb1_used || usb1_used=0
        [ -n "${usb1_available}"] && usb1_available || usb1_available=0
        echo '{' >>${routerhook_info_text}
        echo '"name":"'${usb1_product}'",' >>${routerhook_info_text}
        echo '"status":"'${usb1_status}'",' >>${routerhook_info_text}
        echo '"total":"'${usb1_total}'",' >>${routerhook_info_text}
        echo '"used":"'${usb1_used}'",' >>${routerhook_info_text}
        echo '"free":"'${usb1_available}'",' >>${routerhook_info_text}
        echo '"use":"'${usb1_use}'"' >>${routerhook_info_text}
        echo '}' >>${routerhook_info_text}
    else
        echo "{}" >>${routerhook_info_text}
    fi

    usb2_fs_path=$(nvram get usb_path2_fs_path0)
    if [ -n "${usb2_fs_path}" ]; then
        usb2_product=$(echo $(nvram get usb_path2_manufacturer) $(nvram get usb_path2_product))
        usb2_removed=$(nvram get usb_path2_removed)
        usb2_total=$(df -h | grep "${usb2_fs_path}" | head -n1 | awk '{print $2}')
        usb2_used=$(df -h | grep "${usb2_fs_path}" | head -n1 | awk '{print $3}')
        usb2_available=$(df -h | grep "${usb2_fs_path}" | head -n1 | awk '{print $4}')
        usb2_use=$(df -h | grep "${usb2_fs_path}" | head -n1 | awk '{print $5}')
        [ "${usb2_removed}" == "1" ] && usb2_status="removed" || usb2_status="mounted"
        [ -n "${usb2_total}"] && usb2_total || usb2_total=0
        [ -n "${usb2_used}"] && usb2_used || usb2_used=0
        [ -n "${usb2_available}"] && usb2_available || usb2_available=0
        echo ',{' >>${routerhook_info_text}
        echo '"name":"'${usb2_product}'",' >>${routerhook_info_text}
        echo '"status":"'${usb2_status}'",' >>${routerhook_info_text}
        echo '"total":"'${usb2_total}'",' >>${routerhook_info_text}
        echo '"used":"'${usb2_used}'",' >>${routerhook_info_text}
        echo '"free":"'${usb2_available}'",' >>${routerhook_info_text}
        echo '"use":"'${usb2_use}'"' >>${routerhook_info_text}
        echo '}' >>${routerhook_info_text}
    else
        echo ",{}" >>${routerhook_info_text}
    fi
    echo ']' >>${routerhook_info_text}
fi

# 客户端列表
if [[ "${routerhook_info_lan}" == "1" ]]; then
    echo ',"cliINFO":[' >>${routerhook_info_text}
    arp_list=$(arp | grep "br0" | grep -v "incomplete" | sed 's/ (/\t/g' | sed 's/) at /\t/' | sed 's/\[ether\]/ /g' | cut -d " " -f1 | sort -t "." -k3n,3 -k4n,4)
    if [ -n "${arp_list}" ]; then
        # arp_list_title="|IP|MAC|客户端名称|"
        arp_num=0
        echo "${arp_list}" | while read line; do
            if [[ "${arp_num}" != "0" ]]; then
                echo ',' >>${routerhook_info_text}
            fi
            echo '{' >>${routerhook_info_text}
            arp_client_mac=$(echo ${line} | awk '{print $3}')
            arp_dhcp_white_name=$(echo $(dbus get routerhook_trigger_dhcp_white | base64_decode | grep -i "${arp_client_mac}") | cut -d# -f2)
            if [[ "${arp_dhcp_white_name}" == "" ]]; then
                arp_custom_clientlist=$(echo $(nvram get custom_clientlist | sed 's/</\n/g' | awk -F ">" '{print $1"##"$2}' | sed '/^##*$/d' | grep -i "${arp_client_mac}"))
                if [[ "${arp_custom_clientlist}" == "" ]]; then
                    if [ "$routerhook_info_lan_macoff" == "1" ]; then
                        echo ${line} | awk '{print "\"ip\":\""$2"\",\"name\":\""$1"\""}' >>${routerhook_info_text}
                    else
                        echo ${line} | awk '{print "\"ip\":\""$2"\",\"mac\":\""$3"\",\"name\":\""$1"\""}' >>${routerhook_info_text}
                    fi
                else
                    arp_lease_name=$(echo ${arp_custom_clientlist} | awk -F "##" '{print $1}')
                    if [ "$routerhook_info_lan_macoff" == "1" ]; then
                        echo $(echo "${line}" | awk '{print "\"ip\":\""$2"\",\"name\":"}')"\"${arp_lease_name}\"" >>${routerhook_info_text}
                    else
                        echo $(echo "${line}" | awk '{print "\"ip\":\""$2"\",\"mac\":\""$3"\",\"name\":"}')"\"${arp_lease_name}\"" >>${routerhook_info_text}
                    fi
                fi
            else
                if [ "$routerhook_info_lan_macoff" == "1" ]; then
                    echo $(echo "${line}" | awk '{print "\"ip\":\""$2"\",\"name\":"}')"\"${arp_dhcp_white_name}\"" >>${routerhook_info_text}
                else
                    echo $(echo "${line}" | awk '{print "\"ip\":\""$2"\",\"mac\":\""$3"\",\"name\":"}')"\"${arp_dhcp_white_name}\"" >>${routerhook_info_text}
                fi
            fi
            echo '}' >>${routerhook_info_text}
            let arp_num=arp_num+1
        done
    fi
    echo ']' >>${routerhook_info_text}
fi

# DHCP租期列表
if [[ "${routerhook_info_dhcp}" == "1" ]]; then
    echo ',"dhcpINFO":[' >>${routerhook_info_text}
    dnsmasq_leases_list=$(cat ${dnsmasq_leases_file} | sort -t "." -k3n,3 -k4n,4)
    num=0
    echo "${dnsmasq_leases_list}" | while read line; do
        if [[ "${num}" != "0" ]]; then
            echo ',' >>${routerhook_info_text}
        fi
        echo '{' >>${routerhook_info_text}
        dhcp_client_mac=$(echo ${line} | awk '{print $2}')
        trigger_dhcp_white_name=$(echo $(dbus get routerhook_trigger_dhcp_white | base64_decode | grep -i "${dhcp_client_mac}") | cut -d# -f2)
        if [[ "${trigger_dhcp_white_name}" == "" ]]; then
            dhcp_custom_clientlist=$(echo $(nvram get custom_clientlist | sed 's/</\n/g' | awk -F ">" '{print $1"##"$2}' | sed '/^##*$/d' | grep -i "${dhcp_client_mac}"))
            if [[ "${dhcp_custom_clientlist}" == "" ]]; then
                if [ "$routerhook_info_dhcp_macoff" == "1" ]; then
                    echo ${line} | awk '{print "\"ip\":\""$3"\",\"name\":\""$4"\""}' >>${routerhook_info_text}
                else
                    echo ${line} | awk '{print "\"ip\":\""$3"\",\"mac\":\""$2"\",\"name\":\""$4"\""}' >>${routerhook_info_text}
                fi
            else
                dhcp_lease_name=$(echo ${dhcp_custom_clientlist} | awk -F "##" '{print $1}')
                if [ "$routerhook_info_dhcp_macoff" == "1" ]; then
                    echo $(echo "${line}" | awk '{print "\"ip\":\""$3"\",\"name\":"}')"\"${dhcp_lease_name}\"" >>${routerhook_info_text}
                else
                    echo $(echo "${line}" | awk '{print "\"ip\":\""$3"\",\"mac\":\""$2"\",\"name\":"}')"\"${dhcp_lease_name}\"" >>${routerhook_info_text}
                fi
            fi
        else
            if [ "$routerhook_info_dhcp_macoff" == "1" ]; then
                echo $(echo "${line}" | awk '{print "\"ip\":\""$3"\",\"name\":"}')"\"${trigger_dhcp_white_name}\"" >>${routerhook_info_text}
            else
                echo $(echo "${line}" | awk '{print "\"ip\":\""$3"\",\"mac\":\""$2"\",\"name\":"}')"\"${trigger_dhcp_white_name}\"" >>${routerhook_info_text}
            fi
        fi
        echo '}' >>${routerhook_info_text}
        let num=num+1
    done
    echo ']' >>${routerhook_info_text}
fi

echo '}' >>${routerhook_info_text}

routerhook_send_content=$(jq -c . ${routerhook_info_text})

source /koolshare/scripts/routerhook_sender.sh
