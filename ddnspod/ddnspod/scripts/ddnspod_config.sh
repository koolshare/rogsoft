#!/bin/sh
source /koolshare/scripts/base.sh
eval `dbus export ddnspod`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
# ====================================函数定义====================================
# 获得外网地址
arIpAdress() {
    local inter=$(curl -s whatismyip.akamai.com)
    #local inter=$(nvram get wan0_realip_ip)
    echo $inter
}

# 查询域名地址
# 参数: 待查询域名
arNslookup() {
    local inter="http://119.29.29.29/d?dn="
    wget --quiet --output-document=- $inter$1
}

# 读取接口数据
# 参数: 接口类型 待提交数据
arApiPost() {
    local agent="AnripDdns/5.07(mail@anrip.com)"
    local inter="https://dnsapi.cn/${1:?'Info.Version'}"
    local param="login_token=$ddnspod_config_id,$ddnspod_config_token&format=json&${2}"
    wget --quiet --no-check-certificate --output-document=- --user-agent=$agent --post-data $param $inter
}

# 更新记录信息
# 参数: 主域名 子域名
arDdnsUpdate() {
    local domainID recordID recordRS recordCD myIP errMsg
    # 获得域名ID
    domainID=$(arApiPost "Domain.Info" "domain=${1}")
	domainID=$(echo $domainID | sed 's/.*"id":"\([0-9]*\)".*/\1/')
	
    # 获得记录ID
    recordID=$(arApiPost "Record.List" "domain_id=${domainID}&sub_domain=${2}")
    recordID=$(echo $recordID | sed 's/.*\[{"id":"\([0-9]*\)".*/\1/')
    # 更新记录IP
    myIP=$($inter)
    recordRS=$(arApiPost "Record.Ddns" "domain_id=${domainID}&record_id=${recordID}&sub_domain=${2}&value=${myIP}&record_line=默认")
    recordCD=$(echo $recordRS | sed 's/.*{"code":"\([0-9]*\)".*/\1/')
    # 输出记录IP
    if [ "$recordCD" == "1" ]; then
        echo $recordRS | sed 's/.*,"value":"\([0-9\.]*\)".*/\1/'
        dbus set ddnspod_run_status="`echo_date` 更新成功，wan ip：${hostIP}"
        return 1
    fi
    # 输出错误信息
    errMsg=$(echo $recordRS | sed 's/.*,"message":"\([^"]*\)".*/\1/')
    dbus set ddnspod_run_status="失败，错误代码：$errMsg"
    echo $errMsg
}

arDdnsCheck() {
	local postRS
	hostIP=$(arIpAdress)
	lastIP=$(arNslookup "${2}.${1}")
	echo "hostIP: ${hostIP}"
	echo "lastIP: ${lastIP}"
	if [ "$lastIP" != "$hostIP" ]; then
		dbus set ddnspod_run_status="更新中。。。"
		postRS=$(arDdnsUpdate $1 $2)
		echo "postRS: ${postRS}"
		if [ $? -ne 1 ]; then
			dbus set ddnspod_run_status="wan ip：${hostIP} 更新失败，原因：${postRS}"
		    return 1
		fi
	else
		dbus set ddnspod_run_status="`echo_date` wan ip：${hostIP} 未改变，无需更新"
	fi
	return 0
}

parseDomain() {
	mainDomain=${ddnspod_config_domain#*.}
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
