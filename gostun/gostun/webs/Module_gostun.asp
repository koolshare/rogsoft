<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - Gostun NAT检测</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script language="JavaScript" type="text/javascript" src="/js/jquery.js"></script>
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/res/softcenter.js"></script>
<style>
	input:focus { outline: none; }
	.ks_row { margin: 8px 0 12px 0; }
	.ks_label { display:inline-block; width: 150px; }
	select.ks_select {
		height: 28px;
		min-width: 360px;
		border-radius: 4px;
		border: 1px solid #2f3a3e;
		background: #475A5F;
		background: transparent; /* W3C rogcss */
		color: #fff;
	}
	.ks_btn {
		border: 1px solid #222;
		font-size:10pt;
		color: #fff;
		padding: 5px 12px;
		border-radius: 5px;
		background: linear-gradient(to bottom, #003333  0%, #000000 100%);
		background: linear-gradient(to bottom, #91071f  0%, #700618 100%); /* W3C rogcss */
	}
	.ks_btn:hover {
		background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%);
		background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%); /* W3C rogcss */
	}
	.button_gen:disabled, .ks_btn:disabled {
		opacity: 0.35;
		cursor: not-allowed;
	}
	.soft_setting_log1 {
	    width: 97%;
	    padding-top: 4px;
	    padding-bottom: 4px;
	    padding-left: 4px;
	    padding-right: 37px;
	    font-family: 'Lucida Console';
	    font-size: 11px;
	    line-height: 1.5;
	    color: #FFFFFF;
	    outline: none;
	    overflow-x: scroll;
	    margin-top: 1px;
	    border: 0px solid #222;
	    background: #475A5F;
	    white-space: nowrap;
	}
</style>
<script>
var dbus = {};
String.prototype.myReplace = function(f, e){
	var reg = new RegExp(f, "g");
	return this.replace(reg, e);
}
function init() {
	show_menu(menu_hook);
	get_dbus_data();
	load_ao_stun();
	get_log();
	$("#gostun_server").change(function(){ toggle_custom(); });
}
function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "gostun");
	tablink[tablink.length - 1] = new Array("", "Module_gostun.asp");
}
function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/gostun",
		dataType: "json",
		async: true,
		cache: false,
		success: function(data) {
			dbus = data.result[0] || {};
			if (!dbus["gostun_server"]) {
				dbus["gostun_server"] = "stun.miwifi.com:3478";
			}
			if (dbus["gostun_server"]) {
				$("#gostun_server").val(dbus["gostun_server"]);
			}
			if (dbus["gostun_custom"]) {
				$("#gostun_custom").val(dbus["gostun_custom"]);
			}
			toggle_custom();
			if (dbus["gostun_running"] == "1") {
				set_buttons(true);
				get_log(1);
			} else {
				set_buttons(false);
			}
			if (dbus["gostun_version"]) {
				$("#gostun_version").html("当前版本：" + dbus["gostun_version"]);
			}
		}
	});
}
function set_buttons(disabled) {
	E("gostun_apply").disabled = disabled;
	E("gostun_clear").disabled = disabled;
}
function get_log(action){
	$.ajax({
		url: '/_temp/gostun_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content_text");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.myReplace("XU6J03M6", " ");
				retArea.scrollTop = retArea.scrollHeight;
				set_buttons(false);
				return false;
			}
			if(action){
				setTimeout("get_log(1);", 350);
			}
			retArea.value = response.myReplace("XU6J03M6", " ");
			retArea.scrollTop = retArea.scrollHeight;
		},
		error: function() {
			if(action){
				setTimeout("get_log(1);", 350);
			}
		}
	});
}
function gostun_run(){
	set_buttons(true);
	var dbus_new = {};
	dbus_new["gostun_server"] = $("#gostun_server").val();
	dbus_new["gostun_custom"] = $("#gostun_custom").val();
	if (dbus_new["gostun_server"] == "custom") {
		var s = $.trim(dbus_new["gostun_custom"] || "");
		if (!s) {
			alert("请输入自定义 STUN 服务器地址（格式：host:port）！");
			set_buttons(false);
			return;
		}
		if (s.indexOf("]") > -1) {
			if (!/\]:\d+$/.test(s)) {
				alert("自定义 STUN 服务器未指定端口，请使用 [IPv6]:port 或 host:port 格式！");
				set_buttons(false);
				return;
			}
		} else {
			if (!/:\d+$/.test(s)) {
				alert("自定义 STUN 服务器未指定端口，请使用 host:port 格式（例如：stun.example.com:3478）！");
				set_buttons(false);
				return;
			}
		}
	}
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "gostun_config.sh", "params": [1], "fields": dbus_new };
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function() {
			get_log(1);
		},
		error: function() {
			E("gostun_apply").disabled = false;
		}
	});
}
function toggle_custom(){
	var v = $("#gostun_server").val();
	if (v == "custom") {
		$("#custom_row").show();
	} else {
		$("#custom_row").hide();
	}
}
function load_ao_stun(){
	$.ajax({
		url: '/res/gostun_stun_servers.json.js',
		type: 'GET',
		cache: false,
		dataType: 'script',
		success: function(){
			var cur = $("#gostun_server").val();
			var list = window.gostun_stun_servers || [];
			var uniq = {};
			var hosts = [];
			for (var i = 0; i < list.length; i++) {
				var s = $.trim(list[i]);
				if (!s) continue;
				if (s.indexOf(':') < 1) continue;
				if (!uniq[s]) {
					uniq[s] = 1;
					hosts.push(s);
				}
			}
			hosts.sort();
			var group = $("#ao_stun_group");
			group.empty();
			for (var j = 0; j < hosts.length; j++) {
				var v = hosts[j].replace(/'/g, "&#39;");
				group.append("<option value='" + v + "'>" + v + "</option>");
			}
			$("#gostun_server").val(cur);
		},
		error: function(){
			var group = $("#ao_stun_group");
			group.empty();
			group.append("<option value='auto'>（列表加载失败，使用其它选项）</option>");
		}
	});
}
function gostun_clear(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "gostun_config.sh", "params": [2], "fields": {} };
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function() {
			setTimeout("get_log();", 200);
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
											<div class="formfonttitle">网络工具 - Gostun NAT检测 <lable id="gostun_version"></lable></div>
											<div style="float:right; width:15px; height:25px;margin-top:-20px">
												<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
											</div>
											<div style="margin:10px 0 10px 5px;" class="splitLine"></div>

											<div class="ks_row">
												<span class="ks_label">STUN 服务器：</span>
												<select id="gostun_server" class="ks_select">
													<option value="auto">自动（默认 stun.voipgate.com:3478）</option>
													<optgroup label="国内（可能受网络影响）">
														<option value="stun.qq.com:3478">stun.qq.com:3478</option>
														<option value="stun.miwifi.com:3478" selected="selected">stun.miwifi.com:3478</option>
													</optgroup>
													<optgroup label="国外/通用（可能受GFW/代理软件的影响）">
														<option value="stun.l.google.com:19302">stun.l.google.com:19302</option>
														<option value="stun1.l.google.com:19302">stun1.l.google.com:19302</option>
														<option value="stun2.l.google.com:19302">stun2.l.google.com:19302</option>
														<option value="global.stun.twilio.com:3478">global.stun.twilio.com:3478</option>
														<option value="stun.stunprotocol.org:3478">stun.stunprotocol.org:3478</option>
														<option value="stun.sipgate.net:3478">stun.sipgate.net:3478</option>
													</optgroup>
													<optgroup id="ao_stun_group" label="always-online-stun（在线列表）"></optgroup>
													<optgroup label="自定义">
														<option value="custom">自定义（手动填写 host:port）</option>
													</optgroup>
												</select>
											</div>
											<div class="ks_row" id="custom_row" style="display:none;">
												<span class="ks_label">自定义地址：</span>
												<input id="gostun_custom" class="input_15_table" style="width: 360px;" value="" placeholder="例如：stun.example.com:3478" onkeyup="this.value=this.value.replace(/\\s+/g,'')" />
											</div>

											<div id="log_content" class="soft_setting_log">
												<textarea cols="63" rows="26" wrap="on" readonly="readonly" id="log_content_text" class="soft_setting_log1" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
											</div>
											<div class="apply_gen">
												<input class="button_gen" id="gostun_apply" onClick="gostun_run()" type="button" value="开始检测" />
												<input class="button_gen" id="gostun_clear" style="margin-left:10px;" onClick="gostun_clear()" type="button" value="清空日志" />
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
	<div id="footer"></div>
</body>
</html>
