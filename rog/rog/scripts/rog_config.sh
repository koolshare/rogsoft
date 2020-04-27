#!/bin/sh
source /koolshare/scripts/base.sh
eval $(dbus export rog)
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
LOG_FILE=/tmp/upload/rog_log.txt

# 具有ROG的插件： acme aria2 cfddns ddnsto easyexplorer fastd1ck frpc koolproxy mdial qiaodao rog serverchan softcenter shadowsocks
# 无ROG的插件： ddnspod kms shellinabox ssid ssserver swap

switch_ui(){
	WGET="wget -4 --no-check-certificate --quiet --timeout=15"
	softcenter_app_url="https://rogsoft.ddnsto.com/softcenter/app.json.js"
	app_file=/tmp/.app.json.js
	ROGUI="softcenter|aliddns|acme|aria2|cfddns|ddnsto|easyexplorer|fastd1ck|frpc|koolproxy|mdial|qiaodao|rog|serverchan|usb2jffs|routerhook"
	BASE_FOLDER=/tmp/ks_ui
	rm -rf ${BASE_FOLDER}
	rm -rf ${serverchan_info_text} ${app_file}
	mkdir ${BASE_FOLDER}
	mkdir ${BASE_FOLDER}/res
	mkdir ${BASE_FOLDER}/webs
	
	local type="$1"
	[ "$type" == "1" ] && echo_date "切换到Rog风格皮肤！"
	[ "$type" == "2" ] && echo_date "切换到Asuswrt风格皮肤！"
	
	wget -4 --no-check-certificate --quiet ${softcenter_app_url} -O ${app_file}
	if [ "$?" == "0" ]; then
		echo_date "连接软件中心服务器正常！开始切换UI！"
	else
		echo_date "连接软件中心服务器异常，无法切换UI，退出！"
		return 1
	fi

	softcenter_local_version=$(dbus get softcenter_version)
	softcenter_online_version=$(cat ${app_file} | jq .version | sed 's/"//g')
	COMP_SOFT=$(versioncmp ${softcenter_local_version} ${softcenter_online_version})
	if [ "${COMP_SOFT}" == "1" ];then
		echo_date "软件中心有新版本了，最新版本: ${softcenter_online_version}"
		echo_date "请将软件中心更新到最新版本后再使用UI切换功能！！！"
		return 1
	else
		download_ui softcenter ${type}
	fi

	local soft_lists=$(dbus list softcenter | grep "version" | grep "softcenter_module_" | cut -d "_" -f3 | grep -E ${ROGUI})
	#check software update
	app_nu_online=$(cat ${app_file} | jq '.apps|length')
	for app in ${soft_lists}
	do
		i=-1
		until [ "${i}" == "${app_nu_online}" ];	do
			i=$(($i+1))
			soft_match=$(cat ${app_file} | jq .apps[${i}] | grep -w "${app}")
			if [ -n "$soft_match" ];then
				app_local_version=$(dbus get softcenter_module_${app}_version)
				app_oneline_version=$(cat ${app_file} | jq .apps[${i}].version | sed 's/"//g')
				COMP_APP=$(versioncmp ${app_local_version} ${app_oneline_version})
				if [ "${COMP_APP}" == "1" ];then
					echo_date "插件 ${app} 有新版本: ${app_oneline_version}，请将插件更新至最新版本后尝试！" 
				else
					download_ui ${app} ${type}
				fi
			else
				continue
			fi
		done
	done
	
	[ "$rog_ui_flag" == "1" ] && download_ext_ui ${type}
	apply_ui
	echo_date "Rog风格皮肤切换完毕，请使用ctrl + F5强制刷新网页！"
}

_get_ui_name(){
	case $1 in
	1)
		echo "Rog"
		;;
	2)
		echo "Asuswrt"
		;;
	esac
}

_get_plugin_name(){
	case $1 in
	softcenter)
		echo "【软件中心】"
		;;
	acme)
		echo "【Let's Encrypt】"
		;;
	aria2)
		echo "【aria2】"
		;;
	cfddns)
		echo "【CloudFlare DDNS】"
		;;
	easyexplorer)
		echo "【易有云】"
		;;
	fastd1ck)
		echo "【迅雷快鸟】"
		;;
	frpc)
		echo "【frpc内网穿透】"
		;;
	mdial)
		echo "【单线多拨】"
		;;
	qiaodao)
		echo "【自动签到】"
		;;
	serverchan)
		echo "【ServerChan 微信推送】"
		;;
	rog)
		echo "【ROG工具箱】"
		;;
	*)
		echo "【$1】"
	esac
}

download_ui(){
	local app=$1
	local type=$2
	[ "$type" == "1" ] && local EXT="/ROG" || local EXT=""
	case ${app} in
	softcenter)
		echo_date "切换$(_get_plugin_name $app)的webui为$(_get_ui_name $type)风格！"
		$WGET -P ${BASE_FOLDER}/res https://rogsoft.ddnsto.com/${app}/${app}${EXT}/res/softcenter.css
		;;
	*)
		echo_date "切换$(_get_plugin_name $app)的webui为$(_get_ui_name $type)风格！"
		wget -4 --no-check-certificate --quiet -P ${BASE_FOLDER}/webs https://rogsoft.ddnsto.com/${app}/${app}/webs/Module_${app}.asp
		[ "$?" == "0" -a "$type" == "2" ] && sed -i '/rogcss/d' ${BASE_FOLDER}/webs/Module_${app}.asp >/dev/null 2>&1
		;;
	esac
}

download_ext_ui(){
	local type=$1
	[ "$type" == "1" ] && local EXT="/rog" || local EXT=""
	# koolproxy
	if [ -n "$(dbus get softcenter_module_koolproxy_install)" ]; then
		echo_date "切换【koolproxy】的webui为$(_get_ui_name $type)风格！"
		$WGET -P ${BASE_FOLDER}/webs https://rogsoft.ddnsto.com/koolproxy/koolproxy/ROG/webs/Module_koolproxy.asp
	fi
	# 不可描述
	if [ -n "$(dbus get softcenter_module_shadowsocks_install)" ]; then
		echo_date "切换【科学上网】的webui为$(_get_ui_name $type)风格！"
		$WGET -P ${BASE_FOLDER}/res https://raw.githubusercontent.com/hq450/fancyss/master/fancyss_hnd/shadowsocks${EXT}/res/shadowsocks.css
		if [ "$?" != "0" ]; then
			echo_date "下载https://raw.githubusercontent.com/hq450/fancyss/master/fancyss_hnd/shadowsocks${EXT}/res/shadowsocks.css失败！！"
			echo_date "不替换【科学上网】的css样式！"
			rm -rf ${BASE_FOLDER}/res/shadowsocks.css
		fi
	fi
}

apply_ui(){
	cp -rf ${BASE_FOLDER}/webs/* /koolshare/webs/
	cp -rf ${BASE_FOLDER}/res/* /koolshare/res/
	rm -rf ${BASE_FOLDER} ${serverchan_info_text} ${app_file}
}

fan_control(){
	case $rog_fan_level in
	0)
		logger "[软件中心]手动控制：关闭${model}风扇！"
		killall fanCtl
		;;
	1|2|3|4)
		logger "[软件中心]手动控制：将${model}风扇调节至${rog_fan_level}挡！"
		killall fanCtl
		LD_PRELOAD=/rom/libnvram.so fanCtl $rog_fan_level 2>&1 &
		;;
	5)
		logger "[软件中心]手动控制：将${model}风扇调节至自动控制策略！"
		if [ -z "$(ps | grep fanCtl | grep -v grep)" ];then
			LD_PRELOAD=/rom/libnvram.so fanCtl -d >/dev/null 2>&1 &
		fi
		;;
	esac
}

case $2 in
1)
	sync
	echo 1 > /proc/sys/vm/drop_caches
	http_response "$1"
	;;
2)
	# switch UI
	rm -rf $LOG_FILE
	touch $LOG_FILE
	http_response "$1"
	switch_ui $3 | tee -a $LOG_FILE
	echo XU6J03M6 | tee -a $LOG_FILE
	;;
3)
	# fan control
	http_response "$1"
	fan_control
	;;
esac
