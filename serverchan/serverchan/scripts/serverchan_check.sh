#!/bin/sh
source /koolshare/scripts/base.sh
eval $(dbus export serverchan_)
model=$(nvram get model)
if [ "${serverchan_config_ntp}" == "" ]; then
    ntp_server="ntp1.aliyun.com"
else
    ntp_server=${serverchan_config_ntp}
fi
ntpclient -h ${ntp_server} -i3 -l -s >/dev/null 2>&1
serverchan_info_text=/tmp/.serverchan_info.md
softcenter_app_url="https://rogsoft.ddnsto.com/softcenter/app.json.js"
app_file=/tmp/.app.json.js
dnsmasq_leases_file="/var/lib/misc/dnsmasq.leases"
rm -rf ${serverchan_info_text} ${app_file}

if [[ "${serverchan_enable}" != "1" ]]; then
    exit
fi
clang_action="$1"
if [[ "${clang_action}" == "task" ]]; then
    if [[ "${serverchan_info_silent_send}" == "0" ]]; then
        if [[ "${serverchan_silent_time}" == "1" ]]; then
            router_now_hour=$(date "+%H")
            if [[ "${router_now_hour}" -ge "${serverchan_silent_time_start_hour}" ]] || [[ "${router_now_hour}" -lt "${serverchan_silent_time_end_hour}" ]]; then
                [ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 推送时间在消息免打扰时间内，推送任务通道静默！"
                exit
            fi
        fi
    fi
fi
case "${clang_action}" in
task)
    [ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 启动定时推送任务！"
    echo "###### 本次信息推送：定时任务." >${serverchan_info_text}
    ;;
*)
    [ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 启动手动推送任务！"
    echo "###### 本次信息推送：手动推送." >${serverchan_info_text}
    ;;
esac
dnsmasq_pid=$(ps | grep "dnsmasq" | grep "nobody" | grep -v grep | awk '{print $1}')
kill -12 ${dnsmasq_pid}
sleep 1
[ ! -L "/koolshare/bin/base64_decode" ] && ln -s /koolshare/bin/base64_encode /koolshare/bin/base64_decode
send_title=$(echo "$serverchan_config_name" | base64_decode)
# 系统运行状态
if [ "${serverchan_info_system}" == "1" ]; then
    echo "---" >>${serverchan_info_text}
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
    router_uptime=$(cat /proc/uptime | awk '{print $1}' | awk '{print int($1/86400)"天 "int($1%86400/3600)"小时 "int(($1%3600)/60)"分钟 "int($1%60)"秒"}')
    router_cpu_loadavg_1min=$(cat /proc/loadavg | awk '{print $1}')
    router_cpu_loadavg_5min=$(cat /proc/loadavg | awk '{print $2}')
    router_cpu_loadavg_15min=$(cat /proc/loadavg | awk '{print $3}')
    router_memtotal=$(awk 'BEGIN{printf ("%.2f\n",'$(cat /proc/meminfo | grep "MemTotal" | awk '{print $2}')'/1024)}')
    router_memfree=$(awk 'BEGIN{printf ("%.2f\n",'$(cat /proc/meminfo | grep "MemFree" | awk '{print $2}')'/1024)}')
    router_swaptotal=$(awk 'BEGIN{printf ("%.2f\n",'$(cat /proc/meminfo | grep "SwapTotal" | awk '{print $2}')'/1024)}')
    router_swapfree=$(awk 'BEGIN{printf ("%.2f\n",'$(cat /proc/meminfo | grep "SwapFree" | awk '{print $2}')'/1024)}')
    router_jffs_total=$(df -h | grep "/jffs" | grep -v grep | awk '{print $2}' | sed 's/M//g')
    router_jffs_used=$(df -h | grep "/jffs" | grep -v grep | awk '{print $3}' | sed 's/M//g')
    echo "#### **系统运行状态:**" >>${serverchan_info_text}
    echo "##### 系统名称: ${router_name}" >>${serverchan_info_text}
    echo "##### 系统当前时间: ${router_time}" >>${serverchan_info_text}
    echo "##### 固件版本: ${router_firmware}" >>${serverchan_info_text}
    echo "##### 系统模式: ${router_mode}" >>${serverchan_info_text}
    echo "##### 系统运行时间: ${router_uptime}" >>${serverchan_info_text}
    echo "##### 平均负载(1,5,15min): ${router_cpu_loadavg_1min}, ${router_cpu_loadavg_5min}, ${router_cpu_loadavg_15min}" >>${serverchan_info_text}
    echo "##### 总内存: ${router_memtotal}MB   空闲数: ${router_memfree}MB" >>${serverchan_info_text}
    echo "##### 虚拟内存: $(awk 'BEGIN{printf ("%.2f\n",'${router_swaptotal}'-'${router_swapfree}')}') / ${router_swaptotal} MB" >>${serverchan_info_text}
    echo "##### JFFS: ${router_jffs_used} / ${router_jffs_total} MB" >>${serverchan_info_text}
fi
# 温度传感器
if [[ "${serverchan_info_temp}" == "1" ]]; then
    echo "---" >>${serverchan_info_text}
    cpu_temperature_origin=$(cat /sys/class/thermal/thermal_zone0/temp)
    router_cpu_temperature=$(awk 'BEGIN{printf "%.1f\n",('$cpu_temperature_origin'/'1000')}')

    case "$model" in
    GT-AC5300 | GT-AX11000)
        interface_2g=$(nvram get wl0_ifname)
        interface_5g1=$(nvram get wl1_ifname)
        interface_5g2=$(nvram get wl2_ifname)
        interface_2g_temperature=$(wl -i ${interface_2g} phy_tempsense | awk '{print $1}') 2>/dev/null
        interface_5g1_temperature=$(wl -i ${interface_5g1} phy_tempsense | awk '{print $1}') 2>/dev/null
        interface_5g2_temperature=$(wl -i ${interface_5g2} phy_tempsense | awk '{print $1}') 2>/dev/null
        [ -n "${interface_2g_temperature}" ] && interface_2g_temperature_c=$(expr ${interface_2g_temperature} / 2 + 20)°C || interface_2g_temperature_c="offline"
        [ -n "${interface_5g1_temperature}" ] && interface_5g1_temperature_c=$(expr ${interface_5g1_temperature} / 2 + 20)°C || interface_5g1_temperature_c="offline"
        [ -n "${interface_5g2_temperature}" ] && interface_5g2_temperature_c=$(expr ${interface_5g2_temperature} / 2 + 20)°C || interface_5g2_temperature_c="offline"
        router_temperature="2.4G: ${interface_2g_temperature_c} | 5G-1: ${interface_5g1_temperature_c} | 5G-2: ${interface_5g2_temperature_c} | CPU: ${router_cpu_temperature}°C"
        ;;
    *)
        interface_2g=$(nvram get wl0_ifname)
        interface_5g1=$(nvram get wl1_ifname)
        interface_2g_temperature=$(wl -i ${interface_2g} phy_tempsense | awk '{print $1}') 2>/dev/null
        interface_5g1_temperature=$(wl -i ${interface_5g1} phy_tempsense | awk '{print $1}') 2>/dev/null
        [ -n "${interface_2g_temperature}" ] && interface_2g_temperature_c=$(expr ${interface_2g_temperature} / 2 + 20)°C || interface_2g_temperature_c="offline"
        [ -n "${interface_5g1_temperature}" ] && interface_5g1_temperature_c=$(expr ${interface_5g1_temperature} / 2 + 20)°C || interface_5g1_temperature_c="offline"
        #router_temperature="2.4G：${interface_2g_temperature_c} &nbsp;&nbsp;|&nbsp;&nbsp; 5G-1：${interface_5g1_temperature_c} &nbsp;&nbsp;|&nbsp;&nbsp; CPU: ${router_cpu_temperature}°C"
        router_temperature="2.4GHz: ${interface_2g_temperature_c} | 5GHz: ${interface_5g1_temperature_c} | CPU: ${router_cpu_temperature}°C"
        ;;
    esac

    echo "#### **温度传感器状况:**" >>${serverchan_info_text}
    echo "##### ${router_temperature}" >>${serverchan_info_text}
fi
# 网络运行状态
if [[ "${serverchan_info_wan}" == "1" ]]; then
    echo "---" >>${serverchan_info_text}
    # 网络信息
    router_wan0_proto=$(nvram get wan0_proto)
    router_wan0_ifname=$(nvram get wan0_ifname)
    router_wan0_gw=$(nvram get wan0_gw_ifname)
    router_wan0_ip=$(nvram get wan0_ipaddr)
    if [[ "${serverchan_info_pub}" == "1" ]]; then
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

    echo "#### **网络状态信息:**" >>${serverchan_info_text}
    echo "##### **WAN0状态信息:**" >>${serverchan_info_text}
    echo "##### 联机类型: ${router_wan0_proto}" >>${serverchan_info_text}
    echo "##### 公网IPv4地址: ${router_wan0_ip4}" >>${serverchan_info_text}
    echo "##### 公网IPv6地址: ${router_wan0_ip6}" >>${serverchan_info_text}
    echo "##### WAN口IPv4地址: ${router_wan0_ip}" >>${serverchan_info_text}
    echo "##### WAN口DNS地址: ${router_wan0_dns1} ${router_wan0_dns2}" >>${serverchan_info_text}
    echo "##### WAN口接收流量: ${router_wan0_rx}" >>${serverchan_info_text}
    echo "##### WAN口发送流量: ${router_wan0_tx}" >>${serverchan_info_text}
    echo "---" >>${serverchan_info_text}
    router_wan1_ifname=$(nvram get wan1_ifname)
    router_wan1_gw=$(nvram get wan1_gw_ifname)
    if [ -n "${router_wan1_ifname}" ] && [ -n "${router_wan1_gw}" ]; then
        router_wan1_proto=$(nvram get wan1_proto)
        router_wan1_ip=$(nvram get wan1_ipaddr)
        if [[ "${serverchan_info_pub}" == "1" ]]; then
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
        echo "##### **WAN1状态信息:**" >>${serverchan_info_text}
        echo "##### 联机类型: ${router_wan1_proto}" >>${serverchan_info_text}
        echo "##### 公网IPv4地址: ${router_wan1_ip4}" >>${serverchan_info_text}
        echo "##### 公网IPv6地址: ${router_wan1_ip6}" >>${serverchan_info_text}
        echo "##### WAN口IPv4地址: ${router_wan1_ip}" >>${serverchan_info_text}
        echo "##### WAN口DNS地址: ${router_wan1_dns1} ${router_wan1_dns2}" >>${serverchan_info_text}
        echo "##### WAN口接收流量: ${router_wan1_rx}" >>${serverchan_info_text}
        echo "##### WAN口发送流量: ${router_wan1_tx}" >>${serverchan_info_text}
        echo "---" >>${serverchan_info_text}
    fi
    # ddns状态
    ddns_enable=$(nvram get ddns_enable_x)
    if [[ "${serverchan_info_wan}" == "1" ]]; then
        echo "##### **DDNS状态信息:**" >>${serverchan_info_text}
        echo "##### DDNS域名: $(nvram get ddns_hostname_x)" >>${serverchan_info_text}
        echo "---" >>${serverchan_info_text}
    fi
    # ss状态
    net_check_time=$(date "+%Y-%m-%d %H:%M:%S")
    get_china_status1() {
        wget -4 --spider --quiet --tries=2 --timeout=2 www.baidu.com
        if [ "$?" == "0" ]; then
            echo '##### 国内链接 【'${net_check_time}'】 √' >>${serverchan_info_text}
        else
            echo '##### 国内链接 【'${net_check_time}'】 ×' >>${serverchan_info_text}
        fi
    }

    get_foreign_status1() {
        wget -4 --spider --quiet --tries=2 --timeout=2 www.google.com.tw
        if [ "$?" == "0" ]; then
            echo '##### 国外链接 【'${net_check_time}'】 √' >>${serverchan_info_text}
        else
            echo '##### 国外链接 【'${net_check_time}'】 ×' >>${serverchan_info_text}
        fi
    }

    get_china_status() {
        local ret=$(httping www.baidu.com -s -Z -c1 -f -t 3 2>/dev/null | sed -n '2p' | sed 's/seq=0//g' | sed 's/([0-9]\+\sbytes),\s//g')
        local S1=$(echo $ret | grep -Eo "200 OK")
        if [ -n "$S1" ]; then
            local S2=$(echo $ret | sed 's/time=//g' | awk '{printf "%.0f ms\n",$(NF -3)}')
            echo '##### 国内链接 【'${net_check_time}'】 ✓%26nbsp;%26nbsp;'$S2'' >>${serverchan_info_text}
        else
            echo '##### 国内链接 【'${net_check_time}'】 X' >>${serverchan_info_text}
        fi
    }

    get_foreign_status() {
        local ret=$(httping www.google.com.tw -s -Z -c1 -f -t 3 2>/dev/null | sed -n '2p' | sed 's/seq=0//g' | sed 's/([0-9]\+\sbytes),\s//g')
        local S1=$(echo $ret | grep -Eo "200 OK")
        if [ -n "$S1" ]; then
            local S2=$(echo $ret | sed 's/time=//g' | awk '{printf "%.0f ms\n",$(NF -3)}')
            echo '##### 国外链接 【'${net_check_time}'】 ✓%26nbsp;%26nbsp;'$S2'' >>${serverchan_info_text}
        else
            echo '##### 国外链接 【'${net_check_time}'】 X' >>${serverchan_info_text}
        fi
    }

    ss_status=$(dbus get ss_basic_enable)
    if [[ "${ss_status}" == "1" ]]; then
        echo "##### **网络连接信息:**" >>${serverchan_info_text}
        get_china_status >>${serverchan_info_text}
        get_foreign_status >>${serverchan_info_text}
        echo "---" >>${serverchan_info_text}
    fi
    router_lan_ip=$(nvram get lan_ipaddr_rt)
    echo "##### 路由器管理地址: ${router_lan_ip}" >>${serverchan_info_text}
    echo "---" >>${serverchan_info_text}
    router_smart_connect=$(nvram get smart_connect_x)
    wl_list_title="|无线网络%26nbsp;%26nbsp;%26nbsp;%26nbsp;%26nbsp;%26nbsp;%26nbsp;%26nbsp;|SSID|"
    wl_list_tab="|:-|:-|"
    echo "${wl_list_title}" >>${serverchan_info_text}
    echo "${wl_list_tab}" >>${serverchan_info_text}
    if [[ "${router_smart_connect}" == "1" ]]; then
        router_ssid=$(nvram get wl_ssid)
        [ -n "${router_ssid}" ] && echo "|SmartConnect%26nbsp;%26nbsp;%26nbsp;%26nbsp;|${router_ssid}|" >>${serverchan_info_text}
    else
        if [[ "$(nvram get wl0_bss_enabled)" == "1" ]]; then
            router_wl0_ssid=$(nvram get wl0_ssid)
            [ -n "${router_wl0_ssid}" ] && echo "|2.4G%26nbsp;%26nbsp;%26nbsp;%26nbsp;|${router_wl0_ssid}|" >>${serverchan_info_text}
        fi
        if [[ "$(nvram get wl1_bss_enabled)" == "1" ]]; then
            router_wl1_ssid=$(nvram get wl1_ssid)
            [ -n "${router_wl0_ssid}" ] && echo "|5G-1%26nbsp;%26nbsp;%26nbsp;%26nbsp;|${router_wl1_ssid}|" >>${serverchan_info_text}
        fi
        if [[ "$(nvram get wl2_bss_enabled)" == "1" ]]; then
            router_wl2_ssid=$(nvram get wl2_ssid)
            [ -n "${router_wl0_ssid}" ] && echo "|5G-2%26nbsp;%26nbsp;%26nbsp;%26nbsp;|${router_wl2_ssid}|" >>${serverchan_info_text}
        fi
        #router_ssid=`echo ${router_wl0_ssid} ${router_wl1_ssid} ${router_wl2_ssid}`
    fi
    echo "---" >>${serverchan_info_text}
    wlg_list_title="|访客网络%26nbsp;%26nbsp;%26nbsp;%26nbsp;%26nbsp;%26nbsp;%26nbsp;%26nbsp;|SSID|"
    wlg_list_tab="|:-|:-|"
    echo "${wlg_list_title}" >>${serverchan_info_text}
    echo "${wlg_list_tab}" >>${serverchan_info_text}
    wlg_lists="0.1 0.2 0.3 1.1 1.2 1.3 2.1 2.2 2.3"
    for wlg_status in ${wlg_lists}; do
        if [[ "$(nvram get wl${wlg_status}_bss_enabled)" == "1" ]]; then
            [ "${wlg_status}" == "0.1" ] && wlg_name="2.4G-1"
            [ "${wlg_status}" == "0.2" ] && wlg_name="2.4G-2"
            [ "${wlg_status}" == "0.3" ] && wlg_name="2.4G-3"
            [ "${wlg_status}" == "1.1" ] && wlg_name="5G-1-1"
            [ "${wlg_status}" == "1.2" ] && wlg_name="5G-1-2"
            [ "${wlg_status}" == "1.3" ] && wlg_name="5G-1-3"
            [ "${wlg_status}" == "2.1" ] && wlg_name="5G-2-1"
            [ "${wlg_status}" == "2.2" ] && wlg_name="5G-2-2"
            [ "${wlg_status}" == "2.3" ] && wlg_name="5G-2-3"
            echo "|${wlg_name}%26nbsp;%26nbsp;%26nbsp;%26nbsp;|$(nvram get wl${wlg_status}_ssid)|" >>${serverchan_info_text}
            wlg_en="true"
        fi
    done
    if [[ "${wlg_en}" != "true" ]]; then
        echo "|无访客网络||" >>${serverchan_info_text}
    fi
    #echo "##### SSID: ${router_ssid}" >> ${serverchan_info_text}
fi
# USB设备列表
if [[ "${serverchan_info_usb}" == "1" ]]; then
    echo "---" >>${serverchan_info_text}
    echo "#### **USB设备列表:**" >>${serverchan_info_text}
    usb1_fs_path=$(nvram get usb_path1_fs_path0)
    if [ -n "${usb1_fs_path}" ]; then
        usb1_product=$(echo $(nvram get usb_path1_manufacturer) $(nvram get usb_path1_product))
        usb1_removed=$(nvram get usb_path1_removed)
        usb1_total=$(df -h | grep "${usb1_fs_path}" | awk '{print $2}')
        usb1_used=$(df -h | grep "${usb1_fs_path}" | awk '{print $3}')
        usb1_available=$(df -h | grep "${usb1_fs_path}" | awk '{print $4}')
        [ "${usb1_removed}" == "1" ] && usb1_status="已移除" || usb1_status="已挂载"
        echo "##### USB1名称: ${usb1_product}(${usb1_status})" >>${serverchan_info_text}
        echo "##### USB1容量: ${usb1_used} / ${usb1_total}" >>${serverchan_info_text}
        echo "##### USB1可用容量：${usb1_available}" >>${serverchan_info_text}
    else
        echo "##### USB1接口下无设备" >>${serverchan_info_text}
    fi
    echo "---" >>${serverchan_info_text}
    usb2_fs_path=$(nvram get usb_path2_fs_path0)
    if [ -n "${usb2_fs_path}" ]; then
        usb2_product=$(echo $(nvram get usb_path2_manufacturer) $(nvram get usb_path2_product))
        usb2_removed=$(nvram get usb_path2_removed)
        usb2_total=$(df -h | grep "${usb2_fs_path}" | awk '{print $2}')
        usb2_used=$(df -h | grep "${usb2_fs_path}" | awk '{print $3}')
        usb2_available=$(df -h | grep "${usb2_fs_path}" | awk '{print $4}')
        [ "${usb2_removed}" == "1" ] && usb2_status="已移除" || usb2_status="已挂载"
        echo "##### USB2名称: ${usb2_product}(${usb2_status})" >>${serverchan_info_text}
        echo "##### USB2容量: ${usb2_used} / ${usb2_total}" >>${serverchan_info_text}
        echo "##### USB2可用容量：${usb2_available}" >>${serverchan_info_text}
    else
        echo "##### USB2接口下无设备" >>${serverchan_info_text}
    fi
fi
# 客户端列表
if [[ "${serverchan_info_lan}" == "1" ]]; then
    echo "---" >>${serverchan_info_text}
    echo "#### **客户端列表:**" >>${serverchan_info_text}
    arp_list=$(arp | grep "br0" | grep -v "incomplete" | sed 's/ (/\t/g' | sed 's/) at /\t/' | sed 's/\[ether\]/ /g' | cut -d " " -f1 | sort -t "." -k3n,3 -k4n,4)
    #echo "${arp_list}" >${arp_file}
    if [ -n "${arp_list}" ]; then
        if [ "$serverchan_info_lan_macoff" == "1" ]; then
            arp_list_title="|IP|客户端名称|"
            arp_list_tab="|:-|:-|"
        else
            arp_list_title="|IP|MAC|客户端名称|"
            arp_list_tab="|:-|:-|:-|"
        fi
        echo "${arp_list_title}" >>${serverchan_info_text}
        echo "${arp_list_tab}" >>${serverchan_info_text}
        arp_num=0
        echo "${arp_list}" | while read line; do
            arp_client_mac=$(echo ${line} | awk '{print $3}')
            arp_dhcp_white_name=$(echo $(dbus get serverchan_trigger_dhcp_white | base64_decode | grep -i "${arp_client_mac}") | cut -d# -f2)
            if [[ "${arp_dhcp_white_name}" == "" ]]; then
                arp_custom_clientlist=$(echo $(nvram get custom_clientlist | sed 's/</\n/g' | awk -F ">" '{print $1"##"$2}' | sed '/^##*$/d' | grep -i "${arp_client_mac}"))
                if [[ "${arp_custom_clientlist}" == "" ]]; then
                    if [ "$serverchan_info_lan_macoff" == "1" ]; then
                        echo ${line} | awk '{print "|"$2"%26nbsp;%26nbsp;|"$1"|"}' >>${serverchan_info_text}
                    else
                        echo ${line} | awk '{print "|"$2"%26nbsp;%26nbsp;|"$3"%26nbsp;%26nbsp;|"$1"|"}' >>${serverchan_info_text}
                    fi
                else
                    arp_lease_name=$(echo ${arp_custom_clientlist} | awk -F "##" '{print $1}')
                    if [ "$serverchan_info_lan_macoff" == "1" ]; then
                        echo $(echo "${line}" | awk '{print "|"$2"%26nbsp;%26nbsp;|"}')"${arp_lease_name}|" >>${serverchan_info_text}
                    else
                        echo $(echo "${line}" | awk '{print "|"$2"%26nbsp;%26nbsp;|"$3"%26nbsp;%26nbsp;|"}')"${arp_lease_name}|" >>${serverchan_info_text}
                    fi
                fi
            else
                if [ "$serverchan_info_lan_macoff" == "1" ]; then
                    echo $(echo "${line}" | awk '{print "|"$2"%26nbsp;%26nbsp;|"}')"${arp_dhcp_white_name}|" >>${serverchan_info_text}
                else
                    echo $(echo "${line}" | awk '{print "|"$2"%26nbsp;%26nbsp;|"$3"%26nbsp;%26nbsp;|"}')"${arp_dhcp_white_name}|" >>${serverchan_info_text}
                fi
            fi
            let arp_num=arp_num+1
        done
    else
        echo "##### 路由器下没有找到在线客户端" >>${serverchan_info_text}
    fi
fi
# DHCP租期列表
if [[ "${serverchan_info_dhcp}" == "1" ]]; then
    total_lease_client=$(cat ${dnsmasq_leases_file} | wc -l)
    echo "---" >>${serverchan_info_text}
    echo "##### 现在租约期内的客户端共有 ${total_lease_client} 个,情况如下：" >>${serverchan_info_text}
    if [ "$serverchan_info_dhcp_macoff" == "1" ]; then
        total_lease_info_title="|IP|客户端名称|"
        total_lease_info_tab="|:-|:-|"
    else
        total_lease_info_title="|IP|MAC|客户端名称|"
        total_lease_info_tab="|:-|:-|:-|"
    fi
    echo "${total_lease_info_title}" >>${serverchan_info_text}
    echo "${total_lease_info_tab}" >>${serverchan_info_text}
    dnsmasq_leases_list=$(cat ${dnsmasq_leases_file} | sort -t "." -k3n,3 -k4n,4)
    num=0
    echo "${dnsmasq_leases_list}" | while read line; do
        dhcp_client_mac=$(echo ${line} | awk '{print $2}')
        trigger_dhcp_white_name=$(echo $(dbus get serverchan_trigger_dhcp_white | base64_decode | grep -i "${dhcp_client_mac}") | cut -d# -f2)
        if [[ "${trigger_dhcp_white_name}" == "" ]]; then
            dhcp_custom_clientlist=$(echo $(nvram get custom_clientlist | sed 's/</\n/g' | awk -F ">" '{print $1"##"$2}' | sed '/^##*$/d' | grep -i "${dhcp_client_mac}"))
            if [[ "${dhcp_custom_clientlist}" == "" ]]; then
                if [ "$serverchan_info_dhcp_macoff" == "1" ]; then
                    echo ${line} | awk '{print "|"$3"%26nbsp;%26nbsp;|"$4"|"}' >>${serverchan_info_text}
                else
                    echo ${line} | awk '{print "|"$3"%26nbsp;%26nbsp;|"$2"%26nbsp;%26nbsp;|"$4"|"}' >>${serverchan_info_text}
                fi
            else
                dhcp_lease_name=$(echo ${dhcp_custom_clientlist} | awk -F "##" '{print $1}')
                if [ "$serverchan_info_dhcp_macoff" == "1" ]; then
                    echo $(echo "${line}" | awk '{print "|"$3"%26nbsp;%26nbsp;|"}')"${dhcp_lease_name}|" >>${serverchan_info_text}
                else
                    echo $(echo "${line}" | awk '{print "|"$3"%26nbsp;%26nbsp;|"$2"%26nbsp;%26nbsp;|"}')"${dhcp_lease_name}|" >>${serverchan_info_text}
                fi
            fi
        else
            if [ "$serverchan_info_dhcp_macoff" == "1" ]; then
                echo $(echo "${line}" | awk '{print "|"$3"%26nbsp;%26nbsp;|"}')"${trigger_dhcp_white_name}|" >>${serverchan_info_text}
            else
                echo $(echo "${line}" | awk '{print "|"$3"%26nbsp;%26nbsp;|"$2"%26nbsp;%26nbsp;|"}')"${trigger_dhcp_white_name}|" >>${serverchan_info_text}
            fi
        fi
        let num=num+1
    done
fi
# 软件中心状态
if [[ "${serverchan_info_softcenter}" == "1" ]]; then
    # 软件中心
    echo "---" >>${serverchan_info_text}
    echo "#### **软件中心状态:**" >>${serverchan_info_text}
    soft_lists=$(dbus list softcenter | grep "version" | grep "softcenter_module_" | cut -d "_" -f3)
    soft_lists_nu=$(dbus list softcenter | grep "version" | grep "softcenter_module_" | cut -d "_" -f3 | wc -l)
    echo "##### 检测到您共安装了 ${soft_lists_nu} 个插件" >>${serverchan_info_text}
    rm -rf ${app_file}
    wget --no-check-certificate --quiet ${softcenter_app_url} -O ${app_file}
    if [ "$?" != "0" ]; then
        echo "本次检测软件中心更新状态失败。" >>${serverchan_info_text}
    else
        update=0
        softcenter_local_version=$(dbus get softcenter_version)
        softcenter_online_version=$(cat ${app_file} | jq .version | sed 's/"//g')
        COMP_SOFT=$(versioncmp ${softcenter_local_version} ${softcenter_online_version})
        if [ "${COMP_SOFT}" == "1" ]; then
            echo "##### 软件中心有新版本了，最新版本: ${softcenter_online_version}" >>${serverchan_info_text}
            let update+=1
        fi
        #check software update
        app_nu_online=$(cat ${app_file} | jq '.apps|length')
        for app in ${soft_lists}; do
            i=0
            until [ "${i}" == "${app_nu_online}" ]; do
                i=$(($i + 1))
                soft_match=$(cat ${app_file} | jq .apps[${i}] | grep -w "${app}")
                if [ -n "$soft_match" ]; then
                    app_local_version=$(dbus get softcenter_module_${app}_version)
                    app_oneline_version=$(cat ${app_file} | jq .apps[${i}].version | sed 's/"//g')
                    COMP_APP=$(versioncmp ${app_local_version} ${app_oneline_version})
                    if [ "${COMP_APP}" == "1" ]; then
                        echo "##### 插件 ${app} 有新版本了，最新版本: ${app_oneline_version}" >>${serverchan_info_text}
                        let update+=1
                    fi
                else
                    continue
                fi
            done
        done
        #show update message
        if [ "${update}" == "0" ]; then
            echo "##### 检测到所有插件均为最新版本！" >>${serverchan_info_text}
        else
            echo "##### 快登录路由器进入软件中心更新吧！" >>${serverchan_info_text}
        fi
    fi
fi
serverchan_send_title="${send_title} 路由器状态信息"
serverchan_send_content=$(cat ${serverchan_info_text})
sckey_nu=$(dbus list serverchan_config_sckey | sort -n -t "_" -k 4 | cut -d "=" -f 1 | cut -d "_" -f 4)
for nu in ${sckey_nu}; do
    serverchan_config_sckey=$(dbus get serverchan_config_sckey_${nu})
    url="https://sc.ftqq.com/${serverchan_config_sckey}.send"
    result=$(wget --no-check-certificate --post-data "text=${serverchan_send_title}&desp=${serverchan_send_content}" -qO- ${url})
    if [ -n $(echo $result | grep "success") ]; then
        [ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 路由器状态信息推送到 SCKEY No.${nu} 成功！"
    else
        [ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 路由器状态信息推送到 SCKEY No.${nu} 失败，请检查网络及配置！"
    fi
done
