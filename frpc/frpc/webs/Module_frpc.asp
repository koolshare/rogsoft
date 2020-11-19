<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!-- version: 2.1.8 -->
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - Frp内网穿透</title>
<link rel="stylesheet" type="text/css" href="index_style.css" />
<link rel="stylesheet" type="text/css" href="form_style.css" />
<link rel="stylesheet" type="text/css" href="usp_style.css" />
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/res/layer/theme/default/layer.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/calendar/jquery-ui.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<style type="text/css">
.show-btn1, .show-btn2 {
    border: 1px solid #222;
    background: #576d73;
    background: linear-gradient(to bottom, #91071f  0%, #700618 100%); /* W3C rogcss*/
    font-size:10pt;
    color: #fff;
    padding: 10px 3.75px;
    border-radius: 5px 5px 0px 0px;
    width:15%;
    border: 1px solid #91071f; /* W3C rogcss*/
    background: none; /* W3C rogcss*/
    }
.active {
    background: #2f3a3e;
    background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%); /* W3C rogcss*/
    border: 1px solid #91071f; /* W3C rogcss*/
}
.close {
    background: red;
    color: black;
    border-radius: 12px;
    line-height: 18px;
    text-align: center;
    height: 18px;
    width: 18px;
    font-size: 16px;
    padding: 1px;
    top: -10px;
    right: -10px;
    position: absolute;
}
/* use cross as close button */
.close::before {
    content: "\2716";
}
.contentM_qis {
    position: fixed;
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    border-radius:10px;
    z-index: 10;
    background-color:#2B373B;
    /*margin-left: -100px;*/
    top: 100px;
    width:755px;
    return height:auto;
    box-shadow: 3px 3px 10px #000;
    background: rgba(0,0,0,0.85);
    display:none;
}

.user_title{
    text-align:center;
    font-size:18px;
    color:#99FF00;
    padding:10px;
    font-weight:bold;
}
.frpc_btn {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #003333  0%, #000000 100%); /* W3C */
	background: linear-gradient(to bottom, #91071f  0%, #700618 100%); /* W3C rogcss*/
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
}
.frpc_btn:hover {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%); /* W3C */
	background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%); /* W3C rogcss*/
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
}
#frpc_config {
	width:99%;
	font-family:'Lucida Console';
	font-size:12px; background:#475A5F;
	color:#FFFFFF;
	text-transform:none;
	margin-top:5px;
	overflow:scroll;
	background:transparent; /* W3C rogcss*/
	border:1px solid #91071f; /* W3C rogcss*/
}
.formbottomdesc {
    margin-top:10px;
    margin-left:10px;
}
input[type=button]:focus {
    outline: none;
}
</style>
<script>
var myid;
var db_frpc = {};
var node_max = 0;
var params_input = ["frpc_common_ddns", "frpc_domain", "frpc_common_cron_time", "frpc_common_cron_hour_min", "frpc_common_server_addr", "frpc_common_server_port", "frpc_common_protocol", "frpc_common_tcp_mux", "frpc_common_login_fail_exit", "frpc_common_privilege_token", "frpc_common_vhost_http_port", "frpc_common_vhost_https_port", "frpc_common_user", "frpc_common_log_file", "frpc_common_log_level", "frpc_common_log_max_days"]
var params_check = ["frpc_enable", "frpc_customize_conf"]
var params_base64 = ["frpc_config"]

function initial() {
	show_menu(menu_hook);
	get_dbus_data();
	get_status();
	toggle_func();
	conf2obj();
	buildswitch();
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/frpc",
		dataType: "json",
		async: false,
		success: function(data) {
			db_frpc = data.result[0];
			conf2obj();
			$("#frpc_version_show").html("插件版本：" + db_frpc["frpc_version"]);
		}
	});
}

function conf2obj() {
	//input
	for (var i = 0; i < params_input.length; i++) {
		if(db_frpc[params_input[i]]){
			E(params_input[i]).value = db_frpc[params_input[i]];
		}
	}
	// checkbox
	for (var i = 0; i < params_check.length; i++) {
		if(db_frpc[params_check[i]]){
			E(params_check[i]).checked = db_frpc[params_check[i]] == 1 ? true : false
		}
	}
	//base64
	for (var i = 0; i < params_base64.length; i++) {
		if(db_frpc[params_base64[i]]){
			E(params_base64[i]).value = Base64.decode(db_frpc[params_base64[i]]);
		}
	}
	//dfnamic table data
	$("#conf_table").find("tr:gt(2)").remove();
	$('#conf_table tr:last').after(refresh_html());
}

function get_status() {
		var postData = {
			"id": parseInt(Math.random() * 100000000),
			"method": "frpc_status.sh",
			"params": [],
			"fields": ""
		};
		$.ajax({
			type: "POST",
			cache: false,
			url: "/_api/",
			data: JSON.stringify(postData),
			dataType: "json",
			success: function(response) {
				E("status").innerHTML = response.result;
				setTimeout("get_status();", 10000);
			},
			error: function() {
				setTimeout("get_status();", 5000);
			}
		});
	}

function buildswitch() {
	$("#frpc_enable").click(
	function() {
		if (E('frpc_enable').checked) {
			document.form.frpc_enable.value = 1;
		} else {
			document.form.frpc_enable.value = 0;
		}
	});
}

function save() {
	if (E("frpc_customize_conf").checked) {
		if (trim(E("frpc_config").value) == "") {
			alert("提交的表单不能为空!");
			return false;
		}
	} else {
		if (trim(E("frpc_common_server_addr").value) == "" || trim(E("frpc_common_server_port").value) == "" || trim(E("frpc_common_privilege_token").value) == "" || trim(E("frpc_common_vhost_http_port").value) == "" || trim(E("frpc_common_vhost_https_port").value) == "" || trim(E("frpc_common_user").value) == "" || trim(E("frpc_common_cron_time").value) == "") {
			alert("提交的表单不能为空!");
			return false;
		}
	}
	showLoading();
	//input
	for (var i = 0; i < params_input.length; i++) {
		if (E(params_input[i]).value) {
			db_frpc[params_input[i]] = E(params_input[i]).value;
		}else{
			db_frpc[params_input[i]] = "";
		}
	}
	// checkbox
	for (var i = 0; i < params_check.length; i++) {
		db_frpc[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
	}
	//base64
	for (var i = 0; i < params_base64.length; i++) {
		if (!E(params_base64[i]).value) {
			db_frpc[params_base64[i]] = "";
		} else {
			if (E(params_base64[i]).value.indexOf("=") != -1) {
				db_frpc[params_base64[i]] = Base64.encode(E(params_base64[i]).value);
			} else {
				db_frpc[params_base64[i]] = "";
			}
		}
	}
	//console.log(db_frpc);
	// post data
	var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "frpc_config.sh", "params": [1], "fields": db_frpc };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
				refreshpage();
			}
		}
	});
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "Frpc 内网穿透");
	tablink[tablink.length - 1] = new Array("", "Module_frpc.asp");
}

function addTr(o) {
	var _form_addTr = document.form;
	if (trim(E("proto_node").value) == "tcp" || trim(E("proto_node").value) == "udp") {
		if (trim(E("subname_node").value) == "" || trim(E("localhost_node").value) == "" || trim(E("localport_node").value) == "" || trim(E("remoteport_node").value) == "") {
			alert("提交的表单不能为空!");
			return false;
		}
	} else if (trim(E("proto_node").value) == "stcp") {
		if (trim(E("subname_node").value) == "" || trim(E("subdomain_node").value) == "" || trim(E("localhost_node").value) == "" || trim(E("localport_node").value) == "" || trim(E("remoteport_node").value) == "") {
			alert("提交的表单不能为空!");
			return false;
		}
	} else {
		if (trim(E("subname_node").value) == "" || trim(E("subdomain_node").value) == "" || trim(E("localhost_node").value) == "" || trim(E("localport_node").value) == "" || trim(E("remoteport_node").value) == "") {
			alert("提交的表单不能为空!");
			return false;
		}
	}
	var ns = {};
	var p = "frpc";
	node_max += 1;
	var params = ["proto_node", "subname_node", "subdomain_node", "localhost_node", "localport_node", "remoteport_node", "encryption_node", "gzip_node"];
	if (!myid) {
		for (var i = 0; i < params.length; i++) {
			ns[p + "_" + params[i] + "_" + node_max] = $('#' + params[i]).val();
		}
	} else {
		for (var i = 0; i < params.length; i++) {
			ns[p + "_" + params[i] + "_" + myid] = $('#' + params[i]).val();
		}
	}
	var postData = {"id": parseInt(Math.random() * 100000000), "method": "dummy_script.sh", "params":[], "fields": ns };
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			//回传成功后，重新生成表格
			refresh_table();
			// 添加成功一个后将输入框清空
			document.form.proto_node.value = "tcp";
			document.form.subname_node.value = "";
			document.form.subdomain_node.value = "none";
			document.form.localhost_node.value = "";
			document.form.localport_node.value = "";
			document.form.remoteport_node.value = "";
			document.form.encryption_node.value = "true";
			document.form.gzip_node.value = "true";
			E('remoteport_node').disabled = false;
			E('subdomain_node').disabled = true;
		}
	});
}

function delTr(o) { //删除配置行功能
	if (confirm("你确定删除吗？")) {
		//定位每行配置对应的ID号
		var id = $(o).attr("id");
		var ids = id.split("_");
		var p = "frpc";
		id = ids[ids.length - 1];
		// 定义ns数组，用于回传给dbus
		var ns = {};
		var params = ["proto_node", "subname_node", "subdomain_node", "localhost_node", "localport_node", "remoteport_node", "encryption_node", "gzip_node"];
		for (var i = 0; i < params.length; i++) {
			//空的值，用于清除dbus中的对应值
			ns[p + "_" + params[i] + "_" + id] = "";
		}
		//回传删除数据操作给dbus接口
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

function refresh_table() {
	$.ajax({
		type: "GET",
		url: "/_api/frpc",
		dataType: "json",
		async: false,
		success: function(data) {
			db_frpc = data.result[0];
			$("#conf_table").find("tr:gt(2)").remove();
			$('#conf_table tr:last').after(refresh_html());
		}
	});
}

function editlTr(o) { //编辑节点功能，显示编辑面板
	checkTime = 2001; //编辑节点时停止可能在进行的刷新
	var id = $(o).attr("id");
	var ids = id.split("_");
	confs = getAllConfigs();
	id = ids[ids.length - 1];
	var c = confs[id];

	document.form.proto_node.value = c["proto_node"];
	document.form.subname_node.value = c["subname_node"];
	document.form.subdomain_node.value = c["subdomain_node"];
	document.form.localhost_node.value = c["localhost_node"];
	document.form.localport_node.value = c["localport_node"];
	remoteport = document.form.proto_node.value;
	if (remoteport == "http") {
		E('remoteport_node').disabled = true;
		E('subdomain_node').disabled = false;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('remoteport_node').value = c["common_vhost_http_port"];
	} else if (remoteport == "https") {
		E('remoteport_node').disabled = true;
		E('subdomain_node').disabled = false;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('remoteport_node').value = c["common_vhost_https_port"];
	} else if (remoteport == "stcp") {
		E('remoteport_node').disabled = true;
		E('subdomain_node').disabled = false;
		E('encryption_node').disabled = true;
		E('gzip_node').disabled = true;
		E('remoteport_node').value = "none";
	} else if (remoteport == "tcp") {
		E('remoteport_node').disabled = false;
		E('subdomain_node').disabled = true;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('subdomain_node').value = "none";
	} else if (remoteport == "udp") {
		E('remoteport_node').disabled = false;
		E('subdomain_node').disabled = true;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('subdomain_node').value = "none";
	}
	document.form.remoteport_node.value = c["remoteport_node"];
	document.form.encryption_node.value = c["encryption_node"];
	document.form.gzip_node.value = c["gzip_node"];
	myid = id;
}

function getAllConfigs() {
	var dic = {};
	for (var field in db_frpc) {
		names = field.split("_");
		dic[names[names.length - 1]] = 'ok';
	}
	confs = {};
	var p = "frpc";
	var params = ["proto_node", "subname_node", "subdomain_node", "localhost_node", "localport_node", "remoteport_node", "encryption_node", "gzip_node"];
	for (var field in dic) {
		var obj = {};
		for (var i = 0; i < params.length; i++) {
			var ofield = p + "_" + params[i] + "_" + field;
			if (typeof db_frpc[ofield] == "undefined") {
				obj = null;
				break;
			}
			obj[params[i]] = db_frpc[ofield];
		}
		if (obj != null) {
			var node_i = parseInt(field);
			if (node_i > node_max) {
				node_max = node_i;
			}
			obj["node"] = field;
			confs[field] = obj;
		}
	}
	return confs;
}

function refresh_html() {
	confs = getAllConfigs();
	var n = 0;
	for (var i in confs) {
		n++;
	}
	var html = '';
	for (var field in confs) {
		var c = confs[field];
		html = html + '<tr>';
		html = html + '<td>' + c["proto_node"] + '</td>';
		if (c["proto_node"] == "stcp") {
			html = html + '<td><a href="javascript:void(0)" onclick="open_conf(\'stcp_settings\');" style="cursor:pointer;"><i><u>' + c["subname_node"] + '</u></i></a></td>';
		} else {
			html = html + '<td>' + c["subname_node"] + '</td>';
		}
		if ((c["proto_node"] == "tcp" || c["proto_node"] == "udp") && c["subdomain_node"] == "none") {
			html = html + '<td>' + "-" + '</td>';
		} else {
			html = html + '<td>' + c["subdomain_node"] + '</td>';
		}
		html = html + '<td>' + c["localhost_node"] + '</td>';
		html = html + '<td>' + c["localport_node"] + '</td>';
		if (c["proto_node"] == "stcp" && c["remoteport_node"] == "none") {
			html = html + '<td>' + "-" + '</td>';
		} else {
			html = html + '<td>' + c["remoteport_node"] + '</td>';
		}
		if (c["proto_node"] == "stcp") {
			html = html + '<td>' + "-" + '</td>';
			html = html + '<td>' + "-" + '</td>';
		} else {
			html = html + '<td>' + c["encryption_node"] + '</td>';
			html = html + '<td>' + c["gzip_node"] + '</td>';
		}
		html = html + '<td>';
		html = html + '<input style="margin-left:-3px;" id="dd_node_' + c["node"] + '" class="edit_btn" type="button" onclick="editlTr(this);" value="">'
		html = html + '</td>';
		html = html + '<td>';
		html = html + '<input style="margin-top: 4px;margin-left:-3px;" id="td_node_' + c["node"] + '" class="remove_btn" type="button" onclick="delTr(this);" value="">'
		html = html + '</td>';
		html = html + '</tr>';
	}
	return html;
}

/*
function get_frpc_conf() {
	$.ajax({
		url: '/res/frpc_conf.html',
		dataType: 'html',

		error: function(xhr) {
			setTimeout("get_frpc_conf();", 400);
		},
		success: function(response) {
			E("frpctxt").value = response;
			return true;
		}
	});
}
*/

function get_frpc_conf() {
	$.ajax({
		url: '/_temp/.frpc.ini',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(res) {
			$('#frpctxt').val(res);
		}
	});
}

function get_stcp_conf() {
	$.ajax({
		url: '/_temp/.frpc_stcp.ini',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(res) {
			$('#usertxt').val(res);
		}
	});
}

function open_conf(open_conf) {
	if (open_conf == "frpc_settings") {
		get_frpc_conf();
		console.log("2222")
	}
	if (open_conf == "stcp_settings") {
		get_stcp_conf();
		console.log("444")
	}
	$("#" + open_conf).fadeIn(200);
}

function close_conf(close_conf) {
	$("#" + close_conf).fadeOut(200);
}

function toggle_func() {
	E("simple_table").style.display = "";
	E("conf_table").style.display = "";
	E("customize_conf_table").style.display = "none";
	$('.show-btn1').addClass('active');
	$(".show-btn1").click(
		function() {
			$('.show-btn1').addClass('active');
			$('.show-btn2').removeClass('active');
			E("simple_table").style.display = "";
			E("conf_table").style.display = "";
			E("customize_conf_table").style.display = "none";
		}
	);
	$(".show-btn2").click(
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn2').addClass('active');
			E("simple_table").style.display = "none";
			E("conf_table").style.display = "none";
			E("customize_conf_table").style.display = "";
		}
	);
}

function proto_onchange() {
	var remoteport = "";
	var obj = E('proto_node');
	var index = obj.selectedIndex; //序号，取当前选中选项的序号
	var r_https_port = "<%  nvram_get(https_lanport); %>"
	var r_ssh_port = "<%  nvram_get(sshd_port); %>"
	var r_computer_name = "<%  nvram_get(computer_name); %>"
	var r_lan_ipaddr = "<% nvram_get(lan_ipaddr); %>"
	var r_subname_node_http = r_computer_name + '-http';
	var r_subname_node_https = r_computer_name + '-https';
	var r_subname_node_ssh = r_computer_name + '-ssh';
	//alert(r_https_port);
	vhost_http_port = E("frpc_common_vhost_http_port").value;
	vhost_https_port = E("frpc_common_vhost_https_port").value;
	remoteport = obj.options[index].text;
	if (remoteport == "http") {
		E('remoteport_node').disabled = true;
		E('subdomain_node').disabled = false;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('subdomain_node').value = "";
		E('remoteport_node').value = vhost_http_port;
	} else if (remoteport == "https") {
		E('remoteport_node').disabled = true;
		E('subdomain_node').disabled = false;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('subdomain_node').value = "";
		E('remoteport_node').value = vhost_https_port;
	} else if (remoteport == "tcp") {
		E('remoteport_node').disabled = false;
		E('subdomain_node').disabled = true;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('subdomain_node').value = "none";
	} else if (remoteport == "udp") {
		E('remoteport_node').disabled = false;
		E('subdomain_node').disabled = true;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('subdomain_node').value = "none";
	} else if (remoteport == "stcp") {
		E('remoteport_node').disabled = true;
		E('subdomain_node').disabled = false;
		E('encryption_node').disabled = true;
		E('gzip_node').disabled = true;
		E('subdomain_node').value = "";
		E('remoteport_node').value = "none";
	} else if (remoteport == "router-http") {
		E('remoteport_node').disabled = true;
		E('subdomain_node').disabled = false;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('subdomain_node').value = "";
		E('remoteport_node').value = vhost_http_port;
		E('subname_node').value = r_subname_node_http;
		E('localhost_node').value = "127.0.0.1";
		E('localport_node').value = "80";
	} else if (remoteport == "router-https") {
		E('remoteport_node').disabled = true;
		E('subdomain_node').disabled = false;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('subdomain_node').value = "";
		E('remoteport_node').value = vhost_https_port;
		E('subname_node').value = r_subname_node_https;
		E('localhost_node').value = "127.0.0.1";
		E('localport_node').value = r_https_port;
	} else if (remoteport == "router-ssh") {
		E('remoteport_node').disabled = false;
		E('remoteport_node').value = "";
		E('subdomain_node').disabled = true;
		E('subdomain_node').value = "none";
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('subname_node').value = r_subname_node_ssh;
		E('localhost_node').value = r_lan_ipaddr;
		E('localport_node').value = r_ssh_port;
	} else if (remoteport == "router-ssh-stcp") {
		E('remoteport_node').disabled = true;
		E('subdomain_node').disabled = false;
		E('encryption_node').disabled = false;
		E('gzip_node').disabled = false;
		E('subdomain_node').value = "";
		E('remoteport_node').value = "none";
		E('subname_node').value = r_subname_node_ssh;
		E('localhost_node').value = r_lan_ipaddr;
		E('localport_node').value = r_ssh_port;
	}
}

function openssHint(itemNum) {
	statusmenu = "";
	width = "350px";

	if (itemNum == 0) {
		statusmenu = "如果发现开关不能开启，那么请检查<a href='Advanced_System_Content.asp'><u><font color='#00F'>系统管理 -- 系统设置</font></u></a>页面内Enable JFFS custom scripts and configs是否开启。";
		_caption = "服务器说明";
	} else if (itemNum == 1) {
		statusmenu = "此处填入你的frp服务器的地址。</br>建议优先填入<font color='#F46'>IP地址</font>。填入域名，特别是一些服务商给的复杂域名，有时遇到无法解析会导致无法连接!";
		_caption = "服务器";
	} else if (itemNum == 2) {
		statusmenu = "此处填入你的frp服务器的端口，对应服务器配置文件中的节[common]下的bind_port字段";
		_caption = "服务器端口";
	} else if (itemNum == 3) {
		statusmenu = "此处填入你的frp服务器的特权授权码。对应服务器配置文件中的节[common]下的token字段。</br><font color='#F46'>注意：</font>使用带有特殊字符的密码，可能会导致frpc链接不上服务器。";
		_caption = "Token";
	} else if (itemNum == 4) {
		statusmenu = "此处填入你的frp服务器HTTP穿透服务的端口，对应服务器配置文件中的节[common]下的vhost_http_port字段";
		_caption = "HTTP穿透服务端口";
	} else if (itemNum == 5) {
		statusmenu = "此处填入你的frp服务器HTTPS穿透服务的端口，对应服务器配置文件中的节[common]下的vhost_https_port字段";
		_caption = "HTTPS穿透服务端口";
	} else if (itemNum == 6) {
		statusmenu = "此处是否开启frpc客户端日志。</br><font color='#F46'>注意：</font>默认不开启，开启后日志路径为/tmp/frpc.log";
		_caption = "日志记录";
	} else if (itemNum == 7) {
		statusmenu = "此处选择日志记录等级。</br>可选内容：info、warn、error、debug。";
		_caption = "日志等级";
	} else if (itemNum == 8) {
		statusmenu = "此处选择要保留的日志天数。";
		_caption = "日志记录天数";
	} else if (itemNum == 9) {
		statusmenu = "要穿透的协议类型，目前有http和tcp两种方式。";
		_caption = "协议类型";
	} else if (itemNum == 10) {
		statusmenu = "此处输入穿透内容的命名（描述），如：ac68u-web或ac68u-webshell，对应客户端配置文件中的节名称。</br><font color='#F46'>注意：</font>frp服务器上的所有命名不能重复！";
		_caption = "代理名称";
	} else if (itemNum == 11) {
		statusmenu = "此处输入穿透内容的域名，如：ac68u.frp.com，对应客户端配置文件中节下的custom_domains字段。</br><font color='#F46'>注意：</font>frp上运行的域名不能重复！";
		_caption = "域名配置";
	} else if (itemNum == 12) {
		statusmenu = "此处输入要穿透的内部主机IP地址，如：192.168.1.1";
		_caption = "内网主机地址";
	} else if (itemNum == 13) {
		statusmenu = "此处输入要穿透的内部主机的端口，如：80或22";
		_caption = "内网主机端口";
	} else if (itemNum == 14) {
		statusmenu = "此处输入服务器端端口用来映射内部主机端口，如：80或8080</br><font color='#F46'>注意：</font>";
		statusmenu += "</br><b><font color='#669900'>http协议：</font></b>选择http协议时，远程主机端口对应服务器配置文件中的节[common]下的vhost_http_port字段值。";
		statusmenu += "</br><b><font color='#669900'>https协议：</font></b>选择https协议时，远程主机端口对应服务器配置文件中的节[common]下的vhost_https_port字段值。https协议只能对应穿透内网https协议。";
		statusmenu += "</br><b><font color='#669900'>tcp协议：</font></b>选择tcp协议时，远程主机端口应在服务器配置文件中的节[common]下的privilege_allow_ports字段值范围内。";
		_caption = "远程主机端口";
	} else if (itemNum == 15) {
		statusmenu = "如果公司内网防火墙对外网访问进行了流量识别与屏蔽，例如禁止了 ssh 协议等，通过设置加密，将 frpc 与 frps 之间的通信内容加密传输，将会有效防止流量被拦截。";
		_caption = "加密";
	} else if (itemNum == 16) {
		statusmenu = "如果传输的报文长度较长，通过设置对传输内容进行压缩，可以有效减小 frpc 与 frps 之间的网络流量，加快流量转发速度，但是会额外消耗一些 cpu 资源。";
		_caption = "压缩";
	} else if (itemNum == 17) {
		statusmenu = "定时到Frp服务器上重新注册服务，以便Frp提供持续的服务。</br><font color='#F46'>注意：</font>填写内容为0时关闭该功能！";
		_caption = "定时注册服务";
	} else if (itemNum == 18) {
		statusmenu = "如果穿透服务配置中内网主机地址是路由器管理地址，并且内网主机端口为80时，在网络地图DDNS处显示相应的域名配置。</br><font color='#F46'>注意：</font>此功能与路由系统自带的DDNS功能冲突，frp的DDNS显示设置会覆盖系统自带的DDNS设置！";
		_caption = "DDNS显示设置";
	} else if (itemNum == 19) {
		statusmenu = "穿透服务的用户名称，如AC68U 配置结果为 {用户名称}.{代理名称}";
		_caption = "Frpc用户名称";
	} else if (itemNum == 20) {
		statusmenu = "从 v0.12.0 版本开始，底层通信协议支持选择 kcp 协议，在弱网环境下传输效率提升明显，但是会有一些额外的流量消耗";
		_caption = "底层通信协议";
	} else if (itemNum == 21) {
		statusmenu = "从 v0.10.0 版本开始，客户端和服务器端之间的连接支持多路复用，不再需要为每一个用户请求创建一个连接，使连接建立的延迟降低，并且避免了大量文件描述符的占用，使 frp 可以承载更高的并发数。</br>该功能默认启用，如需关闭，可以在 frps.ini 和 frpc.ini 中配置，该配置项在服务端和客户端必须一致.";
		_caption = "TCP 多路复用";
	} else if (itemNum == 22) {
		statusmenu = "当客户端连接服务器失败后的动作：</br>失败后重复连接</br>失败后退出客户端";
		_caption = "连接设置";
	} else if (itemNum == 23) {
		statusmenu = "按照官方教程自己编写配置文件";
		_caption = "自定义配置";
	}
	return overlib(statusmenu, OFFSETX, -160, LEFT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, '');

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
</script>
</head>
<body onload="initial();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="POST" name="form" action="/applydb.cgi?p=frpc" target="hidden_frame">
<input type="hidden" name="current_page" value="Module_frpc.asp"/>
<input type="hidden" name="next_page" value="Module_frpc.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="5"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="config-frpc.sh"/>
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
                        <table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3"  class="FormTitle" id="FormTitle">
                            <tr>
                                <td bgcolor="#4D595D" colspan="3" valign="top">
                                    <div>&nbsp;</div>
                                    <div style="float:left;" class="formfonttitle">软件中心 - Frpc内网穿透</div>
                                    <div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
                                    <div style="margin:30px 0 10px 5px;" class="splitLine"></div>
                                    <div class="formfontdesc"><i>* 为了Frpc稳定运行，请开启虚拟内存功能！！！</i>&nbsp;&nbsp;&nbsp;&nbsp;【<a href="http://koolshare.cn/thread-65379-1-1.html"  target="_blank"><i>服务器搭建教程</i></a>】</div>
                                    <div id="frpc_switch_show">
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                        <tr id="switch_tr">
                                            <th>
                                                <label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(0)">开启Frpc</a></label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="frpc_enable">
                                                        <input id="frpc_enable" class="switch" type="checkbox" style="display: none;">
                                                        <div class="switch_container" >
                                                            <div class="switch_bar"></div>
                                                            <div class="switch_circle transition_style">
                                                                <div></div>
                                                            </div>
                                                        </div>
                                                    </label>
                                                </div>
                                                <div id="frpc_version_show" style="padding-top:5px;margin-left:30px;margin-top:0px;float: left;"></div>
                                                <div id="frpc_changelog_show" style="padding-top:5px;margin-right:10px;margin-top:0px;float: right;">
                                                    <a type="button" class="frpc_btn" style="cursor:pointer" href="https://raw.githubusercontent.com/koolshare/rogsoft/master/frpc/Changelog.txt" target="_blank">更新日志</a> <a type="button" class="frpc_btn" style="cursor:pointer" target="_blank" href="https://github.com/fatedier/frp/blob/master/README_zh.md">自定义配置帮助</a>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr id="frpc_status">
                                            <th width="20%">运行状态</th>
                                            <td><span id="status">获取中...</span>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(18)">DDNS显示设置</a></th>
                                            <td>
                                                <select id="frpc_common_ddns" name="frpc_common_ddns" style="margin:0px 0px 0px 2px;" class="input_option">
                                                    <option value="2" selected="selected">不做更改</option>
                                                    <option value="1">开启</option>
                                                    <option value="0">关闭</option>
                                                </select>
                                                <input type="text" class="input_ss_table" id="frpc_domain" name="frpc_domain" maxlength="255" value="" placeholder="填入要显示的域名，如:router.xxx.com" style="width:330px;margin-top: 3px;" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(17)">定时注册服务</a>(<i>0为关闭</i>)</th>
                                            <td>
                                                每 <input type="text" id="frpc_common_cron_time" name="frpc_common_cron_time" class="input_3_table" maxlength="2" value="30" placeholder="" />
                                                <select id="frpc_common_cron_hour_min" name="frpc_common_cron_hour_min" style="width:60px;margin:3px 2px 0px 2px;" class="input_option">
                                                    <option value="min" selected="selected">分钟</option>
                                                    <option value="hour">小时</option>
                                                </select> 重新注册一次服务
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%">查看当前配置</th>
                                            <td>
                                                <a type="button" class="frpc_btn" style="cursor:pointer" href="javascript:void(0);" onclick="open_conf('frpc_settings');" >查看当前配置</a>
                                            </td>
                                        </tr>
                                    </table>
                                    </div>

                                    <div id="tablet_show">
                                        <table style="margin:10px 0px 0px 0px;border-collapse:collapse" width="100%" height="37px">
                                            <tr width="235px">
                                             <td colspan="4" cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#000">
                                               <input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="简单设置"/>
                                               <input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="自定义设置"/>
                                             </td>
                                             </tr>
                                        </table>
                                    </div>

                                    <div id="simple_table">
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="box-shadow: 3px 3px 10px #000;margin-top: 0px;">
                                        <thead>
                                            <tr>
                                            <td colspan="2">Frpc 简单设置</td>
                                            </tr>
                                        </thead>
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(1)">服务器</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" value="" id="frpc_common_server_addr" name="frpc_common_server_addr" maxlength="20" value="" placeholder=""/>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(2)">端口</a></th>
                                            <td>
                                        <input type="text" class="input_ss_table" id="frpc_common_server_port" name="frpc_common_server_port" maxlength="10" value="" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(20)">底层通信协议</a></th>
                                            <td>
                                                <select id="frpc_common_protocol" name="frpc_common_protocol" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="tcp">tcp</option>
                                                    <option value="kcp">kcp</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(21)">TCP 多路复用</a></th>
                                            <td>
                                                <select id="frpc_common_tcp_mux" name="frpc_common_tcp_mux" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="true">开启</option>
                                                    <option value="false">关闭</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(22)">连接设置</a></th>
                                            <td>
                                                <select id="frpc_common_login_fail_exit" name="frpc_common_login_fail_exit" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="true">失败后退出程序</option>
                                                    <option value="false">失败后重复连接</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(3)">Token</a></th>
                                            <td>
                                                <input type="password" name="frpc_common_privilege_token" id="frpc_common_privilege_token" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="256" value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);"/>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(4)">HTTP穿透服务端口</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" id="frpc_common_vhost_http_port" name="frpc_common_vhost_http_port" maxlength="6" value="" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(5)">HTTPS穿透服务端口</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" id="frpc_common_vhost_https_port" name="frpc_common_vhost_https_port" maxlength="6" value="" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(19)">Frpc用户名称</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" id="frpc_common_user" name="frpc_common_user" maxlength="50" value="" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(6)">日志记录</a></th>
                                            <td>
                                                <select id="frpc_common_log_file" name="frpc_common_log_file" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="/dev/null">关闭</option>
                                                    <option value="/tmp/frpc.log">开启</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(7)">日志等级</a></th>
                                            <td>
                                                <select id="frpc_common_log_level" name="frpc_common_log_level" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="info">info</option>
                                                    <option value="warn">warn</option>
                                                    <option value="error">error</option>
                                                    <option value="debug">debug</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(8)">日志记录天数</a></th>
                                            <td>
                                                <select id="frpc_common_log_max_days" name="frpc_common_log_max_days" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3" selected="selected">3</option>
                                                    <option value="4">4</option>
                                                    <option value="5">6</option>
                                                    <option value="6">6</option>
                                                    <option value="7">7</option>
                                                </select>
                                            </td>
                                        </tr>
                                    </table>
                                    <table id="conf_table" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable_table" style="box-shadow: 3px 3px 10px #000;margin-top: 10px;">
                                          <thead>
                                              <tr>
                                                <td colspan="10">穿透服务配置</td>
                                              </tr>
                                          </thead>

                                          <tr>
                                            <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(9)">协议类型</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(10)">代理名称</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(11)">域名配置/SK</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(12)">内网主机地址</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(13)">内网主机端口</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(14)">远程主机端口</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(15)">加密</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(16)">压缩</a></th>
                                          <th>修改</th>
                                          <th>添加/删除</th>
                                          </tr>
                                          <tr>
                                        <td>
                                            <select id="proto_node" name="proto_node" style="width:70px;margin:0px 0px 0px 2px;" class="input_option" onchange="proto_onchange()" >
                                                <option value="tcp">tcp</option>
                                                <option value="udp">udp</option>
                                                <option value="stcp">stcp</option>
                                                <option value="http">http</option>
                                                <option value="https">https</option>
                                                <option value="http">router-http</option>
                                                <option value="https">router-https</option>
                                                <option value="tcp">router-ssh</option>
                                                <option value="stcp">router-ssh-stcp</option>
                                            </select>

                                        </td>
                                         <td>
                                            <input type="text" id="subname_node" name="subname_node" class="input_6_table" maxlength="50" style="width:60px;" placeholder=""/>
                                        </td>
                                         <td>
                                            <input type="text" id="subdomain_node" name="subdomain_node" class="input_12_table" maxlength="250" value="none" placeholder="" disabled/>
                                        </td>
                                        <td>
                                            <input type="text" id="localhost_node" name="localhost_node" class="input_12_table" maxlength="20" placeholder=""/>
                                        </td>
                                        <td>
                                            <input type="text" id="localport_node" name="localport_node" class="input_6_table" maxlength="6" placeholder=""/>
                                        </td>
                                        <td>
                                            <input type="text" id="remoteport_node" name="remoteport_node" class="input_6_table" maxlength="6" placeholder=""/>
                                        </td>
                                        <td>
                                            <select id="encryption_node" name="encryption_node" style="width:50px;margin:0px 0px 0px 2px;" class="input_option" >
                                                <option value="true">是</option>
                                                <option value="false">否</option>
                                            </select>
                                        </td>
                                        <td>
                                            <select id="gzip_node" name="gzip_node" style="width:50px;margin:0px 0px 0px 2px;" class="input_option" >
                                                <option value="true">是</option>
                                                <option value="false">否</option>
                                            </select>
                                        </td>
                                        <td width="7%">
                                            <div>
                                            </div>
                                        </td>
                                        <td width="10%">
                                            <div>
                                                <input type="button" class="add_btn" onclick="addTr()" value=""/>
                                            </div>
                                        </td>
                                          </tr>
                                      </table>
                                    </div>

                                    <div id="customize_conf_table">
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable_table" style="box-shadow: 3px 3px 10px #000;margin-top: 0px;">
                                        <thead>
                                            <tr>
                                                <td colspan="2"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(23)">Frpc 高级配置</a></td>
                                            </tr>
                                        </thead>
                                            <tr>
                                                <th style="width:20%;">
                                                    <label><input type="checkbox" id="frpc_customize_conf" name="frpc_customize_conf"><i>自定义配置</i>
                                                </th>
                                                <td>
                                                    <textarea cols="50" rows="40" id="frpc_config" name="frpc_config" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" placeholder="[common]&#13;&#10;server_addr = 127.0.0.1&#13;&#10;server_port = 7000&#10;&#10;[ssh]&#10;type = tcp&#10;local_ip = 127.0.0.1&#10;local_port = 22&#10;remote_port = 6000" ></textarea>
                                                </td>
                                            </tr>
                                    </table>
                                    </div>
                                    <div style="margin:30px 0 10px 5px;" class="splitLine"></div>
                                    <div class="formbottomdesc" id="cmdDesc">
                                        <i>* 注意事项：</i><br>
                                        <i>1. 请使用虚拟内存！请使用虚拟内存！请使用虚拟内存！重要的事说三遍</i><br>
                                        <i>2. DDNS显示设置功能与系统自带的DDNS设置冲突，frp的DDNS显示设置会覆盖系统自带的DDNS设置！</i><br>
                                        <i>3. 上面所有内容都为必填项，请认真填写，不然无法穿透。</i><br>
                                        <i>4. 每一个文字都可以点击查看相应的帮助信息。</i><br>
                                        <i>5. 穿透设置中添加删除为本地实时生效，请谨慎操作，修改后请提交以便服务器端生效。</i><br>
                                    </div>
                                    <div class="apply_gen">
                                        <span><input class="button_gen_long" id="cmdBtn" onclick="save()" type="button" value="提交"/></span>
                                    </div>
                                </td>
                            </tr>
                        </table>
                                    <!-- this is the popup area for user rules -->
                                    <div id="frpc_settings"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">Frpc 配置文件&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="close_conf('frpc_settings');" value="关闭"><span class="close"></span></a></div>
                                        <div style="margin-left:15px"><i>1&nbsp;&nbsp;文本框内的内容保存在【/tmp/upload/.frpc.ini】。</i></div>
                                        <div style="margin-left:15px"><i>2&nbsp;&nbsp;请自行保存到本地，并根据实际情况进行修改，如有疑问请到frp官网求助。</i></div>
                                        <div id="user_tr" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="20" wrap="off" id="frpctxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" disabled="disabled"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node1" class="button_gen" type="button" onclick="close_conf('frpc_settings');" value="返回主界面">
                                        </div>
                                    </div>
                                    <div id="stcp_settings"  class="contentM_qis" style="box-shadow: 3px 3px 10px #000;margin-top: 70px;">
                                        <div class="user_title">Frpc stcp 配置文件参考&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" onclick="close_conf('stcp_settings');" value="关闭"><span class="close"></span></a></div>
                                        <div style="margin-left:15px"><i>1&nbsp;&nbsp;文本框内的内容保存在【/tmp/upload/.frpc_stcp.ini】。</i></div>
                                        <div style="margin-left:15px"><i>2&nbsp;&nbsp;请自行保存到本地，并根据实际情况进行修改，如有疑问请到frp官网求助。</i></div>
                                        <div id="user_tr" style="margin: 10px 10px 10px 10px;width:98%;text-align:center;">
                                            <textarea cols="50" rows="20" wrap="off" id="usertxt" style="width:97%;padding-left:10px;padding-right:10px;border:1px solid #222;font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;outline: none;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" disabled="disabled"></textarea>
                                        </div>
                                        <div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
                                            <input id="edit_node2" class="button_gen" type="button" onclick="close_conf('stcp_settings');" value="返回主界面">
                                        </div>
                                    </div>
                                    <!-- end of the popouparea -->
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <!--===================================Ending of Main Content===========================================-->
        </td>
        <td width="10" align="center" valign="top"></td>
    </tr>
</table>
</form>
<div id="footer"></div>
</body>
</html>
