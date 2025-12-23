<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - FakeSIP 伪装</title>
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

	.payload_area {
		width: 100% !important;
		box-sizing: border-box !important;
		height: 78px;
		resize: vertical;
		padding: 6px 8px;
		border-radius: 4px;
		background: rgba(0,0,0,.22);
		color: #fff;
		border: 1px solid rgba(255,255,255,.18);
	}
	#app[skin="ASUSWRT"] .payload_area { background: rgba(0,0,0,.06); color: #000; border-color: #999; }
	#app[skin="ROG"] .payload_area { border-color: rgba(145,7,31,.85); }
	#app[skin="TUF"] .payload_area { border-color: rgba(208,152,44,.85); }
	#app[skin="TS"] .payload_area { border-color: rgba(46,217,195,.85); }

	.fakesip_mask {
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		z-index: 9998;
		display: none;
		background: rgba(0,0,0,0.55);
	}
	.fakesip_popup {
		position: fixed;
		z-index: 9999;
		top: 260px;
		left: calc(50% + 97px);
		transform: translateX(-50%);
		width: 780px;
		background: #000;
		border-radius: 10px;
		box-shadow: 3px 3px 10px #000;
		display: none;
	}
	.fakesip_popup_head{
		padding: 10px 12px;
		font-size: 16px;
		font-weight: 700;
		color: #99FF00;
		text-align: center;
	}
	.fakesip_popup_body{ padding: 0 12px 12px 12px; }
	#log_text { width: 100% !important; box-sizing: border-box !important; background: #000 !important; color: #fff !important; border: 1px solid #111 !important; }
</style>
<script>
var dbus = {};
var logTimer = null;
var logAutoScroll = true;
var logIgnoreScroll = false;
var logTrimming = false;
var statusTimer = null;

function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "fakesip");
	tablink[tablink.length - 1] = new Array("", "Module_fakesip.asp");
}

function reload_Soft_Center(){
	location.href = "/Module_Softcenter.asp";
}

function init() {
	show_menu(menu_hook);
	get_dbus_data();
	$("#log_text").on("scroll", function(){
		if (logIgnoreScroll) return;
		var el = this;
		var remain = el.scrollHeight - (el.scrollTop + el.clientHeight);
		logAutoScroll = (remain < 20);
	});
}

function get_dbus_data(){
	$.ajax({
		type: "GET",
		url: "/_api/fakesip",
		dataType: "json",
		async: true,
		cache: false,
		success: function(data) {
			dbus = (data.result && data.result[0]) ? data.result[0] : {};
			if (dbus["fakesip_version"]) {
				$("#fakesip_version").html("当前版本：" + dbus["fakesip_version"]);
			}
			fill_form();
			check_status();
		}
	});
}

function E(id){ return document.getElementById(id); }

function fill_form(){
	E("fakesip_alliface").checked = (dbus["fakesip_alliface"] == "1");
	E("fakesip_iface").value = (dbus["fakesip_iface"] && dbus["fakesip_iface"] != "null") ? dbus["fakesip_iface"] : "ppp0";

	E("fakesip_sip_uri").value = (dbus["fakesip_sip_uri"] && dbus["fakesip_sip_uri"] != "null") ? dbus["fakesip_sip_uri"] : "";
	E("fakesip_payload_file").value = (dbus["fakesip_payload_file"] && dbus["fakesip_payload_file"] != "null") ? dbus["fakesip_payload_file"] : "";

	E("fakesip_outbound").checked = (dbus["fakesip_outbound"] != "0");
	E("fakesip_inbound").checked = (dbus["fakesip_inbound"] == "1");
	E("fakesip_ipv4").checked = (dbus["fakesip_ipv4"] != "0");
	E("fakesip_ipv6").checked = (dbus["fakesip_ipv6"] == "1");

	E("fakesip_nfqnum").value = (dbus["fakesip_nfqnum"] && dbus["fakesip_nfqnum"] != "null") ? dbus["fakesip_nfqnum"] : "513";
	E("fakesip_fwmark").value = (dbus["fakesip_fwmark"] && dbus["fakesip_fwmark"] != "null") ? dbus["fakesip_fwmark"] : "0x10000";
	E("fakesip_fwmask").value = (dbus["fakesip_fwmask"] && dbus["fakesip_fwmask"] != "null") ? dbus["fakesip_fwmask"] : "";
	E("fakesip_repeat").value = (dbus["fakesip_repeat"] && dbus["fakesip_repeat"] != "null") ? dbus["fakesip_repeat"] : "1";
	E("fakesip_ttl").value = (dbus["fakesip_ttl"] && dbus["fakesip_ttl"] != "null") ? dbus["fakesip_ttl"] : "3";
	E("fakesip_dynamic_pct").value = (dbus["fakesip_dynamic_pct"] && dbus["fakesip_dynamic_pct"] != "null") ? dbus["fakesip_dynamic_pct"] : "";
	E("fakesip_nohopest").checked = (dbus["fakesip_nohopest"] == "1");
	E("fakesip_silent").checked = (dbus["fakesip_silent"] == "1");

	toggle_iface();
}

function toggle_iface(){
	if (E("fakesip_alliface").checked) {
		$("#iface_row").hide();
	} else {
		$("#iface_row").show();
	}
}

function set_buttons(busy){
	E("btn_start").disabled = busy;
	E("btn_stop").disabled = busy;
	E("btn_clear").disabled = busy;
	E("btn_log").disabled = busy;
}

function apply_config(enable){
	var alliface = E("fakesip_alliface").checked ? "1" : "0";
	var iface = $.trim(E("fakesip_iface").value || "");
	var sipUri = $.trim(E("fakesip_sip_uri").value || "");
	var payloadFile = $.trim(E("fakesip_payload_file").value || "");

	if (alliface != "1" && !iface) {
		alert("未指定接口（-i）！");
		return;
	}
	if (!E("fakesip_inbound").checked && !E("fakesip_outbound").checked) {
		E("fakesip_outbound").checked = true;
	}
	if (!E("fakesip_ipv4").checked && !E("fakesip_ipv6").checked) {
		E("fakesip_ipv4").checked = true;
	}
	if ($.trim(E("fakesip_dynamic_pct").value || "") && E("fakesip_nohopest").checked) {
		alert("动态 TTL（-y）不能与禁用跳数估计（-g）同时使用！");
		return;
	}

	var fields = {};
	fields["fakesip_enable"] = enable;
	fields["fakesip_alliface"] = alliface;
	fields["fakesip_iface"] = iface;

	fields["fakesip_sip_uri"] = sipUri;
	fields["fakesip_payload_file"] = payloadFile;

	fields["fakesip_inbound"] = E("fakesip_inbound").checked ? "1" : "0";
	fields["fakesip_outbound"] = E("fakesip_outbound").checked ? "1" : "0";
	fields["fakesip_ipv4"] = E("fakesip_ipv4").checked ? "1" : "0";
	fields["fakesip_ipv6"] = E("fakesip_ipv6").checked ? "1" : "0";

	fields["fakesip_nfqnum"] = $.trim(E("fakesip_nfqnum").value || "513");
	fields["fakesip_fwmark"] = $.trim(E("fakesip_fwmark").value || "0x10000");
	fields["fakesip_fwmask"] = $.trim(E("fakesip_fwmask").value || "");
	fields["fakesip_repeat"] = $.trim(E("fakesip_repeat").value || "1");
	fields["fakesip_ttl"] = $.trim(E("fakesip_ttl").value || "3");
	fields["fakesip_dynamic_pct"] = $.trim(E("fakesip_dynamic_pct").value || "");
	fields["fakesip_nohopest"] = E("fakesip_nohopest").checked ? "1" : "0";
	fields["fakesip_silent"] = E("fakesip_silent").checked ? "1" : "0";

	set_buttons(true);
	var id = parseInt(Math.random() * 100000000);
	var action = (enable == "1") ? 2 : 3;
	var postData = {"id": id, "method": "fakesip_config.sh", "params": [action], "fields": fields};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function() {
			setTimeout("get_dbus_data();", 500);
			setTimeout(function(){ set_buttons(false); }, 1200);
		},
		error: function() {
			set_buttons(false);
		}
	});
}

function start_now(){ apply_config("1"); }
function stop_now(){ apply_config("0"); }

function clear_log(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "fakesip_config.sh", "params": [4], "fields": {}};
	$.ajax({type:"POST", url:"/_api/", data: JSON.stringify(postData), dataType:"json", success:function(){ setTimeout("get_log();", 200);} });
}

function open_log_popup(){
	logAutoScroll = true;
	$("#fakesip_log_mask").fadeIn(100);
	$("#fakesip_log_popup").fadeIn(150);
	get_log(1);
}
function close_log_popup(){
	stop_log_poll();
	$("#fakesip_log_popup").fadeOut(120);
	$("#fakesip_log_mask").fadeOut(120);
}
function show_log(){ open_log_popup(); }

function stop_log_poll(){
	if (logTimer) {
		clearTimeout(logTimer);
		logTimer = null;
	}
}

function get_log(action){
	if (action) stop_log_poll();
	$.ajax({
		url: "/_temp/fakesip.log",
		type: "GET",
		cache: false,
		dataType: "text",
		success: function(response){
			var el = E("log_text");
			var prevTop = el.scrollTop;
			logIgnoreScroll = true;
			el.value = response || "";
			if (logAutoScroll) {
				el.scrollTop = el.scrollHeight;
			} else {
				el.scrollTop = prevTop;
			}
			logIgnoreScroll = false;
			if (!logTrimming) {
				var lines = (el.value ? el.value.split("\n").length : 0);
				if (lines > 500) {
					logTrimming = true;
					var id = parseInt(Math.random() * 100000000);
					var postData = {"id": id, "method": "fakesip_config.sh", "params": [5], "fields": {}};
					$.ajax({
						type: "POST",
						url: "/_api/",
						data: JSON.stringify(postData),
						dataType: "json",
						complete: function(){
							logTrimming = false;
							setTimeout(function(){ get_log(action ? 1 : 0); }, 200);
						}
					});
					return;
				}
			}
			if (action) {
				logTimer = setTimeout(function(){ get_log(1); }, 1200);
			}
		},
		error: function(){
			if (action) {
				logTimer = setTimeout(function(){ get_log(1); }, 1500);
			}
		}
	});
}

function check_status(){
	if (statusTimer) {
		clearTimeout(statusTimer);
		statusTimer = null;
	}
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "fakesip_status.sh", "params":[1], "fields": ""};
	$.ajax({
		type: "POST",
		url: "/_api/",
		async: true,
		data: JSON.stringify(postData),
		success: function (response) {
			try {
				E("fakesip_status").innerHTML = response.result || "";
			} catch(e) {
				E("fakesip_status").innerHTML = "";
			}
			statusTimer = setTimeout(check_status, 5000);
		},
		error: function(){
			E("fakesip_status").innerHTML = "获取运行状态失败";
			statusTimer = setTimeout(check_status, 8000);
		}
	});
}
</script>
</head>
<body id="app" skin="<% nvram_get("sc_skin"); %>" onload="init();">
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
							<table width="760px" border="0" cellpadding="4" cellspacing="0" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div class="formfonttitle">FakeSIP 伪装</div>
										<div style="float:right; width:15px; height:25px; margin-top:-20px">
											<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
										</div>
										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
										<div class="formfontdesc">
											<div id="fakesip_version"></div>
											<div id="fakesip_status" style="margin-top:6px;color:#99FF00;"></div>
										</div>
										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>

										<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
											<tr>
												<th width="25%">接口</th>
												<td>
													<label><input type="checkbox" id="fakesip_alliface" onclick="toggle_iface();"> 所有接口（-a）</label>
												</td>
											</tr>
											<tr id="iface_row">
												<th>接口名（-i）</th>
												<td><input type="text" class="input_25_table" id="fakesip_iface" style="width: 240px;" placeholder="ppp0 或 eth0（多个可用逗号分隔）"></td>
											</tr>

											<tr>
												<th>Payload：SIP URI（-u）</th>
												<td>
													<textarea id="fakesip_sip_uri" class="payload_area" placeholder="每行一个 SIP URI，例如：sip:user@example.com（留空则随机生成）"></textarea>
												</td>
											</tr>
											<tr>
												<th>Payload：二进制文件（-b）</th>
												<td>
													<textarea id="fakesip_payload_file" class="payload_area" placeholder="每行一个文件路径，例如：/koolshare/fakesip/payload.bin（可留空）"></textarea>
												</td>
											</tr>

											<tr>
												<th>处理方向</th>
												<td>
													<label><input type="checkbox" id="fakesip_outbound"> 出站（-1）</label>
													&nbsp;&nbsp;
													<label><input type="checkbox" id="fakesip_inbound"> 入站（-0）</label>
												</td>
											</tr>
											<tr>
												<th>IP 版本</th>
												<td>
													<label><input type="checkbox" id="fakesip_ipv4"> IPv4（-4）</label>
													&nbsp;&nbsp;
													<label><input type="checkbox" id="fakesip_ipv6"> IPv6（-6）</label>
												</td>
											</tr>

											<tr>
												<th>NFQUEUE 编号（-n）</th>
												<td><input type="text" class="input_25_table" id="fakesip_nfqnum" style="width: 140px;" placeholder="513"></td>
											</tr>
											<tr>
												<th>FWMark（-m / -x）</th>
												<td>
													<input type="text" class="input_25_table" id="fakesip_fwmark" style="width: 140px;" placeholder="0x10000">
													&nbsp;Mask：
													<input type="text" class="input_25_table" id="fakesip_fwmask" style="width: 140px;" placeholder="可留空">
												</td>
											</tr>
											<tr>
												<th>发包倍率（-r）</th>
												<td><input type="text" class="input_25_table" id="fakesip_repeat" style="width: 140px;" placeholder="1"></td>
											</tr>
											<tr>
												<th>TTL（-t）</th>
												<td><input type="text" class="input_25_table" id="fakesip_ttl" style="width: 140px;" placeholder="3"></td>
											</tr>
											<tr>
												<th>动态 TTL（-y）</th>
												<td><input type="text" class="input_25_table" id="fakesip_dynamic_pct" style="width: 140px;" placeholder="可留空（0-99）"></td>
											</tr>
											<tr>
												<th>其它</th>
												<td>
													<label><input type="checkbox" id="fakesip_nohopest"> 禁用跳数估计（-g）</label>
													&nbsp;&nbsp;
													<label><input type="checkbox" id="fakesip_silent"> 静默（-s）</label>
												</td>
											</tr>
										</table>

										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
										<div style="text-align:center;">
											<input class="button_gen" type="button" id="btn_start" onclick="start_now();" value="启动" />
											&nbsp;&nbsp;
											<input class="button_gen" type="button" id="btn_stop" onclick="stop_now();" value="停止" />
											&nbsp;&nbsp;
											<input class="button_gen" type="button" id="btn_log" onclick="show_log();" value="查看日志" />
										</div>
										<div>&nbsp;</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

	<div id="fakesip_log_mask" class="fakesip_mask" onclick="close_log_popup();"></div>
	<div id="fakesip_log_popup" class="fakesip_popup">
		<div class="fakesip_popup_head">FakeSIP 日志</div>
		<div class="fakesip_popup_body">
			<textarea id="log_text" rows="26" readonly="readonly"></textarea>
			<div style="margin-top:10px;text-align:center;background:#000;">
				<input class="button_gen" type="button" id="btn_clear" onclick="clear_log();" value="清空日志" />
				&nbsp;&nbsp;
				<input class="button_gen" type="button" onclick="close_log_popup();" value="关闭" />
			</div>
		</div>
	</div>
	<div id="footer"></div>
</body>
</html>
