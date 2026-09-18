#!/bin/sh
# build script for rogsoft project
set -eu

VERSION=1.9.58

DIR="$(cd "$(dirname "$0")" && pwd)"
ME=$(basename "$0")
PLATFORM=$(echo "${ME}" | awk -F"." '{print $1}' | sed 's/build_//g')
cd "${DIR}"

if [ "${ME}" = "build.sh" ];then
	echo "build error!"
	exit 1
fi

echo ${VERSION} > ./softcenter/.soft_ver

echo build version: ${VERSION}
rm -f ${DIR}/softcenter.tar.gz

python3 ./gen_install.py stage1

# --------------------------------------------------------
rm -rf ${DIR}/build && mkdir -p ${DIR}/build
cp -rf ${DIR}/softcenter ${DIR}/build/ && cd ${DIR}/build
echo "build koolcenter for ${PLATFORM}"
echo ${PLATFORM} >${DIR}/build/softcenter/.valid
cp -rf ${DIR}/../softcenter/softcenter/bin ${DIR}/build/softcenter/
cp -rf ${DIR}/../softcenter/softcenter/bin-${PLATFORM}/* ${DIR}/build/softcenter/bin/
cp -rf ${DIR}/../softcenter/softcenter/init.d ${DIR}/build/softcenter/
cp -rf ${DIR}/../softcenter/softcenter/perp ${DIR}/build/softcenter/
cp -rf ${DIR}/../softcenter/softcenter/scripts ${DIR}/build/softcenter/
cp -rf ${DIR}/../softcenter/softcenter/install.sh ${DIR}/build/softcenter/
cp -rf ${DIR}/../softcenter/softcenter/res/* ${DIR}/build/softcenter/res
rm -rf ${DIR}/build/softcenter/res/icon-*.png
python3 ${DIR}/create_deterministic_tar.py ${DIR}/build/softcenter ${DIR}/build/softcenter.tar.gz
echo "build success!"
mv ${DIR}/build/softcenter.tar.gz ${DIR}/
cp -f ${DIR}/softcenter.tar.gz ${DIR}/koolcenter.tar.gz
cd ${DIR} && rm -rf ${DIR}/build
# --------------------------------------------------------
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

python3 ./gen_install.py stage2

xargs rm -f < to_remove.txt
rm -f to_remove.txt
