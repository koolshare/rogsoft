#!/bin/sh

# delete old file & folders from softcenter
if [ -f "/jffs/.asusrouter" ];then
	rm -rf /jffs/.asusrouter
	rm -rf /jffs/.koolshare
	rm -rf /jffs/configs
	rm -rf /jffs/scripts
	rm -rf /jffs/db
fi

# make some folders for basic center
mkdir -p /jffs/etc
mkdir -p /tmp/upload

# install
if [ -f "/koolshare/.soft_ver" ];then
	CUR_VERSION=$(cat /koolshare/.soft_ver)
else
	CUR_VERSION="0"
fi
ROM_VERSION=$(cat /rom/etc/koolshare/.soft_ver)
COMP=$(/rom/etc/koolshare/bin/versioncmp $CUR_VERSION $ROM_VERSION)

if [ ! -f "/jffs/.koolshare/bin/skipd" -o "$COMP" == "1" ]; then
	# make folder for basioc center
	mkdir -p /jffs/.koolshare
	mkdir -p /jffs/.koolshare/configs/

	# copy files form /rom to /jffs
	#cp -rf /rom/etc/koolshare/* /jffs/.koolshare/
	cp -rf /rom/etc/koolshare/bin/* /jffs/.koolshare/bin/
	cp -rf /rom/etc/koolshare/init.d/* /jffs/.koolshare/init.d/
	cp -rf /rom/etc/koolshare/res/* /jffs/.koolshare/res/
	cp -rf /rom/etc/koolshare/scripts/* /jffs/.koolshare/scripts/
	cp -rf /rom/etc/koolshare/perp /jffs/.koolshare/
	cp -rf /rom/etc/koolshare/.soft_ver /jffs/.koolshare/
	
	chmod 755 /koolshare/bin/*
	chmod 755 /koolshare/init.d/*
	chmod 755 /koolshare/scripts/*
	chmod 755 /koolshare/perp/*
	chmod 755 /koolshare/perp/.boot/*
	chmod 755 /koolshare/perp/.control/*
	chmod 755 /koolshare/perp/httpdb/*
	chmod 755 /koolshare/perp/skipd/*
	
	# make some links
	[ ! -L "/koolshare/bin/base64_decode" ] && ln -sf /koolshare/bin/base64_encode /koolshare/bin/base64_decode
	[ ! -L "/jffs/etc/profile" ] && ln -sf /koolshare/scripts/base.sh /jffs/etc/profile

	# save
	sync
fi

# run basic center
sh /koolshare/bin/kscore.sh
