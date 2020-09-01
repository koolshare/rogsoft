#!/bin/sh

export KSROOT=/koolshare
source $KSROOT/scripts/base.sh
ACTION=$1

logger "【basic_center】: 检测jffs分区挂载情况！"
detect_jffs(){
	i=120
	JFFS=$(mount|grep /jffs)
	until [ -n "${JFFS}" ]
	do
		i=$(($i-1))
		    JFFS=$(mount|grep /jffs)
		if [ "$i" -lt 1 ];then
		    logger "【basic_center】: 错误，jffs分区未能成功挂载！"
		    exit
		fi
		sleep 1
	done
	logger "【basic_center】: jffs分区已经成功挂载！"
}

detect_jffs
mkdir -p /tmp/upload


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
