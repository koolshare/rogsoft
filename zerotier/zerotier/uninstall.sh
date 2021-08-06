#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'

echo_date "删除zerotier插件相关文件！"
rm -rf /tmp/zerotier* >/dev/null 2>&1
rm -rf /koolshare/bin/file >/dev/null 2>&1
rm -rf /koolshare/bin/zerotier* >/dev/null 2>&1
rm -rf /koolshare/res/icon-zerotier.png >/dev/null 2>&1
rm -rf /koolshare/res/zt_*.png >/dev/null 2>&1
rm -rf /koolshare/scripts/zerotier_* >/dev/null 2>&1
rm -rf /koolshare/scripts/uninstall_zerotier.sh >/dev/null 2>&1
rm -rf /koolshare/webs/Module_zerotier.asp >/dev/null 2>&1
rm -rf /koolshare/share/misc/magic >/dev/null 2>&1
find /koolshare/init.d -name "*zerotier*" | xargs rm -rf

if [ -d "/koolshare/share" ];then
	local FLAG_1=$(ls -aelR /koolshare/share | sed '/:$/d' | sed '/^$/d' | sed '/^d/d' 2>/dev/null)
	if [ -z "$FLAG_1" ];then
		rm -rf /koolshare/share
	fi
fi

if [ -d "/koolshare/lib" ];then
	cd /koolshare/lib
	if [ -f "/koolshare/lib/.flag_zerotier.txt" ];then
		echo_date "删除zerotier插件相关依赖！"
		cat .flag_*.txt | sort -k2 | uniq -f1 -u | grep -E "^zerotier" | awk '{print $2}' | xargs rm -rf >/dev/null 2>&1
		rm -rf .flag_zerotier.txt
	fi
	if [ -z "$(ls)" ];then
		cd /
		rm -rf /koolshare/lib
	fi
fi

echo_date "zerotier插件卸载成功！"
echo_date "-------------------------------------------"
echo_date "卸载保留了zerotier配置文件夹: /koolshare/configs/zerotier-one"
echo_date "如果你希望重装zerotier插件后，完全重新配置zerotier"
echo_date "或者你希望更改本机的zerotier peer id"
echo_date "请重装插件前手动删除文件夹/koolshare/configs/zerotier-one"
echo_date "-------------------------------------------"
