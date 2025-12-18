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
	.button_gen:disabled {
		opacity: 0.35;
		cursor: not-allowed;
	}
	#head_note a {
		color: #00c6ff;
		font-weight: 600;
		text-decoration: underline;
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
			if (!dbus["gostun_server"] || dbus["gostun_server"] == "null") {
				dbus["gostun_server"] = "auto";
			} else if (dbus["gostun_server"] != "auto" && dbus["gostun_server"] != "custom") {
				if (!dbus["gostun_custom"] || dbus["gostun_custom"] == "null") {
					dbus["gostun_custom"] = dbus["gostun_server"];
				}
				dbus["gostun_server"] = "custom";
			}
			if (dbus["gostun_server"]) {
				$("#gostun_server").val(dbus["gostun_server"]);
			}
			if (dbus["gostun_custom"] && dbus["gostun_custom"] != "null") {
				$("#gostun_custom").val(dbus["gostun_custom"]);
			} else {
				$("#gostun_custom").val("");
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
			set_buttons(false);
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

											<div id="head_note" class="SimpleNote">
												<span>1. 本插件可以检测你的wan侧（未经路由器nat）网络的NAT类型，建议使用自动检测，可以自动切换stun服务器。</span><br/>
												<span>2. 检测结果代表了你路由器网络NAT类型上限，如果你局域网中测试是更低类型（通常是NAT3），说明存在优化空间</span><br/>
												<span>3. 局域网中检测建议手机连Wi-Fi后访问：<a href="https://ai.koolcenter.com/nat" target="_blank" rel="noreferrer">https://ai.koolcenter.com/nat</a>，或者 <a href="https://mao.fan/mynat" target="_blank" rel="noreferrer">https://mao.fan/mynat</a> 进行检测</span>
											</div>
											<div id="log_content" class="soft_setting_log">
												<textarea cols="63" rows="18" wrap="on" readonly="readonly" id="log_content_text" class="soft_setting_log1" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
											</div>
											<table width="100%" border="0" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th>STUN 服务器</th>
													<td>
														<select id="gostun_server" class="input_option" style="width:360px;">
															<option value="auto">自动检测</option>
															<option value="custom">自定义（手动填写 host:port）</option>
														</select>
													</td>
												</tr>
												<tr id="custom_row" style="display:none;">
													<th>自定义地址</th>
													<td>
														<input id="gostun_custom" class="input_ss_table" style="width:360px;" value="" placeholder="例如：stun.example.com:3478" onkeyup="this.value=this.value.replace(/\\s+/g,'')" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" />
													</td>
												</tr>
											</table>
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
