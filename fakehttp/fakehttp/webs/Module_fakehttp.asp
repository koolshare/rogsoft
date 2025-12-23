<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - FakeHTTP 伪装</title>
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
	#log_text { width: 100% !important; box-sizing: border-box !important; }
	.host_area { width: 100% !important; box-sizing: border-box !important; height: 78px; resize: vertical; }
	.fakehttp_mask {
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		z-index: 9998;
		display: none;
		background: rgba(0,0,0,0.55);
	}
	.fakehttp_popup {
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
	.fakehttp_popup_head{
		padding: 10px 12px;
		font-size: 16px;
		font-weight: 700;
		color: #99FF00;
		text-align: center;
	}
	.fakehttp_popup_body{ padding: 0 12px 12px 12px; }
	#log_text { background: #000 !important; color: #fff !important; border: 1px solid #111 !important; }
</style>
<script>
var dbus = {};
var logTimer = null;
var logAutoScroll = true;
var logIgnoreScroll = false;
var logTrimming = false;
var statusTimer = null;

function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "fakehttp");
	tablink[tablink.length - 1] = new Array("", "Module_fakehttp.asp");
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
		url: "/_api/fakehttp",
		dataType: "json",
		async: true,
		cache: false,
		success: function(data) {
			dbus = (data.result && data.result[0]) ? data.result[0] : {};
			if (dbus["fakehttp_version"]) {
				$("#fakehttp_version").html("当前版本：" + dbus["fakehttp_version"]);
			}
			fill_form();
			check_status();
		}
	});
}

function E(id){ return document.getElementById(id); }

function fill_form(){
	E("fakehttp_alliface").checked = (dbus["fakehttp_alliface"] == "1");
	E("fakehttp_iface").value = (dbus["fakehttp_iface"] && dbus["fakehttp_iface"] != "null") ? dbus["fakehttp_iface"] : "ppp0";
	E("fakehttp_http_host").value = (dbus["fakehttp_http_host"] && dbus["fakehttp_http_host"] != "null") ? dbus["fakehttp_http_host"] : "www.example.com";
	E("fakehttp_https_host").value = (dbus["fakehttp_https_host"] && dbus["fakehttp_https_host"] != "null") ? dbus["fakehttp_https_host"] : "";

	E("fakehttp_outbound").checked = (dbus["fakehttp_outbound"] != "0");
	E("fakehttp_inbound").checked = (dbus["fakehttp_inbound"] == "1");
	E("fakehttp_ipv4").checked = (dbus["fakehttp_ipv4"] != "0");
	E("fakehttp_ipv6").checked = (dbus["fakehttp_ipv6"] == "1");

	E("fakehttp_nfqnum").value = (dbus["fakehttp_nfqnum"] && dbus["fakehttp_nfqnum"] != "null") ? dbus["fakehttp_nfqnum"] : "512";
	E("fakehttp_fwmark").value = (dbus["fakehttp_fwmark"] && dbus["fakehttp_fwmark"] != "null") ? dbus["fakehttp_fwmark"] : "0x8000";
	E("fakehttp_fwmask").value = (dbus["fakehttp_fwmask"] && dbus["fakehttp_fwmask"] != "null") ? dbus["fakehttp_fwmask"] : "";
	E("fakehttp_repeat").value = (dbus["fakehttp_repeat"] && dbus["fakehttp_repeat"] != "null") ? dbus["fakehttp_repeat"] : "1";
	E("fakehttp_ttl").value = (dbus["fakehttp_ttl"] && dbus["fakehttp_ttl"] != "null") ? dbus["fakehttp_ttl"] : "3";
	E("fakehttp_dynamic_pct").value = (dbus["fakehttp_dynamic_pct"] && dbus["fakehttp_dynamic_pct"] != "null") ? dbus["fakehttp_dynamic_pct"] : "";
	E("fakehttp_nohopest").checked = (dbus["fakehttp_nohopest"] == "1");
	E("fakehttp_silent").checked = (dbus["fakehttp_silent"] == "1");

	toggle_iface();
}

function toggle_iface(){
	if (E("fakehttp_alliface").checked) {
		$("#iface_row").hide();
	} else {
		$("#iface_row").show();
	}
}

function set_buttons(running){
	E("btn_start").disabled = running;
	E("btn_stop").disabled = running;
	E("btn_clear").disabled = running;
	E("btn_log").disabled = running;
}

function apply_config(enable){
	var alliface = E("fakehttp_alliface").checked ? "1" : "0";
	var iface = $.trim(E("fakehttp_iface").value || "");
	var httpHost = $.trim(E("fakehttp_http_host").value || "");
	var httpsHost = $.trim(E("fakehttp_https_host").value || "");

	if (!httpHost) {
		alert("HTTP Host 不能为空（-h）！");
		return;
	}
	if (alliface != "1" && !iface) {
		alert("未指定接口（-i）！");
		return;
	}
	if (!E("fakehttp_inbound").checked && !E("fakehttp_outbound").checked) {
		E("fakehttp_outbound").checked = true;
	}
	if (!E("fakehttp_ipv4").checked && !E("fakehttp_ipv6").checked) {
		E("fakehttp_ipv4").checked = true;
	}
	if ($.trim(E("fakehttp_dynamic_pct").value || "") && E("fakehttp_nohopest").checked) {
		alert("动态 TTL（-y）不能与禁用跳数估计（-g）同时使用！");
		return;
	}

	var fields = {};
	fields["fakehttp_enable"] = enable;
	fields["fakehttp_alliface"] = alliface;
	fields["fakehttp_iface"] = iface;
	fields["fakehttp_http_host"] = httpHost;
	fields["fakehttp_https_host"] = httpsHost;

	fields["fakehttp_inbound"] = E("fakehttp_inbound").checked ? "1" : "0";
	fields["fakehttp_outbound"] = E("fakehttp_outbound").checked ? "1" : "0";
	fields["fakehttp_ipv4"] = E("fakehttp_ipv4").checked ? "1" : "0";
	fields["fakehttp_ipv6"] = E("fakehttp_ipv6").checked ? "1" : "0";

	fields["fakehttp_nfqnum"] = $.trim(E("fakehttp_nfqnum").value || "512");
	fields["fakehttp_fwmark"] = $.trim(E("fakehttp_fwmark").value || "0x8000");
	fields["fakehttp_fwmask"] = $.trim(E("fakehttp_fwmask").value || "");
	fields["fakehttp_repeat"] = $.trim(E("fakehttp_repeat").value || "2");
	fields["fakehttp_ttl"] = $.trim(E("fakehttp_ttl").value || "3");
	fields["fakehttp_dynamic_pct"] = $.trim(E("fakehttp_dynamic_pct").value || "");
	fields["fakehttp_nohopest"] = E("fakehttp_nohopest").checked ? "1" : "0";
	fields["fakehttp_silent"] = E("fakehttp_silent").checked ? "1" : "0";

	set_buttons(true);
	var id = parseInt(Math.random() * 100000000);
	var action = (enable == "1") ? 2 : 3;
	var postData = {"id": id, "method": "fakehttp_config.sh", "params": [action], "fields": fields};
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

function start_now(){
	apply_config("1");
}

function stop_now(){
	apply_config("0");
}

function clear_log(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "fakehttp_config.sh", "params": [4], "fields": {}};
	$.ajax({type:"POST", url:"/_api/", data: JSON.stringify(postData), dataType:"json", success:function(){ setTimeout("get_log();", 200);} });
}

function open_log_popup(){
	logAutoScroll = true;
	$("#fakehttp_log_mask").fadeIn(100);
	$("#fakehttp_log_popup").fadeIn(150);
	get_log(1);
}

function close_log_popup(){
	stop_log_poll();
	$("#fakehttp_log_popup").fadeOut(120);
	$("#fakehttp_log_mask").fadeOut(120);
}

function show_log(){
	open_log_popup();
}

function stop_log_poll(){
	if (logTimer) {
		clearTimeout(logTimer);
		logTimer = null;
	}
}

function get_log(action){
	if (action) stop_log_poll();
	$.ajax({
		url: "/_temp/fakehttp.log",
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
			// auto trim log file when too large (>500 lines): keep last 10 lines
			if (!logTrimming) {
				var lines = (el.value ? el.value.split("\n").length : 0);
				if (lines > 500) {
					logTrimming = true;
					var id = parseInt(Math.random() * 100000000);
					var postData = {"id": id, "method": "fakehttp_config.sh", "params": [5], "fields": {}};
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
	var postData = {"id": id, "method": "fakehttp_status.sh", "params":[1], "fields": ""};
	$.ajax({
		type: "POST",
		url: "/_api/",
		async: true,
		data: JSON.stringify(postData),
		success: function (response) {
			try {
				E("fakehttp_status").innerHTML = response.result || "";
			} catch(e) {
				E("fakehttp_status").innerHTML = "";
			}
			statusTimer = setTimeout(check_status, 5000);
		},
		error: function(){
			E("fakehttp_status").innerHTML = "获取运行状态失败";
			statusTimer = setTimeout(check_status, 8000);
		}
	});
}
</script>
</head>
<body onload="init();">
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
										<div class="formfonttitle">网络工具 - FakeHTTP 伪装 <lable id="fakehttp_version"></lable></div>
										<div style="float:right; width:15px; height:25px;margin-top:-20px">
											<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
										</div>
										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>

										<div class="SimpleNote">
											<div>1. FakeHTTP 通过 NFQUEUE 将 TCP 流量伪装为 HTTP/HTTPS 协议，用于网络流量混淆。</div>
											<div>2. 已针对华硕/梅林系统定制编译，移除了 iptables 的 <span style="color:#00c6ff;font-weight:600;">-w</span> 依赖，FakeHTTP 将自动创建所需的防火墙/NFQUEUE 规则。</div>
										</div>

										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>

										<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
											<tr>
												<th>运行状态</th>
												<td><span id="fakehttp_status">加载中...</span></td>
											</tr>
											<tr>
												<th>HTTP Host（必填）</th>
												<td><textarea id="fakehttp_http_host" class="input_ss_table host_area" placeholder="每行一个 host，等价于多次 -h 参数，例如：
												www.example.com
												www.google.com" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea></td>
											</tr>
											<tr>
												<th>HTTPS Host（可选）</th>
												<td><textarea id="fakehttp_https_host" class="input_ss_table host_area" placeholder="每行一个 host，等价于多次 -e 参数（可留空）" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea></td>
											</tr>
											<tr>
												<th>全接口</th>
												<td><label><input type="checkbox" id="fakehttp_alliface" onclick="toggle_iface()" style="vertical-align:middle;"> 作用于所有接口（忽略 -i）</label></td>
											</tr>
											<tr id="iface_row">
												<th>接口（-i）</th>
												<td><input id="fakehttp_iface" class="input_ss_table" style="width:360px;" value="" placeholder="例如：ppp0（可用逗号/空格分隔多个接口）" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" /></td>
											</tr>
											<tr>
												<th>方向</th>
												<td>
													<label><input type="checkbox" id="fakehttp_outbound" style="vertical-align:middle;"> 出站（-1）</label>
													<label style="margin-left:18px;"><input type="checkbox" id="fakehttp_inbound" style="vertical-align:middle;"> 入站（-0）</label>
												</td>
											</tr>
											<tr>
												<th>IP族</th>
												<td>
													<label><input type="checkbox" id="fakehttp_ipv4" style="vertical-align:middle;"> IPv4（-4）</label>
													<label style="margin-left:18px;"><input type="checkbox" id="fakehttp_ipv6" style="vertical-align:middle;"> IPv6（-6）</label>
												</td>
											</tr>
											<tr>
												<th>NFQUEUE</th>
												<td>
													<input id="fakehttp_nfqnum" class="input_ss_table" style="width:120px;" value="" placeholder="512" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
													<span style="margin-left:10px;" class="hint-color">对应 -n</span>
												</td>
											</tr>
											<tr>
												<th>fwmark/mask</th>
												<td>
													<input id="fakehttp_fwmark" class="input_ss_table" style="width:120px;" value="" placeholder="0x8000" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
													<input id="fakehttp_fwmask" class="input_ss_table" style="width:120px; margin-left:10px;" value="" placeholder="留空=同 fwmark" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
													<span style="margin-left:10px;" class="hint-color">对应 -m/-x</span>
												</td>
											</tr>
											<tr>
												<th>发包倍率</th>
												<td>
													<input id="fakehttp_repeat" class="input_ss_table" style="width:120px;" value="" placeholder="1" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
													<span style="margin-left:10px;" class="hint-color">对应 -r（1~10）</span>
												</td>
											</tr>
											<tr>
												<th>TTL</th>
												<td>
													<input id="fakehttp_ttl" class="input_ss_table" style="width:120px;" value="" placeholder="3" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
													<span style="margin-left:10px;" class="hint-color">对应 -t</span>
												</td>
											</tr>
											<tr>
												<th>动态 TTL（可选）</th>
												<td>
													<input id="fakehttp_dynamic_pct" class="input_ss_table" style="width:120px;" value="" placeholder="例如：80" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
													<label style="margin-left:18px;"><input type="checkbox" id="fakehttp_nohopest" style="vertical-align:middle;"> 禁用跳数估计（-g）</label>
													<label style="margin-left:18px;"><input type="checkbox" id="fakehttp_silent" style="vertical-align:middle;"> 静默（-s）</label>
													<div class="hint-color" style="margin-top:6px;">动态 TTL 对应 -y（0~99），与 -g 不可同时使用。</div>
												</td>
											</tr>
										</table>

										<div class="apply_gen">
											<input class="button_gen" id="btn_start" type="button" value="启动" onclick="start_now()" />
											<input class="button_gen" id="btn_stop" style="margin-left:10px;" type="button" value="停止" onclick="stop_now()" />
											<input class="button_gen" id="btn_log" style="margin-left:10px;" type="button" value="查看日志" onclick="show_log()" />
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
	<div id="fakehttp_log_mask" class="fakehttp_mask"></div>
	<div id="fakehttp_log_popup" class="fakehttp_popup">
		<div class="fakehttp_popup_head">运行日志</div>
		<div class="fakehttp_popup_body">
			<div class="soft_setting_log">
				<textarea cols="63" rows="18" wrap="on" readonly="readonly" id="log_text" class="soft_setting_log1" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
			</div>
			<div class="apply_gen" style="background:#000;">
				<input class="button_gen" id="btn_clear" type="button" value="清空日志" onclick="clear_log()" />
				<input class="button_gen" style="margin-left:10px;" type="button" value="关闭" onclick="close_log_popup()" />
			</div>
		</div>
	</div>
	<div id="footer"></div>
</body>
</html>
