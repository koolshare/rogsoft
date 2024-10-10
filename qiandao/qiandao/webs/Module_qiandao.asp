<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!-- version: 1.8 -->
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>自动签到</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/> 
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<style> 
.test-textarea {
	width: 585px;
	min-height: 26px;
	line-height: 20px;
	_height: 30px;
	/* max-height: 150px;*/
	margin-left: auto;
	margin-right: auto;
	padding: 3px;
	outline: 0;
	border: 1px solid gray;
	font-size: 10px;
	font-family: 'Lucida Console';
	line-height: 1.2;
	word-wrap: break-word;
	overflow-x: hidden;
	overflow-y: auto;
	-webkit-user-modify: read-write-plaintext-only;
	border-radius: 1px;
}
input[type=button]:focus {
	outline: none;
}

.show-btn1, .show-btn2 {
	border-radius: 5px 5px 0px 0px;
	font-size:10pt;
	color: #fff;
	padding: 10px 3.75px;
	width:8.45601%;
	border: 1px solid #222;
	background: linear-gradient(to bottom, #919fa4 0%, #67767d 100%);
	border: 1px solid #91071f; /* W3C rogcss*/
	background: none; /* W3C rogcss*/
}
.active {
	background: linear-gradient(to bottom, #61b5de 0%, #279fd9 100%);
	border: 1px solid #222;
	background: linear-gradient(to bottom, #cf0a2c 0%, #91071f 100%); /* W3C rogcss*/
	border: 1px solid #91071f; /* W3C rogcss*/
}
#log_content1 {
	width:97%;
	padding-left:4px;
	padding-right:37px;
	font-family:'Lucida Console';
	font-size:11px;
	color:#FFFFFF;
	outline:none;
	overflow-x:hidden;
	border:0px solid #222;
	background:#475A5F;
	border:1px solid #91071f; /* W3C rogcss*/
	background:transparent; /* W3C rogcss*/
}
#qiandao_setting, #qiandao_log{
	margin: -1px 0px 0px 0px;
	border: 1px solid #91071f; /* W3C rogcss*/
}
</style>
<script>
var db_qiandao = {}
var _responseLen;
var noChange = 0;
var params_input = ["qiandao_time"];
var params_check = ["qiandao_enable"];
var params_sites = ["koolshare", "baidu", "v2ex", "hostloc", "acfun", "bilibili", "smzdm", "xiami", "163music", "miui", "52pojie", "kafan", "right", "mydigit"];

function init() {
	show_menu(menu_hook);
	get_dbus_data();
	generate_time_options();
	update_visibility();
	tab_switch();
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/qiandao",
		dataType: "json",
		async: false,
		success: function(data) {
			db_qiandao = data.result[0];
			conf_to_obj();
		}
	});
}

function generate_time_options() {
	for (var i = 0; i < 24; i++) {
		$("#qiandao_time").append("<option value='" + i + "'>" + i + "点</option>");
		$("#qiandao_time").val(8);
	}
}

function tab_switch(){
	if($('.show-btn1').hasClass("active")){
		E("qiandao_setting").style.display = "";
		E("qiandao_log").style.display = "none";
	}else if($('.show-btn2').hasClass("active")){
		E("qiandao_setting").style.display = "none";
		E("qiandao_log").style.display = "";
	}else{
		$('.show-btn1').addClass('active');
		$('.show-btn2').removeClass('active');
		E("qiandao_setting").style.display = "";
		E("qiandao_log").style.display = "none";
	}
	$(".show-btn1").click(
	function() {
		$('.show-btn1').addClass('active');
		$('.show-btn2').removeClass('active');
		E("qiandao_setting").style.display = "";
		E("qiandao_log").style.display = "none";
	});
	$(".show-btn2").click(
	function() {
		setTimeout("get_realtime_log();", 200);
		$('.show-btn1').removeClass('active');
		$('.show-btn2').addClass('active');
		E("qiandao_setting").style.display = "none";
		E("qiandao_log").style.display = "";
	});
}

function update_visibility(r) {
	var params_sites = ["koolshare", "baidu", "v2ex", "hostloc", "acfun", "bilibili", "smzdm", "xiami", "163music", "miui", "52pojie", "kafan", "right", "mydigit"];
	for (var i = 0; i < params_sites.length; i++) {
		if(E("qiandao_" + params_sites[i]).checked){
			E("_qiandao_" + params_sites[i]).style.display = ""
		}else{
			E("_qiandao_" + params_sites[i]).style.display = "none"
		}
	}
}

function conf_to_obj() {
	// data to input/select
	for (var i = 0; i < params_input.length; i++) {
		if(db_qiandao[params_input[i]]){
			E(params_input[i]).value = db_qiandao[params_input[i]];
		}
	}
	// data to div （base64 decode）
	for (var i = 0; i < params_sites.length; i++) {
		if(db_qiandao["qiandao_" + params_sites[i] + "_setting"]){
			$("#qiandao_" + params_sites[i] + "_setting").text(Base64.decode(db_qiandao["qiandao_" + params_sites[i] + "_setting"]));
		}
	}
	// data to checkbox
	for (var i = 0; i < params_check.length; i++) {
		if(db_qiandao[params_check[i]]){
			E(params_check[i]).checked = db_qiandao[params_check[i]] == "1";
		}
	}
	for (var i = 0; i < params_sites.length; i++) {
		if(db_qiandao["qiandao_" + params_sites[i]]){
			E("qiandao_" + params_sites[i]).checked = db_qiandao["qiandao_" + params_sites[i]] == "1";
		}
	}
}

function save(action){
	db_qiandao["qiandao_action"] = action;
	// data from input/select
	for (var i = 0; i < params_input.length; i++) {
		if(E(params_input[i])){
			db_qiandao[params_input[i]] = E(params_input[i]).value
		}
	}
	// data from div （base64 encode）
	for (var i = 0; i < params_sites.length; i++) {
		if($("#qiandao_" + params_sites[i] + "_setting").text()){
			db_qiandao["qiandao_" + params_sites[i] + "_setting"] = Base64.encode($("#qiandao_" + params_sites[i] + "_setting").text());
		}else{
			db_qiandao["qiandao_" + params_sites[i] + "_setting"] = "";
		}
	}
	// data from checkbox
	for (var i = 0; i < params_check.length; i++) {
		db_qiandao[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
	}
	for (var i = 0; i < params_sites.length; i++) {
		db_qiandao["qiandao_" + params_sites[i]] = E("qiandao_" + params_sites[i]).checked ? '1' : '0';
	}
	push_data(db_qiandao, 1);
}

function push_data(obj, arg) {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "qiandao_config.sh", "params": [arg], "fields": obj };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == id){
				$('.show-btn1').removeClass('active');
				$('.show-btn2').addClass('active');
				E("qiandao_setting").style.display = "none";
				E("qiandao_log").style.display = "";
				noChange = 0;
				get_realtime_log(1);
			}
		}
	});
}

function get_realtime_log(refresh) {
	$.ajax({
		url: '/_temp/qiandao_log.txt',
		type: 'GET',
		async: true,
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content1");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", " ");
				retArea.scrollTop = retArea.scrollHeight;
				if(refresh == "1"){
					refreshpage(2);
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
				setTimeout("get_realtime_log(1);", 500);
			}
			retArea.value = response.replace("XU6J03M6", " ");
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		}
	});
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "自动签到");
	tablink[tablink.length - 1] = new Array("", "Module_qiandao.asp");
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
											<div class="formfonttitle">软件中心 - 自动签到</div>
											<div style="float:right; width:15px; height:25px;margin-top:-20px">
												<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
											</div>
											<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
											<div class="SimpleNote">
												<li>本插件实现帮你实现自动签到，<a href="http://koolshare.cn/thread-127783-1-1.html"><em><u>签到程序</u></em></a>来自Carseason。<a type="button" style="cursor:pointer" href="https://github.com/sadoneli/merlin380-qiandao/blob/master/Changelog.txt" target="_blank"><em>【<u>插件更新日志</u>】</em></a>
											</div>
											<div id="tablets">
												<table style="margin:10px 0px 0px 0px;border-collapse:collapse" width="100%" height="37px">
													<tr width="235px">
														<td colspan="4" cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#000">
															<input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="签到设置" />
															<input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="日志信息" />
														</td>
													</tr>
												</table>
											</div>
											<div id="qiandao_setting">
												<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
													<tr id="switch_tr">
														<th style="width:18%">
															<label>开关</label>
														</th>
														<td colspan="2">
															<div class="switch_field" style="display:table-cell;float: left;">
																<label for="qiandao_enable">
																	<input id="qiandao_enable" class="switch" type="checkbox" style="display: none;">
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
													<tr>
														<th style="width:18%">自动签到时间</th>
														<td>
															<select name="qiandao_time" id="qiandao_time" class="input_option" onchange="update_visibility();">
															</select>
														</td>
													</tr>
													<tr>
														<th style="width:18%">需要签到的网站</th>
														<td>
															<input type="checkbox" id="qiandao_koolshare" name="qiandao_koolshare" onclick="update_visibility();">koolshare
															<input type="checkbox" id="qiandao_baidu" name="qiandao_baidu" onclick="update_visibility();">baidu
															<input type="checkbox" id="qiandao_v2ex" name="qiandao_v2ex" onclick="update_visibility();">v2ex
															<input type="checkbox" id="qiandao_hostloc" name="qiandao_hostloc" onclick="update_visibility();">hostloc
															<input type="checkbox" id="qiandao_acfun" name="qiandao_acfun" onclick="update_visibility();">acfun
															<input type="checkbox" id="qiandao_bilibili" name="qiandao_bilibili" onclick="update_visibility();">bilibili
															<input type="checkbox" id="qiandao_smzdm" name="qiandao_smzdm" onclick="update_visibility();">smzdm
															<input type="checkbox" id="qiandao_xiami" name="qiandao_xiami" onclick="update_visibility();">xiami
															<input type="checkbox" id="qiandao_163music" name="qiandao_163music" onclick="update_visibility();">163music
															<input type="checkbox" id="qiandao_miui" name="qiandao_miui" onclick="update_visibility();">miui
															<input type="checkbox" id="qiandao_52pojie" name="qiandao_52pojie" onclick="update_visibility();">52pojie
															<input type="checkbox" id="qiandao_kafan" name="qiandao_kafan" onclick="update_visibility();">kafan
															<input type="checkbox" id="qiandao_right" name="qiandao_right" onclick="update_visibility();">right
															<input type="checkbox" id="qiandao_mydigit" name="qiandao_mydigit" onclick="update_visibility();">mydigit
														</td>
													</tr>
													<tr id="_qiandao_koolshare" style="display:none">
														<th style="width:18%"><b>koolshare cookie</b></th>
														<td>
															<div class="test-textarea" id="qiandao_koolshare_setting" windth="400px" contenteditable="true" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"><br /></div>
														</td>
													</tr>
													<tr id="_qiandao_baidu" style="display:none">
														<th style="width:18%"><b>baidu cookie</b></th>
														<td>
															<div class="test-textarea" id="qiandao_baidu_setting" windth="400px" contenteditable="true" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"><br /></div>
														</td>
													</tr>
													<tr id="_qiandao_v2ex" style="display:none">
														<th style="width:18%"><b>v2ex cookie</b></th>
														<td>
															<div class="test-textarea" id="qiandao_v2ex_setting" windth="400px" contenteditable="true" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"><br /></div>
														</td>
													</tr>
													<tr id="_qiandao_hostloc" style="display:none">
														<th style="width:18%"><b>hostloc cookie</b></th>
														<td>
															<div class="test-textarea" id="qiandao_hostloc_setting" windth="400px" contenteditable="true" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"><br /></div>
														</td>
													</tr>
													<tr id="_qiandao_acfun" style="display:none">
														<th style="width:18%"><b>acfun cookie</b></th>
														<td>
															<div class="test-textarea" id="qiandao_acfun_setting" windth="400px" contenteditable="true" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"><br /></div>
														</td>
													</tr>
													<tr id="_qiandao_bilibili" style="display:none">
														<th style="width:18%"><b>bilibili cookie</b></th>
														<td>
															<div class="test-textarea" id="qiandao_bilibili_setting" windth="400px" contenteditable="true" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"><br /></div>
														</td>
													</tr>
													<tr id="_qiandao_smzdm" style="display:none">
														<th style="width:18%"><b>smzdm cookie</b></th>
														<td>
															<div class="test-textarea" id="qiandao_smzdm_setting" windth="400px" contenteditable="true" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"><br /></div>
														</td>
													</tr>
													<tr id="_qiandao_xiami" style="display:none">
														<th style="width:18%"><b>xiami cookie</b></th>
														<td>
															<div class="test-textarea" id="qiandao_xiami_setting" windth="400px" contenteditable="true" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"><br /></div>
														</td>
													</tr>
													<tr id="_qiandao_163music" style="display:none">
														<th style="width:18%"><b>163music cookie</b></th>
														<td>
															<div class="test-textarea" id="qiandao_163music_setting" windth="400px" contenteditable="true" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"><br /></div>
														</td>
													</tr>
													<tr id="_qiandao_miui" style="display:none">
														<th style="width:18%"><b>miui cookie</b></th>
														<td>
															<div class="test-textarea" id="qiandao_miui_setting" windth="400px" contenteditable="true" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"><br /></div>
														</td>
													</tr>
													<tr id="_qiandao_52pojie" style="display:none">
														<th style="width:18%"><b>52pojie cookie</b></th>
														<td>
															<div class="test-textarea" id="qiandao_52pojie_setting" windth="400px" contenteditable="true" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"><br /></div>
														</td>
													</tr>
													<tr id="_qiandao_kafan" style="display:none">
														<th style="width:18%"><b>kafan cookie</b></th>
														<td>
															<div class="test-textarea" id="qiandao_kafan_setting" windth="400px" contenteditable="true" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"><br /></div>
														</td>
													</tr>
													<tr id="_qiandao_right" style="display:none">
														<th style="width:18%"><b>right cookie</b></th>
														<td>
															<div class="test-textarea" id="qiandao_right_setting" windth="400px" contenteditable="true" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"><br /></div>
														</td>
													</tr>
													<tr id="_qiandao_mydigit" style="display:none">
														<th style="width:18%" title="数码之家需要填入帐号和密码,用英文逗号分隔,如zhangsan,123456"><b>mydigit (?)</b> <br/></th>
														<td>
															<div class="test-textarea" id="qiandao_mydigit_setting" windth="400px" contenteditable="true" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"><br /></div>
														</td>
													</tr>
												</table>
											</div>
											<div id="qiandao_log">
												<div id="log_content" style="margin-top:-1px;display:block;overflow:hidden;outline: 1px solid #222;">
													<textarea cols="63" rows="36" wrap="on" readonly="readonly" id="log_content1" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
												</div>
											</div>												
											<div id="warning" style="font-size:14px;margin:20px auto;"></div>
											<div class="apply_gen">
												<input class="button_gen" id="cmdBtn" onClick="save(1);" type="button" value="仅保存设置" />
												<input class="button_gen" id="cmdBtn" onClick="save(2);" type="button" value="保存并立即签到" />
											</div>
											<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
											<div class="SimpleNote">
												<li>请勿泄露你的cookie和账号密码等信息！</li>
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
