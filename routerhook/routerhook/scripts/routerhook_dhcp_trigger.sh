#!/bin/sh

set -x
source /koolshare/scripts/base.sh
eval $(dbus export routerhook_)
if [ "${serverchan_config_ntp}" == "" ]; then
    ntp_server="ntp1.aliyun.com"
else
    ntp_server=${serverchan_config_ntp}
fi
ntpclient -h ${ntp_server} -i3 -l -s >/dev/null 2>&1
dnsmasq_leases_file="/var/lib/misc/dnsmasq.leases"
routerhook_lease_text="/tmp/.routerhook_dhcp.json"
dhcp_lease_time=$(nvram get dhcp_lease)
client_join_time=$(TZ=UTC-8 date "+%Y-%m-%d %H:%M:%S")
client_lease_info=$(cat ${dnsmasq_leases_file} | sort -rn | head -n1)
client_lease_time=$(echo ${client_lease_info} | awk '{print $1}')
time_diff=$(expr ${dhcp_lease_time} - ${client_lease_time})

if [ "${time_diff}" -gt "30" ]; then
    #logger "[routerhook]: 未发现新上线设备，推送任务通道静默！"
    exit
fi
[ "${routerhook_info_logger}" == "1" ] && logger "[routerhook]: 启动设备上线通知任务！"
dnsmasq_pid=$(ps | grep "dnsmasq" | grep "nobody" | grep -v grep | awk '{print $1}')
kill -12 ${dnsmasq_pid}
sleep 1
if [[ "${routerhook_enable}" != "1" ]]; then
    [ "${routerhook_info_logger}" == "1" ] && logger "[routerhook]: 程序未开启，自动退出！"
    exit
fi
if [[ "${routerhook_trigger_dhcp}" != "1" ]]; then
    exit
fi
if [[ "${routerhook_silent_time}" == "1" ]]; then
    router_now_hour=$(TZ=UTC-8 date "+%H")
    if [[ "${router_now_hour}" -ge "${routerhook_silent_time_start_hour}" ]] || [[ "${router_now_hour}" -lt "${routerhook_silent_time_end_hour}" ]]; then
        [ "${routerhook_info_logger}" == "1" ] && logger "[routerhook]: 推送时间在消息免打扰时间内，推送任务通道静默！"
        exit
    fi
fi
client_join_time_format=$(TZ=UTC-8 date -d "${client_join_time}" "+%Y年%m月%d日 %H点%M分%S秒")
client_lease_epired_time=$(TZ=UTC-8 date -d @$(expr $(TZ=UTC-8 date -d "${client_join_time}" +%s) + ${dhcp_lease_time}) "+%Y-%m-%d %H:%M:%S")
client_lease_epired_time_format=$(TZ=UTC-8 date -d "${client_lease_epired_time}" "+%Y年%m月%d日 %H点%M分%S秒")
total_lease_client=$(cat ${dnsmasq_leases_file} | wc -l)
client_lease_mac=$(echo ${client_lease_info} | awk '{print $2}' | tr '[A-Z]' '[a-z]')
client_lease_ip=$(echo ${client_lease_info} | awk '{print $3}')
client_dhcp_white_name=$(echo $(dbus get routerhook_trigger_dhcp_white | base64_decode | grep -i "${client_lease_mac}") | cut -d# -f2)
if [[ "${client_dhcp_white_name}" == "" ]]; then
    client_custom_clientlist=$(echo $(nvram get custom_clientlist | sed 's/</\n/g' | awk -F ">" '{print $1"##"$2}' | sed '/^##*$/d' | grep -i "${client_lease_mac}"))
    if [[ "${client_custom_clientlist}" == "" ]]; then
        client_lease_name=$(echo ${client_lease_info} | awk '{print $4}')
    else
        client_lease_name=$(echo ${client_custom_clientlist} | awk -F "##" '{print $1}')
    fi
else
    client_lease_name=$(echo ${client_dhcp_white_name})
fi
if [[ "${routerhook_dhcp_bwlist_en}" == "1" ]]; then
    if [[ "${routerhook_dhcp_white_en}" == "1" ]]; then
        trigger_dhcp_white_diff=$(echo $(dbus get routerhook_trigger_dhcp_white | base64_decode | grep -i "${client_lease_mac}"))
        if [[ "${trigger_dhcp_white_diff}" != "" ]]; then
            [ "${routerhook_info_logger}" == "1" ] && logger "[routerhook]: 新登录设备在设备上线提醒白名单列表内，推送任务通道静默！"
            exit
        fi
    fi
    if [[ "${routerhook_dhcp_black_en}" == "1" ]]; then
        trigger_dhcp_black_diff=$(echo $(dbus get routerhook_trigger_dhcp_white | base64_decode | grep -i "${client_lease_mac}"))
        if [[ "${trigger_dhcp_black_diff}" == "" ]]; then
            [ "${routerhook_info_logger}" == "1" ] && logger "[routerhook]: 新登录设备不在设备上线提醒黑名单列表内，推送任务通道静默！"
            exit
        fi
    fi
fi
get_lease_send_mac=$(echo $(dbus get routerhook_lease_send_mac) | tr '[A-Z]' '[a-z]')
get_lease_send_time=$(dbus get routerhook_lease_send_time)
if [[ "${get_lease_send_mac}" == "${client_lease_mac}" ]]; then
    join_time_format=$(TZ=UTC-8 date -d "${client_join_time}" +%s)
    join_time_diff=$(expr ${join_time_format} - ${get_lease_send_time})
    if [ "${join_time_diff}" -lt "600" ]; then
        [ "${routerhook_info_logger}" == "1" ] && logger "[routerhook]: 重复上线，推送任务通道静默！"
        exit
    fi
fi

dbus set routerhook_lease_send_mac="${client_lease_mac}"
dbus set routerhook_lease_send_time="$(TZ=UTC-8 date -d "${client_join_time}" +%s)"

msg_type='newDHCP'
echo '{' >${routerhook_lease_text}
echo '"msgTYPE":"'${msg_type}'",' >>${routerhook_lease_text}
echo '"cliNAME": "'${client_lease_name}'",' >>${routerhook_lease_text}
echo '"cliIP":"'${client_lease_ip}'",' >>${routerhook_lease_text}
echo '"cliMAC":"'${client_lease_mac}'",' >>${routerhook_lease_text}
echo '"upTIME":"'${client_join_time_format}'",' >>${routerhook_lease_text}
echo '"expTIME":"'${client_lease_epired_time_format}'",' >>${routerhook_lease_text}
echo '"value1":"'${client_lease_name}'",' >>${routerhook_lease_text}
echo '"value2":"'${client_lease_ip}'",' >>${routerhook_lease_text}
echo '"value3":"'${client_lease_mac}'"' >>${routerhook_lease_text}

if [[ ${routerhook_trigger_dhcp_leases} == "1" ]]; then
    dnsmasq_leases_list=$(cat ${dnsmasq_leases_file} | sort -t "." -k3n,3 -k4n,4)
    num=0
    echo ',"cliLISTS":[' >>${routerhook_lease_text}
    echo "${dnsmasq_leases_list}" | while read line; do
        if [[ "${num}" != "0" ]]; then
            echo ',' >>${routerhook_lease_text}
        fi
        echo '{' >>${routerhook_lease_text}
        dhcp_client_mac=$(echo ${line} | awk '{print $2}')
        trigger_dhcp_white_name=$(echo $(dbus get routerhook_trigger_dhcp_white | base64_decode | grep -i "${dhcp_client_mac}") | cut -d# -f2)
        if [[ "${trigger_dhcp_white_name}" == "" ]]; then
            dhcp_custom_clientlist=$(echo $(nvram get custom_clientlist | sed 's/</\n/g' | awk -F ">" '{print $1"##"$2}' | sed '/^##*$/d' | grep -i "${dhcp_client_mac}"))
            if [[ "${dhcp_custom_clientlist}" == "" ]]; then
                if [ "$routerhook_trigger_dhcp_macoff" == "1" ]; then
                    echo ${line} | awk '{print "\"ip\":\""$3"\",\"name\":\""$4"\""}' >>${routerhook_lease_text}
                else
                    echo ${line} | awk '{print "\"ip\":\""$3"\",\"mac\":\""$2"\",\"name\":\""$4"\""}' >>${routerhook_lease_text}
                fi
            else
                dhcp_lease_name=$(echo ${dhcp_custom_clientlist} | awk -F "##" '{print $1}')
                if [ "$routerhook_trigger_dhcp_macoff" == "1" ]; then
                    echo $(echo "${line}" | awk '{print "\"ip\":\""$3"\",\"name\":"}')"\"${dhcp_lease_name}\"" >>${routerhook_lease_text}
                else
                    echo $(echo "${line}" | awk '{print "\"ip\":\""$3"\",\"mac\":\""$2"\",\"name\":"}')"\"${dhcp_lease_name}\"" >>${routerhook_lease_text}
                fi
            fi
        else
            if [ "$routerhook_trigger_dhcp_macoff" == "1" ]; then
                echo $(echo "${line}" | awk '{print "\"ip\":\""$3"\",\"name\":"}')"\"${trigger_dhcp_white_name}\"" >>${routerhook_lease_text}
            else
                echo $(echo "${line}" | awk '{print "\"ip\":\""$3"\",\"mac\":\""$2"\",\"name\":"}')"\"${trigger_dhcp_white_name}\"" >>${routerhook_lease_text}
            fi
        fi
        echo '}' >>${routerhook_lease_text}
        let num=num+1
    done
    echo "]" >>${routerhook_lease_text}
fi

echo '}' >>${routerhook_lease_text}

routerhook_send_content=$(jq -c . ${routerhook_lease_text})
source /koolshare/scripts/routerhook_sender.sh

sleep 2
rm -rf ${routerhook_lease_text}
