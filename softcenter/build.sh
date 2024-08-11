#!/bin/bash
# build script for rogsoft project
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"
ME=$(basename "$0")
VERSION=1.9.5

echo $VERSION > ./softcenter/.soft_ver

echo build version: ${VERSION}
rm -f softcenter.tar.gz

python ./gen_install.py stage1

chmod 755 ./softcenter/scripts/ks_app_install.sh

# ----------------------------
# for mtk
if [ "$ME" = "build.sh" ];then
	echo "build softcenter for hnd"
	rm -rf $DIR/build
	mkdir -p $DIR/build
	cp -rf ./softcenter ./build/
	cd ./build
	cp -rf softcenter/bin-hnd/* softcenter/bin/
	rm -rf softcenter/bin-hnd
	tar -zcf softcenter.tar.gz softcenter
	if [ "$?" = "0" ];then
		echo "build hnd success!"
		mv softcenter.tar.gz ..
	fi
	cd ..
	rm -rf ./build
elif [ "$ME" = "build_mtk.sh" ];then
	echo "build softcenter for mtk"
	rm -rf $DIR/build
	mkdir -p $DIR/build
	cp -rf ./softcenter ./build/
	cd ./build
	cp -rf softcenter/bin-mtk/* softcenter/bin/
	rm -rf softcenter/bin-mtk
	tar -zcf softcenter.tar.gz softcenter
	if [ "$?" = "0" ];then
		echo "build mtk success!"
		mv softcenter.tar.gz ..
	fi
	cd ..
	rm -rf ./build
fi
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
