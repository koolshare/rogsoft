#!/bin/sh

source /koolshare/scripts/base.sh

KSPATH=$1

[ $# -lt 1 ] && exit 1

for i in $(find /koolshare/init.d/ -name 'U*' | sort -n);
do
	case "$i" in
		U* | *.sh )
			# fork subprocess.
			trap "" INT QUIT TSTP EXIT
			if [ -r "$i" ]; then
				_LOG "[软件中心]-[${0##*/}]: $i $KSPATH"
				$i $KSPATH
			fi
			;;
		*)
			# No sh extension, Source shell script for speed.
			_LOG "[软件中心]-[${0##*/}]: . $i $KSPATH"
			. $i $KSPATH
			;;
	esac
done
