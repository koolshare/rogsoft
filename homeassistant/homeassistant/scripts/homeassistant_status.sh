#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval $(dbus export dockroot)
INST_NAME=homeassistant

DockRootBin="${dockroot_path_selected}/DockRootBin/DockRoot"
# 0:OK,1:DIR_NOT_FOUND,2:BIN_NOT_FOUND,3:BIN_ERROR
DockRootRet=1
version_output=
if [ -d ${dockroot_path_selected} ]; then
  DockRootRet=2
  if [ -f "$DockRootBin" ]; then
    DockRootRet=3
    version_output=$($DockRootBin -v 2>&1)
    if echo "$version_output" | grep -iq "version"; then
      DockRootRet=0
    fi
  fi
fi

if [ "$DockRootRet" -eq 0 ]; then
  PORT=8123
  PIDS=`${DockRootBin} ps ${INST_NAME}|tr -d '[:space:]'`
  if [ -z "$PIDS" ]; then
    DockRootRet=4
    if ps | grep -q "DockRoot pull homeassistant/home-assistant"; then
      DockRootRet=5
    fi
  fi
  RESP="{\\\"pids\\\":\\\"${PIDS}\\\",\\\"status\\\":${DockRootRet},\\\"port\\\":${PORT}}"
else
  PIDS=
  RESP="{\\\"pids\\\":\\\"${PIDS}\\\",\\\"status\\\":${DockRootRet}}"
fi

http_response "${RESP}"
