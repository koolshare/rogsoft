#!/bin/sh

export KSROOT=/koolshare
export PERP_BASE=$KSROOT/perp
NEW_PATH=$(echo $PATH|tr ':' '\n'|sed '/opt/d;/mmc/d'|awk '!a[$0]++'|tr '\n' ':'|sed '$ s/:$//')
export PATH=$KSROOT/bin:$KSROOT/scripts:${NEW_PATH}
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'

ACTION=$1
ID=$1
export LANIP=127.0.0.1

_LOG(){
	# for debug
	# echo [$(date)]-$1 | tee -a /data/ks_softcenter_log.txt
	logger $1
}

http_response()  {
    ARG0="$@"
    curl -X POST -d "$ARG0" http://$LANIP:3030/_resp/$ID
}

[ -d "/tmp/.xt" ] && export XTABLES_LIBDIR=/tmp/.xt
