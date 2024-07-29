<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html xmlns:v>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache" />
<meta HTTP-EQUIV="Expires" CONTENT="-1" />
<link rel="shortcut icon" href="images/favicon.png" />
<link rel="icon" href="images/favicon.png" />
<title>软件中心 - 上海电信IPTV</title>
<link rel="stylesheet" type="text/css" href="index_style.css" />
<link rel="stylesheet" type="text/css" href="form_style.css" />
<link rel="stylesheet" type="text/css" href="usp_style.css" />
<link rel="stylesheet" type="text/css" href="ParentalControl.css" />
<link rel="stylesheet" type="text/css" href="css/icon.css" />
<link rel="stylesheet" type="text/css" href="css/element.css" />
<link rel="stylesheet" type="text/css" href="/res/softcenter.css" />
<style>
	.switch:checked ~.switch_container > .switch_bar{
		background-color: #629cee;
	}
	.KSBottom {
		position: absolute;
		height: 100px;
		background: url(/res/koolshare.png) 0px 3px no-repeat;
		padding-left:150px;
		margin-top:20px;
		float:right;
	}
	.shiptv_box{
		position: absolute;
		width: 733px;
		margin-left: 1%;
		margin-top:-83px;
		padding-top: 10px;
		padding-bottom: 10px;
		line-height: 1.8;
		background:rgba(0, 0, 0, 0.7);
	}
	.status_box{
		position: absolute;
		margin-left: 388px;
		margin-right: 100px;;
		margin-top:-239px;
		padding-top: 3px;
		padding-bottom: 3px;
		line-height: 1.8;
		/*background:rgba(0, 0, 0, 0.2);*/
		/*color: #009900;*/
		font-size: 22px;
	}
</style>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script>
var dbus = {};
var x = 6;
var SUBMIT;
var refresh_flag=1;
var params_chk = ['shiptv_dhcp', 'shiptv_vlan'];
function init() {
	show_menu(menu_hook);
	get_dbus_data();
	hook_funcion();
	setTimeout("get_status();", 1000);
	detect();
}

function hide_elem(){
	$("#koolshare").hide();
	$("#shanghai").hide();
	$(".shiptv_box").hide();
	$(".satus_box").hide();
	$("#sp2").hide();
	$(".apply_gen").hide();
	$("#warn_msg_1").show();
}

function detect(){
	var sw_mode = '<% nvram_get("sw_mode"); %>' 
	var MODEL = '<% nvram_get("odmpid"); %>' || '<% nvram_get("productid"); %>';
	if(sw_mode != 1){ //使用的不是路由模式
		hide_elem();
		$('#warn_msg_1').html('<h2><font color="#FF6600">错误！</font></h2><h2>【上海电信IPTV】插件暂时不可用！因为你的设备工作在非路由模式下！</h2><h2>请前往【系统管理】-<a href="Advanced_OperationMode_Content.asp"><u><em>【操作模式】</em></u></a>中选择无线路由器模式！才能正常使用本插件！</h2>');
	}
	//if(MODEL != "RT-AX86U"){
	//	hide_elem();
	//	$('#warn_msg_1').html('<h2><font color="#FF6600">哦豁！</font></h2><h2>【上海电信IPTV】插件在你的机型：' + MODEL + '上不可用！</h2><h2>本插件目前仅针对<font color="#00CCFF">RT-AX86U</font>开放测试！</h2><h2>其它机型请耐心等待！</h2><h2>更多信息请见：<a href="https://koolshare.cn/thread-183914-1-1.html"><u><font color="#00CCFF">https://koolshare.cn/thread-183914-1-1.html</font><u></a></h2>');
	//}
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/shiptv_",
		dataType: "json",
		cache: false,
		async: false,
		success: function(data) {
			dbus = data.result[0];
			conf2obj();
		},
		error: function(XmlHttpRequest, textStatus, errorThrown) {
			console.log(XmlHttpRequest.responseText);
			alert("skipd数据读取错误，请用在chrome浏览器中按F12键后，在console页面获取错误信息！");
		}
	});
}

function conf2obj() {
	for (var i = 0; i < params_chk.length; i++) {
		if(dbus[params_chk[i]]){
			E(params_chk[i]).checked = dbus[params_chk[i]] != "0";
		}
	}
	if(dbus["shiptv_version"])
		E("shiptv_version").innerHTML = "&nbsp;-&nbsp;" + dbus["shiptv_version"];
}

function hook_funcion(){
	$("#log_content2").click(
		function() {
			x = -1;
		});
}

function save() {
	var SUBMIT = 1;
	var dbus_new = {};
	//都关闭
	if(E("shiptv_dhcp").checked == false && E("shiptv_vlan").checked == false && dbus["shiptv_warn_3"] != "1"){
		if(!confirm('注意：\n• DHCP OPTION选项未开启！\n• VLAN穿透选项未开启！\n两个选项均未开启，插件将关闭。\n点确定后，此弹出消息以后将不再显示。')){
			return false;
		}else{
			dbus_new["shiptv_warn_3"] = "1"
		}
	}
	//dhcp option选项
	if(E("shiptv_dhcp").checked == false && E("shiptv_vlan").checked == true && dbus["shiptv_warn_2"] != "1"){
		if(!confirm('注意：\n• DHCP OPTION选项未开启！\n你确定要这样配置吗？\n点确定后，此弹出消息以后将不再显示。')){
			return false;
		}else{
			dbus_new["shiptv_warn_2"] = "1"
		}
	}
	//vlan穿透选项
	if(E("shiptv_dhcp").checked == true && E("shiptv_vlan").checked == false && dbus["shiptv_warn_1"] != "1"){
		if(!confirm('注意：\n• VLAN穿透选项未开启！\n你需要正确配置交换机才能让IPTV正常工作！\n确定不开启VLAN穿透吗？\n点确定后，此弹出消息以后将不再显示。')){
			return false;
		}else{
			dbus_new["shiptv_warn_1"] = "1"
		}
	}
	//首次使用，提示只有上海用户电信用户才能使用
	if(dbus["shiptv_warn_0"] != "1"){
		if(!confirm('注意：\n检测到首次使用【上海电信IPTV】插件！\n此插件仅针对上海地区电信用户，其它地区用户请勿使用本插件！\n\n你确定要开启插件吗？？\n点确定后，此弹出消息以后将不再显示。')){
			return false;
		}else{
			dbus_new["shiptv_warn_0"] = "1"
		}
	}
	// collect data from checkbox
	for (var i = 0; i < params_chk.length; i++) {
		dbus_new[params_chk[i]] = E(params_chk[i]).checked ? '1' : '0';
	}
	console.log("dbus_new：", dbus_new);
	// post data
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "shiptv_config.sh", "params": ["web_apply"], "fields": dbus_new };
	$.ajax({
		type: "POST",
		cache: false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			console.log(response);
			if (response.result == id){
				console.log("提交成功！");
				get_log();
			}else{
				alert("脚本运行错误！");
				return false;
			}
		},
		error: function(XmlHttpRequest, textStatus, errorThrown){
			console.log(XmlHttpRequest.responseText);
			alert("脚本运行错误！");
		}
	});
}

function get_status(){
	if (SUBMIT == 1)
		return false;
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "shiptv_status.sh", "params":[1], "fields": ""};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			var resp = response.result.split("@@");
			if (resp[0] == 0){
				E("status1").style.display = "";
				E("status2").style.display = "none";
				E("status1").innerHTML = resp[1];
			}else{
				E("status1").style.display = "none";
				E("status2").style.display = "";
				E("status2").innerHTML = resp[1] + "，代码：" + resp[0];
			}
			setTimeout("get_status();", 4000);
		},
		error: function(){
			E("status1").style.display = "none";
			E("status2").style.display = "";
			E("status2").innerHTML = "获取运行状态失败！";
			setTimeout("get_status();", 10000);
		}
	});
}

function get_log(){
	showROGLoadingBar();
	$.ajax({
		url: '/_temp/shiptv_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content3");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", " ");
				E("ok_button").style.display = "";
				retArea.scrollTop = retArea.scrollHeight;
				count_down_close();
				return true;
			}
			setTimeout("get_log();", 200);
			retArea.value = response.replace("XU6J03M6", " ");
			retArea.scrollTop = retArea.scrollHeight;
		}
	});
}

function show_log() {
	x = -1;
	refresh_flag=2;
	E("ok_button1").value = "关闭日志";
	get_log(2);
}

function showROGLoadingBar(){
	if(window.scrollTo)
		window.scrollTo(0,0);

	disableCheckChangedStatus();
	
	htmlbodyforIE = document.getElementsByTagName("html");  //this both for IE&FF, use "html" but not "body" because <!DOCTYPE html PUBLIC.......>
	htmlbodyforIE[0].style.overflow = "hidden";	  //hidden the Y-scrollbar for preventing from user scroll it.
	
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

	if (document.documentElement  && document.documentElement.clientHeight && document.documentElement.clientWidth){
		winHeight = document.documentElement.clientHeight;
		winWidth = document.documentElement.clientWidth;
	}

	if(winWidth >1050){
	
		winPadding = (winWidth-1050)/2;	
		winWidth = 1105;
		blockmarginLeft= (winWidth*0.3)+winPadding-150;
	}
	else if(winWidth <=1050){
		blockmarginLeft= (winWidth)*0.3+document.body.scrollLeft-160;

	}
	
	if(winHeight >660)
		winHeight = 660;
	
	blockmarginTop= winHeight*0.3-140		
	E("loadingBarBlock").style.marginTop = blockmarginTop+"px";
	E("loadingBarBlock").style.marginLeft = blockmarginLeft+"px";
	E("loadingBarBlock").style.width = 770+"px";
	E("LoadingBar").style.width = winW+"px";
	E("LoadingBar").style.height = winH+"px";
	LoadingROGProgress();
}

function LoadingROGProgress(){
	E("LoadingBar").style.visibility = "visible";
	$("#loading_block2").html("<font color='#629cee'>----------------------------------------------------------------------------------------------------------------------------------");
	E("loading_block3").innerHTML = "上海电信 IPTV - 应用中 ...";
}

function hideROGLoadingBar(){
	x = -1;
	E("LoadingBar").style.visibility = "hidden";
	if (refresh_flag == "1"){
		refreshpage();
	}
}

function count_down_close() {
	if (x == "0") {
		hideROGLoadingBar();
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
	tabtitle[tabtitle.length - 1] = new Array("", "上海电信IPTV");
	tablink[tablink.length - 1] = new Array("", "Module_shiptv.asp");
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
					<div id="loading_block3" style="margin:10px auto;margin-left:20px;width:85%; font-size:12pt;"></div>
					<div id="loading_block2" style="margin:10px auto;width:95%;"></div>
					<div id="log_content2" style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
						<textarea cols="50" rows="28" wrap="off" readonly="readonly" id="log_content3" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Lucida Console'; font-size:11px;background:transparent;color:#FFFFFF;outline: none;padding-left:3px;padding-right:22px;overflow-x:hidden"></textarea>
					</div>
					<div id="ok_button" class="apply_gen" style="background: #000;display: none;">
						<input id="ok_button1" class="button_gen" type="button" onclick="hideROGLoadingBar()" value="确定">
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
								<div>
									<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
										<tr>
											<td bgcolor="#4D595D" colspan="3" valign="top">
												<div>&nbsp;</div>
												<div style="float:left;margin-left:10px;" class="formfonttitle" style="padding-top: 12px">上海电信 IPTV<lable id="shiptv_version"></lable></div>
												<div style="float:right;width:15px;height:25px;margin-top:10px;margin-right:15px;"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
												<div style="margin:35px 0 10px 5px;" class="splitLine"></div>
												<div id="koolshare" style="width: 98%;">
													<img src="/res/koolshare.png" style="width: 110px;position:absolute;margin-top:5px;right:18px;" draggable="false">
												</div>
												<div id="shanghai" style="width: 98%;margin: 0 0 0% 1%;">
													<img src="res/shanghai.jpg" style="width: 100%" draggable="false">
												</div>
												<div class="shiptv_box">
													<li style="margin-left: 10px;">上海电信 4K IPTV 一键开启。</li>
													<li style="margin-left: 10px;">光猫路由/桥接模式下，4K机顶盒接入路由器后正常使用观看IPTV节目。</li>
													<li style="margin-left: 10px;">更多信息请前往论坛帖：<a href="https://koolshare.cn/thread-183914-1-1.html" title="" target="_blank">https://koolshare.cn/thread-183914-1-1.html</a> 。</li>
													<div class="switch_field" style="position: absolute;width: 170px;height: 30px;top: 10%;right: 0%;">
														<label for="shiptv_dhcp">
															<input id="shiptv_dhcp" class="switch" type="checkbox" checked=true style="display: none;">
															<div class="switch_container">
																<div class="switch_bar"></div>
																<div class="switch_circle transition_style">
																	<div></div>
																</div>
															</div>
															<div style="position: relative;margin:-27px 0 0 60px">DHCP OPTION</div>
														</label>
													</div>
													<div class="switch_field" style="position: absolute;width: 170px;height: 30px;top: 55%;right: 0%;">
														<label for="shiptv_vlan">
															<input id="shiptv_vlan" class="switch" type="checkbox" checked=true style="display: none;">
															<div class="switch_container">
																<div class="switch_bar"></div>
																<div class="switch_circle transition_style">
																	<div></div>
																</div>
															</div>
															<div style="position: relative;margin:-27px 0 0 60px">VLAN 穿透</div>
														</label>
													</div>
												</div>
												<div class="status_box">
													<span id="status1" style="display: none;color: #009900"></span>
													<span id="status2" style="display: none;color: #CC3300"></span>
												</div>
												<div style="margin: 5% 0 2% 3%;width: 96%;background: #464f52;" class="splitLine" id="sp2"></div>
												<div class="apply_gen">
													<input class="button_gen" id="shiptv_apply" onClick="save()" type="button" value="应用" />
												</div>
												<div id="warn_msg_1" style="display: none;text-align:center; line-height: 4em;"><i></i></div>
											</td>
										</tr>
									</table>
								<div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</td>
	<div id="footer"></div>
</body>
</html>
