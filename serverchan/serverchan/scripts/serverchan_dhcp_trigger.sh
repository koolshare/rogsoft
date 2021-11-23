#!/bin/sh

set -x
source /koolshare/scripts/base.sh
eval $(dbus export serverchan_)
if [ "${serverchan_config_ntp}" == "" ]; then
    ntp_server="ntp1.aliyun.com"
else
    ntp_server=${serverchan_config_ntp}
fi
ntpclient -h ${ntp_server} -i3 -l -s >/dev/null 2>&1
dnsmasq_leases_file="/var/lib/misc/dnsmasq.leases"
serverchan_lease_text="/tmp/.serverchan_dhcp.md"
dhcp_lease_time=$(nvram get dhcp_lease)
client_join_time=$(TZ=UTC-8 date "+%Y-%m-%d %H:%M:%S")
client_lease_info=$(cat ${dnsmasq_leases_file} | sort -rn | head -n1)
client_lease_time=$(echo ${client_lease_info} | awk '{print $1}')
time_diff=$(expr ${dhcp_lease_time} - ${client_lease_time})

if [ "${time_diff}" -gt "30" ]; then
    #logger "[ServerChan]: 未发现新上线设备，推送任务通道静默！"
    exit
fi
[ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 启动设备上线通知任务！"
dnsmasq_pid=$(ps | grep "dnsmasq" | grep "nobody" | grep -v grep | awk '{print $1}')
kill -12 ${dnsmasq_pid}
sleep 1
if [[ "${serverchan_enable}" != "1" ]]; then
    [ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 程序未开启，自动退出！"
    exit
fi
if [[ "${serverchan_trigger_dhcp}" != "1" ]]; then
    exit
fi
if [[ "${serverchan_silent_time}" == "1" ]]; then
    router_now_hour=$(TZ=UTC-8 date "+%H")
    if [[ "${router_now_hour}" -ge "${serverchan_silent_time_start_hour}" ]] || [[ "${router_now_hour}" -lt "${serverchan_silent_time_end_hour}" ]]; then
        [ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 推送时间在消息免打扰时间内，推送任务通道静默！"
        exit
    fi
fi
send_title=$(dbus get serverchan_config_name | base64_decode) || "本次未获取到！"
client_join_time_format=$(TZ=UTC-8 date -d "${client_join_time}" "+%Y年%m月%d日 %H点%M分%S秒")
client_lease_epired_time=$(TZ=UTC-8 date -d @$(expr $(TZ=UTC-8 date -d "${client_join_time}" +%s) + ${dhcp_lease_time}) "+%Y-%m-%d %H:%M:%S")
client_lease_epired_time_format=$(TZ=UTC-8 date -d "${client_lease_epired_time}" "+%Y年%m月%d日 %H点%M分%S秒")
total_lease_client=$(cat ${dnsmasq_leases_file} | wc -l)
client_lease_mac=$(echo ${client_lease_info} | awk '{print $2}' | tr '[A-Z]' '[a-z]')
client_lease_ip=$(echo ${client_lease_info} | awk '{print $3}')
client_dhcp_white_name=$(echo $(dbus get serverchan_trigger_dhcp_white | base64_decode | grep -i "${client_lease_mac}") | cut -d# -f2)
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
if [[ "${serverchan_dhcp_bwlist_en}" == "1" ]]; then
    if [[ "${serverchan_dhcp_white_en}" == "1" ]]; then
        trigger_dhcp_white_diff=$(echo $(dbus get serverchan_trigger_dhcp_white | base64_decode | grep -i "${client_lease_mac}"))
        if [[ "${trigger_dhcp_white_diff}" != "" ]]; then
            [ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 新登录设备在设备上线提醒白名单列表内，推送任务通道静默！"
            exit
        fi
    fi
    if [[ "${serverchan_dhcp_black_en}" == "1" ]]; then
        trigger_dhcp_black_diff=$(echo $(dbus get serverchan_trigger_dhcp_white | base64_decode | grep -i "${client_lease_mac}"))
        if [[ "${trigger_dhcp_black_diff}" == "" ]]; then
            [ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 新登录设备不在设备上线提醒黑名单列表内，推送任务通道静默！"
            exit
        fi
    fi
fi
get_lease_send_mac=$(echo $(dbus get serverchan_lease_send_mac) | tr '[A-Z]' '[a-z]')
get_lease_send_time=$(dbus get serverchan_lease_send_time)
if [[ "${get_lease_send_mac}" == "${client_lease_mac}" ]]; then
    join_time_format=$(TZ=UTC-8 date -d "${client_join_time}" +%s)
    join_time_diff=$(expr ${join_time_format} - ${get_lease_send_time})
    if [ "${join_time_diff}" -lt "600" ]; then
        [ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 重复上线，推送任务通道静默！"
        exit
    fi
fi

dbus set serverchan_lease_send_mac="${client_lease_mac}"
dbus set serverchan_lease_send_time="$(TZ=UTC-8 date -d "${client_join_time}" +%s)"
echo "##### ** 刚刚有新的客户端加入了你的网络，信息如下： **" >${serverchan_lease_text}
echo "---" >>${serverchan_lease_text}
echo "##### 客户端名: ${client_lease_name}" >>${serverchan_lease_text}
echo "##### 客户端IP: ${client_lease_ip}" >>${serverchan_lease_text}
echo "##### 客户端MAC: ${client_lease_mac}" >>${serverchan_lease_text}
echo "##### 客户端上线时间: ${client_join_time_format}" >>${serverchan_lease_text}
echo "##### 租约过期的时间: ${client_lease_epired_time_format}" >>${serverchan_lease_text}
echo "---" >>${serverchan_lease_text}
if [[ ${serverchan_trigger_dhcp_leases} == "1" ]]; then
    echo "##### 现在租约期内的客户端共有 ${total_lease_client} 个,情况如下：" >>${serverchan_lease_text}
    if [ "$serverchan_trigger_dhcp_macoff" == "1" ]; then
        total_lease_info_title="|IP|客户端名称|"
        total_lease_info_tab="|:-|:-|"
    else
        total_lease_info_title="|IP|MAC|客户端名称|"
        total_lease_info_tab="|:-|:-|:-|"
    fi
    echo "${total_lease_info_title}" >>${serverchan_lease_text}
    echo "${total_lease_info_tab}" >>${serverchan_lease_text}
    dnsmasq_leases_list=$(cat ${dnsmasq_leases_file} | sort -t "." -k3n,3 -k4n,4)
    num=0
    echo "${dnsmasq_leases_list}" | while read line; do
        dhcp_client_mac=$(echo ${line} | awk '{print $2}')
        trigger_dhcp_white_name=$(echo $(dbus get serverchan_trigger_dhcp_white | base64_decode | grep -i "${dhcp_client_mac}") | cut -d# -f2)
        if [[ "${trigger_dhcp_white_name}" == "" ]]; then
            dhcp_custom_clientlist=$(echo $(nvram get custom_clientlist | sed 's/</\n/g' | awk -F ">" '{print $1"##"$2}' | sed '/^##*$/d' | grep -i "${dhcp_client_mac}"))
            if [[ "${dhcp_custom_clientlist}" == "" ]]; then
                if [ "$serverchan_trigger_dhcp_macoff" == "1" ]; then
                    echo ${line} | awk '{print "|"$3"%26nbsp;%26nbsp;|"$4"|"}' >>${serverchan_lease_text}
                else
                    echo ${line} | awk '{print "|"$3"%26nbsp;%26nbsp;|"$2"%26nbsp;%26nbsp;|"$4"|"}' >>${serverchan_lease_text}
                fi
            else
                dhcp_lease_name=$(echo ${dhcp_custom_clientlist} | awk -F "##" '{print $1}')
                if [ "$serverchan_trigger_dhcp_macoff" == "1" ]; then
                    echo $(echo "${line}" | awk '{print "|"$3"%26nbsp;%26nbsp;|"}')"${dhcp_lease_name}|" >>${serverchan_lease_text}
                else
                    echo $(echo "${line}" | awk '{print "|"$3"%26nbsp;%26nbsp;|"$2"%26nbsp;%26nbsp;|"}')"${dhcp_lease_name}|" >>${serverchan_lease_text}
                fi
            fi
        else
            if [ "$serverchan_trigger_dhcp_macoff" == "1" ]; then
                echo $(echo "${line}" | awk '{print "|"$3"%26nbsp;%26nbsp;|"}')"${trigger_dhcp_white_name}|" >>${serverchan_lease_text}
            else
                echo $(echo "${line}" | awk '{print "|"$3"%26nbsp;%26nbsp;|"$2"%26nbsp;%26nbsp;|"}')"${trigger_dhcp_white_name}|" >>${serverchan_lease_text}
            fi
        fi
        let num=num+1
    done
    echo "---" >>${serverchan_lease_text}
fi
serverchan_send_title="${send_title} 路由器客户端上线通知："
serverchan_send_content=$(cat ${serverchan_lease_text})
sckey_nu=$(dbus list serverchan_config_sckey | sort -n -t "_" -k 4 | cut -d "=" -f 1 | cut -d "_" -f 4)
for nu in ${sckey_nu}; do
    serverchan_config_sckey=$(dbus get serverchan_config_sckey_${nu})
    url="https://sc.ftqq.com/${serverchan_config_sckey}.send"
    result=$(wget --no-check-certificate --post-data "text=${serverchan_send_title}&desp=${serverchan_send_content}" -qO- ${url})
    if [ -n $(echo $result | grep "success") ]; then
        [ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 设备上线信息推送到 SCKEY No.${nu} 成功！！"
    else
        [ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 设备上线信息推送到 SCKEY No.${nu} 失败，请检查网络及配置！"
    fi
done
sleep 2
rm -rf ${serverchan_lease_text}
