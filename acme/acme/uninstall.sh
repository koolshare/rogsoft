#!/bin/sh

sed -i '/acme/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
rm -rf /koolshare/acme
rm -rf /koolshare/scripts/acme_config.sh
rm -rf /koolshare/webs/Module_acme.asp
rm -rf /koolshare/res/icon-acme.png
rm -rf /koolshare/init.d/*acme.sh