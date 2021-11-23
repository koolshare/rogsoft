#!/bin/sh

# called by script /jffs/scripts/nat-start
# call scripts in /koolshare/init.d/N*, eg: N98SoftEther.sh start_nat

ACTION=$1

#echo start $(date) > /tmp/ks_nat_log.txt

ks_nat=$(nvram get ks_nat)
[ "$ks_nat" == "1" ] && echo exit $(date) >> /tmp/ks_nat_log.txt && exit

for i in $(find /koolshare/init.d/ -name 'N*' | sort -n) ;
do
	case "$i" in
		*.sh )
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

#echo finish $(date) >> /tmp/ks_nat_log.txt
