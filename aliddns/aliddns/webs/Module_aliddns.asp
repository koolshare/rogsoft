<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>Aliddns</title>
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
<script src="/state.js"></script>
<script src="/help.js"></script>
<script>
var dbus = {}
function init() {
	show_menu(menu_hook);
	generate_options();
	get_dbus_data();
	update_visibility();
	hook_event();
	get_run_status();
	setInterval("get_run_status()", 5000);
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/aliddns",
		dataType: "json",
		async: false,
		success: function(data) {
			dbus = data.result[0];
			E("aliddns_enable").checked = dbus["aliddns_enable"] == "1";
			var params = ['ak', 'sk', 'name', 'domain', 'interval', 'dns', 'curl', 'ttl'];
			for (var i = 0; i < params.length; i++) {
				if (dbus["aliddns_" + params[i]]) {
					//$("#aliddns_" + params[i]).val(dbus["aliddns_" + params[i]]);
					E("aliddns_" + params[i]).value = dbus["aliddns_" + params[i]];
				}
			}
		}
	});
}

function get_run_status(){
	$.ajax({
		type: "GET",
		url: "/_api/aliddns_last_act",
		dataType: "json",
		async: false,
		success: function(data) {
			var aliddns_status = data.result[0];
			if (aliddns_status["aliddns_last_act"]) {
				E("run_status").innerHTML = aliddns_status["aliddns_last_act"];
			}
		}
	});
}

function save() {
	showLoading(2);
	refreshpage(2);
	// collect data from checkbox
	dbus["aliddns_enable"] = E("aliddns_enable").checked ? '1' : '0';
	var params = ['ak', 'sk', 'name', 'domain', 'interval', 'dns', 'curl', 'ttl'];
	for (var i = 0; i < params.length; i++) {
    	dbus["aliddns_" + params[i]] = E("aliddns_" + params[i]).value;
	}
	// post data
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "aliddns_config.sh", "params": [1], "fields": dbus };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData)
	});
}

function generate_options(){
	for(var i = 2; i < 60; i++) {
		$("#aliddns_interval").append("<option value='"  + i + "'>" + i + "</option>");
		$("#aliddns_interval").val(2);
	}
}

function hook_event(){
	$("#aliddns_enable").click(
		function(){
		if(E('aliddns_enable').checked){
			dbus["aliddns_enable"] = "1";
			E("last_act_tr").style.display = "";
			E("ak_tr").style.display = "";
			E("sk_tr").style.display = "";
			E("interval_tr").style.display = "";
			E("name_tr").style.display = "";
			E("dns_tr").style.display = "";
			E("curl_tr").style.display = "";
			E("ttl_tr").style.display = "";
		}else{
			dbus["aliddns_enable"] = "0";
			E("last_act_tr").style.display = "none";
			E("ak_tr").style.display = "none";
			E("sk_tr").style.display = "none";
			E("interval_tr").style.display = "none";
			E("name_tr").style.display = "none";
			E("dns_tr").style.display = "none";
			E("curl_tr").style.display = "none";
			E("ttl_tr").style.display = "none";
		}
	});
}

function update_visibility(){
	if(dbus["aliddns_enable"] == "1"){
		E("last_act_tr").style.display = "";
		E("ak_tr").style.display = "";
		E("sk_tr").style.display = "";
		E("interval_tr").style.display = "";
		E("name_tr").style.display = "";
		E("dns_tr").style.display = "";
		E("curl_tr").style.display = "";
		E("ttl_tr").style.display = "";
	}else{
		E("last_act_tr").style.display = "none";
		E("ak_tr").style.display = "none";
		E("sk_tr").style.display = "none";
		E("interval_tr").style.display = "none";
		E("name_tr").style.display = "none";
		E("dns_tr").style.display = "none";
		E("curl_tr").style.display = "none";
		E("ttl_tr").style.display = "none";
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
                						<div style="float:left;" class="formfonttitle" style="padding-top: 12px">Aliddns - 设置</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote" id="head_illustrate"><i></i><em>Aliddns</em>是一款基于阿里云解析的私人ddns解决方案。<a href='http://koolshare.cn/thread-64703-1-1.html' target='_blank'><i>&nbsp;&nbsp;<u>点击查看插件详情</u></i></a></div>
                						<table style="margin:20px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
											<tr>
												<td colspan="2">Aliddns - 设置面板</td>
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
													<div id="koolproxy_install_show" style="padding-top:5px;margin-left:80px;margin-top:-30px;float: left;"></div>	
												</td>
											</tr>
                						    <tr id="last_act_tr">
                						        <th>上次运行</th>
                						        <td>
                						            <span id="run_status"></span>
                						        </td>
                						    </tr>
                						    <tr id="ak_tr">
                						        <th>Access Key ID</th>
                						        <td>
                						            <input type="text" id="aliddns_ak" value="" class="input_ss_table" style="width:200px;">
                						        </td>
                						    </tr>
                						    <tr id="sk_tr">
                						        <th>Access Key Secret</th>
                						        <td><input type="password" id="aliddns_sk" value="" class="input_ss_table" style="width:260px;" autocomplete="off" autocorrect="off" autocapitalize="off" maxlength="100" readonly onBlur="switchType(this, false);" onFocus="switchType(this, true);this.removeAttribute('readonly');"/></td>
                						    </tr>
                						    <tr id="interval_tr">
                						        <th>检查周期</th>
                						        <td>
                						        	<select id="aliddns_interval" name="aliddns_interval" class="ssconfig input_option" ></select> min
                						        </td>
                						    </tr>
                						    <tr id="name_tr">
                						        <th>域名</th>
                						        <td>
                						            <input type="text" style="width: 4em" id="aliddns_name" placeholder="子域名" value="router" class="input_ss_table">.
                						            <input type="text"  id="aliddns_domain" placeholder="主域名" value="example.com" class="input_ss_table">
                						        </td>
                						    </tr>
                						    <tr id="dns_tr">
                						        <th title="查询域名当前IP时使用的DNS解析服务器，默认为阿里云DNS">DNS服务器(?)</th>
                						        <td><input id="aliddns_dns" class="input_ss_table" value="223.5.5.5"></td>
                						    </tr>
                						    <tr id="curl_tr">
                						        <th title="可自行修改命令行，以获得正确的公网IP。如添加 '--interface vlan2' 以指定多播情况下的端口支持">获得IP命令(?)</th>
                						        <td><textarea id="aliddns_curl" class="input_ss_table" style="width: 94%; height: 2.4em">curl -s --interface ppp0 whatismyip.akamai.com</textarea></td>
                						    </tr>
                						    <tr id="ttl_tr">
                						        <th title="设置解析TTL，默认10分钟，免费版的范围是600-86400">TTL(?)</th>
                						        <td><input id="aliddns_ttl" style="width: 4.5em" class="input_ss_table" value="600">s (1~86400)</td>
                						    </tr>
                						</table>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div class="apply_gen">
											<button id="cmdBtn" class="button_gen" onclick="save()">提交</button>
										</div>
										<div class="KoolshareBottom" style="margin-top:540px;">
											论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a> <br/>
											Github项目： <a href="https://github.com/koolshare/koolshare.github.io/tree/acelan_softcenter_ui" target="_blank"> <i><u>github.com/koolshare</u></i> </a> <br/>
											Shell by： <i>kyrios</i> , Web by： <i>kyrios</i>
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

