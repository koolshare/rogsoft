<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - Unlock AiMesh</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/> 
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<link rel="stylesheet" type="text/css" href="/res/layer/theme/default/layer.css">
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<style>
.uamas_btn {
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
.uamas_btn:hover {
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
body .layui-layer-lan .layui-layer-btn0 {border-color:#22ab39; background-color:#22ab39;color:#fff; background:#22ab39}
body .layui-layer-lan .layui-layer-btn .layui-layer-btn1 {border-color:#1678ff; background-color:#1678ff;color:#fff;}
body .layui-layer-lan .layui-layer-btn2 {border-color:#FF6600; background-color:#FF6600;color:#fff;}
body .layui-layer-lan .layui-layer-title {background: #1678ff;}
body .layui-layer-lan .layui-layer-btn a{margin:8px 8px 0;padding:5px 18px;}
body .layui-layer-lan .layui-layer-btn {text-align:center}
</style>
<script>
var params_inp = ['uamas_key'];
var dbus;
String.prototype.myReplace = function(f, e){
	var reg = new RegExp(f, "g"); 
	return this.replace(reg, e); 
}
function init() {
	show_menu(menu_hook);
	get_dbus_data();
	get_log();
}

function get_dbus_data(){
	$.ajax({
		type: "GET",
		url: "/_api/uamas_",
		dataType: "json",
		async: false,
		success: function(data) {
			dbus = data.result[0];
			conf2obj();
		}
	});
}
function conf2obj(){
	if (dbus["uamas_version"]){
		E("uamas_version").innerHTML = " - " + dbus["uamas_version"];
	}
	if (!dbus["uamas_mcode"]){
		E("uamas_buy_btn").style.display = "";
		E("uamas_active_btn").style.display = "none";
		E("uamas_mcode_pannel").style.display = "none";
		E("uamas_main").style.display = "none";
	}else{
		E("uamas_buy_btn").style.display = "none";
		E("uamas_active_btn").style.display = "";
		E("uamas_mcode_pannel").style.display = "";
		E("uamas_main").style.display = "";
		E("uamas_mcode_content").innerHTML = "<em>" + dbus["uamas_mcode"] + "</em>";
	}
	if(dbus["uamas_key"]){
		E("uamas_key").value = dbus["uamas_key"];
		E("uamas_buy_btn").style.display = "none";
		E("uamas_active_btn").style.display = "none";
		E("uamas_authorized_btn").style.display = "";
		E("uamas_unlock_btn").style.display = "";
	}
	if (dbus["uamas_mcode"] && dbus["uamas_key"]){
		E("uamas_mcode_pannel").style.display = "none";
		E("uamas_a_info").innerHTML = "识别码：" +  dbus["uamas_mcode"] + "&#10;激活码：" + dbus["uamas_key"];
	}
	if(dbus["uamas_unlock"] == "1"){
		E("uamas_close_aimesh").style.display = "";
	}
}
function unlock(action){
	// 1. 获取激活码
	// 2. 激活插件
	// 3. 解锁AiMesh
	// 4. 关闭AiMesh
	var dbus_new = {};
	if(action == 2 || action == 3 || action == 4){
		var unlock_key = E("uamas_key").value;
		if(!unlock_key){
			alert("请先输入激活码后再点击激活按钮！");
			return false;
		}
		if (unlock_key.indexOf('UAK_') == -1){
			alert("请输入正确格式的激活码！");
			return false;
		}
		if(unlock_key.length != "52"){
			alert("激活码长度不正确！");
			return false;
		}
	}
	if(action == 2){
		for (var i = 0; i < params_inp.length; i++) {
			dbus_new[params_inp[i]] = E(params_inp[i]).value;
		}
	}
	if(action == 3){
		if(dbus["uamas_warn_3"] != "1"){
			if(!confirm('注意：\n检测到首次使用【Unlock AiMesh】插件！\n\nUnlock AiMesh通过一些特殊的修改实现解锁网件原厂固件的AiMesh功能！\n修改成功会立即生效，无需重启路由器！\n\n点确定后，将会继续运行，并且此弹出消息以后也不再显示。')){
				return false;
			}else{
				dbus_new["uamas_warn_3"] = "1";
			}
		}
	}

	E("uamas_unlock_btn").disabled = true;
	//E("uamas_apply_2").disabled = true;
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "uamas_config", "params": [action], "fields": dbus_new};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			E("uamas_unlock_btn").disabled = false;
			//E("uamas_apply_2").disabled = false;
			get_log(action);
		}
	});
}
function get_log(action){
	$.ajax({
		url: '/_temp/uamas_log.txt',
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
	tabtitle[tabtitle.length - 1] = new Array("", "uamas");
	tablink[tablink.length - 1] = new Array("", "Module_uamas.asp");
}
function close_info(){
	$("#activated_info").fadeOut(300);
}
function open_info(){
	$("#activated_info").css("margin-top", "-50px");
	$("#activated_info").fadeIn(300);
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
											<div id="activated_info" class="content_status" style="height:190px;top:200px">
												<div style="text-align: center;margin-top:15px;margin-bottom:15px">
													<span id="qrtitle_1" style="font-size:16px;color:#000;"><i>你的【Unlock AiMesh】已经成功激活！</i></span>
												</div>
												<div style="margin-top:0px;margin-left:3%;width:97%;text-align:left;">
													<div id="a_info2" style="font-size:12px;color:#000;">以下是你的识别码，激活码信息，请妥善保管。</div>
												</div>
												<div style="margin-top:5px;padding-bottom:10px;margin-left:3%;width:97%;text-align:left;">
													<textarea name="test" id="uamas_a_info" rows="3" cols="50" style="border:1px solid #000;width:96%;font-family:'Lucida Console';font-size:12px;background:transparent;color:#000;outline:none;resize:none;padding-top: 5px;">机器码：xxxx&#10;激活码：xxxx</textarea>
												</div>
												<div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
													<input class="button_gen" type="button" onclick="close_info();" value="关闭">
												</div>
											</div>
											<div class="formfonttitle">Unlock Aimesh For NetGear Merlin Router<lable id="uamas_version"><lable></div>
											<div style="float:right; width:15px; height:25px;margin-top:-20px">
												<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
											</div>
											<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
											<div id="head_note">
												<span>&nbsp;&nbsp;本插件可以解锁网件梅林固件的AiMesh功能，插件需要激活使用！一旦解锁AiMesh，效果是永久的！</span>
												<lable id="uamas_o_version"></lable>
											</div>
											<div id="log_content" class="soft_setting_log">
												<textarea cols="63" rows="18" wrap="on" readonly="readonly" id="log_content_text" class="soft_setting_log1" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
											</div>
											<div id="uamas_main" style="margin-top:10px">
												<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
													<thead>
														<tr>
															<td colspan="2">激活面板</td>
														</tr>
													</thead>
													<tr id="uamas_mcode_pannel" style="display:none;">
														<th>识别码</th>
														<td id="uamas_mcode_content" title="请将识别码发送给插件作者，以获取插件激活码！"></td>
													</tr>
													<tr>
														<th>激活密钥</th>
														<td>
															<input type="password" maxlength="100" id="uamas_key" class="input_ss_table" style="width:415px;font-size: 85%;" readonly onblur="switchType(this, false);" onfocus="switchType(this, true);this.removeAttribute('readonly');" autocomplete="new-password" autocorrect="off" autocapitalize="off" spellcheck="false" >
															<button id="uamas_active_btn" onclick="unlock(2);" class="uamas_btn" style="width:70px;cursor:pointer;vertical-align: middle;display: none;">激活插件</button>
															<button id="uamas_authorized_btn" onclick="open_info();" class="uamas_btn" style="width:80px;cursor:pointer;vertical-align: middle;display: none;">插件已激活</button>
														</td>
													</tr>
												</table>
											</div>
											<div class="apply_gen">
												<input class="button_gen" style="display: none;" id="uamas_buy_btn" onClick="unlock(1)" type="button" value="获取激活码"/>
												<input class="button_gen" style="display: none;" id="uamas_unlock_btn" onClick="unlock(3)" type="button" value="解锁AiMesh"/>
												<input class="button_gen" style="display: none;" id="uamas_close_aimesh" onClick="unlock(4)" type="button" value="关闭AiMesh"/>
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
