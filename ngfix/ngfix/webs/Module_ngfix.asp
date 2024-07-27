<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - RAX80 Toolbox</title>
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
.FormTable th{
	font-family: Roboto-Light, "Microsoft JhengHei";
	font-size:10pt;
	width:40%;
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
	height:646px;
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
.splitLine_0 {
    background: #242424;
    height: 1px;
    width: 549px;
    margin: 10px 0 10px 15px;
}
.input_ss_table{
	font-family: Roboto-Light, "Microsoft JhengHei";
	font-size:10pt;
}
body .layui-layer-lan .layui-layer-btn0 {border-color:#1678ff; background-color:#1678ff;color:#fff; background:#1678ff}
body .layui-layer-lan .layui-layer-btn .layui-layer-btn1 {border-color:#5B5B5B; background-color:#5B5B5B;color:#fff;}
body .layui-layer-lan .layui-layer-btn2 {border-color:#FF6600; background-color:#FF6600;color:#fff;}
body .layui-layer-lan .layui-layer-title {background: #9a258f;}
body .layui-layer-lan .layui-layer-btn a{margin:8px 8px 0;padding:5px 18px;}
body .layui-layer-lan .layui-layer-btn {text-align:center}
</style>
<script>
var params_inp = ['ngfix_ssid', 'ngfix_passwd', 'ngfix_sn', 'ngfix_mac'];
var dbus;
function init() {
	show_menu(menu_hook);
	get_dbus_data();
	get_log();
}
function get_dbus_data(){
	$.ajax({
		type: "GET",
		url: "/_api/ngfix_",
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
	if (dbus["ngfix_fixed"] == "1"){
		E("ngfix_apply_5").style.display = "";
	}	
	if (dbus["ngfix_flag"] == "1"){
		E("ngfix_main").style.display = "";
		E("ngfix_apply_2").style.display = "";
		E("ngfix_apply_3").style.display = "";
		E("ngfix_apply_5").style.display = "none";
		E("message").style.display = "";
		E("spl").style.display = "";
	}
	if (dbus["ngfix_flag"] == "2"){
		E("ngfix_apply_4").style.display = "";
	}
}
function fixit(action){
	var dbus_new = {};
	if(action == 2){
		if(!E("ngfix_ssid").value){
			alert("请输入路由器的出厂SSID名称！");
			return false;
		}
		if(!E("ngfix_passwd").value){
			alert("请输入路由器的出厂wifi名称！！");
			return false;
		}
		if(!E("ngfix_sn").value){
			alert("请输入路由器的出厂SN序列号！");
			return false;
		}
		if(!E("ngfix_mac").value){
			alert("请输入路由器的MAC地址！");
			return false;
		}

		for (var i = 0; i < params_inp.length; i++) {
			dbus_new[params_inp[i]] = E(params_inp[i]).value;
		}
	}
	if(action == 3){
		dbus_new["ngfix_flag"] = "1";
	}
	E("ngfix_apply_1").disabled = true;
	E("ngfix_apply_2").disabled = true;
	E("ngfix_apply_3").disabled = true;
	E("ngfix_apply_4").disabled = true;
	E("ngfix_apply_5").disabled = true;
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "ngfix_config", "params": [action], "fields": dbus_new};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			E("ngfix_apply_1").disabled = false;
			E("ngfix_apply_2").disabled = false;
			get_log(action);
		}
	});
}
function get_log(action){
	$.ajax({
		url: '/_temp/ngfix_log.txt',
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
	tabtitle[tabtitle.length - 1] = new Array("", "ngfix");
	tablink[tablink.length - 1] = new Array("", "Module_ngfix.asp");
}
function close_buy(){
	$("#qrcode_show").fadeOut(300);
}
function open_help() {
	$("#qrcode_show").css("margin-top", "-50px");
	$("#qrcode_show").fadeIn(300);
}
function flash_erase(){
	if(!confirm('注意：\n\n点击确定将会运行 flash_erase 命令！\n\n')){
		return false;
	}else{
		var id = parseInt(Math.random() * 100000000);
		var postData = {"id": id, "method": "ngfix_preofw", "params": '1', "fields": {}};
		$.ajax({
			type: "POST",
			url: "/_api/",
			data: JSON.stringify(postData),
			dataType: "json",
			success: function(response) {
				console.log(response)
				if(response.result == "success"){
					alert("flash_erase 命令全部执行成功!");
				}else if(response.result == "failed"){
					alert("错误:\n\nflash_erase 命令全部执行失败，\n\n请尝试重装插件，或者重启/重置/重刷386梅林固件后再试！");
				}else if(response.result == "failed1"){
					alert("错误:\n\nflash_erase 命令部分执行失败，你仍然可以尝试刷OFW固件，但这有一定概率会使得路由器变砖!\n\n或者请尝试重装插件，以及重启/重置/重刷梅林386固件后再试！");					
				}else if(response.result == "failed2"){
					alert("错误:\n\n没有找到mtd15分区！n\n请更新梅林386最新固件后重试！");
				}
			},
			error: function(XmlHttpRequest, textStatus, errorThrown){
				console.log(XmlHttpRequest.responseText);
				alert("错误:\n\nflash_erase 命令执行失败!\n\n请尝试重装插件，或者重启/重置/重刷386梅林固件后再试！");
			}
		});
	}
}
function ofw_guide() {
	var current_url = window.location.href;
	net_address = current_url.split("/Module")[0];
	note = "<font color='#FF0000'>提醒1：刷机有风险，请严格按照刷机流程操作，刷机带来的风险请自行承担！</font>"
	note += "<br />"
	note += "<font color='#FF0000'>提醒2：请全程插网线，使用PC + 谷歌浏览器进行操作，刷机前先移除路由器上的USB设备！</font>"
	note += "<hr>"
	note += "<h4>1. 下载Merlin to OFW固件：<a style='color:#22ab39;' href='https://fw.koolcenter.com/KoolCenter_Merlin_New_Gen_386/Netgear/RAX80/Merlin%20to%20OFW/RAX80-OFW-V1.0.0.30_1.0.17.w'><u>RAX80-OFW-V1.0.0.30_1.0.17.w</u></a></h4>"
	note += "<h4>2. 核对固件md5校验值：<font color='#1678ff'>420FEB0CF64C5D0C2B232014BF671748</font></h4>"
	note += "<h4>3. 校验核对无误后，点击此<a style='margin: 8px 2px 0;padding: 5px 5px;border-color: #ee1f60;background-color: #ee1f60;color: #fff;background: #ee1f60;border-radius: 2px;cursor: pointer;' onclick='flash_erase();'>flash_erase</a>按钮，等待页面弹出成功提示!</h4>"
	note += "<h4>4. 前往固件升级页面：<a style='color:#22ab39;' href='/Advanced_FirmwareUpgrade_Content.asp'>Advanced_FirmwareUpgrade_Content.asp</a>，上传Merlin to OFW固件</h4>"
	note += "<h4>5. 升级OFW固件后，请不要关闭RAX80，等待路由器自己重启，直到出现WiFi信号。</h4>"
	note += "<div id='ofw_help' style='display:none;'>"
	note += "<hr>"
	note += "<font color='#676767'>&nbsp;&nbsp;&nbsp;&nbsp;点击</font><font color='#1678ff'>flash_erase</font><font color='#676767'>按钮并弹出成功提示后，会清除当前RAX80梅林固件的所有nvram配置和软件中心！包括但不限于路由器账号、密码；网络拨号账号密码；wifi SSID与密码等...</font>"
	note += "<br />"
	note += "<font color='#676767'>&nbsp;&nbsp;&nbsp;&nbsp;如果成功进行了flash_erase后，但不上传Merlin to OFW固件，那么路由器重启后，所有配置将会丢失，路由器需要重新配置。点击取消按钮将不会进行任何操作！</font>"
	note += "<br />"
	note += "<font color='#676767'>&nbsp;&nbsp;&nbsp;&nbsp;更多信息，请参考RAX80梅林386固件发布贴: <a style='color:#22ab39;' target='_blank' href='https://koolshare.cn/thread-201178-1-1.html'><u>https://koolshare.cn/thread-201178-1-1.html</u></a></font>"
	note += "</div>"
	
	require(['/res/layer/layer.js'], function(layer) {
		layer.open({
			type: 0,
			skin: 'layui-layer-lan',
			shade: 0.8,
			title: '网件RAX80梅林固件刷回网件官方固件',
			time: 0,
			area: '660px',
			btnAlign: 'c',
			maxmin: true,
			content: note,
			btn: ['帮助', '取消'],
			btn1: function() {
				if(E("ofw_help").style.display == "none"){
					E("ofw_help").style.display = "";
					$('.layui-layer-btn0').html("关闭帮助")
				}else{
					E("ofw_help").style.display = "none";
					$('.layui-layer-btn0').html("帮助")
				}
			},
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
												<div style="margin-top:30px;text-align: center;margin-top:10px">
													<span id="qrtitle" style="font-size:16px;color:#000;">【RAX80 Toolbox】请参考下图，找到你路由器背面的标签。</span>
												</div>
												<div id="qrcode" style="margin-top:10px;width:580px;height:340px;text-align:center;overflow:hidden" >
													<canvas width="580px" height="340px" style="display: none;"></canvas>
													<img style="height:340px" src="https://fw.koolcenter.com/binary/image_bed/sadog/RAX80_TAG.jpg"/>
												</div>
												<div style="margin-top:10px;margin-left:4%;width:94%;text-align:left;">
													<div id="info0" style="font-size:16px;color:#000;">使用方法</div>
													<div id="info0" style="font-size:12px;color:#000;margin-top:10px;">&nbsp;&nbsp;&nbsp;&nbsp;请将你的RAX80路由器背面标签右侧白框内四行字符（如上图）抄写/拍照记录，并分别对应填写在插件内的对应的文本输入框，填写时请注意字符串长度、大小写和标签上保持一致。正确填写后点击开始修复按钮即可！</div>
													<div id="info1" style="font-size:12px;color:#000;margin-top:10px;">&nbsp;&nbsp;&nbsp;&nbsp;1.无线名称：WiFi Network Name(SSID)</div>
													<div id="info1" style="font-size:12px;color:#000;">&nbsp;&nbsp;&nbsp;&nbsp;2.无线密码：Network Key（Password）</div>
													<div id="info1" style="font-size:12px;color:#000;">&nbsp;&nbsp;&nbsp;&nbsp;3.SN序列号：SERIAL序列号</div>
													<div id="info1" style="font-size:12px;color:#000;">&nbsp;&nbsp;&nbsp;&nbsp;4.MAC地址：MAC Address</div>
												</div>
												<div class="splitLine_0"></div>
												<div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
													<input class="button_gen" type="button" onclick="close_buy();" value="关闭">
												</div>
											</div>
											<div class="formfonttitle">RAX80 Toolbox</div>
											<div style="float:right; width:15px; height:25px;margin-top:-20px">
												<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
											</div>
											<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
											<div id="head_note">
												<span>本工具可以帮你给RAX80刷回网件原厂固件，如果网件原厂分区受损，还能进行修复！请点击开始检测按钮，检测原厂分区是否完整。
												<lable id="ngfix_o_version"></lable>
											</div>
											<div id="log_content" class="soft_setting_log">
												<textarea cols="63" rows="18" wrap="on" readonly="readonly" id="log_content_text" class="soft_setting_log1" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
											</div>
											<div id="ngfix_main" style="margin-top:10px;display: none;">
												<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
													<thead>
														<tr>
															<td colspan="2">修复信息面板</td>
														</tr>
													</thead>
													<tr>
														<th>无线名称：<font color="#fdb813">WiFi Network Name (SSID)</font></th>
														<td>
															<input type="text" maxlength="15" id="ngfix_ssid" class="input_ss_table" style="width:164px;" autocorrect="off" autocapitalize="off" spellcheck="false" >
														</td>
													</tr>
													<tr>
														<th>无线密码：<font color="#fdb813">Network Key (Password)</font></th>
														<td>
															<input type="text" maxlength="20" id="ngfix_passwd" class="input_ss_table" style="width:164px;" autocorrect="off" autocapitalize="off" spellcheck="false" >
														</td>
													</tr>
													<tr>
														<th>SN序列号：<font color="#fdb813">SERIAL序列号</font></th>
														<td>
															<input type="text" maxlength="13" id="ngfix_sn" class="input_ss_table" style="width:164px;" autocorrect="off" autocapitalize="off" spellcheck="false" >
														</td>
													</tr>
													<tr>
														<th>MAC地址：<font color="#fdb813">MAC Address</font></th>
														<td>
															<input type="text" maxlength="12" id="ngfix_mac" class="input_ss_table" style="width:164px;" autocorrect="off" autocapitalize="off" spellcheck="false" >
														</td>
													</tr>													
												</table>
											</div>
											<div class="apply_gen">
												<input class="button_gen" id="ngfix_apply_1" onClick="fixit(1)" type="button" value="开始检测" />
												<input class="button_gen" id="ngfix_apply_5" onClick="fixit(3)" type="button" value="重新修复" style="display: none;"/>
												<input class="button_gen" id="ngfix_apply_4" onClick="ofw_guide()" type="button" value="RAX80 OFW 向导" style="display: none;"/>
												<input class="button_gen" id="ngfix_apply_2" onClick="fixit(2)" type="button" value="开始修复" style="display: none;"/>
												<input class="button_gen" id="ngfix_apply_3" onClick="open_help()" type="button" value="修复帮助" style="display: none;"/>
											</div>
											<div id="warn_msg_1" style="display: none;text-align:center; line-height: 4em;"><i></i></div>
											<div style="margin:10px 0 10px 5px;display: none;" class="splitLine" id="spl"></div>
											<div class="SimpleNote" id="message" style="display: none;">
												<li id="msg1">请根据机器本面标签上的信息正确填写以上输入框，包括字符串长度、大小写都必须严格填写！</li>
												<li id="msg2">通过本插件对网件RAX80原厂分区进行修复，此操作不会影响任何梅林改版固件的功能，请放心使用！</li>
												<li id="msg3">原厂分区仅需进行一次修复即可，修复完成后你可以再次开始检测按钮，检查当前网件原厂分区是否完整。</li>
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
