<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html xmlns:v>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<title>软件中心 - wifi boost</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/> 
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/res/softcenter.css">
<link rel="stylesheet" type="text/css" href="/res/layer/theme/default/layer.css">
<script type="text/javascript" src="/res/Browser.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/res/jquery-ui.js"></script> 
<style>
#app[skin=ASUSWRT] .wifiboost_btn {
	border: 1px solid #222;
	background: linear-gradient(to bottom, #003333  0%, #000000 100%);
	font-size:10pt;
	color: #fff;
	padding: 5px 5px;
	border-radius: 5px 5px 5px 5px;
	width:14%;
}
#app[skin=ASUSWRT] .wifiboost_btn:hover {
	border: 1px solid #222;
	background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%);
	font-size:10pt;
	color: #fff;
	padding: 5px 5px;
	border-radius: 5px 5px 5px 5px;
	width:14%;
}
#app[skin=ROG] .wifiboost_btn {
	border: 1px solid #222;
	background: linear-gradient(to bottom, #91071f  0%, #700618 100%);
	font-size:10pt;
	color: #fff;
	padding: 5px 5px;
	border-radius: 5px 5px 5px 5px;
	width:14%;
}
#app[skin=ROG] .wifiboost_btn:hover {
	border: 1px solid #222;
	background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%);
	font-size:10pt;
	color: #fff;
	padding: 5px 5px;
	border-radius: 5px 5px 5px 5px;
	width:14%;
}
#app[skin=TUF] .wifiboost_btn {
	border: 1px solid #222;
	background: linear-gradient(to bottom, #92650F  0%, #74500b 100%);
	font-size:10pt;
	color: #fff;
	padding: 5px 5px;
	border-radius: 5px 5px 5px 5px;
	width:14%;
}
#app[skin=TUF] .wifiboost_btn:hover {
	border: 1px solid #222;
	background: linear-gradient(to bottom, #c58813  0%, #92650F 100%);
	font-size:10pt;
	color: #fff;
	padding: 5px 5px;
	border-radius: 5px 5px 5px 5px;
	width:14%;
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
	top: 140px;
	return height:auto;
	box-shadow: 3px 3px 10px #000;
	background: #fff;
	margin-left:60px;
	width:520px;
	height:500px;
	display: none;
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

#app[skin=ASUSWRT] .ui-widget-content {
	background-color:#000;
}
#app[skin=ROG] .ui-widget-content {
	background-color:#626262;
}
#app[skin=TUF] .ui-widget-content {
	background-color:#fff;
}
.ui-state-default,
.ui-widget-content .ui-state-default,
.ui-widget-header .ui-state-default {
	border: 1px solid ;
	background: #e6e6e6;
	margin-top:-4px;
	margin-left:-6px;
}
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
#app[skin=ASUSWRT] #slider24 .ui-slider-range, #app[skin=ASUSWRT] #slider52 .ui-slider-range, #app[skin=ASUSWRT] #slider58 .ui-slider-range {
	background: #93E7FF; 
	border-top-left-radius: 3px;
	border-top-right-radius: 1px;
	border-bottom-left-radius: 3px;
	border-bottom-right-radius: 1px;
}
#app[skin=ASUSWRT] #slider24 .ui-slider-handle, #app[skin=ASUSWRT] #slider52 .ui-slider-handle, #app[skin=ASUSWRT] #slider58 .ui-slider-handle {
	border-color: #93E7FF;
}
#app[skin=ROG] #slider24 .ui-slider-range, #app[skin=ROG] #slider52 .ui-slider-range, #app[skin=ROG] #slider58 .ui-slider-range {
	background: #93E7FF; 
	border-top-left-radius: 3px;
	border-top-right-radius: 1px;
	border-bottom-left-radius: 3px;
	border-bottom-right-radius: 1px;
}
#app[skin=ROG] #slider24 .ui-slider-handle, #app[skin=ROG] #slider52 .ui-slider-handle, #app[skin=ROG] #slider58 .ui-slider-handle {
	border-color: #93E7FF;
}
#app[skin=TUF] #slider24 .ui-slider-range, #app[skin=TUF] #slider52 .ui-slider-range, #app[skin=TUF] #slider58 .ui-slider-range {
	background: #d0982c; 
	border-top-left-radius: 3px;
	border-top-right-radius: 1px;
	border-bottom-left-radius: 3px;
	border-bottom-right-radius: 1px;
}
#app[skin=TUF] #slider24 .ui-slider-handle, #app[skin=TUF] #slider52 .ui-slider-handle, #app[skin=TUF] #slider58 .ui-slider-handle {
	border-color: #d0982c;
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
	/*background: url(/images/New_ui/login_bg.png);*/
	background:rgba(68, 79, 83, 0.85) none repeat scroll 0 0 !important;
	background-position: 0 0;
	background-size: cover;
	opacity: .94;
}
.loadingBarBlock{
	width:740px;
}
.loading_block_spilt {
    background: #656565;
    height: 1px;
    width: 98%;
}
</style>
<script>
var MODEL = '<% nvram_get("odmpid"); %>' || '<% nvram_get("productid"); %>';
var BUILD = '<% nvram_get("buildno"); %>'
var FWVER = '<% nvram_get("extendno"); %>';
var RC_SUPPORT = '<% nvram_get("rc_support"); %>';
var orig_region = '<% nvram_get("location_code"); %>';
var odm = '<% nvram_get("productid"); %>'
var params_chk = ['wifiboost_boost_24', 'wifiboost_boost_52', 'wifiboost_boost_58'];
var params_inp = ['wifiboost_key'];
var max_dbm_24 = '28.50';
var max_dbm_52 = '28.50';
var max_dbm_58 = '28.50';
if(odm == "GT10"){
	max_dbm_24 = '29.00';
}
if(odm == "RT-BE88U"){
	max_dbm_24 = '30.00';
var max_dbm_52 = '30.00';
}
var boost_dbm_24;
var boost_dbm_52;
var boost_dbm_58;
var current_maxp24;
var current_maxp52;
var current_maxp58;
var current_dec_24;
var current_dec_52;
var current_dec_58;
var current_dbm_24;
var current_dbm_52;
var current_dbm_58;
var current_pwr_24;
var current_pwr_52;
var current_pwr_58;
var	refresh_flag;
var count_down;
var asus = 0;
var dbus;
var pay_server = '42.192.18.234';
var pay_port = '8083';
var online_ver;
String.prototype.myReplace = function(f, e){
	var reg = new RegExp(f, "g"); 
	return this.replace(reg, e); 
}
function init() {
	show_menu(menu_hook);
	detect_brower();
}
function detect_brower() {
	var info = new Browser();
	console.log("您使用的浏览器为：", info.browser);
	if(info.device!='Mobile'){
		if (info.browser == "360EE"){
			$("#wifiboost_main").hide();
			$("#wifiboost_apply_1").hide();
			$("#wifiboost_apply_2").hide();
			$("#wifiboost_apply_3").hide();
			$(".SimpleNote").hide();
			$('#warn_msg_1').html('<h1><font color="#FF6600">错误！</font></h1><h2><font color="#FF6666">360浏览器/IE</font>下使用【wifi boost】插件会出现兼容性问题！<h2>为了保证使用本插件的最佳使用体验:</h2><h2>建议使用<em>谷歌chrome浏览器</em>或者其它<em>Chromium内核</em>的浏览器！</h2>');
			$("#warn_msg_1").show();
			return false;
		}
	}
	var current_url = window.location.href;
	var net_address = current_url.split("/Module")[0];
	var port = net_address.split(":")[2];
	//console.log(port);
	if(port && port != "80" && asus == "1"){
		$("#wifiboost_main").hide();
		$("#wifiboost_apply_1").hide();
		$("#wifiboost_apply_2").hide();
		$("#wifiboost_apply_3").hide();
		$(".SimpleNote").hide();
		$('#warn_msg_1').html('<h1><font color="#FF6600">哦豁！</font></h1><h2>目前<font color="#3399FF">华硕官方固件 / 梅林原版固件</font>安装的插件在https下暂时不可用~<h2>建议先使用http访问路由器后台，以便使用插件。</h2><h2>你也可以关注 <a href="https://koolshare.cn"><font color="#00CC66">https://koolshare.cn</font></a> 论坛，看下插件是否更新了https下能使用的版本！</h2>');
		$("#warn_msg_1").show();
		return false;
	}
	write_location();
	show_hide_elem();
	get_wl_status();
	get_dbus_data();
	try_activate();
	get_pay_server();
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
	var web_key = getQueryVariable("key");
	var local_key = $("#wifiboost_key").val();
	if(local_key){
		var newURL = location.href.split("?")[0];
		window.history.pushState('object', document.title, newURL);
		return true;
	}else{
		if(web_key){
			console.log("有激活码: ", web_key)
			$("#wifiboost_key").val(web_key);
			boost_now(3);
		}		
	}
}
function register_event(){
	var current_maxp24_tmp = '<% nvram_get("0:maxp2ga0"); %>';
	if(odm == "GT-AC5300" || odm == "GT-AX11000" || odm == "GT-AX11000_BO4" || odm == "RT-AX92U" || odm == "RT-AX95Q" || odm == "RT-AC5300" || odm == "XT12" || odm == "ET12" || odm == "GT-AXE11000" || odm == "GT10"){
		// three wifi router
		if(!current_maxp24_tmp){
			current_maxp24 = '<% nvram_get("1:maxp2ga0"); %>';
			current_maxp52 = '<% nvram_get("2:maxp5gb0a0"); %>';
			current_maxp58 = '<% nvram_get("3:maxp5gb0a0"); %>';
		}else{
			current_maxp24 = '<% nvram_get("0:maxp2ga0"); %>';
			current_maxp52 = '<% nvram_get("1:maxp5gb0a0"); %>';
			current_maxp58 = '<% nvram_get("2:maxp5gb0a0"); %>';
		}
	}else if(odm == "GT-AX11000_PRO"){
		current_maxp24 = '<% nvram_get("3:maxp2ga0"); %>';
		current_maxp52 = '<% nvram_get("4:maxp5gb0a0"); %>';
		current_maxp58 = '<% nvram_get("1:maxp5gb0a0"); %>';
	}else if(odm == "RT-AX55" || odm == "RT-AX56U" || odm == "TUF-AX3000_V2"){
		// two wifi router new format
		current_maxp24 = '<% nvram_get("sb/0/maxp2ga0"); %>';
		current_maxp52 = '<% nvram_get("sb/1/maxp5gb0a0"); %>';
	}else{
		// two wifi router old format
		if(!current_maxp24_tmp){
			current_maxp24 = '<% nvram_get("1:maxp2ga0"); %>';
			current_maxp52 = '<% nvram_get("2:maxp5gb0a0"); %>';
		}else{
			current_maxp24 = '<% nvram_get("0:maxp2ga0"); %>';
			current_maxp52 = '<% nvram_get("1:maxp5gb0a0"); %>';
		}
	}
	if(MODEL == "RAX50"){
		current_maxp24 = '<% nvram_get("sb/0/maxp2ga0"); %>';
		current_maxp52 = '<% nvram_get("1:maxp5gb0a0"); %>';
	}

	// define max dbm
	current_dec_24 = parseInt(current_maxp24);
	if(MODEL == "RT-BE88U"){
		current_dbm_24 = (current_dec_24/4).toFixed(2);
		current_pwr_24 = Math.pow(10,current_dec_24/4/10).toFixed(2);
	}else{
		current_dbm_24 = ((current_dec_24 - 6)/4).toFixed(2);
		current_pwr_24 = Math.pow(10,(current_dec_24 - 6)/4/10).toFixed(2);
	}
	boost_dbm_24 = current_dbm_24;
	$(function() {
		$( "#slider24" ).slider({
			orientation: "horizontal",
			range: "min",
			min: 20.00,
			max: max_dbm_24,
			value: current_dbm_24,
			step: 0.25,
			slide:function(event, ui){
				dbm = ui.value.toFixed(2);
				var power_24 = Math.pow(10,ui.value/10).toFixed(2);
				document.getElementById('tx_power_desc_24').innerHTML = ui.value.toFixed(2) + " dBm / " + power_24 + " mw";
			},
			stop:function(event, ui){
				boost_dbm_24 = ui.value;
			},
		}); 
	});
	document.getElementById('tx_power_desc_24').innerHTML = current_dbm_24 + " dBm / " + current_pwr_24 + " mw";

	current_dec_52 = parseInt(current_maxp52);
	if(MODEL == "RT-BE88U"){
		current_dbm_52 = (current_dec_52/4).toFixed(2);
		current_pwr_52 = Math.pow(10,current_dec_52/4/10).toFixed(2);
	}else{
		current_dbm_52 = ((current_dec_52 - 6)/4).toFixed(2);
		current_pwr_52 = Math.pow(10,(current_dec_52 - 6)/4/10).toFixed(2);
	}

	boost_dbm_52 = current_dbm_52;
	$(function() {
		$( "#slider52" ).slider({
			orientation: "horizontal",
			range: "min",
			min: 20.00,
			max: max_dbm_52,
			value: current_dbm_52,
			step: 0.25,
			slide:function(event, ui){
				var dbm = ui.value.toFixed(2);
				var power_52 = Math.pow(10,ui.value/10).toFixed(2);
				document.getElementById('tx_power_desc_52').innerHTML = ui.value.toFixed(2) + " dBm / " + power_52 + " mw";
			},
			stop:function(event, ui){
				boost_dbm_52 = ui.value;
			},
		}); 
	});
	document.getElementById('tx_power_desc_52').innerHTML = current_dbm_52 + " dBm / " + current_pwr_52 + " mw";

	if (current_maxp58){
		current_dec_58 = parseInt(current_maxp58);
		current_dbm_58 = ((current_dec_58 - 6)/4).toFixed(2);
		current_pwr_58 = Math.pow(10,(current_dec_58 - 6)/4/10).toFixed(2);
		boost_dbm_58 = current_dbm_58;
		$(function() {
			$( "#slider58" ).slider({
				orientation: "horizontal",
				range: "min",
				min: 20.00,
				max: max_dbm_58,
				value: current_dbm_58,
				step: 0.25,
				slide:function(event, ui){
					var dbm = ui.value.toFixed(2);
					var power_58 = Math.pow(10,ui.value/10).toFixed(2);
					document.getElementById('tx_power_desc_58').innerHTML = ui.value.toFixed(2) + " dBm / " + power_58 + " mw";
				},
				stop:function(event, ui){
					boost_dbm_58 = ui.value;
				},
			}); 
		});
		document.getElementById('tx_power_desc_58').innerHTML = current_dbm_58 + " dBm / " + current_pwr_58 + " mw";	
	}
	
	$(".popup_bar_bg_ks").click(
		function() {
			count_down = -1;
		});	
	$(window).resize(function(){
		if($('.popup_bar_bg_ks').css("visibility") == "visible"){
			document.scrollingElement.scrollTop = 0;
			var page_h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
			var page_w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
			var log_h = E("loadingBarBlock").clientHeight;
			var log_w = E("loadingBarBlock").clientWidth;
			var log_h_offset = (page_h - log_h) / 2;
			var log_w_offset = (page_w - log_w) / 2 + 90;
			$('#loadingBarBlock').offset({top: log_h_offset, left: log_w_offset});
		}
	});
}
function show_hide_elem(){
	if(odm == "GT-AC5300" || odm == "GT-AX11000" || odm == "GT-AX11000_BO4" || odm == "RT-AX92U" || odm == "RT-AX95Q" || odm == "RT-AC5300" || odm == "XT12" || odm == "ET12" || odm == "GT-AXE11000" || odm == "GT-AX11000_PRO" || odm == "GT10"){
		E("wifiboost_boost_58_tr").style.display = "";
		E("LABLE_58").style.display = "";
		E("LABLE_52").innerHTML = "5G-1";
	}
	if(MODEL == "RAX80"){
		E("msg1").style.display = "none";
		E("msg3").style.display = "none";
		E("msg5").innerHTML = "修改完成后，卸载wifi boost插件、重置/双清固件、升级固件版本（梅林）、等操作均会保持最后一次的功率修改效果。";
		E("msg6").innerHTML = "但是由于RAX80为移植机型，在刷回网件后将失去boost效果，再刷回梅林固件后，需要重新安装插件再进行一次boost操作。";
	}else if(MODEL == "RAX50"){
		E("msg1").style.display = "none";
		E("msg3").style.display = "none";
		E("msg5").innerHTML = "修改完成后，卸载wifi boost插件、重置/双清固件、升级梅林/网件远程固件、等操作均会保持最后一次的功率修改效果。";
		E("msg6").innerHTML = "虽然RAX50为梅林移植机型，但是即使其刷回网件原厂固件后再刷回梅林固件，其wifi boost的修改效果也不会丢失！";
	} else if(MODEL == "GT6"){
		E("msg1").style.display = "";
		E("msg3").style.display = "";
		E("msg6").innerHTML = "ROG魔方 • 幻，即GT6，该机型的2.4G wifi在澳大利亚状态下已经是最高值29dbm，属于出厂灰烬无法再提高了，不过其余两个5G频段均能提高到28.5dbm";
	} else {
		E("msg1").style.display = "";
		E("msg3").style.display = "";
		E("msg6").style.display = "none";
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
		E("wifiboost_version").innerHTML = " - " + dbus["wifiboost_version"];
	}
	if (dbus["wifiboost_mcode"] && dbus["wifiboost_key"]){
		E("wifiboost_a_info").innerHTML = "机器码：" +  dbus["wifiboost_mcode"] + "&#10;激活码：" + dbus["wifiboost_key"];
		E("wifiboost_a_mail").href = "mailto:mjy211@gmail.com?subject=wifi boost插件购买&body=我的wifiboost插件就激活码遗失了，需要找回！%0d%0a机器码：" +  dbus["wifiboost_mcode"];
	} else if (dbus["wifiboost_mcode"] && !dbus["wifiboost_key"]) {
		E("wifiboost_info").innerHTML = "订单号：xxx&#10;机器码：" +  dbus["wifiboost_mcode"];
		E("wifiboost_mail").href = "mailto:mjy211@gmail.com?subject=wifi boost插件购买&body=订单号：xxx%0d%0a机器码：" +  dbus["wifiboost_mcode"];
	}
	if (!dbus["wifiboost_mcode"]){
		if(!dbus["wifiboost_warn"]){
			dbus["wifiboost_warn"] = "8";
		}
		E("wifiboost_buy_btn").style.display = "none";
		E("wifiboost_active_btn").style.display = "none";
		E("wifiboost_authorized_btn").style.display = "none";
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
			err_mesg = '<br/><span style="color: #CC3300">错误代码1：' + MODEL + '在当前固件版本下不支持wifiboost插件，请升级至最新的386梅林改版固件后以获取支持！</span><br/><br>';
		break;
		case "2":
			err_mesg = '<br/><span style="color: #CC3300">错误代码2：当前路由不支持wifiboost插件！请尝试重刷正确的固件后重试！！</span><br/><br>';
		break;
		case "3":
			err_mesg = '<br/><span style="color: #CC3300">错误代码3：读取wlan硬件设备数量错误！请重启或重置路由器后重试！！<br/>可能是错误的nvram值导致的！请尝试重置路由器后重试！！</span><br/><br>';
		break;
		case "4":
			err_mesg = '<br/><span style="color: #CC3300">错误代码4：读取原厂wlan配置失败，重启或重置路由器后重试！！</span><br/><br>';
		break;
		case "5":
			err_mesg = '<br/><span style="color: #CC3300">错误代码5：读取原厂wlan配置失败，重启或重置路由器后重试！！</span><br/><br>';
		break;
		case "6":
			err_mesg = '<br/><span style="color: #CC3300">错误代码6：检测到你的路由器不是国行机器！！</span><hr>非国行机器因【无线网络】-【专业设置】中没有澳大利亚区域选项，从而使得插件无法发挥作用！！<br/>如果你需要将机器刷成国行，可以使用【CFE工具箱】，即可将路由器改为国行！<br/><br/>CFE工具箱安装方法如下：<br/>1. 带软件中心的固件，请下载<a style="color: #1678ff" href="https://rogsoft.ddnsto.com/cfetool/cfetool.tar.gz">CFE工具箱离线安装包</a>后离线安装后<br/>2. 无软件中心的【华硕官方/梅林原版】固件请参考<a style="color: #1678ff" target="_blank" href="https://github.com/koolshare/rogsoft/tree/master/cfetool#cfe%E5%B7%A5%E5%85%B7%E7%AE%B1">CFE工具箱文档</a>进行安装！<br/><hr>';
		break;
		case "7":
			err_mesg = '<br/><span style="color: #CC3300">错误代码7：检测到你的路由器出厂配置有误！！</span><br/><br>';
		break;
		case "8":
			err_mesg = '<br/><span style="color: #CC3300">错误代码8：无法购买！因为检测到插件安装有问题，请尝试卸载并重装插件后再试！</span><br/><br>';
		break;
		case "9":
			err_mesg = '<br/><span style="color: #CC3300">错误代码9：' + MODEL + '当前暂时不支持wifi boost插件！</span><br/><br>';
		break;
	}
	require(['/res/layer/layer.js'], function(layer) {
		layer.alert('<span style="font-size: 18px;">wifi boost插件检测到错误！错误信息如下：</span><br/>' + err_mesg + '出现错误提示意味着你可能无法使用wifi boost修改最大功率。<br/>点击确定将关闭此窗口，如果错误未解决，此窗口下次还会和你相见！', {
			time: 3e4,
			shade: 0.8,
			maxWidth: '800px'
		}, function(index) {
			layer.close(index);
			return false;
		});
	});
}
function get_wl_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "wifiboost_status.sh", "params":[2], "fields": ""};
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
			setTimeout("get_wl_status();", 8000);
		}
	});
}
function boost_now(action){
	var dbus_new = {};
	var current_url = window.location.href;
	net_address = current_url.split("/Module")[0];
	if(odm == "GT-AC5300" || odm == "GT-AX11000" || odm == "GT-AX11000_BO4" || odm == "RT-AX92U" || odm == "RT-AX95Q" || odm == "RT-AC5300"  || odm == "XT12" || odm == "ET12" || odm == "GT-AXE11000" || odm == "GT10"){
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
	if(action == 3 && wb_key.indexOf('wifiboost-') != -1){
		if(wb_key.length == "46" && wb_key.myReplace("-", "").length == "41"){

			msg = '';
			msg += '<span style="font-size: 18px;">你正在使用兑换码进行激活</span>';
			msg += '<br/>';
			msg += '<br/>';
			msg += '兑换码：<span style="color: #CC3300">' + wb_key + '</span>';
			msg += '<br/>';
			msg += '<br/>';
			msg += '提示：一个兑换码只能用于一台路由器的wifi boost激活；';
			msg += '<br/>';
			msg += '点击立即激活，你将会获得wifi boost激活码，同时兑换码将会失效。';
			
			require(['/res/layer/layer.js'], function(layer) {
				layer.confirm(msg, {
					btn: ['立即激活', '取消'],
					shade: 0.8,
					maxWidth: '600px'
				}, function(index) {
					layer.close(index);
					location.href = "http://" + pay_server + ":" + pay_port + "/pay.php?paytype=3&uuid=" + wb_key + "&mcode=" + dbus["wifiboost_mcode"].replace(/\+/g, "-") + "&router=" + net_address;
					return true;
				});
			});
			E("wifiboost_key").value = "";
			return true;
		}else{
			E("wifiboost_key").value = "";
			alert("请输入正确格式的兑换码！");
			return false;
		}
	}
	if (wb_key.indexOf('wb_') == -1){
		E("wifiboost_key").value = "";
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
	if(boost_dbm_24){
		dbus_new["wifiboost_boost_dbm_24"] = boost_dbm_24;
	}
	if(boost_dbm_52){
		dbus_new["wifiboost_boost_dbm_52"] = boost_dbm_52;
	}
	if(boost_dbm_58){
		dbus_new["wifiboost_boost_dbm_58"] = boost_dbm_58;
	}
	if(boost_dbm_24 == current_dbm_24 && boost_dbm_52 == current_dbm_52 && boost_dbm_58 == current_dbm_58){
		if(action == 1){
			alert("功率值没有任何变化！插件将不会继续运行!\n\n请拉动功率调节条后再使用boost按钮！");
			return false;
		}
	}
	E("wifiboost_apply_1").disabled = true;
	E("wifiboost_apply_2").disabled = true;
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "wifiboost_config.sh", "params": [action], "fields": dbus_new};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			E("wifiboost_apply_1").disabled=false;
			E("wifiboost_apply_2").disabled=false;
			get_log();
		}
	});
}
function showWBLoadingBar(){
	document.scrollingElement.scrollTop = 0;
	E("loading_block_title").innerHTML = "wifi boost 运行中，请稍后 ...";
	E("LoadingBar").style.visibility = "visible";
	var page_h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	var page_w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	var log_h = E("loadingBarBlock").clientHeight;
	var log_w = E("loadingBarBlock").clientWidth;
	var log_h_offset = (page_h - log_h) / 2;
	var log_w_offset = (page_w - log_w) / 2 + 90;
	$('#loadingBarBlock').offset({top: log_h_offset, left: log_w_offset});
}
function hideWBLoadingBar(){
	E("LoadingBar").style.visibility = "hidden";
	E("ok_button").style.visibility = "hidden";
	if (refresh_flag == "1"){
		var newURL = location.href.split("?")[0];
		window.history.pushState('object', document.title, newURL);
		refreshpage();
	}
}
function count_down_close() {
	if (count_down == "0") {
		hideWBLoadingBar();
	}
	if (count_down < 0) {
		E("ok_button1").value = "手动关闭"
		return false;
	}
	E("ok_button1").value = "自动关闭（" + count_down + "）"
		--count_down;
	setTimeout("count_down_close();", 1000);
}
function get_log(flag){
	E("ok_button").style.visibility = "hidden";
	showWBLoadingBar();
	$.ajax({
		url: '/_temp/wifiboost_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.myReplace("XU6J03M6", " ");
				E("ok_button").style.visibility = "visible";
				retArea.scrollTop = retArea.scrollHeight;
				if(flag == 1){
					count_down = -1;
					refresh_flag = 0;
				}else{
					count_down = 6;
					refresh_flag = 1;
				}
				count_down_close();
				return false;
			}
			setTimeout("get_log(" + flag + ");", 200);
			retArea.value = response.myReplace("XU6J03M6", " ");
			retArea.scrollTop = retArea.scrollHeight;
		},
		error: function(xhr) {
			E("loading_block_title").innerHTML = "暂无wifi boost日志信息 ...";
			E("log_content").value = "日志文件为空，请关闭本窗口！";
			E("ok_button").style.visibility = "visible";
			return false;
		}
	});
}
function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "wifi boost");
	tablink[tablink.length - 1] = new Array("", "Module_wifiboost.asp");
}
function ValidateIPaddress(ipaddress) {  
	if (/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(ipaddress)) {  
		return ipaddress;
	}
}
function versionCompare(v1, v2, options) {
	var lexicographical = options && options.lexicographical,
		zeroExtend = options && options.zeroExtend,
		v1parts = v1.split('.'),
		v2parts = v2.split('.');
	function isValidPart(x) {
		return (lexicographical ? /^\d+[A-Za-z]*$/ : /^\d+$/).test(x);
	}
	if (!v1parts.every(isValidPart) || !v2parts.every(isValidPart)) {
		return NaN;
	}
	if (zeroExtend) {
		while (v1parts.length < v2parts.length) v1parts.push("0");
		while (v2parts.length < v1parts.length) v2parts.push("0");
	}
	if (!lexicographical) {
		v1parts = v1parts.map(Number);
		v2parts = v2parts.map(Number);
	}
	for (var i = 0; i < v1parts.length; ++i) {
		if (v2parts.length == i) {
			return true;
		}
		if (v1parts[i] == v2parts[i]) {
			continue;
		} else if (v1parts[i] > v2parts[i]) {
			return true;
		} else {
			return false;
		}
	}
	if (v1parts.length != v2parts.length) {
		return false;
	}
	return false;
}
function get_pay_server() {
	$.ajax({
		url: 'https://rogsoft.ddnsto.com/wifiboost/config.json.js',
		type: 'GET',
		dataType: 'jsonp',
		success: function(res) {
			pay_server = ValidateIPaddress(res.server) || pay_server;
			pay_port = res.port || pay_port;
			online_ver = res.version;
			if (res["version"]) {
				if (versionCompare(res["version"], dbus["wifiboost_version"])) {
					E("wifiboost_o_version").innerHTML = "&nbsp;&nbsp;&nbsp;&nbsp;<em>有新版本: " + res["version"] + "</em>";
				}
			}
		}
	});
}
function close_mail_buy(){
	$("#qrcode_show").fadeOut(300);
	open_buy();
}

function open_buy() {
	var current_url = window.location.href;
	net_address = current_url.split("/Module")[0];
	
	note = "<h2><font color='#FF6600'>【wifi boost】是一款付费插件，价格为30元人民币。</font></h2>";
	note += "<hr>";
	note += "<h3>选择 <font color='#22ab39'>微信支付</font> / <font color='#1678ff'>支付宝</font> 购买，可以即时激活【wifi boost】！</h3>";
	note += "<h5><li>建议在PC上使用chrome浏览器进行购买、激活操作，以免出现未知问题；</li>";
	note += "<li>扫码支付后，会立即跳转到激活码发放页面，根据页面提示即可激活插件；</li>";
	note += "<li>如遇到无法支付、无法获得激活码等问题，可以联系下方客服邮箱解决。</li></h5>";
	note += "<h4 style='text-align:right'>客服邮箱：<a style='color:#22ab39;' href='mailto:mjy211@gmail.com?subject=wifi boost咨询&body=这是邮件的内容'>mjy211@gmail.com</a></h4>";
	//note += "<h5>如果你已经有<font color='#FF6600'>wifiboost-xxx-xxx-xxx-xxx-xxx</font>形式的兑换码，请跳过支付流程，直接在激活码栏内输入兑换码即可获得激活码。</h5>";
	require(['/res/layer/layer.js'], function(layer) {
		layer.open({
			type: 0,
			skin: 'layui-layer-lan',
			shade: 0.8,
			title: '请选择【wifi boost】购买方式！',
			time: 0,
			area: '540px',
			offset: '250px',
			btnAlign: 'c',
			maxmin: true,
			content: note,
			btn: ['微信支付', '支付宝', '人工邮件购买'],
			btn1: function() {
				location.href = "http://" + pay_server + ":" + pay_port + "/pay.php?paytype=1&mcode=" + dbus["wifiboost_mcode"].replace(/\+/g, "-") + "&router=" + net_address;
			},
			btn2: function() {
				location.href = "http://" + pay_server + ":" + pay_port + "/pay.php?paytype=2&mcode=" + dbus["wifiboost_mcode"].replace(/\+/g, "-") + "&router=" + net_address;
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
				<b>wifi boost 购买订单号获取</b><br><br>\
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
<body id="app" skin='<% nvram_get("sc_skin"); %>' onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<div id="LoadingBar" class="popup_bar_bg_ks" style="z-index: 200;" >
		<table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
			<tr>
				<td height="100">
				<div id="loading_block_title" style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;"></div>
				<div id="loading_block_spilt" style="margin:10px 0 10px 5px;" class="loading_block_spilt"></div>
				<div style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
					<textarea cols="50" rows="25" wrap="off" readonly="readonly" id="log_content" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Lucida Console'; font-size:11px;background:transparent;color:#FFFFFF;outline: none;padding-left:3px;padding-right:22px;overflow-x:hidden"></textarea>
				</div>
				<div id="ok_button" class="apply_gen" style="background:#000;visibility:hidden;">
					<input id="ok_button1" class="button_gen" type="button" onclick="hideWBLoadingBar()" value="确定">
				</div>
				</td>
			</tr>
		</table>
	</div>
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
												<img style="height:250px" src="https://fw.koolcenter.com/binary/image_bed/sadog/sadog.png"/>
											</div>
											<div style="margin-top:0px;margin-left:4%;width:96%;text-align:left;">
												<div id="info0" style="font-size:16px;color:#000;margin:10px 0 10px 0"><i>人工邮件购买激活码流程:</i></div>
												<div id="info1" style="font-size:12px;color:#000;">1.扫描上方其中一个二维码，付款30元人民币给开发者，即可购买wifi boost 激活码。</div>
												<div id="info2" style="font-size:12px;color:#000;">2.复制下面文本框内容，替换xxx为<a type="button" href="javascript:void(0);" style="cursor: pointer;color:#FF3300;" onclick="pop_help();"><u>支付订单号</u></a>，发送邮件到：<a id="wifiboost_mail" style="font-size:12px;color:#CC0000;" href="mailto:mjy211@gmail.com?subject=wifi_boost插件购买&body=这是邮件的内容">mjy211@gmail.com</a></div>
												<div id="info3" style="font-size:12px;color:#000;">3.此方式购买的订单为人工处理，激活码会在一个工作日左右发送到你的邮箱，请耐心等待。</div>
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
										<div class="formfonttitle">wifi boost<lable id="wifiboost_version"></lable></div>
										<div style="float:right; width:15px; height:25px;margin-top:-20px">
											<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
										</div>
										<div id="spl1" style="margin:10px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote">
											<span>wifi boost可以极大的增强路由器wifi的发射功率，增强信号覆盖范围。
												<a type="button" href="https://koolshare.cn/thread-184369-1-1.html" target="_blank" class="ks_btn" style="cursor: pointer;margin-left:5px;border:none" >使用交流</a>
												<a type="button" href="https://github.com/koolshare/rogsoft/blob/master/wifiboost/Changelog.txt" target="_blank" class="ks_btn" style="cursor: pointer;margin-left:5px;border:none" >更新日志</a>
												<a type="button" class="ks_btn" href="javascript:void(0);" onclick="get_log(1)" style="margin-left:5px;border:none">显示日志</a></span>
												<lable id="wifiboost_o_version"></lable>
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
													if (BUILD.indexOf(".") != -1){
														if(RC_SUPPORT.indexOf("koolsoft") != -1){
															$("#wifiboost_ver").html(MODEL + "&nbsp;&nbsp;" + BUILD + "_" + FWVER + "&nbsp;&nbsp;梅林改版固件");
														}else{
															$("#wifiboost_ver").html(MODEL + "&nbsp;&nbsp;" + BUILD + "_" + FWVER + "&nbsp;&nbsp;梅林原版固件");
														}
													}else{
														if(RC_SUPPORT.indexOf("koolsoft") != -1){
															$("#wifiboost_ver").html(MODEL + "&nbsp;&nbsp;" + BUILD + "_" + FWVER + "&nbsp;&nbsp;官改固件");
														}else{
															$("#wifiboost_ver").html(MODEL + "&nbsp;&nbsp;" + BUILD + "_" + FWVER + "&nbsp;&nbsp;华硕官方固件");
														}
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
												<th>wifi boost 激活码</th>
												<td>
													<input type="password" maxlength="100" id="wifiboost_key" class="input_ss_table" title="此处输入wifi boost激活码或者兑换码！" style="width:340px;font-size: 95%;" readonly onblur="switchType(this, false);" onfocus="switchType(this, true);this.removeAttribute('readonly');" autocomplete="new-password" autocorrect="off" autocapitalize="off" spellcheck="false" >
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
																</td>									
																<td style="border:0px;padding-left:8px;">
																	<div id="slider24" style="width:280px;"></div>
																</td>									
																<td style="border:0px;width:60px;">
																	<div id="tx_power_desc_24" style="width:150px;font-size:12px;"></div>
																</td>					
															</tr>
														</table>
													</div>
												</td>
											</tr>
											<tr>
												<th>功率调节</th>
												<td>
													<div>
														<table>
															<tr>
																<td style="border:0px;padding-left:0px;">
																	<input type="checkbox" id="wifiboost_boost_52" onchange="verifyFields(this, 1);" style="vertical-align: middle;" checked=true /><lable id="LABLE_52">5.2G</lable>
																</td>									
																<td style="border:0px;padding-left:8px;">
																	<div id="slider52" style="width:280px;"></div>
																</td>									
																<td style="border:0px;width:60px;">
																	<div id="tx_power_desc_52" style="width:150px;font-size:12px;"></div>
																</td>					
															</tr>
														</table>
													</div>
												</td>
											</tr>
											<tr id="wifiboost_boost_58_tr" style="display: none;">
												<th>功率调节</th>
												<td>
													<div>
														<table>
															<tr>
																<td style="border:0px;padding-left:0px;">
																	<input type="checkbox" id="wifiboost_boost_58" onchange="verifyFields(this, 1);" style="vertical-align: middle;" checked=true /><lable id="LABLE_58">5G-2</lable>
																</td>									
																<td style="border:0px;padding-left:8px;">
																	<div id="slider58" style="width:280px;"></div>
																</td>									
																<td style="border:0px;width:60px;">
																	<div id="tx_power_desc_58" style="width:150px;font-size:12px;"></div>
																</td>					
															</tr>
														</table>
													</div>
												</td>
											</tr>
										</table>
										</div>
										<div class="apply_gen">
											<input class="button_gen" id="wifiboost_apply_1" onClick="boost_now(1)" type="button" value="boost/增强功率" />
											<input class="button_gen" id="wifiboost_apply_2" onClick="boost_now(2)" type="button" value="恢复原厂功率" />
										</div>
										<div id="warn_msg_1" style="display: none;text-align:center; line-height: 4em;"><i></i></div>
										<div id="spl2" style="margin:10px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote">
											<li id="msg1">wifi boost通过修改机器出厂wlan设置，突破出厂设定的最大发射功率，须知修改出厂wlan设置有风险，由此带来的风险请自行承担！</li>
											<li id="msg2">更高的发射功率可能影响速率、稳定性等，甚至会烧功放，请勿盲目追求过高的发射功率，建议WIFI6机型设定不超过27.50dBm！</li>
											<li id="msg3">虽然插件可以保证修改过程相对安全，但还是强烈建议不要过于频繁的进行修改，以免发生意外导致机器wlan出厂设置被损坏。</li>
											<li id="msg4">修改后插件会自动将地区切换为澳大利亚以发挥效果，非澳大利亚的功率和修改前一样。如果修改后功率未起作用，请重置一次路由。</li>
											<li id="msg5">修改完成后，卸载wifi boost插件、升级固件版本、刷三方固件/原厂固件等操作均会保持最后一次的功率修改效果。</li>
											<li id="msg6"></li>
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

