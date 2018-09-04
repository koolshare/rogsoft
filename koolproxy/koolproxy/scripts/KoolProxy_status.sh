#!/bin/sh

alias echo_date1='echo $(date +%Y年%m月%d日\ %X)'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval `dbus export koolproxy_`

version="koolproxy `koolproxy -v`"
status=`ps|grep -w koolproxy | grep -cv grep`
pid=`pidof koolproxy`
date=`echo_date1`

rules_date_local=`cat $KSROOT/koolproxy/data/rules/koolproxy.txt  | sed -n '3p'|awk '{print $3,$4}'`
rules_nu_local=`grep -E -v "^!" $KSROOT/koolproxy/data/rules/koolproxy.txt | wc -l`
video_date_local=`cat $KSROOT/koolproxy/data/rules/koolproxy.txt  | sed -n '4p'|awk '{print $3,$4}'`
daily_nu_local=`grep -E -v "^!" $KSROOT/koolproxy/data/rules/daily.txt | wc -l`
custom_nu_local=`grep -E -v "^!" $KSROOT/koolproxy/data/rules/user.txt | wc -l`

if [ "$status" == "2" ];then
	http_response "【$date】 $version  运行正常！(PID: $pid)@@<i>静态规则：</i><span>$rules_date_local / $rules_nu_local条</span>&nbsp;&nbsp;&nbsp;&nbsp;<i>视频规则：</i><span>$video_date_local<span>&nbsp;&nbsp;&nbsp;&nbsp;<i>每日/自定义规则：</i><span>$daily_nu_local条 / $custom_nu_local条</span>"
else
	http_response "<font color='#FF0000'>【警告】：进程未运行！请点击提交按钮！</font> @@<i>静态规则：</i><span>$rules_date_local / $rules_nu_local条</span>&nbsp;&nbsp;&nbsp;&nbsp;<i>视频规则：</i><span>$video_date_local<span>&nbsp;&nbsp;&nbsp;&nbsp;<i>每日/自定义规则：</i><span>$daily_nu_local条 / $custom_nu_local条</span>"
fi

