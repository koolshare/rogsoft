<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>CloudFlare DDNS</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
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
		border: 1px solid #91071f;  /* W3C rogcss */
		background: none;  /* W3C rogcss */
	}
	.active {
		border: 1px solid #2f3a3e;
		background: #2f3a3e;
		border: 1px solid #91071f; /* W3C rogcss */
		background: #91071f; /* W3C rogcss */
	}
	.ss_btn {
		border: 1px solid #222;
		font-size:10pt;
		color: #fff;
		padding: 5px 5px 5px 5px;
		border-radius: 5px 5px 5px 5px;
		width:14%;
		background: linear-gradient(to bottom, #003333  0%, #000000 100%);
		background: linear-gradient(to bottom, #91071f  0%, #700618 100%); /* W3C rogcss */
	}
	.ss_btn:hover, .active3 {
		border: 1px solid #222;
		font-size:10pt;
		color: #fff;
		padding: 5px 5px 5px 5px;
		border-radius: 5px 5px 5px 5px;
		width:14%;
		background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%);
		background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%); /* W3C rogcss */
	}
	#log_content1{
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
	#cfddns_switch, #cfddns_status, #cfddns_settings, #cfddns_log, #cfddns_help { border:1px solid #91071f; } /* W3C rogcss */
	#log_content{ outline: 1px solid #222;width:748px; }
	input[type=button]:focus {
		outline: none;
	}
</style>
<script>
var dbus = {};
var _responseLen;
var noChange = 0;
var x = 5;
var params_inp = ['cfddns_email', 'cfddns_akey', 'cfddns_zid', 'cfddns_name', 'cfddns_domain', 'cfddns_ttl', 'cfddns_method_v4', 'cfddns_method_v6'];
var params_chk = ['cfddns_enable', 'cfddns_proxied', 'cfddns_ipv6'];

function init(){
	show_menu(menu_hook);
	get_dbus_data();
	conf2obj();
	toggle_func();
	update_visibility();
	get_status();
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
}

function get_dbus_data(){
	$.ajax({
		type: "GET",
		url: "/_api/cfddns",
		dataType: "json",
		async: false,
		success: function(data) {
			dbus = data.result[0];
		}
	});
}

function get_status(){
	if (dbus["cfddns_enable"] == "1"){
		inner_status = dbus["cfddns_status_v4"] || "获取状态失败！";
		if (dbus["cfddns_ipv6"] == "1"){
			inner_status = inner_status + "<br>" + (dbus["cfddns_status_v6"] || "获取状态失败！");
		}
		E('script_status').innerHTML = inner_status;
	}else{
		E('script_status').innerHTML = "插件未开启！";
	}
}

function get_status1(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "cfddns_status.sh", "params":[1], "fields": ""};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			E("script_status").innerHTML = response.result;
			setTimeout("get_status();", 3000);
		},
		error: function(){
			E("script_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_status();", 8000);
		}
	});
}

function save(){
	setInterval("get_status();",2000);
	var dbus_new = {}
	$("#show_btn2").trigger("click");
	// collect data from input and checkbox
	for (var i = 0; i < params_inp.length; i++) {
		dbus_new[params_inp[i]] = E(params_inp[i]).value;
	}
	for (var i = 0; i < params_chk.length; i++) {
		dbus_new[params_chk[i]] = E(params_chk[i]).checked ? '1' : '0';
	}
	// 提交数据
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "cfddns_config.sh", "params": [1], "fields": dbus_new };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == id){
				get_log();
				if(E("cfddns_enable").checked == false){
					setTimeout("refreshpage();", 1000);
				};
			}
		}
	});
}

function get_log(){
	$.ajax({
		url: '/_temp/cfddns_log.txt',
		type: 'GET',
		dataType: 'html',
		async: true,
		cache:false,
		success: function(response) {
			var retArea = E("log_content1");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", "");
				retArea.scrollTop = retArea.scrollHeight;
				return true;
			}
			if (_responseLen == response.length) {
				noChange++;
			} else {
				noChange = 0;
			}
			if (noChange > 6000) {
				return false;
			} else {
				setTimeout("get_log();", 500);
			}
			retArea.value = response.replace("XU6J03M7", "");
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		},
		error: function(xhr) {
			setTimeout("get_log();", 1000);
			E("log_content1").value = "暂无日志信息！";
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
			E("cfddns_settings").style.display = "";
			E("cfddns_log").style.display = "none";
			E("cfddns_help").style.display = "none";
		});
	$(".show-btn2").click(
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn2').addClass('active');
			$('.show-btn3').removeClass('active');
			E("cfddns_settings").style.display = "none";
			E("cfddns_log").style.display = "";
			E("cfddns_help").style.display = "none";
			get_log();
		});
	$(".show-btn3").click(
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn2').removeClass('active');
			$('.show-btn3').addClass('active');
			E("cfddns_settings").style.display = "none";
			E("cfddns_log").style.display = "none";
			E("cfddns_help").style.display = "";
		});
	$("#cfddns_ipv6").click(
		function(e){
			if($('#cfddns_ipv6').prop("checked")){
				E('cfddns_method_v6_tr').style.visibility = "";
				E('cfddns_method_v6_tr').style.display = "";
			}else{
				E('cfddns_method_v6_tr').style.visibility = "hidden";
				E('cfddns_method_v6_tr').style.display = "none";
			};
		});
}

function update_visibility(){
	if($('.show-btn1').hasClass("active")){
		E('cfddns_status').style.display = "";
		E('tablet_show').style.display = "";
		E('cfddns_settings').style.display = "";
		E('cfddns_log').style.display = "none";
		E('cfddns_help').style.display = "none";
	}else if($('.show-btn2').hasClass("active")){
		E('cfddns_status').style.display = "";
		E('tablet_show').style.display = "";
		E('cfddns_settings').style.display = "none";
		E('cfddns_log').style.display = "";
		E('cfddns_help').style.display = "none";
	}else if($('.show-btn3').hasClass("active")){
		E('cfddns_status').style.display = "";
		E('tablet_show').style.display = "";
		E('cfddns_settings').style.display = "none";
		E('cfddns_log').style.display = "none";
		E('cfddns_help').style.display = "";
	}
	if($('#cfddns_ipv6').prop("checked")){
		E('cfddns_method_v6_tr').style.visibility = "";
		E('cfddns_method_v6_tr').style.display = "";
	}else{
		E('cfddns_method_v6_tr').style.visibility = "hidden";
		E('cfddns_method_v6_tr').style.display = "none";
	};
}

function menu_hook(){
	tabtitle[tabtitle.length - 1] = new Array("", "CloudFlare DDNS");
	tablink[tablink.length - 1] = new Array("", "Module_cfddns.asp");
}

function reload_Soft_Center(){
	location.href = "/Module_Softcenter.asp";
}
</script>
</head>
<body onload="init();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<input type="hidden" name="current_page" value="Module_ssserver.asp"/>
<input type="hidden" name="next_page" value="Module_ssserver.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="5"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="ssserver_config.sh"/>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
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
										<div id="cfddns_title" style="float:left;" class="formfonttitle" style="padding-top: 12px">CloudFlare DDNS</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote" id="head_illustrate"><i></i><em>CloudFlare DDNS是基于 CloudFlare API实现的个人DDNS工具。</em></div>
										<div id="cfddns_switch" style="margin:0px 0px 0px 0px;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
												<tr>
													<td colspan="2">CloudFlare DDNS - 开关</td>
												</tr>
												</thead>
												<tr id="switch_tr">
													<th>
														<label>开启CloudFlare DDNS</label>
													</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell">
															<label for="cfddns_enable">
																<input id="cfddns_enable" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container" >
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
														<div style="display:table-cell;float: left;margin-left:270px;margin-top:-32px;position: absolute;padding: 5.5px 0px;">
															<a type="button" class="ss_btn" target="_blank" href="https://github.com/koolshare/rogsoft/blob/master/cfddns/Changelog.txt">更新日志</a>
														</div>
													</td>
												</tr>
											</table>
										</div>
										<div id="cfddns_status" style="margin:10px 0px 0px 0px;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
													<tr>
														<td colspan="2">CloudFlare DDNS - 状态</td>
													</tr>
												</thead>
												<tr id="script_status_tr">
													<th>运行状态</th>
													<td>
														<span id="script_status"></span>
													</td>
												</tr>
											</table>
										</div>
										<div id="tablet_show">
											<table style="margin:10px 0px 0px 0px;border-collapse:collapse" width="100%" height="37px">
												<tr	width="235px">
													<td colspan="4" cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#000">
														<input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="服务配置"/>
														<input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="查看日志"/>
														<input id="show_btn3" class="show-btn3" style="cursor:pointer" type="button" value="帮助信息"/>
													</td>
													</tr>
											</table>
										</div>
										<div id="cfddns_settings" style="margin:-1px 0px 0px 0px;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th>Email</th>
													<td>
														<input type="text" id="cfddns_email" name="cfddns_email" class="input_ss_table" style="width:340px;" autocomplete="off" autocorrect="off" autocapitalize="off" value="" />
													</td>
												</tr>
												<tr>
													<th>API KEY</th>
													<td>
														<input type="password" name="cfddns_akey" id="cfddns_akey" class="input_ss_table" style="width:340px;" autocomplete="off" autocorrect="off" autocapitalize="off" maxlength="300" readonly onBlur="switchType(this, false);" onFocus="switchType(this, true);this.removeAttribute('readonly');" value="" />
													</td>
												</tr>
												<tr>
													<th>Zone ID</th>
													<td>
														<input type="password" name="cfddns_zid" id="cfddns_zid" class="input_ss_table" style="width:340px;" autocomplete="off" autocorrect="off" autocapitalize="off" maxlength="300" readonly onBlur="switchType(this, false);" onFocus="switchType(this, true);this.removeAttribute('readonly');" value="" />
													</td>
												</tr>
												<tr>
													<th width="35%">域名(Domain Name)</th>
													<td>
														<input type="text" maxlength="64" id="cfddns_name" name="cfddns_name" class="input_ss_table" style="width:130px;" autocomplete="off" autocorrect="off" autocapitalize="off" placeholder="子域名" value="" />
														.
														<input type="text" maxlength="64" id="cfddns_domain" name="cfddns_domain" class="input_ss_table" style="width:191px;" autocomplete="off" autocorrect="off" autocapitalize="off" placeholder="主域名" value="" />
													</td>
												</tr>
												<tr>
													<th title="设置解析TTL，免费版的范围是120-86400,设置1为自动,默认为1">生存时间(TTL) [?]</th>
													<td>
														<input type="text" maxlength="64" id="cfddns_ttl" name="cfddns_ttl" class="input_ss_table" style="width:130px;" autocomplete="off" autocorrect="off" autocapitalize="off" value="1" />
													</td>
												</tr>
												<tr>
													<th title="开启后所有流量经Cloudflare在到路由器">Cloudflare代理(proxied)[?]</th>
													<td>
														<input type="checkbox" id="cfddns_proxied" name="cfddns_proxied" >
													</td>
												</tr>
												<tr>
													<th title="请先确认是否路由能获得IPV6地址,并且能上网">IPV6支持[?]</th>
													<td>
														<input type="checkbox" id="cfddns_ipv6" name="cfddns_ipv6" >
													</td>
												</tr>
												<tr id="cfddns_method_v4_tr">
													<th title="可自行修改命令行，以获得正确的公网IPv4。如添加 '--interface vlan2' 以指定多播情况下的接口,可以空着">获得IPv4命令(get ip)[?]</th>
													<td>
														<input type="text" id="cfddns_method_v4" name="cfddns_method_v6" value="curl -s --interface ppp0 v4.ipip.net" class="input_ss_table" style="width:98%;" autocomplete="off" autocorrect="off" autocapitalize="off" />
													</td>
												</tr>
												<tr id="cfddns_method_v6_tr" style="visibility: hidden; display: none;">
													<th title="可自行修改命令行，以获得正确的公网IPv6。如添加 '--interface vlan2' 以指定多播情况下的接口,可以空着">获得IPv6命令(get ip)[?]</th>
													<td>
														<input type="text" id="cfddns_method_v6" name="cfddns_method_v6" value="curl -s --interface ppp0 v6.ipip.net" class="input_ss_table" style="width:98%;" autocomplete="off" autocorrect="off" autocapitalize="off" />
													</td>
												</tr>
											</table>
										</div>											
										<div id="cfddns_log" style="margin:-1px 0px 0px 0px;display: none;">
											<div id="log_content" style="margin-top:-1px;display:block;overflow:hidden;">
												<textarea cols="63" rows="20" wrap="on" readonly="readonly" id="log_content1" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
											</div>
										</div>
										<div id="cfddns_help" style="margin:-1px 0px 0px 0px;display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
												<td>
													<ul>
														<li>注意：本插件仅适用于koolshare RT-AC86U、RT-AC5300、RT-AX88U等hnd/axhnd平台固件！</li>
														<li>使用此插件时，需要在cloudflare上先添加A记录，然后再把添加的A记录域名填入到上方选项里，域名要保持一致。</li>
														<li>使用IPV6时，需要在cloudflare上先添加AAAA记录。</li>
														<li>上面的检测只代表服务器设置了IP地址，一般需要一段时间来生效，这跟服务器有关。</li>
														<li>开启Cloudflare代理后，域名解析的IP地址为Cloudflare的IP，所有流量需经Cloudflare服务器再到你设备的IP，只适用于网页。</li>
														<li>参考链接：<a href="https://www.cloudflare.com/" target="_blank" ><i><u>https://www.cloudflare.com/</u></i></a>，<a href="http://koolshare.cn/thread-147364-1-1.html" target="_blank" ><i><u>http://koolshare.cn/thread-147364-1-1.html</u></i></a></li>
													</ul>
												</td>
												</tr>
											</table>
										</div>
										<div class="apply_gen">
											<button id="cmdBtn" class="button_gen" onclick="save()">提交</button>
										</div>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
        </td>
    </tr>
</table>
<div id="footer"></div>
</body>
</html>

