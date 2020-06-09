<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - pushplus全能推送</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/> 
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<style>
.Bar_container {
    width:85%;
    height:20px;
    border:1px inset #999;
    margin:0 auto;
    margin-top:20px \9;
    background-color:#FFFFFF;
    z-index:100;
}
#proceeding_img_text {
    position:absolute;
    z-index:101;
    font-size:11px;
    color:#000000;
    line-height:21px;
    width: 83%;
}
#proceeding_img {
    height:21px;
    background:#C0D1D3 url(/images/ss_proceding.gif);
}
#ClientList_Block_PC{
    border:1px outset #999;
    background-color:#576D73;
    position:absolute;
    *margin-top:26px;
    margin-left:2px;
    *margin-left:-353px;
    width:346px;
    text-align:left;
    height:auto;
    overflow-y:auto;
    z-index:200;
    padding: 1px;
    display:none;
}
#ClientList_Block_PC div{
    background-color:#576D73;
    height:auto;
    *height:20px;
    line-height:20px;
    text-decoration:none;
    font-family: Lucida Console;
    padding-left:2px;
}

#ClientList_Block_PC a{
    background-color:#EFEFEF;
    color:#FFF;
    font-size:12px;
    font-family:Arial, Helvetica, sans-serif;
    text-decoration:none;
}
#ClientList_Block_PC div:hover, #ClientList_Block a:hover {
    background-color:#3366FF;
    color:#FFFFFF;
    cursor:default;
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
    margin-left: -100px;
    top: 10px;
    width:720px;
    height:auto;
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
.pushplus_btn {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #003333  0%, #000000 100%); /* W3C */
	background: linear-gradient(to bottom, #91071f  0%, #700618 100%); /* W3C rogcss */
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
}
.pushplus_btn:hover {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%); /* W3C */
	background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%); /* W3C rogcss */
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
}
#pushplus_trigger_dhcp_white {
	width:99%;
	font-family:'Lucida Console';
	font-size:12px;
	text-transform: none;
	margin-top:5px;
	color:#FFFFFF;
	background:#475A5F;
	background:transparent; /* W3C rog */
	border:1px solid #91071f; /* W3C rogcss */
}
input[type=button]:focus {
    outline: none;
}
</style>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/calendar/jquery-ui.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script>
var db_pushplus = {}

function initial() {
	show_menu();
	get_dbus_data();
	refresh_table();
	version_show();
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/pushplus_",
		dataType: "json",
		async: false,
		success: function(data) {
			db_pushplus = data.result[0];
			console.log(db_pushplus);
			conf2obj();
			$("#pushplus_version_show").html("<i>插件版本：" + db_pushplus["pushplus_version"] + "</i>")
		}
	});
}

function conf2obj() { //表单填写函数，将dbus数据填入到对应的表单中
	for (var field in db_pushplus) {
		var el = E(field);
		if (el != null) {
			if (field == "pushplus_config_name") {
				el.value = Base64.decode(db_pushplus[field]);
			} else if (field == "pushplus_trigger_dhcp_white") {
				el.value = Base64.decode(db_pushplus[field]);
			} else if (field == "pushplus_check_custom") {
				el.value = Base64.decode(db_pushplus[field]);
			} else {
				if (field == "pushplus_status_check") {
					__pushplus_status_check = db_pushplus[field];
					if (__pushplus_status_check == "0") {
						E('_pushplus_check_day_pre').style.display = "none";
						E('_pushplus_check_week_pre').style.display = "none";
						E('_pushplus_check_time_pre').style.display = "none";
						E('_pushplus_check_inter_pre').style.display = "none";
						E('_pushplus_check_custom_pre').style.display = "none";
						E('_pushplus_check_send_text').style.display = "none";
					} else if (__pushplus_status_check == "1") {
						E('_pushplus_check_week_pre').style.display = "none";
						E('_pushplus_check_day_pre').style.display = "none";
						E('_pushplus_check_time_pre').style.display = "inline";
						E('_pushplus_check_inter_pre').style.display = "none";
						E('_pushplus_check_custom_pre').style.display = "none";
						E('_pushplus_check_send_text').style.display = "inline";
					} else if (__pushplus_status_check == "2") {
						E('_pushplus_check_week_pre').style.display = "inline";
						E('_pushplus_check_day_pre').style.display = "none";
						E('_pushplus_check_time_pre').style.display = "inline";
						E('_pushplus_check_inter_pre').style.display = "none";
						E('_pushplus_check_custom_pre').style.display = "none";
						E('_pushplus_check_send_text').style.display = "inline";
					} else if (__pushplus_status_check == "3") {
						E('_pushplus_check_week_pre').style.display = "none";
						E('_pushplus_check_day_pre').style.display = "inline";
						E('_pushplus_check_time_pre').style.display = "inline";
						E('_pushplus_check_inter_pre').style.display = "none";
						E('_pushplus_check_custom_pre').style.display = "none";
						E('_pushplus_check_send_text').style.display = "inline";
					} else if (__pushplus_status_check == "4") {
						E('_pushplus_check_week_pre').style.display = "none";
						E('_pushplus_check_day_pre').style.display = "none";
						E('_pushplus_check_time_pre').style.display = "none";
						E('_pushplus_check_inter_pre').style.display = "inline";
						E('_pushplus_check_custom_pre').style.display = "none";
						E('_pushplus_check_send_text').style.display = "inline";
						__pushplus_check_inter_pre = db_pushplus["pushplus_check_inter_pre"];
						if (__pushplus_check_inter_pre == "1") {
							E('pushplus_check_inter_min').style.display = "inline";
							E('pushplus_check_inter_hour').style.display = "none";
							E('pushplus_check_inter_day').style.display = "none";
							E('_pushplus_check_time_pre').style.display = "none";
							E('_pushplus_check_inter_pre').style.display = "inline";
							E('_pushplus_check_send_text').style.display = "inline";
						} else if (__pushplus_check_inter_pre == "2") {
							E('pushplus_check_inter_min').style.display = "none";
							E('pushplus_check_inter_hour').style.display = "inline";
							E('pushplus_check_inter_day').style.display = "none";
							E('_pushplus_check_time_pre').style.display = "none";
							E('_pushplus_check_inter_pre').style.display = "inline";
							E('_pushplus_check_send_text').style.display = "inline";
						} else if (__pushplus_check_inter_pre == "3") {
							E('pushplus_check_inter_min').style.display = "none";
							E('pushplus_check_inter_hour').style.display = "none";
							E('pushplus_check_inter_day').style.display = "inline";
							E('_pushplus_check_time_pre').style.display = "inline";
							E('_pushplus_check_inter_pre').style.display = "inline";
							E('_pushplus_check_send_text').style.display = "inline";
						}
					} else if (__pushplus_status_check == "5") {
						E('_pushplus_check_week_pre').style.display = "none";
						E('_pushplus_check_day_pre').style.display = "none";
						E('_pushplus_check_time_pre').style.display = "inline";
						E('_pushplus_check_inter_pre').style.display = "none";
						E('_pushplus_check_custom_pre').style.display = "inline";
						E('_pushplus_check_send_text').style.display = "inline";
						E('pushplus_check_time_hour').style.display = "none";
					}
				}
				if (el.getAttribute("type") == "checkbox") {
					if (db_pushplus[field] == "1") {
						el.checked = true;
					} else {
						el.checked = false;
					}
				}
				el.value = db_pushplus[field];
			}
		}
	}
}

function onSubmitCtrl(){
	showLoading(5);
	refreshpage(5);
	var params_input = ["pushplus_silent_time_start_hour", "pushplus_silent_time_end_hour", "pushplus_config_ntp", "pushplus_config_name", "pushplus_status_check", "pushplus_check_week", "pushplus_check_day", "pushplus_check_inter_min", "pushplus_check_inter_hour", "pushplus_check_inter_day", "pushplus_check_inter_pre", "pushplus_check_custom", "pushplus_check_time_hour", "pushplus_check_time_min", "pushplus_trigger_dhcp_white"];
	var params_check = ["pushplus_enable", "pushplus_silent_time", "pushplus_info_logger", "pushplus_info_silent_send", "pushplus_info_system", "pushplus_info_temp", "pushplus_info_wan", "pushplus_info_pub", "pushplus_info_usb", "pushplus_info_lan", "pushplus_info_dhcp", "pushplus_trigger_ifup", "pushplus_trigger_ifup_sendinfo","pushplus_trigger_dhcp", "pushplus_trigger_dhcp_leases","pushplus_dhcp_bwlist_en", "pushplus_dhcp_white_en", "pushplus_dhcp_black_en", "pushplus_info_lan_macoff", "pushplus_info_dhcp_macoff", "pushplus_trigger_dhcp_macoff" ];
	var params_base64 = ["pushplus_config_name", "pushplus_check_custom", "pushplus_trigger_dhcp_white"];
	// collect data from input
	for (var i = 0; i < params_input.length; i++) {
		if(E(params_input[i])){
			db_pushplus[params_input[i]] = E(params_input[i]).value;
		}
	}
	// collect data from checkbox
	for (var i = 0; i < params_check.length; i++) {
		db_pushplus[params_check[i]] = E(params_check[i]).checked ? '1':'0';
	}
	// data need base64 encode
	for (var i = 0; i < params_base64.length; i++) {
		if (!E(params_base64[i]).value){
			db_pushplus[params_base64[i]] = "";
		}else{
			db_pushplus[params_base64[i]] = Base64.encode(E(params_base64[i]).value);
		}
	}
	// post data
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "pushplus_config.sh", "params":[1], "fields": db_pushplus};
	$.ajax({
		url: "/_api/",
		cache:false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData)
	});
}

function manual_push(){
	E('manual_push_Btn').disabled = "disabled";
	showLoading(2);
	refreshpage(2);
	// post data
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "pushplus_check.sh", "params":[1], "fields": {}};
	$.ajax({
		url: "/_api/",
		cache:false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response){
			alert("手动推送成功，请检查手机信息！");
		}
	});
}
function reload_Soft_Center() { //返回软件中心按钮
	location.href = "/Module_Softcenter.asp";
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "pushplus微信通知");
	tablink[tablink.length - 1] = new Array("", "Module_pushplus.asp");
}

function addTr(o) { //添加配置行操作
	var _form_addTr = document.form;
	if (trim(_form_addTr.config_token.value) == "") {
		alert("提交的Token不能为空!");
		return false;
	}
	var ns = {};
	var p = "pushplus";
	node_max += 1;
	// 定义ns数组，用于回传给dbus
	var params = ["config_token","config_topic"];
	if (!myid) {
		for (var i = 0; i < params.length; i++) {
			ns[p + "_" + params[i] + "_" + node_max] = $('#' + params[i]).val() || "";
		}
	} else {
		for (var i = 0; i < params.length; i++) {
			ns[p + "_" + params[i] + "_" + myid] = $('#' + params[i]).val() || "";
		}
	}
	//回传网页数据给dbus接口，此处回传不同于form表单回传
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "dummy_script.sh", "params":[2], "fields": ns};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if (response.result == id){
				//回传成功后，重新生成表格
				refresh_table();
				// 添加成功一个后将输入框清空
				document.form.config_token.value = "";
                document.form.config_topic.value = "";
			}
		}
	});
	myid = 0;
}

function delTr(o) { //删除配置行功能
	if (confirm("你确定删除吗？")) {
		//定位每行配置对应的ID号
		var id = $(o).attr("id");
		var ids = id.split("_");
		var p = "pushplus";
		id = ids[ids.length - 1];
		// 定义ns数组，用于回传给dbus
		var ns = {};
		var params = ["config_token","config_topic"];
		for (var i = 0; i < params.length; i++) {
			//空的值，用于清除dbus中的对应值
			ns[p + "_" + params[i] + "_" + id] = "";
		}
		//回传删除数据操作给dbus接口
		var id = parseInt(Math.random() * 100000000);
		var postData = {"id": id, "method": "dummy_script.sh", "params":[2], "fields": ns};
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
	//获取dbus数据接口，该接口获取dbus list pushplus的所有值
	$.ajax({
		type: "GET",
		url: "/_api/pushplus_",
		dataType: "json",
		async: false,
		success: function(response) {
			db_pushplus=response.result[0];
			//先删除表格中的行，留下前两行，表头和数据填写行
			$("#conf_table").find("tr:gt(1)").remove();
			//在表格中增加行，增加的行的内容来自refresh_html()函数生成
			$('#conf_table tr:last').after(refresh_html());
		}
	});
}
var myid;

function getAllConfigs() { //用dbus数据生成数据组，方便用于refresh_html()生成表格
	var dic = {};
	node_max = 0; //定义配置行数，用于每行配置的后缀
	for (var field in db_pushplus) {
		names = field.split("_");
		dic[names[names.length - 1]] = 'ok';
	}
	confs = {};
	var p = "pushplus";
	for (var field in dic) {
		var obj = {};
        var otoken = p + "_config_token_" + field;
        var otopic = p + "_config_topic_" + field;
        if (typeof db_pushplus[otoken] == "undefined") {
            obj=null
        }else{
            obj["config_token"] = db_pushplus[otoken];
            obj["config_topic"] = db_pushplus[otopic] || "";
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
	//总之，最后生成了confs数组
	return confs;
}

function refresh_html() { //用conf数据生成配置表格
	confs = getAllConfigs();
	var n = 0;
	for (var i in confs) { //获取节点的数目
		n++;
	}
	var html = '';
	for (var field in confs) {
		var c = confs[field];
        if(!c["config_topic"]) c["config_topic"]=""
		html = html + '<tr>';
		html = html + '<td><input type="password" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="256" value="' + c["config_token"] + '" onBlur="switchType(this, false);" onFocus="switchType(this, true);" style="width:95%;margin-top: 3px;" disabled="disabled" /></td>';
        html = html + '<td><input type="password" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="256" value="' + c["config_topic"] + '" onBlur="switchType(this, false);" onFocus="switchType(this, true);" style="width:95%;margin-top: 3px;" disabled="disabled" /></td>';
        html = html + '<td>微信</td>';
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

function editlTr(o) { //编辑节点功能，显示编辑面板
	checkTime = 2001; //编辑节点时停止可能在进行的刷新
	var id = $(o).attr("id");
	var ids = id.split("_");
	confs = getAllConfigs();
	id = ids[ids.length - 1];
	var c = confs[id];

	document.form.config_token.value = c["config_token"];
    document.form.config_topic.value = c["config_topic"] || "";
	myid = id; //返回ID号
}

function oncheckclick(obj) {
	if (obj.checked) {
		if (obj.id == "pushplus_dhcp_white_en") {
			E("pushplus_dhcp_black_en").checked = false;
		}
		if (obj.id == "pushplus_dhcp_black_en") {
			E("pushplus_dhcp_white_en").checked = false;
		}
	} else {
		if (obj.id == "pushplus_dhcp_white_en") {
			E("pushplus_dhcp_black_en").checked = true;
		}
		if (obj.id == "pushplus_dhcp_black_en") {
			E("pushplus_dhcp_white_en").checked = true;
		}
	}
}

function version_show() {
	$.ajax({
		url: 'https://rogsoft.ddnsto.com/pushplus/config.json.js',
		type: 'GET',
		dataType: 'jsonp',
		success: function(res) {
			if (typeof(res["version"]) != "undefined" && res["version"].length > 0) {
				if (res["version"] == db_pushplus["pushplus_version"]) {
					$("#pushplus_version_show").html("<i>插件版本：" + res["version"]);
				} else if (res["version"] > db_pushplus["pushplus_version"]) {
					$("#pushplus_version_show").html("<font color=\"#66FF66\">有新版本：</font>" + res.version);
				}
			}
		}
	});
}
</script>
</head>
<body onload="initial();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="POST" name="form" action="/applydb.cgi?p=pushplus" target="hidden_frame"> 
<input type="hidden" name="current_page" value="Module_pushplus.asp"/>
<input type="hidden" name="next_page" value="Main_pushplus.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="5"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="SystemCmd" value=""/>
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
                                    <div style="float:left;" class="formfonttitle">软件中心 - pushplus全能推送</div>
                                    <div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
                                    <div style="margin:30px 0 10px 5px;" class="splitLine"></div>
                                    <div class="formfontdesc" id="cmdDesc">
                                        「<a href="https://pushplus.hxtrip.com/" target=_blank><i>pushplus</i></a>」，中文名「推送加」，起初是为了帮助程序员处理系统监控告警而开发的免费服务。随着功能不断的完善，我们针对性的推出了路由器插件可以让您第一时间在手机上接收路由器的消息。<br><br>
                                        只需两步，轻松上手：<br>
                                        <i>1. 获取Token：</i>打开<a href="https://pushplus.hxtrip.com/login?redirectUrl=/message" target="_blank"><i>pushplus官网</i></a>,微信扫码登录成功后在页面上获取您的Token<br>
                                        <i>2. 填写Token：</i>在插件页面中填入自己的Token点击提交，即可收到路由器发送的消息。<br><br>
                                        想要多个人接收怎么办？pushplus支持群发功能，到官网上创建自己的群组后，在插件页面上填入自己的群组编码，消息就会群发给群组内的成员了。<br>
                                    </div>
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                        <thead>
                                            <tr>
                                              <td colspan="2">pushplus 基础设置</td>
                                            </tr>
                                        </thead>
                                        <tr id="switch_tr">
                                            <th>
                                                <label>开启pushplus</label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="pushplus_enable">
                                                        <input id="pushplus_enable" class="switch" type="checkbox" style="display: none;">
                                                        <div class="switch_container" >
                                                            <div class="switch_bar"></div>
                                                            <div class="switch_circle transition_style">
                                                                <div></div>
                                                            </div>
                                                        </div>
                                                    </label>
                                                </div>
                                                <span style="margin-left:100px;"><input class="pushplus_btn" id="manual_push_Btn" onclick="manual_push();" type="button" value="手动推送"/></span>
                                            </td>
                                        </tr>
                                    </table>

                                    <table id="conf_table" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" class="FormTable_table" style="margin-top:8px;">
                                        <tr>
                                            <th>Token(必填)</th>
                                            <th>群组编码(可选)</th>
                                            <th>渠道</th>
                                            <th>修改</th>
                                            <th>添加/删除</th>
                                        </tr>
                                        <tr>
                                            <td>
                                                <input type="input" name="config_token" id="config_token" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="256" value="" style="width:95%;margin-top: 3px;" />
                                            </td>
                                            <td>
                                                <input type="input" name="config_topic" id="config_topic" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="256" value="" style="width:95%;margin-top: 3px;" />
                                            </td>
                                            <td>
                                                <label><input type="checkbox" readonly checked disabled id="config_channel_wechat" name="config_channel_wechat" onclick="oncheckclick(this);">微信</label>
                                                <!-- <label><input type="checkbox" id="config_channel_email" name="config_channel_email" onclick="oncheckclick(this);">邮件</label>
                                                <label><input type="checkbox" id="config_channel_sms" name="config_channel_sms" onclick="oncheckclick(this);">短信</label> -->
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

                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="margin-top:8px;">
                                        <thead>
                                              <tr>
                                                <td colspan="2">pushplus 功能设置</td>
                                              </tr>
                                          </thead>                                       
                                        <tr>
                                            <th style="width:20%;">版本信息</th>
                                            <td>
                                                <div id="pushplus_version_show" style="padding-top:5px;margin-left:0px;margin-top:0px;float: left;"></div>
                                                <span style="padding-top:5px;margin-right: 15px;margin-left:0px;margin-top:0px;float: right;"><a href="https://pushplus.hxtrip.com/about" target="_blank">[ 联系我们 ]</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://raw.githubusercontent.com/koolshare/rogsoft/master/pushplus/Changelog.txt" target="_blank"><em><u>[ 更新日志 ]</u></em></a></span>
                                            </td>                                                                                    
                                        </tr>
                                        <tr>
                                            <th width="20%">消息免打扰时间</th>
                                            <td>
                                                <label><input type="checkbox" id="pushplus_silent_time" checked="checked" onclick="oncheckclick(this);"> 消息免打扰 
                                                <select id="pushplus_silent_time_start_hour" name="pushplus_silent_time_start_hour" style="margin:0px 0px 0px 2px;" class="input_option" >
                                                        <option value="17">17时</option>
                                                        <option value="18">18时</option>
                                                        <option value="19">19时</option>
                                                        <option value="20">20时</option>
                                                        <option value="21">21时</option>
                                                        <option value="22" selected="selected">22时</option>
                                                        <option value="23">23时</option>
                                                </select> 到 
                                                <select id="pushplus_silent_time_end_hour" name="pushplus_silent_time_end_hour" style="margin:0px 0px 0px 2px;" class="input_option" >
                                                        <option value="1">1时</option>
                                                        <option value="2">2时</option>
                                                        <option value="3">3时</option>
                                                        <option value="4">4时</option>
                                                        <option value="5">5时</option>
                                                        <option value="6">6时</option>
                                                        <option value="7">7时</option>
                                                        <option value="8" selected="selected">8时</option>
                                                        <option value="9">9时</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">系统日志</th>
                                            <td>
                                                <label><input type="checkbox" id="pushplus_info_logger" onclick="oncheckclick(this);"> 在系统日志中显示pushplus相关日志
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">时间同步服务器(校正推送时间)</th>
                                            <td>
                                                <input type="text" class="input_ss_table" value="" id="pushplus_config_ntp" name="pushplus_config_ntp" maxlength="255" value="" placeholder="" style="width:250px;"/>
                                            </td>
                                        </tr>
                                    </table>

                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="margin-top:8px;">
                                        <thead>
                                              <tr>
                                                <td colspan="2">定时发送状态消息 (长消息)</td>
                                              </tr>
                                          </thead>
                                        <tr>
                                            <th width="20%">设备标识(显示在推送信息标题中)</th>
                                            <td>
                                                <input type="text" class="input_ss_table" value="" id="pushplus_config_name" name="pushplus_config_name" maxlength="255" value="" placeholder="" style="width:250px;"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">定时任务设定</th>
                                            <td>
                                                <select id="pushplus_status_check" name="pushplus_status_check" style="margin:0px 0px 0px 2px;" class="input_option" onchange="status_onchange();" >
                                                    <option value="0">关闭</option>
                                                    <option value="1">每天</option>
                                                    <option value="2">每周</option>
                                                    <option value="3">每月</option>
                                                    <option value="4">每隔</option>
                                                    <option value="5">自定义</option>
                                                </select>
                                                <span id="_pushplus_check_week_pre" style="display: none;">
                                                    <select id="pushplus_check_week" name="pushplus_check_week" style="margin:0px 0px 0px 2px;" class="input_option" >
                                                        <option value="1">一</option>
                                                        <option value="2">二</option>
                                                        <option value="3">三</option>
                                                        <option value="4">四</option>
                                                        <option value="5">五</option>
                                                        <option value="6">六</option>
                                                        <option value="7">日</option>
                                                    </select>
                                                </span>
                                                <span id="_pushplus_check_day_pre" style="display: none;">
                                                    <select id="pushplus_check_day" name="pushplus_check_day" style="margin:0px 0px 0px 2px;" class="input_option" >
                                                        <option value="1">1日</option>
                                                        <option value="2">2日</option>
                                                        <option value="3">3日</option>
                                                        <option value="4">4日</option>
                                                        <option value="5">5日</option>
                                                        <option value="6">6日</option>
                                                        <option value="7">7日</option>
                                                        <option value="8">8日</option>
                                                        <option value="9">9日</option>
                                                        <option value="10">10日</option>
                                                        <option value="11">11日</option>
                                                        <option value="12">12日</option>
                                                        <option value="13">13日</option>
                                                        <option value="14">14日</option>
                                                        <option value="15">15日</option>
                                                        <option value="16">16日</option>
                                                        <option value="17">17日</option>
                                                        <option value="18">18日</option>
                                                        <option value="19">19日</option>
                                                        <option value="20">20日</option>
                                                        <option value="21">21日</option>
                                                        <option value="22">22日</option>
                                                        <option value="23">23日</option>
                                                        <option value="24">24日</option>
                                                        <option value="25">25日</option>
                                                        <option value="26">26日</option>
                                                        <option value="27">27日</option>
                                                        <option value="28">28日</option>
                                                        <option value="29">29日</option>
                                                        <option value="30">30日</option>
                                                        <option value="31">31日</option>
                                                    </select>
                                                </span>
                                                <span id="_pushplus_check_inter_pre" style="display: none;">
                                                    <select id="pushplus_check_inter_min" name="pushplus_check_inter_min" style="margin:0px 0px 0px 2px;" class="input_option" >
                                                        <option value="1">1</option>
                                                        <option value="5">5</option>
                                                        <option value="10">10</option>
                                                        <option value="15">15</option>
                                                        <option value="20">20</option>
                                                        <option value="25">25</option>
                                                        <option value="30">30</option>
                                                    </select>
                                                    <select id="pushplus_check_inter_hour" name="pushplus_check_inter_hour" style="display: none; margin:0px 0px 0px 2px;" class="input_option" >
                                                        <option value="1">1</option>
                                                        <option value="2">2</option>
                                                        <option value="3">3</option>
                                                        <option value="4">4</option>
                                                        <option value="5">5</option>
                                                        <option value="6">6</option>
                                                        <option value="7">7</option>
                                                        <option value="8">8</option>
                                                        <option value="9">9</option>
                                                        <option value="10">10</option>
                                                        <option value="11">11</option>
                                                        <option value="12">12</option>
                                                    </select>
                                                    <select id="pushplus_check_inter_day" name="pushplus_check_inter_day" style="display: none; margin:0px 0px 0px 2px;" class="input_option" >
                                                        <option value="1">1</option>
                                                        <option value="2">2</option>
                                                        <option value="3">3</option>
                                                        <option value="4">4</option>
                                                        <option value="5">5</option>
                                                        <option value="6">6</option>
                                                        <option value="7">7</option>
                                                        <option value="8">8</option>
                                                        <option value="9">9</option>
                                                        <option value="10">10</option>
                                                        <option value="11">11</option>
                                                        <option value="12">12</option>
                                                        <option value="13">13</option>
                                                        <option value="14">14</option>
                                                        <option value="15">15</option>
                                                        <option value="16">16</option>
                                                        <option value="17">17</option>
                                                        <option value="18">18</option>
                                                        <option value="19">19</option>
                                                        <option value="20">20</option>
                                                        <option value="21">21</option>
                                                        <option value="22">22</option>
                                                        <option value="23">23</option>
                                                        <option value="24">24</option>
                                                        <option value="25">25</option>
                                                        <option value="26">26</option>
                                                        <option value="27">27</option>
                                                        <option value="28">28</option>
                                                        <option value="29">29</option>
                                                        <option value="30">30</option>
                                                    </select>
                                                    <select id="pushplus_check_inter_pre" name="pushplus_check_inter_pre" style="margin:0px 0px 0px 2px;" class="input_option" onchange="inter_pre_onchange();" >
                                                        <option value="1">分钟</option>
                                                        <option value="2">小时</option>
                                                        <option value="3">天</option>
                                                    </select>
                                                </span>
                                                <span id="_pushplus_check_custom_pre" style="display: none;">
                                                    <input type="text" id="pushplus_check_custom" name="pushplus_check_custom" class="input_6_table" maxlength="50" title="填写说明：&#13;此处填写1-23之间任意小时&#13;小时间用逗号间隔，如：&#13;当天的8点、10点、15点则填入：8,10,15" placeholder="8,10,15" style="width:150px;" /> 小时
                                                </span>
                                                <span id="_pushplus_check_time_pre" style="display: none;">
                                                    <select id="pushplus_check_time_hour" name="pushplus_check_time_hour" style="margin:0px 0px 0px 2px;" class="input_option" >
                                                        <option value="0">0时</option>
                                                        <option value="1">1时</option>
                                                        <option value="2">2时</option>
                                                        <option value="3">3时</option>
                                                        <option value="4">4时</option>
                                                        <option value="5">5时</option>
                                                        <option value="6">6时</option>
                                                        <option value="7">7时</option>
                                                        <option value="8">8时</option>
                                                        <option value="9">9时</option>
                                                        <option value="10">10时</option>
                                                        <option value="11">11时</option>
                                                        <option value="12">12时</option>
                                                        <option value="13">13时</option>
                                                        <option value="14">14时</option>
                                                        <option value="15">15时</option>
                                                        <option value="16">16时</option>
                                                        <option value="17">17时</option>
                                                        <option value="18">18时</option>
                                                        <option value="19">19时</option>
                                                        <option value="20">20时</option>
                                                        <option value="21">21时</option>
                                                        <option value="22">22时</option>
                                                        <option value="23">23时</option>
                                                    </select>
                                                    <select id="pushplus_check_time_min" name="pushplus_check_time_min" style="margin:0px 0px 0px 2px;" class="input_option" >
                                                        <option value="0">0分</option>
                                                        <option value="1">1分</option>
                                                        <option value="2">2分</option>
                                                        <option value="3">3分</option>
                                                        <option value="4">4分</option>
                                                        <option value="5">5分</option>
                                                        <option value="6">6分</option>
                                                        <option value="7">7分</option>
                                                        <option value="8">8分</option>
                                                        <option value="9">9分</option>
                                                        <option value="10">10分</option>
                                                        <option value="11">11分</option>
                                                        <option value="12">12分</option>
                                                        <option value="13">13分</option>
                                                        <option value="14">14分</option>
                                                        <option value="15">15分</option>
                                                        <option value="16">16分</option>
                                                        <option value="17">17分</option>
                                                        <option value="18">18分</option>
                                                        <option value="19">19分</option>
                                                        <option value="20">20分</option>
                                                        <option value="21">21分</option>
                                                        <option value="22">22分</option>
                                                        <option value="23">23分</option>
                                                        <option value="24">24分</option>
                                                        <option value="25">25分</option>
                                                        <option value="26">26分</option>
                                                        <option value="27">27分</option>
                                                        <option value="28">28分</option>
                                                        <option value="29">29分</option>
                                                        <option value="30">30分</option>
                                                        <option value="31">31分</option>
                                                        <option value="32">32分</option>
                                                        <option value="33">33分</option>
                                                        <option value="34">34分</option>
                                                        <option value="35">35分</option>
                                                        <option value="36">36分</option>
                                                        <option value="37">37分</option>
                                                        <option value="38">38分</option>
                                                        <option value="39">39分</option>
                                                        <option value="40">40分</option>
                                                        <option value="41">41分</option>
                                                        <option value="42">42分</option>
                                                        <option value="43">43分</option>
                                                        <option value="44">44分</option>
                                                        <option value="45">45分</option>
                                                        <option value="46">46分</option>
                                                        <option value="47">47分</option>
                                                        <option value="48">48分</option>
                                                        <option value="49">49分</option>
                                                        <option value="50">50分</option>
                                                        <option value="51">51分</option>
                                                        <option value="52">52分</option>
                                                        <option value="53">53分</option>
                                                        <option value="54">54分</option>
                                                        <option value="55">55分</option>
                                                        <option value="56">56分</option>
                                                        <option value="57">57分</option>
                                                        <option value="58">58分</option>
                                                        <option value="59">59分</option>
                                                    </select>
                                                </span>
                                                <span id="_pushplus_check_send_text" style="display: none;">发送</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">在免打扰时间内推送定时消息</th>
                                            <td>
                                                <input type="checkbox" id="pushplus_info_silent_send" onclick="oncheckclick(this);">
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">系统运行情况</th>
                                            <td>
                                                <input type="checkbox" id="pushplus_info_system" checked="checked" onclick="oncheckclick(this);">
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">设备温度</th>
                                            <td>
                                                <input type="checkbox" id="pushplus_info_temp" checked="checked" onclick="oncheckclick(this);">
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">网络信息</th>
                                            <td>
                                                <input type="checkbox" id="pushplus_info_wan" checked="checked" onclick="oncheckclick(this);">
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">公网信息</th>
                                            <td>
                                                <input type="checkbox" id="pushplus_info_pub" checked="checked" onclick="oncheckclick(this);">
                                                <label>是否需要通过ip.sb获取公网IP,若你的wanIP就是公网IP则不建议开启</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">USB信息</th>
                                            <td>
                                                <input type="checkbox" id="pushplus_info_usb" checked="checked" onclick="oncheckclick(this);">
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">客户端列表</th>
                                            <td>
                                                <input type="checkbox" id="pushplus_info_lan" checked="checked" onclick="oncheckclick(this);">
                                                <label style="margin-left:30px;">列表关闭MAC显示<input type="checkbox" id="pushplus_info_lan_macoff" checked="checked" onclick="oncheckclick(this);">
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">DHCP租期内用户列表</th>
                                            <td>
                                                <input type="checkbox" id="pushplus_info_dhcp" checked="checked" onclick="oncheckclick(this);">
                                                <label style="margin-left:30px;">列表关闭MAC显示<input type="checkbox" id="pushplus_info_dhcp_macoff" checked="checked" onclick="oncheckclick(this);">
                                            </td>
                                        </tr>
                                    </table>
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="margin-top:8px;">
                                        <thead>
                                              <tr>
                                                <td colspan="2">触发类通知消息 (短消息)</td>
                                              </tr>
                                          </thead>
                                        <tr>
                                            <th width="20%">网络重拨时</th>
                                            <td>
                                                <input type="checkbox" id="pushplus_trigger_ifup" checked="checked" onclick="oncheckclick(this);">
                                                <label style="margin-left:30px;">重播时单独推送上面设置的路由器信息<input type="checkbox" id="pushplus_trigger_ifup_sendinfo" onclick="oncheckclick(this);">
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">设备上线时</th>
                                            <td>
                                                <input type="checkbox" id="pushplus_trigger_dhcp" checked="checked" onclick="oncheckclick(this);">
                                                <label style="margin-left:30px;">DHCP租期内用户列表显示<input type="checkbox" id="pushplus_trigger_dhcp_leases" checked="checked" onclick="oncheckclick(this);">
                                                <label style="margin-left:30px;">列表关闭MAC显示<input type="checkbox" id="pushplus_trigger_dhcp_macoff" checked="checked" onclick="oncheckclick(this);">
                                            </td>
                                        </tr>
                                        <tr>
                                            <th width="20%">设备上线提醒名单(MAC地址)<br><i>白名单：名单内设备上线不推送信息<br>黑名单：名单内设备上线推送信息</i></th>
                                            <td>
                                                <label><input type="checkbox" id="pushplus_dhcp_bwlist_en" name="pushplus_dhcp_bwlist_en" onclick="oncheckclick(this);">启用</label>（ 
                                                <label><input type="checkbox" id="pushplus_dhcp_white_en" name="pushplus_dhcp_white_en" onclick="oncheckclick(this);">白名单</label>
                                                <label><input type="checkbox" id="pushplus_dhcp_black_en" name="pushplus_dhcp_black_en" onclick="oncheckclick(this);">黑名单</label> ）
                                                <textarea placeholder="# 填入设备MAC地址，一行一个，格式如下：
                                                aa:bb:cc:dd:ee:ff
                                                aa:bb:cc:dd:ee:ff #我的电脑
                                                a1:b2:c3:d4:e5:f6 #我的手机" cols="50" rows="7" id="pushplus_trigger_dhcp_white" name="pushplus_trigger_dhcp_white" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
                                            </td>
                                        </tr>

                                    </table>
                                    <div class="apply_gen">
                                        <span><input class="button_gen" id="cmdBtn" onclick="onSubmitCtrl();" type="button" value="提交"/></span>
                                    </div>
                                </td>
                            </tr>
                        </table>
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
<script type="text/javascript">
function status_onchange(){
    var __pushplus_status_check="";
    var ___pushplus_check_inter_pre="";
    __pushplus_status_check=E("pushplus_status_check").value;
    ___pushplus_check_inter_pre=E("pushplus_check_inter_pre").value;
    //alert(__pushplus_status_check)
    if (__pushplus_status_check == "0") {
        E('_pushplus_check_day_pre').style.display="none";
        E('_pushplus_check_week_pre').style.display="none";
        E('_pushplus_check_time_pre').style.display="none";
        E('_pushplus_check_inter_pre').style.display="none";
        E('_pushplus_check_custom_pre').style.display="none";
        E('_pushplus_check_send_text').style.display="none";
    } else if(__pushplus_status_check == "1"){
        E('_pushplus_check_week_pre').style.display="none";
        E('_pushplus_check_day_pre').style.display="none";
        E('_pushplus_check_time_pre').style.display="inline";
        E('_pushplus_check_inter_pre').style.display="none";
        E('_pushplus_check_custom_pre').style.display="none";
        E('_pushplus_check_send_text').style.display="inline";
        E('pushplus_check_time_hour').style.display="inline";
    } else if(__pushplus_status_check == "2"){
        E('_pushplus_check_week_pre').style.display="inline";
        E('_pushplus_check_day_pre').style.display="none";
        E('_pushplus_check_time_pre').style.display="inline";
        E('_pushplus_check_inter_pre').style.display="none";
        E('_pushplus_check_custom_pre').style.display="none";
        E('pushplus_check_time_hour').style.display="inline";
        E('_pushplus_check_send_text').style.display="inline";
    } else if(__pushplus_status_check == "3"){
        E('_pushplus_check_week_pre').style.display="none";
        E('_pushplus_check_day_pre').style.display="inline";
        E('_pushplus_check_time_pre').style.display="inline";
        E('_pushplus_check_inter_pre').style.display="none";
        E('_pushplus_check_custom_pre').style.display="none";
        E('pushplus_check_time_hour').style.display="inline";
        E('_pushplus_check_send_text').style.display="inline";
    } else if(__pushplus_status_check == "4"){
        E('_pushplus_check_week_pre').style.display="none";
        E('_pushplus_check_day_pre').style.display="none";
        E('_pushplus_check_time_pre').style.display="none";
        E('_pushplus_check_inter_pre').style.display="inline";
        E('_pushplus_check_custom_pre').style.display="none";
        E('_pushplus_check_send_text').style.display="inline";
        if (___pushplus_check_inter_pre == "1") {
            E('pushplus_check_inter_min').style.display="inline";
            E('pushplus_check_inter_hour').style.display="none";
            E('pushplus_check_inter_day').style.display="none";
            E('_pushplus_check_time_pre').style.display="none";
            E('_pushplus_check_inter_pre').style.display="inline";
            E('_pushplus_check_send_text').style.display="inline";
        } else if(___pushplus_check_inter_pre == "2"){
            E('pushplus_check_inter_min').style.display="none";
            E('pushplus_check_inter_hour').style.display="inline";
            E('pushplus_check_inter_day').style.display="none";
            E('_pushplus_check_time_pre').style.display="none";
            E('_pushplus_check_inter_pre').style.display="inline";
            E('_pushplus_check_send_text').style.display="inline";
        } else if(___pushplus_check_inter_pre == "3"){
            E('pushplus_check_inter_min').style.display="none";
            E('pushplus_check_inter_hour').style.display="none";
            E('pushplus_check_inter_day').style.display="inline";
            E('_pushplus_check_time_pre').style.display="inline";
            E('_pushplus_check_inter_pre').style.display="inline";
            E('_pushplus_check_send_text').style.display="inline";
            E('pushplus_check_time_hour').style.display="inline";
        }
    } else if(__pushplus_status_check == "5"){
        E('_pushplus_check_week_pre').style.display="none";
        E('_pushplus_check_day_pre').style.display="none";
        E('_pushplus_check_time_pre').style.display="inline";
        E('_pushplus_check_inter_pre').style.display="none";
        E('_pushplus_check_custom_pre').style.display="inline";
        E('_pushplus_check_send_text').style.display="inline";
        E('pushplus_check_time_hour').style.display="none";
    }
}
function inter_pre_onchange(){
    var __pushplus_check_inter_pre="";
    __pushplus_check_inter_pre=E("pushplus_check_inter_pre").value;
    if (__pushplus_check_inter_pre == "1") {
        E('pushplus_check_inter_min').style.display="inline";
        E('pushplus_check_inter_hour').style.display="none";
        E('pushplus_check_inter_day').style.display="none";
        E('_pushplus_check_time_pre').style.display="none";
        E('_pushplus_check_inter_pre').style.display="inline";
        E('_pushplus_check_send_text').style.display="inline";
    } else if(__pushplus_check_inter_pre == "2"){
        E('pushplus_check_inter_min').style.display="none";
        E('pushplus_check_inter_hour').style.display="inline";
        E('pushplus_check_inter_day').style.display="none";
        E('_pushplus_check_time_pre').style.display="none";
        E('_pushplus_check_inter_pre').style.display="inline";
        E('_pushplus_check_send_text').style.display="inline";
    } else if(__pushplus_check_inter_pre == "3"){
        E('pushplus_check_inter_min').style.display="none";
        E('pushplus_check_inter_hour').style.display="none";
        E('pushplus_check_inter_day').style.display="inline";
        E('_pushplus_check_time_pre').style.display="inline";
        E('_pushplus_check_inter_pre').style.display="inline";
        E('_pushplus_check_send_text').style.display="inline";
    }
}
</script>
</html>
