#!/bin/sh
. /koolshare/scripts/base.sh
set -e
src=$(cd "$(dirname "$0")" && pwd)
mkdir -p /koolshare/cdn
# Replace complete files so a concurrent cron invocation sees a complete script.
copy_file() {
    cp "$1" "$2.cdn-new" && chmod "$3" "$2.cdn-new" && mv -f "$2.cdn-new" "$2"
}
copy_file "$src/bin/cdn-watch" /koolshare/cdn/cdn-watch 755
copy_file "$src/cdn/endpoint.sh" /koolshare/cdn/endpoint.sh 755
copy_file "$src/scripts/cdn_config.sh" /koolshare/scripts/cdn_config.sh 755
copy_file "$src/init.d/S99cdn.sh" /koolshare/init.d/S99cdn.sh 755
copy_file "$src/webs/Module_cdn.asp" /koolshare/webs/Module_cdn.asp 644
copy_file "$src/res/icon-cdn.png" /koolshare/res/icon-cdn.png 644
copy_file "$src/uninstall.sh" /koolshare/scripts/uninstall_cdn.sh 755
dbus set softcenter_module_cdn_name=cdn
dbus set softcenter_module_cdn_title=软件中心CDN
dbus set 'softcenter_module_cdn_description=为软件中心配置 CDN，加快软件下载速度。'
dbus set "softcenter_module_cdn_version=$(cat "$src/version")"
dbus set softcenter_module_cdn_install=1
/koolshare/cdn/endpoint.sh boot
