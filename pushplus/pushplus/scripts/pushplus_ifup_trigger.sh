#!/bin/sh
source /koolshare/scripts/base.sh
eval $(dbus export pushplus_)
if [ "${pushplus_config_ntp}" == "" ]; then
    ntp_server="ntp1.aliyun.com"
else
    ntp_server=${pushplus_config_ntp}
fi
ntpclient -h ${ntp_server} -i3 -l -s >/dev/null 2>&1
[ "${pushplus_info_logger}" == "1" ] && logger "[pushplus]: 网络重启触发消息推送！"

if [[ "${pushplus_enable}" != "1" ]]; then
    [ "${pushplus_info_logger}" == "1" ] && logger "[pushplus]: 程序未开启，自动退出！"
    exit
fi
if [[ ${pushplus_trigger_ifup} != "1" ]]; then
    exit
fi
pushplus_ifup_text="/tmp/.pushplus_ifup.json"
send_title=$(dbus get pushplus_config_name | base64_decode) || "本次未获取到！"
router_uptime=$(cat /proc/uptime | awk '{print $1}' | awk '{print int($1/86400)"天 "int($1%86400/3600)"小时 "int(($1%3600)/60)"分钟 "int($1%60)"秒"}')
router_reboot_time=$(echo $(TZ=UTC-8 date "+%Y年%m月%d日 %H点%M分%S秒"))

msg_type='ifUP'
echo '{' >${pushplus_ifup_text}
echo '"msgTYPE":"'${msg_type}'",' >>${pushplus_ifup_text}
echo '"upTIME":"'${router_uptime}'",' >>${pushplus_ifup_text}
echo '"rebootTIME":"'${router_reboot_time}'",' >>${pushplus_ifup_text}

router_wan0_proto=$(nvram get wan0_proto)
router_wan0_ifname=$(nvram get wan0_ifname)
router_wan0_gw=$(nvram get wan0_gw_ifname)
router_wan0_ip=$(nvram get wan0_ipaddr)
if [[ "${pushplus_info_pub}" == "1" ]]; then
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

echo '"netSTATE":[' >>${pushplus_ifup_text}
echo '{' >>${pushplus_ifup_text}
echo '"proto":"'${router_wan0_proto}'",' >>${pushplus_ifup_text}
echo '"pubIPv4":"'${router_wan0_ip4}'",' >>${pushplus_ifup_text}
echo '"pubIPv6":"'${router_wan0_ip6}'",' >>${pushplus_ifup_text}
echo '"wanIPv4":"'${router_wan0_ip}'",' >>${pushplus_ifup_text}
echo '"wanDNS": ["'${router_wan0_dns1}'","'${router_wan0_dns2}'"],' >>${pushplus_ifup_text}
echo '"wanRX":"'${router_wan0_rx}'",' >>${pushplus_ifup_text}
echo '"wanTX":"'${router_wan0_tx}'"' >>${pushplus_ifup_text}
echo '}' >>${pushplus_ifup_text}

router_wan1_ifname=$(nvram get wan1_ifname)
router_wan1_gw=$(nvram get wan1_gw_ifname)
if [ -n "${router_wan1_ifname}" ] && [ -n "${router_wan1_gw}" ]; then
    router_wan1_proto=$(nvram get wan1_proto)
    router_wan1_ip=$(nvram get wan1_ipaddr)
    if [[ "${pushplus_info_pub}" == "1" ]]; then
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

    echo ',{' >>${pushplus_ifup_text}
    echo '"proto":"'${router_wan1_proto}'",' >>${pushplus_ifup_text}
    echo '"pubIPv4":"'${router_wan1_ip4}'",' >>${pushplus_ifup_text}
    echo '"pubIPv6":"'${router_wan1_ip6}'",' >>${pushplus_ifup_text}
    echo '"wanIPv4":"'${router_wan1_ip}'",' >>${pushplus_ifup_text}
    echo '"wanDNS": ["'${router_wan1_dns1}'","'${router_wan1_dns2}'"],' >>${pushplus_ifup_text}
    echo '"wanRX":"'${router_wan1_rx}'",' >>${pushplus_ifup_text}
    echo '"wanTX":"'${router_wan1_tx}'"' >>${pushplus_ifup_text}
    echo '}' >>${pushplus_ifup_text}
fi
echo ']' >>${pushplus_ifup_text}
echo '}' >>${pushplus_ifup_text}

pushplus_send_title="${send_title} 网络重启通知："
pushplus_send_content=$(jq -c . ${pushplus_ifup_text})

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
rm -rf ${pushplus_ifup_text}
if [[ "${pushplus_trigger_ifup_sendinfo}" == "1" ]]; then
    sh /koolshare/scripts/pushplus_check_task.sh
fi
