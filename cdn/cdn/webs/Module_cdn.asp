<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>软件中心CDN</title>
<link rel="stylesheet" href="/index_style.css">
<link rel="stylesheet" href="/form_style.css">
<link rel="stylesheet" href="/res/softcenter.css">
<script src="/js/jquery.js"></script>
<script src="/state.js"></script>
<script src="/general.js"></script>
<script src="/popup.js"></script>
<script src="/help.js"></script>
<script src="/res/softcenter.js"></script>
<style>
.cdn-heading { display:flex; align-items:center; justify-content:space-between; gap:15px; margin:8px 6px 0; }
.cdn-heading .formfonttitle { margin:0; }
.cdn-back, .cdn-back img { display:block; }
.cdn-back img { width:42px; height:auto; }
#FormTitle .cdn-rule { clear:both; margin:12px 0 12px 5px !important; }
.cdn-intro { margin:0 10px; padding-left:1.7em; font-size:13px; line-height:1.8; }
.cdn-status-table { width:100%; border-collapse:collapse; }
.cdn-status-table th { width:135px; }
#cdn_cell { padding:12px 16px; }
.cdn-routes { display:flex; align-items:center; gap:10px; flex-wrap:wrap; }
.cdn-route { position:relative; }
.cdn-chip { display:inline-flex; align-items:center; justify-content:center; gap:8px; min-width:80px;
    padding:6px 14px; border:1px solid #76818b; border-radius:5px; background:#38434b; color:#e0e5e8;
    font:600 14px/18px Arial,sans-serif; cursor:help; }
.cdn-chip::before { content:""; width:8px; height:8px; border:1px solid #abb5be; border-radius:50%; }
.cdn-route.is-active .cdn-chip { border-color:#72dda5; background:#20593f; color:#effff4; }
.cdn-route.is-active .cdn-chip::before { background:#88efb4; border-color:#88efb4; }
.cdn-chip:focus-visible { outline:2px solid #fff; outline-offset:3px; }
#cdn_cell .cdn-tip { display:none; position:absolute; z-index:9; top:100%; left:0; padding-top:6px; width:max-content;
    max-width:285px; background:transparent; color:#f4f7fa; font:13px/1.5 Arial,sans-serif; text-align:left; }
#cdn_cell .cdn-route.is-open .cdn-tip { display:block; }
#cdn_cell .cdn-tip-inner { display:block; background:#132127; border:1px solid #8b9da3; border-radius:5px;
    padding:9px 12px; box-shadow:0 4px 12px rgba(0,0,0,.35); overflow-wrap:anywhere; }
#cdn_cell .cdn-address, #cdn_cell .cdn-tip-note { background:transparent; color:#f4f7fa; }
.cdn-address::before { content:""; display:inline-block; width:8px; height:8px; margin-right:7px;
    border-radius:50%; background:#f38a83; }
.cdn-route.is-active .cdn-address::before { background:#82e4ac; }
.cdn-tip-note:not(:empty) { display:block; margin-top:5px; color:#e2e9ed; }
#cdn_detail { margin:8px 0 0; line-height:1.5; overflow-wrap:anywhere; }
.cdn-log-label { display:block; margin:20px 2px 7px; font-size:14px; font-weight:bold; }
#cdn_log { box-sizing:border-box; display:block; width:100%; height:240px; resize:none;
    overflow-x:hidden; overflow-y:auto; scrollbar-width:none; -ms-overflow-style:none; }
#cdn_log::-webkit-scrollbar { display:none; }
</style>
<script>
var target = "none";
var changing = false;
function menu_hook() {
    tabtitle[tabtitle.length - 1] = ["", "软件中心CDN"];
    tablink[tablink.length - 1] = ["", "Module_cdn.asp"];
}
function request(action) {
    return $.ajax({
        type: "POST", url: "/_api/", dataType: "json", timeout: 30000,
        data: JSON.stringify({id: Math.floor(Math.random()*100000000), method: "cdn_config.sh", params: [action, "json"], fields: {}})
    });
}
function scrollLogToEnd() {
    var box = document.getElementById("cdn_log");
    box.scrollTop = box.scrollHeight;
}
function setLog(text) {
    document.getElementById("cdn_log").value = text;
    if (window.requestAnimationFrame) window.requestAnimationFrame(scrollLogToEnd);
    else scrollLogToEnd();
}
function showResult(reply) {
    var raw = window.atob(reply.result), encoded = "";
    for (var i = 0; i < raw.length; i++) {
        encoded += "%" + ("0" + raw.charCodeAt(i).toString(16)).slice(-2);
    }
    var state = JSON.parse(decodeURIComponent(encoded));
    if (!/^(cdn|direct|none)$/.test(state.target) || !/^(cdn|direct|unknown)$/.test(state.active)) throw Error("status");
    target = state.target;
    $(".cdn-route").each(function() {
        var route = $(this), key = route.attr("data-route"), active = state.active === key;
        var label = key === "cdn" ? "CDN" : "直连";
        route.toggleClass("is-active", active);
        route.find(".cdn-chip").prop("disabled", false).attr("aria-label",
            label + (active ? "，当前使用" : state.active === "unknown" ? "，状态未确认" : "，未使用"));
        route.find(".cdn-address").text(state[key] || "地址未识别");
        route.find(".cdn-tip-note").text(state.kind === "legacy" ? state.detail : "");
    });
    $("#cdn_detail").text(state.detail).toggle(!!state.detail);
    setLog(state.log.replace(/\s+$/, ""));
    var caption = target === "cdn" ? "切换到 CDN" : target === "direct" ? "切换到直连" : "当前页面无法切换";
    if (state.kind === "legacy" && target === "direct") caption = "取消 CDN 偏好";
    $("#cdn_button").val(caption)
        .prop("disabled", changing || target === "none");
}
function loadStatus() {
    request("status").done(function(reply) {
        try { showResult(reply); } catch (e) { unavailable(); }
    }).fail(unavailable);
}
function unavailable() {
    target = "none";
    $(".cdn-route").removeClass("is-active is-open").find(".cdn-chip").prop("disabled", true).attr("aria-expanded", "false");
    $("#cdn_detail").text("暂时无法读取状态，请刷新页面重试。").show();
    $("#cdn_button").val("状态未知").prop("disabled", true);
}
function switchServer() {
    if (changing || target === "none") return;
    changing = true;
    $("#cdn_button").prop("disabled", true);
    var previous = document.getElementById("cdn_log").value;
    var progress = target === "cdn" ? "正在检查 CDN 目录和回调…" : "正在恢复平台直连地址…";
    setLog(previous ? previous + "\n" + progress : progress);
    request(target).done(function(reply) {
        changing = false;
        try { showResult(reply); } catch (e) { unavailable(); }
    }).fail(function() {
        changing = false;
        loadStatus();
    });
}
function init() {
    var skin = '<% nvram_get("sc_skin"); %>'.toUpperCase();
    if (/^(ASUSWRT|ROG|TUF|TS)$/.test(skin)) document.body.setAttribute("skin", skin);
    function tip(route, open) {
        $(".cdn-route").removeClass("is-open").find(".cdn-chip").attr("aria-expanded", "false");
        if (open && !route.find(".cdn-chip").prop("disabled")) {
            route.addClass("is-open").find(".cdn-chip").attr("aria-expanded", "true");
        }
    }
    $(".cdn-route").on("mouseenter focusin click", function() { tip($(this), true); })
        .on("mouseleave focusout", function() { if ($(this).hasClass("is-open")) tip($(this), false); });
    $(document).on("keydown", function(e) { if (e.which === 27) tip(null, false); })
        .on("click", function(e) { if (!$(e.target).closest(".cdn-route").length) tip(null, false); });
    $(window).on("resize pageshow", scrollLogToEnd);
    loadStatus();
    show_menu(menu_hook);
}
</script>
</head>
<body id="app" skin="ASUSWRT" onload="init();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<table class="content" align="center" cellpadding="0" cellspacing="0">
<tr><td width="17"></td><td width="202" valign="top"><div id="mainMenu"></div><div id="subMenu"></div></td>
<td valign="top"><div id="tabMenu" class="submenuBlock"></div>
<table class="FormTitle" id="FormTitle" width="760" cellpadding="8" cellspacing="0"><tr><td bgcolor="#4D595D" valign="top">
<div class="cdn-heading"><div class="formfonttitle">软件中心CDN</div>
<a class="cdn-back" href="/Module_Softcenter.asp" title="返回软件中心"><img src="/images/backprev.png" alt="返回软件中心"></a></div>
<div class="splitLine cdn-rule"></div>
<ol class="cdn-intro"><li>本插件可将软件中心的服务器线路切换为直连或 CDN。</li>
<li>建议使用 CDN，以获得更好的插件下载体验。</li></ol>
<div class="splitLine cdn-rule"></div>
<table class="FormTable cdn-status-table" border="1" cellpadding="4" cellspacing="0"><tr>
<th scope="row">当前线路</th><td id="cdn_cell"><div class="cdn-routes">
<div class="cdn-route" data-route="direct"><button type="button" class="cdn-chip" aria-describedby="direct_tip" aria-expanded="false" disabled>直连</button>
<span class="cdn-tip" id="direct_tip" role="tooltip"><span class="cdn-tip-inner"><span class="cdn-address"></span><span class="cdn-tip-note"></span></span></span></div>
<div class="cdn-route" data-route="cdn"><button type="button" class="cdn-chip" aria-describedby="cdn_tip" aria-expanded="false" disabled>CDN</button>
<span class="cdn-tip" id="cdn_tip" role="tooltip"><span class="cdn-tip-inner"><span class="cdn-address"></span><span class="cdn-tip-note"></span></span></span></div>
</div><p id="cdn_detail" role="status">读取中…</p></td></tr></table>
<label class="cdn-log-label" for="cdn_log">切换日志</label>
<div class="soft_setting_log"><textarea id="cdn_log" class="soft_setting_log1" rows="8" readonly
    autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" placeholder="尚无切换记录。"></textarea></div>
<div class="apply_gen"><input id="cdn_button" class="button_gen" type="button" value="读取中…" onclick="switchServer();" disabled></div>
</td></tr></table></td></tr></table>
<div id="footer"></div>
</body>
</html>
