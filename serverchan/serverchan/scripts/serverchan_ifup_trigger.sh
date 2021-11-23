#!/bin/sh
source /koolshare/scripts/base.sh
eval $(dbus export serverchan_)
if [ "${serverchan_config_ntp}" == "" ]; then
    ntp_server="ntp1.aliyun.com"
else
    ntp_server=${serverchan_config_ntp}
fi
ntpclient -h ${ntp_server} -i3 -l -s >/dev/null 2>&1
[ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 网络重启触发消息推送！"

if [[ "${serverchan_enable}" != "1" ]]; then
    [ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 程序未开启，自动退出！"
    exit
fi
if [[ ${serverchan_trigger_ifup} != "1" ]]; then
    exit
fi
serverchan_ifup_text="/tmp/.serverchan_ifup.md"
send_title=$(dbus get serverchan_config_name | base64_decode) || "本次未获取到！"
router_uptime=$(cat /proc/uptime | awk '{print $1}' | awk '{print int($1/86400)"天 "int($1%86400/3600)"小时 "int(($1%3600)/60)"分钟 "int($1%60)"秒"}')
router_reboot_time=$(echo $(TZ=UTC-8 date "+%Y年%m月%d日 %H点%M分%S秒"))

echo "#### ** 你的网络刚刚发生了重启，重启后WAN信息如下： **" >${serverchan_ifup_text}
echo "---" >>${serverchan_ifup_text}
echo "##### 系统开机时间: ${router_uptime}" >>${serverchan_ifup_text}
echo "##### 网络重启时间: ${router_reboot_time}" >>${serverchan_ifup_text}
echo "---" >>${serverchan_ifup_text}
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

echo "#### **网络状态信息:**" >>${serverchan_ifup_text}
echo "##### **WAN0状态信息:**" >>${serverchan_ifup_text}
echo "##### 联机类型: ${router_wan0_proto}" >>${serverchan_ifup_text}
echo "##### 公网IPv4地址: ${router_wan0_ip4}" >>${serverchan_ifup_text}
echo "##### 公网IPv6地址: ${router_wan0_ip6}" >>${serverchan_ifup_text}
echo "##### WAN口IPv4地址: ${router_wan0_ip}" >>${serverchan_ifup_text}
echo "##### WAN口DNS地址: ${router_wan0_dns1} ${router_wan0_dns2}" >>${serverchan_ifup_text}
echo "##### WAN口接收流量: ${router_wan0_rx}" >>${serverchan_ifup_text}
echo "##### WAN口发送流量: ${router_wan0_tx}" >>${serverchan_ifup_text}
echo "---" >>${serverchan_ifup_text}
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
    echo "##### **WAN1状态信息:**" >>${serverchan_ifup_text}
    echo "##### 联机类型: ${router_wan1_proto}" >>${serverchan_ifup_text}
    echo "##### 公网IPv4地址: ${router_wan1_ip4}" >>${serverchan_ifup_text}
    echo "##### 公网IPv6地址: ${router_wan1_ip6}" >>${serverchan_ifup_text}
    echo "##### WAN口IPv4地址: ${router_wan1_ip}" >>${serverchan_ifup_text}
    echo "##### WAN口DNS地址: ${router_wan1_dns1} ${router_wan1_dns2}" >>${serverchan_ifup_text}
    echo "##### WAN口接收流量: ${router_wan1_rx}" >>${serverchan_ifup_text}
    echo "##### WAN口发送流量: ${router_wan1_tx}" >>${serverchan_ifup_text}
    echo "---" >>${serverchan_ifup_text}
fi
serverchan_send_title="${send_title} 路由器网络重启通知："
serverchan_send_content=$(cat ${serverchan_ifup_text})
sckey_nu=$(dbus list serverchan_config_sckey | sort -n -t "_" -k 4 | cut -d "=" -f 1 | cut -d "_" -f 4)
for nu in ${sckey_nu}; do
    serverchan_config_sckey=$(dbus get serverchan_config_sckey_${nu})
    url="https://sc.ftqq.com/${serverchan_config_sckey}.send"
    result=$(wget --no-check-certificate --post-data "text=${serverchan_send_title}&desp=${serverchan_send_content}" -qO- ${url})
    if [ -n $(echo $result | grep "success") ]; then
        [ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 网络重启信息推送到 SCKEY No.${nu} 成功！！"
    else
        [ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 网络重启信息推送到 SCKEY No.${nu} 失败，请检查网络及配置！"
    fi
done
sleep 2
rm -rf ${serverchan_ifup_text}
if [[ "${serverchan_trigger_ifup_sendinfo}" == "1" ]]; then
    sh /koolshare/scripts/serverchan_check_task.sh
fi
