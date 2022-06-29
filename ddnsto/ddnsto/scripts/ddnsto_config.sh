#!/bin/sh
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
eval $(dbus export ddnsto)
#-a -n "${ddnsto_feat_port}" -a -n "${ddnsto_feat_username}" -a -n "${ddnsto_feat_password}" -a -n "${ddnsto_feat_disk_path_selected}"
if [ -z "${ddnsto_feat_disk_path_selected}" ];then
disk_path="/tmp"
fi

case $ACTION in
start)
    if [ "${ddnsto_enable}" == "1" ];then
        if [ "${ddnsto_feat_enabled}" == "1" ] && [ -n "${ddnsto_feat_username}" ] && [ -n "${ddnsto_feat_port}" ] && [ -n "${ddnsto_feat_password}" ];then
            ddnsto -u $ddnsto_token  -n $ddnsto_feat_username -k $ddnsto_feat_password -p ${ddnsto_feat_port} -s $disk_path -d
        else
            ddnsto -u ${ddnsto_token} -d
        fi 
    fi
    ;;
*)
    if [ "${ddnsto_enable}" == "1" ];then
        killall ddnsto
        killall ddwebdav
        if [ "${ddnsto_feat_enabled}" == "1" ] && [ -n "${ddnsto_feat_username}" ] && [ -n "${ddnsto_feat_port}" ] && [ -n "${ddnsto_feat_password}" ];then
            ddnsto -u $ddnsto_token  -n $ddnsto_feat_username -k $ddnsto_feat_password -p ${ddnsto_feat_port} -s $disk_path -d
        else
            ddnsto -u ${ddnsto_token} -d
        fi 
    else
        killall ddnsto
        killall ddwebdav
    fi
    http_response "$1"
    ;;
esac