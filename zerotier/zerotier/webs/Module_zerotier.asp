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
<title>软件中心 - zerotier</title>
<link rel="stylesheet" type="text/css" href="index_style.css"> 
<link rel="stylesheet" type="text/css" href="form_style.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/js/table/table.css">
<link rel="stylesheet" type="text/css" href="/res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/js/table/table.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
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
	background:rgba(68, 79, 83, 0.85) none repeat scroll 0 0 !important;
	background: url(/images/New_ui/login_bg.png);
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
.content_status {
	position: absolute;
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	border-radius:10px;
	z-index: 100;
	margin-left: -215px;
	top: 0;
	left: 0;
	height:auto;
	box-shadow: 3px 3px 10px #000;
	background: rgba(0,0,0,0.88);
	width:748px;
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
#ztpeers_status {
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
.contentM_qis {
	position: absolute;
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	border-radius: 5px;
	z-index: 200;
	background-color:#2B373B;
	margin-left: 10px;
	top: 250px;
	width:730px;
	return height:auto;
	box-shadow: 3px 3px 10px #000;
	/*display:none;*/
	line-height:1.8;
	visibility:hidden;
}
.pop_div_bg{
	background-color: #2B373B;
}
.QISform_wireless {
	width:690px;
	font-size:14px;
	color:#FFFFFF;
}
.remove_btn{
	background: transparent url(/res/zt_del.png) no-repeat scroll center top;
}
.edit_btn{
  background: transparent url(/res/zt_edt.png) no-repeat scroll center top;
}
.add_btn{
	background: transparent url(/res/zt_add.png) no-repeat scroll center top;
}
input[type=button]:focus {
	outline: none;
}

#app[skin=ASUSWRT] .show-btn0, #app[skin=ASUSWRT] .show-btn1, #app[skin=ASUSWRT] .show-btn2, #app[skin=ASUSWRT] .show-btn3, #app[skin=ASUSWRT] .show-btn4, #app[skin=ASUSWRT] .show-btn5 {
	font-family: Roboto-Light, "Microsoft JhengHei";
	font-size:10pt;
	color: #fff;
	padding: 10px 4px;
	border-radius: 5px 5px 0px 0px;
	width:12%;
	border-left: 1px solid #67767d;
	border-top: 1px solid #67767d;
	border-right: 1px solid #67767d;
	border-bottom: none;
	background: #67767d;
	margin-right: 6px;
	cursor:pointer
}
#app[skin=ASUSWRT] .show-btn0:hover, #app[skin=ASUSWRT] .show-btn1:hover, #app[skin=ASUSWRT] .show-btn2:hover, #app[skin=ASUSWRT] .show-btn3:hover, #app[skin=ASUSWRT] .show-btn4:hover, #app[skin=ASUSWRT] .show-btn5:hover, #app[skin=ASUSWRT] .active {
	cursor:pointer
	font-family: Roboto-Light, "Microsoft JhengHei";
	border: 1px solid #2f3a3e;
	background: #2f3a3e;
}
#app[skin=ROG] .show-btn0, #app[skin=ROG] .show-btn1, #app[skin=ROG] .show-btn2, #app[skin=ROG] .show-btn3, #app[skin=ROG] .show-btn4, #app[skin=ROG] .show-btn5 {
	font-family: Roboto-Light, "Microsoft JhengHei";
	font-size:10pt;
	color: #fff;
	padding: 10px 4px;
	border-radius: 5px 5px 0px 0px;
	width:12%;
	border: 1px solid #91071f;
	background: none;
	margin-right: 6px;
	cursor:pointer
}
#app[skin=ROG] .show-btn0:hover, #app[skin=ROG] .show-btn1:hover, #app[skin=ROG] .show-btn2:hover, #app[skin=ROG] .show-btn3:hover, #app[skin=ROG] .show-btn4:hover, #app[skin=ROG] .show-btn5:hover, #app[skin=ROG] .active {
	cursor:pointer
	font-family: Roboto-Light, "Microsoft JhengHei";
	border: 1px solid #91071f;
	background: #91071f;
}

#app[skin=TUF] .show-btn0, #app[skin=TUF] .show-btn1, #app[skin=TUF] .show-btn2, #app[skin=TUF] .show-btn3, #app[skin=TUF] .show-btn4, #app[skin=TUF] .show-btn5 {
	font-family: Roboto-Light, "Microsoft JhengHei";
	font-size:10pt;
	color: #fff;
	padding: 10px 4px;
	border-radius: 5px 5px 0px 0px;
	width:12%;
	border: 1px solid #92650F;
	background: none;
	margin-right: 6px;
	cursor:pointer
}
#app[skin=TUF] .show-btn0:hover, #app[skin=TUF] .show-btn1:hover, #app[skin=TUF] .show-btn2:hover, #app[skin=TUF] .show-btn3:hover, #app[skin=TUF] .show-btn4:hover, #app[skin=TUF] .show-btn5:hover, #app[skin=TUF] .active {
	cursor:pointer
	font-family: Roboto-Light, "Microsoft JhengHei";
	border: 1px solid #92650F;
	background: #92650F;
}

#app[skin=TS] .show-btn0, #app[skin=TS] .show-btn1, #app[skin=TS] .show-btn2, #app[skin=TS] .show-btn3, #app[skin=TS] .show-btn4, #app[skin=TS] .show-btn5 {
	font-family: Roboto-Light, "Microsoft JhengHei";
	font-size:10pt;
	color: #fff;
	padding: 10px 4px;
	border-radius: 5px 5px 0px 0px;
	width:12%;
	border: 1px solid #2ED9C3;
	background: none;
	margin-right: 6px;
	cursor:pointer
}
#app[skin=TS] .show-btn0:hover, #app[skin=TS] .show-btn1:hover, #app[skin=TS] .show-btn2:hover, #app[skin=TS] .show-btn3:hover, #app[skin=TS] .show-btn4:hover, #app[skin=TS] .show-btn5:hover, #app[skin=TS] .active {
	cursor:pointer
	font-family: Roboto-Light, "Microsoft JhengHei";
	border: 1px solid #2ED9C3;
	background: #2ED9C3;
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
#app[skin=ASUSWRT] .ks_btn:hover {
	cursor: pointer;
}
#app[skin=ASUSWRT] .loadingBarBlock{
	width:740px;
}
#app[skin=ROG] .loadingBarBlock{
	width:740px;
	border:1px solid #91071f
}
#app[skin=TUF] .loadingBarBlock{
	width:740px;
	border:1px solid #92650F
}
#app[skin=TS] .loadingBarBlock{
	width:740px;
	border:1px solid #2ED9C3
}
#app[skin=ROG] #zerotier_main, #app[skin=ROG] #zerotier_peers_status_div, #app[skin=ROG] #zt_moons_settings, #app[skin=ROG] #zerotier_ztnets, #app[skin=ROG] #zerotier_route_div_2, #app[skin=ROG] #zt_moons_settings_div, #app[skin=ROG] #zerotier_interface_div_0, #app[skin=ROG] #zerotier_interface_div_1, #app[skin=ROG] #zerotier_interface_div_2, #app[skin=ROG] #zerotier_interface_div_3, #app[skin=ROG] #zerotier_interface_div_4, #app[skin=ROG] #zerotier_interface_div_5 {
	border: 1px solid #91071f;
}
#app[skin=TUF] #zerotier_main, #app[skin=TUF] #zerotier_peers_status_div, #app[skin=TUF] #zt_moons_settings, #app[skin=TUF] #zerotier_ztnets, #app[skin=TUF] #zerotier_route_div_2, #app[skin=TUF] #zt_moons_settings_div, #app[skin=TUF] #zerotier_interface_div_0, #app[skin=TUF] #zerotier_interface_div_1, #app[skin=TUF] #zerotier_interface_div_2, #app[skin=TUF] #zerotier_interface_div_3, #app[skin=TUF] #zerotier_interface_div_4, #app[skin=TUF] #zerotier_interface_div_5 {
	border: 1px solid #92650F;
}
#app[skin=TS] #zerotier_main, #app[skin=TS] #zerotier_peers_status_div, #app[skin=TS] #zt_moons_settings, #app[skin=TS] #zerotier_ztnets, #app[skin=TS] #zerotier_route_div_2, #app[skin=TS] #zt_moons_settings_div, #app[skin=TS] #zerotier_interface_div_0, #app[skin=TS] #zerotier_interface_div_1, #app[skin=TS] #zerotier_interface_div_2, #app[skin=TS] #zerotier_interface_div_3, #app[skin=TS] #zerotier_interface_div_4, #app[skin=TS] #zerotier_interface_div_5 {
	border: 1px solid #2ED9C3;
}
</style>
<script>
var odm = '<% nvram_get("productid"); %>'
var lan_ipaddr = "<% nvram_get(lan_ipaddr); %>"
var params_chk = ['zerotier_enable', 'zerotier_nat'];
var params_inp = ['zerotier_id'];
var	refresh_flag;
var count_down;
var myid;
var dbus = {};
var confs = [];
var zt_nodes = [];
var node_max = 0;
var active_tab = 0;


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
		url: "/_api/zerotier_",
		dataType: "json",
		async: false,
		success: function(data) {
			dbus = data.result[0];
			conf2obj();
			register_event();
			if(dbus["zerotier_enable"] == "1"){
				get_proces_status();
				get_ztnets_status();
				get_ifaces_status();
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
	//for (var i = 0; i < params_inp.length; i++) {
	//	if (dbus[params_inp[i]]) {
	//		$("#" + params_inp[i]).val(dbus[params_inp[i]]);
	//	}
	//}
	if (dbus["zerotier_version"]){
		E("zerotier_version").innerHTML = " - " + dbus["zerotier_version"];
	}
}
function show_hide_element(){
	E("zeroTier_nat_tr").style.display = "";
	E("zeroTier_id_tr").style.display = "";
	E("zerotier_route_div").style.display = "";
	E("zeroTier_status_tr").style.display = "";
	E("zerotier_console_tr").style.display = "";
	E("zerotier_jion_btn_div").style.display = "";
	E("zerotier_action_tr").style.display = "";
}
function register_event(){
	$("#zerotier_enable").click(
		function() {
			if (dbus["zerotier_enable"] == "1"){
				E("zerotier_enable").checked = false;
			}else{
				E("zerotier_enable").checked = true;
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
		if($('#zerotier_peers_status_div').css("visibility") == "visible"){
			document.scrollingElement.scrollTop = 0;
			var peer_h = E("zerotier_peers_status_div").clientHeight;
			var peer_w = E("zerotier_peers_status_div").clientWidth;
			var peer_h_offset = (page_h - peer_h) / 2;
			var peer_w_offset = (page_w - peer_w) / 2 + 90;
			$('#zerotier_peers_status_div').offset({top: peer_h_offset, left: peer_w_offset});
		}
		if($('#zt_moons_settings').css("visibility") == "visible"){
			document.scrollingElement.scrollTop = 0;
			var moon_h = E("zt_moons_settings").clientHeight;
			var moon_w = E("zt_moons_settings").clientWidth;
			var moon_h_offset = (page_h - moon_h) / 2 - 90;
			var moon_w_offset = (page_w - moon_w) / 2 + 90;
			if(moon_h_offset < 0){
				moon_h_offset = 10;
			}
			$('#zt_moons_settings').offset({top: moon_h_offset, left: moon_w_offset});
		}
	});

}
function get_proces_status() {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "zerotier_status", "params":[], "fields": ""};
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
				var space = "&nbsp;&nbsp;&nbsp;&nbsp;"
				E("zerotier_status").innerHTML = arr[0];
				E("zerotier_info").innerHTML = arr[3] + space + arr[4] + space + arr[5] + space;
				//E("zerotier_info").innerHTML = '<lable style="margin-right:15px">' + arr[3] + '</lable>' + '<lable style="margin-right:15px">' + arr[4] + '</lable>' + '<lable style="margin-right:15px">' + arr[5] + '</lable>';
			}
			setTimeout("get_proces_status();", 5000);
		},
		error: function() {
			setTimeout("get_proces_status();", 15000);
		}
	});
}
function get_ztnets_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "zerotier_ztnets", "params":[1], "fields": ""};
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
			E("zerotier_ztnets").style.display = "";
			var data = JSON.parse(Base64.decode(response.result));
			//console.log(data)
			$("#zerotier_ztnets_status").find("tr:gt(1)").remove();
			var code = ''
			for (var field in data) {
				var f = data[field];
				code = code + '<tr>';
				code = code + '<td>' + f.if + '</td>';
				code = code + '<td>' + f.ip + '</td>';
				code = code + '<td>' + f.hw + '</td>';
				code = code + '<td>' + f.rx + '</td>';
				code = code + '<td>' + f.tx + '</td>';
				code = code + '</tr>';
			}
			$('#zerotier_ztnets_status tr:last').after(code);
			setTimeout("get_ztnets_status();", 11000);
		},
		error: function(XmlHttpRequest, textStatus, errorThrown){
			console.log(XmlHttpRequest.responseText);
			setTimeout("get_ztnets_status();", 20000);
		}
	});
}
function tabSelect(w) {
	for (var i = 0; i <= 10; i++) {
		if($('.show-btn' + w).length != 0){
			$('.show-btn' + i).removeClass('active');
			$('#zerotier_interface_div_' + i).hide();
		}
	}
	$('.show-btn' + w).addClass('active');
	$('#zerotier_interface_div_' + w).show();
	active_tab = w;
}
function get_ifaces_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "zerotier_ifaces", "params":[1], "fields": ""};
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
			E("zerotier_interface").style.display = "";
			//E("zeroTier_moon_tr").style.display = "";
			var data = JSON.parse(Base64.decode(response.result));
			//console.log(data);
			for (var i = 0; i <= 10; i++) {
				if($('.show-btn' + i).length != 0){
					if($('.sub-btn' + i).hasClass("active")){
						active_tab = i;
					}
				}
			}
			var code = '';
			for (var field in data) {
				var f = data[field];
				isactive = field == active_tab ? active_tab + " active" : field;
				code = code + '<input class="show-btn' + isactive + '" type="button" onclick="tabSelect(' + field + ')" value="' + f.DEVICE + '">';
			}
			for (var field in data) {
				var f = data[field];
				isdisplay = field == active_tab ? "" : "none";
				code = code + '<div id="zerotier_interface_div_' + field + '" style="display:' + isdisplay + '">';
				code = code + '<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable_table">';
				code = code + '<tr>';
				code = code + '<th style="width:50%;"><em>' + f.NETWORK + '</em></th>';
				code = code + '<th style="width:50%;"><em>' + f.NAME + '</em></th>';
				code = code + '</tr>';
				code = code + '<tr>';
				code = code + '<td>Status</td>';
				code = code + '<td>' + f.STATUS + '</td>';
				code = code + '</tr>';
				code = code + '<tr>';
				code = code + '<td>Type</td>';
				code = code + '<td>' + f.TYPE + '</td>';
				code = code + '</tr>';
				code = code + '<tr>';
				code = code + '<td>MAC</td>';
				code = code + '<td>' + f.MAC + '</td>';
				code = code + '</tr>';
				code = code + '<tr>';
				code = code + '<td>MTU</td>';
				code = code + '<td>' + f.MTU + '</td>';
				code = code + '</tr>';
				code = code + '<tr>';
				code = code + '<td>Broadcast</td>';
				code = code + '<td>' + f.BROADCAST + '</td>';
				code = code + '</tr>';
				code = code + '<tr>';
				code = code + '<td>Bridging</td>';
				code = code + '<td>' + f.BRIDGE + '</td>';
				code = code + '</tr>';
				code = code + '<tr>';
				code = code + '<td>Device</td>';
				code = code + '<td>' + f.DEVICE + '</td>';
				code = code + '</tr>';
				code = code + '<tr>';
				code = code + '<td>Managed IPs</td>';
				code = code + '<td>' + f.IPADDR + '</td>';
				code = code + '</tr>';
				code = code + '<tr>';
				code = code + '<td>Action</td>';
				code = code + '<td><a type="button" class="ks_btn" style="cursor:pointer" onclick="leave_network(\'' + f.NETWORK + '\')" href="javascript:void(0);">离开此网络</a></td>';
				code = code + '</tr>';
				code = code + '</table>';
				code = code + '</div>';
			}
			// write html
			$('#zerotier_interface').html(code);

			//route table
			var html = '';
			var tr_nu=0;
			for (var field in data) {
				var f = data[field];
				var r = JSON.parse(f.ROUTES)
				for (var i = 0; i < r.length; i++) {
					if (r[i].via != null) {
						tr_nu++;
						//console.log(r[i]);
						html = html + '<tr>';
						html = html + '<td>';
						html = html + '✔';
						html = html + '</td>';
						html = html + '<td id="zerotier_route_default_ipaddr_' + tr_nu + '">';
						html = html + r[i].target;
						html = html + '</td>';
						html = html + '<td id="zerotier_route_default_gateway_' + tr_nu + '">';
						html = html + r[i].via;
						html = html + '</td>';
						////html = html + '<td>';
						////html = html + '</td>';
						html = html + '</tr>';
					}
				}
			}
			// routes default
			////$("#zerotier_route_table").find("tr:gt(1):lt(-1)").remove();
			$("#zerotier_route_table").find("tr:gt(1)").remove();
			$('#zerotier_route_table tr:eq(1)').after(html);	
			
			// route uset
			//// tr_nu = parseInt(tr_nu + 1);
			//// console.log(tr_nu);
			//// $("#zerotier_route_table").find("tr:gt(" + tr_nu + "):lt(-1)").remove();
			//// $('#zerotier_route_table tr:eq(' + tr_nu + ')').after(refresh_html());			
			setTimeout("get_ifaces_status();", 11000);
		},
		error: function(XmlHttpRequest, textStatus, errorThrown){
			console.log(XmlHttpRequest.responseText);
			setTimeout("get_ifaces_status();", 20000);
		}
	});
}
function save(){
	var dbus_new = {};
	for (var i = 0; i < params_chk.length; i++) {
		dbus_new[params_chk[i]] = E(params_chk[i]).checked ? '1' : '0';
	}
	
	//for (var i = 0; i < params_inp.length; i++) {
	//	dbus_new[params_inp[i]] = E(params_inp[i]).value;
	//}
	
	////var tr = E("zerotier_route_table").getElementsByTagName("tr");
	////for (var i = 2; i < tr.length - 2; i++) {
	////	var rowid = tr[i].getAttribute("id").split("_")[2];
	////	if (E("zerotier_route_enable_" + i)){
	////		dbus_new["zerotier_route_enable_" + rowid] = E("zerotier_route_enable_" + rowid).checked ? '1' : '0';
	////	}
	////}
	E("zerotier_jion_btn").disabled = true;
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "zerotier_config", "params": ["web_submit"], "fields": dbus_new};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if(response.result == id){
				E("zerotier_jion_btn").disabled=false;
				get_log();
			}
		}
	});
}
function leave_network(o){
	var dbus_new = {};
	dbus_new["zerotier_leave_id"] = o;
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "zerotier_config", "params": ["leave_network"], "fields": dbus_new};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if(response.result == id){
				E("zerotier_jion_btn").disabled=false;
				get_log();
			}
		}
	});
}
function deorbit_moon(){
	var dbus_new = {};
	dbus_new["zerotier_deorbit_moon_id"] = E("zerotier_deorbit_moon_id").value;
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "zerotier_config", "params": ["deorbit_moon"], "fields": dbus_new};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if(response.result == id){
				E("zt_moons_settings").style.visibility = "hidden";
				$("body").find(".fullScreen").fadeOut(0, function() { tableApi.removeElement("fullScreen"); });
				get_log();
			}
		}
	});
}
function orbit_moon(){
	var dbus_new = {};
	dbus_new["zerotier_orbit_moon_id"] = E("zerotier_moon_id").value;
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "zerotier_config", "params": ["orbit_moon"], "fields": dbus_new};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if(response.result == id){
				E("zt_moons_settings").style.visibility = "hidden";
				$("body").find(".fullScreen").fadeOut(0, function() { tableApi.removeElement("fullScreen"); });
				get_log();
			}
		}
	});
}
function join_network(){
	var dbus_new = {};
	dbus_new["zerotier_join_id"] = E("zerotier_id").value;
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "zerotier_config", "params": ["join_network"], "fields": dbus_new};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if(response.result == id){
				E("zerotier_jion_btn").disabled=false;
				get_log();
			}
		}
	});
}
function showWBLoadingBar(){
	document.scrollingElement.scrollTop = 0;
	E("loading_block_title").innerHTML = "&nbsp;&nbsp;ZeroTier日志信息";
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
		url: '/_temp/zerotier_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", " ");
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
			setTimeout("get_log(" + flag + ");", 600);
			retArea.value = response.replace("XU6J03M6", " ");
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
	tabtitle[tabtitle.length - 1] = new Array("", "zerotier");
	tablink[tablink.length - 1] = new Array("", "Module_zerotier.asp");
}
function refresh_table() {
	$.ajax({
		type: "GET",
		url: "/_api/zerotier_",
		dataType: "json",
		async: false,
		success: function(data) {
			dbus = data.result[0];
			// route table
			var trs = $("#zerotier_route_table tr");
			for (var i = 0; i < trs.length; i++) {
				var isid = $('#zerotier_route_table tr:nth-child(' + i + ')').attr("id");
				if (isid && isid != "zerotier_route_add_tr"){
					$("#zerotier_route_table").find('tr:eq(' + i + ')').remove();
				}
			}
			var ins_pos = parseInt(trs.length - 1);
			$('#zerotier_route_table tr:eq(' + ins_pos + ')').before(refresh_html());
		}
	});
}
function addTr(o) {
	if (!E(zerotier_route_ipaddr).value){
		alert("IP地址不能为空!");
		return false;
	}

	if (!E(zerotier_route_gateway).value){
		alert("网关地址不能为空!");
		return false;
	}
	
	if (!validator.ipv4cidr(zerotier_route_ipaddr)){
		alert("IP地址格式错误!");
		return false;
	}

	if (!validator.ipv4_addr(E(zerotier_route_gateway).value)){
		alert("网关地址格式错误!");
		return false;
	}

	if (E(zerotier_route_ipaddr).value == E(zerotier_route_gateway).value){
		alert("IP地址和网关地址不能相同!");
		return false;
	}

	//var tds = $("#zerotier_route_table tr td");
	//for (var i = 0; i < tds.length; i++) {
	//	var isid = $('#zerotier_route_table tr td:nth-child(' + i + ')').attr("id");
	//	console.log(isid)
	//}

	var _match_ip = confs.filter(function(person){return person.ipaddr == $('#zerotier_route_ipaddr').val();});
	//console.log(_match_ip);
	if (_match_ip.length > 0){
		alert("IP地址不能重复!");
		return false;
	}
	
	var _match_gw = confs.filter(function(person){return person.gateway == $('#zerotier_route_gateway').val();});
	//console.log(_match_gw);
	if (_match_gw.length > 0){
		alert("网关地址不能重复!");
		return false;
	}

	var ns = {};
	node_max += 1;

	ns["zerotier_route_ipaddr_" + node_max] = $('#zerotier_route_ipaddr').val();
	ns["zerotier_route_gateway_" + node_max] = $('#zerotier_route_gateway').val();
	ns["zerotier_route_enable_" + node_max] = E("zerotier_route_enable").checked ? '1' : '0';

	var postData = {"id": parseInt(Math.random() * 100000000), "method": "dummy_script.sh", "params":[], "fields": ns };
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			refresh_table();
			E("zerotier_route_enable").checked = true;
			E("zerotier_route_ipaddr").value = "";
			E("zerotier_route_gateway").value = "";
		}
	});
}
function delTr(o) {
	if (confirm("你确定删除吗？")) {
		var id = $(o).attr("id");
		var ids = id.split("_");
		id = ids[ids.length - 1];
		var ns = {};
		var zt_params = ["enable", "ipaddr", "gateway"];
		for (var i = 0; i < zt_params.length; i++) {
			ns["zerotier_route_" + zt_params[i] + "_" + id] = "";
		}
		var postData = {"id": parseInt(Math.random() * 100000000), "method": "dummy_script.sh", "params":[], "fields": ns };
		$.ajax({
			type: "POST",
			cache:false,
			url: "/_api/",
			data: JSON.stringify(postData),
			dataType: "json",
			success: function(response) {
				refresh_table();
			}
		});
	}
}
function compare(val1,val2){
	return val1-val2;
}
function getAllConfigs() {
	zt_nodes = [];
	for (var field in dbus) {
		var arr = field.split("zerotier_route_enable_");
		if(arr[0] == ""){
			zt_nodes.push(arr[1]);
		}
	}
	zt_nodes = zt_nodes.sort(compare);
	node_max = zt_nodes.length > 0 ? Math.max.apply(null, zt_nodes) : 0;

	confs = [];
	var zt_params = ["enable", "ipaddr", "gateway"];
	for (var j = 0; j < zt_nodes.length; j++) {
		var idx = zt_nodes[j];
		var obj = {};
		for (var i = 0; i < zt_params.length; i++) {
			var ofield = "zerotier_route_" + zt_params[i] + "_" + idx;
			if (typeof dbus[ofield] == "undefined") {
				obj[zt_params[i]] = '';
			}else{
				obj[zt_params[i]] = dbus[ofield];
			}
			obj["node"] = idx;
		}
		if (obj != null) {
			confs[idx] = obj;
		}
	}
	//console.log(confs);
	//return confs;
}
function refresh_html() {
	getAllConfigs();
	var html = '';
	for (var i = 0; i < zt_nodes.length; i++) {
		var c = confs[zt_nodes[i]];
		
		html = html + '<tr id="zerotier_route_' + c["node"] + '">';
		html = html + '<td>';
		if(c["enable"] == "1"){
			html = html + '<input type="checkbox" id="zerotier_route_enable_' + c["node"] + '" checked="checked" />';
		}else{
			html = html + '<input type="checkbox" id="zerotier_route_enable_' + c["node"] + '" />';
		}
		html = html + '</td>';

		html = html + '<td id="zerotier_route_user_ipaddr_' + c["node"] + '">';
		html = html + c["ipaddr"];
		html = html + '</td>';

		html = html + '<td id="zerotier_route_user_gateway_' + c["node"] + '">';
		html = html + c["gateway"];
		html = html + '</td>';
				
		html = html + '<td>';
		//html = html + '<input style="margin-top: 4px;margin-left:-3px;" id="td_node_' + c["node"] + '" class="remove_btn" type="button" onclick="delTr(this);" value="">';
		html = html + '<input style="margin:-2px 0px -4px -3px;" id="td_node_' + c["node"] + '" class="remove_btn" type="button" onclick="delTr(this);" title="删除" value="">';
		html = html + '</td>';
		html = html + '</tr>';
	}
	return html;
}
function close_peers_info() {
	//$("#zerotier_peers_status_div").fadeOut(200);
	E("zerotier_peers_status_div").style.visibility = "hidden";
	$("body").find(".fullScreen").fadeOut(0, function() { tableApi.removeElement("fullScreen"); });
}
function open_peers_info() {
	$('body').prepend(tableApi.genFullScreen());
	$('.fullScreen').show();
	document.scrollingElement.scrollTop = 0;
	E("zerotier_peers_status_div").style.visibility = "visible";
	var page_h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	var page_w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	var peer_h = E("zerotier_peers_status_div").clientHeight;
	var peer_w = E("zerotier_peers_status_div").clientWidth;
	var peer_h_offset = (page_h - peer_h) / 2;
	var peer_w_offset = (page_w - peer_w) / 2 + 90;
	$('#zerotier_peers_status_div').offset({top: peer_h_offset, left: peer_w_offset});
	//$("#zerotier_peers_status_div").fadeIn(500);
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "zerotier_peerss", "params":[], "fields": ""};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if(response.result == id){
				write_peers_status();
			}
		}
	});
}
function write_peers_status() {
	$.ajax({
		url: '/_temp/zerotier_peers_status.txt',
		type: 'GET',
		cache: false,
		dataType: 'text',
		success: function(res) {
			$('#ztpeers_status').val(res);
		}
	});
}
function get_moons_status() {
	// get snap file
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "zerotier_lsmoon", "params":[1], "fields": dbus};
	$.ajax({
		type: "POST",
		async: true,
		cache: false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			option_file = response.result.split( '>' );
			console.log(option_file);
			if(!option_file[0]){
				E("zerotier_deorbit_moon_id_tr").style.display = "none";
				return false;
			}else{
				// write deorbit option
				E("zerotier_deorbit_moon_id_tr").style.display = "";
				$("#zerotier_deorbit_moon_id").find('option').remove().end();
				for ( var i = 0; i < option_file.length; i++){
					$("#zerotier_deorbit_moon_id").append('<option value="' + option_file[i] + '">' + option_file[i]  + '</option>');
				}
			}
		},
		error: function() {
			E("zerotier_deorbit_moon_id_tr").style.display = "none";
			return false;
		}
	});
}
function open_moons_sett() {
	$('body').prepend(tableApi.genFullScreen());
	$('.fullScreen').show();
	get_moons_status();
	document.scrollingElement.scrollTop = 0;
	E("zt_moons_settings").style.visibility = "visible";
	var page_h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	var page_w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	var moon_h = E("zt_moons_settings").clientHeight;
	var moon_w = E("zt_moons_settings").clientWidth;
	var moon_h_offset = (page_h - moon_h) / 2 - 90;
	var moon_w_offset = (page_w - moon_w) / 2 + 90;
	if(moon_h_offset < 0){
		moon_h_offset = 10;
	}
	$('#zt_moons_settings').offset({top: moon_h_offset, left: moon_w_offset});
}
function close_moons_sett() {
	E("zt_moons_settings").style.visibility = "hidden";
	$("body").find(".fullScreen").fadeOut(0, function() { tableApi.removeElement("fullScreen"); });
}
function upload_moon() {
	var file_name = $("#file").val();
	if(!file_name){
		alert('文件为空，请选择备份文件！');
		return false;
	}
	
	file_name = file_name.split('\\');
	file_name = file_name[file_name.length - 1];
	//console.log("file_name: ", file_name);

	// 文件名
	file_splits = file_name.split('\.');
	if(file_splits.length !=2){
		alert('moon配置文件的文件名不正确！\n\n正确的文件名示例：0000003bcf160f91.moon');
		return false;
	}
	
	file_prefix = file_splits[file_splits.length - 2];
	file_suffix = file_splits[file_splits.length - 1];
	//console.log("file_prefix: ", file_prefix);
	//console.log("file_suffix: ", file_suffix);
	
	// 后缀
	if(file_suffix != "moon"){
		alert('备份文件的文件名后缀不正确！\n\n正确的文件名示例：0000003bcf160f91.moon');
		return false;
	}
	// 前缀
	var regExp = /^000000/g;
	if(!regExp.test(file_prefix)){
		alert('备份文件的文件名前缀不正确！\n\n正确的文件名示例：0000003bcf160f91.moon');
		return false;	
	}

	document.getElementById('file_info').style.display = "none";
	var formData = new FormData();
	formData.append(file_name, $('#file')[0].files[0]);
	//changeButton(true);
	$.ajax({
		url: '/_upload',
		type: 'POST',
		cache: false,
		data: formData,
		processData: false,
		contentType: false,
		complete: function(res) {
			if (res.status == 200) {
				var Info = {
					"zerotier_moon_name": file_name,
				};
				document.getElementById('file_info').style.display = "block";
				apply_uppoaded_moon(Info);
			}
		}
	});
}

function apply_uppoaded_moon(Info) {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "zerotier_config", "params": ["upload_moon"], "fields": Info };
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if(response.result == id){
				$("#zt_moons_settings").fadeOut();
				$("body").find(".fullScreen").fadeOut(0, function() { tableApi.removeElement("fullScreen"); });
				get_log();
			}
		}
	});
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
					<textarea cols="50" rows="26" wrap="off" readonly="readonly" id="log_content" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" ></textarea>
				</div>
				<div id="ok_button" class="apply_gen" style="background:#000;visibility:hidden;">
					<input id="ok_button1" class="button_gen" type="button" onclick="hideWBLoadingBar()" value="确定">
				</div>
				</td>
			</tr>
		</table>
	</div>
	<!--============================this is the popup area for zerotier peers status=================================-->
	<div id="zerotier_peers_status_div" class="content_status">
		<div class="user_title">zerotier peers 状态</div>
		<div style="margin-left:15px"><i>此处展示命令：zerotier-cli peers 显示的内容。</i></div>
		<div style="margin: 10px 10px 10px 15px;width:718px;text-align:center;overflow:hidden;outline:1px solid #818181;padding-top:10px">
			<textarea cols="63" rows="18" wrap="off" id="ztpeers_status" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
		</div>
		<div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
			<input class="button_gen" type="button" onclick="close_peers_info();" value="返回主界面">
		</div>
	</div>
	<!--===================================Ending of zerotier peers status===========================================-->
	<!--============================this is the popup area for zerotier moons========================================-->
	<div id="zt_moons_settings" class="contentM_qis pop_div_bg">
		<table class="QISform_wireless" border="0" align="center" cellpadding="5" cellspacing="0">
			<tr>
				<td>
					<div class="user_title">zerotier moons 配置</div>
					<div id="zt_moons_settings_div">
						<table id="table_edit" style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
							<thead>
								<tr>
									<td colspan="2">zerotier - moon</td>
								</tr>
							</thead>
							<tr>
								<th>通过上传配置文件加入moon</th>
								<td>
									&nbsp;<a class="ks_btn bt3" href="javascript:void(0);" onclick="upload_moon()" style="display: inline;">上传moon配置</a>
									<input style="color:#FFCC00;*color:#000;width: 260px;vertical-align: middle;" id="file" type="file" name="file">
									<img id="loadingicon" style="margin-left:5px;margin-right:5px;display:none;" src="/images/InternetScan.gif">
									<span id="file_info" style="display:none;">完成</span>
								</td>
							</tr>
							<tr>
								<th>通过moon id加入moon </th>
								<td>
									<input class="input_ss_table" type="text" id="zerotier_moon_id" value="" placeholder="输入moon的id">
									&nbsp;<a type="button" class="ks_btn" style="cursor: pointer; display: inline;" onclick="orbit_moon()">oribit（加入moon）</a>
								</td>
							</tr>
							<tr id="zerotier_deorbit_moon_id_tr" style="display:none;">
								<th>离开moon/删除moon配置</th>
								<td>
									<select id="zerotier_deorbit_moon_id" onchange="update_visibility();" class="input_option" style="width:auto;margin:0px 0px 0px 2px;">
									</select>
									&nbsp;<a type="button" class="ks_btn" style="cursor: pointer; display: inline;" onclick="deorbit_moon()">deoribit（离开moon）</a>
								</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
		<span style="margin-left:30px">加入moon有两种方法：1. 通过上传配置文件加入moon；2. 通过id加入moon。选择其一即可！</span>
		<div style="padding-top:10px;padding-bottom:10px;width:100%;text-align:center;">
			<input class="button_gen" type="button" onclick="close_moons_sett();" id="cancelBtn" value="返回">
		</div>
	</div>
	<!--===================================Ending of zerotier moons settings===========================================-->
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
										<div class="formfonttitle">ZeroTier<lable id="zerotier_version"></lable></div>
										<div style="float:right; width:15px; height:25px;margin-top:-20px">
											<img id="return_btn" onclick="reload_Soft_Center();" align="right" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
										</div>
										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote">
											<span>Zerotier是一款开源，跨平台，简单易用的内网穿透工具，轻松帮你实现虚拟局域网的组建。</span>
											<span><a type="button" href="https://github.com/koolshare/rogsoft/blob/master/zerotier/Changelog.txt" target="_blank" class="ks_btn" style="margin-left:5px;" >更新日志</a></span>
											<span><a type="button" class="ks_btn" href="javascript:void(0);" onclick="get_log(1)" style="margin-left:5px;">查看日志</a></span>
										</div>

										<div id="zerotier_main">
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable">
												<thead>
													<tr>
														<td colspan="2">zerotier - 设定</td>
													</tr>
												</thead>
												<tr id="switch_tr">
													<th>开关</th>
													<td>
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="zerotier_enable">
																<input id="zerotier_enable" class="switch" type="checkbox" style="display: none;">
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
												<tr id="zeroTier_status_tr" style="display:none;">
													<th>运行状态</th>
													<td>
														<span style="margin-left:4px" id="zerotier_status"></span>
													</td>
												</tr>
												<tr id="zeroTier_nat_tr" style="display:none;">
													<th title="允许Zerotier的拨入客户端访问路由器LAN资源（需要在 Zerotier管理页面设定到LAN网段的路由表）">自动允许客户端NAT</th>
													<td>
														<input type="checkbox" id="zerotier_nat" style="vertical-align:middle;" checked="checked">
													</td>
												</tr>
												<tr id="zeroTier_id_tr" style="display:none;">
													<th>join network</th>
													<td>
														<span style="margin-left:4px" id="zerotier_info"></span>
														<input style="width:150px;" type="text" class="input_ss_table" id="zerotier_id" name="zerotier_id" maxlength="22" value="" autocorrect="off" autocapitalize="off" placeholder="zerotier network id">
														<input style="margin:-2px 0px -12px -3px;" id="zerotier_jion_btn" class="add_btn" type="button" onclick="join_network();" title="点击后加入zerotier网络" value="">
													</td>
												</tr>
												<tr id="zerotier_console_tr">
													<th title="点击跳转到Zerotier官网管理平台，新建或者管理网络，并允许客户端接入访问你私人网路（新接入的节点默认不允许访问）">zerotier官网</th>
													<td>
														<a type="button" id="zerotier_website" class="ks_btn" href="https://my.zerotier.com/network" target="_blank" style="margin-left:2px">my.zerotier.com</a>
													</td>
												</tr>
												<tr id="zerotier_action_tr" style="display:none;">
													<th>其它</th>
													<td>
														<a type="button" id="zerotier_website" class="ks_btn" onclick="open_peers_info();" target="_blank" style="margin-left:2px">zerotier peers</a>
														<a type="button" id="zerotier_website" class="ks_btn" onclick="open_moons_sett();" target="_blank" style="margin-left:2px">zerotier moons</a>
													</td>
												</tr>
											</table>
										</div>
										<div id="zerotier_ztnets" style="margin:10px 0px 0px 0px;display:none;">
											<table id="zerotier_ztnets_status" style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable_table">
												<thead>
													<tr>
														<td colspan="5">zerotier - 网口状态</td>
													</tr>
												</thead>
												<tr>
													<th style="width:20%">接口</th>
													<th style="width:20%">IP</th>
													<th style="width:20%">MAC</th>
													<th style="width:20%">下行</th>
													<th style="width:20%">上行</th>
												</tr>
											</table>
										</div>
										<div id="zerotier_interface" style="margin:10px 0px 0px 0px;display:none;">
										</div>
										<div id="zerotier_route_div" style="margin:10px 0px 0px 0px;display:none;">
											<div id="zerotier_route_div_2">
												<table id="zerotier_route_table" style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable_table">
													<thead>
													<tr>
														<td colspan="4">zerotier - 路由表</td>
													</tr>
													</thead>
													<tr>
														<th style="width:6%">启用</th>
														<th style="width:44%">IP地址</th>
														<th style="width:44%">网关</th>
														<!--<th style="width:6%">操作</th>-->
													</tr>
													<!--<tr id="zerotier_route_add_tr">
														<td>
															<input type="checkbox" id="zerotier_route_enable" checked="checked" />
														</td>
														<td>
															<input type="text" id="zerotier_route_ipaddr" name="zerotier_route_ipaddr" class="input_ss_table" maxlength="50" style="width:180px;text-align: center;" placeholder="" value=""/>
														</td>
														<td>
															<input type="text" id="zerotier_route_gateway" name="zerotier_route_gateway" class="input_ss_table" maxlength="50" style="width:180px;text-align: center;" placeholder="" value="" />
														</td>
														<td style="width:66px">
															<input style="margin:-2px 0px -4px -3px;" id="dd_node_1" class="add_btn" type="button" onclick="addTr(this);" title="添加" value="">
														</td>
													</tr>-->
												</table>
											</div>
											<span>▲ 此路由表为zerotier后台下发的路由表，仅做展示，需要添加/修改请前往zerotier后台。</span>
											<!--<span>▲ 如需访问其它zerotier的内网LAN网段，将IP、网关和zerotier后台对应填写即可（本机的LAN网段不用填）</span>-->
										</div>
										<div id="zerotier_jion_btn_div" class="apply_gen" style="display:none;">
											<input class="button_gen" id="zerotier_jion_btn" onClick="save()" type="button" value="重启插件" />
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

