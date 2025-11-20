#!/bin/sh

# --- 核心逻辑部分 ---

# 读取 HTTP 请求的第一行
read request_line
# 解析方法与路径
method=$(echo "${request_line}" | awk '{print $1}')
path=$(echo "${request_line}" | awk '{print $2}')

# 读取并丢弃剩余请求头
while read header; do
    header=$(echo "$header" | tr -d '\r')
    [ -z "$header" ] && break
done

# --- 辅助函数 ---

# 统一的 HTML 头部和 CSS 样式
print_head() {
    local title=$1
    printf "HTTP/1.1 200 OK\r\n"
    printf "Content-Type: text/html; charset=UTF-8\r\n\r\n"
    cat <<EOF
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${title}</title>
<style>
    /* 全局盒模型修复：确保 padding 不会撑大元素的宽度 */
    *, *:before, *:after {
        box-sizing: border-box;
    }

    :root {
        --primary: #3b82f6; --primary-hover: #2563eb;
        --success: #10b981; --success-hover: #059669;
        --danger: #ef4444; --danger-hover: #dc2626;
        --bg: #f3f4f6; --card-bg: #ffffff; --text: #1f2937; --text-sub: #6b7280;
        --border: #e5e7eb;
    }
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; background-color: var(--bg); color: var(--text); margin: 0; padding: 20px; display: flex; justify-content: center; min-height: 100vh; }
    
    .container { 
        background: var(--card-bg); 
        width: 100%; 
        max-width: 680px; 
        border-radius: 16px; 
        box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1); 
        padding: 2rem; 
        height: fit-content; 
        /* 防止内部元素溢出 */
        overflow: hidden;
    }

    h1 { font-size: 1.5rem; font-weight: 700; text-align: center; margin-bottom: 0.5rem; color: #111827; margin-top: 0; }
    .subtitle { text-align: center; color: var(--text-sub); font-size: 0.9rem; margin-bottom: 2rem; }
    
    .card { border: 1px solid var(--border); border-radius: 12px; padding: 1.5rem; margin-bottom: 1.5rem; transition: transform 0.2s; }
    .card:hover { border-color: #d1d5db; transform: translateY(-2px); }
    .card h3 { margin: 0 0 0.5rem 0; font-size: 1.1rem; display: flex; align-items: center; }
    .card p { margin: 0 0 1rem 0; font-size: 0.9rem; color: var(--text-sub); line-height: 1.5; }
    
    .btn { 
        display: block; /* 改为 block 确保填满宽度 */
        width: 100%; 
        padding: 0.75rem 1rem; 
        border: none; 
        border-radius: 8px; 
        font-weight: 600; 
        color: white; 
        cursor: pointer; 
        text-align: center; 
        text-decoration: none; 
        transition: background-color 0.2s; 
        font-size: 1rem; 
    }
    .btn-restart { background-color: var(--success); } .btn-restart:hover { background-color: var(--success-hover); }
    .btn-reset { background-color: var(--danger); } .btn-reset:hover { background-color: var(--danger-hover); }
    .btn-httpd { background-color: var(--primary); } .btn-httpd:hover { background-color: var(--primary-hover); }
    .btn-back { background-color: #6b7280; margin-top: 1rem; } .btn-back:hover { background-color: #4b5563; }
    
    .terminal { 
        background: #1e293b; 
        color: #e2e8f0; 
        padding: 1rem; 
        border-radius: 8px; 
        font-family: monospace; 
        font-size: 0.85rem; 
        line-height: 1.6; 
        overflow-x: auto; /* 如果单行太长，内部滚动，而不是撑开容器 */
        white-space: pre-wrap; 
        margin-bottom: 1rem; 
        border: 1px solid #334155;
        width: 100%; /* 强制宽度100% */
    }
    
    hr { border: 0; border-top: 1px solid var(--border); margin: 1.5rem 0; }
    .badge { display: inline-block; padding: 0.25rem 0.5rem; border-radius: 4px; font-size: 0.75rem; margin-right: 8px; }
    .bg-green { background: #d1fae5; color: #065f46; }
    .bg-red { background: #fee2e2; color: #991b1b; }
    .bg-blue { background: #dbeafe; color: #1e40af; }
    .loading { opacity: 0.7; pointer-events: none; position: relative; }
</style>
<script>
    function clickHandler(btn, msg) {
        btn.classList.add('loading');
        btn.innerText = msg;
        return true;
    }
</script>
</head>
<body>
<div class="container">
EOF
}

print_footer() {
    cat <<EOF
</div>
</body>
</html>
EOF
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

# --- 页面逻辑 ---

if [ "${path}" == "/" ]; then
    print_head "koolcenter 调试面板"
    
    cat <<EOF
    <h1>🔧 Koolcenter 调试面板</h1>
    <p class="subtitle">独立于软件中心的应急管理工具</p>
    
    <div style="background: #fff7ed; border-left: 4px solid #f97316; padding: 10px 15px; margin-bottom: 20px; color: #9a3412; font-size: 0.9rem; border-radius: 4px;">
        <strong>⚠️ 注意事项：</strong> 按钮点击后会立即执行，请耐心等待页面跳转。建议按 <kbd>Ctrl+D</kbd> 收藏此页。
    </div>

    <div class="card">
        <h3><span class="badge bg-green">重启</span> 重启软件中心</h3>
        <p>如果你遇到版本号显示 0.0.0，或者界面一直显示“更新中”，请尝试此功能。</p>
        <form action="/run1" method="get" onsubmit="clickHandler(this.querySelector('button'), '正在重启...')">
            <button type="submit" class="btn btn-restart">⚡ 立即重启</button>
        </form>
    </div>

    <div class="card">
        <h3><span class="badge bg-red">重置</span> 重置软件中心</h3>
        <p>将软件中心恢复到初始状态。<b>警告：</b>此操作将彻底删除所有已安装插件和配置！</p>
        <form action="/run2" method="get" onsubmit="clickHandler(this.querySelector('button'), '正在重置(耗时较长)...')">
            <button type="submit" class="btn btn-reset">🗑️ 确认重置</button>
        </form>
    </div>

    <div class="card">
        <h3><span class="badge bg-blue">系统</span> 重启 HTTPD 服务</h3>
        <p>如果路由器后台管理页面无法访问（卡死），可以尝试重启 httpd 进程。</p>
        <form action="/run3" method="get" onsubmit="clickHandler(this.querySelector('button'), '正在重启 HTTPD...')">
            <button type="submit" class="btn btn-httpd">🔄 重启服务</button>
        </form>
    </div>
EOF
    print_footer

elif [ "${path}" == "/run1?" ] || [ "${path}" == "/run1" ]; then
    # 重启软件中心
    print_head "执行结果 - 重启软件中心"
    
    echo "<h1>🚀 正在重启软件中心</h1>"
    echo "<div class='terminal'>"
    echo "Executing restart sequence..."
    
    sh /koolshare/perp/perp.sh >/dev/null 2>&1
    service restart_skipd >/dev/null 2>&1
    detect_running_status httpdb
    detect_running_status skipd
    
    _PID1=$(pidof httpdb)
    _PID2=$(pidof skipd)
    
    if [ -n "${_PID1}" ] && [ -n "${_PID2}" ]; then
        echo "✅ Success!"
        echo "---------------------------------"
        echo "httpdb PID : ${_PID1}"
        echo "skipd  PID : ${_PID2}"
    else
        echo "❌ Failed to detect processes."
        echo "建议尝试 [重置软件中心] 功能。"
    fi
    echo "</div>"
    
    echo "<a href='/' class='btn btn-back'>返回主页</a>"
    print_footer

elif [ "${path}" == "/run2?" ] || [ "${path}" == "/run2" ]; then
    # 重置软件中心
    print_head "执行结果 - 重置软件中心"
    
    echo "<h1>☢️ 正在重置软件中心</h1>"
    echo "<p style='text-align:center; color:var(--danger)'>操作正在进行中，请勿关闭页面...</p>"
    echo "<div class='terminal'>"
    
    JFFS=$(df -h | grep -w /jffs)
    if [ -z "${JFFS}" ]; then
        echo "❌ Error: JFFS partition not mounted!"
    else
        echo "1. Killing processes..."
        killall perpboot tinylog perpd skipd >/dev/null 2>&1
        kill -9 $(pidof skipd) >/dev/null 2>&1
        kill -9 $(pidof httpdb) >/dev/null 2>&1
        
        echo "2. Cleaning files..."
        rm -rf /jffs/db /jffs/ksdb /jffs/asdb /jffs/.asusrouter /jffs/.koolshare >/dev/null 2>&1
        rm -rf /jffs/configs/dnsmasq.d/* /jffs/scripts/* >/dev/null 2>&1
        
        echo "3. Syncing disk..."
        sync
        echo 1 > /proc/sys/vm/drop_caches
        
        echo "4. Restarting services..."
        service restart_dnsmasq >/dev/null 2>&1
        sleep 1
        
        echo "5. Re-initializing koolcenter..."
        /usr/bin/jffsinit.sh >/dev/null 2>&1
        sleep 1
        
        cd /koolshare/perp && sh perp.sh start >/dev/null 2>&1
        [ -z "$(pidof skipd)" ] && service start_skipd >/dev/null 2>&1
        cd /koolshare/bin && sh kscore.sh >/dev/null 2>&1
        
        if [ -f "/koolshare/.soft_ver" ]; then
             VER=$(cat /koolshare/.soft_ver)
             /usr/bin/dbus set softcenter_version=$VER
             echo "✅ Version set to: $VER"
        fi
        echo "---------------------------------"
        echo "🎉 Reset Completed."
    fi
    echo "</div>"
    echo "<p style='text-align:center'>⚠️ 请清空浏览器缓存后重新进入软件中心</p>"
    echo "<a href='/' class='btn btn-back'>返回主页</a>"
    print_footer

elif [ "${path}" == "/run3?" ] || [ "${path}" == "/run3" ]; then
    # 重启 HTTPD
    print_head "执行结果 - 重启 HTTPD"
    
    echo "<h1>🔄 正在重启 HTTPD</h1>"
    echo "<div class='terminal'>"
    echo "Restarting system web service..."
    service restart_httpd >/dev/null 2>&1
    sleep 2
    
    detect_running_status httpdb
    HTTPD_PID=$(ps | grep -w httpd | grep -v grep | awk '{print $1}' | head -n 1)
    
    if [ -n "${HTTPD_PID}" ]; then
        echo "✅ HTTPD is running."
        echo "PID: ${HTTPD_PID}"
    else
        echo "❌ HTTPD restart failed or PID not found."
    fi
    echo "</div>"
    
    echo "<a href='/' class='btn btn-back'>返回主页</a>"
    print_footer

else
    # 404
    print_head "脚本运行中"
    cat <<EOF
    <div style="text-align:center; padding: 40px 0;">
        <div style="font-size: 40px;">👻</div>
        <h2>404 Not Found</h2>
        <p>后台脚本运行正常，但请求路径不存在。</p>
        <a href="/" class="btn btn-httpd" style="max-width:200px; display:inline-block">返回主页</a>
    </div>
EOF
    print_footer
fi