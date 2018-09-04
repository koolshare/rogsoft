#!/bin/sh

MODEL=`nvram get model`

softcenter_install() {
	if [ -d "/tmp/softcenter" ]; then
		# make some folders
		mkdir -p /jffs/configs/dnsmasq.d
		mkdir -p /jffs/scripts
		mkdir -p /jffs/etc
		mkdir -p /koolshare/bin/
		mkdir -p /koolshare/init.d/
		mkdir -p /koolshare/scripts/
		mkdir -p /koolshare/configs/
		mkdir -p /koolshare/webs/
		mkdir -p /koolshare/res/
		mkdir -p /tmp/upload
		
		# remove useless files
		[ -L "/jffs/configs/profile" ] && rm -rf /jffs/configs/profile
		[ -L "/koolshare/webs/files" ] && rm -rf /koolshare/webs/files
		[ -d "/tmp/files" ] && rm -rf /tmp/files
		
		# coping files
		cp -rf /tmp/softcenter/webs/* /koolshare/webs/
		cp -rf /tmp/softcenter/res/* /koolshare/res/
		if [ "`nvram get model`" == "GT-AC5300" ] || [ -n "`nvram get extendno | grep koolshare`" -a "`nvram get productid`" == "RT-AC86U" ];then
			cp -rf /tmp/softcenter/GT-AC5300/webs/* /koolshare/webs/
			cp -rf /tmp/softcenter/GT-AC5300/res/* /koolshare/res/
		fi
		cp -rf /tmp/softcenter/init.d/* /koolshare/init.d/
		cp -rf /tmp/softcenter/bin/* /koolshare/bin/
		cp -rf /tmp/softcenter/perp /koolshare/
		cp -rf /tmp/softcenter/scripts /koolshare/

		# make some link
		[ ! -L "/koolshare/bin/base64_decode" ] && ln -sf /koolshare/bin/base64_encode /koolshare/bin/base64_decode
		[ ! -L "/koolshare/scripts/ks_app_remove.sh" ] && ln -sf /koolshare/scripts/ks_app_install.sh /koolshare/scripts/ks_app_remove.sh
		[ ! -L "/jffs/.asusrouter" ] && ln -sf /koolshare/bin/kscore.sh /jffs/.asusrouter
		[ -L "/koolshare/bin/base64" ] && rm -rf /koolshare/bin/base64
		if [ "`nvram get model`" == "GT-AC5300" ] || [ -n "`nvram get extendno | grep koolshare`" -a "`nvram get productid`" == "RT-AC86U" ];then
			[ ! -L "/jffs/etc/profile" ] && ln -sf /koolshare/scripts/base.sh /jffs/etc/profile
		else
			[ ! -L "/jffs/configs/profile" ] && ln -sf /koolshare/scripts/base.sh /jffs/configs/profile
		fi
		chmod 755 /koolshare/bin/*
		chmod 755 /koolshare/init.d/*
		chmod 755 /koolshare/perp/*
		chmod 755 /koolshare/perp/.boot/*
		chmod 755 /koolshare/perp/.control/*
		chmod 755 /koolshare/perp/httpdb/*
		chmod 755 /koolshare/perp/skipd/*
		chmod 755 /koolshare/scripts/*

		# remove install package
		rm -rf /tmp/softcenter
		# creat wan-start nat-start post-mount
		if [ ! -f "/jffs/scripts/wan-start" ];then
			cat > /jffs/scripts/wan-start <<-EOF
			#!/bin/sh
			/koolshare/bin/ks-wan-start.sh start
			EOF
			chmod +x /jffs/scripts/wan-start
		else
			STARTCOMAND1=`cat /jffs/scripts/wan-start | grep -c "/koolshare/bin/ks-wan-start.sh start"`
			[ "$STARTCOMAND1" -gt "1" ] && sed -i '/ks-wan-start.sh/d' /jffs/scripts/wan-start && sed -i '1a /koolshare/bin/ks-wan-start.sh start' /jffs/scripts/wan-start
			[ "$STARTCOMAND1" == "0" ] && sed -i '1a /koolshare/bin/ks-wan-start.sh start' /jffs/scripts/wan-start
		fi
		
		if [ ! -f "/jffs/scripts/nat-start" ];then
			cat > /jffs/scripts/nat-start <<-EOF
			#!/bin/sh
			/koolshare/bin/ks-nat-start.sh start_nat
			EOF
			chmod +x /jffs/scripts/nat-start
		else
			STARTCOMAND2=`cat /jffs/scripts/nat-start | grep -c "/koolshare/bin/ks-nat-start.sh start"`
			[ "$STARTCOMAND2" -gt "1" ] && sed -i '/ks-nat-start.sh/d' /jffs/scripts/nat-start && sed -i '1a /koolshare/bin/ks-nat-start.sh start' /jffs/scripts/nat-start
			[ "$STARTCOMAND2" == "0" ] && sed -i '1a /koolshare/bin/ks-nat-start.sh start' /jffs/scripts/nat-start
		fi
		
		if [ ! -f "/jffs/scripts/post-mount" ];then
			cat > /jffs/scripts/post-mount <<-EOF
			#!/bin/sh
			/koolshare/bin/ks-mount-start.sh start
			EOF
			chmod +x /jffs/scripts/post-mount
		else
			STARTCOMAND2=`cat /jffs/scripts/post-mount | grep "/koolshare/bin/ks-mount-start.sh start"`
			[ -z "$STARTCOMAND2" ] && sed -i '1a /koolshare/bin/ks-mount-start.sh start' /jffs/scripts/post-mount
		fi

		# now try to reboot httpdb if httpdb not started
		# /koolshare/bin/start-stop-daemon -S -q -x /koolshare/perp/perp.sh
	fi
}

softcenter_install
