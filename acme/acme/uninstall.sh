#!/bin/sh

# stop
sed -i '/acme/d' /var/spool/cron/crontabs/* >/dev/null 2>&1

# remove files
rm -rf /koolshare/acme >/dev/null 2>&1
rm -rf /koolshare/scripts/acme_config.sh >/dev/null 2>&1
rm -rf /koolshare/webs/Module_acme.asp >/dev/null 2>&1
rm -rf /koolshare/res/icon-acme.png >/dev/null 2>&1
find /koolshare/init.d -name "*acme*" | xargs rm -rf >/dev/null 2>&1

# remove myself
rm -rf /koolshare/scripts/uninstall_acme.sh >/dev/null 2>&1
