#! /bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval $(dbus export ddnsto)
ddnsto_status=`ps | grep -w ddnsto | grep -cv grep`
ddnsto_pid=`pidof ddnsto`
ddnsto_version=`/koolshare/bin/ddnsto -v`
ddnsto_route_id=`/koolshare/bin/ddnsto -w | awk '{print $2}'`
ddnsto_webdav_status=`ps | grep ddwebdav | grep -cv grep`
if [ "$ddnsto_status" == "2" ];then
    if [ "$ddnsto_webdav_status" == "1" ];then
        RESP="{\\\"version\\\": \\\"$ddnsto_version\\\",\\\"status\\\":1,\\\"router_id\\\":\\\"$ddnsto_route_id\\\", \\\"pid\\\":\\\"$ddnsto_pid\\\", \\\"feat\\\":{\\\"status\\\":\\\"1\\\",\\\"username\\\":\\\"$ddnsto_feat_username\\\",\\\"port\\\":\\\"$ddnsto_feat_port\\\",\\\"disk_path\\\":\\\"/webdav/\\\"}}"
    else
        RESP="{\\\"version\\\": \\\"$ddnsto_version\\\",\\\"status\\\":1,\\\"router_id\\\":\\\"$ddnsto_route_id\\\", \\\"pid\\\":\\\"$ddnsto_pid\\\", \\\"feat\\\":{\\\"status\\\":\\\"0\\\",\\\"username\\\":\\\"-\\\",\\\"disk_path\\\":\\\"未启用\\\"}}"
    fi
    
    
else
    RESP="{\\\"version\\\": \\\"$ddnsto_version\\\",\\\"status\\\":0,\\\"router_id\\\":\\\"$ddnsto_route_id\\\", \\\"pid\\\":\\\"$ddnsto_pid\\\", \\\"feat\\\":{\\\"status\\\":\\\"0\\\",\\\"username\\\":\\\"-\\\",\\\"disk_path\\\":\\\"未启用\\\"}}"
fi
http_response "${RESP}"
