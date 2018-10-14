#!/bin/sh

timestamp=$(date +'%Y/%m/%d %H:%M:%S')
alias echo_date='echo $timestamp'
export KSROOT=/koolshare
source $KSROOT/scripts/base.sh

json_init(){
	POST_DATA2='{}'
}

json_add_string(){
	POST_DATA2=`echo $POST_DATA2 | jq --arg var "$2" '. + {'$1': $var}'`
}

json_dump() {
	echo $POST_DATA2 | jq .
}

POST_DATA1='{}'
NU=$(ifconfig|grep ppp|awk '{print $1}'|sed 's/ppp//g')
for nu in $NU
do
	local P0=$(ifconfig|grep ppp$nu -A 6)
	local P1=$(echo "$P0" | grep -Eo 'ppp[0-9]')
	local P2=$(echo "$P0" | grep -Eo 'inet addr:([0-9]{1,3}[\.]){3}[0-9]{1,3}'|awk -F":" '{print $2}')
	local P3=$(echo "$P0" | grep -Eo 'P-t-P:([0-9]{1,3}[\.]){3}[0-9]{1,3}'|awk -F":" '{print $2}')
	local P4=$(echo "$P0" | grep -Eo 'RX bytes:[0-9]+ \(.+) '|grep -Eo '\(.+)'|sed 's/[()]//g')
	local P5=$(echo "$P0" | grep -Eo 'TX bytes:[0-9]+ \(.+)'|grep -Eo '\(.+)'|sed 's/[()]//g')
	json_init
	json_add_string if "$P1"
	json_add_string ip "$P2"
	json_add_string gw "$P3"
	json_add_string rx "$P4"
	json_add_string tx "$P5"
	json_dump
	POST_DATA1=`echo $POST_DATA1 | jq --argjson args "$POST_DATA2" '. + {'\"ppp$nu\"': $args}'`
done

POST_DATA1=`echo $POST_DATA1|base64_encode`

if [ -n "$NU" ]; then
	http_response "$POST_DATA1"
else
	http_response "null"
fi
