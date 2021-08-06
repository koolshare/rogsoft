#!/bin/sh

source /koolshare/scripts/base.sh

ACTION=$1

[ $# -lt 1 ] && exit 1

[ $ACTION = stop -o $ACTION = restart -o $ACTION = kill ] && ORDER="-r"

for i in $(find /koolshare/init.d/ -name 'S*' | sort $ORDER ) ;
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

