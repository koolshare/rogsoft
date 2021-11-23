#! /bin/sh

killall shellinaboxd >/dev/null 2>&1

find /koolshare/init.d -name "*shellinabox*" | xargs rm -rf >/dev/null 2>&1
rm -rf /koolshare/shellinabox
rm -rf /koolshare/res/icon-shellinabox.png
rm -rf /koolsahre/scripts/shellinabox_config.sh
rm -rf /koolsahre/scripts/uninstall_shellinabox.sh
rm -rf /koolsahre/webs/Module_shellinabox.asp
