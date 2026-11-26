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
    links-begin|links-chunk|links-commit|links-cancel)
        # httpdb has a small request/command buffer. Stage short chunks, then
        # verify the complete upload and atomically replace the existing value.
        umask 077
        upload="$3"
        printf '%s' "$upload" | grep -Eq '^[a-f0-9]{32}$' || { respond "$rpc_id" '{"error":"invalid-upload"}'; exit 1; }
        root="${TMPDIR:-/tmp}/softcenter-ddnsto-uploads"
        mkdir -p "$root" || exit 1
        stage="$root/$upload"
        scope="$(printf '%s' "$(dbus get ddnsto_token)" | md5sum | awk '{print $1}')"
        links_key="softcenter_ddnsto_links_$scope"
        lock="${TMPDIR:-/tmp}/softcenter-ddnsto-links.lock"
        mkdir "$lock" 2>/dev/null || { respond "$rpc_id" '{"error":"busy"}'; exit 1; }
        trap 'rmdir "$lock"' EXIT
        fail() { respond "$rpc_id" "{\"error\":\"$1\"}"; exit 1; }
        case "$action" in
            links-begin)
                printf '%s' "$4" | grep -Eq '^[a-f0-9]{32}:[a-f0-9]{32}:[1-9][0-9]{0,4}:[a-f0-9]{32}$' || fail invalid-upload
                saved_scope="$(printf '%s' "$4" | cut -d: -f1)"
                expected="$(printf '%s' "$4" | cut -d: -f2)"
                size="$(printf '%s' "$4" | cut -d: -f3)"
                digest="$(printf '%s' "$4" | cut -d: -f4)"
                [ "$saved_scope" = "$scope" ] || fail changed
                [ "$size" -le 60000 ] || fail invalid-upload
                current="$(dbus get "$links_key")"
                [ "$(printf '%s' "$current" | md5sum | awk '{print $1}')" = "$expected" ] || fail changed
                # Abandoned uploads expire; they never become visible records.
                find "$root" -type f -mtime +1 -exec rm -f '{}' ';'
                mkdir "$stage" 2>/dev/null || fail upload-exists
                printf '%s\n' "$scope" "$expected" "$size" "$digest" > "$stage/meta" || fail stage-failed
                : > "$stage/data" || fail stage-failed
                ;;
            links-chunk|links-commit)
                [ -f "$stage/meta" ] && [ -f "$stage/data" ] || fail missing-upload
                saved_scope="$(sed -n '1p' "$stage/meta")"
                expected="$(sed -n '2p' "$stage/meta")"
                size="$(sed -n '3p' "$stage/meta")"
                digest="$(sed -n '4p' "$stage/meta")"
                [ "$scope" = "$saved_scope" ] || fail changed
                actual="$(wc -c < "$stage/data" | tr -d ' ')"
                if [ "$action" = links-chunk ]; then
                    [ "$4" = "$actual" ] || fail invalid-offset
                    [ -n "$5" ] && [ "${#5}" -le 256 ] || fail invalid-chunk
                    printf '%s' "$5" | grep -Eq '^[A-Za-z0-9+/=]+$' || fail invalid-chunk
                    [ "$((actual + ${#5}))" -le "$size" ] || fail invalid-size
                    printf '%s' "$5" >> "$stage/data" || fail stage-failed
                else
                    [ "$actual" = "$size" ] || fail incomplete-upload
                    next="$(cat "$stage/data")"
                    [ "$(printf '%s' "$next" | md5sum | awk '{print $1}')" = "$digest" ] || fail invalid-digest
                    printf '%s' "$next" | grep -Eq '^[A-Za-z0-9+/]+={0,2}$' || fail invalid-links
                    current="$(dbus get "$links_key")"
                    [ "$(printf '%s' "$current" | md5sum | awk '{print $1}')" = "$expected" ] || fail changed
                    dbus set "$links_key=$next" || fail save-failed
                    [ "$(dbus get "$links_key")" = "$next" ] || fail verify-failed
                    rm -f "$stage/meta" "$stage/data"
                    rmdir "$stage"
                fi
                ;;
            links-cancel)
                rm -f "$stage/meta" "$stage/data"
                [ ! -d "$stage" ] || rmdir "$stage"
                ;;
        esac
        respond "$rpc_id" "{\"scope\":\"$scope\",\"value\":\"\"}"
        ;;
    links-read|links-save)
        # Account-scoped metadata; never store account credentials in the payload.
        scope="$(printf '%s' "$(dbus get ddnsto_token)" | md5sum | awk '{print $1}')"
        links_key="softcenter_ddnsto_links_$scope"
        lock="${TMPDIR:-/tmp}/softcenter-ddnsto-links.lock"
        mkdir "$lock" 2>/dev/null || { respond "$rpc_id" '{"error":"busy"}'; exit 1; }
        trap 'rmdir "$lock"' EXIT
        value="$(dbus get "$links_key")"
        if [ "$action" = links-save ]; then
            expected="$4"; [ "$expected" != empty ] || expected=""
            if [ "$3" != "$scope" ] || [ "$expected" != "$value" ]; then
                respond "$rpc_id" '{"error":"changed"}'; exit 1
            fi
            next="$5"
            if [ -z "$next" ] || [ "${#next}" -gt 60000 ] ||
               ! printf '%s' "$next" | grep -Eq '^[A-Za-z0-9+/]+={0,2}$'; then
                respond "$rpc_id" '{"error":"invalid-links"}'; exit 1
            fi
            dbus set "$links_key=$next" || { respond "$rpc_id" '{"error":"save-failed"}'; exit 1; }
            value="$next"
        fi
        respond "$rpc_id" "{\"scope\":\"$scope\",\"value\":\"$value\"}"
        ;;
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
