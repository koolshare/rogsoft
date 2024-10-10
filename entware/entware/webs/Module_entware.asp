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
<title>Entware</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/js/jquery.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/js/table/table.js"></script>
<script language="JavaScript" type="text/javascript" src="/res/softcenter.js"></script>
<style>
#app[skin=ASUSWRT] .show-btn1, #app[skin=ASUSWRT] .show-btn2, #app[skin=ASUSWRT] .show-btn3, #app[skin=ASUSWRT] .show-btn4, #app[skin=ASUSWRT] .show-btn5 {
	font-size:10pt;
	color: #fff;
	padding: 10px 3.75px;
	border-radius: 5px 5px 0px 0px;
	width:8.42%;
	border-left: 1px solid #67767d;
	border-top: 1px solid #67767d;
	border-right: 1px solid #67767d;
	border-bottom: none;
	background: #67767d;
}
#app[skin=ASUSWRT] .show-btn1:hover, #app[skin=ASUSWRT] .show-btn2:hover, #app[skin=ASUSWRT] .show-btn3:hover, #app[skin=ASUSWRT] .show-btn4:hover, #app[skin=ASUSWRT] .show-btn5:hover, #app[skin=ASUSWRT] .active {
	border: 1px solid #2f3a3e;
	background: #2f3a3e;
}
#app[skin=ROG] .show-btn1, #app[skin=ROG] .show-btn2, #app[skin=ROG] .show-btn3, #app[skin=ROG] .show-btn4, #app[skin=ROG] .show-btn5 {
	font-size:10pt;
	color: #fff;
	padding: 10px 3.75px;
	border-radius: 5px 5px 0px 0px;
	width:8.42%;
	border: 1px solid #91071f;
	background: none;
}
#app[skin=ROG] .show-btn1:hover, #app[skin=ROG] .show-btn2:hover, #app[skin=ROG] .show-btn3:hover, #app[skin=ROG] .show-btn4:hover, #app[skin=ROG] .show-btn5:hover, #app[skin=ROG] .active {
	border: 1px solid #91071f;
	background: #91071f;
}
#app[skin=TUF] .show-btn1, #app[skin=TUF] .show-btn2, #app[skin=TUF] .show-btn3, #app[skin=TUF] .show-btn4, #app[skin=TUF] .show-btn5 {
	font-size:10pt;
	color: #fff;
	padding: 10px 3.75px;
	border-radius: 5px 5px 0px 0px;
	width:8.42%;
	border: 1px solid #92650F;
	background: none;
}
#app[skin=TUF] .show-btn1:hover, #app[skin=TUF] .show-btn2:hover, #app[skin=TUF] .show-btn3:hover, #app[skin=TUF] .show-btn4:hover, #app[skin=TUF] .show-btn5:hover, #app[skin=TUF] .active {
	border: 1px solid #92650F;
	background: #92650F;
}
#app[skin=TS] .show-btn1, #app[skin=TS] .show-btn2, #app[skin=TS] .show-btn3, #app[skin=TS] .show-btn4, #app[skin=TS] .show-btn5 {
	font-size:10pt;
	color: #fff;
	padding: 10px 3.75px;
	border-radius: 5px 5px 0px 0px;
	width:8.42%;
	border: 1px solid #2ed9c3;
	background: none;
}
#app[skin=TS] .show-btn1:hover, #app[skin=TS] .show-btn2:hover, #app[skin=TS] .show-btn3:hover, #app[skin=TS] .show-btn4:hover, #app[skin=TS] .show-btn5:hover, #app[skin=TS] .active {
	border: 1px solid #2ed9c3;
	background: #2ed9c3;
}
#app[skin=ASUSWRT] #log_content{
	outline: 1px solid #222;
	width:748px;
}
#app[skin=ROG] #log_content{
	outline: 1px solid #91071f;
	width:748px;
}
#app[skin=TUF] #log_content{
	outline: 1px solid #92650F;
	width:748px;
}
#app[skin=TS] #log_content{
	outline: 1px solid #2ed9c3;
	width:748px;
}
#app[skin=ASUSWRT] #log_content_text{
	width:97%;
	padding-left:4px;
	padding-right:37px;
	font-family:'Lucida Console';
	font-size:11px;
	line-height:1.5;
	color:#FFFFFF;
	outline:none;
	overflow-x:hidden;
	border:0px solid #222;
	background:#475A5F;
}
#app[skin=ROG] #log_content_text{
	width:97%;
	padding-left:4px;
	padding-right:37px;
	font-family:'Lucida Console';
	font-size:11px;
	line-height:1.5;
	color:#FFFFFF;
	outline:none;
	overflow-x:hidden;
	border:0px solid #222;
	background:#475A5F;
	background:transparent;
}
#app[skin=TUF] #log_content_text{
	width:97%;
	padding-left:4px;
	padding-right:37px;
	font-family:'Lucida Console';
	font-size:11px;
	line-height:1.5;
	color:#FFFFFF;
	outline:none;
	overflow-x:hidden;
	border:0px solid #222;
	background:#475A5F;
	background:transparent;
}
#app[skin=TS] #log_content_text{
	width:97%;
	padding-left:4px;
	padding-right:37px;
	font-family:'Lucida Console';
	font-size:11px;
	line-height:1.5;
	color:#FFFFFF;
	outline:none;
	overflow-x:hidden;
	border:0px solid #222;
	background:#475A5F;
	background:transparent;
}
#app[skin=ROG] #entware_disks_status, #app[skin=ROG] #usb2jffs_mount_status, #app[skin=ROG] #tablet_1, #app[skin=ROG] #tablet_2, #app[skin=ROG] #tablet_3, #app[skin=ROG] #tablet_4, #app[skin=ROG] #tablet_5 { border:1px solid #91071f; }
#app[skin=TUF] #entware_disks_status, #app[skin=TUF] #usb2jffs_mount_status, #app[skin=TUF] #tablet_1, #app[skin=TUF] #tablet_2, #app[skin=TUF] #tablet_3, #app[skin=TUF] #tablet_4, #app[skin=TUF] #tablet_5 { border:1px solid #92650F; }
#app[skin=TS] #entware_disks_status, #app[skin=TS] #usb2jffs_mount_status, #app[skin=TS] #tablet_1, #app[skin=TS] #tablet_2, #app[skin=TS] #tablet_3, #app[skin=TS] #tablet_4, #app[skin=TS] #tablet_5 { border:1px solid #2ed9c3; }
.input_option{
	vertical-align:middle;
	font-size:12px;
}
input[type=button]:focus {
	outline: none;
}
.content_status {
	position: absolute;
	-webkit-border-radius: 5px;
	-moz-border-radius: 5px;
	border-radius:10px;
	z-index: 10;
	/*background-color:#2B373B;*/
	margin-left: -215px;
	top: 140px;
	width:980px;
	return height:auto;
	box-shadow: 3px 3px 10px #000;
	background: rgba(0,0,0,0.85);
	display:none;
}
</style>
<script>
var dbus = {};
var _responseLen;
var noChange = 0;
var x = 5;
var params_inp = ['entware_install_path'];
var usbDevicesList;
var mounted;
var softver;

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

function get_disks(){
	require(['/require/modules/diskList.js'], function(diskList) {
		usbDevicesList = diskList.list();
		//console.log(usbDevicesList)
		var html = '';
		html += '<thead>'
		html += '<tr>'
		html += '<td colspan="8">磁盘分区列表</td>'
		html += '</tr>'
		html += '</thead>'	
		html += '<tr>'
		html += '<th style="width:auto">端口</th>'
		html += '<th style="width:auto">名称</th>'
		html += '<th style="width:auto">大小</th>'
		html += '<th style="width:auto">已用</th>'
		html += '<th style="width:auto">权限</th>'
		html += '<th style="width:auto">格式</th>'
		html += '<th style="width:auto">挂载点</th>'
		html += '<th style="width:auto">路径</th>'
		html += '</tr>'
		for (var i = 0; i < usbDevicesList.length; ++i){
			for (var j = 0; j < usbDevicesList[i].partition.length; ++j){
				//append options
				if(usbDevicesList[i].partition[j].status != "unmounted"){
					$("#entware_install_path").append("<option value='/tmp/mnt/" + usbDevicesList[i].partition[j].partName + "'>/tmp/mnt/" + usbDevicesList[i].partition[j].partName + "</option>");
				}
				var totalsize = ((usbDevicesList[i].partition[j].size)/1000000).toFixed(2);
				var usedsize = ((usbDevicesList[i].partition[j].used)/1000000).toFixed(2);
				var usedpercent = (usedsize/totalsize*100).toFixed(2) + " %";
				var used = usedsize + " GB" + " (" + usedpercent + ")"
				html += '<tr>'
				html += '<td>' + usbDevicesList[i].usbPath + '</td>'
				html += '<td>' + usbDevicesList[i].deviceName + '</td>'
				html += '<td>' + totalsize + " GB" + '</td>'
				html += '<td>' + used + '</td>'
				html += '<td>' + usbDevicesList[i].partition[j].status + '</td>'
				html += '<td>' + usbDevicesList[i].partition[j].format + '</td>'
				html += '<td>' + usbDevicesList[i].partition[j].mountPoint + '</td>'
				html += '<td>' + '/tmp/mnt/' + usbDevicesList[i].partition[j].partName + '</td>'
				html += '</tr>'
			}
		}
		$('#disk_table').html(html);
	});
}

function conf2obj() {
	for (var i = 0; i < params_inp.length; i++) {
		if(dbus[params_inp[i]]){
			E(params_inp[i]).value = dbus[params_inp[i]];
		}
	}
	if(dbus["entware_version"])
		E("entware_version").innerHTML = "&nbsp;-&nbsp;" + dbus["entware_version"];
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/entware",
		dataType: "json",
		cache: false,
		async: false,
		success: function(data) {
			dbus = data.result[0];
			conf2obj();
			get_disks();
			check_status();
			toggle_func();
			get_log(2);
		},
		error: function(XmlHttpRequest, textStatus, errorThrown) {
			console.log(XmlHttpRequest.responseText);
			alert("skipd数据读取错误，请用在chrome浏览器中按F12键后，在console页面获取错误信息！");
		}
	});
}

function check_status() {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "entware_status.sh", "params":[1], "fields": dbus};
	$.ajax({
		type: "POST",
		async: true,
		cache: false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			$("#_jffs_status_1").html(response.result.split("@@")[0]);
			$("#_jffs_status_2").html(response.result.split("@@")[0]);
			$('.sbt0').hide();
			$('.sbt2').hide();
			var MOUNT_FLAG = response.result.split("@@")[1];
			if (MOUNT_FLAG == 1){
				mounted = "1";
				if($('.show-btn1').hasClass("active")){
					$('.sbt0').hide();
					$('.sbt2').show();
				}
				$('#entware_install_tr').hide();
				$('#show_btn2').trigger('click');
			}else if(MOUNT_FLAG == 0){
				mounted = "0";
				if($('.show-btn1').hasClass("active")){
					$('.sbt0').show();
					$('.sbt2').hide();
				}
				$('#entware_install_tr').show();
			}
		},
		error: function(XmlHttpRequest, textStatus, errorThrown) {
			console.log(XmlHttpRequest.responseText);
		}
	});
}

function select_tablet(w){
	for (var i = 1; i <= 3; i++) {
		//将所有标签页移除选中，隐藏所有tablet，隐藏所有button
		$('.show-btn' + i).removeClass('active');
		$('#tablet_' + i).hide();
		$('.bt1').hide();
		$('.bt2').hide();
	}
	//显示对应标签的内容
	$('.show-btn' + w).addClass('active');
	$('#tablet_' + w).show();
	if(w == 1){
		if(mounted == 1){
			//挂载
			$('.sbt0').hide();
			$('.sbt2').show();
			$('.bt2').hide();
		}else if(mounted == 0){
			//未挂载，需要创建
			$('.sbt0').show();
			$('.sbt2').hide();
			$('.bt2').hide();
		}
	}else if(w == 2){
		$('.sbt0').hide();
		$('.sbt2').hide();
		$('.bt2').show();
	}else{
		$('.sbt0').hide();
		$('.sbt2').hide();
	}
}

function toggle_func(){
	$('.show-btn1').addClass('active');
	$(".show-btn1").click(
		function() {
			select_tablet(1);
		});
	$(".show-btn2").click(
		function() {
			select_tablet(2);
		});
	$(".show-btn3").click(
		function() {
			select_tablet(3);
		});
	//$('#show_btn1').trigger('click');
}

function save(flag) {
	var dbus_new = {};
	if(flag == 1){
		if (!E("entware_install_path").value){
			alert('无法选择！请插入USB磁盘！！');
			return false;
		}
		for (var i = 0; i < params_inp.length; i++) {
			dbus_new[params_inp[i]] = E(params_inp[i]).value;
		}
	}
	if(flag == 2){
		if(!confirm('\n注意：此操作会完全移除当前已经安装的Entware环境\n\n同时会删除USB磁盘里的entware文件夹，其它文件不受影响！\n\n确定删除吗？')){
			return false;
		}
	}
	for (var i = 1; i <= 7; i++) {
		if(flag != i){
			$('.bb' + i).attr('onclick', '')
		}
	}
	// post data
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "entware_config.sh", "params": [flag], "fields": dbus_new };
	$.ajax({
		type: "POST",
		cache: false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			//console.log(response);
			if (response.result == id){
				if(flag != 4){
					get_log(1);
				}
				else{
					get_log(1);
				}
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

function get_log(flag){
	$.ajax({
		url: '/_temp/entware_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content_text");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", " ");
				if(flag == 1){
					refreshpage();
				}else if(flag == 2){
					setTimeout("get_log();", 1500);
				}else{
					return false;
				}
			}else{
				if(flag == 2){
					return false;
				}else{
					setTimeout("get_log(" + flag + ");", 300);
				}
			}
			retArea.value = response.replace("XU6J03M6", " ");
			retArea.scrollTop = retArea.scrollHeight;
		}
	});
}

(function($) {
	$.fn.forms = function(data, settings) {
		$(this).append(createFormFields(data, settings));
	}
})(jQuery);

function escapeHTML(s) {
	function esc(c) {
		return '&#' + c.charCodeAt(0) + ';';
	}
	return s.replace(/[&"'<>\r\n]/g, esc);
}

function UT(v) {
	return (typeof(v) == 'undefined') ? '' : '' + v;
}

function createFormFields(data, settings) {
	var id, id1, common, output, form = '', multiornot;
	var s = $.extend({
		'align': 'left',
		'grid': ['col-sm-3', 'col-sm-9']

	}, settings);
	$.each(data, function(key, v) {
		if (!v) {
			form += '<br />';
			return;
		}
		if (v.ignore) return;
		if (v.th) {
			form += '<tr' + ((v.class) ? ' class="' + v.class + '"' : '') + '><th colspan="2">' + v.title + '</th></tr>';
			return;
		}
		if (v.thead) {
			form += '<thead><tr><td colspan="2">' + v.title + '</td></tr></thead>';
			return;
		}
		if (v.td) {
			form += v.td;
			return;
		}
		form += '<tr' + ((v.rid) ? ' id="' + v.rid + '"' : '') + ((v.class) ? ' class="' + v.class + '"' : '') + ((v.hidden) ? ' style="display: none;"' : '') + '>';
		if (v.help) {
			v.title += '&nbsp;&nbsp;<a class="hintstyle" href="javascript:void(0);" onclick="openssHint(' + v.help + ')"><font color="#ffcc00"><u>[说明]</u></font></a>';
		}
		if (v.text) {
			if (v.title)
				form += '<label class="' + s.grid[0] + ' ' + ((s.align == 'center') ? 'control-label' : 'control-left-label') + '">' + v.title + '</label><div class="' + s.grid[1] + ' text-block">' + v.text + '</div></fieldset>';
			else
				form += '<label class="' + s.grid[0] + ' ' + ((s.align == 'center') ? 'control-label' : 'control-left-label') + '">' + v.text + '</label></fieldset>';
			return;
		}
		if (v.multi) multiornot = v.multi;
		else multiornot = [v];
		output = '';
		$.each(multiornot, function(key, f) {
			id = (f.id ? f.id : '');
			common = ' id="' + id + '"';
			if (f.func == 'v') common += ' onchange="verifyFields(this, 1);"';
			else if (f.func == 'u') common += ' onchange="update_visibility();"';
			else if (f.func) common += ' ' + f.func

			if (f.attrib) common += ' ' + f.attrib;
			if (f.ph) common += ' placeholder="' + f.ph + '"';
			if (f.disabled) common += ' disabled="disabled"'
			if (f.prefix) output += f.prefix;
			switch (f.type) {
				case 'checkbox':
					if (f.css) common += ' class="' + f.css + '"';
					if (f.style) common += ' style="' + f.style + '"';
					output += '<input type="checkbox"' + (f.value ? ' checked' : '') + common + '>' + (f.suffix ? f.suffix : '');
					break;
				case 'radio':
					output += '<div class="radio c-radio"><label><input class="custom" type="radio"' + (f.value ? ' checked' : '') + common + '>\
					<span></span> ' + (f.suffix ? f.suffix : '') + '</label></div>';
					break;
				case 'password':
					common += ' class="input_ss_table" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"';
					if (f.style) common += ' style="' + f.style + '"';
					if (f.peekaboo) common += ' readonly onBlur="switchType(this, false);" onFocus="switchType(this, true);this.removeAttribute(' + '\'readonly\'' + ');"';
					output += '<input type="' + f.type + '"' + ' value="' + escapeHTML(UT(f.value)) + '"' + (f.maxlen ? (' maxlength="' + f.maxlen + '" ') : '') + common + '>';
					break;
				case 'text':
					if (f.css) common += ' class="input_ss_table ' + f.css + '"';
					else common += ' class="input_ss_table" spellcheck="false"';
					if (f.style) common += ' style="' + f.style + '"';
					if (f.title) common += ' title="' + f.title + '"';
					output += '<input type="' + f.type + '"' + ' value="' + escapeHTML(UT(f.value)) + '"' + (f.maxlen ? (' maxlength="' + f.maxlen + '" ') : '') + common + '>';
					break;
				case 'select':
					if (f.css) common += ' class="input_option ' + f.css + '"';
					else common += ' class="input_option"';
					if (f.style) common += ' style="' + f.style + ';margin:0px 0px 0px 2px;"';
					else common += ' style="width:164px;margin:0px 0px 0px 2px;"';
					output += '<select' + common + '>';
					for (optsCount = 0; optsCount < f.options.length; ++optsCount) {
						a = f.options[optsCount];
						if (!Array.isArray(a)) {
							output += '<option value="' + a + '"' + ((a == f.value) ? ' selected' : '') + '>' + a + '</option>';
						} else {
							if (a.length == 1) a.push(a[0]);
							output += '<option value="' + a[0] + '"' + ((a[0] == f.value) ? ' selected' : '') + '>' + a[1] + '</option>';
						}
					}
					output += '</select>';
					break;
				case 'textarea':
					common += ' autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"';
					if (f.style) common += ' style="' + f.style + ';margin:0px 0px 0px 2px;"';
					else common += ' style="margin:0px 0px 0px 2px;"';
					if (f.rows) common += ' rows="' + f.rows + '"';
					output += '<textarea ' + common + (f.wrap ? (' wrap=' + f.wrap) : '') + '>' + escapeHTML(UT(f.value)) + '</textarea>';
					break;
				default:
					if (f.custom) output += f.custom;
					break;
			}
			if (f.suffix && (f.type != 'checkbox' && f.type != 'radio')) output += f.suffix;
		});
		if (v.hint) form += '<th><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(' + v.hint + ')">' + v.title + '</a></th><td>' + output;
		else form += '<th>' + v.title + '</th><td>' + output;
		form += '</td></tr>';
	});
	return form;
}

function menu_hook() {
	tabtitle[tabtitle.length - 1] = new Array("", "entware");
	tablink[tablink.length - 1] = new Array("", "Module_entware.asp");
}

function reload_Soft_Center(){
	location.href = "/Module_Softcenter.asp";
}
function help(){
	window.open('https://koolshare.cn/forum-98-1.html');
}
</script>
</head>
<body id="app" skin="ASUSWRT" onload="init();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="POST" name="form" action="/applydb.cgi?p=swap_" target="hidden_frame">
<input type="hidden" name="current_page" value="Module_entware.asp"/>
<input type="hidden" name="next_page" value="Module_entware.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value=""/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" id="usb_td" value=""/>
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="swap_load.sh"/>
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
						<div>
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div id="qrcode_show" class="content_status" style="box-shadow: 3px 3px 10px #000;margin-top:-40px;margin-left:120px;display: none;width:520px;height:340px;background: #fff;">
											<div id="qrcode" style="margin: 10px 5px 10px 0px;width:520px;height:240px;text-align:center;overflow:hidden" >
												<canvas width="520px" height="360px" style="display: none;"></canvas>
												<img style="height:240px" src="https://fw.koolcenter.com/binary/image_bed/sadog/sadog.png"/>
											</div>
											<div style="margin-top:5px;padding-bottom:10px;width:100%;text-align:center;">
												<input class="button_gen" type="button" onclick="cleanCode();" value="关闭">
											</div>
										</div>
										<div style="float:left;" class="formfonttitle" style="padding-top: 12px">Entware<lable id="entware_version"></lable></div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div style="margin-left:5px;" id="head_illustrate">
											Entware插件可以轻松帮你安装和管理Entware。
											<a type="button" href="https://github.com/koolshare/rogsoft/blob/master/entware/Changelog.txt" target="_blank" class="ks_btn" style="cursor: pointer;margin-left:5px;border:none" >更新日志</a>
										</div>
										
										<div id="entware_disks_status" style="margin:10px 0px 0px 0px;">
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="disk_table">
											</table>
										</div>

										<div id="log_content" style="margin:10px 0px 0px 0px;;display:block;overflow:hidden;">
											<textarea cols="63" rows="15" wrap="on" readonly="readonly" id="log_content_text" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
										</div>
										
										<div id="tablet_show">
											<table style="margin:10px 0px 0px 0px;border-collapse:collapse" width="100%" height="37px">
												<tr>
													<td cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#222">
														<input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="操作"/>
														<input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="命令"/>
														<input id="show_btn3" class="show-btn3" style="cursor:pointer" type="button" value="帮助"/>
													</td>
													</tr>
											</table>
										</div>
										<div id="tablet_1">
											<table id="entware_config" width="100%" border="0" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<script type="text/javascript">
													$('#entware_config').forms([
														{ title: 'Entware安装状态', suffix: '<div id="_jffs_status_1"><i></i></div>' },
														{ title: '选择Entware安装路径', rid: 'entware_install_tr', multi: [
															{ id:'entware_install_path', type:'select', style:'width:auto', func:'u', options:[], value:'0'}
														]}
													]);
												</script>
											</table>
										</div>
										<div id="tablet_2" style="display: none;">
											<table id="entware_snapshot" width="100%" border="0" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<script type="text/javascript">
													$('#entware_snapshot').forms([
														{ title: 'Entware安装状态', suffix: '<div id="_jffs_status_2"><i></i></div>' },
														{ title: '列出所有软件包', multi: [
															{ suffix:'&nbsp;&nbsp;<a type="button" class="ks_btn bb3" style="cursor:pointer;" onclick="save(3)">opkg list</a>'},
														]},
														{ title: '更新软件包列表', multi: [
															{ suffix:'&nbsp;&nbsp;<a type="button" class="ks_btn bb4" style="cursor:pointer;" onclick="save(4)">opkg update</a>'},
														]},
														{ title: '列出所有已安装软件包', multi: [
															{ suffix:'&nbsp;&nbsp;<a type="button" class="ks_btn bb5" style="cursor:pointer;" onclick="save(5)">opkg list-installed</a>'},
														]},
														{ title: '列出所有可升级软件包', multi: [
															{ suffix:'&nbsp;&nbsp;<a type="button" class="ks_btn bb6" style="cursor:pointer;" onclick="save(6)">opkg list-upgradable</a>'},
														]}
													]);
												</script>
											</tr>										
											</table>
										</div>
										<div id="tablet_3" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
												<td>
													<ul>
														<h4><i>插件说明</i></h4>
															&nbsp;&nbsp;&nbsp;&nbsp;1. 使用Entware插件，轻松帮安装和管理Entware环境。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;2. 为了加速国内使用体验，我们部署了国内镜像，同步Entware官方源。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;3. 如果你之前手动部署了Entware，插件也能识别，但是更建议你用本插件重新部署。<br />
														<h4><i>插件使用</i></h4>
															&nbsp;&nbsp;&nbsp;&nbsp;1. 使用本插件，你需要提前准备一个已经格式化成ext3/ext4格式的U盘。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;2. 如果不知道如何制作ext格式的磁盘，可以使用虚拟内存插件制作一次虚拟内存即可。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;3. 本插件安装Entware环境可以与虚拟内存插件和USB2JFFS插件使用同一个磁盘。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;4. 使用的U盘质量不能太差，要求读写速度不能太低，可长时间稳定运行，不然可能极度影响使用体验。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;5. 安装Entware环境时，建议路由器只插入一个USB设备，以免出现未知问题。<br />
														<h4><i>插件功能</i></h4>
															&nbsp;&nbsp;&nbsp;&nbsp;挂载： 插入U盘，选择目录，点击安装，插件会在USB磁盘中创建entware目录，用于安装entware环境。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;删除： 点击删除，会删除USB磁盘中的entware目录，entware插件的开机启动配置等。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;命令： 点击命令标签页，会有一些简单的opkg命令按钮，安装包等其他命令请使用命令行手动操作。<br />
														<h4><i>注意事项</i></h4>
															&nbsp;&nbsp;&nbsp;&nbsp;1. 一些依赖Entware的插件，必须提前安装Entware插件并配置Entware环境后才能使用<br />
															&nbsp;&nbsp;&nbsp;&nbsp;2. 如果已经安装了依赖Entware环境的插件，无法使用此插件删除Entware环境<br />
													</ul>
												</td>
												</tr>
											</table>
										</div>
										<div id="apply_button" class="apply_gen">
											<input class="button_gen bt1 bb1 sbt0" type="button" onclick="save(1)" value="安装" style="display: none;">
											<input class="button_gen bt1 bb2 sbt2" type="button" onclick="save(2)" value="删除" style="display: none;">
											<input class="button_gen bt2 bb7"  type="button" onclick="save(7)" value="清除日志" style="display: none;">
										</div>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</td>
		<td width="10" align="center" valign="top"></td>
	</tr>
</table>
</form>
<div id="footer"></div>
</body>
</html>

