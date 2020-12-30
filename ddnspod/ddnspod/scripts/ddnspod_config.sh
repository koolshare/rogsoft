#!/bin/sh
source /koolshare/scripts/base.sh
eval `dbus export ddnspod`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
# ====================================函数定义====================================
# Get WAN-IP

arWanIp() {

    local hostIp

    local lanIps="^$"

    lanIps="$lanIps|(^10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$)"
    lanIps="$lanIps|(^127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$)"
    lanIps="$lanIps|(^169\.254\.[0-9]{1,3}\.[0-9]{1,3}$)"
    lanIps="$lanIps|(^172\.(1[6-9]|2[0-9]|3[0-1])\.[0-9]{1,3}\.[0-9]{1,3}$)"
    lanIps="$lanIps|(^192\.168\.[0-9]{1,3}\.[0-9]{1,3}$)"

    case $(uname) in
        'Linux')
            hostIp=$(ip -o -4 addr list | grep -Ev '\s(docker|lo)' | awk '{print $4}' | cut -d/ -f1 | grep -Ev "$lanIps")
        ;;
        'Darwin')
            hostIp=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | grep -Ev "$lanIps")
        ;;
    esac

    if [ -z "$hostIp" ]; then
        if type wget >/dev/null 2>&1; then
            hostIp=$(wget --quiet --output-document=- http://members.3322.org/dyndns/getip)
        else
            hostIp=$(curl -s http://members.3322.org/dyndns/getip)
        fi
    fi

    echo $hostIp

}

# Dnspod Bridge
# Arg: type data
arDdnsApi() {

    local agent="AnripDdns/6.0.0(mail@anrip.com)"

    local apiurl="https://dnsapi.cn/${1:?'Info.Version'}"
    local params="login_token=$ddnspod_config_id,$ddnspod_config_token&format=json&$2"

    if type wget >/dev/null 2>&1; then
        wget --quiet --no-check-certificate --output-document=- --user-agent=$agent --post-data $params $apiurl
    else
        curl -s -A $agent -d $params $apiurl
    fi

}

# Fetch Domain Ip
# Arg: domain
arDdnsInfo() {

    local domainId
    local recordId
    local recordIp

    # Get domain ID
    domainId=$(arDdnsApi "Domain.Info" "domain=$1")
    domainId=$(echo $domainId | sed 's/.*"id":"\([0-9]*\)".*/\1/')

    # Get Record ID
    recordId=$(arDdnsApi "Record.List" "domain_id=$domainId&sub_domain=$2&record_type=A")
    recordId=$(echo $recordId | sed 's/.*"id":"\([0-9]*\)".*/\1/')

    # Last IP
    recordIp=$(arDdnsApi "Record.Info" "domain_id=$domainId&record_id=$recordId")
    recordIp=$(echo $recordIp | sed 's/.*,"value":"\([0-9\.]*\)".*/\1/')

    # Output IP
    case "$recordIp" in
        [1-9]*)
            echo $recordIp
            return 0
        ;;
        *)
            echo "Get Record Info Failed!"
            return 1
        ;;
    esac

}
# Update Domain Ip
# Arg: main-domain sub-domain
arDdnsUpdate() {
    local domainId
    local recordId
    local recordRs
    local recordIp
    local recordCd
    local errMsg

    local hostIp=$(arWanIp)

    # Get domain ID
    domainId=$(arDdnsApi "Domain.Info" "domain=$1")
    domainId=$(echo $domainId | sed 's/.*"id":"\([0-9]*\)".*/\1/')

    # Get Record ID
    recordId=$(arDdnsApi "Record.List" "domain_id=$domainId&sub_domain=$2&record_type=A")
    recordId=$(echo $recordId | sed 's/.*"id":"\([0-9]*\)".*/\1/')

    # Update IP
    recordRs=$(arDdnsApi "Record.Ddns" "domain_id=$domainId&record_id=$recordId&sub_domain=$2&record_type=A&value=$hostIp&record_line=%e9%bb%98%e8%ae%a4")
    recordIp=$(echo $recordRs | sed 's/.*,"value":"\([0-9\.]*\)".*/\1/')
    recordCd=$(echo $recordRs | sed 's/.*{"code":"\([0-9]*\)".*/\1/')

    # Output IP
    if [ "$recordIp" = "$hostIp" ]; then
        if [ "$recordCd" = "1" ]; then
            dbus set ddnspod_run_status="`echo_date` 更新成功，wan ip：${hostIp}"
            echo $recordIp
            return 0
        fi
        # Echo error message
        errMsg=$(echo $recordRs | sed 's/.*,"message":"\([^"]*\)".*/\1/')
        dbus set ddnspod_run_status="失败，错误代码：$errMsg"
        echo $errMsg
        return 1
    else
        echo "Update Failed! Please check your network."
        return 1
    fi
}

# DDNS Check
# Arg: Main Sub
arDdnsCheck() {
    local postRs
    local lastIP

    local hostIp=$(arWanIp)

    echo "Updating Domain: $2.$1"
    echo "Host Ip: $hostIp"

    lastIP=$(arDdnsInfo "$1" "$2")
    if [ $? -eq 0 ]; then
        echo "lastIP: $lastIP"
        if [ "$lastIP" != "$hostIp" ]; then
            dbus set ddnspod_run_status="更新中。。。"
            postRs=$(arDdnsUpdate "$1" "$2")
            if [ $? -eq 0 ]; then
                echo "postRs: $postRs"
                return 0
            else
                dbus set ddnspod_run_status="wan ip：${hostIp} 更新失败，原因：${postRs}"
                echo "$postRs"
                return 1
            fi
        fi
        dbus set ddnspod_run_status="`echo_date` wan ip：${hostIp} 未改变，无需更新"
        echo "Last IP is the same as current IP!"
        return 1
    fi

    echo "$lastIP"
    return 1
}

parseDomain() {
    mainDomain=${ddnspod_config_domain#*.}
    local tmp=${ddnspod_config_domain%$mainDomain}
    subDomain=${tmp%.}
}

add_ddnspod_cru(){
    sed -i '/ddnspod/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
    cru a ddnspod "*/$ddnspod_refresh_time * * * * /koolshare/scripts/ddnspod_config.sh update"
}

stop_ddnspod(){
    sed -i '/ddnspod/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
}

# ====================================used by init or cru====================================
case $1 in
start)
    #此处为开机自启动设计
    if [ "$ddnspod_enable" == "1" ];then
        logger "[软件中心]: 启动ddnspod！"
        add_ddnspod_cru
        parseDomain
        arDdnsCheck $mainDomain $subDomain
    else
        logger "[软件中心]: ddnspod未设置开机启动，跳过！"
    fi
    ;;
stop | kill )
    #此处卸载插件时关闭插件设计
    stop_ddnspod
    ;;
update)
    #此处为定时脚本设计
    parseDomain
    arDdnsCheck $mainDomain $subDomain
    ;;
esac
# ====================================submit by web====================================
case $2 in
1)
    #此处为web提交动设计
    if [ "$ddnspod_enable" == "1" ];then
        [ ! -L "/koolshare/init.d/S99ddnspod.sh" ] && ln -sf /koolshare/scripts/ddnspod_config.sh /koolshare/init.d/S99ddnspod.sh
        parseDomain
        add_ddnspod_cru
        arDdnsCheck $mainDomain $subDomain
        http_response "$1"
    else
        stop_ddnspod
        http_response "$1"
    fi
    ;;
esac
