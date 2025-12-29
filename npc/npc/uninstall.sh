#!/bin/sh
. /koolshare/scripts/base.sh

module="npc"

killall npc >/dev/null 2>&1
rm -f /var/run/npc.pid >/dev/null 2>&1

rm -f /koolshare/bin/npc
rm -f /koolshare/scripts/npc_config.sh
rm -f /koolshare/scripts/npc_status.sh
rm -f /koolshare/scripts/uninstall_${module}.sh
rm -f /koolshare/webs/Module_npc.asp
rm -f /koolshare/res/icon-npc.png
rm -f /koolshare/init.d/N99npc.sh

dbus remove npc_enable >/dev/null 2>&1
dbus remove npc_mode >/dev/null 2>&1
dbus remove npc_server_addr >/dev/null 2>&1
dbus remove npc_vkey >/dev/null 2>&1
dbus remove npc_conn_type >/dev/null 2>&1
dbus remove npc_auto_reconnection >/dev/null 2>&1
dbus remove npc_crypt >/dev/null 2>&1
dbus remove npc_compress >/dev/null 2>&1
dbus remove npc_disconnect_timeout >/dev/null 2>&1
dbus remove npc_log_level >/dev/null 2>&1
dbus remove npc_customize_conf >/dev/null 2>&1
dbus remove npc_config >/dev/null 2>&1
dbus remove npc_version >/dev/null 2>&1
dbus remove softcenter_module_npc_* >/dev/null 2>&1

rm -f /tmp/upload/.npc.conf /tmp/upload/npc.log /tmp/upload/npc_submit_log.txt >/dev/null 2>&1

exit 0

