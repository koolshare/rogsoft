#!/bin/sh
. /koolshare/scripts/base.sh
case "$1" in ''|*[!0-9]*) exit 1 ;; esac
case "$2" in status|direct|cdn) ;; *) exit 1 ;; esac
core=/koolshare/cdn/endpoint.sh
message=
if [ "$2" != status ]; then
    message=$("$core" "$2" 2>&1) || message=${message:-切换未完成，请查看日志。}
fi
# httpdb accepts a string. Keep line breaks and Chinese text intact across versions.
if [ "$3" = json ]; then
    reply=$("$core" status json "$message" | /bin/busybox base64 | tr -d '\n')
else
    reply=$({ "$core" status; printf '%s\n' "$message"; } | /bin/busybox base64 | tr -d '\n')
fi
http_response "$reply"
