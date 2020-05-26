#!/bin/sh

source /koolshare/scripts/base.sh
eval $(dbus export pushplus_)
# for long message job remove
remove_cron_job() {
    logger "[pushplus]: 关闭自动发送状态消息..."
    cru d pushplus_check >/dev/null 2>&1
}

# for long message job creat
creat_cron_job() {
    remove_cron_job
    logger "[pushplus]: 启动自动发送状态消息..."
    if [[ "${pushplus_status_check}" == "1" ]]; then
        cru a pushplus_check ${pushplus_check_time_min} ${pushplus_check_time_hour}" * * * /koolshare/scripts/pushplus_check_task.sh"
    elif [[ "${pushplus_status_check}" == "2" ]]; then
        cru a pushplus_check ${pushplus_check_time_min} ${pushplus_check_time_hour}" * * "${pushplus_check_week}" /koolshare/scripts/pushplus_check_task.sh"
    elif [[ "${pushplus_status_check}" == "3" ]]; then
        cru a pushplus_check ${pushplus_check_time_min} ${pushplus_check_time_hour} ${pushplus_check_day}" * * /koolshare/scripts/pushplus_check_task.sh"
    elif [[ "${pushplus_status_check}" == "4" ]]; then
        if [[ "${pushplus_check_inter_pre}" == "1" ]]; then
            cru a pushplus_check "*/"${pushplus_check_inter_min}" * * * * /koolshare/scripts/pushplus_check_task.sh"
        elif [[ "${pushplus_check_inter_pre}" == "2" ]]; then
            cru a pushplus_check "0 */"${pushplus_check_inter_hour}" * * * /koolshare/scripts/pushplus_check_task.sh"
        elif [[ "${pushplus_check_inter_pre}" == "3" ]]; then
            cru a pushplus_check ${pushplus_check_time_min} ${pushplus_check_time_hour}" */"${pushplus_check_inter_day} " * * /koolshare/scripts/pushplus_check_task.sh"
        fi
    elif [[ "${pushplus_status_check}" == "5" ]]; then
        check_custom_time=$(dbus get pushplus_check_custom | base64_decode)
        cru a pushplus_check ${pushplus_check_time_min} ${check_custom_time}" * * * /koolshare/scripts/pushplus_check_task.sh"
    fi
}

creat_trigger_dhcp() {
    logger "[pushplus]: 添加DHCP触发器"
    sed -i '/pushplus_dhcp_trigger/d' /jffs/configs/dnsmasq.d/dhcp_trigger.conf
    echo "dhcp-script=/koolshare/scripts/pushplus_dhcp_trigger.sh" >>/jffs/configs/dnsmasq.d/dhcp_trigger.conf
    [ "${pushplus_info_logger}" == "1" ] && logger "[pushplus]: 重启DNSMASQ！"
    #service restart_dnsmasq
    killall dnsmasq
    sleep 1
    dnsmasq --log-async
}

remove_trigger_dhcp() {
    logger "[pushplus]: 移除DHCP触发器"
    sed -i '/pushplus_dhcp_trigger/d' /jffs/configs/dnsmasq.d/dhcp_trigger.conf
    [ "${pushplus_info_logger}" == "1" ] && logger "[pushplus]: 重启DNSMASQ！"
    service restart_dnsmasq
}

creat_trigger_ifup() {
    logger "[pushplus]: 添加WAN触发器"
    rm -f /koolshare/init.d/*pushplus.sh
    if [[ "${pushplus_trigger_ifup}" == "1" ]]; then
        ln -sf /koolshare/scripts/pushplus_ifup_trigger.sh /koolshare/init.d/S99pushplus.sh
    else
        rm -f /koolshare/init.d/*pushplus.sh
    fi
}

remove_trigger_ifup() {
    logger "[pushplus]: 移除WAN触发器"
    rm -f /koolshare/init.d/*pushplus.sh
}

onstart() {
    creat_cron_job
    creat_trigger_ifup
    if [ "${pushplus_trigger_dhcp}" == "1" ]; then
        creat_trigger_dhcp
    else
        remove_trigger_dhcp
    fi
}

# used by httpdb
case $1 in
stop)
    remove_trigger_dhcp
    remove_trigger_ifup
    remove_cron_job
    logger "[软件中心]: 关闭pushplus！"
    ;;
*)
    if [[ "${pushplus_enable}" == "1" ]]; then
        logger "[软件中心]: 启动pushplus！"
        onstart
    else
        logger "[软件中心]: pushplus未设置启动，跳过！"
    fi
    ;;
esac
