#!/bin/sh

source /koolshare/scripts/base.sh

for i in $(find /koolshare/init.d/ -name 'V*' | sort -n);
do
	case "$i" in
		V* | *.sh )
			# Source shell script for speed.
			trap "" INT QUIT TSTP EXIT
			if [ -r "$i" ]; then
				_LOG "[软件中心]-[${0##*/}]: $i"
				$i
			fi
			;;
		*)
			# No sh extension, so fork subprocess.
			_LOG "[软件中心]-[ks_service-start-1]: . $i"
			. $i
			;;
	esac
done
