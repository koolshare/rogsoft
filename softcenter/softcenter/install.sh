#!/bin/sh

MODEL=$(nvram get model)

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
		if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ -n "$(nvram get extendno | grep koolshare)" -a "$(nvram get productid)" == "RT-AC86U" ];then
			cp -rf /tmp/softcenter/ROG/webs/* /koolshare/webs/
			cp -rf /tmp/softcenter/ROG/res/* /koolshare/res/
		fi
		cp -rf /tmp/softcenter/init.d/* /koolshare/init.d/
		cp -rf /tmp/softcenter/bin/* /koolshare/bin/
		#for axhnd
		if [ "$MODEL" == "RT-AX88U" ] || [ "$MODEL" == "GT-AX11000" ];then
			cp -rf /tmp/softcenter/axbin/* /koolshare/bin/
		fi
		cp -rf /tmp/softcenter/perp /koolshare/
		cp -rf /tmp/softcenter/scripts /koolshare/
		cp -rf /tmp/softcenter/.soft_ver /koolshare/

		# make some link
		[ ! -L "/koolshare/bin/base64_decode" ] && ln -sf /koolshare/bin/base64_encode /koolshare/bin/base64_decode
		[ ! -L "/koolshare/scripts/ks_app_remove.sh" ] && ln -sf /koolshare/scripts/ks_app_install.sh /koolshare/scripts/ks_app_remove.sh
		[ ! -L "/jffs/.asusrouter" ] && ln -sf /koolshare/bin/kscore.sh /jffs/.asusrouter
		[ -L "/koolshare/bin/base64" ] && rm -rf /koolshare/bin/base64
		if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ -n "$(nvram get extendno | grep koolshare)" -a "$(nvram get productid)" == "RT-AC86U" ];then
			# for offcial mod, RT-AC86U, GT-AC5300
			[ ! -L "/jffs/etc/profile" ] && ln -sf /koolshare/scripts/base.sh /jffs/etc/profile
		else
			# for Merlin mod, RT-AX88U, RT-AC86U
			[ ! -L "/jffs/configs/profile.add" ] && ln -sf /koolshare/scripts/base.sh /jffs/configs/profile.add
		fi
		chmod 755 /koolshare/bin/*
		chmod 755 /koolshare/init.d/*
		chmod 755 /koolshare/perp/*
		chmod 755 /koolshare/perp/.boot/*
		chmod 755 /koolshare/perp/.control/*
		chmod 755 /koolshare/perp/httpdb/*
		chmod 755 /koolshare/scripts/*

		# remove install package
		rm -rf /tmp/softcenter
		#============================================
		# check start up scripts 
		if [ ! -f "/jffs/scripts/wan-start" ];then
			cat > /jffs/scripts/wan-start <<-EOF
			#!/bin/sh
			/koolshare/bin/ks-wan-start.sh start
			EOF
		else
			STARTCOMAND1=$(cat /jffs/scripts/wan-start | grep -c "/koolshare/bin/ks-wan-start.sh start")
			[ "$STARTCOMAND1" -gt "1" ] && sed -i '/ks-wan-start.sh/d' /jffs/scripts/wan-start && sed -i '1a /koolshare/bin/ks-wan-start.sh start' /jffs/scripts/wan-start
			[ "$STARTCOMAND1" == "0" ] && sed -i '1a /koolshare/bin/ks-wan-start.sh start' /jffs/scripts/wan-start
		fi
		
		if [ ! -f "/jffs/scripts/nat-start" ];then
			cat > /jffs/scripts/nat-start <<-EOF
			#!/bin/sh
			/koolshare/bin/ks-nat-start.sh start_nat
			EOF
		else
			STARTCOMAND2=$(cat /jffs/scripts/nat-start | grep -c "/koolshare/bin/ks-nat-start.sh start_nat")
			[ "$STARTCOMAND2" -gt "1" ] && sed -i '/ks-nat-start.sh/d' /jffs/scripts/nat-start && sed -i '1a /koolshare/bin/ks-nat-start.sh start_nat' /jffs/scripts/nat-start
			[ "$STARTCOMAND2" == "0" ] && sed -i '1a /koolshare/bin/ks-nat-start.sh start_nat' /jffs/scripts/nat-start
		fi
		
		if [ ! -f "/jffs/scripts/post-mount" ];then
			cat > /jffs/scripts/post-mount <<-EOF
			#!/bin/sh
			/koolshare/bin/ks-mount-start.sh start \$1
			EOF
		else
			STARTCOMAND3=$(cat /jffs/scripts/post-mount | grep -c "/koolshare/bin/ks-mount-start.sh \$1")
			[ "$STARTCOMAND3" -gt "1" ] && sed -i '/ks-mount-start.sh/d' /jffs/scripts/post-mount && sed -i '1a /koolshare/bin/ks-mount-start.sh start $1' /jffs/scripts/post-mount
			[ "$STARTCOMAND3" == "0" ] && sed -i '/ks-mount-start.sh/d' /jffs/scripts/post-mount && sed -i '1a /koolshare/bin/ks-mount-start.sh start $1' /jffs/scripts/post-mount
		fi
		
		if [ ! -f "/jffs/scripts/services-start" ];then
			cat > /jffs/scripts/services-start <<-EOF
			#!/bin/sh
			/koolshare/bin/ks-services-start.sh start
			EOF
		else
			STARTCOMAND4=$(cat /jffs/scripts/services-start | grep -c "/koolshare/bin/ks-services-start.sh start")
			[ "$STARTCOMAND4" -gt "1" ] && sed -i '/ks-services-start.sh/d' /jffs/scripts/services-start && sed -i '1a /koolshare/bin/ks-services-start.sh start' /jffs/scripts/services-start
			[ "$STARTCOMAND4" == "0" ] && sed -i '1a /koolshare/bin/ks-services-start.sh start' /jffs/scripts/services-start
		fi
		
		if [ ! -f "/jffs/scripts/unmount" ];then
			cat > /jffs/scripts/unmount <<-EOF
			#!/bin/sh
			/koolshare/bin/ks-unmount.sh \$1
			EOF
		else
			STARTCOMAND5=$(cat /jffs/scripts/unmount | grep -c "/koolshare/bin/ks-unmount.sh \$1")
			[ "$STARTCOMAND5" -gt "1" ] && sed -i '/ks-unmount.sh/d' /jffs/scripts/unmount && sed -i '1a /koolshare/bin/ks-unmount.sh $1' /jffs/scripts/unmount
			[ "$STARTCOMAND5" == "0" ] && sed -i '1a /koolshare/bin/ks-unmount.sh $1' /jffs/scripts/unmount

		chmod +x /jffs/scripts/*
		#============================================

		# now try to reboot httpdb if httpdb not started
		# /koolshare/bin/start-stop-daemon -S -q -x /koolshare/perp/perp.sh
	fi
}

softcenter_install
