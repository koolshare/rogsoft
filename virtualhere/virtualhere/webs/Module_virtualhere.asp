<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache" />
<meta HTTP-EQUIV="Expires" CONTENT="-1" />
<link rel="shortcut icon" href="images/favicon.png" />
<link rel="icon" href="images/favicon.png" />
<title>软件中心 - 系统工具</title>
<link rel="stylesheet" type="text/css" href="index_style.css" />
<link rel="stylesheet" type="text/css" href="form_style.css" />
<link rel="stylesheet" type="text/css" href="usp_style.css" />
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
<script>
var db_virtualhere = {}

function init() {
	show_menu(menu_hook);
	get_dbus_data();
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/virtualhere",
		dataType: "json",
		async: false,
		success: function(data) {
			db_virtualhere = data.result[0];
			E("virtualhere_enable").checked = db_virtualhere["virtualhere_enable"] == "1";
			if(db_virtualhere["virtualhere_wan_port"]){
				E("virtualhere_wan_port").value = db_virtualhere["virtualhere_wan_port"];
			}
		}
	});
}

function save() {
	showLoading(3);
	refreshpage(3);
	// collect data from checkbox
	db_virtualhere["virtualhere_enable"] = E("virtualhere_enable").checked ? '1' : '0';
	db_virtualhere["virtualhere_wan_port"] = E("virtualhere_wan_port").value;
	// post data
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "virtualhere.sh", "params": [1], "fields": db_virtualhere };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData)
	});
}

function reload_Soft_Center(){
	location.href = "/Module_Softcenter.asp";
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", "VirtualHere");
	tablink[tablink.length -1] = new Array("", "Module_virtualhere.asp");
}
</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
		<input type="hidden" name="current_page" value="Module_virtualhere.asp" />
		<input type="hidden" name="next_page" value="Module_virtualhere.asp" />
		<input type="hidden" name="group_id" value="" />
		<input type="hidden" name="modified" value="0" />
		<input type="hidden" name="action_mode" value="" />
		<input type="hidden" name="action_script" value="" />
		<input type="hidden" name="action_wait" value="5" />
		<input type="hidden" name="first_time" value="" />
		<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get(" preferred_lang "); %>"/>
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
											<div style="float:left;" class="formfonttitle">系统工具 - VirtualHere Linux 服务器</div>
											<div style="float:right; width:15px; height:25px;margin-top:10px">
												<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
											</div>
											<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
											<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="virtualhere_table">
												<thead>
													<tr>
														<td colspan="2">开关</td>
													</tr>
												</thead>
												<tr>
													<th>开启USB服务</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="virtualhere_enable">
																<input id="virtualhere_enable" class="switch" type="checkbox" style="display: none;">
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
												<tr id="port_tr">
													<th width="35%">外网开关</th>
													<td>
														<div style="float:left; width:165px; height:25px">
															<select id="virtualhere_wan_port" name="virtualhere_wan_port" style="width:164px;margin:0px 0px 0px 2px;" class="input_option">
																<option value="0">关闭</option>
																<option value="1">开启</option>
															</select>
														</div>
													</td>
												</tr>
											</table>
											<div class="apply_gen">
                                        		<span><input class="button_gen" id="cmdBtn" onclick="save();" type="button" value="提交"/></span>
											</div>
											 <div id="NoteBox">
                                                <h2>支持通过网络远程访问 USB</h2>
                                                <br />鸣谢提供商：
                                                <a href="https://www.virtualhere.com/" target="_blank">
                                                  https://www.virtualhere.com/
                                                </a>
                                                <br />后台技术支持： <i>Jeremy</i>
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
	</td>
	<div id="footer"></div>
</body>
</html>
