#!/bin/bash
set -e

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
exec bash "$root/softcenter/build_all.sh" "$@"
