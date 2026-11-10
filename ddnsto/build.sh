#!/bin/sh
set -eu

# build script for rogsoft project

MODULE="ddnsto"
VERSION="4.2.8"
TITLE="ddnsto"
DESCRIPTION="ddnsto内网穿透"
HOME_URL="Module_ddnsto.asp"
TAGS="穿透 DDNS"
AUTHOR="xiaobao"
LINK="https://www.ddnsto.com"

DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
PLATFORM="${1-hnd}"

usage() {
    echo "Usage: sh $0 [hnd|mtk|ipq32|ipq64|qca]" >&2
    exit 1
}
[ "$#" -le 1 ] || usage
case "$PLATFORM" in
    hnd|mtk|ipq32|ipq64|qca) ;;
    *) usage ;;
esac

# Keep both architectures: install.sh selects using the router's uname -m.
# Check inputs before replacing any previously built package.
for binary in ddnsto_arm ddnsto_aarch64; do
    if [ ! -s "$DIR/$MODULE/bin/$binary" ] || [ ! -x "$DIR/$MODULE/bin/$binary" ]; then
        echo "Missing or non-executable binary: $DIR/$MODULE/bin/$binary" >&2
        exit 1
    fi
done
command -v python3 >/dev/null

BUILD_DIR=$(mktemp -d "$DIR/.build.XXXXXX")
trap 'rm -rf "$BUILD_DIR"' EXIT
trap 'exit 1' HUP INT TERM
cp -Rp "$DIR/$MODULE" "$BUILD_DIR/$MODULE"
printf '%s\n' "$PLATFORM" > "$BUILD_DIR/$MODULE/.valid"
printf '%s\n' "$VERSION" > "$BUILD_DIR/$MODULE/version"
(cd "$BUILD_DIR" && tar -zcf "$MODULE.tar.gz" "$MODULE")

MD5=$(python3 - "$BUILD_DIR/$MODULE.tar.gz" <<'PY'
import hashlib
import sys
with open(sys.argv[1], "rb") as package:
    print(hashlib.md5(package.read()).hexdigest())
PY
)
printf '%s\n%s\n' "$VERSION" "$MD5" > "$BUILD_DIR/version"
DATE=$(date +%Y-%m-%d_%H:%M:%S)
cat > "$BUILD_DIR/config.json.js" <<EOF
{
"version":"$VERSION",
"md5":"$MD5",
"home_url":"$HOME_URL",
"title":"$TITLE",
"description":"$DESCRIPTION",
"tags":"$TAGS",
"author":"$AUTHOR",
"link":"$LINK",
"changelog":"",
"build_date":"$DATE"
}
EOF

# Match other plugins' output contract for existing deploy callers.
mv -f "$BUILD_DIR/$MODULE.tar.gz" "$DIR/$MODULE.tar.gz"
mv -f "$BUILD_DIR/version" "$DIR/version"
mv -f "$BUILD_DIR/config.json.js" "$DIR/config.json.js"
python3 "$DIR/../softcenter/gen_install.py" stage2
echo "Built $MODULE $VERSION for $PLATFORM: $DIR/$MODULE.tar.gz"
