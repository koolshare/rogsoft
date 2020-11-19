#!/bin/sh
# 本模块为公共的发送请求的模块，被其他模块通过source调用即可，通过全局变量routerhook_send_content传递需要发送的内容即可

routerhook_var_timestamp=$(date '+%s')
routerhook_var_gmt=$(date -u '+%a, %d %b %Y %T GMT')

replace_var() {
    temp_var=$*
    temp_var=${temp_var//_PRM_EVENT/$msg_type}
    temp_var=${temp_var//_PRM_DT/$routerhook_var_gmt}
    temp_var=${temp_var//_PRM_TS/$routerhook_var_timestamp}
    echo $temp_var
}

header='-H "content-type:application/json"'
header_nu=$(dbus list routerhook_config_header_key | sort -n -t "_" -k 4 | cut -d "=" -f 1 | cut -d "_" -f 5)
for nu in ${header_nu}; do
    temp=$(dbus get routerhook_config_header_key_${nu})
    header_key=$(replace_var $temp)
    temp=$(dbus get routerhook_config_header_val_${nu})
    header_val=$(replace_var $temp)
    header="${header} -H \"${header_key}:${header_val}\""
done

url_wl=$(dbus list routerhook_sm_url | cut -d "=" -f 2 | sed 's/\,/ /g')
url_nu=$(dbus list routerhook_config_sckey | sort -n -t "_" -k 4 | cut -d "=" -f 1 | cut -d "_" -f 4)
for nu in ${url_nu}; do
    if [[ -n $(echo $msg_type | grep "rh_") ]] && [[ -n "${url_wl}" ]]; then
        check=$(echo $url_wl | grep "[[:alpha:]]\?${nu}[[:alpha:]]\?")
        if [[ "${check}" == "" ]]; then
            continue
        fi
    fi
    temp=$(dbus get routerhook_config_sckey_${nu})
    url=$(replace_var $temp)
    reqstr="curl ${header} -X POST -d '"${routerhook_send_content}"' ${url}"
    result=$(eval ${reqstr})
    if [[ -n "$(echo $result | grep "success")" ]]; then
        [ "${routerhook_info_logger}" == "1" ] && logger "[routerhook]: ${msg_type}推送到 URL No.${nu} 成功！"
    else
        [ "${routerhook_info_logger}" == "1" ] && logger "[routerhook]: ${msg_type}推送到 URL No.${nu} 失败！返回结果为：${result}"
    fi
done
