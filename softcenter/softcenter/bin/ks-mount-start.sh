#!/bin/sh

# called by script /jffs/scripts/post-mount with $1 like /tmp/mnt/sda1
# call scripts in /koolshare/init.d/M*, eg: M50swap.sh /tmp/mnt/sda1

source /koolshare/scripts/base.sh

[ $# -lt 2 ] && exit 1

MOPATH=$2

[ "${MOPATH}" == "start" ] && exit 1


for i in $(find /koolshare/init.d/ -name 'M*' | sort -n) ;
do
	case "$i" in
		M* | *.sh)
			# Source shell script for speed.
			trap "" INT QUIT TSTP EXIT
			if [ -r "$i" ]; then
				_LOG "[软件中心]-[${0##*/}]: $i $MOPATH"
				$i $MOPATH
			fi
			;;
		*)
			# No sh extension, so fork subprocess.
			_LOG "[软件中心]-[${0##*/}]: . $i $MOPATH"
			. $i $MOPATH
			;;
	esac
done
