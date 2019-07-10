<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - DDnspod设置</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
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
<script type="text/javascript">
var db_ddnspod_ = {};
var params_input = ["ddnspod_config_id", "ddnspod_config_token", "ddnspod_config_domain", "ddnspod_refresh_time"];
var params_check = ["ddnspod_enable"];

function init() {
	show_menu(menu_hook);
	get_dbus_data();
	buildswitch();
	update_visibility();
	get_status();
	setInterval("get_status();", 5000);
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/ddnspod_",
		dataType: "json",
		async: false,
		success: function(data) {
			db_ddnspod_ = data.result[0];
			conf2obj();
		}
	});
}

function conf2obj() {
	for (var i = 0; i < params_input.length; i++) {
		if(db_ddnspod_[params_input[i]]){
			E(params_input[i]).value = db_ddnspod_[params_input[i]];
		}
	}
	for (var i = 0; i < params_check.length; i++) {
		if(db_ddnspod_[params_check[i]]){
			E(params_check[i]).checked = db_ddnspod_[params_check[i]] == "1";
		}
	}
}

function save(){
	for (var i = 0; i < params_input.length; i++) {
		if(E(params_input[i])){
			db_ddnspod_[params_input[i]] = E(params_input[i]).value
		}
	}
	for (var i = 0; i < params_check.length; i++) {
		db_ddnspod_[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
	}
	showLoading();
	push_data(db_ddnspod_, 1);
}

function push_data(obj, arg) {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "ddnspod_config.sh", "params": [arg], "fields": obj };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == id){
				refreshpage();
			}
		}
	});
}

function get_status(){
	$.ajax({
		type: "GET",
		url: "/_api/ddnspod_run_status",
		dataType: "json",
		async: false,
		success: function(data) {
			ddstatus = data.result[0];
			$("#ddnspod_run_state").html(ddstatus["ddnspod_run_status"]);
		}
	});
}

function buildswitch() {
	$("#ddnspod_enable").click(
	function() {
		if (E('ddnspod_enable').checked) {
			E('ddnspod_detail_table').style.display = "";
			E('status_tr').style.display = "";
		} else {
			E('ddnspod_detail_table').style.display = "none";
			E('status_tr').style.display = "none";
		}
	});
}

function update_visibility(){
	var rrt = E("ddnspod_enable");
	if (db_ddnspod_["ddnspod_enable"] != "1") {
		rrt.checked = false;
		E('ddnspod_detail_table').style.display = "none";
		E('status_tr').style.display = "none";
	} else {
		rrt.checked = true;
		E('ddnspod_detail_table').style.display = "";
		E('status_tr').style.display = "";
	}
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "ddnspod");
	tablink[tablink.length - 1] = new Array("", "Module_ddnspod.asp");
}

</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
		<input type="hidden" name="current_page" value="Module_ddnspod.asp" />
		<input type="hidden" name="next_page" value="Module_ddnspod.asp" />
		<input type="hidden" name="group_id" value="" />
		<input type="hidden" name="modified" value="0" />
		<input type="hidden" name="action_mode" value="" />
		<input type="hidden" name="action_script" value="" />
		<input type="hidden" name="action_wait" value="5" />
		<input type="hidden" name="first_time" value="" />
		<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get(" preferred_lang "); %>"/>
		<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="ddnspod_config.sh" />
		<input type="hidden" name="firmver" value="<% nvram_get(" firmver "); %>"/>
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
											<div style="float:left;" class="formfonttitle">DDnspod</div>
											<div style="float:right; width:15px; height:25px;margin-top:10px">
												<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
											</div>
											<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
											<div class="formfontdesc" style="padding-top:5px;margin-top:0px;float: left;" id="cmdDesc">
												<div>使用dnspod实现的ddns服务</div>
												<ul style="padding-top:5px;margin-top:10px;float: left;">
													<li>使用前需要将域名添加到dnspod中，并添加一条A记录，使用之后将自动更新ip</li>
													<li>点 <a href="https://support.dnspod.cn/Kb/showarticle/tsid/227"><i><u>这里</u></i></a> 查看官方说明以及如何获取dnspod Token</li>
												</ul>
											</div>
											<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="routing_table">
												<thead>
													<tr>
														<td colspan="2">开关设置</td>
													</tr>
												</thead>
												<tr>
													<th>开启DDnspod</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="ddnspod_enable">
																<input id="ddnspod_enable" class="switch" type="checkbox" style="display: none;">
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
												<tr id="status_tr">
													<th width="35%">状态</th>
													<td>
														<a>	<span id="ddnspod_run_state"></span>
														</a>
													</td>
												</tr>												
											</table>
											<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="ddnspod_detail_table">

												<thead>
													<tr>
														<td colspan="2">基本设置</td>
													</tr>
												</thead>
												<tr>
													<th width="35%">dnspod ID</th>
													<td>
														<input type="text" class="input_ss_table" size="30" style="width:60px;" id="ddnspod_config_id" name="ddnspod_config_id" maxlength="50" placeholder="ID" value="">
													</td>
												</tr>
												<tr>
													<th width="35%">dnspod Token</th>
													<td>
														<input type="text" class="input_ss_table" size="30" style="width:260px;" id="ddnspod_config_token" name="ddnspod_config_token" maxlength="50" placeholder="Token" value="">
													</td>
												</tr>
												<tr>
													<th width="35%">域名</th>
													<td>
														<input type="text" class="input_ss_table" size="30" style="width:180px;" id="ddnspod_config_domain" name="ddnspod_config_domain" maxlength="40" placeholder="填写完整域名" value="">
													</td>
												</tr>
												<tr>
													<th width="35%">刷新时间</th>
													<td>
														<select id="ddnspod_refresh_time" name="ddnspod_refresh_time" class="input_option">
															<option value="1">1H</option>
															<option value="5">5H</option>
															<option value="10">10H</option>
														</select>
													</td>
												</tr>
											</table>
											<div class="apply_gen">
												<input class="button_gen" id="cmdBtn" onClick="save();" type="button" value="提交" />
											</div>
											<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
											<div class="KoolshareBottom">
												论坛技术支持：<a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i></a>
												<br/>后台技术支持：<i>Xiaobao</i> 
												<br/>Shell, Web by：<i>freexiaoyao & sadog</i>
											</div>
										</td>
									</tr>
								</table>
							</td>
							<td width="10" align="center" valign="top"></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	<div id="footer"></div>
</body>
</html>
