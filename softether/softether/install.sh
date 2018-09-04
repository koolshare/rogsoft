#! /bin/sh

eval `dbus export softether`

# stop first
if [ "$softether_enable" == "1" ];then
	/koolshare/softether/softether.sh stop
fi

# remove old start file
find /koolshare/init.d/ -name "*SoftEther*"|xargs rm -rf

# copy new files
cd /tmp
cp -rf /tmp/softether/softether /koolshare/
cp -rf /tmp/softether/scripts/* /koolshare/scripts/
cp -rf /tmp/softether/webs/* /koolshare/webs/
cp -rf /tmp/softether/res/* /koolshare/res/
rm -rf /tmp/softether* >/dev/null 2>&1
chmod 755 /koolshare/softether/*
chmod 755 /koolshare/scripts/*

# create new start file
ln -sf /koolshare/softether/softether.sh /koolshare/init.d/S98SoftEther.sh
ln -sf /koolshare/softether/softether.sh /koolshare/init.d/N98SoftEther.sh

if [ "$softether_enable" == "1" ];then
	/koolshare/softether/softether.sh start
fi

