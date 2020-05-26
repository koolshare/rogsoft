#!/bin/sh

set -x
source /koolshare/scripts/base.sh
eval $(dbus export pushplus_)
if [ "${pushplus_config_ntp}" == "" ]; then
    ntp_server="ntp1.aliyun.com"
else
    ntp_server=${pushplus_config_ntp}
fi
ntpclient -h ${ntp_server} -i3 -l -s >/dev/null 2>&1
dnsmasq_leases_file="/var/lib/misc/dnsmasq.leases"
pushplus_lease_text="/tmp/.pushplus_dhcp.json"
dhcp_lease_time=$(nvram get dhcp_lease)
client_join_time=$(TZ=UTC-8 date "+%Y-%m-%d %H:%M:%S")
client_lease_info=$(cat ${dnsmasq_leases_file} | sort -rn | head -n1)
client_lease_time=$(echo ${client_lease_info} | awk '{print $1}')
time_diff=$(expr ${dhcp_lease_time} - ${client_lease_time})

if [ "${time_diff}" -gt "30" ]; then
    #logger "[pushplus]: 未发现新上线设备，推送任务通道静默！"
    exit
fi
[ "${pushplus_info_logger}" == "1" ] && logger "[pushplus]: 启动设备上线通知任务！"
dnsmasq_pid=$(ps | grep "dnsmasq" | grep "nobody" | grep -v grep | awk '{print $1}')
kill -12 ${dnsmasq_pid}
sleep 1
if [[ "${pushplus_enable}" != "1" ]]; then
    [ "${pushplus_info_logger}" == "1" ] && logger "[pushplus]: 程序未开启，自动退出！"
    exit
fi
if [[ "${pushplus_trigger_dhcp}" != "1" ]]; then
    exit
fi
if [[ "${pushplus_silent_time}" == "1" ]]; then
    router_now_hour=$(TZ=UTC-8 date "+%H")
    if [[ "${router_now_hour}" -ge "${pushplus_silent_time_start_hour}" ]] || [[ "${router_now_hour}" -lt "${pushplus_silent_time_end_hour}" ]]; then
        [ "${pushplus_info_logger}" == "1" ] && logger "[pushplus]: 推送时间在消息免打扰时间内，推送任务通道静默！"
        exit
    fi
fi
send_title=$(dbus get pushplus_config_name | base64_decode) || "本次未获取到！"
client_join_time_format=$(TZ=UTC-8 date -d "${client_join_time}" "+%Y年%m月%d日 %H点%M分%S秒")
client_lease_epired_time=$(TZ=UTC-8 date -d @$(expr $(TZ=UTC-8 date -d "${client_join_time}" +%s) + ${dhcp_lease_time}) "+%Y-%m-%d %H:%M:%S")
client_lease_epired_time_format=$(TZ=UTC-8 date -d "${client_lease_epired_time}" "+%Y年%m月%d日 %H点%M分%S秒")
total_lease_client=$(cat ${dnsmasq_leases_file} | wc -l)
client_lease_mac=$(echo ${client_lease_info} | awk '{print $2}' | tr '[A-Z]' '[a-z]')
client_lease_ip=$(echo ${client_lease_info} | awk '{print $3}')
client_dhcp_white_name=$(echo $(dbus get pushplus_trigger_dhcp_white | base64_decode | grep -i "${client_lease_mac}") | cut -d# -f2)
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
if [[ "${pushplus_dhcp_bwlist_en}" == "1" ]]; then
    if [[ "${pushplus_dhcp_white_en}" == "1" ]]; then
        trigger_dhcp_white_diff=$(echo $(dbus get pushplus_trigger_dhcp_white | base64_decode | grep -i "${client_lease_mac}"))
        if [[ "${trigger_dhcp_white_diff}" != "" ]]; then
            [ "${pushplus_info_logger}" == "1" ] && logger "[pushplus]: 新登录设备在设备上线提醒白名单列表内，推送任务通道静默！"
            exit
        fi
    fi
    if [[ "${pushplus_dhcp_black_en}" == "1" ]]; then
        trigger_dhcp_black_diff=$(echo $(dbus get pushplus_trigger_dhcp_white | base64_decode | grep -i "${client_lease_mac}"))
        if [[ "${trigger_dhcp_black_diff}" == "" ]]; then
            [ "${pushplus_info_logger}" == "1" ] && logger "[pushplus]: 新登录设备不在设备上线提醒黑名单列表内，推送任务通道静默！"
            exit
        fi
    fi
fi
get_lease_send_mac=$(echo $(dbus get pushplus_lease_send_mac) | tr '[A-Z]' '[a-z]')
get_lease_send_time=$(dbus get pushplus_lease_send_time)
if [[ "${get_lease_send_mac}" == "${client_lease_mac}" ]]; then
    join_time_format=$(TZ=UTC-8 date -d "${client_join_time}" +%s)
    join_time_diff=$(expr ${join_time_format} - ${get_lease_send_time})
    if [ "${join_time_diff}" -lt "600" ]; then
        [ "${pushplus_info_logger}" == "1" ] && logger "[pushplus]: 重复上线，推送任务通道静默！"
        exit
    fi
fi

dbus set pushplus_lease_send_mac="${client_lease_mac}"
dbus set pushplus_lease_send_time="$(TZ=UTC-8 date -d "${client_join_time}" +%s)"

msg_type='newDHCP'
echo '{' >${pushplus_lease_text}
echo '"msgTYPE":"'${msg_type}'",' >>${pushplus_lease_text}
echo '"cliNAME": "'${client_lease_name}'",' >>${pushplus_lease_text}
echo '"cliIP":"'${client_lease_ip}'",' >>${pushplus_lease_text}
echo '"cliMAC":"'${client_lease_mac}'",' >>${pushplus_lease_text}
echo '"upTIME":"'${client_join_time_format}'",' >>${pushplus_lease_text}
echo '"expTIME":"'${client_lease_epired_time_format}'"' >>${pushplus_lease_text}

if [[ ${pushplus_trigger_dhcp_leases} == "1" ]]; then
    dnsmasq_leases_list=$(cat ${dnsmasq_leases_file} | sort -t "." -k3n,3 -k4n,4)
    num=0
    echo ',"cliLISTS":[' >>${pushplus_lease_text}
    echo "${dnsmasq_leases_list}" | while read line; do
        if [[ "${num}" != "0" ]]; then
            echo ',' >>${pushplus_lease_text}
        fi
        echo '{' >>${pushplus_lease_text}
        dhcp_client_mac=$(echo ${line} | awk '{print $2}')
        trigger_dhcp_white_name=$(echo $(dbus get pushplus_trigger_dhcp_white | base64_decode | grep -i "${dhcp_client_mac}") | cut -d# -f2)
        if [[ "${trigger_dhcp_white_name}" == "" ]]; then
            dhcp_custom_clientlist=$(echo $(nvram get custom_clientlist | sed 's/</\n/g' | awk -F ">" '{print $1"##"$2}' | sed '/^##*$/d' | grep -i "${dhcp_client_mac}"))
            if [[ "${dhcp_custom_clientlist}" == "" ]]; then
                if [ "$pushplus_trigger_dhcp_macoff" == "1" ]; then
                    echo ${line} | awk '{print "\"ip\":\""$3"\",\"name\":\""$4"\""}' >>${pushplus_lease_text}
                else
                    echo ${line} | awk '{print "\"ip\":\""$3"\",\"mac\":\""$2"\",\"name\":\""$4"\""}' >>${pushplus_lease_text}
                fi
            else
                dhcp_lease_name=$(echo ${dhcp_custom_clientlist} | awk -F "##" '{print $1}')
                if [ "$pushplus_trigger_dhcp_macoff" == "1" ]; then
                    echo $(echo "${line}" | awk '{print "\"ip\":\""$3"\",\"name\":"}')"\"${dhcp_lease_name}\"" >>${pushplus_lease_text}
                else
                    echo $(echo "${line}" | awk '{print "\"ip\":\""$3"\",\"mac\":\""$2"\",\"name\":"}')"\"${dhcp_lease_name}\"" >>${pushplus_lease_text}
                fi
            fi
        else
            if [ "$pushplus_trigger_dhcp_macoff" == "1" ]; then
                echo $(echo "${line}" | awk '{print "\"ip\":\""$3"\",\"name\":"}')"\"${trigger_dhcp_white_name}\"" >>${pushplus_lease_text}
            else
                echo $(echo "${line}" | awk '{print "\"ip\":\""$3"\",\"mac\":\""$2"\",\"name\":"}')"\"${trigger_dhcp_white_name}\"" >>${pushplus_lease_text}
            fi
        fi
        echo '}' >>${pushplus_lease_text}
        let num=num+1
    done
    echo "]" >>${pushplus_lease_text}
fi

echo '}' >>${pushplus_lease_text}

pushplus_send_title="${send_title} 客户端上线通知："
pushplus_send_content=$(jq -c . ${pushplus_lease_text})

token_nu=$(dbus list pushplus_config_token | sort -n -t "_" -k 4 | cut -d "=" -f 1 | cut -d "_" -f 4)
for nu in ${token_nu}; do
    pushplus_config_token=$(dbus get pushplus_config_token_${nu})
    pushplus_config_topic=$(dbus get pushplus_config_topic_${nu})
    # pushplus_config_channel=`dbus get pushplus_config_channel_${nu}`
    pushplus_config_channel="wechat"
    url="https://pushplus.hxtrip.com/send/${pushplus_config_token}"
    reqstr="curl -H \"content-type:application/json\" -X POST -d '{\"template\":\"route\",\"topic\":\""${pushplus_config_topic}"\",\"channel\":\""${pushplus_config_channel}"\",\"title\":\""${pushplus_send_title}"\",\"content\":"${pushplus_send_content}"}' ${url}"
    result=$(eval ${reqstr})
    if [[ -n "$(echo $result | grep "success")" ]]; then
        [ "${pushplus_info_logger}" == "1" ] && logger "[pushplus]: 网络重启信息推送到 TOKEN No.${nu} 成功！！"
    else
        [ "${pushplus_info_logger}" == "1" ] && logger "[pushplus]: 网络重启信息推送到 TOKEN No.${nu} 失败，请检查网络及配置！"
    fi
done

sleep 2
rm -rf ${pushplus_lease_text}
