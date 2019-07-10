<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心-SS-SERVER</title>
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
<script>
var db_ssserver = {}
function init() {
	show_menu(menu_hook);
	get_dbus_data();
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/ssserver",
		dataType: "json",
		async: false,
		success: function(data) {
			db_ssserver = data.result[0];
			E("ssserver_enable").checked = db_ssserver["ssserver_enable"] == "1";
			var params = ["method", "password", "port", "udp", "time", "use_ss", "obfs"];
			for (var i = 0; i < params.length; i++) {
				if (db_ssserver["ssserver_" + params[i]]) {
					//$("#ssserver_" + params[i]).val(db_ssserver["ssserver_" + params[i]]);
					E("ssserver_" + params[i]).value = db_ssserver["ssserver_" + params[i]];
				}
			}
		}
	});
}

function save() {
	showLoading(2);
	//refreshpage(2);
	// collect data from checkbox
	db_ssserver["ssserver_enable"] = E("ssserver_enable").checked ? '1' : '0';
	var params = ["method", "password", "port", "udp", "time", "use_ss", "obfs"];
	for (var i = 0; i < params.length; i++) {
    	db_ssserver["ssserver_" + params[i]] = E("ssserver_" + params[i]).value;
	}
	// post data
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "ssserver_config.sh", "params": [1], "fields": db_ssserver };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData)
	});
}

function menu_hook() {
	tabtitle[tabtitle.length - 1] = new Array("", "ssserver");
	tablink[tablink.length - 1] = new Array("", "Module_ssserver.asp");
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
	<form method="POST" name="form" action="/applydb.cgi?p=ssserver_" target="hidden_frame">
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
				<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
					<tr>
						<td align="left" valign="top">
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div style="float:left;" class="formfonttitle">SS-SERVER</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div class="formfontdesc" id="cmdDesc">开启ss-server后，就可以类似VPN一样，将你的网络共享到公网，让你和你的小伙伴远程连接。</div>										
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
											<tr>
												<td colspan="2">ss-server开关</td>
											</tr>
											</thead>
											<tr>
											<th>开启ss-server</th>
												<td colspan="2">
													<div class="switch_field" style="display:table-cell;float: left;">
														<label for="ssserver_enable">
															<input id="ssserver_enable" class="switch" type="checkbox" style="display: none;">
															<div class="switch_container" >
																<div class="switch_bar"></div>
																<div class="switch_circle transition_style">
																	<div></div>
																</div>
															</div>
														</label>
													</div>
													<div style="display:table-cell;float: left;position: absolute;margin-left:70px;padding: 5.5px 0px;">
														<span style="float: left;">二进制版本: 3.1.1</span>
													</div>
													
												</td>
											</tr>
                                    	</table>                                    	
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="ssserver_detail">
											<thead>
											<tr>
												<td colspan="2">ss-server详细设置</td>
											</tr>
											</thead>
											<tr>
												<th>加密方式</th>
												<td>
													<div>
														<select id="ssserver_method" name="ssserver_method" style="width:164px;margin:0px 0px 0px 2px;" class="input_option" >
                                                        <option class="content_input_fd" value="rc4-md5">rc4-md5</option>
                                                        <option class="content_input_fd" value="aes-128-gcm">aes-128-gcm</option>
                                                        <option class="content_input_fd" value="aes-192-gcm">aes-192-gcm</option>
                                                        <option class="content_input_fd" value="aes-256-gcm">aes-256-gcm</option>
                                                        <option class="content_input_fd" value="aes-128-cfb">aes-128-cfb</option>
                                                        <option class="content_input_fd" value="aes-192-cfb">aes-192-cfb</option>
                                                        <option class="content_input_fd" value="aes-256-cfb">aes-256-cfb</option>
                                                        <option class="content_input_fd" value="aes-128-ctr">aes-128-ctr</option>
                                                        <option class="content_input_fd" value="aes-192-ctr">aes-192-ctr</option>
                                                        <option class="content_input_fd" value="aes-256-ctr">aes-256-ctr</option>
                                                        <option class="content_input_fd" value="camellia-128-cfb">camellia-128-cfb</option>
                                                        <option class="content_input_fd" value="camellia-192-cfb">camellia-192-cfb</option>
                                                        <option class="content_input_fd" value="camellia-256-cfb">camellia-256-cfb</option>
                                                        <option class="content_input_fd" value="bf-cfb">bf-cfb</option>
                                                        <option class="content_input_fd" value="chacha20-ietf-poly1305">chacha20-ietf-poly1305</option>
                                                        <option class="content_input_fd" value="xchacha20-ietf-poly1305">xchacha20-ietf-poly1305</option>
                                                        <option class="content_input_fd" value="salsa20">salsa20</option>
                                                        <option class="content_input_fd" value="chacha20">chacha20</option>
                                                        <option class="content_input_fd" value="chacha20-ietf">chacha20-ietf</option>
														</select>
													</div>
												</td>
											</tr>
											<tr>
												<th>密码</th>
												<td>
													<input type="password" name="ssserver_password" id="ssserver_password" class="input_ss_table" maxlength="100" value="" readonly onBlur="switchType(this, false);" onFocus="switchType(this, true);this.removeAttribute('readonly');"/>
												</td>
											</tr>
											<tr>
												<th>端口</th>
												<td>
													<div>
														<input type="txt" name="ssserver_port" id="ssserver_port" class="input_ss_table" maxlength="100" value=""/>
													</div>
												</td>
											</tr>
											<tr>
												<th>超时时间（秒）</th>
												<td>
													<div>
														<input type="txt" name="ssserver_time" id="ssserver_time" class="input_ss_table" maxlength="100" value="600"/>
													</div>
												</td>
											</tr>
											<tr>
												<th>UDP转发</th>
												<td>
													<select style="width:164px;margin-left: 2px;" class="input_option" id="ssserver_udp" name="ssserver_udp">
														<option value="0" selected>关闭</option>
														<option value="1">开启</option>
													</select>
												</td>
											</tr>
											<tr>
												<th>混淆（obfs）</th>
												<td>
													<select style="width:164px;margin-left: 2px;" class="input_option" id="ssserver_obfs" name="ssserver_obfs">
														<option value="0" selected>关闭</option>
														<option value="http">http</option>
														<option value="tls">tls</option>
													</select>
												</td>
											</tr>
											<tr>
												<th>使用ss网络</th>
												<td>
													<select style="width:164px;margin-left: 2px;" class="input_option" id="ssserver_use_ss" name="ssserver_use_ss">
														<option value="0" selected>关闭</option>
														<option value="1">开启</option>
													</select>
													<br/>
													<span>开启后，连接到ss-server的客户端，将能够访问ss网络，但是ss插件的访问控制会失效。</span>
													<br/>
													<span>此功能要求软件中心的SS插件开启，如果没有开启，此功能将不会有效果。</span>
												</td>
											</tr>
										</table>
 										<div id="warn" style="display: none;margin-top: 20px;text-align: center;font-size: 20px;margin-bottom: 20px;" class="formfontdesc" id="cmdDesc"><i>开启双线路负载均衡模式才能进行本页面设置，建议负载均衡设置比例1：1</i></div>
										<div class="apply_gen">
											<button id="cmdBtn" class="button_gen" onclick="save()">提交</button>
										</div>
										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
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
	</form>
	<div id="footer"></div>
</body>
</html>

