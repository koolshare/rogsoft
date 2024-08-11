#!/bin/sh
# build script for rogsoft project
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"
ME=$(basename "$0")
VERSION=1.9.27

echo $VERSION > ./softcenter/.soft_ver

echo build version: ${VERSION}
rm -f softcenter.tar.gz

python ./gen_install.py stage1

# ----------------------------
if [ "$ME" = "build.sh" ];then
	# for hnd
	echo "build koolcenter for hnd"
	rm -rf $DIR/build
	mkdir -p $DIR/build
	cp -rf $DIR/softcenter $DIR/build/
	cd $DIR/build
	# copy files from softcenter
	cp -rf ${DIR}/../softcenter/softcenter/bin $DIR/build/softcenter/
	cp -rf ${DIR}/../softcenter/softcenter/bin-hnd $DIR/build/softcenter/bin
	cp -rf ${DIR}/../softcenter/softcenter/init.d $DIR/build/softcenter/
	cp -rf ${DIR}/../softcenter/softcenter/perp $DIR/build/softcenter/
	cp -rf ${DIR}/../softcenter/softcenter/scripts $DIR/build/softcenter/
	cp -rf ${DIR}/../softcenter/softcenter/install.sh $DIR/build/softcenter/
	cp -rf ${DIR}/../softcenter/softcenter/res/* $DIR/build/softcenter/res
	tar -zcf softcenter.tar.gz softcenter
	if [ "$?" = "0" ];then
		echo "build success!"
		mv $DIR/build/softcenter.tar.gz $DIR/
		cp -rf $DIR/softcenter.tar.gz $DIR/koolcenter.tar.gz
	fi
	rm -rf $DIR/build
	cd $DIR
elif [ "$ME" = "build_mtk.sh" ];then
	# for mtk
	echo "build koolcenter for mtk"
	rm -rf $DIR/build
	mkdir -p $DIR/build
	cp -rf $DIR/softcenter $DIR/build/
	cd $DIR/build
	# copy files from softcenter
	cp -rf ${DIR}/../softcenter/softcenter/bin $DIR/build/softcenter/
	cp -rf ${DIR}/../softcenter/softcenter/bin-mtk $DIR/build/softcenter/bin
	cp -rf ${DIR}/../softcenter/softcenter/init.d $DIR/build/softcenter/
	cp -rf ${DIR}/../softcenter/softcenter/perp $DIR/build/softcenter/
	cp -rf ${DIR}/../softcenter/softcenter/scripts $DIR/build/softcenter/
	cp -rf ${DIR}/../softcenter/softcenter/install.sh $DIR/build/softcenter/
	cp -rf ${DIR}/../softcenter/softcenter/res/* $DIR/build/softcenter/res	
	tar -zcf softcenter.tar.gz softcenter
	if [ "$?" = "0" ];then
		echo "build success!"
		mv $DIR/build/softcenter.tar.gz $DIR/
		cp -rf $DIR/softcenter.tar.gz $DIR/koolcenter.tar.gz
	fi
	rm -rf $DIR/build
	cd $DIR
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
