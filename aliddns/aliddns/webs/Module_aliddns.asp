<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html xmlns:v>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>Aliddns</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/js/jquery.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" language="JavaScript" src="/js/table/table.js"></script>
<script language="JavaScript" type="text/javascript" src="/res/softcenter.js"></script>
<style>
	.show-btn1, .show-btn2, .show-btn3 {
		font-size:10pt;
		color: #fff;
		padding: 10px 3.75px;
		border-radius: 5px 5px 0px 0px;
		width:8.42%;
		border-left: 1px solid #67767d;
		border-top: 1px solid #67767d;
		border-right: 1px solid #67767d;
		border-bottom: none;
		background: #67767d;
		border: 1px solid #91071f; /* W3C rogcss */
		background: none; /* W3C rogcss */
	}
	.show-btn1:hover, .show-btn2:hover, .show-btn3:hover, .active {
		border: 1px solid #2f3a3e;
		background: #2f3a3e;
		border: 1px solid #91071f; /* W3C rogcss */
		background: #91071f; /* W3C rogcss */
	}
	#log_content{
		outline: 1px solid #222;
		width:748px;
	}
	#log_content_text{
		width:97%;
		padding-left:4px;
		padding-right:37px;
		font-family:'Lucida Console';
		font-size:11px;
		line-height:1.5;
		color:#FFFFFF;
		outline:none;
		overflow-x:hidden;
		border:0px solid #222;
		background:#475A5F;
		background:transparent; /* W3C rogcss */
	}
	.ks_btn {
		border: 1px solid #222;
		font-size:10pt;
		color: #fff;
		padding: 5px 5px 5px 5px;
		border-radius: 5px 5px 5px 5px;
		width:14%;
		background: linear-gradient(to bottom, #003333  0%, #000000 100%);
		background: linear-gradient(to bottom, #91071f  0%, #700618 100%); /* W3C rogcss */
	}
	.ks_btn:hover, {
		border: 1px solid #222;
		font-size:10pt;
		color: #fff;
		padding: 5px 5px 5px 5px;
		border-radius: 5px 5px 5px 5px;
		width:14%;
		background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%);
		background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%); /* W3C rogcss */
	}
	#aliddns_switch, #tablet_1, #tablet_2, #aliddns_log, #tablet_3 { border:1px solid #91071f; } /* W3C rogcss */
	.input_option{
		vertical-align:middle;
		font-size:12px;
	}
	input[type=button]:focus {
		outline: none;
	}
</style>
<script>
var dbus = {};
var _responseLen;
var noChange = 0;
var x = 5;
var params_inp = ['aliddns_ak', 'aliddns_sk', 'aliddns_name', 'aliddns_domain', 'aliddns_interval', 'aliddns_dns', 'aliddns_curl', 'aliddns_ttl', 'aliddns_comd'];
var params_chk = ['aliddns_enable'];

function init() {
	show_menu(menu_hook);
	generate_options();
	get_dbus_data();
	get_run_status();
}

function conf2obj(){
	for (var i = 0; i < params_inp.length; i++) {
		if(dbus[params_inp[i]]){
			E(params_inp[i]).value = dbus[params_inp[i]];
		}
	}
	for (var i = 0; i < params_chk.length; i++) {
		if(dbus[params_chk[i]]){
			E(params_chk[i]).checked = dbus[params_chk[i]] == "1";
		}
	}
	if(dbus["aliddns_version"])
		E("aliddns_version").innerHTML = "当前版本：" + dbus["aliddns_version"]
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/aliddns",
		dataType: "json",
		cache: false,
		async: false,
		success: function(data) {
			dbus = data.result[0];
			conf2obj();
			toggle_func();
			update_visibility();
			hook_event();
			change_url();
		},
		error: function(XmlHttpRequest, textStatus, errorThrown){
			console.log(XmlHttpRequest.responseText);
			alert("skipd数据读取错误，请用在chrome浏览器中按F12键后，在console页面获取错误信息！");
		}
	});
}

function change_url() {
	var misc_http_x = '<% nvram_get("misc_http_x"); %>';
	var misc_httpsport_x = '<% nvram_get("misc_httpsport_x"); %>';
	//var ddns_hostname_x_t = '<% nvram_get("ddns_hostname_x"); %>';
	if (!E("aliddns_name").value || E("aliddns_name").value == "@" || E("aliddns_name").value == "*"){
		var ddns_hostname_x_t = E("aliddns_domain").value;
	}else{
		var ddns_hostname_x_t = E("aliddns_name").value + "." + E("aliddns_domain").value;
	}
	if (misc_http_x == "0"){
		E("wan_access_url").innerHTML = "检测到【从互联网设置 <% nvram_get("productid"); %>】未启用，请前往<a href=" + "/Advanced_System_Content.asp" + "><em><u>系统管理 -系统设置</u></em></a>页面设置！";
	}else if (ddns_hostname_x_t.length != 0 && E("aliddns_enable").checked == true){
		E("wan_access_url").innerHTML = "&nbsp;Aliddns远程访问地址：<a href=\"https://" + ddns_hostname_x_t + ":" + misc_httpsport_x + "\" target=\"_blank\" style=\"color:#00ffe4;text-decoration: underline; font-family:Lucida Console;\"><em>https://" + ddns_hostname_x_t + ":" + misc_httpsport_x + "</em></a></em>";
	}
}

function get_run_status(){
	$.ajax({
		type: "GET",
		url: "/_api/aliddns_last_act",
		dataType: "json",
		async: true,
		cache: false,
		success: function(data) {
			var aliddns_status = data.result[0];
			if (aliddns_status["aliddns_last_act"]) {
				E("run_status").innerHTML = aliddns_status["aliddns_last_act"];
			}
		},
		error: function(xhr) {
			E("run_status").innerHTML = "状态获取失败，请查看日志！";
		}
	});
	setTimeout("get_run_status();", 5000);
}

function save(flag) {
	var dbus_new = {}
	$("#show_btn2").trigger("click");
	// collect data from input and checkbox
	for (var i = 0; i < params_inp.length; i++) {
		dbus_new[params_inp[i]] = E(params_inp[i]).value;
	}
	for (var i = 0; i < params_chk.length; i++) {
		dbus_new[params_chk[i]] = E(params_chk[i]).checked ? '1' : '0';
	}
	if(flag == 2){
		// when clean log，don't save enable status
		dbus_new["aliddns_enable"] = dbus["aliddns_enable"]
	}
	// post data
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "aliddns_config.sh", "params": [flag], "fields": dbus_new };
	$.ajax({
		url: "/_api/",
		cache: false,
		async: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == id){
				get_log();
				if(E("aliddns_enable").checked == false){
					setTimeout("refreshpage();", 1000);
				}else{
					if ($('.show-btn2').hasClass("active"))
						setTimeout("$('#show_btn1').trigger('click');", 8000);
				}
			}
		}
	});
}

function generate_options(){
	for(var i = 2; i < 60; i++) {
		$("#aliddns_interval").append("<option value='"  + i + "'>" + i + "</option>");
		$("#aliddns_interval").val(3);
	}
}

function hook_event(){
	$("#aliddns_enable").click(
		function(){
		if(E('aliddns_enable').checked){
			dbus["aliddns_enable"] = "1";
			$('.show-btn1').addClass('active');
			$('.show-btn2').removeClass('active');
			$('.show-btn3').removeClass('active');
			E("tablet_show").style.display = "";
			E("last_act_tr").style.display = "";
			E("tablet_1").style.display = "";
			E("tablet_2").style.display = "none";
			E("tablet_3").style.display = "none";
			E("apply_button-1").style.display = "";
			E("apply_button-2").style.display = "none";

		}else{
			dbus["aliddns_enable"] = "0";
			$('.show-btn1').removeClass('active');
			$('.show-btn2').removeClass('active');
			$('.show-btn3').removeClass('active');
			E("tablet_show").style.display = "none";
			E("last_act_tr").style.display = "none";
			E("tablet_1").style.display = "none";
			E("tablet_2").style.display = "none";
			E("tablet_3").style.display = "none";
			E("apply_button-1").style.display = "";
			E("apply_button-2").style.display = "none";
		}
	});
}


function get_log(){
	$.ajax({
		url: '/_temp/aliddns_log.txt',
		type: 'GET',
		dataType: 'html',
		async: true,
		cache: false,
		success: function(response) {
			var retArea = E("log_content_text");
			if (_responseLen == response.length) {
				noChange++;
			} else {
				noChange = 0;
			}
			if (noChange > 200) {
				return false;
			} else {
				setTimeout("get_log();", 1500);
			}
			retArea.value = response;
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		},
		error: function(xhr) {
			setTimeout("get_log();", 5000);
			E("log_content_text").value = "暂无日志信息！";
		}
	});
}

function toggle_func(){
	$('.show-btn1').addClass('active');
	$(".show-btn1").click(
		function() {
			$('.show-btn1').addClass('active');
			$('.show-btn2').removeClass('active');
			$('.show-btn3').removeClass('active');
			E("tablet_1").style.display = "";
			E("tablet_2").style.display = "none";
			E("tablet_3").style.display = "none";
			E("apply_button-1").style.display = "";
			E("apply_button-2").style.display = "none";
		});
	$(".show-btn2").click(
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn2').addClass('active');
			$('.show-btn3').removeClass('active');
			E("tablet_1").style.display = "none";
			E("tablet_2").style.display = "";
			E("tablet_3").style.display = "none";
			E("apply_button-1").style.display = "none";
			E("apply_button-2").style.display = "";
			get_log();
		});
	$(".show-btn3").click(
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn2').removeClass('active');
			$('.show-btn3').addClass('active');
			E("tablet_1").style.display = "none";
			E("tablet_2").style.display = "none";
			E("tablet_3").style.display = "";
			E("apply_button-1").style.display = "none";
			E("apply_button-2").style.display = "none";
		});
}

function update_visibility(){
	// pannel
	if(E("aliddns_enable").checked == true){
		E("tablet_show").style.display = "";
		E("last_act_tr").style.display = "";
		E("tablet_1").style.display = "";
	}else{
		E("tablet_show").style.display = "none";
		E("last_act_tr").style.display = "none";
		E("tablet_1").style.display = "none";
	}
	// update command
	switch (E("aliddns_comd").value) {
		case '1':
			E("aliddns_curl").value = "curl -s --interface ppp0 whatismyip.akamai.com"
			break;
		case '2':
			E("aliddns_curl").value = "curl -s --interface ppp0 ip.clang.cn"
			break;
		case '3':
			E("aliddns_curl").value = "curl -s whatismyip.akamai.com"
			break;
		case '4':
			E("aliddns_curl").value = "curl -s ip.clang.cn"
			break;
		case '5':
			E("aliddns_curl").value = "nvram get wan0_realip_ip"
			break;
		case '6':
			if(dbus["aliddns_userip"]){
				E("aliddns_curl").value = dbus["aliddns_userip"]
			}else{
				E("aliddns_curl").value = ""
			}
			E("aliddns_curl").placeholder = "自定义ip地址或命令，如：nvram get wan1_realip_ip"
			break;
	}
}

function menu_hook() {
	tabtitle[tabtitle.length - 1] = new Array("", "aliddns");
	tablink[tablink.length - 1] = new Array("", "Module_aliddns.asp");
}

function reload_Soft_Center(){
	location.href = "/Module_Softcenter.asp";
}
</script>
</head>
<body onload="init();">
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
			<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0" style="display: block;">
				<tr>
					<td align="left" valign="top">
						<div>
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div style="float:left;" class="formfonttitle" style="padding-top: 12px">Aliddns</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div style="margin-left:5px;" id="head_illustrate">
											<li><em>Aliddns</em>是一款基于阿里云解析的私人ddns解决方案。</li>
										</div>
										<div id="aliddns_switch" style="margin:5px 0px 0px 0px;">
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
												<tr>
													<td colspan="2">Aliddns - 开关/状态</td>
												</tr>
												</thead>
												<tr id="switch_tr">
													<th>
														<label>开启Aliddns</label>
													</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell">
															<label for="aliddns_enable">
																<input id="aliddns_enable" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container" >
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
														<div style="display:table-cell;float: left;margin-left:270px;margin-top:-32px;position: absolute;padding: 5.5px 0px;">
															<a type="button" class="ks_btn" target="_blank" href="https://github.com/koolshare/rogsoft/blob/master/aliddns/Changelog.txt">更新日志</a>
														</div>
														<div id="aliddns_version" style="padding-top:5px;margin-right:50px;margin-top:-30px;float: right;"></div>	
													</td>
												</tr>
												<tr id="last_act_tr" style="display: none;">
													<th>上次运行</th>
													<td>
														<span id="run_status"></span>
													</td>
												</tr>
											</table>
										</div>
										<div id="tablet_show" style="display: none;">
											<table style="margin:10px 0px 0px 0px;border-collapse:collapse" width="100%" height="37px">
												<tr>
													<td cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#222">
														<input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="服务配置"/>
														<input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="查看日志"/>
														<input id="show_btn3" class="show-btn3" style="cursor:pointer" type="button" value="帮助信息"/>
													</td>
													</tr>
											</table>
										</div>
										<div id="tablet_1" style="display: none;">
											<table width="100%" border="0" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr id="ak_tr">
													<th>Ali Access Key ID</th>
													<td>
														<input type="text" id="aliddns_ak" value="" class="input_ss_table" style="width:200px;" autocomplete="off" autocorrect="off" autocapitalize="off" maxlength="100" spellcheck="false" readonly onFocus="this.removeAttribute('readonly');">
													</td>
												</tr>
												<tr id="sk_tr">
													<th>Ali Access Key Secret</th>
													<td>
														<input type="password" id="aliddns_sk" value="" class="input_ss_table" style="width:260px;" autocomplete="off" autocorrect="off" autocapitalize="off" maxlength="100" spellcheck="false" readonly onBlur="switchType(this, false);" onFocus="switchType(this, true);this.removeAttribute('readonly');"/>
													</td>
												</tr>
												<tr id="interval_tr">
													<th>检查周期</th>
													<td>
														<select style="width:40px;margin:0px 0px 0px 2px;" id="aliddns_interval" name="aliddns_interval" class="input_option"></select> min
													</td>
												</tr>
												<tr id="name_tr">
													<th>域名</th>
													<td>
														<input type="text" style="width: 4em" id="aliddns_name" placeholder="子域名" value="router" class="input_ss_table" onBlur="change_url();" autocorrect="off" autocapitalize="off">.
														<input type="text"  id="aliddns_domain" placeholder="主域名" value="example.com" class="input_ss_table" onBlur="change_url();" autocorrect="off" autocapitalize="off">
													</td>
												</tr>
												<tr id="dns_tr">
													<th title="查询域名当前IP时使用的DNS解析服务器，默认为阿里云DNS">DNS服务器(?)</th>
													<td><input id="aliddns_dns" class="input_ss_table" value="223.5.5.5"></td>
												</tr>
												<tr id="curl_tr">
													<th title="可自行修改命令行，以获得正确的公网IP。如添加 '--interface vlan2' 以指定多播情况下的端口支持">获得IP命令(?)</th>
													<td>
													<select id="aliddns_comd" class="input_option" onchange="update_visibility();">
														<option value="1" selected="selected">命令1</option>
														<option value="2">命令2</option>
														<option value="3">命令3</option>
														<option value="4">命令4</option>
														<option value="5">命令5</option>
														<option value="6">自定义</option>
													</select>
														<!--<textarea id="aliddns_curl" class="input_ss_table" style="width: 94%; height: 2.4em">curl -s --interface ppp0 ip.clang.cn</textarea>-->
														<input type="text" id="aliddns_curl" value="curl -s --interface ppp0 ip.clang.cn" maxlength="300" placeholder="" class="input_ss_table" spellcheck="false" style="width:84%" title="[排除]关键词（含关键词的节点不会添加）">
													</td>
												</tr>
												<tr id="ttl_tr">
													<th title="设置解析TTL，默认10分钟，免费版的范围是600-86400">TTL(?)</th>
													<td><input id="aliddns_ttl" style="width: 4.5em" class="input_ss_table" value="600">s (1~86400)</td>
												</tr>
												<tr id="url_tr">
													<th>远程访问地址</th>
													<td><span style="text-align: left;" id="wan_access_url"></span></td>
												</tr>
											</table>
										</div>
										<div id="tablet_2" style="display: none;">
											<div id="log_content" style="margin-top:-1px;display:block;overflow:hidden;">
												<textarea cols="63" rows="20" wrap="on" readonly="readonly" id="log_content_text" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
											</div>
										</div>
										<div id="tablet_3" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
												<td>
													<ul>
														<li>插件使用帮助-1：<a href="https://koolshare.cn/thread-64703-1-1.html" target="_blank" ><i><u>自制Aliddns插件：基于阿里云解析的私人ddns解决方案</u></i></a></li>
														<li>插件使用帮助-2：<a href="https://koolshare.cn/thread-85519-1-1.html" target="_blank" ><i><u>零基础小白Aliddns插件设置教程</u></i></a></li>
														<li>说明：使用远程访问需要在<a href=/Advanced_System_Content.asp><em>【系统管理 -系统设置】</em></a>页面打开【<#1735#>】功能。</li>
														<li>注意：如果你正在使用<a href=/Advanced_ASUSDDNS_Content.asp><em>固件内置的DDNS服务</em></a>，启用<i>【网络地图】首页显示Aliddns域名</i>功能后，固件内置的DDNS服务将会被禁用，如ASUSDDNS.！</li>
														<li>获得IP命令功能：
														<br />&nbsp;&nbsp;&nbsp;&nbsp;1. 如果本路由使用pppoe拨号，且能获得公网ip，可以使用命令1或者2，当然命令3-5也是可以的。
														<br />&nbsp;&nbsp;&nbsp;&nbsp;2. 如果本路由二级路由，无法获得公网ip，想为上级路由的公网ip设置DDNS，可以使用命令3、命令4。
														<br />&nbsp;&nbsp;&nbsp;&nbsp;3. 如果不想使用curl来获取地址，可以尝试nvram命令来获取公网ip，如命令5。
														<br />&nbsp;&nbsp;&nbsp;&nbsp;4. 命令1 - 5不可更改，请使用自定义命令或ip选项，如双拨后用第二WAN IP获取命令：<i>nvram get wan0_realip_ip</i>。
														<br />&nbsp;&nbsp;&nbsp;&nbsp;5. 自定义选项也可直接写入ip地址：<i>114.188.24.115</i>。
														</li>
														<li>建议安装软件中心的<i>【Let's Encrypt】</i>插件，可为你的域名配置ssl证书，让远程访问更加安全。</li>
													</ul>
												</td>
												</tr>
											</table>
										</div>
										<div id="apply_button" class="apply_gen">
											<input id="apply_button-1" class="button_gen" type="button" onclick="save(1)" value="提交">
											<input id="apply_button-2" class="button_gen" type="button" onclick="save(2)" value="清除" style="display: none;">
										</div>
										<div class="KoolshareBottom" style="margin-top:50px;">
											论坛技术支持: <a href="https://koolshare.cn" target="_blank"> <i><u>https://koolshare.cn</u></i></a><br />
											GitHub: <a href="https://github.com/koolshare/rogsoft" target="_blank"><i><u>https://github.com/koolshare</u></i></a><br />
											Shell & Web by: <a href="mailto:sadoneli@gmail.com"><i>kyrios</i></a>, <i>sadog</i>
										</div>
									</td>
								</tr>
							</table>
						</div>
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

