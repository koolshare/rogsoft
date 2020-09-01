#!/bin/sh

# 每次开机第一个运行的文件

# make some folders
mkdir -p /jffs/scripts
mkdir -p /jffs/configs/dnsmasq.d
mkdir -p /jffs/etc
mkdir -p /tmp/upload

# install all
if [ -f "/koolshare/.soft_ver" ];then
	CUR_VERSION=$(cat /koolshare/.soft_ver)
else
	CUR_VERSION="0"
fi
ROM_VERSION=$(cat /rom/etc/koolshare/.soft_ver)
COMP=$(/rom/etc/koolshare/bin/versioncmp $CUR_VERSION $ROM_VERSION)

if [ ! -f "/jffs/.koolshare/bin/skipd" -o "$COMP" == "1" ]; then
	# 删除一次，避免从改版固件升级到官方固件后，/jffs/.koolshare内没有basic_center相关文件
	rm -rf /jffs/.koolshare
	sleep 1
	
	mkdir -p /jffs/.koolshare
	mkdir -p /jffs/.koolshare/configs/
	
	cp -rf /rom/etc/koolshare/* /jffs/.koolshare/
	cp -rf /rom/etc/koolshare/.soft_ver /jffs/.koolshare/
	
	chmod 755 /koolshare/bin/*
	chmod 755 /koolshare/init.d/*
	chmod 755 /koolshare/perp/*
	chmod 755 /koolshare/perp/.boot/*
	chmod 755 /koolshare/perp/.control/*
	chmod 755 /koolshare/perp/httpdb/*
	chmod 755 /koolshare/perp/skipd/*
	chmod 755 /koolshare/scripts/*
	
	[ ! -L "/koolshare/bin/base64_decode" ] && ln -sf /koolshare/bin/base64_encode /koolshare/bin/base64_decode
	[ ! -L "/jffs/etc/profile" ] && ln -sf /koolshare/scripts/base.sh /jffs/etc/profile

	sync
fi

# 运行软件中心
sh /koolshare/bin/kscore.sh
