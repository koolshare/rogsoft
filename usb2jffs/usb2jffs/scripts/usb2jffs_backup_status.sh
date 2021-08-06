#!/bin/sh

source /koolshare/scripts/base.sh
eval $(dbus export usb2jffs_)

cd ${usb2jffs_mount_path}
FILES=$(ls -alrh .koolshare_jffs_*.tar|awk '{print $NF}'|sed "s/$/>/g"|tr -d '\n'|sed 's/>$/\n/g')
if [ -z "${FILES}" ];then
	http_response ""
else
	http_response ${FILES}
fi