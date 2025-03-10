#!/bin/sh
# 读取 HTTP 请求的第一行，例如 "GET / HTTP/1.1"
read request_line
# 从第一行解析方法与路径
method=$(echo "${request_line}" | awk '{print $1}')
path=$(echo "${request_line}" | awk '{print $2}')

# 读取并丢弃剩余请求头，直到遇到空行（去除回车）
while read header; do
    header=$(echo "$header" | tr -d '\r')
    [ -z "$header" ] && break
done

print_prehead(){
	printf "HTTP/1.1 200 OK\r\n"
	printf "Content-Type: text/html; charset=UTF-8\r\n\r\n"
	printf "<html>\n"
	printf "<head>\n"
	printf "<meta charset=\"UTF-8\">\n"
}

detect_running_status(){
	local BINNAME=$1
	local PID1
	local i=40
	until [ -n "${PID1}" ]; do
		usleep 250000
		i=$(($i - 1))
		PID1=$(pidof ${BINNAME})
		if [ "$i" -lt 1 ]; then
			return 1
		fi
	done
}

if [ "${path}" == "/" ]; then
	# 返回一个简单 HTML 页面，页面上包含一个按钮（点击后 GET 请求到 /run）
	print_prehead
	printf "<style>\n"
	printf ".btn,h1{text-align:center}body{font-family:Roboto,sans-serif;background-color:#f2f2f2;margin:0;padding:20px}.container{max-width:800px;margin:0 auto;background:#fff;padding:30px;box-shadow:0 4px 8px rgba(0,0,0,.1);border-radius:8px}h1{color:#333}p{line-height:1.6;color:#555}hr{border:none;height:1px;background:#ddd;margin:30px 0}.op-box{margin-bottom:20px;padding-bottom:20px;border-bottom:1px solid #eee}.op-box:last-child{border-bottom:none;margin-bottom:0;padding-bottom:0}.btn{border:none;color:#fff;padding:10px 16px;text-decoration:none;font-size:14px;margin:10px 0;cursor:pointer;border-radius:4px;transition:background-color .3s}.btn-restart{background-color:#04aa6d}.btn-restart:hover{background-color:#039f63}.btn-reset{background-color:#f74848}.btn-reset:hover{background-color:#e03d3d}.btn-httpd{background-color:#4893f7}.btn-httpd:hover{background-color:#3c7ed0}\n"
	printf "</style>\n"
	printf "<title>koolcenter 调试页面</title>\n"
	printf "</head>\n"
	printf "<body>\n"
	printf "<div class='container'>\n"
	printf "<h1>koolcenter 调试页面</h1>\n"
	printf "<hr>\n"
	printf "<p>♥️ 欢迎使用 koolcenter 软件中心调试页面！使用前请仔细阅读相关说明！</p>\n"
	printf "<p>🤖 此页面功能独立，不依赖软件中心，软件中心出问题时可在此处调整！</p>\n"
	printf "<p>🔖 建议使用浏览器快捷键 <strong>Ctrl+D</strong>，将本页面添加到书签，以备不时之需。</p>\n"
	printf "<p>⚠️ 以下按钮点击后会立即运行，不会有任何提示，请根据需要选择使用。</p>\n"
	printf "<hr>\n"
	printf "<div class='op-box'>\n"
	printf "<form action='/run1' method='get'>\n"
	printf "<button type='submit' class='btn btn-restart'>重启软件中心</button>\n"
	printf "</form>\n"
	printf "<p>如果你的软件中心版本号显示0.0.0，或者一直显示更新中，可以尝试使用此功能。</p>\n"
	printf "</div>\n"
	printf "<div class='op-box'>\n"
	printf "<form action='/run2' method='get'>\n"
	printf "<button type='submit' class='btn btn-reset'>重置软件中心</button>\n"
	printf "</form>\n"
	printf "<p>点击此按钮让软件中心恢复到初始状态，请注意：此操作会删除所有已安装插件！</p>\n"
	printf "</div>\n"
	printf "<div class='op-box'>\n"
	printf "<form action='/run3' method='get'>\n"
	printf "<button type='submit' class='btn btn-httpd'>重启httpd服务</button>\n"
	printf "</form>\n"
	printf "<p>路由器管理界面进不去的时候，可能是httpd崩了，点此按钮可以重启httpd服务！</p>\n"
	printf "</div>\n"
	printf "</div>\n"
	printf "</body>\n"
	printf "</html>\n"
elif [ "${path}" == "/run1?" -o "$path" == "/run1" ]; then
	# 重启软件中心
	print_prehead
	printf "<title>重启软件中心</title>\n"
	printf "</head>\n<body>\n"
	printf "<p>软件中心重启中！请稍候...</p>\n"
	sh /koolshare/perp/perp.sh >/dev/null 2>&1
	service restart_skipd >/dev/null 2>&1
	detect_running_status httpdb
	detect_running_status skipd
	_PID1=$(pidof httpdb)
	_PID2=$(pidof skipd)
	if [ -n "${_PID1}" -a -n "${_PID2}" ];then
		printf "<p>软件中心重启成功！httpdb pid: ${_PID1}; skipd pid: ${_PID2}</p>\n"
	else
		printf "<p>软件中心重启失败！请尝试重置软件中心\n"
	fi
	printf "<a href='/'>返回主页</a>\n"
	printf "</body>\n"
	printf "</html>\n"
elif [ "${path}" == "/run2?" -o "$path" == "/run2" ]; then
	# 重置软件中心
	print_prehead
	printf "<title>重置软件中心</title>\n"
	printf "</head>\n<body>\n"
	printf "<p>软件中心重置中！请稍候...</p>\n"
	JFFS=$(df -h|grep -w /jffs)
	if [ -z "${JFFS}" ];then
		printf "<p>检测到jffs分区未正确挂载！请解决此问题后重试！</p>\n"
	else
		printf "<p>关闭软件中心相关进程！</p>\n"
		killall perpboot >/dev/null 2>&1
		killall tinylog >/dev/null 2>&1
		killall perpd >/dev/null 2>&1
		killall skipd >/dev/null 2>&1
		kill -9 $(pidof skipd) >/dev/null 2>&1
		kill -9 $(pidof httpdb) >/dev/null 2>&1
		printf "<p>移除软件中心相关文件！</p>\n"
		rm -rf /jffs/db >/dev/null 2>&1
		rm -rf /jffs/ksdb >/dev/null 2>&1
		rm -rf /jffs/asdb >/dev/null 2>&1
		rm -rf /jffs/.asusrouter >/dev/null 2>&1
		rm -rf /jffs/.koolshare >/dev/null 2>&1
		rm -rf /jffs/configs/dnsmasq.d/* >/dev/null 2>&1
		rm -rf /jffs/configs/profile.add >/dev/null 2>&1
		rm -rf /jffs/etc/profile >/dev/null 2>&1
		rm -rf /jffs/etc/profile.add >/dev/null 2>&1
		rm -rf /jffs/scripts/*
		rm -rf /cifs2/db >/dev/null 2>&1
		rm -rf /cifs2/ksdb >/dev/null 2>&1
		rm -rf /cifs2/asdb >/dev/null 2>&1
		rm -rf /cifs2/.asusrouter >/dev/null 2>&1
		rm -rf /cifs2/.koolshare >/dev/null 2>&1
		rm -rf /cifs2/configs/dnsmasq.d/* >/dev/null 2>&1
		rm -rf /cifs2/configs/profile.add >/dev/null 2>&1
		rm -rf /cifs2/etc/profile >/dev/null 2>&1
		rm -rf /cifs2/etc/profile.add >/dev/null 2>&1
		rm -rf /cifs2/scripts/*
		sync
		echo 1 > /proc/sys/vm/drop_caches
		printf "<p>重启dnsmasq！</p>\n"
		service restart_dnsmasq >/dev/null 2>&1
		sleep 1
		printf "<p>初始化软件中心...</p>\n"
		/usr/bin/jffsinit.sh >/dev/null 2>&1
		sleep 1
		sync
		echo 1 > /proc/sys/vm/drop_caches
		printf "<p>尝试重新启动软件中心相关进程...</p>\n"
		cd /koolshare/perp
		sh perp.sh start >/dev/null 2>&1
		if [ -z "$(pidof skipd)" ];then
			service start_skipd  >/dev/null 2>&1
		fi
		cd /koolshare/bin
		sh kscore.sh >/dev/null 2>&1
		if [ -f "/koolshare/.soft_ver" ];then
			printf "<p>设置软件中心版本号...</p>\n"
			/usr/bin/dbus set softcenter_version=$(cat /koolshare/.soft_ver)
		fi
		echo "<p>软件中心重置完成，请清空浏览器缓存后重新进入软件中心！</p>\n"
		printf "<a href='/'>返回主页</a>\n"
		printf "</body>\n"
		printf "</html>\n"
	fi
elif [ "${path}" == "/run3?" -o "${path}" == "/run3"  ]; then
	# httpd
	print_prehead
	printf "<title>重启httpd</title>\n"
	printf "</head>\n<body>\n"
	printf "<p>httpd重启中！请稍候...</p>\n"
	service restart_httpd >/dev/null 2>&1
	detect_running_status httpdb
	HTTPD_PID=$(ps|grep -w httpd|grep -v grep|awk '{print $1}')
	if [ -n "${HTTPD_PID}" ];then
		printf "<p>httpd重启成功！pid: ${HTTPD_PID}</p>\n"
	else
		printf "<p>httpd重启失败！</p>\n"
	fi
	printf "<a href='/'>返回主页</a>\n"
	printf "</body>\n"
	printf "</html>\n"
else
    # 其它路径返回 404 页面
	printf "<title>脚本已启动</title>\n"
	printf "</head>\n<body>\n"
	printf "<p>后台脚本已经启动！</p>\n"
	printf "<a href='/'>返回主页</a>\n"
	printf "</body>\n"
	printf "</html>\n"
fi