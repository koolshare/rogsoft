#!/bin/sh
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'

URL="https://raw.githubusercontent.com/pradt2/always-online-stun/refs/heads/master/valid_nat_testing_hosts.txt"
OUT_TXT="/koolshare/res/gostun_stun_servers.txt"
OUT_JS="/koolshare/res/gostun_stun_servers.json.js"
TMP_RAW="/tmp/gostun_stun_servers.raw"
TMP_NEW="/tmp/gostun_stun_servers.new"
TMP_JS="/tmp/gostun_stun_servers.json.js"

download_list() {
	if command -v curl >/dev/null 2>&1; then
		curl -fsSL "${URL}" -o "${TMP_RAW}"
		return $?
	fi
	if command -v wget >/dev/null 2>&1; then
		wget -qO "${TMP_RAW}" "${URL}"
		return $?
	fi
	return 127
}

echo_date "拉取 always-online-stun 列表..."
download_list
ret=$?
if [ "${ret}" != "0" ]; then
	echo_date "下载失败（需要 curl 或 wget）：${ret}"
	exit 1
fi

tr -d '\r' <"${TMP_RAW}" \
	| sed '/^#/d;/^$/d' \
	| grep -E '^[A-Za-z0-9._-]+:[0-9]{2,5}$' \
	| sort -u >"${TMP_NEW}"

NEW_NU=$(wc -l <"${TMP_NEW}" 2>/dev/null)
if [ -z "${NEW_NU}" ] || [ "${NEW_NU}" = "0" ]; then
	echo_date "解析结果为空，未更新！"
	exit 1
fi

mkdir -p "$(dirname "${OUT_TXT}")"

if [ -f "${OUT_TXT}" ]; then
	BACKUP="${OUT_TXT}.bak.$(date +%Y%m%d%H%M%S)"
	cp -f "${OUT_TXT}" "${BACKUP}" >/dev/null 2>&1
	echo_date "已备份旧列表：${BACKUP}"
fi

cp -f "${TMP_NEW}" "${OUT_TXT}"

# generate JS for web (some firmwares may not serve .txt)
awk 'BEGIN{print "var gostun_stun_servers = ["} {a[NR]=$0} END{for(i=1;i<=NR;i++){gsub(/\\\\/,"\\\\\\\\",a[i]); gsub(/\"/,"\\\\\\\"",a[i]); printf "  \\\"%s\\\"%s\\n", a[i], (i<NR?",":"");} print "];"}' "${TMP_NEW}" > "${TMP_JS}"
cp -f "${TMP_JS}" "${OUT_JS}"

rm -f "${TMP_RAW}" "${TMP_NEW}" "${TMP_JS}"

echo_date "更新完成，共 ${NEW_NU} 条：${OUT_JS}"
echo_date "请刷新 Gostun 页面以加载最新列表。"
exit 0
