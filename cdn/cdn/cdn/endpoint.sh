#!/bin/sh
# Read-only status, explicit user selections, and compatibility with older installers.
PATH=/koolshare/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH
umask 077
state=/tmp/.softcenter-cdn
page=/koolshare/webs/Module_Softcenter.asp
core=/koolshare/cdn/endpoint.sh
watcher=/koolshare/cdn/cdn-watch
job=softcenter_cdn
mkdir -p "$state" || exit 1

note() {
    printf '%s  %s\n' "$(date '+%H:%M:%S')" "$*" >> "$state/log"
}
fail() {
    note "$1"
    printf '%s\n' "$1"
    exit 1
}
platform=$(cat /koolshare/.valid 2>/dev/null)
case "$platform" in
    hnd|hnd_v7|hnd_v8) repo=rogsoft ;;
    mtk|qca|ipq32|ipq64) repo=${platform}soft ;;
    *) repo= ;;
esac
direct="https://$repo.ddnsto.com"
edge="https://asusgo.koolcenter.com/$repo"
manager=/koolshare/bin/sc-endpoint
native=
if [ -x "$manager" ] && "$manager" capable; then native=cdn; fi

read_config() {
    db=$(dbus get softcenter_home_url) && pref=$(dbus get cdn_mode) || return 1
    if [ -n "$native" ]; then nv=$db; else nv=$(nvram get sc_url) || return 1; fi
}
center_type() {
    if [ ! -r "$page" ]; then
        echo unknown
    elif grep -Fq 'data["softcenter_home_url"] = "https://" + SOFT_ARCH + ".ddnsto.com";' "$page"; then
        # The center switcher can restore this old page on a newer core.
        echo legacy
    elif [ -n "$native" ] || grep -q 'nvram_get("sc_url")' "$page"; then
        echo configurable
    elif grep -q 'SOFT_ARCH.*\.ddnsto\.com' "$page"; then
        echo legacy
    else
        echo unknown
    fi
}
url_for() {
    case "$1" in direct) printf '%s' "$direct" ;; cdn) printf '%s' "$edge" ;; *) return 1 ;; esac
}
known_pair() {
    [ -n "$repo" ] || return 1
    [ -z "$native" ] || return 0
    for addr in "$nv" "$db"; do
        case "$addr" in ''|"$direct"|"$edge") ;; *) return 1 ;; esac
    done
}
write_nv() {
    if [ -n "$1" ]; then nvram set "sc_url=$1"; else nvram unset sc_url; fi
}
write_db() {
    if [ -n "$1" ]; then dbus set "softcenter_home_url=$1"; else dbus remove softcenter_home_url; fi
}
set_pair() {
    # Save read-back values for rollback if either write fails part way through.
    if [ "$db" != "$2" ]; then write_db "$2" || return 1; fi
    if [ "$nv" != "$1" ] && ! write_nv "$1"; then
        write_db "$db"
        return 1
    fi
    if [ "$(nvram get sc_url)" != "$1" ] || [ "$(dbus get softcenter_home_url)" != "$2" ]; then
        write_nv "$nv"; write_db "$db"
        return 1
    fi
}
busy() {
    [ -n "$(dbus get softcenter_installing_todo)" ] ||
        [ -n "$(dbus get softcenter_installing_name)" ]
}
status() {
    button=none
    active=unknown
    shown=${nv:-未设置}
    detail=
    if [ -z "$repo" ]; then
        detail="无法识别平台标记 $platform"
    elif [ "$kind" = legacy ]; then
        active=direct
        detail="此版本 softcenter 仅支持直连。请用 center 切换至 koolcenter 以启用 CDN。"
        [ "$pref" = cdn ] && button=direct
    elif [ "$kind" = unknown ] || ! known_pair; then
        detail="当前地址 $shown · 页面或地址未识别"
    else
        case "$shown" in
            "$edge") active=cdn; button=direct ;;
            "$direct") active=direct; button=cdn ;;
            *) detail="当前软件中心地址：${shown:-未设置}"; button=direct ;;
        esac
        if [ -z "$native" ] && [ "$pref" = cdn ] && [ "$shown" != "$edge" ]; then
            detail="已选 CDN，等待恢复。"; button=direct
        fi
        if [ -z "$native" ] && [ "$pref" = direct ] && [ "$shown" != "$direct" ]; then
            detail="已选直连，等待恢复。"; button=direct
        fi
        if [ -n "$db" ] && [ "$db" != "$shown" ]; then
            detail="${detail:+$detail }下载器记录 $db"
        fi
    fi
    if [ "$1" = json ]; then
        {
            last=
            if [ -f "$state/log" ]; then
                tail -n 24 "$state/log"
                last=$(tail -n 1 "$state/log")
            fi
            if [ -n "$2" ] && [ "$2" != "${last#*  }" ]; then printf '%s\n' "$2"; fi
        } |
            jq -Rsc --arg active "$active" --arg target "$button" --arg kind "$kind" \
                --arg direct "${repo:+$direct}" --arg cdn "${repo:+$edge}" --arg detail "$detail" \
                '{active:$active,target:$target,kind:$kind,direct:$direct,cdn:$cdn,detail:$detail,log:.}'
    else
        case "$active" in direct) summary="直连 · $direct" ;; cdn) summary="CDN · $edge" ;; *) summary= ;; esac
        [ "$kind" != legacy ] || summary="softcenter 固定直连 · $direct"
        if [ -n "$summary" ] && [ -n "$detail" ]; then summary="$summary · "; fi
        printf '%s\n%s\n' "$button" "$summary$detail"
        [ ! -f "$state/log" ] || tail -n 24 "$state/log"
    fi
}
fetch_catalog() {
    # Keep verbose output private. Only expose the attempted peer, phase and curl code.
    trace=$(curl -fsv --connect-timeout 6 --max-time 10 --max-filesize 2097152 \
        -w '\nSC_TIME %{time_connect} %{time_appconnect} %{http_code}\n' \
        -o "$state/probe" "$url" 2>&1)
    rc=$?
    [ "$rc" != 0 ] || return 0
    peer=$(printf '%s\n' "$trace" | awk '/^\* +Trying / {p=$3} END {sub(/\.\.\.$/, "", p); print p}')
    timings=$(printf '%s\n' "$trace" | awk '$1 == "SC_TIME" {print $2, $3, $4}')
    set -- $timings
    case "$rc" in
        5|6) reason="DNS 解析失败" ;;
        7) reason="无法连接 CDN 节点" ;;
        28)
            case "$1" in
                0|0.000000|'') if [ -n "$peer" ]; then reason="TCP 连接超时"; else reason="解析或建立连接超时"; fi ;;
                *) case "$2" in 0|0.000000|'') reason="TLS 握手超时" ;; *) reason="等待目录响应超时" ;; esac ;;
            esac ;;
        22) reason="目录返回 HTTP ${3:-错误}" ;;
        35|51|60|77|90|91) reason="TLS 握手或证书验证失败" ;;
        63) reason="目录超过大小限制" ;;
        *) reason="目录请求失败" ;;
    esac
    note "$reason${peer:+ · $peer}（curl $rc）"
    return "$rc"
}
probe() {
    model=$(nvram get odmpid)
    [ -n "$model" ] || model=$(nvram get productid)
    file=app.json.js
    [ "$model" != ZenWiFi_BD4 ] || file=app_nousb.json.js
    cb=__softcenterCatalog$$
    catalog=koolcenter
    if grep -Fq '/softcenter/app.json.js' "$page"; then catalog=softcenter; fi
    url="$edge/$catalog/$file?_nonce=$(date +%s)&callback=$cb"
    note "检查 $edge/$catalog/$file 的 HTTPS 和 JSONP 回调"
    # Treat the response as data. jq validates both the wrapper and catalog shape.
    fetch_catalog
    rc=$?
    case "$rc" in
        5|6|7|28) note "正在重试一次…"; fetch_catalog; rc=$? ;;
    esac
    if [ "$rc" = 0 ]; then
        jq -Rse --arg cb "$cb" '
          startswith($cb+"(") and (rtrimstr("\n") | endswith(");")) and
          (ltrimstr($cb+"(") | rtrimstr("\n") | rtrimstr(");") | fromjson |
           (.apps | type == "array") and (.version | type == "string"))
        ' "$state/probe" >/dev/null 2>&1
        rc=$?
        [ "$rc" = 0 ] || note "已收到 HTTPS 响应，但目录内容或 JSONP 回调不匹配。"
    fi
    rm -f "$state/probe"
    return "$rc"
}
watcher_exe() {
    pid=
    [ -r "$state/watch.pid" ] && read -r pid < "$state/watch.pid" || return 1
    case "$pid" in ''|*[!0-9]*) return 1 ;; esac
    exe=$(readlink "/proc/$pid/exe") || return 1
    [ "$exe" = "$watcher_real" ] || [ "$exe" = "$watcher_real (deleted)" ]
}
stop_watch() {
    if watcher_exe; then kill "$pid" 2>/dev/null || :; fi
    rm -f "$state/watch.pid"
}
ensure_watch() {
    if [ "$1" != cdn ] || [ -n "$native" ]; then stop_watch; return; fi
    if watcher_exe; then
        [ "$exe" != "$watcher_real" ] || return 0
        stop_watch
    fi
    [ -x "$watcher" ] || return 1
    # Do not let the sleeping worker retain the settings lock or httpdb pipes.
    (trap '' HUP; exec "$watcher" /tmp "$core") 9>&- </dev/null >/dev/null 2>&1 &
    pid=$!
    printf '%s\n' "$pid" > "$state/watch.pid" || { kill "$pid"; return 1; }
    # Catch an exec failure (wrong ABI, noexec mount) before saving a choice.
    for attempt in 1 2 3 4 5 6 7 8 9 10; do
        watcher_exe && [ "$exe" = "$watcher_real" ] && return 0
        kill -0 "$pid" 2>/dev/null || break
        /bin/busybox usleep 50000
    done
    stop_watch
    return 1
}
schedule() {
    if [ -n "$native" ] || [ -z "$1" ]; then
        stop_watch
        if cru l | grep -Fq "#$job#"; then cru d "$job" >/dev/null; fi
    else
        cru a "$job" "*/5 * * * * $core watchdog" >/dev/null && ensure_watch "$1"
    fi
}
choose() {
    mode=$1
    known_pair || fail "平台或现有服务器不在本平台支持范围，已保留原配置。"
    [ "$kind" != unknown ] || fail "未识别活动页面，已保留原配置。"
    if [ "$mode" = cdn ] && [ "$kind" = legacy ]; then
        fail "此页面无法切换 CDN，请通过 center 切至 koolcenter。"
    fi
    busy && fail "软件中心有安装或卸载任务，请在任务结束后重试。"
    if [ "$mode" = cdn ]; then
        probe || fail "CDN 目录验证失败，已保留原配置。"
    fi
    busy && fail "软件中心刚开始安装或卸载，请稍后重试。"
    read_config && known_pair || fail "检测到服务器配置变化，请刷新后重试。"
    [ "$(center_type)" = "$kind" ] || fail "活动软件中心已改变，请刷新后重试。"
    if [ -n "$native" ]; then
        "$manager" capable && "$manager" "$mode" >/dev/null || fail "地址保存失败，请刷新状态。"
        schedule "" || fail "地址已保存，旧兼容任务清理失败。"
        dbus set "cdn_mode=$mode" || fail "地址已保存，模式偏好保存失败。"
        note "已切换到 $(url_for "$mode")。请重新打开软件中心页面。"
        return 0
    fi
    if [ -z "$(dbus get cdn_original)" ]; then
        dbus set "cdn_original=$nv|$db" || fail "保存原配置失败。"
    fi
    target=$(url_for "$mode")
    previous_mode=$pref
    if ! schedule "$mode"; then
        schedule "$previous_mode"
        fail "设置兼容任务失败。"
    fi
    if ! set_pair "$target" "$target"; then
        schedule "$previous_mode"
        fail "更新服务器地址失败。"
    fi
    if ! dbus set "cdn_mode=$mode"; then
        set_pair_back_nv=$nv; set_pair_back_db=$db
        read_config && set_pair "$set_pair_back_nv" "$set_pair_back_db"
        schedule "$previous_mode"
        fail "保存偏好失败，已尝试恢复原配置。"
    fi
    note "已切换到 $target。请重新打开软件中心页面。"
}
reconcile() {
    case "$pref" in direct|cdn) ;; *) return 0 ;; esac
    if [ -n "$native" ]; then schedule ""; return; fi
    known_pair && [ "$kind" != unknown ] || return 0
    busy && return 0
    mode=$pref
    [ "$kind" != legacy ] || mode=direct
    target=$(url_for "$mode")
    if [ "$target" != "$nv" ] || [ "$target" != "$db" ]; then
        set_pair "$target" "$target" || return 1
        note "已按活动页面恢复 $target"
    fi
}
remove_settings() {
    original=$(dbus get cdn_original)
    if [ -z "$native" ] && known_pair && [ -n "$pref" ] && [ -n "$original" ]; then
        set_pair "${original%%|*}" "${original#*|}" || return 1
    fi
    schedule "" || return 1
    dbus remove cdn_mode && dbus remove cdn_original || return 1
    rm -f "$state/log" "$state/probe"
}

if [ "$1" = status ]; then
    read_config || exit 1
    kind=$(center_type)
    status "$2" "$3"
    exit $?
fi
exec 9>"$state/lock"
case "$1" in
    direct|cdn)
        # A completion callback may be finishing a short read-back. BusyBox
        # flock has no timed wait on these firmwares.
        tries=0
        until flock -n 9; do
            [ "$tries" -lt 10 ] || { echo '另一项切换正在进行，请稍后重试。'; exit 1; }
            /bin/busybox usleep 50000
            tries=$((tries + 1))
        done
        ;;
    *) flock 9 || exit 1 ;;
esac
# /koolshare is a symlink on supported firmwares. /proc/PID/exe is canonical.
watcher_real=$(readlink -f "$watcher")
if [ "$1" = stop ]; then stop_watch; exit; fi
read_config || fail "无法读取软件中心配置。"
kind=$(center_type)
# Bound the volatile log, including after long-running reconcile jobs.
if [ -f "$state/log" ] && [ "$(wc -l < "$state/log")" -gt 64 ]; then
    tail -n 24 "$state/log" > "$state/log.trim" && mv "$state/log.trim" "$state/log"
fi
case "$1" in
    direct|cdn) choose "$1" ;;
    reconcile|install-event) reconcile ;;
    watchdog) ensure_watch "$pref"; reconcile ;;
    boot)
        if [ -z "$native" ] && [ "$(cat /koolshare/.sc_endpoint_default 2>/dev/null)" = cdn ]; then
            rm -f /koolshare/.sc_endpoint_default
        fi
        schedule "$pref" && reconcile ;;
    remove) remove_settings ;;
    *) exit 1 ;;
esac
