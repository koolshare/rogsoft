#!/bin/sh

# stop kms first
enable=`dbus get kms_enable`
if [ "$enable" == "1" ];then
	sh /koolshare/scripts/kms.sh stop
fi

# cp files
cp -rf /tmp/kms/scripts/* /koolshare/scripts/
cp -rf /tmp/kms/bin/* /koolshare/bin/
cp -rf /tmp/kms/webs/* /koolshare/webs/
cp -rf /tmp/kms/res/* /koolshare/res/

# delete install tar
rm -rf /tmp/kms* >/dev/null 2>&1

chmod +x /koolshare/scripts/kms*
chmod +x /koolshare/bin/vlmcsd

# re-enable kms
if [ "$enable" == "1" ];then
	sh /koolshare/scripts/kms.sh start
fi



