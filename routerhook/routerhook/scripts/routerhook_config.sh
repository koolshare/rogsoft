#!/bin/sh

source /koolshare/scripts/base.sh
eval $(dbus export routerhook_)
# for long message job remove
remove_cron_job() {
    logger "[routerhook]: 关闭全部定时任务！"
    cru d routerhook_check >/dev/null 2>&1
    cru d routerhook_sm >/dev/null 2>&1
}

# for long message job creat
creat_cron_job() {
    remove_cron_job
    logger "[routerhook]: 准备启动定时任务！"
    if [[ "${routerhook_status_check}" == "1" ]]; then
        cru a routerhook_check ${routerhook_check_time_min} ${routerhook_check_time_hour}" * * * /koolshare/scripts/routerhook_check_task.sh"
    elif [[ "${routerhook_status_check}" == "2" ]]; then
        cru a routerhook_check ${routerhook_check_time_min} ${routerhook_check_time_hour}" * * "${routerhook_check_week}" /koolshare/scripts/routerhook_check_task.sh"
    elif [[ "${routerhook_status_check}" == "3" ]]; then
        cru a routerhook_check ${routerhook_check_time_min} ${routerhook_check_time_hour} ${routerhook_check_day}" * * /koolshare/scripts/routerhook_check_task.sh"
    elif [[ "${routerhook_status_check}" == "4" ]]; then
        if [[ "${routerhook_check_inter_pre}" == "1" ]]; then
            cru a routerhook_check "*/"${routerhook_check_inter_min}" * * * * /koolshare/scripts/routerhook_check_task.sh"
        elif [[ "${routerhook_check_inter_pre}" == "2" ]]; then
            cru a routerhook_check "0 */"${routerhook_check_inter_hour}" * * * /koolshare/scripts/routerhook_check_task.sh"
        elif [[ "${routerhook_check_inter_pre}" == "3" ]]; then
            cru a routerhook_check ${routerhook_check_time_min} ${routerhook_check_time_hour}" */"${routerhook_check_inter_day} " * * /koolshare/scripts/routerhook_check_task.sh"
        fi
    elif [[ "${routerhook_status_check}" == "5" ]]; then
        check_custom_time=$(dbus get routerhook_check_custom | base64_decode)
        cru a routerhook_check ${routerhook_check_time_min} ${check_custom_time}" * * * /koolshare/scripts/routerhook_check_task.sh"
    fi
    logger "[routerhook]: 准备启动HASS定时任务！"
    if [[ -n "${routerhook_sm_cron}" ]]; then
        cru a routerhook_sm "* * * * * /koolshare/scripts/routerhook_hass_task.sh"
        logger "[routerhook]: 已创建HASS定时任务！"
    fi
}

creat_trigger_dhcp() {
    sed -i '/routerhook_dhcp_trigger/d' /jffs/configs/dnsmasq.d/dhcp_trigger.conf
    echo "dhcp-script=/koolshare/scripts/routerhook_dhcp_trigger.sh" >>/jffs/configs/dnsmasq.d/dhcp_trigger.conf
    [ "${routerhook_info_logger}" == "1" ] && logger "[routerhook]: 创建DHCP触发器，重启DNSMASQ！"
    #service restart_dnsmasq
    killall dnsmasq
    sleep 1
    dnsmasq --log-async
}

remove_trigger_dhcp() {
    sed -i '/routerhook_dhcp_trigger/d' /jffs/configs/dnsmasq.d/dhcp_trigger.conf
    [ "${routerhook_info_logger}" == "1" ] && logger "[routerhook]: 移除DHCP触发器，重启DNSMASQ！"
    service restart_dnsmasq
}

creat_trigger_ifup() {
    rm -f /koolshare/init.d/S99routerhook.sh
    if [[ "${routerhook_trigger_ifup}" == "1" ]]; then
        ln -sf /koolshare/scripts/routerhook_ifup_trigger.sh /koolshare/init.d/S99routerhook.sh
    else
        rm -f /koolshare/init.d/S99routerhook.sh
    fi
}

remove_trigger_ifup() {
    rm -f /koolshare/init.d/S99routerhook.sh
}

onstart() {
    creat_cron_job
    creat_trigger_ifup
    if [ "${routerhook_trigger_dhcp}" == "1" ]; then
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
    logger "[routerhook]: 关闭routerhook！"
    ;;
*)
    if [[ "${routerhook_enable}" == "1" ]]; then
        logger "[routerhook]: 启动routerhook！"
        onstart
    else
        logger "[routerhook]: routerhook未设置启动，跳过！"
    fi
    ;;
esac
