#!/bin/sh
source /koolshare/scripts/base.sh
eval `dbus export ddnspod`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
# ====================================函数定义====================================

# 获得公网IP地址
# 参数：IP协议类型
arIPAddress() {
    wget --quiet --output-document=- "v${1}.ipip.net"
}

# 读取接口数据
# 参数: 接口类型 待提交数据
arApiPost() {
    local site recordLine
    if [ $ddnspod_site -eq 1 ]; then
        site="dnsapi.cn"
        recordLine="%E9%BB%98%E8%AE%A4"
    else
        site="api.dnspod.com"
        recordLine="default"
    fi
    local agent="AnripDdns/5.07(mail@anrip.com)"
    local inter="https://${site}/${1:?'Info.Version'}"
    local param="login_token=$ddnspod_config_id,$ddnspod_config_token&format=json&${2}&record_line=${recordLine}"
    wget --quiet --no-check-certificate --output-document=- --user-agent=$agent --post-data "$param" "$inter"
}

# 更新域名记录信息
# 参数: IP协议类型 主域名 子域名 记录ID 当前IP
arDdnsUpdate() {
    # 更新记录IP
    arApiPost "Record.Modify" "record_type=${1}&domain=${2}&sub_domain=${3}&record_id=${4}&value=${5}"
}

# 获取域名记录列表
# 参数: IP协议类型 主域名 子域名
arDdnsList() {
    # 获得记录列表
    arApiPost "Record.List" "record_type=${1}&domain=${2}&sub_domain=${3}"
}

# 检查DNS
# 参数: IP协议类型 主域名 子域名
arDdnsCheck() {
    local recordRS recordID recordIP recordCD currentIP errMsg
    local recordType
    if [ $1 -eq 6 ]; then
        recordType="AAAA"
    else
        recordType="A"
    fi

    currentIP=$(arIPAddress $1)
    recordRS=$(arDdnsList $recordType $2 $3)
    recordCD=$(echo $recordRS | sed 's/.*{"code":"\([0-9]*\)".*/\1/')
    if [ "$recordCD" == "1" ]; then
        recordID=$(echo $recordRS | sed 's/.*{"id":"\([0-9]*\)".*"type":"'${recordType}'".*/\1/')
        recordIP=$(echo $recordRS | sed 's/.*{"id":"'${recordID}'".*"value":"\([a-z0-9:.]*\)".*/\1/')
    else
        errMsg=$(echo $recordRS | sed 's/.*,"message":"\([^"]*\)".*/\1/')
        dbus set ddnspod_run_status_v${1}="WAN IPV${1}：${currentIP} 更新失败，原因：${errMsg}"
        echo $errMsg
        return 1
    fi

    if [ "$currentIP" != "$recordIP" ]; then
        dbus set ddnspod_run_status_v${1}="更新中。。。"

        # 更新记录IP
        recordRS=$(arDdnsUpdate $recordType $2 $3 $recordID $currentIP)
        recordCD=$(echo $recordRS | sed 's/.*{"code":"\([0-9]*\)".*/\1/')

        if [ "$recordCD" == "1" ]; then
            dbus set ddnspod_run_status_v${1}=`echo_date` "更新成功，WAN IPV${1}：${currentIP}"
        else
            errMsg=$(echo $recordRS | sed 's/.*,"message":"\([^"]*\)".*/\1/')
            dbus set ddnspod_run_status_v${1}="WAN IPV${1}：${currentIP} 更新失败，原因：${errMsg}"
            echo $errMsg
            return 1
        fi
    else
        dbus set ddnspod_run_status_v${1}="`echo_date` 无需更新，WAN IPV${1}：${currentIP}"
    fi
    return 0
}

parseDomain() {
    mainDomain=`echo ${ddnspod_config_domain} | awk -F. '{print $(NF-1)"."$NF}'`
    local tmp=${ddnspod_config_domain%$mainDomain}
    subDomain=${tmp%.}
}

add_ddnspod_cru(){
    sed -i '/ddnspod/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
    cru a ddnspod "0 */$ddnspod_refresh_time * * * /koolshare/scripts/ddnspod_config.sh update"
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
        arDdnsCheck 4 $mainDomain $subDomain
        if [ "$ddnspod_ipv6_enable" == "1" ];then
            arDdnsCheck 6 $mainDomain $subDomain
        fi
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
    arDdnsCheck 4 $mainDomain $subDomain
    if [ "$ddnspod_ipv6_enable" == "1" ];then
        arDdnsCheck 6 $mainDomain $subDomain
    fi
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
        arDdnsCheck 4 $mainDomain $subDomain
        if [ "$ddnspod_ipv6_enable" == "1" ];then
            arDdnsCheck 6 $mainDomain $subDomain
        fi
        http_response "$1"
    else
        stop_ddnspod
        http_response "$1"
    fi
    ;;
esac
