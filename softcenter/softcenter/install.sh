#!/bin/sh

odmpid=$(nvram get odmpid)
productid=$(nvram get productid)
[ -n "${odmpid}" ] && MODEL="${odmpid}" || MODEL="${productid}"
ROG_86U=0
EXT_NU=$(nvram get extendno)
EXT_NU=${EXT_NU%_*}

if [ -n "$(nvram get extendno | grep koolshare)" -a "$(nvram get productid)" == "RT-AC86U" -a "${EXT_NU}" -lt "81918" ];then
	ROG_86U=1
fi

if [ "$MODEL" == "GT-AC5300" -o "$MODEL" == "GT-AX11000" -o "$MODEL" == "GT-AX11000_BO4" -o "$ROG_86U" == "1" ];then
	# 官改固件，骚红皮肤
	ROG=1
fi

if [ "$(nvram get productid)" == "TUF-AX3000" ];then
	# 官改固件，橙色皮肤
	TUF=1
fi

softcenter_install() {
	if [ -d "/tmp/softcenter" ]; then
		# make some folders
		# chmod 755 /koolshare/scripts/ks_tar_install.sh
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

		# do not install some file for some model
		JFFS_TOTAL=$(df|grep -Ew "/jffs" | awk '{print $2}')
		if [ -n "${JFFS_TOTAL}" -a "${JFFS_TOTAL}" -le "20000" ];then
			rm -rf /tmp/softcenter/bin/htop
		fi
		
		# coping files
		cp -rf /tmp/softcenter/webs/* /koolshare/webs/
		cp -rf /tmp/softcenter/res/* /koolshare/res/
		# ----ui------
		if [ "$ROG" == "1" ]; then
			cp -rf /tmp/softcenter/ROG/res/* /koolshare/res/
		fi
		if [ "$TUF" == "1" ]; then
			sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /tmp/softcenter/ROG/res/*.css >/dev/null 2>&1
			sed -i 's/3e030d/3e2902/g;s/91071f/92650F/g;s/680516/D0982C/g;s/cf0a2c/c58813/g;s/700618/74500b/g;s/530412/92650F/g' /tmp/softcenter/webs/*.asp >/dev/null 2>&1
			cp -rf /tmp/softcenter/ROG/res/* /koolshare/res/
		fi
		if [ -z "$TUF" -a -z "$ROG" ]; then
			sed -i '/rogcss/d' /koolshare/webs/Module_Softsetting.asp >/dev/null 2>&1
		fi
		# -------------
		cp -rf /tmp/softcenter/init.d/* /koolshare/init.d/
		cp -rf /tmp/softcenter/bin/* /koolshare/bin/
		#for axhnd
		if [ "${MODEL}" == "RT-AX88U" ] || [ "${MODEL}" == "GT-AX11000" ];then
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
		if [ -n "$(nvram get extendno | grep koolshare)" ];then
			# for offcial mod, RT-AC86U, GT-AC5300, TUF-AX3000, RT-AX86U, etc
			[ ! -L "/jffs/etc/profile" ] && ln -sf /koolshare/scripts/base.sh /jffs/etc/profile
		else
			# for Merlin mod, RT-AX88U, RT-AC86U, etc
			[ ! -L "/jffs/configs/profile.add" ] && ln -sf /koolshare/scripts/base.sh /jffs/configs/profile.add
		fi

		# remove install package
		rm -rf /tmp/softcenter*
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
			STARTCOMAND3=$(cat /jffs/scripts/post-mount | grep -c "/koolshare/bin/ks-mount-start.sh start \$1")
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
		fi

		chmod 755 /jffs/scripts/*
		chmod 755 /koolshare/bin/*
		chmod 755 /koolshare/init.d/*
		chmod 755 /koolshare/perp/*
		chmod 755 /koolshare/perp/.boot/*
		chmod 755 /koolshare/perp/.control/*
		chmod 755 /koolshare/perp/httpdb/*
		chmod 755 /koolshare/scripts/*

		# reset some default value
		if [ -n "$(pidof skipd)" -a -f "/usr/bin/dbus" ];then
			/usr/bin/dbus set softcenter_installing_todo=""
			/usr/bin/dbus set softcenter_installing_title=""
			/usr/bin/dbus set softcenter_installing_name=""
			/usr/bin/dbus set softcenter_installing_tar_url=""
			/usr/bin/dbus set softcenter_installing_version=""
			/usr/bin/dbus set softcenter_installing_md5=""
		fi
		#============================================
		# now try to reboot httpdb if httpdb not started
		# /koolshare/bin/start-stop-daemon -S -q -x /koolshare/perp/perp.sh
	fi
}

softcenter_install
