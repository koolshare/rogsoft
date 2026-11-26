#!/bin/bash
# Compatibility entry point for building the HND checkout in place.
set -eo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
SCRIPT_DIR=
candidates=("$root/../asusgo-build" "$root/../../asusgo-build")
if [[ -n ${ASUSGO_BUILD_ROOT:-} ]]; then candidates=("$ASUSGO_BUILD_ROOT"); fi
for tools in "${candidates[@]}"; do
    if [[ -f $tools/build.py && -f $tools/lib/plugin_runtime.py && -f $tools/lib/platform-deploy.sh ]]; then
        SCRIPT_DIR=$(cd -- "$tools" && pwd -P)
        break
    fi
done
if [[ -z ${SCRIPT_DIR:-} ]]; then
    printf '请将 ASUSGO_BUILD_ROOT 指向新版 asusgo-build 工具目录。\n' >&2
    exit 1
fi
TOOL_PATH=$SCRIPT_DIR
. "$SCRIPT_DIR/lib/platform-deploy.sh"

load_platform_profile rogsoft
GIT_PATH=$root
acquire_workspace_lock "$GIT_PATH" "${0##*/}"
RULE_ICON_DIR=$(mktemp -d)
trap 'rm -rf -- "$RULE_ICON_DIR"' EXIT
rebuild_prepare
rebuild_modules
rebuild_platform_center softcenter
rebuild_platform_center koolcenter
