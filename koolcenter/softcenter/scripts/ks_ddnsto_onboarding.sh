#!/bin/sh
# Persist onboarding drafts and confirmed URLs without restarting DDNSTO.
# One dbus value makes reads/writes atomic. Prefix and LAN target are validated
# before storage, so no untrusted JSON or shell text is interpolated.
[ -z "$1" ] || . /koolshare/scripts/base.sh
key=softcenter_ddnsto_onboarding
respond() {
    if [ -n "$1" ]; then
        # httpdb wraps the response in a JSON string without escaping it.
        escaped="$(printf '%s' "$2" | sed 's/\\/\\\\/g; s/"/\\"/g')"
        http_response "$escaped"
    else printf '%s\n' "$2"; fi
}
rpc_id="$1"
action="${2:-read}"
read_current() {
    current="$(dbus get "$key")"
    case "$current" in b64:*) current="$(printf '%s' "${current#b64:}" | base64 -d)" ;; esac
}
read_current
case "$action" in
    domain)
        # URL is display/navigation metadata, not tunnel configuration.
        url="$3"
        if ! printf '%s' "$url" | grep -Eq '^https?://[a-zA-Z0-9.-]+(:[0-9]{1,5})?/?$'; then
            respond "$rpc_id" 'invalid-domain'; exit 1
        fi
        dbus set "ddnsto_url=$url" || { respond "$rpc_id" 'save-failed'; exit 1; }
        respond "$rpc_id" "${rpc_id:-ok}"
        ;;
    target)
        lan="$(nvram get lan_ipaddr)"
        port="$(nvram get http_lanport)"
        case "$lan:$port" in *[!0-9.:]*|:*) respond "$rpc_id" 'invalid-target'; exit 1 ;; esac
        respond "$rpc_id" "http://$lan:${port:-80}"
        ;;
    read) respond "$rpc_id" "${current:-null}" ;;
    save|uncertain|pending|clear)
        lock="${TMPDIR:-/tmp}/softcenter-ddnsto-onboarding.lock"
        mkdir "$lock" 2>/dev/null || { respond "$rpc_id" '{"error":"busy"}'; exit 1; }
        trap 'rmdir "$lock"' EXIT
        read_current
        prefix="$3"
        target="$4"
        if ! printf '%s' "$prefix" | grep -Eq '^[a-z0-9][a-z0-9-]{4,28}[a-z0-9]$' ||
           ! printf '%s' "$target" | grep -Eq '^https?://[a-zA-Z0-9.-]+:[0-9]{1,5}$'; then
            respond "$rpc_id" '{"error":"invalid-draft"}'; exit 1
        fi
        pending="{\"prefix\":\"$prefix\",\"target\":\"$target\",\"state\":\"pending\"}"
        uncertain="{\"prefix\":\"$prefix\",\"target\":\"$target\",\"state\":\"uncertain\"}"
        if [ "$action" = save ]; then
            case "$current" in *'"state":"uncertain"'*) respond "$rpc_id" '{"error":"query-first"}'; exit 1 ;; esac
        elif [ "$current" != "$pending" ] && [ "$current" != "$uncertain" ]; then
            respond "$rpc_id" '{"error":"draft-changed"}'; exit 1
        fi
        if [ "$action" = uncertain ] && [ "$current" != "$pending" ]; then
            respond "$rpc_id" '{"error":"query-first"}'; exit 1
        fi
        case "$action" in
            uncertain) next="$uncertain" ;;
            clear) next=null ;;
            *) next="$pending" ;;
        esac
        encoded="b64:$(printf '%s' "$next" | base64 | tr -d '\n')"
        dbus set "$key=$encoded" || { respond "$rpc_id" '{"error":"save-failed"}'; exit 1; }
        respond "$rpc_id" "$next"
        ;;
    *) respond "$rpc_id" '{"error":"invalid-action"}'; exit 1 ;;
esac
