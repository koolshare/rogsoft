#!/bin/sh
# Read-only discovery: never call the plugin launcher or change configuration.
if ! pidof shellinaboxd >/dev/null 2>&1; then
    status="Shellinabox 未运行"
elif curl -fsS --max-time 2 -o /dev/null http://127.0.0.1:4200/; then
    status="Shellinabox 运行正常"
else
    status="Shellinabox 健康检查失败"
fi

if [ -n "$1" ]; then
    . /koolshare/scripts/base.sh
    http_response "$status"
else
    printf '%s\n' "$status"
fi
