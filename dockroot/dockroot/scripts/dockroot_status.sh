#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval $(dbus export dockroot)
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

RESP="{\\\"version\\\": \\\"$version_output\\\",\\\"status\\\":$DockRootRet}"
http_response "${RESP}"
