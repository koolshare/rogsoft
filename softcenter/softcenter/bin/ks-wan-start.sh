#!/bin/sh

source /koolshare/scripts/base.sh

ACTION=$1

[ $# -lt 1 ] && exit 1

[ $ACTION = stop -o $ACTION = restart -o $ACTION = kill ] && ORDER="-r"

for i in $(find /koolshare/init.d/ -name 'S*' | sort -k1.20 -n${ORDER}) ;
do
	case "$i" in
		S* | *.sh )
			# Source shell script for speed.
			trap "" INT QUIT TSTP EXIT
			if [ -r "$i" ]; then
				_LOG "[软件中心]-[${0##*/}]: $i $ACTION"
				$i $ACTION
			fi
			;;
		*)
			# No sh extension, so fork subprocess.
			_LOG "[软件中心]-[${0##*/}]: . $i $ACTION"
			. $i $ACTION
			;;
	esac
done

# to ensure skin value
set_skin(){
	UI_TYPE=ASUSWRT
	local SC_SKIN=$(nvram get sc_skin)
	local TS_FLAG=$(grep -o "2ED9C3" /www/css/difference.css 2>/dev/null|head -n1)
	local ROG_FLAG=$(cat /www/form_style.css|grep -A1 ".tab_NW:hover{"|grep "background"|sed 's/,//g'|grep -o "2071044")
	local TUF_FLAG=$(cat /www/form_style.css|grep -A1 ".tab_NW:hover{"|grep "background"|sed 's/,//g'|grep -o "D0982C")
	local WRT_FLAG=$(cat /www/form_style.css|grep -A1 ".tab_NW:hover{"|grep "background"|sed 's/,//g'|grep -o "4F5B5F")
	if [ -n "${TS_FLAG}" ];then
		UI_TYPE="TS"
	else
		if [ -n "${TUF_FLAG}" ];then
			UI_TYPE="TUF"
		fi
		if [ -n "${ROG_FLAG}" ];then
			UI_TYPE="ROG"
		fi
		if [ -n "${WRT_FLAG}" ];then
			UI_TYPE="ASUSWRT"
		fi
	fi
	if [ -z "${SC_SKIN}" -o "${SC_SKIN}" != "${UI_TYPE}" ];then
		nvram set sc_skin="${UI_TYPE}"
		nvram commit
	fi
}

set_skin

