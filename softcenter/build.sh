#!/bin/bash
# build script for rogsoft project
MODULE="softcenter"
VERSION=1.9.26

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"
ME=$(basename "$0")
PLATFORM=$(echo "${ME}" | awk -F"." '{print $1}' | sed 's/build_//g')

if [ "${ME}" = "build.sh" ];then
	echo "build error!"
	exit 1
fi

echo ${VERSION} > ${DIR}/softcenter/.soft_ver

echo build version: ${VERSION}
rm -f ${DIR}/softcenter.tar.gz

python ./gen_install.py stage1

# ----------------------------
rm -rf ${DIR}/build && mkdir -p ${DIR}/build
cp -rf ${DIR}/softcenter ${DIR}/build/ && cd ${DIR}/build
echo "build softcenter for ${PLATFORM}"
echo ${PLATFORM} >${DIR}/build/softcenter/.valid
cp -rf softcenter/bin-${PLATFORM}/* softcenter/bin/
rm -rf ${DIR}/build/softcenter/bin-*
tar -zcf softcenter.tar.gz softcenter
if [ "$?" = "0" ];then
	echo "build success!"
	mv ${DIR}/build/softcenter.tar.gz ${DIR}
fi
cd ${DIR} && rm -rf ${DIR}/build
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
