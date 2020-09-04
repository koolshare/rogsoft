#!/bin/sh

source /koolshare/scripts/base.sh
ACTION=$1

if [ $# -lt 1 ]; then
    printf "Usage: $0 {start|stop|restart|reconfigure|check|kill}\n" >&2
    exit 1
fi

[ $ACTION = stop -o $ACTION = restart -o $ACTION = kill ] && ORDER="-r"

for i in $(find /koolshare/init.d/ -name 'B*' | sort $ORDER ) ;
do
    case "$i" in
        B* | *.sh )
            # Source shell script for speed.
            trap "" INT QUIT TSTP EXIT
            #set $1
            logger "【basic_center】:  $i"
            if [ -r "$i" ]; then
            $i $ACTION
            fi
            ;;
        *)
            # No sh extension, so fork subprocess.
            logger "【basic_center】:  $i"
            . $i $ACTION
            ;;
    esac
done
