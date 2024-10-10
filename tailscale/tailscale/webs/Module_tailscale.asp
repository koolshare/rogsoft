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
<title>软件中心 - Tailscale</title>
<link rel="stylesheet" type="text/css" href="index_style.css"> 
<link rel="stylesheet" type="text/css" href="form_style.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/js/table/table.css">
<link rel="stylesheet" type="text/css" href="/res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/js/table/table.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script type="text/javascript" src="/help.js"></script>
<style>
a:focus {
	outline: none;
}
.SimpleNote {
	padding:5px 5px;
}
i {
    color: #FC0;
    font-style: normal;
}
#return_btn {
	cursor:pointer;
	position:absolute;
	margin-left:-30px;
	margin-top:-25px;
}
.popup_bar_bg_ks{
	position:fixed;	
	margin: auto;
	top: 0;
	left: 0;
	width:100%;
	height:100%;
	z-index:99;
	filter:alpha(opacity=90);  /*IE5、IE5.5、IE6、IE7*/
	background-repeat: repeat;
	visibility:hidden;
	overflow:hidden;
	background:rgba(68, 79, 83, 0.85) none repeat scroll 0 0 !important; /* W3C  */
	background-position: 0 0;
	background-size: cover;
	opacity: .94;
}
.loading_block_spilt {
    background: #656565;
    height: 1px;
    width: 98%;
}
.content_status {
	position: absolute;
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	border-radius:10px;
	z-index: 10;
	margin-left: -415px;
	top: 0;
	left: 0;
	height:auto;
	box-shadow: 3px 3px 10px #000;
	background: rgba(0,0,0,0.88);
	width:948px;
	/*display:none;*/
	visibility:hidden;
}
.user_title{
	text-align:center;
	font-size:18px;
	color:#99FF00;
	padding:10px;
	font-weight:bold;
}
#ts_status, #ts_check{
	border:0px solid #222;
	width:98%;
	font-family:'Lucida Console';
	font-size:12px;
	padding-left:13px;
	padding-right:33px;
	background: transparent;
	color:#FFFFFF;
	outline:none;
	overflow-x:hidden;
	line-height:1.5;
}
input[type=button]:focus {
	outline: none;
}
#log_content {
	border:1px solid #000;
	width:99%;
	font-family:'Lucida Console';
	font-size:11px;
	padding-left:3px;
	padding-right:22px;
	background:transparent;
	color:#FFFFFF;
	outline:none;
	overflow-x:hidden;
	line-height:1.5;
}
.FormTitle em {
    color: #00ffe4;
    font-style: normal;
    font-weight:bold;
}
.FormTable th {
	width: 30%;
}
.formfonttitle {
	font-family: Roboto-Light, "Microsoft JhengHei";
	font-size: 18px;
	margin-left: 5px;
}
.FormTitle, .FormTable, .FormTable th, .FormTable td, .FormTable thead td, .FormTable_table, .FormTable_table th, .FormTable_table td, .FormTable_table thead td {
	font-size: 14px;
	font-family: Roboto-Light, "Microsoft JhengHei";
}
.FormTable_table{
	margin-top:0px;
}
.FormTable th {
    width: 35%;
}
#app[skin=ASUSWRT] #tailscale_main, #app[skin=ASUSWRT] #tailscale_tcnets {
	outline: none;
}
#app[skin=ASUSWRT] .loadingBarBlock{
	width:770px;
	outline: none;
}
#app[skin=ASUSWRT] .content_status{
	outline: none;
}
#app[skin=ROG] #tailscale_main, #app[skin=ROG] #tailscale_tcnets {
	outline: 1px solid #91071f;
}
#app[skin=ROG] .loadingBarBlock{
	width:770px;
	outline: 1px solid #91071f;
}
#app[skin=ROG] .content_status{
	outline: 1px solid #91071f;
}
#app[skin=TUF] #tailscale_main, #app[skin=TUF] #tailscale_tcnets {
	outline: 1px solid #ffa523;
}
#app[skin=TUF] .loadingBarBlock{
	width:770px;
	outline: 1px solid #ffa523;
}
#app[skin=TUF] .content_status{
	outline: 1px solid #ffa523;
}
#app[skin=TS] #tailscale_main, #app[skin=TS] #tailscale_tcnets {
	outline: 1px solid #2ed9c3;
}
#app[skin=TS] .loadingBarBlock{
	width:770px;
	outline: 1px solid #2ed9c3;
}
#app[skin=TS] .content_status{
	outline: 1px solid #2ed9c3;
}
</style>
<script>
var odm = '<% nvram_get("productid"); %>'
var lan_ipaddr = "<% nvram_get(lan_ipaddr); %>"
var params_chk = ['tailscale_enable', 'tailscale_ipv4_enable', 'tailscale_ipv6_enable', 'tailscale_advertise_routes', 'tailscale_accept_routes', 'tailscale_exit_node'];
var	refresh_flag;
var count_down;
var myid;
var dbus = {};
var confs = [];
var zt_nodes = [];
var node_max = 0;
var active_tab = 0;
String.prototype.myReplace = function(f, e){
	var reg = new RegExp(f, "g"); 
	return this.replace(reg, e); 
}

function init() {
	show_menu(menu_hook);
	set_skin();
	get_dbus_data();
}
function set_skin(){
	var SKN = '<% nvram_get("sc_skin"); %>';
	if(SKN){
		$("#app").attr("skin", '<% nvram_get("sc_skin"); %>');
	}
}
function get_dbus_data(){
	$.ajax({
		type: "GET",
		url: "/_api/tailscale_",
		dataType: "json",
		async: false,
		success: function(data) {
			dbus = data.result[0];
			conf2obj();
			register_event();
			if(dbus["tailscale_enable"] == "1"){
				get_proces_status();
				get_tcnets_status();
				show_hide_element();
			}
		}
	});
}
function conf2obj(){
	for (var i = 0; i < params_chk.length; i++) { 
		if(dbus[params_chk[i]]){
			E(params_chk[i]).checked = dbus[params_chk[i]] != "0";
		}
	}

	if (dbus["tailscale_version"]){
		E("tailscale_version").innerHTML = " - " + dbus["tailscale_version"];
	}
}
function show_hide_element(){
	E("tailscale_status_tr").style.display = "";
	E("tailscale_state_tr").style.display = "";
	E("tailscale_console_tr").style.display = "";
	E("tailscale_jion_btn_div").style.display = "";
}
function register_event(){
	$("#tailscale_enable").click(
		function() {
			if (dbus["tailscale_enable"] == "1"){
				E("tailscale_enable").checked = false;
			}else{
				E("tailscale_enable").checked = true;
			}
			save();
		});	
	$(".popup_bar_bg_ks").click(
		function() {
			count_down = -1;
		});
	$(window).resize(function(){
		var page_h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
		var page_w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
		if($('.popup_bar_bg_ks').css("visibility") == "visible"){
			document.scrollingElement.scrollTop = 0;
			var log_h = E("loadingBarBlock").clientHeight;
			var log_w = E("loadingBarBlock").clientWidth;
			var log_h_offset = (page_h - log_h) / 2;
			var log_w_offset = (page_w - log_w) / 2 + 90;
			$('#loadingBarBlock').offset({top: log_h_offset, left: log_w_offset});
		}
		if($('#tailscale_status_div').css("visibility") == "visible"){
			document.scrollingElement.scrollTop = 0;
			var status_h = E("tailscale_status_div").clientHeight;
			var status_w = E("tailscale_status_div").clientWidth;
			var status_h_offset = (page_h - status_h) / 2;
			var status_w_offset = (page_w - status_w) / 2 - 10;
			$('#tailscale_status_div').offset({top: status_h_offset, left: status_w_offset});
		}
		if($('#tailscale_netcheck_div').css("visibility") == "visible"){
			document.scrollingElement.scrollTop = 0;
			var netcheck_h = E("tailscale_netcheck_div").clientHeight;
			var netcheck_w = E("tailscale_netcheck_div").clientWidth;
			var netcheck_h_offset = (page_h - netcheck_h) / 2;
			var netcheck_w_offset = (page_w - netcheck_w) / 2 - 10;
			$('#tailscale_netcheck_div').offset({top: netcheck_h_offset, left: netcheck_w_offset});
		}
	});

}
function get_proces_status() {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "tailscale_fettle", "params":[], "fields": ""};
	$.ajax({
		type: "POST",
		cache: false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			//console.log(response);
			if(response.result){
				var arr = response.result.split("@@");
				E("tailscale_status").innerHTML = arr[0];
				E("tailnet_state").innerHTML = arr[1];
			}
			setTimeout("get_proces_status();", 5000);
		},
		error: function() {
			setTimeout("get_proces_status();", 15000);
		}
	});
}
function get_tcnets_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "tailscale_tsnets", "params":[1], "fields": ""};
	$.ajax({
		type: "POST",
		cache: false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			//console.log(response.result);
			if (response.result == "empty"){
				return false;
			}
			E("tailscale_tcnets").style.display = "";
			var data = JSON.parse(Base64.decode(response.result));
			//console.log(data)
			$("#tailscale_tcnets_status").find("tr:gt(1)").remove();
			var code = ''
			for (var field in data) {
				var f = data[field];
				code = code + '<tr>';
				code = code + '<td>' + f.if + '</td>';
				code = code + '<td>' + f.ip + '</td>';
				code = code + '<td>' + f.rx + '</td>';
				code = code + '<td>' + f.tx + '</td>';
				code = code + '</tr>';
			}
			$('#tailscale_tcnets_status tr:last').after(code);
			setTimeout("get_tcnets_status();", 11000);
		},
		error: function(XmlHttpRequest, textStatus, errorThrown){
			console.log(XmlHttpRequest.responseText);
			setTimeout("get_tcnets_status();", 20000);
		}
	});
}
function tabSelect(w) {
	for (var i = 0; i <= 10; i++) {
		if($('.show-btn' + w).length != 0){
			$('.show-btn' + i).removeClass('active');
			$('#tailscale_interface_div_' + i).hide();
		}
	}
	$('.show-btn' + w).addClass('active');
	$('#tailscale_interface_div_' + w).show();
	active_tab = w;
}
function save(){
	var dbus_new = {};
	for (var i = 0; i < params_chk.length; i++) {
		dbus_new[params_chk[i]] = E(params_chk[i]).checked ? '1' : '0';
	}
	
	E("tailscale_jion_btn").disabled = true;
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "tailscale_config", "params": ["web_submit"], "fields": dbus_new};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if(response.result == id){
				E("tailscale_jion_btn").disabled=false;
				get_log();
			}
		}
	});
}
function showWBLoadingBar(){
	document.scrollingElement.scrollTop = 0;
	E("loading_block_title").innerHTML = "&nbsp;&nbsp;tailscale日志信息";
	E("LoadingBar").style.visibility = "visible";
	var page_h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	var page_w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	var log_h = E("loadingBarBlock").clientHeight;
	var log_w = E("loadingBarBlock").clientWidth;
	var log_h_offset = (page_h - log_h) / 2;
	var log_w_offset = (page_w - log_w) / 2 + 95;
	$('#loadingBarBlock').offset({top: log_h_offset, left: log_w_offset});
}
function hideWBLoadingBar(){
	E("LoadingBar").style.visibility = "hidden";
	E("ok_button").style.visibility = "hidden";
	if (refresh_flag == "1"){
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
	if(flag == 2){
		var TARGET_URL = '/_temp/tailscaled_log.txt'
	}else{
		var TARGET_URL = '/_temp/tailscale_log.txt'
	}
	$.ajax({
		url: TARGET_URL,
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content");
			if(flag == 2){
				retArea.value = response;
				E("ok_button").style.visibility = "visible";
				retArea.scrollTop = retArea.scrollHeight;
				return false;
			}else{
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
			}
			setTimeout("get_log(" + flag + ");", 500);
			retArea.value = response.myReplace("XU6J03M6", " ");
			retArea.scrollTop = retArea.scrollHeight;
		},
		error: function(xhr) {
			E("loading_block_title").innerHTML = "暂无日志信息 ...";
			E("log_content").value = "日志文件为空，请关闭本窗口！";
			E("ok_button").style.visibility = "visible";
			return false;
		}
	});
}
function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "tailscale");
	tablink[tablink.length - 1] = new Array("", "Module_tailscale.asp");
}

function close_status() {
	E("tailscale_status_div").style.visibility = "hidden";
}
function tailscale_status() {
	document.scrollingElement.scrollTop = 0;
	E("tailscale_status_div").style.visibility = "visible";
	var page_h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	var page_w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	var status_h = E("tailscale_status_div").clientHeight;
	var status_w = E("tailscale_status_div").clientWidth;
	var status_h_offset = (page_h - status_h) / 2;
	var status_w_offset = (page_w - status_w) / 2 -10;
	$('#tailscale_status_div').offset({top: status_h_offset, left: status_w_offset});
	//$("#tailscale_status_div").fadeIn(500);
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "tailscale_status", "params":[], "fields": ""};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if(response.result == id){
				write_status();
			}
		}
	});
}
function write_status() {
	$.ajax({
		url: '/_temp/tailscale_status.txt',
		type: 'GET',
		cache: false,
		dataType: 'text',
		success: function(res) {
			$('#ts_status').val(res);
		}
	});
}
function close_netcheck() {
	E("tailscale_netcheck_div").style.visibility = "hidden";
}
function tailscale_netcheck() {
	document.scrollingElement.scrollTop = 0;
	E("tailscale_netcheck_div").style.visibility = "visible";
	E("ts_check").value = "";
	var page_h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	var page_w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	var netcheck_h = E("tailscale_netcheck_div").clientHeight;
	var netcheck_w = E("tailscale_netcheck_div").clientWidth;
	var netcheck_h_offset = (page_h - netcheck_h) / 2;
	var netcheck_w_offset = (page_w - netcheck_w) / 2 -10;
	$('#tailscale_netcheck_div').offset({top: netcheck_h_offset, left: netcheck_w_offset});
	//$("#tailscale_netcheck_div").fadeIn(500);
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "tailscale_ncheck", "params":[], "fields": ""};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if(response.result == id){
				write_netcheck();
			}
		}
	});
}
function write_netcheck() {
	$.ajax({
		url: '/_temp/tailscale_netcheck.txt',
		type: 'GET',
		cache: false,
		dataType: 'text',
		success: function(res) {
			$('#ts_check').val(res);
		}
	});
}
function open_alist_hint(itemNum) {
	statusmenu = "";
	width = "350px";
	if (itemNum == 1) {
		width = "600px";
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;1. 通常情况下，tailscale会自动使用你所有网络作为出口（Endpoints）备选，包括ipv4和ipv6（如果开启了ipv6的话），tailscale客户端（peer）之间进行通讯的时候，会自动选取一个网络进行直连通讯，比如当双方客户端都有公网ipv6地址时候，会利用ipv6进行通讯，如果无法通讯，会使用IPV4打洞后直连通讯。<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;2. 一般来说，如果我们同时勾选IPV4和IPV6（如果路由器开启了ipv6的话），tailscale会自动选取速度较快的IP协议进行peer（客户端）之间的连接，所以一般情况我们将其都勾选就行了。但是也有时候tailscale客户端之间的连接会使用到速度较慢的IP协议上，此时我们可以通过勾选/去勾选右侧的IP协议，来达到强制使用特定IP协议进行tailscale客户端之间通讯的目的。<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;3. 如果此时我们两台tailscale客户端都支持ipv4和ipv6，且ipv4速度非常慢（被公司单位防火墙限制等情况），而ipv6速度较好，希望tailscale能强制使用ipv6进行peer（客户端）之间的通讯，此时将IPV4选项去掉，插件会使用iptables规则丢掉tailscale相关的ipv4数据包，这样就能强制其使用ipv6。<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;4. 同理，如果你希望强制使用IPV4，而不是IPV6进行客户端之间的通讯，也可以去掉ipv6选项<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;5. 你可以使用tailscale status按钮，查看当前本路由器与其它tailscale客户端通讯使用的ip协议。<br/><br/>"
		_caption = "使用网络";
		return overlib(statusmenu, OFFSETX, 160, OFFSETY, 10, RIGHT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, '');
	}
	if (itemNum == 2) {
		width = "780px";
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;<b>宣告路由表</b>：将本路由器lan网段，如192.168.50.0/24，宣告给tailnet，如果其它tailscale客户端接受了此路由表，那么其它客户端可以通过192.168.50.0/24内的ip地址访问本路由器和路由器下的客户端。<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;<b>接受路由表</b>：在同一个tailnet网络下，如有其它tailscale客户端宣告了自己的路由表，可以通过此开关选择是否接受此路由表，如果接受，怎可以通过宣告的网段访问到网段内的设备。<br/><br/>"
		statusmenu += "-------------------------------------------------------------------------------------------------------------------<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;<font color='red'>情形1：</font><br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;假如你此路由器在A地，lan网段为192.168.50.0/24，lan网段里包含：路由器本身：192.168.50.1，一台电脑PC-1：192.168.50.23，一台NAS：192.168.50.55，此时打开宣告路由表开关，则此网段信息:192.168.50.0/24就会被告知到tailnet（tailscale局域网）。<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;此时如果你有一台电脑PC-2在B地运行了tailscale客户端，且该电脑的自己的网卡ip不是192.168.50.x，且tailscale设置了接受路由表：（--accept-routes），那么此时在B地的PC-2上，可以直接通过192.168.50.1访问到A地的路由器；直接通过192.168.50.23访问到A地的PC-1；直接通过192.168.50.55访问到A地的NAS<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;<font color='red'>情形2：</font><br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;当然在B地的也可以是一台运行了tailscale的路由器，该路由器的lan网段需要与A地的路由器不同，且tailscale设置了接受路由表：（--accept-routes），那么此时在B地路由器下的所有设备，都能访问A地网段下的所有设备了！<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;同理，如果需要A地路由器下的所有设备能访问B地路由器下的所有设备，那么需要：1. B地路由器上运行的tailscale设置了宣告路由表，2. A地路由器上运行的tailscale设置了接受路由表<br/><br/>"
		statusmenu += "-------------------------------------------------------------------------------------------------------------------<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;<font color='red'>注意1：</font><br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;1. 如果不开启宣告路由表，则其它tailscale客户端只能通过tailscale提供的ip地址来访问此路由器！<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;2. 即使在客户端处开启了宣告路由表，还需要在后台（admin console）的Edit route settings处确认开启才能生效！<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;3. 如果你在有多个客户端需要开启宣告路由表，请一定保证每个路由表都是不同网段，不然会导致路由表冲突使得设备无法登陆后台且无法上网！<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;4. 当然你也可以将宣告路由表功能保持开启，如遇到冲突，可以在控制台不允许该路由表即可！<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;5. 如果你的上级路由开启了tailscale且宣告了路由表，下级路由器运行tailscale请不要接受路由表，不然也会出现路由表冲突导致无法上网！<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;<font color='red'>提示！</font><br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;1. 如果你开启插件后发现无法上网了，请关闭接受路由表选项！<br/><br/>"
		_caption = "宣告路由表";
		return overlib(statusmenu, OFFSETX, 20, OFFSETY, -330, RIGHT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, '');
	}
	if (itemNum == 3) {
		width = "780px";
		statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;<b>互联网出口</b>：开启该功能后，可以将其它tailscale客户端的互联网出口会切换到这台路由器，相当于VPN的功能！<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;<font color='red'>示例：</font><br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;1. 开启此功能后，需要将在后台（admin console）的Edit route settings处将Use as exit node选项打开。<br/><br/>"
		statusmenu += "&nbsp;&nbsp;&nbsp;&nbsp;2. 然后需要在对应的tailscale客户端上，选择exit node作为互联网出口节点即可，比如在ios的tailscale客户端上，连上tailscale后，点击右上角三个点(...)，选择Use Exit Node，然后点击你要使用的出口即可！。<br/><br/>"
		_caption = "宣告路由表";
		return overlib(statusmenu, OFFSETX, 20, OFFSETY, -330, RIGHT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, '');
	}
	var tag_name = document.getElementsByTagName('a');
	for (var i = 0; i < tag_name.length; i++)
		tag_name[i].onmouseout = nd;

	if (helpcontent == [] || helpcontent == "" || hint_array_id > helpcontent.length)
		return overlib('<#defaultHint#>', HAUTO, VAUTO);
	else if (hint_array_id == 0 && hint_show_id > 21 && hint_show_id < 24)
		return overlib(helpcontent[hint_array_id][hint_show_id], FIXX, 270, FIXY, 30);
	else {
		if (hint_show_id > helpcontent[hint_array_id].length)
			return overlib('<#defaultHint#>', HAUTO, VAUTO);
		else
			return overlib(helpcontent[hint_array_id][hint_show_id], HAUTO, VAUTO);
	}
}
function mOver(obj, hint){
	$(obj).css({
		"color": "#00ffe4",
		"text-decoration": "underline"
	});
	open_alist_hint(hint);
}
function mOut(obj){
	$(obj).css({
		"color": "#fff",
		"text-decoration": ""
	});
	E("overDiv").style.visibility = "hidden";
}
</script>
</head>
<body id="app" skin="ASUSWRT" onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<div id="LoadingBar" class="popup_bar_bg_ks" style="z-index: 200;" >
		<table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
			<tr>
				<td height="100">
				<div id="loading_block_title" style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;"></div>
				<div id="loading_block_spilt" style="margin:10px 0 10px 5px;" class="loading_block_spilt"></div>
				<div style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
					<textarea cols="50" rows="26" wrap="on" readonly="readonly" id="log_content" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" ></textarea>
				</div>
				<div id="ok_button" class="apply_gen" style="background:#000;visibility:hidden;">
					<input id="ok_button1" class="button_gen" type="button" onclick="hideWBLoadingBar()" value="确定">
				</div>
				</td>
			</tr>
		</table>
	</div>
	<!--============================this is the popup area for tailscale status=================================-->
	<div id="tailscale_status_div" class="content_status">
		<div class="user_title">tailscale status 状态</div>
		<div style="margin-left:15px"><i>此处展示命令：tailscale status 显示的内容。</i></div>
		<div style="margin: 10px 10px 10px 15px;width:918px;text-align:center;overflow:hidden;border-top:1px solid #818181;padding-top:10px">
			<textarea cols="63" rows="18" wrap="off" id="ts_status" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
		</div>
		<div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
			<input class="button_gen" type="button" onclick="close_status();" value="返回主界面">
		</div>
	</div>
	<!--============================this is the popup area for tailscale netcheck=================================-->
	<div id="tailscale_netcheck_div" class="content_status">
		<div class="user_title">tailscale netcheck 状态</div>
		<div style="margin-left:15px"><i>此处展示命令：tailscale netcheck 显示的内容。</i></div>
		<div style="margin: 10px 10px 10px 15px;width:918px;text-align:center;overflow:hidden;border-top:1px solid #818181;padding-top:10px">
			<textarea cols="63" rows="30" wrap="off" id="ts_check" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
		</div>
		<div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
			<input class="button_gen" type="button" onclick="close_netcheck();" value="返回主界面">
		</div>
	</div>
	<!--=============================================================================================================-->
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
										<div class="formfonttitle">Tailscale<lable id="tailscale_version"></lable></div>
										<div style="float:right; width:15px; height:25px;margin-top:-20px">
											<img id="return_btn" onclick="reload_Soft_Center();" align="right" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
										</div>
										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote">
											<span>Tailscale是一款基于wiregurad协议的零配置安全组网工具。</span>
											<span><a type="button" href="https://github.com/koolshare/rogsoft/blob/master/tailscale/Changelog.txt" target="_blank" class="ks_btn" style="margin-left:5px;" >更新日志</a></span>
											<span><a type="button" class="ks_btn" href="javascript:void(0);" onclick="get_log(1)" style="margin-left:5px;">查看插件日志</a></span>
											<span><a type="button" class="ks_btn" href="javascript:void(0);" onclick="get_log(2)" style="margin-left:5px;">tailscaled运行日志</a></span>
										</div>
										<div id="tailscale_main">
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
												<thead>
													<tr>
														<td colspan="2">tailscale - 状态/控制</td>
													</tr>
												</thead>
												<tr id="switch_tr">
													<th>开关</th>
													<td>
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="tailscale_enable">
																<input id="tailscale_enable" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container" >
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
													</td>
												</tr>
												<tr id="tailscale_status_tr" style="display:none;">
													<th>tailscaled 运行状态</th>
													<td>
														<span style="margin-left:4px" id="tailscale_status"></span>
													</td>
												</tr>
												<tr id="tailscale_state_tr" style="display:none;">
													<th>tailnet 状态</th>
													<td>
														<span style="margin-left:4px" id="tailnet_state"></span>
													</td>
												</tr>
												<tr id="tailscale_console_tr">
													<th>tailscale 控制台</th>
													<td>
														<a type="button" id="tailscale_website" class="ks_btn" href="https://login.tailscale.com/admin" target="_blank" style="margin-left:2px">Admin console</a>
													</td>
												</tr>
												<tr id="tailscale_status_tr">
													<th>连接状态</th>
													<td>
														<a type="button" id="tailscale_status" class="ks_btn" onclick="tailscale_status();" target="_blank" style="margin-left:2px;cursor:pointer;">tailscale status</a>
														<a type="button" id="tailscale_netcheck" class="ks_btn" onclick="tailscale_netcheck();" target="_blank" style="margin-left:2px;cursor:pointer;">tailscale netcheck</a>
													</td>
												</tr>
												<tr>
													<th><a onmouseover="mOver(this, 1)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);">使用网络</a></th>
													<td>
														ipv4
														<input type="checkbox" id="tailscale_ipv4_enable" style="vertical-align:middle;" checked="true">
														ipv6
														<input type="checkbox" id="tailscale_ipv6_enable" style="vertical-align:middle;" checked="true">
													</td>
												</tr>
												<tr>
													<th><a onmouseover="mOver(this, 2)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);">宣告路由表（--advertise-routes）</a></th>
													<td>
														<input type="checkbox" id="tailscale_advertise_routes" style="vertical-align:middle;" checked="true">
													</td>
												</tr>
												<tr>
													<th><a onmouseover="mOver(this, 2)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);">接受路由表（--accept-routes）</a></th>
													<td>
														<input type="checkbox" id="tailscale_accept_routes" style="vertical-align:middle;" checked="true">
													</td>
												</tr>
												<tr>
													<th><a onmouseover="mOver(this, 3)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);">互联网出口（--advertise-exit-node）</a></th>
													<td>
														<input type="checkbox" id="tailscale_exit_node" style="vertical-align:middle;">
													</td>
												</tr>
											</table>
										</div>
										<!--<div id="tailscale_main2" style="margin-top:10px;display:none">
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
												<thead>
													<tr>
														<td colspan="2">tailscale - 操作</td>
													</tr>
												</thead>
												<tr id="tailscale_join_tr">
													<th>加入tailnet</th>
													<td>
														<a type="button" id="tailscale_up" class="ks_btn" onclick="tailscale_up();" target="_blank" style="margin-left:2px">tailscale up</a>
													</td>
												</tr>
												<tr id="tailscale_leave_tr">
													<th>离开tailnet</th>
													<td>
														<a type="button" id="tailscale_down" class="ks_btn" onclick="tailscale_down();" target="_blank" style="margin-left:2px">tailscale down</a>
														<a type="button" id="tailscale_logout" class="ks_btn" onclick="tailscale_logout();" target="_blank" style="margin-left:2px">tailscale logout</a>
													</td>
												</tr>
												<tr id="tailscale_status_tr">
													<th>状态</th>
													<td>
														<a type="button" id="tailscale_status2" class="ks_btn" onclick="tailscale_status();" target="_blank" style="margin-left:2px">tailscale status</a>
														<a type="button" id="tailscale_netcheck" class="ks_btn" onclick="tailscale_netcheck();" target="_blank" style="margin-left:2px">tailscale netcheck</a>
													</td>
												</tr>
											</table>
										</div>-->
										<div id="tailscale_tcnets" style="margin:10px 0px 0px 0px;display:none;">
											<table id="tailscale_tcnets_status" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable_table">
												<thead>
													<tr>
														<td colspan="5">tailscale - 网口状态</td>
													</tr>
												</thead>
												<tr>
													<th style="width:20%">接口</th>
													<th style="width:20%">IP</th>
													<th style="width:20%">下行</th>
													<th style="width:20%">上行</th>
												</tr>
											</table>
										</div>
										<div id="tailscale_jion_btn_div" class="apply_gen" style="display:none;">
											<input class="button_gen" id="tailscale_jion_btn" onClick="save()" type="button" value="重启插件" />
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

