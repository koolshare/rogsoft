#!/bin/sh

source /koolshare/scripts/base.sh
eval $(dbus export serverchan_)
# for long message job remove
remove_cron_job() {
    logger "[ServerChan]: 关闭自动发送状态消息..."
    cru d serverchan_check >/dev/null 2>&1
}

# for long message job creat
creat_cron_job() {
    remove_cron_job
    logger "[ServerChan]: 启动自动发送状态消息..."
    if [[ "${serverchan_status_check}" == "1" ]]; then
        cru a serverchan_check ${serverchan_check_time_min} ${serverchan_check_time_hour}" * * * /koolshare/scripts/serverchan_check_task.sh"
    elif [[ "${serverchan_status_check}" == "2" ]]; then
        cru a serverchan_check ${serverchan_check_time_min} ${serverchan_check_time_hour}" * * "${serverchan_check_week}" /koolshare/scripts/serverchan_check_task.sh"
    elif [[ "${serverchan_status_check}" == "3" ]]; then
        cru a serverchan_check ${serverchan_check_time_min} ${serverchan_check_time_hour} ${serverchan_check_day}" * * /koolshare/scripts/serverchan_check_task.sh"
    elif [[ "${serverchan_status_check}" == "4" ]]; then
        if [[ "${serverchan_check_inter_pre}" == "1" ]]; then
            cru a serverchan_check "*/"${serverchan_check_inter_min}" * * * * /koolshare/scripts/serverchan_check_task.sh"
        elif [[ "${serverchan_check_inter_pre}" == "2" ]]; then
            cru a serverchan_check "0 */"${serverchan_check_inter_hour}" * * * /koolshare/scripts/serverchan_check_task.sh"
        elif [[ "${serverchan_check_inter_pre}" == "3" ]]; then
            cru a serverchan_check ${serverchan_check_time_min} ${serverchan_check_time_hour}" */"${serverchan_check_inter_day} " * * /koolshare/scripts/serverchan_check_task.sh"
        fi
    elif [[ "${serverchan_status_check}" == "5" ]]; then
        check_custom_time=$(dbus get serverchan_check_custom | base64_decode)
        cru a serverchan_check ${serverchan_check_time_min} ${check_custom_time}" * * * /koolshare/scripts/serverchan_check_task.sh"
    fi
}

creat_trigger_dhcp() {
    logger "[ServerChan]: 添加DHCP触发器"
    sed -i '/serverchan_dhcp_trigger/d' /jffs/configs/dnsmasq.d/dhcp_trigger.conf
    echo "dhcp-script=/koolshare/scripts/serverchan_dhcp_trigger.sh" >>/jffs/configs/dnsmasq.d/dhcp_trigger.conf
    [ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 重启DNSMASQ！"
    #service restart_dnsmasq
    killall dnsmasq
    sleep 1
    dnsmasq --log-async
}

remove_trigger_dhcp() {
    logger "[ServerChan]: 移除DHCP触发器"
    sed -i '/serverchan_dhcp_trigger/d' /jffs/configs/dnsmasq.d/dhcp_trigger.conf
    [ "${serverchan_info_logger}" == "1" ] && logger "[ServerChan]: 重启DNSMASQ！"
    service restart_dnsmasq
}

creat_trigger_ifup() {
    logger "[ServerChan]: 添加WAN触发器"
    rm -f /koolshare/init.d/S99serverchan.sh
    if [[ "${serverchan_trigger_ifup}" == "1" ]]; then
        ln -sf /koolshare/scripts/serverchan_ifup_trigger.sh /koolshare/init.d/S99serverchan.sh
    else
        rm -f /koolshare/init.d/S99serverchan.sh
    fi
}

remove_trigger_ifup() {
    logger "[ServerChan]: 移除WAN触发器"
    rm -f /koolshare/init.d/S99serverchan.sh
}

onstart() {
    creat_cron_job
    creat_trigger_ifup
    if [ "${serverchan_trigger_dhcp}" == "1" ]; then
        creat_trigger_dhcp
    else
        remove_trigger_dhcp
    fi
}

case $1 in
start|restart)
    remove_trigger_dhcp
    remove_trigger_ifup
    remove_cron_job
    onstart
    ;;
stop)
    remove_trigger_dhcp
    remove_trigger_ifup
    remove_cron_job
    logger "[软件中心]: 关闭ServerChan！"
    ;;
*)
    if [[ "${serverchan_enable}" == "1" ]]; then
        logger "[软件中心]: 启动ServerChan！"
        onstart
    else
        logger "[软件中心]: ServerChan未设置启动，跳过！"
    fi
    ;;
esac
