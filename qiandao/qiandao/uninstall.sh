#!/bin/sh

sed -i '/qiandao/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
rm -rf /koolshare/qiandao
rm -rf /koolshare/scripts/qiandao_config.sh
rm -rf /koolshare/webs/Module_qiandao.asp
rm -rf /koolshare/res/icon-qiandao.png
rm -rf /koolshare/res/qiandao_run.htm
rm -rf /koolshare/init.d/*qiandao.sh