<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!-- plugin version: 2.4 | frpc: 0.65.0 -->
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
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/general.js"></script>
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
	overflow:hidden;
	resize:none;
	white-space:pre-wrap;
	word-break:break-word;
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
var frpc_refresh_flag = 0;
var frpc_count_down = 0;
var frpc_log_poll_tries = 0;
var params_input = ["frpc_common_cron_time", "frpc_common_cron_hour_min", "frpc_common_server_addr", "frpc_common_server_port", "frpc_common_protocol", "frpc_common_tcp_mux", "frpc_common_privilege_token", "frpc_common_vhost_http_port", "frpc_common_vhost_https_port", "frpc_common_user", "frpc_common_log_file", "frpc_common_log_level", "frpc_common_log_max_days"]
var params_check = ["frpc_enable", "frpc_customize_conf"]
var params_base64 = ["frpc_config"]

function initial() {
	show_menu(menu_hook);
	get_dbus_data();
	get_status();
	toggle_func();
	conf2obj();
	buildswitch();
	$("#frpc_common_log_file").change(function() {
		update_log_rows();
	});
	$("#frpc_customize_conf").change(function() {
		toggle_func();
	});
	$("#frpc_config").on("input", function() {
		autosize_frpc_config();
	});
	autosize_frpc_config();
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
	update_log_rows();
	autosize_frpc_config();
}

function update_log_rows() {
	try {
		var logFile = (E("frpc_common_log_file").value || "");
		if (logFile == "/dev/null") {
			$("#frpc_log_level_tr").hide();
			$("#frpc_log_days_tr").hide();
		} else {
			$("#frpc_log_level_tr").show();
			$("#frpc_log_days_tr").show();
		}
	} catch (e) {
	}
}

function autosize_frpc_config() {
	try {
		var el = E("frpc_config");
		if (!el) return;

		// no horizontal scrollbar, wrap long lines
		el.setAttribute("wrap", "soft");
		el.style.overflowX = "hidden";

		var minHeight = 200;
		var maxHeight = 460;

		el.style.height = "auto";
		var text = (el.value || "").replace(/\r/g, "");
		var need = el.scrollHeight;
		if (!text.trim()) {
			el.style.height = minHeight + "px";
			el.style.overflowY = "hidden";
			return;
		}
		if (need < minHeight) need = minHeight;
		if (need > maxHeight) {
			el.style.height = maxHeight + "px";
			el.style.overflowY = "auto";
		} else {
			el.style.height = need + "px";
			el.style.overflowY = "hidden";
		}
	} catch (e) {}
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

function frpc_submit() {
	if (E("frpc_customize_conf").checked) {
		if (trim(E("frpc_config").value) == "") {
			alert("提交的表单不能为空!");
			return false;
		}
	} else {
		if (trim(E("frpc_common_server_addr").value) == "" || trim(E("frpc_common_server_port").value) == "" || trim(E("frpc_common_cron_time").value) == "") {
			alert("提交的表单不能为空!");
			return false;
		}
	}
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
	frpc_refresh_flag = 0;
	E("frpc_ok_button").style.visibility = "hidden";
	E("frpc_log_content").value = "";
	frpc_log_poll_tries = 0;
	showFRPCLoadingBar();
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
				get_frpc_submit_log();
			}
		},
		error: function() {
			E("frpc_loading_block_title").innerHTML = "提交失败 ...";
			E("frpc_log_content").value = "提交请求失败，请重试！";
			E("frpc_ok_button").style.visibility = "visible";
			frpc_refresh_flag = 0;
			frpc_count_down = -1;
		}
	});
}

function showFRPCLoadingBar(){
	try {
		if (document.scrollingElement) document.scrollingElement.scrollTop = 0;
	} catch(e){}
	try {
		document.documentElement.scrollTop = 0;
		document.body.scrollTop = 0;
	} catch(e){}
	E("frpc_loading_block_title").innerHTML = "&nbsp;&nbsp;Frpc 提交日志";
	try {
		var lb = E("frpc_LoadingBar");
		if (lb && lb.style && lb.style.setProperty) {
			lb.style.setProperty("display", "block", "important");
			lb.style.setProperty("visibility", "visible", "important");
		} else {
			lb.style.display = "block";
			lb.style.visibility = "visible";
		}
	} catch(e){}
	var page_h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	var page_w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	var log_h = E("frpc_loadingBarBlock").clientHeight;
	var log_w = E("frpc_loadingBarBlock").clientWidth;
	var log_h_offset = (page_h - log_h) / 2;
	var log_w_offset = (page_w - log_w) / 2 + 90;
	$('#frpc_loadingBarBlock').offset({top: log_h_offset, left: log_w_offset});
}

function hideFRPCLoadingBar(){
	try {
		var lb = E("frpc_LoadingBar");
		if (lb && lb.style && lb.style.setProperty) {
			lb.style.setProperty("visibility", "hidden", "important");
			lb.style.setProperty("display", "none", "important");
		} else {
			lb.style.visibility = "hidden";
			lb.style.display = "none";
		}
	} catch(e){}
	E("frpc_ok_button").style.visibility = "hidden";
	if (frpc_refresh_flag == 1){
		refreshpage();
	}
}

function frpc_count_down_close() {
	if (frpc_count_down == 0) {
		hideFRPCLoadingBar();
	}
	if (frpc_count_down < 0) {
		E("frpc_ok_button1").value = "手动关闭"
		return;
	}
	E("frpc_ok_button1").value = frpc_count_down + " 秒后关闭"
	--frpc_count_down;
	setTimeout("frpc_count_down_close();", 1000);
}

function frpc_log_clean(s){
	if (!s) return "";
	// drop internal markers and keep human-readable logs only
	return s
		.replace(/\\r/g, "")
		.replace(/^.*FRPC_RESULT=.*$/gm, "")
		.replace(/^.*XU6J03M16.*$/gm, "")
		.replace(/\n{3,}/g, "\n\n")
		.trim() + "\n";
}

function get_frpc_submit_log(){
	$.ajax({
		url: '/_temp/frpc_submit_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("frpc_log_content");
			var done = (response.indexOf("XU6J03M16") != -1);
			var ok = (response.indexOf("FRPC_RESULT=OK") != -1);
			retArea.value = frpc_log_clean(response);
			retArea.scrollTop = retArea.scrollHeight;
			if (done) {
				E("frpc_ok_button").style.visibility = "visible";
				if (ok) {
					frpc_refresh_flag = 1;
					frpc_count_down = 6;
				} else {
					frpc_refresh_flag = 0;
					frpc_count_down = -1;
				}
				frpc_count_down_close();
				return;
			}
			setTimeout("get_frpc_submit_log();", 500);
		},
		error: function(xhr) {
			frpc_log_poll_tries++;
			if (frpc_log_poll_tries <= 20) {
				setTimeout("get_frpc_submit_log();", 500);
				return;
			}
			E("frpc_loading_block_title").innerHTML = "暂无日志信息 ...";
			E("frpc_log_content").value = "日志文件为空，请关闭本窗口！";
			E("frpc_ok_button").style.visibility = "visible";
			frpc_refresh_flag = 0;
			frpc_count_down = -1;
		}
	});
}

function frpc_copy_submit_log(){
	try {
		var ta = E("frpc_log_content");
		ta.focus();
		ta.select();
		document.execCommand("copy");
	} catch(e){}
}

function frpc_download_submit_log(){
	try {
		var content = (E("frpc_log_content").value || "");
		var blob = new Blob([content], {type: "text/plain;charset=utf-8"});
		var url = URL.createObjectURL(blob);
		var a = document.createElement("a");
		a.href = url;
		a.download = "frpc_submit_log.txt";
		document.body.appendChild(a);
		a.click();
		document.body.removeChild(a);
		setTimeout(function(){ try{ URL.revokeObjectURL(url); }catch(e){} }, 1000);
	} catch(e){}
}

function view_frpc_submit_log(){
	frpc_refresh_flag = 0;
	frpc_count_down = -1;
	frpc_log_poll_tries = 999;
	E("frpc_ok_button").style.visibility = "visible";
	E("frpc_ok_button1").value = "关闭";
	showFRPCLoadingBar();
	E("frpc_loading_block_title").innerHTML = "&nbsp;&nbsp;Frpc 上次提交日志";
	$.ajax({
		url: '/_temp/frpc_submit_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("frpc_log_content");
			retArea.value = frpc_log_clean(response);
			retArea.scrollTop = retArea.scrollHeight;
			E("frpc_ok_button").style.visibility = "visible";
		},
		error: function() {
			E("frpc_loading_block_title").innerHTML = "暂无日志信息 ...";
			E("frpc_log_content").value = "暂无上次提交日志，请先点击提交后再查看。";
			E("frpc_ok_button").style.visibility = "visible";
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
			if (params[i] == "encryption_node" || params[i] == "gzip_node") {
				ns[p + "_" + params[i] + "_" + node_max] = E(params[i]).checked ? "true" : "false";
			} else {
				ns[p + "_" + params[i] + "_" + node_max] = $('#' + params[i]).val();
			}
		}
	} else {
		for (var i = 0; i < params.length; i++) {
			if (params[i] == "encryption_node" || params[i] == "gzip_node") {
				ns[p + "_" + params[i] + "_" + myid] = E(params[i]).checked ? "true" : "false";
			} else {
				ns[p + "_" + params[i] + "_" + myid] = $('#' + params[i]).val();
			}
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
			E("encryption_node").checked = true;
			E("gzip_node").checked = true;
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
	E("encryption_node").checked = (c["encryption_node"] == "true");
	E("gzip_node").checked = (c["gzip_node"] == "true");
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
			html = html + "<td style='text-align:center;'><input type='checkbox' disabled='disabled'></td>";
			html = html + "<td style='text-align:center;'><input type='checkbox' disabled='disabled'></td>";
		} else {
			var encChecked = (c["encryption_node"] == "true") ? " checked='checked'" : "";
			var gzipChecked = (c["gzip_node"] == "true") ? " checked='checked'" : "";
			html = html + "<td style='text-align:center;'><input type='checkbox' disabled='disabled'" + encChecked + "></td>";
			html = html + "<td style='text-align:center;'><input type='checkbox' disabled='disabled'" + gzipChecked + "></td>";
		}
		html = html + "<td style='text-align:center;white-space:nowrap;'>";
		html = html + "<input style='margin-left:-3px;' id='dd_node_" + c['node'] + "' class='edit_btn' type='button' onclick='editlTr(this);' value=''>";
		html = html + "<input style='margin-top: 4px;margin-left:8px;' id='td_node_" + c['node'] + "' class='remove_btn' type='button' onclick='delTr(this);' value=''>";
		html = html + "</td>";
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
	var use_custom = (E("frpc_customize_conf") && E("frpc_customize_conf").checked);
	if (use_custom) {
		$('.show-btn1').removeClass('active');
		$('.show-btn2').addClass('active');
		E("simple_table").style.display = "none";
		E("conf_table").style.display = "none";
		E("customize_conf_table").style.display = "";
		setTimeout(function(){ autosize_frpc_config(); }, 50);
	} else {
		$('.show-btn1').addClass('active');
		$('.show-btn2').removeClass('active');
		E("simple_table").style.display = "";
		E("conf_table").style.display = "";
		E("customize_conf_table").style.display = "none";
	}
	$(".show-btn1").off("click").click(
		function() {
			$('.show-btn1').addClass('active');
			$('.show-btn2').removeClass('active');
			E("simple_table").style.display = "";
			E("conf_table").style.display = "";
			E("customize_conf_table").style.display = "none";
		}
	);
	$(".show-btn2").off("click").click(
		function() {
			$('.show-btn1').removeClass('active');
			$('.show-btn2').addClass('active');
			E("simple_table").style.display = "none";
			E("conf_table").style.display = "none";
			E("customize_conf_table").style.display = "";
			setTimeout(function(){ autosize_frpc_config(); }, 50);
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
	var statusmenu = "";
	var _caption = "";

	if (itemNum == 0) {
		_caption = "开启 Frpc";
		statusmenu = "开启/关闭 frpc 客户端。<br>若无法启用，请先在 <a href='Advanced_System_Content.asp'><u><font color='#00F'>系统管理 - 系统设置</font></u></a> 开启 Enable JFFS custom scripts and configs。";
	} else if (itemNum == 1) {
		_caption = "服务器地址";
		statusmenu = "填写 frps 服务器地址。<br>建议优先填写 <font color='#F46'>IP 地址</font>；填写域名时需确保路由器 DNS 解析正常。";
	} else if (itemNum == 2) {
		_caption = "服务器端口";
		statusmenu = "填写 frps 的 <b>bind_port</b>（服务端监听端口）。";
	} else if (itemNum == 3) {
		_caption = "Token";
		statusmenu = "填写 frps 的 <b>token</b>（可留空）。<br>服务端启用 token 时需保持一致。<br>部分特殊字符可能引起解析问题，建议使用字母数字组合。";
	} else if (itemNum == 4) {
		_caption = "HTTP vhost 端口";
		statusmenu = "填写 frps 的 <b>vhost_http_port</b>。<br><b>可留空</b>：仅在使用 http/router-http 类型时用于自动填充远程端口。";
	} else if (itemNum == 5) {
		_caption = "HTTPS vhost 端口";
		statusmenu = "填写 frps 的 <b>vhost_https_port</b>。<br><b>可留空</b>：仅在使用 https/router-https 类型时用于自动填充远程端口。";
	} else if (itemNum == 6) {
		_caption = "日志记录";
		statusmenu = "是否开启 frpc 日志。<br>开启后写入 <b>/tmp/frpc.log</b>（重启会清空）。";
	} else if (itemNum == 7) {
		_caption = "日志等级";
		statusmenu = "设置日志输出等级：info / warn / error / debug。<br>debug 最详细。";
	} else if (itemNum == 8) {
		_caption = "日志保留天数";
		statusmenu = "设置日志最多保留的天数（需开启日志）。";
	} else if (itemNum == 9) {
		_caption = "协议";
		statusmenu = "本条穿透规则类型：tcp / udp / http / https / stcp。";
	} else if (itemNum == 10) {
		_caption = "名称";
		statusmenu = "本条规则的名称（对应 frpc 配置段名）。<br><font color='#F46'>要求：</font>在同一台 frps 上必须唯一。";
	} else if (itemNum == 11) {
		_caption = "域名/SK";
		statusmenu = "<b>http/https</b>：填写域名（custom_domains）。<br><b>stcp</b>：填写访问密钥（sk）。<br><b>tcp/udp</b>：保持为 none 即可。";
	} else if (itemNum == 12) {
		_caption = "内网IP";
		statusmenu = "内网服务 IP（local_ip）。<br>穿透路由器自身服务可使用 127.0.0.1 或路由器 LAN IP。";
	} else if (itemNum == 13) {
		_caption = "内网端口";
		statusmenu = "内网服务端口（local_port），例如 80 / 22。";
	} else if (itemNum == 14) {
		_caption = "远程端口";
		statusmenu = "<b>tcp/udp</b>：服务端映射端口（remote_port）。<br><b>http/https</b>：使用 vhost_http/https_port（页面会自动填充）。<br><b>stcp</b>：无需远程端口。";
	} else if (itemNum == 15) {
		_caption = "加密";
		statusmenu = "是否启用传输加密（use_encryption）。<br>可能有助于绕过部分流量识别，但会增加 CPU 开销。";
	} else if (itemNum == 16) {
		_caption = "压缩";
		statusmenu = "是否启用传输压缩（use_compression）。<br>可降低带宽占用，但会增加 CPU 开销。";
	} else if (itemNum == 17) {
		_caption = "定时注册服务";
		statusmenu = "定时重新连接/注册服务，提升长期稳定性。<br>填写 0 表示关闭。";
	} else if (itemNum == 19) {
		_caption = "Frpc 用户名";
		statusmenu = "frpc 的 user 字段，用于区分用户/生成 stcp 访问名等。<br><b>可留空</b>：后端会自动使用路由器型号。";
	} else if (itemNum == 20) {
		_caption = "底层通信协议";
		statusmenu = "客户端与服务端之间的传输协议（protocol）：tcp / kcp / quic / websocket / wss。<br>弱网可尝试 kcp/quic，但流量消耗可能增加。";
	} else if (itemNum == 21) {
		_caption = "TCP 多路复用";
		statusmenu = "tcp_mux 多路复用：降低连接数、提升并发能力。<br>服务端与客户端需保持一致。";
	} else if (itemNum == 23) {
		_caption = "自定义配置";
		statusmenu = "勾选后使用自定义 frpc 配置内容，完全覆盖简单设置生成的配置。";
	}

	return overlib(statusmenu, OFFSETX, -160, LEFT, WIDTH, 360, CAPTION, _caption);
}
</script>
</head>
<body onload="initial();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<div id="frpc_LoadingBar" class="popup_bar_bg_ks" style="position:fixed;margin:auto;top:0;left:0;width:100%;height:100%;z-index:9999;display:none;visibility:hidden;overflow:hidden;background:rgba(68,79,83,0.94) none repeat scroll 0 0;opacity:.94;" >
	<table cellpadding="5" cellspacing="0" id="frpc_loadingBarBlock" class="loadingBarBlock" style="width:740px;" align="center">
		<tr>
			<td height="100">
				<div id="frpc_loading_block_title" style="margin:10px auto;width:100%; font-size:12pt;text-align:center;"></div>
				<div style="margin-left:15px;margin-top:5px"><i>此处显示 frpc 上次/本次提交日志</i></div>
				<div style="margin-left:15px;margin-right:15px;margin-top:10px;outline: 1px solid #3c3c3c;overflow:hidden">
					<textarea cols="50" rows="25" wrap="off" readonly="readonly" id="frpc_log_content" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Lucida Console'; font-size:11px;background:transparent;color:#FFFFFF;outline: none;padding-left:5px;padding-right:22px;overflow-x:hidden;white-space:break-spaces;"></textarea>
				</div>
				<div id="frpc_ok_button" class="apply_gen" style="background:#000;visibility:hidden;">
					<input class="button_gen" type="button" onclick="frpc_copy_submit_log();" value="复制日志">
					<input style="margin-left:10px" class="button_gen" type="button" onclick="frpc_download_submit_log();" value="下载日志">
					<input style="margin-left:10px" id="frpc_ok_button1" class="button_gen" type="button" onclick="hideFRPCLoadingBar()" value="确定">
				</div>
			</td>
		</tr>
	</table>
</div>
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
                                    <div class="formfontdesc" style="margin-left:10px;">
                                        <i>广告：不会搭建frp服务器？搞不定域名？试试国内frp隧道服务：</i><a href="https://dashboard.passnat.com/reg?aff=mhGZMu" target="_blank" style="color:#00c6ff;font-weight:600;">PassNAT</a><i>，月付低至6元享BGP高速节点</i>
                                    </div>
                                    <div id="frpc_switch_show">
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                        <tr id="switch_tr">
                                            <th>
                                                <label><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(0);" onmouseout="nd();">开启Frpc</a></label>
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
                                                    <a type="button" class="frpc_btn" style="cursor:pointer" href="https://raw.githubusercontent.com/koolshare/rogsoft/master/frpc/Changelog.txt" target="_blank">更新日志</a>
                                                    <a type="button" class="frpc_btn" style="cursor:pointer" href="javascript:void(0);" onclick="view_frpc_submit_log();">查看日志</a>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr id="frpc_status">
                                            <th width="20%">运行状态</th>
                                            <td><span id="status">获取中...</span>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(17);" onmouseout="nd();">定时注册服务</a>(<i>0为关闭</i>)</th>
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
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="margin-top: 0px;">
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(1);" onmouseout="nd();">服务器</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" value="" id="frpc_common_server_addr" name="frpc_common_server_addr" maxlength="128" value="" placeholder=""/>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(2);" onmouseout="nd();">端口</a></th>
                                            <td>
                                        <input type="text" class="input_ss_table" id="frpc_common_server_port" name="frpc_common_server_port" maxlength="10" value="" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(20);" onmouseout="nd();">底层通信协议</a></th>
                                            <td>
												<select id="frpc_common_protocol" name="frpc_common_protocol" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
													<option value="tcp">tcp</option>
													<option value="kcp">kcp</option>
													<option value="quic">quic</option>
													<option value="websocket">websocket</option>
													<option value="wss">wss</option>
												</select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(21);" onmouseout="nd();">TCP 多路复用</a></th>
                                            <td>
                                                <select id="frpc_common_tcp_mux" name="frpc_common_tcp_mux" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="true">开启</option>
                                                    <option value="false">关闭</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(3);" onmouseout="nd();">Token</a></th>
                                            <td>
                                                <input type="password" name="frpc_common_privilege_token" id="frpc_common_privilege_token" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="256" value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);"/>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(4);" onmouseout="nd();">HTTP穿透服务端口</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" id="frpc_common_vhost_http_port" name="frpc_common_vhost_http_port" maxlength="6" value="" placeholder="可留空"/>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(5);" onmouseout="nd();">HTTPS穿透服务端口</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" id="frpc_common_vhost_https_port" name="frpc_common_vhost_https_port" maxlength="6" value="" placeholder="可留空"/>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(19);" onmouseout="nd();">Frpc用户名称</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" id="frpc_common_user" name="frpc_common_user" maxlength="50" value="" placeholder="留空=自动使用路由器型号"/>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(6);" onmouseout="nd();">日志记录</a></th>
                                            <td>
                                                <select id="frpc_common_log_file" name="frpc_common_log_file" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="/dev/null">关闭</option>
                                                    <option value="/tmp/frpc.log">开启</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr id="frpc_log_level_tr">
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(7);" onmouseout="nd();">日志等级</a></th>
                                            <td>
                                                <select id="frpc_common_log_level" name="frpc_common_log_level" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="info">info</option>
                                                    <option value="warn">warn</option>
                                                    <option value="error">error</option>
                                                    <option value="debug">debug</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr id="frpc_log_days_tr">
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(8);" onmouseout="nd();">日志记录天数</a></th>
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
                                    <table id="conf_table" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable_table" style="margin-top: 10px;">
                                          <thead>
                                              <tr>
                                                <td colspan="9">穿透服务配置</td>
                                              </tr>
                                          </thead>

                                          <tr>
                                            <th><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(9);" onmouseout="nd();">协议</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(10);" onmouseout="nd();">名称</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(11);" onmouseout="nd();">域名/SK</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(12);" onmouseout="nd();">内网IP</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(13);" onmouseout="nd();">内网端口</a></th>
                                          <th><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(14);" onmouseout="nd();">远程端口</a></th>
                                          <th style="text-align:center;"><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(15);" onmouseout="nd();">加密</a></th>
                                          <th style="text-align:center;"><a class="hintstyle" href="javascript:void(0);" onmouseover="return openssHint(16);" onmouseout="nd();">压缩</a></th>
                                          <th>操作</th>
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
                                            <div style="text-align:center;"><input type="checkbox" id="encryption_node" name="encryption_node" checked="checked"></div>
                                        </td>
                                        <td>
                                            <div style="text-align:center;"><input type="checkbox" id="gzip_node" name="gzip_node" checked="checked"></div>
                                        </td>
                                        <td width="10%">
                                            <div style="text-align:center;">
                                                <input type="button" class="add_btn" onclick="addTr()" value=""/>
                                            </div>
                                        </td>
                                          </tr>
                                      </table>
                                    </div>

                                    <div id="customize_conf_table">
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable_table" style="margin-top: 0px;">
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

                                    <div class="apply_gen">
                                        <input class="button_gen" id="cmdBtn" onclick="frpc_submit()" type="button" value="提交"/>
                                    </div>

                                    <div style="margin:30px 0 10px 5px;" class="splitLine"></div>
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
