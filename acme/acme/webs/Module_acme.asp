<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - Let's Encrypt</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/> 
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/js/jquery.js"></script>
<script language="JavaScript" type="text/javascript" src="/validator.js"></script>
<script language="JavaScript" type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script language="JavaScript" type="text/javascript" src="/res/softcenter.js"></script>
<style> 
.Bar_container {
	width:85%;
	height:20px;
	border:1px inset #999;
	margin:0 auto;
	margin-top:20px \9;
	background-color:#FFFFFF;
	z-index:100;
}
#proceeding_img_text {
	position:absolute;
	z-index:101;
	font-size:11px;
	color:#000000;
	line-height:21px;
	width: 83%;
}
#proceeding_img {
	height:21px;
	background:#C0D1D3 url(/images/ss_proceding.gif);
}
.acme_btn {
	border: 1px solid #222;
	background: linear-gradient(to bottom, #003333 0%, #000000 100%);
	background: linear-gradient(to bottom, #91071f  0%, #700618 100%); /* W3C rogcss */
	font-size:10pt;
	color: #fff;
	padding: 5px 5px;
	border-radius: 5px 5px 5px 5px;
	width:16%;
}
.acme_btn:hover {
	border: 1px solid #222;
	background: linear-gradient(to bottom, #27c9c9 0%, #279fd9 100%);
	background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%); /* W3C rogcss */
	font-size:10pt;
	color: #fff;
	padding: 5px 5px;
	border-radius: 5px 5px 5px 5px;
	width:16%;
}
input[type=button]:focus {
	outline: none;
}
</style>
<script>
var x = 6;
var basic_action;
var _responseLen;
var noChange = 0;
var httpd_cert_info = [ <% httpd_cert_info(); %> ][0];
var db_acme = {}
var params_input = ["acme_subdomain", "acme_domain", "acme_provider", "acme_ali_arg1", "acme_ali_arg2", "acme_dp_arg1", "acme_dp_arg2", "acme_xns_arg1", "acme_xns_arg2", "acme_cf_arg1", "acme_cf_arg2", "acme_gd_arg1", "acme_gd_arg2"];
var params_check = ["acme_enable"];

function init() {
	show_menu(menu_hook);
	get_dbus_data();
	update_visibility();
	get_cert_info();
	hook_event();
}

function hook_event(){
	$("#log_content2").click(
	function() {
		x = -1;
	});
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/acme",
		dataType: "json",
		async: false,
		success: function(data) {
			db_acme = data.result[0];
			conf_to_obj();
		}
	});
}

function get_cert_info() {
	$.ajax({
		url: '/ajax_certinfo.asp',
		dataType: 'script',
		error: function(xhr) {
			setTimeout("get_cert_info();", 3000);
		},
		success: function(response) {
			show_cert_details();
		}
	});
}

function show_cert_details() {
	if(httpd_cert_info.issueTo){
		E("cert_details").style.display = "";
		E("issueTo").innerHTML = httpd_cert_info.issueTo;
		E("SAN").innerHTML = httpd_cert_info.SAN||"未知";
		if(httpd_cert_info.SAN){
			E("SAN").innerHTML = httpd_cert_info.SAN;
		}else{
			console.log(httpd_cert_info)
			$('#cert_details > td > div:nth-child(2)').hide();
		}
		E("issueBy").innerHTML = httpd_cert_info.issueBy;
		E("expireOn").innerHTML = httpd_cert_info.expire;
	}
}

function update_visibility(r) {
	trs= ["", "ali", "dp", "xns", "cf", "gd"];
	pvd= E("acme_provider").value;
	for (var i = 1; i < trs.length; i++) {
		if(pvd == i){
			E("acme_" + trs[i] + "_arg1_tr").style.display = "";
			E("acme_" + trs[i] + "_arg2_tr").style.display = "";
		}else{
			E("acme_" + trs[i] + "_arg1_tr").style.display = "none";
			E("acme_" + trs[i] + "_arg2_tr").style.display = "none";
		}
	}
}

function conf_to_obj() {
	for (var i = 0; i < params_input.length; i++) {
		if(db_acme[params_input[i]]){
			E(params_input[i]).value = db_acme[params_input[i]];
		}
	}
	for (var i = 0; i < params_check.length; i++) {
		if(db_acme[params_check[i]]){
			E(params_check[i]).checked = db_acme[params_check[i]] == "1";
		}
	}
}

function save(){
	if(!E("acme_subdomain").value){
		alert("字域名不能为空！");
		return false;
	}
	if(!E("acme_domain").value){
		alert("主域名不能为空！");
		return false;
	}
	if(E("acme_provider").value == "1"){
		if(!E("acme_ali_arg1").value || !E("acme_ali_arg2").value){
			alert("输入框不能为空！");
			return false;
		}
	} else if (E("acme_provider").value == "2"){
		if(!E("acme_dp_arg1").value || !E("acme_dp_arg2").value){
			alert("输入框不能为空！");
			return false;
		}
	} else if (E("acme_provider").value == "3"){
		if(!E("acme_xns_arg1").value || !E("acme_xns_arg1").value){
			alert("输入框不能为空！");
			return false;
		}	
	} else if (E("acme_provider").value == "4"){
		if(!E("acme_cf_arg1").value || !E("acme_cf_arg1").value){
			alert("输入框不能为空！");
			return false;
		}	
	} else if (E("acme_provider").value == "5"){
		if(!E("acme_gd_arg1").value || !E("acme_gd_arg1").value){
			alert("输入框不能为空！");
			return false;
		}	
	}
	for (var i = 0; i < params_input.length; i++) {
		if(E(params_input[i])){
			db_acme[params_input[i]] = E(params_input[i]).value
		}
	}
	for (var i = 0; i < params_check.length; i++) {
		db_acme[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
	}
	push_data(db_acme, 1);
}

function renew_cert(){
	if (confirm("你确定需要强制更新吗?????\n你确定需要强制更新吗?????\n你确定需要强制更新吗?????\n1.请注意勿频繁使用此功能，以免超出api次数限制！\n2.强制更新后会重启路由器web服务，导致日志窗口出现网页代码，请自行刷新页面并重新登录！")) {
		var dbus = {}
		push_data(dbus, 2);
	}
}

function delete_cert(){
	if (confirm("你确定删除吗？")) {
		var dbus = {}
		push_data(dbus, 3);
	}
}

function install_cert(){
	var dbus = {}
	push_data(dbus, 4);
}

function push_data(obj, arg) {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "acme_config.sh", "params": [arg], "fields": obj };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == id){
				showKPLoadingBar();
				noChange = 0;
				get_realtime_log();
			}
		}
	});
}

function get_realtime_log(w) {
	$.ajax({
		url: '/_temp/acme_log.txt',
		type: 'GET',
		async: true,
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content3");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", " ");
				retArea.scrollTop = retArea.scrollHeight;
				if(!w){
					E("close_button").style.display = "none";
					E("ok_button").style.display = "";
					count_down_close();
				}else{
					E("close_button").style.display = "";
					E("ok_button").style.display = "none";
				}
				return true;
			}
			if (_responseLen == response.length) {
				noChange++;
			} else {
				noChange = 0;
			}
			if (noChange > 1000) {
				return false;
			} else {
				setTimeout("get_realtime_log();", 500);
			}
			retArea.value = response.replace("XU6J03M6", " ");
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		},
		error: function() {
			setTimeout("get_realtime_log();", 500);
			E("log_content3").value = "日志为空！";
		}
	});
}

function showKPLoadingBar(seconds) {
	if (window.scrollTo)
		window.scrollTo(0, 0);

	disableCheckChangedStatus();

	htmlbodyforIE = document.getElementsByTagName("html"); //this both for IE&FF, use "html" but not "body" because <!DOCTYPE html PUBLIC.......>
	htmlbodyforIE[0].style.overflow = "hidden"; //hidden the Y-scrollbar for preventing from user scroll it.

	winW_H();

	var blockmarginTop;
	var blockmarginLeft;
	if (window.innerWidth)
		winWidth = window.innerWidth;
	else if ((document.body) && (document.body.clientWidth))
		winWidth = document.body.clientWidth;

	if (window.innerHeight)
		winHeight = window.innerHeight;
	else if ((document.body) && (document.body.clientHeight))
		winHeight = document.body.clientHeight;

	if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth) {
		winHeight = document.documentElement.clientHeight;
		winWidth = document.documentElement.clientWidth;
	}

	if (winWidth > 1050) {

		winPadding = (winWidth - 1050) / 2;
		winWidth = 1105;
		blockmarginLeft = (winWidth * 0.3) + winPadding - 150;
	} else if (winWidth <= 1050) {
		blockmarginLeft = (winWidth) * 0.3 + document.body.scrollLeft - 160;

	}

	if (winHeight > 660)
		winHeight = 660;

	blockmarginTop = winHeight * 0.3 - 140
	E("loadingBarBlock").style.marginTop = blockmarginTop + "px";
	E("loadingBarBlock").style.marginLeft = blockmarginLeft + "px";
	E("loadingBarBlock").style.width = 770 + "px";
	E("LoadingBar").style.width = winW + "px";
	E("LoadingBar").style.height = winH + "px";
	loadingSeconds = seconds;
	progress = 100 / loadingSeconds;
	y = 0;
	LoadingACMEProgress(seconds);
}

function LoadingACMEProgress(seconds) {
	E("LoadingBar").style.visibility = "visible";
	if (E("acme_enable").value == 0) {
		E("loading_block3").innerHTML = "Let's Encrypt关闭中 ..."
		$("#loading_block2").html("<li><font color='#ffcc00'><a href='http://www.koolshare.cn' target='_blank'></font>Let's Encrypt工作有问题？请来我们的<font color='#ffcc00'>论坛www.koolshare.cn</font>反应问题...</font></li>");
	} else {
		$("#loading_block2").html("<font color='#ffcc00'>-----------------------------------------------------------------------------------------------------------------------------------");
		E("loading_block3").innerHTML = "Let's Encrypt 插件运行日志:"
	}
}

function hideLoadingBar() {
	x = -1;
	document.getElementById("LoadingBar").style.visibility = "hidden";
	refreshpage();
}

function close_log() {
	document.getElementById("LoadingBar").style.visibility = "hidden";
}

function count_down_close() {
	if (x == "0") {
		refreshpage();
	}
	if (x < 0) {
		E("ok_button1").value = "手动关闭"
		return false;
	}
	E("ok_button1").value = "自动关闭（" + x + "）"
		--x;
	setTimeout("count_down_close();", 1000);
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "Let's Encrypt");
	tablink[tablink.length - 1] = new Array("", "Module_acme.asp");
}

function show_log(){
	showKPLoadingBar();
	noChange = 0;
	get_realtime_log(1);
	E("close_button").style.display = "";
}

</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<div id="LoadingBar" class="popup_bar_bg">
		<table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
			<tr>
				<td height="100">
					<div id="loading_block3" style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;"></div>
					<div id="loading_block2" style="margin:10px auto;width:95%;"></div>
					<div id="log_content2" style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
						<textarea cols="63" rows="30" wrap="on" readonly="readonly" id="log_content3" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Courier New', Courier, mono; font-size:11px;background:#000;color:#FFFFFF;outline:none;"></textarea>
					</div>
					<div id="ok_button" class="apply_gen" style="background: #000;display: none;">
						<input id="ok_button1" class="button_gen" type="button" onclick="hideLoadingBar()" value="确定">
					</div>
					<div id="close_button" class="apply_gen" style="background: #000;display: none;">
						<input id="close_button1" class="button_gen" type="button" onclick="close_log()" value="关闭">
					</div>
				</td>
			</tr>
		</table>
	</div>
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
											<div class="formfonttitle">软件中心 - Let's Encrypt</div>
											<div style="float:right; width:15px; height:25px;margin-top:-20px">
												<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
											</div>
											<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
											<div class="SimpleNote">
												<li>Let's Encrypt是2015年三季度成立的数字证书认证机构，旨在推广互联网无所不在的加密连接，为安全网站提供免费的SSL/TLS证书。
												<li>本插件使用acme.sh，通过dns_api申请ssl证书，目前支持aliyun、Dnspod、CloudXNS、CloudFlare、Godaddy。 <a type="button" style="cursor:pointer" href="https://github.com/koolshare/rogsoft/blob/master/acme/Changelog.txt" target="_blank"><em>【<u>插件更新日志</u>】</em></a></li>
											</div>
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
													<tr>
														<td colspan="2">Let's Encrypt - 高级设置</td>
													</tr>
												</thead>
												<tr id="switch_tr">
													<th>
														<label>开关</label>
													</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="acme_enable">
																<input id="acme_enable" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container">
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
													</td>
												</tr>
												<tr id="cert_details" style="display: none;">
													<th>已安装证书</th>
													<td>
														<div style="display:table-row;">
															<div style="display:table-cell;white-space: nowrap;">Issued to :</div>
															<div id="issueTo" style="display:table-cell; padding-left:10px;"></div>
														</div>
														<div style="display:table-row;">
															<div style="display:table-cell;white-space: nowrap">SAN :</div>
															<div id="SAN" style="display:table-cell; padding-left:10px;"></div>
														</div>
														<div style="display:table-row;">
															<div style="display:table-cell;white-space: nowrap">Issued by :</div>
															<div id="issueBy" style="display:table-cell; padding-left:10px;"></div>
														</div>
														<div style="display:table-row;">
															<div style="display:table-cell;white-space: nowrap">Expires on :</div>
															<div id="expireOn" style="display:table-cell; padding-left:10px;"></div>
														</div>
													</td>
												</tr>
												<tr>
													<th>域名</th>
													<td>
														<input type="text" style="width: 5em" id="acme_subdomain" name="acme_subdomain" placeholder="子域名" value="" class="input_ss_table"> .
														<input type="text" id="acme_domain" name="acme_domain" placeholder="主域名" value="" class="input_ss_table">
													</td>
												</tr>
												<tr>
													<th>DNS服务商</th>
													<td>
														<select name="acme_provider" id="acme_provider" class="input_option" onchange="update_visibility();">
															<option value="1">阿里DNS(万网)</option>
															<option value="2">Dnspod</option>
															<option value="3">CloudXNS</option>
															<option value="4">CloudFlare</option>
															<option value="5">GoDaddy</option>
														</select>
													</td>
												</tr>
												<tr id="acme_ali_arg1_tr" style="display: none;">
													<th>Ali Access Key ID</th>
													<td>
														<input style="width:300px;" type="password" class="input_ss_table" id="acme_ali_arg1" name="acme_arg1" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="100"
														value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);">
													</td>
												</tr>
												<tr id="acme_ali_arg2_tr" style="display: none;">
													<th>Ali Access Key Secret</th>
													<td>
														<input style="width:300px;" type="password" class="input_ss_table" id="acme_ali_arg2" name="acme_arg2" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="100"
														value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);">
													</td>
												</tr>
												<tr id="acme_dp_arg1_tr" style="display: none;">
													<th>Dnspod ID</th>
													<td>
														<input style="width:300px" type="password" class="input_ss_table" id="acme_dp_arg1" name="acme_arg3" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="100"
														value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);">
													</td>
												</tr>
												<tr id="acme_dp_arg2_tr" style="display: none;">
													<th>Dnspod Key</th>
													<td>
														<input style="width:300px;" type="password" class="input_ss_table" id="acme_dp_arg2" name="acme_arg4" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="100"
														value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);">
													</td>
												</tr>
												<tr id="acme_xns_arg1_tr" style="display: none;">
													<th>CloudXNS Access Key ID</th>
													<td>
														<input style="width:300px;" type="password" class="input_ss_table" id="acme_xns_arg1" name="acme_arg5" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="100"
														value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);">
													</td>
												</tr>
												<tr id="acme_xns_arg2_tr" style="display: none;">
													<th>CloudXNS Access Key Secret</th>
													<td>
														<input  type="password" class="input_ss_table" id="acme_xns_arg2" name="acme_arg2" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="100"
														value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);">
													</td>
												</tr>
												<tr id="acme_cf_arg1_tr" style="display: none;">
													<th>CloudFlare Key</th>
													<td>
														<input  type="password" class="input_ss_table" id="acme_cf_arg1" name="acme_cf_arg1" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="100"
														value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);">
													</td>
												</tr>
												<tr id="acme_cf_arg2_tr" style="display: none;">
													<th>CloudFlare Email</th>
													<td>
														<input  type="password" class="input_ss_table" id="acme_cf_arg2" name="acme_cf_arg2" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="100"
														value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);">
													</td>
												</tr>
												<tr id="acme_gd_arg1_tr" style="display: none;">
													<th>GoDaddy Key</th>
													<td>
														<input  type="password" class="input_ss_table" id="acme_gd_arg1" name="acme_gd_arg1" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="100"
														value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);">
													</td>
												</tr>
												<tr id="acme_gd_arg2_tr" style="display: none;">
													<th>GoDaddy Secret</th>
													<td>
														<input  type="password" class="input_ss_table" id="acme_gd_arg2" name="acme_gd_arg2" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="100"
														value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);">
													</td>
												</tr>
												<tr>
													<th>证书管理</th>
													<td>
														<a type="button" class="acme_btn" style="cursor:pointer" onclick="renew_cert();">手动强制更新</a>
														<a type="button" class="acme_btn" style="cursor:pointer" onclick="delete_cert();">删除所有证书</a>
													</td>
												</tr>
												<tr>
													<th>查看日志</th>
													<td>
														<a type="button" class="acme_btn" style="cursor:pointer" onclick="show_log();">查看日志</a>
													</td>
												</tr>
											</table>
											<div id="warning" style="font-size:14px;margin:20px auto;"></div>
											<div class="apply_gen">
												<input class="button_gen" id="cmdBtn" onClick="save();" type="button" value="提交" />
												<!--<input class="button_gen" id="cmdBtn" onClick="install_cert();" type="button" value="安装" />-->
											</div>
											<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
											<div class="SimpleNote">
												<li>Let's Encrypt的免费证书只有90天有效期，到期可以自动续期，或者使用手动更新来续期。</li>
												<li>目前大部分的运营商已经关闭家用宽带80，443端口，如果需要在外网访问请设置端口转发。</li>
												<li>申请到的证书储存在/koolshare/acme/，且安装在/tmp/etc目录，可自行备份。</li>
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

