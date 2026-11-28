#!/bin/sh
. /koolshare/scripts/base.sh
case "$1" in ''|*[!0-9]*) exit 1 ;; esac
case "$2" in direct|cdn) ;; *) http_response failed; exit 1 ;; esac
if /koolshare/bin/sc-endpoint "$2" >/dev/null; then
    http_response ok
else
    http_response failed
fi
