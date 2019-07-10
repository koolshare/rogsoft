#!/bin/sh
eval `dbus export easyexplorer`
source /koolshare/scripts/base.sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'

BIN=/koolshare/bin/easy-explorer
PID_FILE=/var/run/easy-explorer.pid

start_ee(){
	start-stop-daemon -S -q	-b -m -p $PID_FILE -x $BIN -- -c /tmp -u $easyexplorer_token -share $easyexplorer_dir
	[ ! -L "/koolshare/init.d/S99easyexplorer.sh" ] && ln -sf /koolshare/scripts/easyexplorer_config.sh /koolshare/init.d/S99easyexplorer.sh
	[ ! -L "/koolshare/init.d/N99easyexplorer.sh" ] && ln -sf /koolshare/scripts/easyexplorer_config.sh /koolshare/init.d/N99easyexplorer.sh
}

kill_ee(){
	killall	easy-explorer > /dev/null 2>&1
}

load_iptables(){
	iptables -S | grep "2300" | sed 's/-A/iptables -D/g' > clean.sh && chmod 777 clean.sh && ./clean.sh && rm clean.sh > /dev/null 2>&1
	iptables -t	filter -I INPUT -p tcp --dport 2300 -j ACCEPT > /dev/null 2>&1
}

del_iptables(){
	iptables -S | grep "2300" | sed 's/-A/iptables -D/g' > clean.sh && chmod 777 clean.sh && ./clean.sh && rm clean.sh > /dev/null 2>&1
}

#=========================================================
case $ACTION in
start)
	if [ "$easyexplorer_enable" == "1" ];then
		logger "[软件中心]: 启动easyexplorer插件！"
		kill_ee
		start_ee
		load_iptables
	else
		logger "[软件中心]: easyexplorer插件未开启，不启动！"
	fi
	;;
start_nat)
		load_iptables
	;;
*)
	if [ "$easyexplorer_enable" == "1" ];then
		kill_ee
		start_ee
		load_iptables
		http_response "$1"
	else
		kill_ee
		del_iptables
		http_response "$1"
	fi
	;;
esac

