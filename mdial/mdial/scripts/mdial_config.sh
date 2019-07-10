#!/bin/sh

eval `dbus export mdial_`
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
LOG_FILE=/tmp/upload/mdial_log.txt

start(){
	echo_date "==========================================================="
	if [ "$(nvram get wan_proto)" != "pppoe" ];then
		echo_date "你的网络不是pppoe拨号方式，不能使用本插件！"
		echo_date "退出！！"
		echo_date "==========================================================="
		dbus set mdial_enable=0
		return 1
	fi
	num=$mdial_nu
	dialed=`ifconfig | grep -c ppp[0-9]`
	max_ppp=$(ifconfig | grep ppp[0-9]|awk '{print $1}'|sed 's/ppp//g'|sort -n|tail -n1)

	if [ $dialed -lt $num ];then
		dial_nu=$(($num - $dialed))
		echo_date "已经拨号$dialed个，还需要拨号$dial_nu个"
		start_dial $dialed $dial_nu $max_ppp
	elif [ $dialed -eq $num ];then
		echo_date "已经拨号$dialed个，不需要继续拨号"
	elif [ $dialed -gt $num ];then
		kill_nu=$(($dialed - $num))
		echo_date "已经拨号$dialed个，需要关闭$kill_nu个"
	fi
}

start_dial(){
	local dialed_nu=$1
	local dial_nu=$2
	local ppp_nu=$(($3 + 1))
	local count=0
	
	#echo dialed_nu $dialed_nu
	#echo dial_nu $dial_nu
	#echo ppp_nu $ppp_nu
	
	mkdir -p /koolshare/configs/mdial
	rm -rf /koolshare/configs/mdial/*

	# 生成已拨号的负载均衡命令
	cmd="ip route add default"
	local lb_count=1
	while [ $lb_count -le $dialed_nu ]
	do
		local pppoe=`ifconfig | grep ppp[0-9] | awk '{print $1}'| sort -n |sed -n "$lb_count p"`
		local ip=`ifconfig | grep -E 'ppp[0-9]|P-t-P' | awk '{print $3}' | grep P-t-P | head -n $lb_count | cut -d ':' -f 2 | tail -1`
		cmd="${cmd} nexthop via $ip dev $pppoe weight 1 "
		let lb_count+=1
	done

	# 开始拨号
	while [ $count -lt $dial_nu ]
	do
		# 开始拨号
		echo_date "-----------------------------------------------------------"
		#echo_date "正在复制ppp$ppp_nu拨号配置文件..."
		cp /tmp/ppp/options.wan0 /koolshare/configs/mdial/options.mdial$ppp_nu
		sed -i "s/linkname .*/linkname mdial$ppp_nu/" /koolshare/configs/mdial/options.mdial$ppp_nu
		echo_date "第$(( $ppp_nu + 1 ))拨:ppp$ppp_nu开始拨号..."
		/usr/sbin/pppd file /koolshare/configs/mdial/options.mdial$ppp_nu >/dev/null 2>&1

		#判断拨号是否成功
		local i=50
		until [ -n "`ifconfig | grep ppp$ppp_nu`" ]
		do
			i=$(($i-1))
			echo_date "等待ppp$ppp_nu拨号完成..."
			usleep 200000
			if [ "$i" -lt 1 ];then
				echo_date "ppp$ppp_nu拨号失败..."
				return 1
			fi
		done

		if [ "$?" == "0" ];then
			# 生成路由表命令
			local gw_addr=$(ifconfig|grep -A 1 ppp$ppp_nu|grep -Eo 'P-t-P:([0-9]{1,3}[\.]){3}[0-9]{1,3}'|awk -F":" '{print $2}')
			cmd="${cmd} nexthop via $gw_addr dev ppp$ppp_nu weight 1 "
			
			# 添加iptables
			echo_date "为ppp$ppp_nu配置防火墙..."
			local ip_addr=$(ifconfig|grep -A 1 ppp$ppp_nu|grep -Eo 'inet addr:([0-9]{1,3}[\.]){3}[0-9]{1,3}'|awk -F":" '{print $2}')
			local PPP_NU=$(iptables -t nat -L POSTROUTING -v -n --line-numbers|grep ppp|tail -n1|awk '{print $1}')||0
			let PPP_NU+=1
			iptables -t nat -I POSTROUTING $PPP_NU ! -s $ip_addr/32 -o ppp$ppp_nu -j MASQUERADE		

			# 拨号成功+1
			let count+=1
			let ppp_nu+=1
		else
			echo_date "停止继续拨号..."
			break
		fi
	done

	echo_date "-----------------------------------------------------------"
	# 添加路由表
	FINAL_DIAL_NU=`ifconfig | grep -c ppp[0-9]`
	
	echo_date "为$FINAL_DIAL_NU拨配置负载均衡..."
	ip route del default
	$cmd
	ip route flush cache 

	echo_date "完成，总共完成$FINAL_DIAL_NU拨！请打开测速网站测速！"
	echo_date "==========================================================="
	# 拨号完毕，显示状态
	# show_status
}

show_status(){
	# for dbus info
	echo_date "-----------------------------------------------------------"
	iptables -nvL POSTROUTING -t nat
	echo_date "-----------------------------------------------------------"
	ps | grep pppd | grep -v grep
	echo_date "-----------------------------------------------------------"
	ip route show
}

stop(){
	local PIDS=$(ps|grep ppp|grep -E "mdial|duobo"|awk '{print $1}')
	if [ -n "$PIDS" ];then
		echo_date "==========================================================="
		echo_date "关闭多拨进程！"
		for PID in $PIDS
		do
			kill -9 $PID >/dev/null 2>&1
		done
	fi
	# 清除iptables
	local nat_indexs=$(iptables -t nat -L POSTROUTING -v -n --line-numbers|grep ppp|grep -v ppp0|sort -rn|awk '{print $1}')
	if [ -n "$nat_indexs" ];then
		echo_date "清除iptables规则！"
		for nat_index in $nat_indexs
		do
			iptables -t nat -D POSTROUTING $nat_index >/dev/null 2>&1
		done
	fi

	# 重建路由表
	if [ -n "$(ip route show|grep weight)" ];then
		echo_date "重建默认路由表"
		ip route del default
		ip route flush cache
		echo_date "多拨成功关闭，恢复单线单拨状态!"
	fi
}


case $1 in
start)
	if [ "$mdial_enable" == "1" ];then
		logger "[软件中心]: 启动单线多拨！"
		start
	else
		logger "[软件中心]: 单线多拨未设置开机启动，跳过！"
	fi
	;;
stop)
	stop
	;;
esac


case $2 in
1)
	echo " " > $LOG_FILE
	http_response "$1"
	if [ "$mdial_enable" == "1" ];then
		stop >> $LOG_FILE
		sleep 1
		start >> $LOG_FILE
		echo XU6J03M6 >> $LOG_FILE
	else
		stop >> $LOG_FILE
		echo XU6J03M6 >> $LOG_FILE
	fi
	;;
2)
	echo " " > $LOG_FILE
	http_response "$1"
	;;
esac