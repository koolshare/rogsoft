<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - wifi boost</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/> 
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<link rel="stylesheet" type="text/css" href="/res/layer/theme/default/layer.css">
<script src="/state.js"></script>
<script src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script src="/js/jquery.js"></script>
<script src="/calendar/jquery-ui.js"></script> 
<script type="text/javascript" src="/res/softcenter.js"></script>
<style>
.wifiboost_btn {
	border: none;
	background: linear-gradient(to bottom, #003333  0%, #000000 100%); /* W3C */
	background: linear-gradient(to bottom, #91071f  0%, #700618 100%); /* W3C rogcss */
	font-size:10pt;
	color: #fff;
	padding: 5px 5px;
	border-radius: 5px 5px 5px 5px;
	width:165px;
	margin:  5px 5px 5px 5px;
	cursor:pointer;
	vertical-align: middle;
}
.wifiboost_btn:hover {
	border: none;
	background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%); /* W3C */
	background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%); /* W3C rogcss */
}
.loading_bar {
	width:250px;
	border: 0px;
}
.loading_bar > div {
	margin-left:-10px;
	background-color:white;
	border-radius:7px;
	padding:1px;
}
.status_bar {
	height:18px;
	border-radius:7px;
}
.FormTable th{
	width:25%;
}
.content_status {
	position: absolute;
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	border-radius:10px;
	z-index: 10;
	/*background-color:#2B373B;*/
	top: 140px;
	return height:auto;
	box-shadow: 3px 3px 10px #000;
	box-shadow: 3px 3px 10px #000;
	background: #fff;
	margin-left:120px;
	width:520px;
	height:470px;
	display: none;
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
	/*background:rgba(68, 79, 83, 0.9) none repeat scroll 0 0 !important;*/
	background: url(/images/New_ui/login_bg.png);
	background-position: 0 0;
	background-size: cover;
	opacity: .94;
}
input:focus {
	outline: none;
}
input[type=checkbox]{
	vertical-align:middle;
}
a:focus {
	outline: none;
}
.FormTitle i {
	color: #ff002f;
	font-style: normal;
}
#wifiboost_main { border:1px solid #91071f; } /* W3C rogcss */
.SimpleNote { padding:5px 10px;}
.ui-slider {
	position: relative;
	text-align: left;
}
.ui-slider .ui-slider-handle {
	position: absolute;
	width: 12px;
	height: 12px;
}
.ui-slider .ui-slider-range {
	position: absolute;
}
.ui-slider-horizontal {
	height: 6px;
}

.ui-widget-content {
	/*border: 2px solid #000;*/
	background-color:#000;
	background-color:#700618; /* W3C rogcss */
}
.ui-state-default,
.ui-widget-content .ui-state-default,
.ui-widget-header .ui-state-default {
	border: 1px solid ;
	background: #e6e6e6;
	background: #cf0a2c; /* W3C rogcss */
	margin-top:-4px;
	margin-left:-6px;
}

/* Corner radius */
.ui-corner-all,
.ui-corner-top,
.ui-corner-left,
.ui-corner-tl {
	border-top-left-radius: 4px;
}
.ui-corner-all,
.ui-corner-top,
.ui-corner-right,
.ui-corner-tr {
	border-top-right-radius: 4px;
}
.ui-corner-all,
.ui-corner-bottom,
.ui-corner-left,
.ui-corner-bl {
	border-bottom-left-radius: 4px;
}
.ui-corner-all,
.ui-corner-bottom,
.ui-corner-right,
.ui-corner-br {
	border-bottom-right-radius: 4px;
}

.ui-slider-horizontal .ui-slider-range {
	top: 0;
	height: 100%;
}

#slider .ui-slider-range {
	background: #93E7FF; 
	border-top-left-radius: 3px;
	border-top-right-radius: 1px;
	border-bottom-left-radius: 3px;
	border-bottom-right-radius: 1px;
}
#slider .ui-slider-handle {
	border-color: #93E7FF;
	border-color: #cf0a2c; /* W3C rogcss */
}
.parental_th{
	color:white;
	background:#2F3A3E;
	cursor: pointer;
	width:160px;
	height:22px;
	border-bottom:solid 1px black;
	border-right:solid 1px black;
}
body .layui-layer-lan .layui-layer-btn0 {border-color:#22ab39; background-color:#22ab39;color:#fff; background:#22ab39}
body .layui-layer-lan .layui-layer-btn .layui-layer-btn1 {border-color:#1678ff; background-color:#1678ff;color:#fff;}
body .layui-layer-lan .layui-layer-btn2 {border-color:#FF6600; background-color:#FF6600;color:#fff;}
body .layui-layer-lan .layui-layer-title {background: #1678ff;}
body .layui-layer-lan .layui-layer-btn a{margin:8px 8px 0;padding:5px 18px;}
body .layui-layer-lan .layui-layer-btn {text-align:center}
</style>
<script>
var orig_region = '<% nvram_get("location_code"); %>';
var odm = '<% nvram_get("productid"); %>'
var refresh_flag=1;
var params_chk = ['wifiboost_boost_24', 'wifiboost_boost_52', 'wifiboost_boost_58'];
var params_inp = ['wifiboost_key'];
var boost_dbm;
var x = 6;
function init() {
	show_menu(menu_hook);
	write_location();
	show_hide_elem();
	get_wl_status();
	get_dbus_data();
	try_activate();
}

function getQueryVariable(variable){
	var query = window.location.search.substring(1);
	var vars = query.split("&");
	for (var i=0;i<vars.length;i++) {
			if(vars[i].indexOf("key") != -1){
				var key_value = vars[i].split("key=")[1];
				return key_value;
			}
	}
	return(false);
}

function try_activate(){
	var key = getQueryVariable("key");
	if(key){
		if(!$("#wifiboost_key").val()){
			console.log("有激活码: ", key)
			$("#wifiboost_key").val(key);
			boost_now(3);
		}else{
			//已经激活了，跳转
			location.href = "/Module_wifiboost.asp"
		}
	}
}

function register_event(){
	if(odm == "GT-AC5300" || odm == "GT-AX11000" || odm == "RT-AX92U"){
		var current_maxp24 = '<% nvram_get("1:maxp2ga0"); %>';
		var current_maxp52 = '<% nvram_get("2:maxp5gb0a0"); %>';
		var current_maxp58 = '<% nvram_get("3:maxp5gb0a0"); %>';
	}else if(odm == "RT-AX88U"){
		var current_maxp24 = '<% nvram_get("1:maxp2ga0"); %>';
		var current_maxp52 = '<% nvram_get("2:maxp5gb0a0"); %>';
	}else{
		// RT-AC86U, RT-AX82U, RT-AX86U, TUF-AX3000
		var current_maxp24 = '<% nvram_get("0:maxp2ga0"); %>';
		var current_maxp52 = '<% nvram_get("1:maxp5gb0a0"); %>';
	}

	if(E("wifiboost_boost_24").checked == true){
		var maxp = current_maxp24;
	}else{
		if (E("wifiboost_boost_52").checked == true){
			var maxp = current_maxp52;
		}else{
			if (E("wifiboost_boost_58").checked == true){
				var maxp = current_maxp58 || current_maxp24;
			}else{
				var maxp = current_maxp24;
			}
		}
	}
	var current_dec = parseInt(maxp);
	var current_dbm = ((current_dec - 6)/4).toFixed(2);
	var current_pwr = Math.pow(10,(current_dec - 6)/4/10).toFixed(2);
	$(function() {
		$( "#slider" ).slider({
			orientation: "horizontal",
			range: "min",
			min: 24.00,
			max: 28.50,
			value: current_dbm,
			step: 0.25,
			slide:function(event, ui){
				var dbm = ui.value.toFixed(2);
				var power = Math.pow(10,ui.value/10).toFixed(2);
				document.getElementById('tx_power_desc').innerHTML = ui.value + " dBm / " + power + " mw";
			},
			stop:function(event, ui){
				boost_dbm = ui.value;
			},
		}); 
	});
	document.getElementById('tx_power_desc').innerHTML = current_dbm + " dBm / " + current_pwr + " mw";
	$("#log_content2").click(
		function() {
			x = -1;
		});	
}

function show_hide_elem(){
	if(odm == "GT-AC5300" || odm == "GT-AX11000" || odm == "RT-AX92U"){
		E("wifiboost_boost_58").style.display = "";
		E("LABLE_58").style.display = "";
		E("LABLE_52").innerHTML = "5G-1";
	}
}
function get_dbus_data(){
	$.ajax({
		type: "GET",
		url: "/_api/wifiboost_",
		dataType: "json",
		async: false,
		success: function(data) {
			dbus = data.result[0];
			conf2obj();
			show_err_code();
			register_event();
		}
	});
}
function write_location(){
	var COUNTRY = "未知";
	switch(orig_region){
		case "AA":
			COUNTRY = "亚洲";
		break;
		case "CN":
			COUNTRY = "中国";
		break;
		case "EU":
			COUNTRY = "欧洲";
		break;
		case "KR":
			COUNTRY = "韩国";
		break;
		case "RU":
			COUNTRY = "俄罗斯";
		break;
		case "SG":
			COUNTRY = "新加坡";
		break;
		case "US":
			COUNTRY = "美国";
		break;
		case "XX":
			COUNTRY = "澳大利亚";
		break;
	}
	if (orig_region != "XX"){
		document.getElementById("wifiboost_location").innerHTML = COUNTRY + "（当前区域不支持最大发射功率，需要将Wi-F区域调整到澳大利亚）";
	}else{
		document.getElementById("wifiboost_location").innerHTML = COUNTRY;
	}
}
function conf2obj(){
	for (var i = 0; i < params_chk.length; i++) {
		if(dbus[params_chk[i]]){
			E(params_chk[i]).checked = dbus[params_chk[i]] != "0";
		}
	}
	for (var i = 0; i < params_inp.length; i++) {
		if (dbus[params_inp[i]]) {
			$("#" + params_inp[i]).val(dbus[params_inp[i]]);
		}
	}
	//write version
	if (dbus["wifiboost_version"]){
		E("wifiboost_version").innerHTML = " - " + dbus["wifiboost_version"]
	}
	if (dbus["wifiboost_mcode"]){
		E("wifiboost_info").innerHTML = "订单号：xxx&#10;机器码：" +  dbus["wifiboost_mcode"];
		E("wifiboost_mail").href = "mailto:mjy211@gmail.com?subject=wifi boost插件购买&body=订单号：xxx%0d%0a机器码：" +  dbus["wifiboost_mcode"];
	}
	if (dbus["wifiboost_mcode"] &&  dbus["wifiboost_key"]){
		E("wifiboost_a_info").innerHTML = "机器码：" +  dbus["wifiboost_mcode"] + "&#10;激活码：" + dbus["wifiboost_key"];
		E("wifiboost_a_mail").href = "mailto:mjy211@gmail.com?subject=wifi boost插件购买&body=我的wifiboost插件就激活码遗失了，需要找回！%0d%0a机器码：" +  dbus["wifiboost_mcode"];
	}
	if(dbus["wifiboost_key"]){
		E("wifiboost_buy_btn").style.display = "none";
		E("wifiboost_active_btn").style.display = "none";
		E("wifiboost_authorized_btn").style.display = "";
	}else{
		E("wifiboost_buy_btn").style.display = "";
		E("wifiboost_active_btn").style.display = "";
		E("wifiboost_authorized_btn").style.display = "none";
	}
	if (dbus["wifiboost_warn"]){
		E("wifiboost_info").rows = 5
		E("qrcode_show").style.height = "505px"
		E("wifiboost_buy_btn").style.display = "none";
		E("wifiboost_active_btn").style.display = "none";
		E("wifiboost_authorized_btn").style.display = "none";
	}
}
function show_err_code() {
	var err_code = dbus["wifiboost_warn"];
	var err_mesg;
	if(!err_code){
		return true;
	}
	switch(err_code){
		case "1":
			err_mesg = '<span style="color: #CC3300">错误代码1：当前路由【RAX80】不支持wifiboost插件！</span>';
		break;
		case "2":
			err_mesg = '<span style="color: #CC3300">错误代码2：当前路由不支持wifiboost插件！请尝试重刷正确的固件后重试！！</span>';
		break;
		case "3":
			err_mesg = '<span style="color: #CC3300">错误代码3：读取wlan硬件设备数量错误！请重启或重置路由器后重试！！<br/>可能是错误的nvram值导致的！请尝试重置路由器后重试！！</span>';
		break;
		case "4":
			err_mesg = '<span style="color: #CC3300">错误代码4：读取原厂wlan配置失败，重启或重置路由器后重试！！</span>';
		break;
		case "5":
			err_mesg = '<span style="color: #CC3300">错误代码5：读取原厂wlan配置失败，重启或重置路由器后重试！！</span>';
		break;
		case "6":
			err_mesg = '<span style="color: #CC3300">错误代码6：检测到你的路由器不是国行机器！！</span><br/><br/>非国行机器因无法选择澳大利亚区域从而使得插件无法发挥作用！！<br/>如果你需要将机器刷成国行，请<a style="color: #1678ff" href="https://rogsoft.ddnsto.com/cfetool/cfetool.tar.gz">下载并离线安装CFE工具箱。</a>';
		break;
		case "7":
			err_mesg = '<span style="color: #CC3300">错误代码7：检测到你的路由器出厂配置有误！！</span>';
		break;
	}
	require(['/res/layer/layer.js'], function(layer) {
		layer.alert('<span style="font-size: 18px;">wifi boost插件检测到错误！错误信息如下：</span><br/><br/>' + err_mesg + '<br/><br/>出现错误提示意味着你可能无法使用wifi boost修改最大功率。<br/><br/>点击确定将关闭此窗口，如果错误未解决，此窗口下次还会和你相见！', {
			time: 3e4,
			shade: 0.8,
			maxWidth: '600px'
		}, function(index) {
			layer.close(index);
			return false;
		});
	});
}

function get_wl_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "wifiboost_status", "params":[2], "fields": ""};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			E("wifiboost_wl_temperature").innerHTML = response.result.split("@@")[0];
			var pwr = response.result.split("@@")[1];
			if (pwr){
				E("wifiboost_wl_power_tr").style.display = "";
				E("wifiboost_wl_power").innerHTML = pwr;
			}else{
				E("wifiboost_wl_power_tr").style.display = "none";
			}
			var maxpwr = response.result.split("@@")[2];
			if (maxpwr){
				E("wifiboost_wl_maxpower_tr").style.display = "";
				E("wifiboost_wl_maxpower").innerHTML = maxpwr;
			}else{
				E("wifiboost_wl_maxpower_tr").style.display = "none";
			}
			var wl_ver = response.result.split("@@")[3];
			if (wl_ver){
				E("wifiboost_wl_ver_tr").style.display = "";
				E("wifiboost_wl_ver").innerHTML = wl_ver;
			}else{
				E("wifiboost_wl_ver_tr").style.display = "none";
			}
			setTimeout("get_wl_status();", 2000);
		}
	});
}
function boost_now(action){
	var dbus_new = {};
	if(odm == "GT-AC5300" || odm == "GT-AX11000" || odm == "RT-AX92U"){
		if (E("wifiboost_boost_24").checked == false && E("wifiboost_boost_52").checked == false && E("wifiboost_boost_58").checked == false){
			alert("请至少选择一个你要修改功率的wifi信号！");
			return false;
		}
	}else{
		if (E("wifiboost_boost_24").checked == false && E("wifiboost_boost_52").checked == false){
			alert("请至少选择一个你要修改功率的wifi信号！");
			return false;
		}
	}
	var wb_key = E("wifiboost_key").value;
	if(!wb_key){
		alert("请先购买激活码并输入后再点击激活按钮！");
		return false;
	}
	if (wb_key.indexOf('wb_') == -1){
		alert("请输入正确格式的激活码！");
		return false;
	}
	if(action == 1){
		if(dbus["wifiboost_warn_0"] != "1"){
			if(!confirm('注意：\n检测到首次使用【wifi boost】插件！\n\nwifi boost通过修改机器出厂wlan设置，突破出厂设定的最大发射功率！\n每次修改功率会后都自动重启路由器！才能达到修改效果！\n\n点确定后，将会继续运行插件，并且此弹出消息以后也不再显示。')){
				return false;
			}else{
				dbus_new["wifiboost_warn_0"] = "1";
			}
		}
	}
	if(action == 2){
		if(dbus["wifiboost_warn_1"] != "1"){
			if(!confirm('注意：\n检测到首次使用【恢复原厂功率】按钮！\n\n该功能将机器出厂wlan设置完全恢复至首次使用wifi boost前！\n每次恢复后都自动重启路由器！才能达到效果！\n\n点确定后，将会继续运行该功能，并且此弹出消息以后也不再显示。')){
				return false;
			}else{
				dbus_new["wifiboost_warn_1"] = "1";
			}
		}
	}
	for (var i = 0; i < params_chk.length; i++) {
		dbus_new[params_chk[i]] = E(params_chk[i]).checked ? '1' : '0';
	}
	for (var i = 0; i < params_inp.length; i++) {
		dbus_new[params_inp[i]] = E(params_inp[i]).value;
	}
	if(odm != "GT-AC5300" && odm != "GT-AX11000"){
		dbus_new["wifiboost_boost_58"] = "0";
	}
	// boost_dbm
	if(boost_dbm){
		dbus_new["wifiboost_boost_dbm"] = boost_dbm;
	}else{
		if(action == 1){
			alert("功率值没有任何变化！插件将不会继续运行!\n\n请拉动功率调节条后再使用boost按钮！");
			return false;
		}
	}
	E("wifiboost_apply_1").disabled=true;
	E("wifiboost_apply_2").disabled=true;
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "wifiboost_config", "params": [action], "fields": dbus_new};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			E("wifiboost_apply_1").disabled=false;
			E("wifiboost_apply_2").disabled=false;
			get_log(3);
		}
	});
}
function showWBLoadingBar(){
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
	LoadingWBProgress();
}
function LoadingWBProgress(){
	E("LoadingBar").style.visibility = "visible";
	$("#loading_block2").html("<font color='#ffcc00'>----------------------------------------------------------------------------------------------------------------------------------");
	E("loading_block3").innerHTML = "wifi boost修改最大功率应用中，请稍后 ...";
}

function hideWBLoadingBar(){
	x = -1;
	E("LoadingBar").style.visibility = "hidden";
	if (refresh_flag == "1"){
		refreshpage();
	}
}
function count_down_close() {
	if (x == "0") {
		hideWBLoadingBar();
	}
	if (x < 0) {
		E("ok_button1").value = "手动关闭"
		return false;
	}
	E("ok_button1").value = "自动关闭（" + x + "）"
		--x;
	setTimeout("count_down_close();", 1000);
}
function get_log(flag){
	E("ok_button").style.display = "none";
	showWBLoadingBar();
	$.ajax({
		url: '/_temp/wifiboost_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content3");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", " ");
				E("ok_button").style.display = "";
				retArea.scrollTop = retArea.scrollHeight;
				if(flag == 3){
					location.href = "/Module_wifiboost.asp"
				}else{
					count_down_close();
					return true;
				}
			}
			setTimeout("get_log(" + flag + ");", 200);
			retArea.value = response.replace("XU6J03M6", " ");
			retArea.scrollTop = retArea.scrollHeight;
		},
		error: function(xhr) {
			E("loading_block3").innerHTML = "暂无wifi boost日志信息 ...";
			E("log_content3").value = "日志文件为空，请关闭本窗口！";
			E("ok_button").style.display = "";
			return false;
		}
	});
}
function show_log() {
	x = -1;
	refresh_flag = 0;
	get_log();
	E("ok_button1").value = "关闭日志";
}
function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "wifi boost");
	tablink[tablink.length - 1] = new Array("", "Module_wifiboost.asp");
}
function close_mail_buy(){
	$("#qrcode_show").fadeOut(300);
	open_buy();
}

function open_buy() {
	var current_url = window.location.href;
	net_address = current_url.split("/Module")[0];
	
	note = "<h2><font color='#FF6600'>wifi boost是一款付费插件，价格为30元人民币。</font></h2>"
	note += "<hr>"
	note += "<h3><font color='#22ab39'>微信支付</font>/<font color='#1678ff'>支付宝</font>购买wifi boost为即时激活！</h2>"
	note += "<li>扫码并支付后，会跳转到wifi boost插件页面并自动激活，建议在PC上使用chrome浏览器操作；</li>"
	note += "<li>若购买后跳转到路由器登陆界面，请登陆后重新点击下方<font color='#22ab39'>微信支付</font>/<font color='#1678ff'>支付宝</font>按钮，即可在线激活。</li>"
	note += "<li>如果上一步无法解决，或者购买页面错误，请点击<font color='#FF6600'>人工邮件购买</font>，并根据购买流程进行购买！</li>"
	note += "<li>对于购买、使用有疑问的，可以前往：<a style='color:#22ab39' href='https://koolshare.cn/thread-184369-1-1.html'><u>wifi boost介绍/交流贴</u></a>，和开发者或其他使用者交流！</li>"
	note += "<h4 style='text-align:right'>客服邮箱：<a style='color:#22ab39;' href='mailto:mjy211@gmail.com?subject=wifi boost咨询&body=这是邮件的内容'>mjy211@gmail.com</a> 客服：sadog</h4>"
	require(['/res/layer/layer.js'], function(layer) {
		layer.open({
			type: 0,
			skin: 'layui-layer-lan',
			shade: 0.8,
			title: '请选择wifi boost购买方式！',
			time: 0,
			area: '660px',
			offset: '250px',
			btnAlign: 'c',
			maxmin: true,
			content: note,
			btn: ['微信支付', '支付宝', '人工邮件购买'],
			btn1: function() {
				//window.open("http://47.108.206.248:8083/pay.php?paytype=1&mcode=" + dbus["wifiboost_mcode"].replace(/\+/g, "-") + "&router=" + net_address);
				//layer.closeAll();
				location.href = "http://47.108.206.248:8083/pay.php?paytype=1&mcode=" + dbus["wifiboost_mcode"].replace(/\+/g, "-") + "&router=" + net_address;
			},
			btn2: function() {
				//window.open("http://47.108.206.248:8083/pay.php?paytype=2&mcode=" + dbus["wifiboost_mcode"].replace(/\+/g, "-") + "&router=" + net_address);
				location.href = "http://47.108.206.248:8083/pay.php?paytype=2&mcode=" + dbus["wifiboost_mcode"].replace(/\+/g, "-") + "&router=" + net_address;
			},
			btn3: function() {
				$("#qrcode_show").css("margin-top", "-50px");
				$("#qrcode_show").fadeIn(300);
			},
		});
	});
}

function close_info(){
	$("#activated_info").fadeOut(300);
}
function open_info(){
	$("#activated_info").css("margin-top", "-50px");
	$("#activated_info").fadeIn(300);
}
function pop_help() {
	$("#qrcode_show").fadeOut(300);
	require(['/res/layer/layer.js'], function(layer) {
		layer.open({
			type: 1,
			title: false,
			closeBtn: false,
			area: '600px;',
			offset: '250px',
			shade: 0.8,
			shadeClose: 1,
			scrollbar: false,
			id: 'LAY_layuipro',
			btn: ['返回'],
			btnAlign: 'c',
			moveType: 1,
			content: '<div style="padding: 50px; line-height: 22px; background-color: #393D49; color: #fff; font-weight: 300;">\
				<b>wifi boost</b><br><br>\
				wifi boost是一款付费插件，支持hnd/axhnd/axhnd.675x平台的机器，详情：<a style="color:#e7bd16" target="_blank" href="https://github.com/koolshare/rogsoft#%E6%9C%BA%E5%9E%8B%E6%94%AF%E6%8C%81"><u>机型支持</u></a><br>\
				使用本插件有任何问题，可以前往<a style="color:#e7bd16" target="_blank" href="https://koolshare.cn/forum-98-1.html"><u>koolshare论坛插件板块</u></a>反馈~<br><br>\
				● 微信订单号获取：<span style="color:#e7bd16">我 → 支付 → 钱包 → 账单 → 点击付款订单 → 转账单号</span><br>\
				● 支付宝订单号获取：<span style="color:#e7bd16">我的 → 账单 → 点击付款订单 → 订单号</span><br><br>\
				目前订单处理方式为人工，最长大约需要一个工作日，会通过邮件返回激活码信息。<br>\
				wifi boost的激活码为一机一码，一次激活终身使用。<br>\
				</div>',
			yes: function(index, layero){
				$("#qrcode_show").css("margin-top", "-50px");
				$("#qrcode_show").fadeIn(300);
				layer.close(index);
			}
		});
	});
}
function verifyFields(r) {
	register_event();
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
				<div id="loading_block3" style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;"></div>
				<div id="loading_block2" style="margin:10px auto;width:95%;"></div>
				<div id="log_content2" style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
					<textarea cols="50" rows="25" wrap="off" readonly="readonly" id="log_content3" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Lucida Console'; font-size:11px;background:transparent;color:#FFFFFF;outline: none;padding-left:3px;padding-right:22px;overflow-x:hidden"></textarea>
				</div>
				<div id="ok_button" class="apply_gen" style="background: #000;display: none;">
					<input id="ok_button1" class="button_gen" type="button" onclick="hideWBLoadingBar()" value="确定">
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
								<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
									<tr>
										<td bgcolor="#4D595D" colspan="3" valign="top">
											<div>&nbsp;</div>
											<div id="qrcode_show" class="content_status">
												<div style="text-align: center;margin-top:10px">
													<span id="qrtitle" style="font-size:16px;color:#000;">wifi boost是一款付费插件，价格为30元人民币。</span>
												</div>
												<div id="qrcode" style="width:520px;height:250px;text-align:center;overflow:hidden" >
													<canvas width="520px" height="360px" style="display: none;"></canvas>
													<img style="height:250px" src="https://firmware.koolshare.cn/binary/image_bed/sadog/sadog.png"/>
												</div>
												<div style="margin-top:0px;margin-left:4%;width:96%;text-align:left;">
													<div id="info0" style="font-size:16px;color:#000;"><i>人工邮件购买激活码:</i></div>
													<div id="info1" style="font-size:12px;color:#000;">1.扫描上方其中一个二维码，付款30元人民币给开发者，即可购买wifi boost激活码。</div>
													<div id="info2" style="font-size:12px;color:#000;">2.复制下面文本框内容，替换xxx为<a type="button" href="javascript:void(0);" style="cursor: pointer;color:#FF3300;" onclick="pop_help();"><u>支付订单号</u></a>，发送邮件到：<a id="wifiboost_mail" style="font-size:12px;color:#CC0000;" href="mailto:mjy211@gmail.com?subject=wifi_boost插件购买&body=这是邮件的内容">mjy211@gmail.com</a></div>
													<div id="info3" style="font-size:12px;color:#000;">3.目前订单处理为人工，激活码会在一个工作日左右发送到你的邮箱，请耐心等待。</div>
												</div>
												<div style="margin-top:5px;padding-bottom:10px;margin-left:4%;width:92%;text-align:left;">
													<textarea name="test" id="wifiboost_info" rows="3" cols="50" style="border:1px solid #000;width:96%;font-family:'Lucida Console';font-size:12px;background:transparent;color:#000;outline:none;resize:none;padding-top: 5px;">订单号：xxxx&#10;机器码：xxxxx</textarea>
												</div>
												<div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
													<input class="button_gen" type="button" onclick="pop_help();" value="帮助">
													<input class="button_gen" type="button" onclick="close_mail_buy();" value="返回">
												</div>
											</div>
											<div id="activated_info" class="content_status" style="height:240px;top:150px">
												<div style="text-align: center;margin-top:15px;margin-bottom:15px">
													<span id="qrtitle_1" style="font-size:16px;color:#000;"><i>你的wifi boost插件已经成功激活！</i></span>
												</div>
												<div style="margin-top:0px;margin-left:4%;width:96%;text-align:left;">
													<div id="a_info1" style="font-size:12px;color:#000;">1.使用wifi boost有任何问题，可以前往<a style="color:#e7bd16" target="_blank" href="https://koolshare.cn/forum-98-1.html"><u>koolshare论坛插件板块</u></a>反馈。</div>
													<div id="a_info2" style="font-size:12px;color:#000;">2.如果激活码遗失，请尝试重装插件找回，或者发送机器码到：<a id="wifiboost_a_mail" style="font-size:12px;color:#CC0000;" href="mailto:mjy211@gmail.com?subject=wifi boost插件购买&body=这是邮件的内容">mjy211@gmail.com</a>寻回。</div>
													<div id="a_info3" style="font-size:12px;color:#000;">3.以下是你的机器码，激活码相关信息，请妥善保管。</div>
												</div>
												<div style="margin-top:5px;padding-bottom:10px;margin-left:4%;width:92%;text-align:left;">
													<textarea name="test" id="wifiboost_a_info" rows="3" cols="50" style="border:1px solid #000;width:96%;font-family:'Lucida Console';font-size:12px;background:transparent;color:#000;outline:none;resize:none;padding-top: 5px;">机器码：xxxx&#10;激活码：xxxx</textarea>
												</div>
												<div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
													<input class="button_gen" type="button" onclick="close_info();" value="关闭">
												</div>
											</div>
											<div class="formfonttitle">wifi boost<lable id="wifiboost_version"><lable></div>
											<div style="float:right; width:15px; height:25px;margin-top:-20px">
												<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
											</div>
											<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
											<div class="SimpleNote">
												<span>wifi boost可以极大的增强路由器wifi的发射功率，增强信号覆盖范围。
													<a type="button" href="https://koolshare.cn/thread-184369-1-1.html" target="_blank" class="ks_btn" style="cursor: pointer;margin-left:5px;border:none" >使用交流</a>
													<a type="button" href="https://github.com/koolshare/rogsoft/blob/master/wifiboost/Changelog.txt" target="_blank" class="ks_btn" style="cursor: pointer;margin-left:5px;border:none" >更新日志</a>
												</span>
											</div>
											<div id="wifiboost_main">
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
												<thead>
													<tr>
														<td colspan="2">wifi boost 设定</td>
													</tr>
												</thead>
												<tr>
													<th>固件版本</th>
													<td id="wifiboost_ver"></td>
													<script type="text/javascript">
														var MODEL = '<% nvram_get("odmpid"); %>' || '<% nvram_get("productid"); %>';
														var BUILD = '<% nvram_get("buildno"); %>'
														var FWVER = '<% nvram_get("extendno"); %>';
														if (FWVER.indexOf('koolshare') != -1){
															$("#wifiboost_ver").html(MODEL + "&nbsp;&nbsp;" + BUILD + "_" + FWVER + "&nbsp;&nbsp;官改固件");
														}else{
															$("#wifiboost_ver").html(MODEL + "&nbsp;&nbsp;" + BUILD + "&nbsp;&nbsp;梅林改版固件");
														}
													</script>
												</tr>
												<tr>
													<th>网卡温度</th>
													<td><span id="wifiboost_wl_temperature"></span></td>
												</tr>
												<tr>
													<th>当前wifi区域</th>
													<td><span id="wifiboost_location"></span></td>
												</tr>
												<tr id="wifiboost_wl_power_tr" style="display: none;">
													<th>当前发射功率</th>
													<td><span id="wifiboost_wl_power"></span></td>
												</tr>
												<tr id="wifiboost_wl_maxpower_tr">
													<th>最大支持发射功率（澳大利亚）</th>
													<td><span id="wifiboost_wl_maxpower"></span></td>
												</tr>
												<tr id="wifiboost_wl_ver_tr" style="display: none;">
													<th>无线驱动</th>
													<td><span id="wifiboost_wl_ver"></span></td>
												</tr>
												<tr>
													<th>wifi boost激活码</th>
													<td>
														<input type="password" maxlength="100" id="wifiboost_key" class="input_ss_table" style="width:340px;font-size: 95%;" readonly onblur="switchType(this, false);" onfocus="switchType(this, true);this.removeAttribute('readonly');" autocomplete="new-password" autocorrect="off" autocapitalize="off" spellcheck="false" >
														<button id="wifiboost_active_btn" onclick="boost_now(3);" class="wifiboost_btn" style="width:50px;cursor:pointer;vertical-align: middle;">激活</button>
														<button id="wifiboost_buy_btn" onclick="open_buy();" class="wifiboost_btn" style="width:80px;cursor:pointer;vertical-align: middle;">购买激活码</button>
														<button id="wifiboost_authorized_btn" onclick="open_info();" class="wifiboost_btn" style="width:80px;cursor:pointer;vertical-align: middle;">已激活</button>
													</td>
												</tr>
												<tr>
													<th>功率调节</th>
													<td>
														<div>
															<table>
																<tr>
																	<td style="border:0px;padding-left:0px;">
																		<input type="checkbox" id="wifiboost_boost_24" onchange="verifyFields(this, 1);" style="vertical-align: middle;" checked=true /><lable id="LABLE_24">2.4G</lable>
																		<input type="checkbox" id="wifiboost_boost_52" onchange="verifyFields(this, 1);" style="vertical-align: middle;" checked=true /><lable id="LABLE_52">5G</lable>
																		<input type="checkbox" id="wifiboost_boost_58" onchange="verifyFields(this, 1);" style="vertical-align: middle;display: none" checked=true /><lable id="LABLE_58" style="display: none;">5G-2</lable>
																	</td>									
																	<td style="border:0px;padding-left:8px;">
																		<div id="slider" style="width:220px;"></div>
																	</td>									
																	<td style="border:0px;width:60px;">
																		<div id="tx_power_desc" style="width:150px;font-size:14px;"></div>
																	</td>					
																</tr>
															</table>
														</div>
													</td>
												</tr>
											</table>
											</div>
											<div class="apply_gen">
												<input class="button_gen" id="wifiboost_apply_1" onClick="boost_now(1)" type="button" value="boost" />
												<input class="button_gen" id="wifiboost_apply_2" onClick="boost_now(2)" type="button" value="恢复原厂功率" />
												<input class="button_gen" id="wifiboost_apply_3" onClick="show_log()" type="button" value="显示日志" />
											</div>
											<div id="warning" style="font-size:14px;margin:20px auto;"></div>
											<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
											<div class="SimpleNote">
												<li id="msg1">wifi boost通过修改机器出厂wlan设置，突破出厂设定的最大发射功率，须知修改出厂wlan设置有风险，由此带来的风险请自行承担！</li>
												<li id="msg2">更高的发射功率可能影响速率、稳定性等，甚至有烧功放的风险，请勿盲目追求过高的发射功率，建议设定不超过27.00dBm！</li>
												<li id="msg3">虽然插件可以保证修改过程相对安全，但还是强烈建议不要过于频繁的进行修改，以免发生意外导致机器wlan出厂设置被损坏。</li>
												<li id="msg4">修改后需要将wifi区域更改为澳大利亚才会有效果，非澳大利亚的功率和修改前一样。如果修改后功率未起作用，请重置一次路由。</li>
												<li id="msg5">修改完成后，卸载wifi boost插件、升级固件版本、刷三方固件/原厂固件等操作均会保持最后一次的功率修改效果。</li>
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
