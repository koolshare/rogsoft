<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - NATMap 端口映射</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<style>
	input:focus { outline: none; }
	.button_gen { width: auto !important; padding: 4px 10px; }
	.button_gen:disabled { opacity: .35; cursor: not-allowed; }
		.natmap_table { table-layout: fixed; width: 100%; }
		.natmap_table td, .natmap_table th { padding: 6px 6px; }
		.natmap_table td { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
		.natmap_table thead th { background: rgba(0,0,0,.22); color: #fff; border-bottom: 1px solid rgba(255,255,255,.14); }
		#app[skin="ASUSWRT"] .natmap_table thead th { background: #4D595D; color: #fff; border-bottom-color: #222; }
		#app[skin="ROG"] .natmap_table thead th { background: rgba(145,7,31,.22); border-bottom-color: #91071f; }
		#app[skin="TUF"] .natmap_table thead th { background: rgba(208,152,44,.18); border-bottom-color: #D0982C; }
		#app[skin="TS"] .natmap_table thead th { background: rgba(46,217,195,.16); border-bottom-color: #2ed9c3; }
		.natmap_table tbody tr { cursor: pointer; }
		.natmap_table tbody tr:hover { background: rgba(255,255,255,.06); }
		.natmap_table tbody tr.selected { background: rgba(0,198,255,.12); box-shadow: inset 0 0 0 1px rgba(0,198,255,.45); }
		#app[skin="ASUSWRT"] .natmap_table tbody tr:hover { background: rgba(0,0,0,.05); }
		#app[skin="ASUSWRT"] .natmap_table tbody tr.selected { background: rgba(0,0,0,.08); box-shadow: inset 0 0 0 1px rgba(22,120,255,.45); }
		.natmap_table th.sel, .natmap_table td.sel { width: 26px; padding-left: 2px; padding-right: 2px; text-align: center; }
		.natmap_table th.name, .natmap_table td.name { width: 120px; text-align: center; }
		.natmap_table th:nth-child(5), .natmap_table td:nth-child(5) { text-align: center; }
		.natmap_table th:nth-child(6), .natmap_table td:nth-child(6) { text-align: center; }
		.natmap_small { font-size: 12px; opacity: .9; }
		.natmap_link { color: #00c6ff; font-weight: 600; text-decoration: underline; }
	.tag { display:inline-block; padding:2px 6px; border:1px solid rgba(255,255,255,.2); border-radius:10px; font-size:12px; margin-left:6px; }
	.tag.ok { color:#a2ff00; border-color:rgba(162,255,0,.35); }
	.tag.warn { color:#ffcc00; border-color:rgba(255,204,0,.35); }
	.tag.err { color:#ff6666; border-color:rgba(255,102,102,.35); }
	.natmap_ops { margin-top: 8px; text-align: right; }
	.natmap_ops .button_gen { min-width: 68px; }
	.natmap_mapped { font-family: 'Lucida Console', Monaco, monospace; font-size: 12px; }

			/* popup editor */
			.natmap_mask { display:none; z-index: 9998; position: absolute; top: 0; left: 0; width: 100%; }
			.natmap_popup {
				position: absolute;
				z-index: 9999;
				top: 80px;
				left: 50%;
				transform: translateX(-50%);
				width: 740px;
				background: rgba(0,0,0,0.88);
				border: 1px solid rgba(255,255,255,.18);
				border-radius: 10px;
				box-shadow: 3px 3px 10px #000;
				display: none;
			}
			#app[skin="ROG"] .natmap_popup { border-color: #91071f; }
			#app[skin="TUF"] .natmap_popup { border-color: #D0982C; }
			#app[skin="TS"] .natmap_popup { border-color: #2ed9c3; }
			#app[skin="ASUSWRT"] .natmap_popup { border-color: #222; }
			#natmap_editor { top: 150px; left: calc(50%); }
	.natmap_popup_head{
		padding: 10px 12px;
		font-size: 16px;
		font-weight: 700;
		color: #99FF00;
		text-align: center;
		position: relative;
	}
	.natmap_close {
		position: absolute;
		right: 10px;
		top: 8px;
		width: 18px;
		height: 18px;
		line-height: 18px;
		border-radius: 12px;
		background: #b00020;
		color: #000;
		cursor: pointer;
	}
	.natmap_close::before { content: "\u2716"; display:block; text-align:center; font-size: 14px; }
	.natmap_popup_body{ padding: 0 12px 12px 12px; }

		/* log popup customization */
		#natmap_log { background: #000 !important; opacity: 1 !important; top: 260px; left: calc(50% + 97px); width: 780px !important; }
		#natmap_log textarea { width: 100% !important; box-sizing: border-box !important; background: #000 !important; opacity: 1 !important; color: #fff !important; border: 1px solid #111 !important; overflow-y: auto !important; scrollbar-width: none; -ms-overflow-style: none; }
		#natmap_log textarea::-webkit-scrollbar { width: 0; height: 0; }
		#natmap_log .log_actions { background: #000 !important; opacity: 1 !important; padding: 8px 0 0 0; }
		#natmap_log .apply_gen { background: #000 !important; }
		#natmap_log_mask {
			position: absolute;
			top: 0;
			left: 0;
			width: 100%;
			height: 100%;
			z-index: 9998;
			display: none;
			background: rgba(0,0,0,0.55);
		}
	</style>
	<script>
	var dbus = {};
	var editId = "";
	var currentLogId = "";
	var editorInited = false;
	var selectedId = "";
	var logTimer = null;
	var logAutoScroll = true;
	var logIgnoreScroll = false;
	var ruleCount = 0;

function b64e(s){
	if (typeof btoa === "function") {
		return btoa(unescape(encodeURIComponent(s)));
	}
	return Base64.encode(s);
}
function b64d(s){
	if (typeof atob === "function") {
		return decodeURIComponent(escape(atob(s)));
	}
	return Base64.decode(s);
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "natmap");
	tablink[tablink.length - 1] = new Array("", "Module_natmap.asp");
}

	function init() {
		show_menu(menu_hook);
		get_dbus_data();
		$("#rule_proto").change(function(){ toggle_proto_fields(); });
		$("#rule_target_mode").change(function(){ toggle_target_fields(); });
		$("#log_content_text").on("scroll", function(){
			if (logIgnoreScroll) return;
			var el = this;
			var remain = el.scrollHeight - (el.scrollTop + el.clientHeight);
			logAutoScroll = (remain < 20);
		});
	}

function get_dbus_data(){
	$.ajax({
		type: "GET",
		url: "/_api/natmap",
		dataType: "json",
		async: true,
		cache: false,
		success: function(data) {
			dbus = (data.result && data.result[0]) ? data.result[0] : {};
			if (dbus["natmap_version"]) {
				$("#natmap_version").html("当前版本：" + dbus["natmap_version"]);
			}
			render_rules();
			toggle_proto_fields();
			toggle_target_fields();
			if (!editorInited) {
				reset_editor();
				editorInited = true;
			}
			if (currentLogId) {
				get_log(currentLogId, 1);
			}
		}
	});
}

function render_rules(){
	var ids = (dbus["natmap_rule_ids"] && dbus["natmap_rule_ids"] != "null") ? dbus["natmap_rule_ids"] : "";
	var list = [];
	if (ids) {
		list = ids.split(",");
	}
	var html = "";
	ruleCount = 0;
	for (var i = 0; i < list.length; i++) {
		var id = $.trim(list[i]);
		if (!id) continue;
		var b64 = dbus["natmap_rule_" + id];
		if (!b64 || b64 == "null") continue;
		var jsonStr = "";
		try { jsonStr = b64d(b64); } catch(e) { jsonStr = ""; }
		var obj = {};
		try { obj = JSON.parse(jsonStr || "{}"); } catch(e) { obj = {}; }
		var name = obj.name || ("rule-" + id);
		var enable = (obj.enable == "1");
		var proto = (obj.proto == "udp") ? "UDP" : "TCP";
		var ipver = (obj.ipver == "6") ? "IPv6" : "IPv4";
		var mode = obj.target_mode || "direct";
		var target = "";
		if (mode == "relay") {
			target = "中转 → " + (obj.target_addr || "") + ":" + (obj.target_port || "");
		} else if (mode == "firewall") {
			target = "防火墙中转（需自行配置端口转发）";
		} else {
			target = "直接绑定（本机服务）";
		}
		var status = dbus["natmap_rule_" + id + "_status"] || "stopped";
		var publicMap = dbus["natmap_rule_" + id + "_public"] || "";
		var tag = "<span class='tag'>" + status + "</span>";
			if (status == "running") tag = "<span class='tag ok'>running</span>";
			if (status == "error") tag = "<span class='tag err'>error</span>";
			if (status == "disabled") tag = "<span class='tag warn'>disabled</span>";
			var checked = (selectedId && selectedId == id) ? " checked='checked'" : "";
			var trClass = (selectedId && selectedId == id) ? " class='selected'" : "";
			html += "<tr id='natmap_rule_row_" + id + "'" + trClass + " onclick='select_rule(\"" + id + "\")'>";
			html += "<td class='sel'><input type='radio' name='natmap_sel' value='" + id + "' onclick='select_rule(\"" + id + "\")'" + checked + "></td>";
			html += "<td class='name' title='" + htmlEscape(name) + "'>" + htmlEscape(name) + (enable ? "" : " <span class='tag warn'>off</span>") + "</td>";
			html += "<td style='text-align:center;'>" + proto + "/" + ipver + "</td>";
			html += "<td title='" + htmlEscape(target) + "'>" + htmlEscape(target) + "</td>";
			html += "<td>" + tag + "</td>";
			html += "<td class='natmap_mapped' title='" + htmlEscape(publicMap) + "'>" + htmlEscape(publicMap) + "</td>";
			html += "</tr>";
		ruleCount++;
	}
	if (!html) {
		html = "<tr><td colspan='6' style='text-align:center; padding:16px;'>暂无映射任务，请在下方添加。</td></tr>";
	}
	$("#rules_tbody").html(html);
	update_ops_visibility();
	update_ops_state();
}

function htmlEscape(s){
	return String(s || "").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/\"/g, "&quot;").replace(/'/g, "&#39;");
}

function toggle_proto_fields() {
	var p = $("#rule_proto").val();
	if (p == "udp") {
		$("#http_row").hide();
		$("#cycle_row").show();
		$("#ccalgo_row").hide();
		var cur = $.trim(E("rule_stun").value || "");
		if (!cur || cur == "stun.nextcloud.com:3478") {
			E("rule_stun").value = "stun.miwifi.com:3478";
		}
	} else {
		$("#http_row").show();
		$("#cycle_row").hide();
		$("#ccalgo_row").show();
		var cur2 = $.trim(E("rule_stun").value || "");
		if (!cur2 || cur2 == "stun.miwifi.com:3478") {
			E("rule_stun").value = "stun.nextcloud.com:3478";
		}
		if (!$.trim(E("rule_http").value || "")) {
			E("rule_http").value = "www.baidu.com:80";
		}
	}
}

function toggle_target_fields() {
	var m = $("#rule_target_mode").val();
	if (m == "relay") {
		$("#target_row").show();
		$("#timeout_row").show();
	} else {
		$("#target_row").hide();
		$("#timeout_row").hide();
	}
}

function save_global(){
	return;
}

	function build_rule_obj(){
		var obj = {};
		obj.enable = E("rule_enable").checked ? "1" : "0";
		obj.name = $.trim(E("rule_name").value || "");
		obj.proto = $("#rule_proto").val();
		obj.ipver = $("#rule_ipver").val();
		obj.iface = $.trim(E("rule_iface").value || "");
		obj.bind = $.trim(E("rule_bind").value || "0");
		obj.stun = $.trim(E("rule_stun").value || "");
		obj.http = $.trim(E("rule_http").value || "");
		obj.keep = $.trim(E("rule_keep").value || "");
		obj.cycle = $.trim(E("rule_cycle").value || "");
		obj.fwmark = $.trim(E("rule_fwmark").value || "");
		obj.notify_script = $.trim(E("rule_notify").value || "");
		obj.target_mode = $("#rule_target_mode").val();
		obj.target_addr = $.trim(E("rule_target_addr").value || "");
		obj.target_port = $.trim(E("rule_target_port").value || "");
		obj.timeout = $.trim(E("rule_timeout").value || "");
		obj.ccalgo = $.trim(E("rule_ccalgo").value || "");
	return obj;
}

function validate_rule(obj){
	if (!obj.name) {
		alert("请填写任务名称！");
		return false;
	}
	if (!obj.stun) {
		alert("请填写 STUN 服务器（格式：host:port）！");
		return false;
	}
	if (obj.stun.indexOf("]") > -1) {
		if (!/\]:\d+$/.test(obj.stun)) { alert("STUN 未指定端口，请使用 [IPv6]:port 或 host:port 格式！"); return false; }
	} else {
		if (!/:\d+$/.test(obj.stun)) { alert("STUN 未指定端口，请使用 host:port 格式（例如：stun.example.com:3478）！"); return false; }
	}
	if (obj.proto == "tcp") {
		if (!obj.http) { alert("TCP 模式必须填写 HTTP 服务器（host:port）！"); return false; }
	}
	if (obj.target_mode == "relay") {
		if (!obj.target_addr || !obj.target_port) { alert("natmap 中转模式需要填写目标地址和端口！"); return false; }
		if (!/^\d+$/.test(obj.target_port)) { alert("目标端口必须是数字！"); return false; }
	}
	return true;
}

	function reset_editor(){
		editId = "";
		$("#rule_title").html("新增映射任务");
		E("rule_enable").checked = true;
		E("rule_name").value = "";
		$("#rule_proto").val("tcp");
		$("#rule_ipver").val("4");
		E("rule_iface").value = "";
		E("rule_bind").value = "0";
		E("rule_stun").value = "stun.nextcloud.com:3478";
		E("rule_http").value = "www.baidu.com:80";
		E("rule_keep").value = "";
		E("rule_cycle").value = "";
		E("rule_fwmark").value = "";
		E("rule_notify").value = "";
		$("#rule_target_mode").val("direct");
		E("rule_target_addr").value = "";
		E("rule_target_port").value = "0";
		E("rule_timeout").value = "";
		E("rule_ccalgo").value = "";
	toggle_proto_fields();
	toggle_target_fields();
}

	function select_rule(id){
		selectedId = id || "";
		$("#rules_tbody tr").removeClass("selected");
		if (selectedId) {
			$("#natmap_rule_row_" + selectedId).addClass("selected");
			$("input[name='natmap_sel'][value='" + selectedId + "']").prop("checked", true);
		}
		update_ops_state();
	}

	function get_scroll_top(){
		return window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop || 0;
	}

	function get_doc_height(){
		var b = document.body;
		var e = document.documentElement;
		return Math.max(b.scrollHeight, e.scrollHeight, b.offsetHeight, e.offsetHeight, b.clientHeight, e.clientHeight);
	}

	function position_popups(){
		var st = get_scroll_top();
		$("#natmap_editor").css("top", (st + 150) + "px");
		$("#natmap_log").css("top", (st + 260) + "px");
		var h = get_doc_height();
		$("#natmap_mask").css("height", h + "px");
		$("#natmap_log_mask").css("height", h + "px");
	}

function update_ops_state(){
	var has = !!selectedId;
	E("op_edit").disabled = !has;
	E("op_start").disabled = !has;
	E("op_stop").disabled = !has;
	E("op_log").disabled = !has;
	E("op_del").disabled = !has;
	$("#sel_tip").html(has ? ("当前选择任务 ID=" + selectedId) : "未选择任务");
}

function update_ops_visibility(){
	// if no rules, only show "新增"
	if (ruleCount > 0) {
		$("#op_edit,#op_start,#op_stop,#op_log,#op_del").show();
	} else {
		$("#op_edit,#op_start,#op_stop,#op_log,#op_del").hide();
		selectedId = "";
	}
}

	function open_editor(){
		// close log popup if open
		close_log_popup(true);
		position_popups();
		$("#natmap_mask").fadeIn(100);
		$("#natmap_editor").fadeIn(150);
	}

function close_editor(){
	$("#natmap_editor").fadeOut(120);
	$("#natmap_mask").fadeOut(120);
}

function op_add(){
	reset_editor();
	open_editor();
}

function op_edit(){ if (selectedId) edit_rule(selectedId); }
function op_start(){ if (selectedId) start_rule(selectedId); }
function op_stop(){ if (selectedId) stop_rule(selectedId); }
function op_log(){ if (selectedId) show_log(selectedId); }
function op_del(){ if (selectedId) delete_rule(selectedId); }

		function open_log_popup(){
			// close editor popup if open
			$("#natmap_editor").hide();
			position_popups();
			$("#natmap_log_mask").fadeIn(100);
			$("#natmap_log").fadeIn(150);
		}

function close_log_popup(silent){
	stop_log_poll();
	currentLogId = "";
	$("#natmap_log").fadeOut(120);
	$("#natmap_log_mask").fadeOut(120);
}

function submit_rule(){
	var obj = build_rule_obj();
	if (!validate_rule(obj)) return;
	var b64 = b64e(JSON.stringify(obj));
	var fields = {"natmap_rule_payload": b64};
	var id = parseInt(Math.random() * 100000000);
	var params;
	if (editId) {
		params = [3, editId];
	} else {
		params = [2];
	}
	var postData = {"id": id, "method": "natmap_config.sh", "params": params, "fields": fields};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "text",
		success: function() {
			reset_editor();
			close_editor();
			setTimeout("get_dbus_data();", 300);
		},
		error: function(xhr, status, err) {
			// Some firmwares may return non-JSON content with HTTP 200 (parsererror),
			// while the backend action is already done. Treat HTTP 200 as success.
			if (xhr && xhr.status == 200) {
				reset_editor();
				close_editor();
				setTimeout("get_dbus_data();", 300);
				return;
			}
			alert("保存失败！HTTP=" + (xhr && xhr.status ? xhr.status : "0") + "，请刷新页面后重试。");
		}
	});
}

	function edit_rule(id){
		var b64 = dbus["natmap_rule_" + id];
		if (!b64 || b64 == "null") return;
	var jsonStr = "";
	try { jsonStr = b64d(b64); } catch(e) { jsonStr = ""; }
	var obj = {};
	try { obj = JSON.parse(jsonStr || "{}"); } catch(e) { obj = {}; }
	editId = id;
	$("#rule_title").html("编辑映射任务 ID=" + id);
	E("rule_enable").checked = (obj.enable == "1");
	E("rule_name").value = obj.name || "";
	$("#rule_proto").val(obj.proto || "tcp");
	$("#rule_ipver").val(obj.ipver || "4");
		E("rule_iface").value = obj.iface || "";
		E("rule_bind").value = obj.bind || "0";
		E("rule_stun").value = obj.stun || ((obj.proto == "udp") ? "stun.miwifi.com:3478" : "stun.nextcloud.com:3478");
		E("rule_http").value = obj.http || "www.baidu.com:80";
		E("rule_keep").value = obj.keep || "";
		E("rule_cycle").value = obj.cycle || "";
		E("rule_fwmark").value = obj.fwmark || "";
		E("rule_notify").value = obj.notify_script || "";
		$("#rule_target_mode").val(obj.target_mode || "direct");
		E("rule_target_addr").value = obj.target_addr || "";
		E("rule_target_port").value = obj.target_port || "0";
		E("rule_timeout").value = obj.timeout || "";
		E("rule_ccalgo").value = obj.ccalgo || "";
	toggle_proto_fields();
	toggle_target_fields();
	open_editor();
}

function delete_rule(id){
	if (!confirm("确认删除该任务（ID=" + id + "）？")) return;
	var rid = parseInt(Math.random() * 100000000);
	var postData = {"id": rid, "method": "natmap_config.sh", "params": [7, id], "fields": {}};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function() {
			if (selectedId == id) selectedId = "";
			setTimeout("get_dbus_data();", 300);
		}
	});
}

function start_rule(id){
	var rid = parseInt(Math.random() * 100000000);
	var postData = {"id": rid, "method": "natmap_config.sh", "params": [4, id], "fields": {}};
	$.ajax({ type: "POST", url: "/_api/", data: JSON.stringify(postData), dataType: "json", success: function(){ setTimeout("get_dbus_data();", 500); }});
}

function stop_rule(id){
	var rid = parseInt(Math.random() * 100000000);
	var postData = {"id": rid, "method": "natmap_config.sh", "params": [5, id], "fields": {}};
	$.ajax({ type: "POST", url: "/_api/", data: JSON.stringify(postData), dataType: "json", success: function(){ setTimeout("get_dbus_data();", 500); }});
}

function restart_rule(id){
	var rid = parseInt(Math.random() * 100000000);
	var postData = {"id": rid, "method": "natmap_config.sh", "params": [6, id], "fields": {}};
	$.ajax({ type: "POST", url: "/_api/", data: JSON.stringify(postData), dataType: "json", success: function(){ setTimeout("get_dbus_data();", 800); }});
}

	function show_log(id){
		currentLogId = id;
		logAutoScroll = true;
		var name = "";
		try {
			var b64 = dbus["natmap_rule_" + id];
			if (b64 && b64 != "null") {
				var obj = JSON.parse(b64d(b64) || "{}");
			name = obj.name || "";
		}
	} catch(e) { name = ""; }
	$("#log_popup_title").text(name ? ("日志 - " + name) : "日志");
	$("#log_content_text").val("");
	open_log_popup();
	get_log(id, 1);
}

function clear_log(){
	if (!currentLogId) return;
	var rid = parseInt(Math.random() * 100000000);
	var postData = {"id": rid, "method": "natmap_config.sh", "params": [8, currentLogId], "fields": {}};
	$.ajax({ type: "POST", url: "/_api/", data: JSON.stringify(postData), dataType: "json", success: function(){ setTimeout("get_log(" + currentLogId + ");", 300); }});
}

function stop_log_poll(){
	if (logTimer) {
		clearTimeout(logTimer);
		logTimer = null;
	}
}

	function get_log(id, action){
	// prevent multi-rule polling overlap
	if (action) {
		stop_log_poll();
	}
		$.ajax({
			url: "/_temp/natmap_" + id + ".log",
			type: "GET",
			cache: false,
			dataType: "text",
			success: function(response){
				if (currentLogId && id != currentLogId) return;
				var el = E("log_content_text");
				var prevTop = el.scrollTop;
				logIgnoreScroll = true;
				el.value = response || "";
				if (logAutoScroll) {
					el.scrollTop = el.scrollHeight;
				} else {
					el.scrollTop = prevTop;
				}
				logIgnoreScroll = false;
				if(action){
					logTimer = setTimeout(function(){ get_log(id, 1); }, 800);
				}
			},
			error: function(){
			if (currentLogId && id != currentLogId) return;
			if(action){
				logTimer = setTimeout(function(){ get_log(id, 1); }, 1200);
			}
		}
	});
}
	</script>
	</head>
<body id="app" skin="<% nvram_get(\"sc_skin\"); %>" onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
	<table class="content" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td width="17">&nbsp;</td>
			<td valign="top" width="202">
				<div id="mainMenu"></div>
				<div id="subMenu"></div>
			</td>
			<td valign="top">
				<div id="tabMenu" class="submenuBlock"></div>
				<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
					<tr>
						<td align="left" valign="top">
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div class="formfonttitle">网络工具 - NATMap 端口映射 <lable id="natmap_version"></lable></div>
										<div style="float:right; width:15px; height:25px;margin-top:-20px">
											<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
										</div>
										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>

										<div class="SimpleNote">
											<div>1. NATMap 适用于 WAN 侧 NAT1（Full Cone）网络，用于打通公网 TCP/UDP 端口映射。</div>
											<div>2. 多任务=多进程：每个映射任务会启动一个 natmap 进程。</div>
											<div>3. 任务状态与公网映射信息会在 natmap 运行过程中持续更新。</div>
										</div>

										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>

										<table width="100%" border="0" align="center" cellpadding="4" cellspacing="0" class="FormTable natmap_table">
												<thead>
													<tr>
														<th class="sel">选择</th>
														<th class="name">名称</th>
														<th style="width:80px;">协议/IP族</th>
														<th>转发/模式</th>
														<th style="width:90px;">状态</th>
														<th style="width:170px;">公网映射</th>
													</tr>
												</thead>
											<tbody id="rules_tbody"></tbody>
										</table>
											<div class="natmap_ops">
												<span id="sel_tip" class="natmap_small" style="float:left; margin-top:6px;">未选择任务</span>
												<input class="button_gen" id="op_add" type="button" value="新增" onclick="op_add()" />
												<input class="button_gen" id="op_edit" style="margin-left:4px;" type="button" value="编辑" onclick="op_edit()" disabled="disabled" />
												<input class="button_gen" id="op_start" style="margin-left:8px;" type="button" value="启动" onclick="op_start()" disabled="disabled" />
												<input class="button_gen" id="op_stop" style="margin-left:8px;" type="button" value="停止" onclick="op_stop()" disabled="disabled" />
												<input class="button_gen" id="op_log" style="margin-left:8px;" type="button" value="日志" onclick="op_log()" disabled="disabled" />
												<input class="button_gen" id="op_del" style="margin-left:8px;" type="button" value="删除" onclick="op_del()" disabled="disabled" />
											</div>

											<div id="natmap_editor" class="natmap_popup">
												<div class="natmap_popup_head">
													映射任务配置
												</div>
											<div class="natmap_popup_body">
												<div class="formfontdesc" id="rule_title">新增映射任务</div>
										<table width="100%" border="0" align="center" cellpadding="4" cellspacing="0" class="FormTable">
											<tr>
												<th>启用</th>
												<td><label><input type="checkbox" id="rule_enable" checked="checked" style="vertical-align:middle;"> 启用该任务</label></td>
											</tr>
											<tr>
												<th>名称</th>
												<td><input id="rule_name" class="input_ss_table" style="width:360px;" value="" placeholder="例如：SSH 映射" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" /></td>
											</tr>
											<tr>
												<th>协议</th>
												<td>
													<select id="rule_proto" class="input_option" style="width:160px;">
														<option value="tcp">TCP</option>
														<option value="udp">UDP</option>
													</select>
													<span class="natmap_small" style="margin-left:8px;">UDP模式启用 -u</span>
												</td>
											</tr>
											<tr>
												<th>IP族</th>
												<td>
													<select id="rule_ipver" class="input_option" style="width:160px;">
														<option value="4">IPv4</option>
														<option value="6">IPv6</option>
													</select>
												</td>
											</tr>
											<tr>
												<th>绑定出口（可选）</th>
												<td>
													<input id="rule_iface" class="input_ss_table" style="width:360px;" value="" placeholder="接口名或源IP，例如：ppp0 / eth0 / 192.168.1.2" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
													<span class="natmap_small" style="margin-left:8px;">对应 -i</span>
												</td>
											</tr>
											<tr>
												<th>绑定端口</th>
												<td>
													<input id="rule_bind" class="input_ss_table" style="width:360px;" value="0" placeholder="0 / 端口 / a~b / a-b" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
													<span class="natmap_small" style="margin-left:8px;">对应 -b</span>
												</td>
											</tr>
											<tr>
												<th>STUN 服务器</th>
												<td>
													<input id="rule_stun" class="input_ss_table" style="width:360px;" value="" placeholder="stun.miwifi.com:3478" onkeyup="this.value=this.value.replace(/\s+/g,'')" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
													<span class="natmap_small" style="margin-left:8px;">必填，对应 -s</span>
												</td>
											</tr>
											<tr id="http_row">
												<th>HTTP 服务器（TCP）</th>
												<td>
													<input id="rule_http" class="input_ss_table" style="width:360px;" value="" placeholder="www.baidu.com:80" onkeyup="this.value=this.value.replace(/\s+/g,'')" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
													<span class="natmap_small" style="margin-left:8px;">TCP必填，对应 -h</span>
												</td>
											</tr>
											<tr>
												<th>KeepAlive（秒）</th>
												<td>
													<input id="rule_keep" class="input_ss_table" style="width:160px;" value="" placeholder="留空使用默认" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
													<span class="natmap_small" style="margin-left:8px;">对应 -k</span>
												</td>
											</tr>
											<tr id="cycle_row" style="display:none;">
												<th>UDP STUN 周期</th>
												<td>
													<input id="rule_cycle" class="input_ss_table" style="width:160px;" value="" placeholder="例如：10" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
													<span class="natmap_small" style="margin-left:8px;">对应 -c（每 N 次 keepalive 做一次 STUN 检查）</span>
												</td>
											</tr>
											<tr id="ccalgo_row">
												<th>TCP 拥塞算法</th>
												<td>
													<input id="rule_ccalgo" class="input_ss_table" style="width:160px;" value="" placeholder="例如：bbr" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
													<span class="natmap_small" style="margin-left:8px;">对应 -C（可选）</span>
												</td>
											</tr>
												<tr>
													<th>fwmark（可选）</th>
													<td>
														<input id="rule_fwmark" class="input_ss_table" style="width:160px;" value="" placeholder="0x1 / 1" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
														<span class="natmap_small" style="margin-left:8px;">对应 -f（策略路由场景）</span>
													</td>
												</tr>
												<tr>
													<th>通知脚本（可选）</th>
													<td>
														<input id="rule_notify" class="input_ss_table" style="width:360px;" value="" placeholder="/koolshare/scripts/natmap_user_notify.sh" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
														<span class="natmap_small" style="margin-left:8px;">映射更新时异步执行，将 natmap_notify 的参数原样传入</span>
													</td>
												</tr>
												<tr>
													<th>运行方式</th>
													<td>
														<select id="rule_target_mode" class="input_option" style="width:260px;">
														<option value="direct">直接绑定（本机服务）</option>
														<option value="firewall">防火墙中转（需自行配置端口转发）</option>
														<option value="relay">natmap 中转（免端口转发）</option>
													</select>
												</td>
											</tr>
											<tr id="target_row" style="display:none;">
												<th>中转目标</th>
												<td>
													<input id="rule_target_addr" class="input_ss_table" style="width:240px;" value="" placeholder="目标地址，例如：192.168.1.100" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
													<input id="rule_target_port" class="input_ss_table" style="width:100px; margin-left:10px;" value="0" placeholder="端口" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
													<span class="natmap_small" style="margin-left:8px;">对应 -t/-p（端口 0 表示使用公网端口）</span>
												</td>
											</tr>
											<tr id="timeout_row" style="display:none;">
												<th>中转超时</th>
												<td>
													<input id="rule_timeout" class="input_ss_table" style="width:160px;" value="" placeholder="例如：300" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
													<span class="natmap_small" style="margin-left:8px;">对应 -T（秒，可选）</span>
												</td>
											</tr>
										</table>
										<div class="apply_gen">
											<input class="button_gen" type="button" value="保存任务" onclick="submit_rule()" />
											<input class="button_gen" style="margin-left:10px;" type="button" value="取消" onclick="close_editor()" />
										</div>
	
												</div>
											</div>
										</td>
									</tr>
								</table>
						</td>
					</tr>
				</table>
			</td>
			<td width="10" align="center" valign="top"></td>
		</tr>
	</table>
	<div id="natmap_mask" class="popup_bg natmap_mask"></div>
	<div id="natmap_log_mask"></div>
	<div id="natmap_log" class="natmap_popup">
		<div class="natmap_popup_head">
			<span id="log_popup_title">日志</span>
		</div>
		<div class="natmap_popup_body">
			<div class="soft_setting_log">
				<textarea cols="63" rows="18" wrap="on" readonly="readonly" id="log_content_text" class="soft_setting_log1" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
			</div>
			<div class="log_actions">
				<div class="apply_gen">
					<input class="button_gen" type="button" value="清空日志" onclick="clear_log()" />
					<input class="button_gen" style="margin-left:10px;" type="button" value="关闭" onclick="close_log_popup()" />
				</div>
			</div>
		</div>
	</div>
	<div id="footer"></div>
</body>
</html>
