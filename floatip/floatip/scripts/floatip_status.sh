#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval $(dbus export floatip)
floatip_status=`ps | grep -w floatip_bin | grep -cv grep`
floatip_pid=`pidof floatip_bin`
floatip_version=`/koolshare/bin/floatip_bin -v`
if [ "$floatip_status" == "1" ];then
    RESP="{\\\"version\\\": \\\"$floatip_version\\\",\\\"status\\\":1, \\\"pid\\\":\\\"$floatip_pid\\\"}"
    
else
    RESP="{\\\"version\\\": \\\"$floatip_version\\\",\\\"status\\\":0}"

fi
http_response "${RESP}"
