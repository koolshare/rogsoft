<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - Npc 内网穿透</title>
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
	.npc_textarea {
		width: 99%;
		font-family: 'Lucida Console', Monaco, monospace;
		font-size: 12px;
		color: #FFFFFF;
		text-transform: none;
		margin-top: 6px;
		overflow: auto;
		resize: vertical;
		white-space: pre-wrap;
		word-break: break-word;
		background: rgba(0,0,0,0.18);
		border: 1px solid rgba(255,255,255,.18);
	}
	#app[skin="ASUSWRT"] .npc_textarea { background: #475A5F; border-color: #222; }
	#app[skin="ROG"] .npc_textarea { background: transparent; border-color: #91071f; }
	#app[skin="TUF"] .npc_textarea { background: transparent; border-color: #D0982C; }
	#app[skin="TS"] .npc_textarea { background: transparent; border-color: #2ed9c3; }

	/* submit log modal */
	.npc_log_mask {
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		z-index: 9998;
		background: rgba(68,79,83,0.94);
		display: none;
	}
	.npc_log_modal {
		position: fixed;
		top: 120px;
		left: 50%;
		transform: translateX(-50%);
		z-index: 9999;
		width: 740px;
		background: rgba(0,0,0,0.88);
		border: 1px solid rgba(255,255,255,.18);
		border-radius: 10px;
		box-shadow: 3px 3px 10px #000;
		display: none;
		padding: 10px;
	}
	#app[skin="ASUSWRT"] .npc_log_modal { border-color: #222; }
	#app[skin="ROG"] .npc_log_modal { border-color: #91071f; }
	#app[skin="TUF"] .npc_log_modal { border-color: #D0982C; }
	#app[skin="TS"] .npc_log_modal { border-color: #2ed9c3; }
	.npc_log_title {
		text-align: center;
		font-size: 18px;
		color: #99FF00;
		padding: 6px 0 10px 0;
		font-weight: bold;
	}
	.npc_log_area {
		width: 100%;
		border: 0;
		font-family: "Lucida Console";
		font-size: 11px;
		background: transparent;
		color: #ffffff;
		outline: none;
		overflow-x: hidden;
		resize: none;
	}
	.npc_log_btns { text-align: center; padding-top: 10px; }
</style>

<script>
var db_npc = {};
var npc_log_poll_tries = 0;
var params_input = [
	"npc_server_addr",
	"npc_vkey",
	"npc_disconnect_timeout",
	"npc_max_conn",
	"npc_flow_limit",
	"npc_rate_limit"
];
var params_select = [
	"npc_mode",
	"npc_conn_type",
	"npc_log_level"
];
var params_check = [
	"npc_enable",
	"npc_customize_conf",
	"npc_auto_reconnection",
	"npc_crypt",
	"npc_compress"
];
var params_base64 = ["npc_config"];

function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "npc");
	tablink[tablink.length - 1] = new Array("", "Module_npc.asp");
}

function init() {
	show_menu(menu_hook);
	get_dbus_data();
	get_status();

	$("#npc_mode").change(function() { toggle_mode(); });
	$("#npc_customize_conf").change(function() { toggle_mode(); });
}

function get_status() {
	$.ajax({
		type: "GET",
		url: "/_api/npc_status.sh",
		dataType: "text",
		cache: false,
		success: function(data) {
			$("#npc_status").html(data);
		},
		error: function() {
			$("#npc_status").html("状态获取失败");
		}
	});
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/npc",
		dataType: "json",
		async: false,
		cache: false,
		success: function(data) {
			db_npc = (data.result && data.result[0]) ? data.result[0] : {};
			$("#npc_version_show").html("插件版本：" + (db_npc["npc_version"] || ""));
			conf2obj();
		}
	});
}

function conf2obj() {
	for (var i = 0; i < params_input.length; i++) {
		if (db_npc[params_input[i]] != null && db_npc[params_input[i]] != "null") {
			E(params_input[i]).value = db_npc[params_input[i]];
		}
	}
	for (var i = 0; i < params_select.length; i++) {
		if (db_npc[params_select[i]] != null && db_npc[params_select[i]] != "null") {
			E(params_select[i]).value = db_npc[params_select[i]];
		}
	}
	for (var i = 0; i < params_check.length; i++) {
		var k = params_check[i];
		if (k == "npc_enable") {
			E(k).checked = (db_npc[k] == "1");
		} else if (k == "npc_customize_conf") {
			E(k).checked = (db_npc[k] == "1");
		} else {
			E(k).checked = (db_npc[k] == "true" || db_npc[k] == "1");
		}
	}
	for (var i = 0; i < params_base64.length; i++) {
		if (db_npc[params_base64[i]] != null && db_npc[params_base64[i]] != "null") {
			E(params_base64[i]).value = Base64.decode(db_npc[params_base64[i]]);
		}
	}
	toggle_mode();
}

function toggle_mode() {
	var mode = E("npc_mode").value;
	var custom = E("npc_customize_conf").checked;
	if (mode == "cmd") {
		$("#npc_customize_tr").hide();
		$("#npc_config_tr").hide();
	} else {
		$("#npc_customize_tr").show();
		if (custom) {
			$("#npc_config_tr").show();
		} else {
			$("#npc_config_tr").hide();
		}
	}
}

function collect_data() {
	var data = {};
	data["npc_enable"] = E("npc_enable").checked ? "1" : "0";
	data["npc_mode"] = E("npc_mode").value;
	data["npc_conn_type"] = E("npc_conn_type").value;
	data["npc_server_addr"] = E("npc_server_addr").value;
	data["npc_vkey"] = E("npc_vkey").value;
	data["npc_log_level"] = E("npc_log_level").value;

	data["npc_customize_conf"] = E("npc_customize_conf").checked ? "1" : "0";
	data["npc_auto_reconnection"] = E("npc_auto_reconnection").checked ? "true" : "false";
	data["npc_crypt"] = E("npc_crypt").checked ? "true" : "false";
	data["npc_compress"] = E("npc_compress").checked ? "true" : "false";

	data["npc_disconnect_timeout"] = E("npc_disconnect_timeout").value;
	data["npc_max_conn"] = E("npc_max_conn").value;
	data["npc_flow_limit"] = E("npc_flow_limit").value;
	data["npc_rate_limit"] = E("npc_rate_limit").value;

	data["npc_config"] = Base64.encode(E("npc_config").value);
	return data;
}

function npc_log_clean(s){
	if (!s) return "";
	return s
		.replace(/\\r/g, "")
		.replace(/^.*NPC_RESULT=.*$/gm, "")
		.replace(/^.*XU6J03M16.*$/gm, "")
		.replace(/\\n{3,}/g, "\\n\\n")
		.trim() + "\\n";
}

function show_npc_log(title) {
	E("npc_log_title").innerHTML = title || "Npc 提交日志";
	E("npc_log_content").value = "";
	$(".npc_log_mask").show();
	$(".npc_log_modal").show();
}

function hide_npc_log() {
	$(".npc_log_modal").hide();
	$(".npc_log_mask").hide();
}

function get_npc_submit_log(){
	$.ajax({
		url: '/_temp/npc_submit_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("npc_log_content");
			var done = (response.indexOf("XU6J03M16") != -1);
			retArea.value = npc_log_clean(response);
			retArea.scrollTop = retArea.scrollHeight;
			if (done) {
				E("npc_log_close_btn").disabled = false;
				get_status();
				return;
			}
			setTimeout("get_npc_submit_log();", 500);
		},
		error: function() {
			npc_log_poll_tries++;
			if (npc_log_poll_tries <= 20) {
				setTimeout("get_npc_submit_log();", 500);
				return;
			}
			E("npc_log_content").value = "暂无日志信息 ...";
			E("npc_log_close_btn").disabled = false;
		}
	});
}

function view_npc_submit_log(){
	show_npc_log("Npc 上次提交日志");
	E("npc_log_close_btn").disabled = false;
	$.ajax({
		url: '/_temp/npc_submit_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("npc_log_content");
			retArea.value = npc_log_clean(response);
			retArea.scrollTop = retArea.scrollHeight;
		},
		error: function() {
			E("npc_log_content").value = "暂无上次提交日志，请先点击提交。";
		}
	});
}

function npc_submit(){
	var data = collect_data();
	if (data["npc_enable"] == "1") {
		if (!data["npc_server_addr"] || !data["npc_vkey"]) {
			alert("server_addr 和 vkey 不能为空！");
			return;
		}
	}
	npc_log_poll_tries = 0;
	show_npc_log("Npc 提交中 ...");
	E("npc_log_close_btn").disabled = true;

	var id = parseInt(Math.random() * 100000000);
	$.ajax({
		type: "POST",
		url: "/_api/",
		dataType: "json",
		data: JSON.stringify({
			"id": id,
			"method": "npc_config.sh",
			"params": ["1"],
			"fields": data
		}),
		success: function() {
			get_npc_submit_log();
		},
		error: function() {
			E("npc_log_content").value = "提交失败，请重试！";
			E("npc_log_close_btn").disabled = false;
		}
	});
}
</script>
</head>

<body id="app" skin="<% nvram_get(\"sc_skin\"); %>" onload="init();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
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
						<div class="formfonttitle">Npc 内网穿透 <span id="npc_version_show"></span></div>
						<div style="margin: 10px 0; color: #ffcc00;" id="npc_status">加载中...</div>
						<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
							<tr>
								<th width="25%">启用 Npc</th>
								<td>
									<label><input type="checkbox" id="npc_enable" /> 启用</label>
									<span style="margin-left: 10px;">
										<input class="button_gen" type="button" value="提交" onclick="npc_submit();" />
										<input class="button_gen" type="button" value="查看日志" onclick="view_npc_submit_log();" />
									</span>
								</td>
							</tr>
							<tr>
								<th>运行模式</th>
								<td>
									<select id="npc_mode" class="input_option">
										<option value="conf">配置文件模式（推荐）</option>
										<option value="cmd">无配置文件模式</option>
									</select>
									<span class="hint">无配置文件模式仅需 server_addr/vkey；隧道由服务端web端配置。</span>
								</td>
							</tr>
							<tr>
								<th>服务端地址</th>
								<td>
									<input type="text" class="input_32_table" id="npc_server_addr" style="width: 320px;" placeholder="1.2.3.4:8024 或 domain:port" />
								</td>
							</tr>
							<tr>
								<th>VKey</th>
								<td>
									<input type="text" class="input_32_table" id="npc_vkey" style="width: 320px;" placeholder="客户端密钥/公钥（按使用模式）" />
								</td>
							</tr>
							<tr>
								<th>连接类型</th>
								<td>
									<select id="npc_conn_type" class="input_option">
										<option value="tcp">tcp</option>
										<option value="kcp">kcp</option>
									</select>
								</td>
							</tr>
							<tr>
								<th>日志级别</th>
								<td>
									<select id="npc_log_level" class="input_option">
										<option value="0">0 (Emergency)</option>
										<option value="1">1 (Alert)</option>
										<option value="2">2 (Critical)</option>
										<option value="3">3 (Error)</option>
										<option value="4">4 (Warning)</option>
										<option value="5">5 (Notice)</option>
										<option value="6">6 (Info)</option>
										<option value="7">7 (Debug)</option>
									</select>
									<span class="hint">日志文件：/tmp/upload/npc.log</span>
								</td>
							</tr>
							<tr>
								<th>断线检测超时</th>
								<td>
									<input type="text" class="input_6_table" id="npc_disconnect_timeout" placeholder="60" />
									<span class="hint">单位秒，留空表示使用默认值。</span>
								</td>
							</tr>
							<tr>
								<th>自动重连</th>
								<td><label><input type="checkbox" id="npc_auto_reconnection" /> auto_reconnection=true</label></td>
							</tr>
							<tr>
								<th>加密/压缩</th>
								<td>
									<label style="margin-right: 12px;"><input type="checkbox" id="npc_crypt" /> crypt=true</label>
									<label><input type="checkbox" id="npc_compress" /> compress=true</label>
								</td>
							</tr>
							<tr>
								<th>限制（可选）</th>
								<td>
									max_conn <input type="text" class="input_6_table" id="npc_max_conn" placeholder="10" />
									&nbsp;&nbsp;flow_limit <input type="text" class="input_6_table" id="npc_flow_limit" placeholder="1000" />
									&nbsp;&nbsp;rate_limit <input type="text" class="input_6_table" id="npc_rate_limit" placeholder="10000" />
								</td>
							</tr>
							<tr id="npc_customize_tr">
								<th>自定义配置</th>
								<td>
									<label><input type="checkbox" id="npc_customize_conf" /> 使用自定义 npc.conf 内容（覆盖以上简单配置）</label>
								</td>
							</tr>
							<tr id="npc_config_tr">
								<th>npc.conf</th>
								<td>
									<textarea id="npc_config" rows="18" class="npc_textarea" placeholder="[common]\nserver_addr=1.1.1.1:8024\nconn_type=tcp\nvkey=123\n"></textarea>
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
<div id="footer"></div>

<div class="npc_log_mask"></div>
<div class="npc_log_modal">
	<div class="npc_log_title" id="npc_log_title">Npc 提交日志</div>
	<textarea id="npc_log_content" class="npc_log_area" rows="26" readonly="readonly"></textarea>
	<div class="npc_log_btns">
		<input class="button_gen" type="button" id="npc_log_close_btn" value="关闭" onclick="hide_npc_log();" />
	</div>
</div>
</body>
</html>

