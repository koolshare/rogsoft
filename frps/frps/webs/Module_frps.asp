<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - frps</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/> 
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/res/softcenter.css"> 	
<style>
input[type=button]:focus {
	outline: none;
}
.popup_bar_bg_ks{
	position:fixed;	
	margin: auto;
	top: 0;
	left: 0;
	width:100%;
	height:100%;
	z-index:99;
	/*background-color: #444F53;*/
	filter:alpha(opacity=90);  /*IE5、IE5.5、IE6、IE7*/
	background-repeat: repeat;
	visibility:hidden;
	overflow:hidden;
	/*background: url(/images/New_ui/login_bg.png);*/
	background:rgba(68, 79, 83, 0.85) none repeat scroll 0 0 !important;
	background-position: 0 0;
	background-size: cover;
	opacity: .94;
}
.loadingBarBlock{
	width:740px;
}
.loading_block_spilt {
	background: #656565;
	height: 1px;
	width: 98%;
}
</style>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/calendar/jquery-ui.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/frps-menu.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script>
var db_frps = {};
var params_input = ["frps_common_dashboard_port", "frps_common_dashboard_user", "frps_common_dashboard_pwd", "frps_common_bind_port", "frps_common_privilege_token", "frps_common_vhost_http_port", "frps_common_vhost_https_port", "frps_common_cron_time", "frps_common_max_pool_count", "frps_common_log_file", "frps_common_log_level", "frps_common_log_max_days", "frps_common_tcp_mux", "frps_common_cron_hour_min"]
var params_check = ["frps_enable"];
var	refresh_flag;
var count_down;
String.prototype.myReplace = function(f, e){
	var reg = new RegExp(f, "g"); 
	return this.replace(reg, e); 
}
function init(){
	show_menu(menu_hook);
	get_dbus_data();
	get_status();
	conf2obj();
	version_show();
	hook_event();
}
function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/frps",
		dataType: "json",
		async: false,
		success: function(data) {
			db_frps = data.result[0];
			console.log(db_frps);
		}
	});
}
function get_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "frps_status.sh", "params":[1], "fields": ""};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			if(response.result){
				E("status").innerHTML = response.result;
				setTimeout("get_status();", 5000);
			}
		},
		error: function(xhr){
			console.log(xhr)
			setTimeout("get_status();", 15000);
		}
	});
}
function conf2obj(){
	for (var i = 0; i < params_input.length; i++) {
		if(db_frps[params_input[i]]){
			E(params_input[i]).value = db_frps[params_input[i]];
		}
	}
	for (var i = 0; i < params_check.length; i++) {
		if(db_frps[params_check[i]]){
			E(params_check[i]).checked = db_frps[params_check[i]] == 1 ? true : false
		}
	}
}
function save() {
	if(!E(frps_common_dashboard_port).value || !E(frps_common_dashboard_user).value || !E(frps_common_dashboard_pwd).value || !E(frps_common_bind_port).value || !E(frps_common_privilege_token).value || !E(frps_common_vhost_http_port).value || !E(frps_common_vhost_https_port).value || !E(frps_common_max_pool_count).value || !E(frps_common_cron_time).value){
		alert("提交的表单不能为空!");
		return false;
	}
	for (var i = 0; i < params_input.length; i++) {
		if (E(params_input[i]).value) {
			db_frps[params_input[i]] = E(params_input[i]).value;
		}else{
			db_frps[params_input[i]] = "";
		}
	}
	for (var i = 0; i < params_check.length; i++) {
		db_frps[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
	}
	var uid = parseInt(Math.random() * 100000000);
	console.log("uid :", uid);
	var postData = {"id": uid, "method": "frps_config.sh", "params": ["web_submit"], "fields": db_frps };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			console.log("response: ", response);
			if (response.result == uid) {
				get_log();
			} else {
				return false;
			}
		},
		error: function(XmlHttpRequest, textStatus, errorThrown){
			console.log(XmlHttpRequest.responseText);
			alert("skipd数据读取错误！");
		}
	});
}
function reload_Soft_Center(){
	location.href = "/Module_Softcenter.asp";
}
function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "Frps 内网穿透");
	tablink[tablink.length - 1] = new Array("", "Module_frps.asp");
}
function version_show(){
	$.ajax({
		url: 'https://koolshare.ngrok.wang/frps/config.json.js',
		type: 'GET',
		dataType: 'jsonp',
		success: function(res) {
			if(typeof(res["version"]) != "undefined" && res["version"].length > 0) {
				if(res["version"] == db_frps["frps_version"]){
					$("#frps_version_show").html(" - " + res["version"]);
				}else if(res["version"] > db_frps["frps_version"]) {
					$("#frps_version_show").html("<font color=\"#66FF66\">【有新版本：" + res.version + "】</font>");
				}
			}
		}
	});
}
function hook_event(){
	$(".popup_bar_bg_ks").click(
		function() {
			count_down = -1;
		});
	$(window).resize(function(){
		if($('.popup_bar_bg_ks').css("visibility") == "visible"){
			document.scrollingElement.scrollTop = 0;
			var page_h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
			var page_w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
			var log_h = E("loadingBarBlock").clientHeight;
			var log_w = E("loadingBarBlock").clientWidth;
			var log_h_offset = (page_h - log_h) / 2;
			var log_w_offset = (page_w - log_w) / 2 + 90;
			$('#loadingBarBlock').offset({top: log_h_offset, left: log_w_offset});
		}
	});
}
function showWBLoadingBar(){
	document.scrollingElement.scrollTop = 0;
	E("LoadingBar").style.visibility = "visible";
	E("loading_block_title").innerHTML = "【frps】日志";
	var page_h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	var page_w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	var log_h = E("loadingBarBlock").clientHeight;
	var log_w = E("loadingBarBlock").clientWidth;
	var log_h_offset = (page_h - log_h) / 2;
	var log_w_offset = (page_w - log_w) / 2 + 90;
	$('#loadingBarBlock').offset({top: log_h_offset, left: log_w_offset});
}
function hideWBLoadingBar(){
	E("LoadingBar").style.visibility = "hidden";
	E("ok_button").style.visibility = "hidden";
	if (refresh_flag == "1"){
		refreshpage();
	}
}
function count_down_close() {
	if (count_down == "0") {
		hideWBLoadingBar();
	}
	if (count_down < 0) {
		E("ok_button1").value = "手动关闭"
		return false;
	}
	E("ok_button1").value = "自动关闭（" + count_down + "）"
		--count_down;
	setTimeout("count_down_close();", 1000);
}
function get_log(action){
	E("ok_button").style.visibility = "hidden";
	showWBLoadingBar();
	$.ajax({
		url: '/_temp/frps_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.myReplace("XU6J03M6", " ");
				E("ok_button").style.visibility = "visible";
				retArea.scrollTop = retArea.scrollHeight;
				if(action == 1){
					count_down = -1;
					refresh_flag = 0;
				}else{
					count_down = 5;
					refresh_flag = 1;
				}
				count_down_close();
				return false;
			}
			setTimeout("get_log();", 300);
			retArea.value = response.myReplace("XU6J03M6", " ");
			retArea.scrollTop = retArea.scrollHeight;
		},
		error: function(xhr) {
			E("loading_block_title").innerHTML = "暂无日志信息 ...";
			E("log_content").value = "日志文件为空，请关闭本窗口！";
			E("ok_button").style.visibility = "hidden";
			return false;
		}
	});
}
</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<div id="LoadingBar" class="popup_bar_bg_ks" style="z-index: 200;" >
		<table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
			<tr>
				<td height="100">
				<div id="loading_block_title" style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;"></div>
				<div id="loading_block_spilt" style="margin:10px 0 10px 5px;" class="loading_block_spilt"></div>
				<div style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
					<textarea cols="50" rows="26" wrap="off" readonly="readonly" id="log_content" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Lucida Console'; font-size:11px;background:transparent;color:#FFFFFF;outline: none;padding-left:3px;padding-right:22px;overflow-x:hidden"></textarea>
				</div>
				<div id="ok_button" class="apply_gen" style="background: #000;visibility:hidden;">
					<input id="ok_button1" class="button_gen" type="button" onclick="hideWBLoadingBar()" value="确定">
				</div>
				</td>
			</tr>
		</table>
	</div>
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
										<div class="formfonttitle">Frps内网穿透<lable id="frps_version_show"><lable></div>
										<div style="float:right; width:15px; height:25px;margin-top:-20px">
											<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
										</div>
										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote">
											<span>frp 是一个专注于内网穿透的高性能的反向代理应用，支持 TCP、UDP、HTTP、HTTPS 等多种协议。可以将内网服务以安全、便捷的方式通过具有公网 IP 节点的中转暴露到公网。</span>
										</div>
										<div id="frps_main">
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr id="switch_tr">
													<th>
														<label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(0)">开启Frps</a></label>
													</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="frps_enable">
																<input id="frps_enable" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container" >
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
														<div style="float: right;margin-top:5px;margin-right:30px;">
															<a type="button" href="https://github.com/fatedier/frp" target="_blank" class="ks_btn" style="cursor: pointer;border:none;" >frp开源项目</a>
															<a type="button" href="https://koolshare.cn/thread-65379-1-1.html" target="_blank" class="ks_btn" style="cursor: pointer;margin-left:5px;border:none" >服务器搭建教程</a>
															<a type="button" href="https://raw.githubusercontent.com/koolshare/rogsoft/master/frps/Changelog.txt" target="_blank" class="ks_btn" style="cursor: pointer;margin-left:5px;border:none" >更新日志</a>
															<a type="button" class="ks_btn" href="javascript:void(0);" onclick="get_log(1)" style="cursor: pointer;margin-left:5px;border:none">查看日志</a>
														</div>
													</td>
												</tr>
											</table>
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="margin-top:8px;">
												<thead>
													  <tr>
														<td colspan="2">Frps 相关设置</td>
													  </tr>
												  </thead>
												<th style="width:25%;">运行状态</th>
												<td>
													<div id="frps_status"><i><span id="status">获取中...</span></i></div>
												</td>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(1)">Dashboard port</a></th>
													<td>
														<input type="text" class="input_ss_table" value="" id="frps_common_dashboard_port" name="frps_common_dashboard_port" maxlength="5" value="" placeholder=""/>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(11)">Dashboard User</a></th>
													<td>
												<input type="text" class="input_ss_table" id="frps_common_dashboard_user" name="frps_common_dashboard_user" maxlength="50" value="" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(3)">Dashboard Pass</a></th>
													<td>
														<input type="password" name="frps_common_dashboard_pwd" id="frps_common_dashboard_pwd" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="256" value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);"/>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(2)">Bind port</a></th>
													<td>
												<input type="text" class="input_ss_table" id="frps_common_bind_port" name="frps_common_bind_port" maxlength="5" value="" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(3)">Privilege Token</a></th>
													<td>
														<input type="password" name="frps_common_privilege_token" id="frps_common_privilege_token" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="256" value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);"/>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(4)">vhost http port</a></th>
													<td>
														<input type="text" class="input_ss_table" id="frps_common_vhost_http_port" name="frps_common_vhost_http_port" maxlength="6" value="" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(5)">vhost https port</a></th>
													<td>
														<input type="text" class="input_ss_table" id="frps_common_vhost_https_port" name="frps_common_vhost_https_port" maxlength="6" value="" />
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(13)">TCP 多路复用</a></th>
													<td>
														<select id="frps_common_tcp_mux" name="frps_common_tcp_mux" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
															<option value="true">开启</option>
															<option value="false">关闭</option>
														</select>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(6)">日志记录</a></th>
													<td>
														<select id="frps_common_log_file" name="frps_common_log_file" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
															<option value="/tmp/frps.log">开启</option>
															<option value="/dev/null">关闭</option>
														</select>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(7)">日志等级</a></th>
													<td>
														<select id="frps_common_log_level" name="frps_common_log_level" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
															<option value="info">info</option>
															<option value="warn">warn</option>
															<option value="error">error</option>
															<option value="debug">debug</option>
														</select>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(8)">日志记录天数</a></th>
													<td>
														<select id="frps_common_log_max_days" name="frps_common_log_max_days" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
															<option value="1">1</option>
															<option value="2">2</option>
															<option value="3" selected="selected">3</option>
															<option value="4">4</option>
															<option value="5">6</option>
															<option value="6">6</option>
															<option value="7">7</option>
															<option value="30">30</option>
														</select>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(9)">max pool count</a></th>
													<td>
														<select id="frps_common_max_pool_count" name="frps_common_max_pool_count" style="width:60px;margin:3px 2px 0px 2px;" class="input_option">
															<option value="10">10</option>
															<option value="20">20</option>
															<option value="30">30</option>
															<option value="40">40</option>
															<option value="50" selected="selected">50</option>
															<option value="60">60</option>
															<option value="70">70</option>
															<option value="80">80</option>
															<option value="90">90</option>
															<option value="100">100</option>
															<option value="150">150</option>
															<option value="200">200</option>
														</select>
													</td>
												</tr>
												<tr>
													<th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(10)">定时注册服务</a>(<i>0为关闭</i>)</th>
													<td>
														每
														<input type="text" id="frps_common_cron_time" name="frps_common_cron_time" class="input_ss_table" style="width:30px" value="30" placeholder="" />
														<select id="frps_common_cron_hour_min" name="frps_common_cron_hour_min" style="width:60px;vertical-align: middle;" class="input_option">
															<option value="min" selected="selected">分钟</option>
															<option value="hour">小时</option>
														</select>
														重新注册一次服务
													</td>
												</tr>
											</table>
										</div>
										<div class="apply_gen">
											<input class="button_gen" id="cmdBtn" onClick="save()" type="button" value="提交" />
										</div>
										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote">
											<span>* 注意事项：</span>
											<li>1. 使用frps前确保你的路由器可以获得公网ip</li>
											<li>2. 为了frps稳定运行，强烈建议使用虚拟内存</li>
											<li>3. 上面所有内容都为必填项，请认真填写，不然无法提供穿透服务。</li>
											<li>4. 每一个文字都可以点击查看相应的帮助信息。</li>
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<div id="footer"></div>
</body>
</html>