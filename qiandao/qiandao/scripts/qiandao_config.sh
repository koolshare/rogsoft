#!/bin/sh
source /koolshare/scripts/base.sh
eval `dbus export qiandao_`
qiandao_root="/koolshare/qiandao"
LOGFILE="/tmp/upload/qiandao_log.txt"
SETTING_FILE="/tmp/cookie.txt"
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
mkdir -p /tmp/upload/

generate_cookie_conf(){
	echo_date "生成签到配置文件到/tmp/cookie.txt" >> $LOGFILE
	rm -rf $SETTING_FILE
	rm -rf $qiandao_root/cookie.txt
	[ "$qiandao_koolshare" == "1" ] && [ -n "$qiandao_koolshare_setting" ] && echo -e "\"koolshare\"=`echo $qiandao_koolshare_setting | base64_decode`" >> $SETTING_FILE
	[ "$qiandao_baidu" == "1" ] && [ -n "$qiandao_baidu_setting" ] && echo -e "\"baidu\"=`echo $qiandao_baidu_setting | base64_decode`" >> $SETTING_FILE
	[ "$qiandao_v2ex" == "1" ] && [ -n "$qiandao_v2ex_setting" ] && echo -e "\"v2ex\"=`echo $qiandao_v2ex_setting | base64_decode`" >> $SETTING_FILE
	[ "$qiandao_hostloc" == "1" ] && [ -n "$qiandao_hostloc_setting" ] && echo -e "\"hostloc\"=`echo $qiandao_hostloc_setting | base64_decode`" >> $SETTING_FILE
	[ "$qiandao_acfun" == "1" ] && [ -n "$qiandao_acfun_setting" ] && echo -e "\"acfun\"=`echo $qiandao_acfun_setting | base64_decode`" >> $SETTING_FILE
	[ "$qiandao_bilibili" == "1" ] && [ -n "$qiandao_bilibili_setting" ] && echo -e "\"bilibili\"=`echo $qiandao_bilibili_setting | base64_decode`" >> $SETTING_FILE
	[ "$qiandao_smzdm" == "1" ] && [ -n "$qiandao_smzdm_setting" ] && echo -e "\"smzdm\"=`echo $qiandao_smzdm_setting | base64_decode`" >> $SETTING_FILE
	[ "$qiandao_xiami" == "1" ] && [ -n "$qiandao_xiami_setting" ] && echo -e "\"xiami\"=`echo $qiandao_xiami_setting | base64_decode`" >> $SETTING_FILE
	[ "$qiandao_163music" == "1" ] && [ -n "$qiandao_163music_setting" ] && echo -e "\"163music\"=`echo $qiandao_163music_setting | base64_decode`" >> $SETTING_FILE
	[ "$qiandao_miui" == "1" ] && [ -n "$qiandao_miui_setting" ] && echo -e "\"miui\"=`echo $qiandao_miui_setting | base64_decode`" >> $SETTING_FILE
	[ "$qiandao_52pojie" == "1" ] && [ -n "$qiandao_52pojie_setting" ] && echo -e "\"52pojie\"=`echo $qiandao_52pojie_setting | base64_decode`" >> $SETTING_FILE
	[ "$qiandao_kafan" == "1" ] && [ -n "$qiandao_kafan_setting" ] && echo -e "\"kafan\"=`echo $qiandao_kafan_setting | base64_decode`" >> $SETTING_FILE
	[ "$qiandao_right" == "1" ] && [ -n "$qiandao_right_setting" ] && echo -e "\"right\"=`echo $qiandao_right_setting | base64_decode`" >> $SETTING_FILE
	[ "$qiandao_mydigit" == "1" ] && [ -n "$qiandao_mydigit_setting" ] && echo -e "\"mydigit\"=`echo $qiandao_mydigit_setting | base64_decode`" >> $SETTING_FILE
	if [ -f "$SETTING_FILE" ];then
		ln -sf $SETTING_FILE $qiandao_root/cookie.txt
	else
		echo_date "检测到你没有填写任何cookie配置！关闭插件！" >> $LOGFILE
		dbus set qiandao_enable="0"
		echo "------------------------------ koolshare merlin 自动签到程序 -------------------------------" >> $LOGFILE
		echo XU6J03M6 >> $LOGFILE
		exit 1
	fi
}

start_sign(){
	echo_date "开始签到..." >> $LOGFILE
	cd $qiandao_root && ./qiandao
}

add_cron(){
	echo_date "添加签到定时任务，每天 $qiandao_time 点自动签到..." >> $LOGFILE
	sed -i '/qiandao/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	cru a qiandao "0 $qiandao_time * * * /koolshare/scripts/qiandao_config.sh"
}

del_cron(){
	echo_date "删除签到定时任务！" >> $LOGFILE
	sed -i '/qiandao/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
}

case $1 in
start)
	# 开机启动
	if [ "$qiandao_enable" == "1" ];then
		logger "检测到自动签到插件开启，添加自动签到定时任务"
		add_cron
	else
		logger "自动签到插件未开启，跳过！"
	fi
	;;
*)
	# web提交
	echo "------------------------------ koolshare merlin 自动签到程序 -------------------------------" > $LOGFILE
	http_response "$1"
	echo "" >> $LOGFILE
	[ ! -L "/koolshare/init.d/S99qiandao.sh" ] && ln -sf /koolshare/scripts/qiandao_config.sh /koolshare/init.d/S99qiandao.sh
	if [ "$qiandao_enable" == "1" ];then
		if [ "$qiandao_action" == "2" ];then
			echo_date "保存设置并立即签到！" >> $LOGFILE
			generate_cookie_conf >> $LOGFILE
			start_sign >> $LOGFILE
			add_cron >> $LOGFILE
			echo_date "签到完成，实际签到成功与否以相应网站显示结果为准！" >> $LOGFILE
		else
			echo_date "仅保存设置，签到将在你设定的时间进行..." >> $LOGFILE
			generate_cookie_conf >> $LOGFILE
			add_cron >> $LOGFILE
			dbus set qiandao_action="2"
			echo_date "保存完毕..." >> $LOGFILE
		fi
	else
		echo_date "停止定时签到！" >> $LOGFILE
		del_cron >> $LOGFILE
		echo_date "关闭成功！" >> $LOGFILE
	fi
	echo "" >> $LOGFILE
	echo "------------------------------ koolshare merlin 自动签到程序 -------------------------------" >> $LOGFILE
	echo XU6J03M6 >> $LOGFILE
	;;
esac
