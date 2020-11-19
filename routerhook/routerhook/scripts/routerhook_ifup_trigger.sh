#!/bin/sh

source /koolshare/scripts/base.sh
eval $(dbus export routerhook_)
if [ "${serverchan_config_ntp}" == "" ]; then
    ntp_server="ntp1.aliyun.com"
else
    ntp_server=${serverchan_config_ntp}
fi
ntpclient -h ${ntp_server} -i3 -l -s >/dev/null 2>&1
[ "${routerhook_info_logger}" == "1" ] && logger "[routerhook]: 网络重启触发消息推送！"

if [[ "${routerhook_enable}" != "1" ]]; then
    [ "${routerhook_info_logger}" == "1" ] && logger "[routerhook]: 程序未开启，自动退出！"
    exit
fi
if [[ ${routerhook_trigger_ifup} != "1" ]]; then
    exit
fi
routerhook_ifup_text="/tmp/.routerhook_ifup.json"
router_uptime=$(cat /proc/uptime | awk '{print $1}' | awk '{print int($1/86400)"天 "int($1%86400/3600)"小时 "int(($1%3600)/60)"分钟 "int($1%60)"秒"}')
router_reboot_time=$(echo $(TZ=UTC-8 date "+%Y年%m月%d日 %H点%M分%S秒"))

msg_type='ifUP'
echo '{' >${routerhook_ifup_text}
echo '"msgTYPE":"'${msg_type}'",' >>${routerhook_ifup_text}
echo '"upTIME":"'${router_uptime}'",' >>${routerhook_ifup_text}
echo '"rebootTIME":"'${router_reboot_time}'",' >>${routerhook_ifup_text}

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

echo '"netSTATE":[' >>${routerhook_ifup_text}
echo '{' >>${routerhook_ifup_text}
echo '"proto":"'${router_wan0_proto}'",' >>${routerhook_ifup_text}
echo '"pubIPv4":"'${router_wan0_ip4}'",' >>${routerhook_ifup_text}
echo '"pubIPv6":"'${router_wan0_ip6}'",' >>${routerhook_ifup_text}
echo '"wanIPv4":"'${router_wan0_ip}'",' >>${routerhook_ifup_text}
echo '"wanDNS": ["'${router_wan0_dns1}'","'${router_wan0_dns2}'"],' >>${routerhook_ifup_text}
echo '"wanRX":"'${router_wan0_rx}'",' >>${routerhook_ifup_text}
echo '"wanTX":"'${router_wan0_tx}'"' >>${routerhook_ifup_text}
echo '}' >>${routerhook_ifup_text}

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

    echo ',{' >>${routerhook_ifup_text}
    echo '"proto":"'${router_wan1_proto}'",' >>${routerhook_ifup_text}
    echo '"pubIPv4":"'${router_wan1_ip4}'",' >>${routerhook_ifup_text}
    echo '"pubIPv6":"'${router_wan1_ip6}'",' >>${routerhook_ifup_text}
    echo '"wanIPv4":"'${router_wan1_ip}'",' >>${routerhook_ifup_text}
    echo '"wanDNS": ["'${router_wan1_dns1}'","'${router_wan1_dns2}'"],' >>${routerhook_ifup_text}
    echo '"wanRX":"'${router_wan1_rx}'",' >>${routerhook_ifup_text}
    echo '"wanTX":"'${router_wan1_tx}'"' >>${routerhook_ifup_text}
    echo '}' >>${routerhook_ifup_text}
fi

echo '],' >>${routerhook_ifup_text}
echo '"value1":"'${router_uptime}'",' >>${routerhook_ifup_text}
echo '"value2":"'${router_wan0_ip4}'",' >>${routerhook_ifup_text}
echo '"value3":"'${router_wan1_ip4}'"' >>${routerhook_ifup_text}
echo '}' >>${routerhook_ifup_text}

routerhook_send_content=$(jq -c . ${routerhook_ifup_text})
source /koolshare/scripts/routerhook_sender.sh

sleep 2
rm -rf ${routerhook_ifup_text}
if [[ "${routerhook_trigger_ifup_sendinfo}" == "1" ]]; then
    sh /koolshare/scripts/routerhook_check_task.sh
fi
