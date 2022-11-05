#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'

echo_date "删除tailscale插件相关文件！"
rm -rf /tmp/tailscale* >/dev/null 2>&1
rm -rf /koolshare/bin/tailscale* >/dev/null 2>&1
rm -rf /koolshare/res/icon-tailscale.png >/dev/null 2>&1
rm -rf /koolshare/scripts/tailscale_* >/dev/null 2>&1
rm -rf /koolshare/scripts/uninstall_tailscale.sh >/dev/null 2>&1
rm -rf /koolshare/webs/Module_tailscale.asp >/dev/null 2>&1
find /koolshare/init.d -name "*tailscale*" | xargs rm -rf

echo_date "tailscale插件卸载成功！"
echo_date "-------------------------------------------"
echo_date "卸载保留了tailscale配置文件夹: /koolshare/configs/tailscale"
echo_date "如果你希望重装tailscale插件后，完全重新配置tailscale"
echo_date "请重装插件前手动删除文件夹/koolshare/configs/tailscale"
echo_date "-------------------------------------------"
