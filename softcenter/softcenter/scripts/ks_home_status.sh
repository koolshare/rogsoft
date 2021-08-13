#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

_get_model(){
  local odmpid=$(nvram get odmpid)
  local MODEL=$(nvram get productid)
  local _tmp="unknow"
  if [ -n "${odmpid}" ];then
    _tmp=$(echo "${odmpid}"|tr '[A-Z]-' '[a-z]_')
  else
    _tmp=$(echo "${MODEL}"|tr '[A-Z]-' '[a-z]_')
  fi
  echo ${_tmp}
}

_get_mac(){
  local MACADDR=$(nvram get et0macaddr)||"FF:FF:FF:FF:FF:FF"
  local _MACMD5=$(echo $MACADDR|md5sum)
  local _MACMD5=${_MACMD5% -}
  echo $_MACMD5
}

get_current_jffs_status(){
  local cur_patition=$(df | /bin/grep /jffs)
  if [ -n "${cur_patition}" ];then
    JFFS_USED=$(echo ${cur_patition} | awk '{print $3}')
    JFFS_TOTAL=$(echo ${cur_patition} | awk '{print $2}')
  else
    JFFS_USED=0
    JFFS_TOTAL=0
  fi
}

eval $(dbus export ddnsto_)
DDNSTO_URL=${ddnsto_url}
if [ -z "${DDNSTO_URL}" ]; then
  UQ_ID=$(_get_mac)
  DDNSTO_URL=$(echo "https://asus-${UQ_ID:0:8}.kooldns.cn")
fi

DDNSTO_INSTALL=$(dbus get softcenter_module_ddnsto_install)
if [ -n "${DDNSTO_INSTALL}" ]; then
  if [ ! -f "/koolshare/bin/ddnsto" ]; then
    DDNSTO_INSTALL=0
  fi
else
  DDNSTO_INSTALL=0
fi

DDNSTO_STATUS=$(ps | grep -w ddnsto | grep -cv grep)
DDNSTO_PID=$(pidof ddnsto)

BOOT_CFG=$(nvram get ddnsto_boot_cfg)
DDNSTO_DEVICE_ID=
if [ -n "${BOOT_CFG}" ]; then
  DDNSTO_DEVICE_ID=$(/koolshare/bin/ddnsto -w|cut -d ' ' -f2)
fi

get_current_jffs_status

RESP=$(echo '{\"ddnsto_url\":\"'${DDNSTO_URL}'\",\"ddnsto_token\":\"'${ddnsto_token}'\",\"ddnsto_install\":'${DDNSTO_INSTALL}',\"ddnsto_status\":'${DDNSTO_STATUS}',\"ddnsto_device_id\":\"'${DDNSTO_DEVICE_ID}'\",\"ddnsto_pid\":\"'${DDNSTO_PID}'\",\"jffs_used\":\"'${JFFS_USED}'\",\"jffs_total\":\"'${JFFS_TOTAL}'\"}')
http_response "${RESP}"
