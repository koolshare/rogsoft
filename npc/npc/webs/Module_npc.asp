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
<style type="text/css">
input:focus { outline: none; }
.npc_btn {
	border: 1px solid #222;
	background: linear-gradient(to bottom, #003333 0%, #000000 100%);
	font-size: 10pt;
	color: #fff;
	padding: 5px 10px;
	border-radius: 6px;
	display: inline-block;
	cursor: pointer;
	text-decoration: none;
}
.npc_btn:hover { opacity: .9; }

#app[skin="ROG"] .npc_btn { background: linear-gradient(to bottom, #91071f 0%, #700618 100%); border-color: #91071f; }
#app[skin="ROG"] .npc_btn:hover { background: linear-gradient(to bottom, #cf0a2c 0%, #91071f 100%); }
#app[skin="TUF"] .npc_btn { background: linear-gradient(to bottom, #D0982C 0%, #7A5A12 100%); border-color: #D0982C; }
#app[skin="TUF"] .npc_btn:hover { background: linear-gradient(to bottom, #f1b838 0%, #D0982C 100%); }
#app[skin="TS"] .npc_btn { background: linear-gradient(to bottom, #2ed9c3 0%, #158b7c 100%); border-color: #2ed9c3; }
#app[skin="TS"] .npc_btn:hover { background: linear-gradient(to bottom, #66ffeb 0%, #2ed9c3 100%); }

#npc_config {
	width: 99%;
	font-family: 'Lucida Console';
	font-size: 12px;
	color: #FFFFFF;
	text-transform: none;
	margin-top: 5px;
	overflow: auto;
	resize: vertical;
	white-space: pre-wrap;
	word-break: break-word;
	background: transparent;
	border: 1px solid rgba(255,255,255,.18);
}
#app[skin="ASUSWRT"] #npc_config { background: #475A5F; border-color: #222; }
#app[skin="ROG"] #npc_config { border-color: #91071f; }
#app[skin="TUF"] #npc_config { border-color: #D0982C; }
#app[skin="TS"] #npc_config { border-color: #2ed9c3; }
</style>

<script type="text/javascript">
var db_npc = {};
var npc_log_poll_tries = 0;
var params_input = ["npc_server_addr", "npc_vkey", "npc_disconnect_timeout", "npc_max_conn", "npc_flow_limit", "npc_rate_limit"];
var params_select = ["npc_mode", "npc_conn_type", "npc_log_level"];
var params_check = ["npc_enable", "npc_customize_conf", "npc_auto_reconnection", "npc_crypt", "npc_compress"];
var params_base64 = ["npc_config"];

function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "npc");
	tablink[tablink.length - 1] = new Array("", "Module_npc.asp");
}

function initial() {
	show_menu(menu_hook);
	get_dbus_data();
	get_status();

	$("#npc_mode").change(function() { toggle_mode(); });
	$("#npc_customize_conf").change(function() { toggle_mode(); });
}

function get_status() {
	var postData = {
		"id": parseInt(Math.random() * 100000000),
		"method": "npc_status.sh",
		"params": [],
		"fields": ""
	};
	$.ajax({
		type: "POST",
		cache: false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			E("status").innerHTML = response.result;
			setTimeout("get_status();", 10000);
		},
		error: function() {
			E("status").innerHTML = "状态获取失败";
			setTimeout("get_status();", 5000);
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

function showNPCLoadingBar() {
	E("npc_LoadingBar").style.visibility = "visible";
	E("npc_LoadingBar").style.display = "block";
}
function hideNPCLoadingBar() {
	E("npc_LoadingBar").style.visibility = "hidden";
	E("npc_LoadingBar").style.display = "none";
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
				E("npc_ok_button").style.visibility = "visible";
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
			E("npc_ok_button").style.visibility = "visible";
		}
	});
}

function npc_copy_submit_log(){
	try {
		var ta = E("npc_log_content");
		ta.focus();
		ta.select();
		document.execCommand("copy");
	} catch(e){}
}

function npc_download_submit_log(){
	try {
		var content = (E("npc_log_content").value || "");
		var blob = new Blob([content], {type: "text/plain;charset=utf-8"});
		var url = URL.createObjectURL(blob);
		var a = document.createElement("a");
		a.href = url;
		a.download = "npc_submit_log.txt";
		document.body.appendChild(a);
		a.click();
		document.body.removeChild(a);
		setTimeout(function(){ try{ URL.revokeObjectURL(url); }catch(e){} }, 1000);
	} catch(e){}
}

function view_npc_submit_log(){
	E("npc_ok_button").style.visibility = "visible";
	E("npc_ok_button1").value = "关闭";
	showNPCLoadingBar();
	E("npc_loading_block_title").innerHTML = "&nbsp;&nbsp;Npc 上次提交日志";
	$.ajax({
		url: '/_temp/npc_submit_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("npc_log_content");
			retArea.value = npc_log_clean(response);
			retArea.scrollTop = retArea.scrollHeight;
			E("npc_ok_button").style.visibility = "visible";
		},
		error: function() {
			E("npc_log_content").value = "暂无上次提交日志，请先点击提交。";
			E("npc_ok_button").style.visibility = "visible";
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
	E("npc_ok_button").style.visibility = "hidden";
	E("npc_ok_button1").value = "确定";
	showNPCLoadingBar();
	E("npc_loading_block_title").innerHTML = "&nbsp;&nbsp;Npc 提交中 ...";
	E("npc_log_content").value = "";

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
			E("npc_ok_button").style.visibility = "visible";
		}
	});
}
</script>
</head>

<body id="app" skin="<% nvram_get(\"sc_skin\"); %>" onload="initial();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>

<div id="npc_LoadingBar" class="popup_bar_bg_ks" style="position:fixed;margin:auto;top:0;left:0;width:100%;height:100%;z-index:9999;display:none;visibility:hidden;overflow:hidden;background:rgba(68,79,83,0.94) none repeat scroll 0 0;opacity:.94;" >
	<table cellpadding="5" cellspacing="0" id="npc_loadingBarBlock" class="loadingBarBlock" style="width:740px;" align="center">
		<tr>
			<td height="100">
				<div id="npc_loading_block_title" style="margin:10px auto;width:100%; font-size:12pt;text-align:center;"></div>
				<div style="margin-left:15px;margin-top:5px"><i>此处显示 npc 上次/本次提交日志</i></div>
				<div style="margin-left:15px;margin-right:15px;margin-top:10px;outline: 1px solid #3c3c3c;overflow:hidden">
					<textarea cols="50" rows="25" wrap="off" readonly="readonly" id="npc_log_content" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Lucida Console'; font-size:11px;background:transparent;color:#FFFFFF;outline: none;padding-left:5px;padding-right:22px;overflow-x:hidden;white-space:break-spaces;"></textarea>
				</div>
				<div id="npc_ok_button" class="apply_gen" style="background:#000;visibility:hidden;">
					<input class="button_gen" type="button" onclick="npc_copy_submit_log();" value="复制日志">
					<input style="margin-left:10px" class="button_gen" type="button" onclick="npc_download_submit_log();" value="下载日志">
					<input style="margin-left:10px" id="npc_ok_button1" class="button_gen" type="button" onclick="hideNPCLoadingBar()" value="确定">
				</div>
			</td>
		</tr>
	</table>
</div>

<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="POST" name="form" action="/applydb.cgi?p=npc" target="hidden_frame">
<input type="hidden" name="current_page" value="Module_npc.asp"/>
<input type="hidden" name="next_page" value="Module_npc.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="5"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get(\"preferred_lang\"); %>"/>
<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="config-npc.sh"/>
<input type="hidden" name="firmver" value="<% nvram_get(\"firmver\"); %>"/>

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
									<div style="float:left;" class="formfonttitle">软件中心 - Npc 内网穿透</div>
									<div style="float:right; width:15px; height:25px;margin-top:10px">
										<img id="return_btn" onclick="reload_Soft_Center();" align="right"
											style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;"
											title="返回软件中心" src="/images/backprev.png"
											onMouseOver="this.src='/images/backprevclick.png'"
											onMouseOut="this.src='/images/backprev.png'"></img>
									</div>
									<div style="margin:30px 0 10px 5px;" class="splitLine"></div>

									<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
										<tr id="switch_tr">
											<th width="20%">开启 Npc</th>
											<td colspan="2">
												<div class="switch_field" style="display:table-cell;float:left;">
													<label for="npc_enable">
														<input id="npc_enable" class="switch" type="checkbox" style="display:none;">
														<div class="switch_container">
															<div class="switch_bar"></div>
															<div class="switch_circle transition_style"><div></div></div>
														</div>
													</label>
												</div>
												<div id="npc_version_show" style="padding-top:5px;margin-left:30px;float:left;"></div>
												<div style="padding-top:3px;margin-right:10px;float:right;">
													<a class="npc_btn" href="https://raw.githubusercontent.com/koolshare/rogsoft/master/npc/Changelog.txt" target="_blank">更新日志</a>
													<a class="npc_btn" href="javascript:void(0);" onclick="view_npc_submit_log();" style="margin-left:10px;">查看日志</a>
													<a class="npc_btn" href="javascript:void(0);" onclick="npc_submit();" style="margin-left:10px;">提交</a>
												</div>
											</td>
										</tr>

										<tr id="npc_status">
											<th width="20%">运行状态</th>
											<td><span id="status">获取中...</span></td>
										</tr>

										<tr>
											<th width="20%">运行模式</th>
											<td>
												<select id="npc_mode" class="input_option">
													<option value="conf">配置文件模式（推荐）</option>
													<option value="cmd">无配置文件模式（由服务端web配置隧道）</option>
												</select>
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
												<span class="hint" style="margin-left:10px;">日志文件：/tmp/upload/npc.log</span>
											</td>
										</tr>
										<tr>
											<th>断线检测超时</th>
											<td>
												<input type="text" class="input_6_table" id="npc_disconnect_timeout" placeholder="60" />
												<span class="hint" style="margin-left:10px;">单位秒，留空表示使用默认值</span>
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
												<label style="margin-right:10px;"><input type="checkbox" id="npc_customize_conf" /> 使用自定义 npc.conf（覆盖以上简单配置）</label>
											</td>
										</tr>
										<tr id="npc_config_tr">
											<th>npc.conf</th>
											<td>
												<textarea id="npc_config" rows="18" placeholder="[common]\nserver_addr=1.1.1.1:8024\nconn_type=tcp\nvkey=123\n"></textarea>
											</td>
										</tr>
									</table>
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
</form>
</body>
</html>
