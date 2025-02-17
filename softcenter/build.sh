#!/bin/bash
# build script for rogsoft project
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"
ME=$(basename "$0")
VERSION=1.9.16

echo $VERSION > ./softcenter/.soft_ver

echo build version: ${VERSION}
rm -f softcenter.tar.gz

python ./gen_install.py stage1

chmod 755 ./softcenter/scripts/ks_app_install.sh

# ----------------------------
rm -rf $DIR/build && mkdir -p $DIR/build
cp -rf ./softcenter ./build/ && cd ./build
if [ "$ME" = "build.sh" ];then
	# for hnd
	echo "build softcenter for hnd"
	cp -rf softcenter/bin-hnd/* softcenter/bin/
elif [ "$ME" = "build_ipq32.sh" ];then
	# for ipq3232
	echo "build softcenter for ipq32"
	cp -rf softcenter/bin-ipq32/* softcenter/bin/
elif [ "$ME" = "build_mtk.sh" ];then
	# for mtk
	echo "build softcenter for mtk"
	cp -rf softcenter/bin-mtk/* softcenter/bin/
elif [ "$ME" = "build_ipq64.sh" ];then
	# for ipq6432
	echo "build softcenter for ipq64"
	cp -rf softcenter/bin-ipq64/* softcenter/bin/
fi
rm -rf softcenter/bin-mtk
rm -rf softcenter/bin-hnd
rm -rf softcenter/bin-ipq32
rm -rf softcenter/bin-ipq64
tar -zcf softcenter.tar.gz softcenter
if [ "$?" = "0" ];then
	echo "build hnd success!"
	mv softcenter.tar.gz ..
fi
cd .. && rm -rf ./build
# ----------------------------

md5value=$(md5sum softcenter.tar.gz|awk '{print $1}')
cat > ./version <<EOF
$VERSION
$md5value
EOF

cat version

cat > ./config.json.js <<EOF
{
"version":"$VERSION",
"md5":"$md5value"
}
EOF

python ./gen_install.py stage2

cat to_remove.txt|xargs rm -f
rm to_remove.txt
