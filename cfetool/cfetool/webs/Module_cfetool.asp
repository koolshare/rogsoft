<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - CFE工具箱</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/> 
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<link rel="stylesheet" type="text/css" href="/res/layer/theme/default/layer.css">
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script language="JavaScript" type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<style>
.cfetool_btn {
	border: none;
	background: linear-gradient(to bottom, #003333  0%, #000000 100%);
	font-size:10pt;
	color: #fff;
	padding: 5px 5px;
	border-radius: 5px 5px 5px 5px;
	width:165px;
	margin:  5px 5px 5px 5px;
	cursor:pointer;
	vertical-align: middle;
}
.cfetool_btn:hover {
	border: none;
	background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%);
}
.FormTable th{
	width:16%;
}
.content_status {
	position: absolute;
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	border-radius:10px;
	z-index: 10;
	top: 80px;
	return height:auto;
	box-shadow: 3px 3px 10px #000;
	box-shadow: 3px 3px 10px #000;
	background: #fff;
	margin-left:90px;
	width:580px;
	height:520px;
	display: none;
}
input:focus {
	outline: none;
}
input[type=checkbox]{
	vertical-align:middle;
}
.FormTitle i {
	color: #ff002f;
	font-style: normal;
}
.SimpleNote { padding:5px 10px;}
#log_content{
	margin-top:10px;
	display:block;
	overflow:hidden;
	outline: 1px solid #222;
	outline: 1px solid #91071f; /* rogcss */
}
#log_content_text{
	width:97%;
	padding-top:4px;
	padding-bottom:4px;
	padding-left:4px;
	padding-right:37px;
	font-family:'Lucida Console';
	font-size:11px;
	line-height:1.5;
	color:#FFFFFF;
	outline:none;
	overflow-x:hidden;
	margin-top:1px;
	border:0px solid #222;
	background:#475A5F;
	background:transparent; /* rogcss */
}
</style>
<script>
var params_inp = ['cfetool_key'];
function init() {
	show_menu(menu_hook);
	get_dbus_data();
	get_log();
}
function get_dbus_data(){
	$.ajax({
		type: "GET",
		url: "/_api/cfetool_",
		dataType: "json",
		async: false,
		success: function(data) {
			dbus = data.result[0];
			conf2obj();
		}
	});
}
function conf2obj(){
	for (var i = 0; i < params_inp.length; i++) {
		if (dbus[params_inp[i]]) {
			$("#" + params_inp[i]).val(dbus[params_inp[i]]);
		}
	}
	if (dbus["cfetool_version"]){
		E("cfetool_version").innerHTML = " - " + dbus["cfetool_version"]
	}
	if (dbus["cfetool_mcode"]){
		E("cfetool_main").style.display = "";
		E("cfetool_apply_2").style.display = "";
		E("cfetool_apply_3").style.display = "";
		E("cfetool_info").innerHTML = "订单号：xxx&#10;机器码：" +  dbus["cfetool_mcode"];
		E("cfetool_mail").href = "mailto:mjy211@gmail.com?subject=CFE工具箱插件购买&body=订单号：xxx%0d%0a机器码：" +  dbus["cfetool_mcode"];
		E("message").style.display = "";
		E("spl").style.display = "";
	}
	if (dbus["cfetool_mcode"] && dbus["cfetool_key"]){
		E("cfetool_a_info").innerHTML = "机器码：" +  dbus["cfetool_mcode"] + "&#10;激活码：" + dbus["cfetool_key"];
		E("cfetool_a_mail").href = "mailto:mjy211@gmail.com?subject=CFE工具箱插件购买&body=我的CFE工具箱插件就激活码遗失了，需要找回！%0d%0a机器码：" +  dbus["cfetool_mcode"];
	}
	if(dbus["cfetool_key"]){
		E("cfetool_buy_btn").style.display = "none";
		E("cfetool_active_btn").style.display = "none";
		E("cfetool_authorized_btn").style.display = "";
	}else{
		E("cfetool_buy_btn").style.display = "";
		E("cfetool_active_btn").style.display = "";
		E("cfetool_authorized_btn").style.display = "none";
	}
}
function cfeit(action){
	var dbus_new = {}
	if(action == 2 || action == 3 || action == 4){
		var ct_key = E("cfetool_key").value;
		if(!ct_key){
			alert("请先输入激活码后再点击激活按钮！");
			return false;
		}
		if (ct_key.indexOf('ct_') == -1){
			alert("请输入正确格式的激活码！");
			return false;
		}
	}
	if(action == 2){
		if(dbus["cfetool_warn_0"] != "1"){
			if(!confirm('注意：\n检测到首次使用【CFE工具箱】插件！\n\nCFE工具箱通过修改机器CFE，从而实现非国行机器改为国行！\n修改成功后会自动重启路由器！重启后就达到修改效果！\n\n点确定后，将会继续运行，并且此弹出消息以后也不再显示。')){
				return false;
			}else{
				dbus_new["cfetool_warn_0"] = "1";
			}
		}
	}
	if(action == 3){
		if(dbus["cfetool_warn_1"] != "1"){
			if(!confirm('注意：\n检测到首次使用【恢复原始CFE】按钮！\n\n该功能将CFE完全恢复至首次使用CFE工具箱前(出厂状态)！\n恢复后会自动重启路由器！才能达到效果！\n\n点确定后，将会继续运行该功能，并且此弹出消息以后也不再显示。')){
				return false;
			}else{
				dbus_new["cfetool_warn_1"] = "1";
			}
		}
	}
	if(action == 4){
		for (var i = 0; i < params_inp.length; i++) {
			dbus_new[params_inp[i]] = E(params_inp[i]).value;
		}
	}
	E("cfetool_apply_1").disabled = true;
	E("cfetool_apply_2").disabled = true;
	E("cfetool_apply_3").disabled = true;
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "cfetool_config", "params": [action], "fields": dbus_new};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			E("cfetool_apply_1").disabled = false;
			E("cfetool_apply_2").disabled = false;
			E("cfetool_apply_3").disabled = false;
			get_log(action);
		}
	});
}
function get_log(action){
	$.ajax({
		url: '/_temp/cfetool_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content_text");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", " ");
				if(action){
					refreshpage();
				}else{
					return false;
				}
			}
			if(action){
				setTimeout("get_log(1);", 350);
			}
			retArea.value = response.replace("XU6J03M6", " ");
			retArea.scrollTop = retArea.scrollHeight;
		}
	});
}
function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "cfetool");
	tablink[tablink.length - 1] = new Array("", "Module_cfetool.asp");
}
function close_buy(){
	$("#qrcode_show").fadeOut(300);
}
function open_buy(){
	$("#qrcode_show").css("margin-top", "-50px");
	$("#qrcode_show").fadeIn(300);
}
function close_info(){
	$("#activated_info").fadeOut(300);
}
function open_info(){
	$("#activated_info").css("margin-top", "-50px");
	$("#activated_info").fadeIn(300);
}
function pop_help() {
	close_buy();
	require(['/res/layer/layer.js'], function(layer) {
		layer.open({
			type: 1,
			title: false,
			closeBtn: false,
			area: '600px;',
			shade: 0.8,
			shadeClose: 1,
			scrollbar: false,
			id: 'LAY_layuipro',
			btn: ['关闭窗口'],
			btnAlign: 'c',
			moveType: 1,
			content: '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">\
				<b>CFE工具箱</b><br><br>\
				CFE工具箱是一款付费插件，支持hnd/axhnd/axhnd.675x平台的机器，详情：<a style="color:#e7bd16" target="_blank" href="https://github.com/koolshare/rogsoft#%E6%9C%BA%E5%9E%8B%E6%94%AF%E6%8C%81"><u>机型支持</u></a><br>\
				使用本插件有任何问题，可以前往<a style="color:#e7bd16" target="_blank" href="https://koolshare.cn/forum-98-1.html"><u>koolshare论坛插件板块</u></a>反馈~<br><br>\
				● 微信订单号获取：<span style="color:#e7bd16">我 → 支付 → 钱包 → 账单 → 点击付款订单 → 转账单号</span><br>\
				● 支付宝订单号获取：<span style="color:#e7bd16">我的 → 账单 → 点击付款订单 → 订单号</span><br><br>\
				目前订单处理方式为人工，最长大约需要一个工作日，会通过邮件返回激活码信息。<br>\
				CFE工具箱的激活码为一机一码，一次激活终身使用。<br>\
				</div>',
			yes: function(index, layero){
				open_buy();
				layer.close(index);
			}
		});
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
											<div id="qrcode_show" class="content_status">
												<div style="text-align: center;margin-top:10px">
													<span id="qrtitle" style="font-size:16px;color:#000;">【CFE工具箱】修改国行需要付费，价格为40元人民币。</span>
												</div>
												<div id="qrcode" style="width:580px;height:285px;text-align:center;overflow:hidden" >
													<canvas width="580px" height="285px" style="display: none;"></canvas>
													<img style="height:285px" src="https://firmware.koolshare.cn/binary/image_bed/sadog/sadog.png"/>
												</div>
												<div style="margin-top:5px;margin-left:4%;width:96%;text-align:left;">
													<div id="info0" style="font-size:16px;color:#000;"><i>激活码获取:</i></div>
													<div id="info1" style="font-size:12px;color:#000;">&nbsp;&nbsp;&nbsp;&nbsp;1.扫描上方其中一个二维码，付款40元人民币，即可购买【CFE工具箱】激活码。</div>
													<div id="info2" style="font-size:12px;color:#000;">&nbsp;&nbsp;&nbsp;&nbsp;2.复制下面文本框内容，替换xxx为<a type="button" href="javascript:void(0);" style="cursor: pointer;color:#FF3300;" onclick="pop_help();"><u>支付订单号</u></a>，发送邮件到：<a id="cfetool_mail" style="font-size:12px;color:#CC0000;" href="mailto:mjy211@gmail.com?subject=CFE工具箱插件购买&body=这是邮件的内容">mjy211@gmail.com</a></div>
													<div id="info3" style="font-size:12px;color:#000;">&nbsp;&nbsp;&nbsp;&nbsp;3.目前订单处理为人工，激活码会在一个工作日左右发送到你的邮箱，请耐心等待。</div>
												</div>
												<div style="margin-top:5px;padding-bottom:10px;margin-left:4%;width:95%;text-align:left;">
													<textarea name="test" id="cfetool_info" rows="3" cols="50" style="border:1px solid #000;width:96%;font-family:'Lucida Console';font-size:12px;background:transparent;color:#000;outline:none;resize:none;padding-top: 5px;">订单号：xxxx&#10;机器码：xxxxx</textarea>
												</div>
												<div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
													<input class="button_gen" type="button" onclick="pop_help();" value="帮助">
													<input class="button_gen" type="button" onclick="close_buy();" value="关闭">
												</div>
											</div>
											<div id="activated_info" class="content_status" style="height:230px;top:150px">
												<div style="text-align: center;margin-top:15px;margin-bottom:15px">
													<span id="qrtitle_1" style="font-size:16px;color:#000;"><i>你的【CFE工具箱】已经成功激活！</i></span>
												</div>
												<div style="margin-top:0px;margin-left:3%;width:97%;text-align:left;">
													<div id="a_info1" style="font-size:12px;color:#000;">1.使用CFE工具箱有任何问题，可以前往<a style="color:#e7bd16" target="_blank" href="https://koolshare.cn/forum-98-1.html"><u>koolshare论坛插件板块</u></a>反馈。</div>
													<div id="a_info2" style="font-size:12px;color:#000;">2.如果激活码遗失，请尝试重装插件找回，或者发送机器码到：<a id="cfetool_a_mail" style="font-size:12px;color:#CC0000;" href="mailto:mjy211@gmail.com?subject=CFE工具箱插件购买&body=这是邮件的内容">mjy211@gmail.com</a>寻回。</div>
													<div id="a_info3" style="font-size:12px;color:#000;">3.以下是你的机器码，激活码相关信息，请妥善保管。</div>
												</div>
												<div style="margin-top:5px;padding-bottom:10px;margin-left:3%;width:97%;text-align:left;">
													<textarea name="test" id="cfetool_a_info" rows="3" cols="50" style="border:1px solid #000;width:96%;font-family:'Lucida Console';font-size:12px;background:transparent;color:#000;outline:none;resize:none;padding-top: 5px;">机器码：xxxx&#10;激活码：xxxx</textarea>
												</div>
												<div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
													<input class="button_gen" type="button" onclick="close_info();" value="关闭">
												</div>
											</div>
											<div class="formfonttitle">CFE工具箱<lable id="cfetool_version"><lable></div>
											<div style="float:right; width:15px; height:25px;margin-top:-20px">
												<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
											</div>
											<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
											<div>
												<span>【CFE工具箱】可以查看机器CFE内相关信息，并支持非国行机器改国行(收费功能)。</span>
											</div>
											<div id="log_content">
												<textarea cols="63" rows="18" wrap="on" readonly="readonly" id="log_content_text" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
											</div>
											<div id="cfetool_main" style="margin-top:10px;display: none;">
												<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
													<thead>
														<tr>
															<td colspan="2">激活面板</td>
														</tr>
													</thead>
													<tr>
														<th>CFE工具箱激活码</th>
														<td>
															<input type="password" maxlength="100" id="cfetool_key" class="input_ss_table" style="width:415px;font-size: 85%;" readonly onblur="switchType(this, false);" onfocus="switchType(this, true);this.removeAttribute('readonly');" autocomplete="new-password" autocorrect="off" autocapitalize="off" spellcheck="false" >
															<button id="cfetool_active_btn" onclick="cfeit(4);" class="cfetool_btn" style="width:50px;cursor:pointer;vertical-align: middle;">激活</button>
															<button id="cfetool_buy_btn" onclick="open_buy();" class="cfetool_btn" style="width:80px;cursor:pointer;vertical-align: middle;">购买激活码</button>
															<button id="cfetool_authorized_btn" onclick="open_info();" class="cfetool_btn" style="width:80px;cursor:pointer;vertical-align: middle;">已激活</button>
														</td>
													</tr>
												</table>
											</div>
											<div class="apply_gen">
												<input class="button_gen" id="cfetool_apply_1" onClick="cfeit(1)" type="button" value="开始检测" />
												<input class="button_gen" id="cfetool_apply_2" onClick="cfeit(2)" type="button" value="一键改国行" style="display: none;"/>
												<input class="button_gen" id="cfetool_apply_3" onClick="cfeit(3)" type="button" value="恢复原始CFE" style="display: none;"/>
											</div>
											<div id="warning" style="font-size:14px;margin:20px auto;"></div>
											<div style="margin:10px 0 10px 5px;display: none;" class="splitLine" id="spl"></div>
											<div class="SimpleNote" id="message" style="display: none;">
												<li id="msg1">本插件通过修改底层CFE来实现修改路由器国家地区，须知修改CFE有风险，由此带来的风险请自行承担！</li>
												<li id="msg2">华硕通过地区代码来限制固件功能，如wifi选区澳大利亚，UU加速器，中文语言显示等，改CFE为国区后这些功能将不会再受到限制。</li>
												<li id="msg3">修改完成后，卸载本插件、重置路由器、升级固件、刷三方固件/原厂固件等操作，只要不损坏CFE分区，机器均会保持国行状态。</li>
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
