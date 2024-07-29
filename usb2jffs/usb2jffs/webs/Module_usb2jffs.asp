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
<title>USB2JFF2</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" language="JavaScript" src="/js/table/table.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
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
#log_content{
	outline: 1px solid #222;
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
#app[skin=ROG] #usb2jffs_disks_status, #app[skin=ROG] #usb2jffs_mount_status, #app[skin=ROG] #tablet_1, #app[skin=ROG] #tablet_2, #app[skin=ROG] #tablet_3, #app[skin=ROG] #tablet_4, #app[skin=ROG] #tablet_5 { border:1px solid #91071f; }
#app[skin=TUF] #usb2jffs_disks_status, #app[skin=TUF] #usb2jffs_mount_status, #app[skin=TUF] #tablet_1, #app[skin=TUF] #tablet_2, #app[skin=TUF] #tablet_3, #app[skin=TUF] #tablet_4, #app[skin=TUF] #tablet_5 { border:1px solid #92650F; }
#app[skin=TS] #usb2jffs_disks_status, #app[skin=TS] #usb2jffs_mount_status, #app[skin=TS] #tablet_1, #app[skin=TS] #tablet_2, #app[skin=TS] #tablet_3, #app[skin=TS] #tablet_4, #app[skin=TS] #tablet_5 { border:1px solid #2ed9c3; }
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
var params_inp = ['usb2jffs_mount_path', 'usb2jffs_sync', 'usb2jffs_week', 'usb2jffs_day', 'usb2jffs_inter_min', 'usb2jffs_inter_hour', 'usb2jffs_inter_day', 'usb2jffs_inter_pre', 'usb2jffs_custom', 'usb2jffs_time_hour', 'usb2jffs_time_min', 'usb2jffs_backup_file'];
var params_chk = ['usb2jffs_rsync'];
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
		var flag_total=0;
		for (var i = 0; i < usbDevicesList.length; ++i){
			for (var j = 0; j < usbDevicesList[i].partition.length; ++j){
				//append options
				if(usbDevicesList[i].partition[j].status != "unmounted"){
					if(usbDevicesList[i].partition[j].format.indexOf("ext") != -1){
						++flag_total;
						$("#usb2jffs_mount_path").append("<option value='/tmp/mnt/" + usbDevicesList[i].partition[j].partName + "'>/tmp/mnt/" + usbDevicesList[i].partition[j].partName + "</option>");
					}
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

		if(flag_total == 0){
			$("#msg_1").html("无法选择！请检查磁盘格式或者挂载情况！！");
			$("#msg_1").show();
			$(".button_gen .bt1 .sbt0").attr("disabled", "disabled");
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
	for (var i = 0; i < params_chk.length; i++) {
		if(dbus[params_chk[i]]){
			E(params_chk[i]).checked = dbus[params_chk[i]] == "1";
		}
	}
	if(dbus["usb2jffs_version"])
		E("usb2jffs_version").innerHTML = "&nbsp;-&nbsp;" + dbus["usb2jffs_version"];
}
function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/usb2jffs",
		dataType: "json",
		cache: false,
		async: false,
		success: function(data) {
			dbus = data.result[0];
			conf2obj();
			get_disks();
			check_status();
			toggle_func();
			update_visibility();
		},
		error: function(XmlHttpRequest, textStatus, errorThrown) {
			console.log(XmlHttpRequest.responseText);
			alert("skipd数据读取错误，请用在chrome浏览器中按F12键后，在console页面获取错误信息！");
		}
	});
}
function check_status() {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "usb2jffs_mount_status.sh", "params":[1], "fields": dbus};
	$.ajax({
		type: "POST",
		async: true,
		cache: false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			$("#_jffs_status").html(response.result.split("@@")[0]);
			$("#_mount_status").html(response.result.split("@@")[1]);
			$('.sbt0').hide();
			$('.sbt1').hide();
			$('.sbt2').hide();
			var MOUNT_FLAG = response.result.split("@@")[2];
			if (MOUNT_FLAG == 1){
				mounted = "1";
				if($('.show-btn1').hasClass("active")){
					$('.sbt0').hide();
					$('.sbt1').show();
					$('.sbt2').show();
				}
			}else if(MOUNT_FLAG == 0){
				mounted = "0";
				if($('.show-btn1').hasClass("active")){
					$('.sbt0').show();
					$('.sbt1').hide();
					$('.sbt2').hide();
				}
			}else if(MOUNT_FLAG == 2){
				mounted = "2";
				if($('.show-btn1').hasClass("active")){
					$('.sbt0').show();
					$('.sbt1').hide();
					$('.sbt2').show();
				}
			}
		}
	});
}
function get_backup_status() {
	// get snap file
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "usb2jffs_backup_status.sh", "params":[1], "fields": dbus};
	$.ajax({
		type: "POST",
		async: true,
		cache: false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			option_file = response.result.split( '>' );
			//console.log(option_file);
			$("#usb2jffs_backup_file").find('option').remove().end();
			for ( var i = 0; i < option_file.length; i++){
				$("#usb2jffs_backup_file").append('<option value="' + option_file[i] + '">' + option_file[i]  + '</option>');
			}
		}
	});
}
function select_tablet(w){
	for (var i = 1; i <= 5; i++) {
		//将所有标签页移除选中，隐藏所有tablet，隐藏所有button
		$('.show-btn' + i).removeClass('active');
		$('#tablet_' + i).hide();
		$('.bt' + i).hide();
	}
	//显示对应标签的内容
	$('.show-btn' + w).addClass('active');
	$('#tablet_' + w).show();
	if(w != 1){
		$('.bt' + w).show();
		$('.sbt0').hide();
		$('.sbt1').hide();
		$('.sbt2').hide();
	}else if(w == 1){
		if(mounted == 1){
			//挂载
			$('.sbt0').hide();
			$('.sbt1').show();
			$('.sbt2').show();
		}else if(mounted == 0){
			//未挂载，需要创建
			$('.sbt0').show();
			$('.sbt1').hide();
			$('.sbt2').hide();
		}else if(mounted == 2){
			//未挂载，不需要创建
			$('.sbt0').show();
			$('.sbt1').hide();
			$('.sbt2').show();
		}
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
			get_backup_status();
		});
	$(".show-btn4").click(
		function() {
			select_tablet(4);
			get_log(1);
		});
	$(".show-btn5").click(
		function() {
			select_tablet(5);
		});
	//$('#show_btn1').trigger('click');
}
function update_visibility() {
	var Ti = E("usb2jffs_sync").value;
	var In = E("usb2jffs_inter_pre").value;
	var items = ["re1", "re2", "re3", "re4", "re4_1", "re4_2", "re4_3", "re5"];
	for ( var i = 1; i < items.length; ++i ) $("." + items[i]).hide();
	if (Ti != "0") $(".re" + Ti).show();
	if (Ti == "4") $(".re4_" + In).show();
}
function save(flag) {
	var dbus_new = {};
	if(flag == 1){
		if (!E("usb2jffs_mount_path").value){
			alert('无法选择！请检查USB磁盘挂载情况或格式！！');
			return false;
		}
	}
	if(flag == 2 && dbus["usb2jffs_warn_1"] != "1"){
		if(!confirm('注意：卸载操作只会将挂载脱离，并不会删除koolshare_jffs文件夹！\n\n即使重启路由器也不会自动挂载，除非手动重新挂载！\n\n确定卸载吗？')){
			return false;
		}else{
			dbus_new["usb2jffs_warn_1"] = "1"
		}
	}
	if(flag == 3 && dbus["usb2jffs_warn_2"] != "1"){
		if(!confirm('注意：此操作会删除U盘里的koolshare_jffs文件夹，其它文件不受影响！\n\n确定删除吗？')){
			return false;
		}else{
			dbus_new["usb2jffs_warn_2"] = "1"
		}
	}
	if(flag == 8 ){
		if(mounted == 0){
			alert("错误！没有检测到USB磁盘挂载在/jffs，无法备份！\n\n请先挂载USB磁盘到/jffs后再使用本功能！");
			return false;
		}
	}
	if(flag == 9 || flag == 10 || flag == 11){
		if(!E("usb2jffs_backup_file").value){
			alert("没有备份文件！");
			return false;
		}
	}
	if(flag != 4){
		// E("log_content_text") == "";
		// $("#show_btn4").trigger("click");
		// collect data from input and checkbox
		for (var i = 0; i < params_inp.length; i++) {
			dbus_new[params_inp[i]] = E(params_inp[i]).value;
		}
		for (var i = 0; i < params_chk.length; i++) {
			dbus_new[params_chk[i]] = E(params_chk[i]).checked ? '1' : '0';
		}
	}
	// post data
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "usb2jffs_config.sh", "params": [flag], "fields": dbus_new };
	$.ajax({
		type: "POST",
		cache: false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			//console.log(response);
			if (response.result == id){
				if(flag == 11){
					file_name = E("usb2jffs_backup_file").value;
					var a = document.createElement('A');
					a.href = "_root/files/" + file_name;
					a.download = file_name;
					document.body.appendChild(a);
					a.click();
					document.body.removeChild(a);
				}
				else if(flag == 9 || flag == 10){
					get_log(1);
					$("#show_btn4").trigger("click");
				}
				else if(flag != 4){
					get_log(1);
					$("#show_btn4").trigger("click");
				}
				else{
					get_log(1);
					$("#show_btn4").trigger("click");
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
function upload_backup() {
	// .koolshare_jffs_20210221_092734.tar
	var file_name = $("#file").val();

	if(!file_name){
		alert('文件为空，请选择备份文件！');
		return false;
	}
	
	file_name = file_name.split('\\');
	file_name = file_name[file_name.length - 1];
	//console.log("file_name: ", file_name);

	file_suffix = file_name.split('\.');
	file_suffix = file_suffix[file_suffix.length - 1];
	//console.log("file_suffix: ", file_suffix);
	if(file_suffix != "tar"){
		alert('备份文件的格式不正确！\n\n正确的文件名示例：.koolshare_jffs_20210221_092734.tar');
		return false;
	}
	
	var regExp = /\.koolshare_jffs_/g;
	if(!regExp.test(file_name)){
		alert('备份文件的文件名前缀不正确！\n\n正确的文件名示例：.koolshare_jffs_20210221_092734.tar');
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
					"usb2jffs_backupfile_name": file_name,
				};
				document.getElementById('file_info').style.display = "block";
				restore_backup(Info);
			}
		}
	});
}
function restore_backup(Info) {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "usb2jffs_config.sh", "params": [12], "fields": Info };
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			if(response.result == id){
				get_log(1);
				$("#show_btn4").trigger("click");
			}
		}
	});
}
function get_log(flag){
	$.ajax({
		url: '/_temp/usb2jffs_log.txt',
		type: 'GET',
		dataType: 'html',
		async: true,
		cache: false,
		success: function(response) {
			var retArea = E("log_content_text");
			retArea.value = response.replace("XU6J03M6", " ");
			if (response.search("XU6J03M6") != -1) {
				if(flag){
					return true;
				}else{
					//return true;
					setTimeout("refreshpage();", 2500);
				}
			}
			if (_responseLen == response.length) {
				noChange++;
			} else {
				noChange = 0;
			}
			if (noChange > 50) {
				return false;
			} else {
				setTimeout("get_log(" + flag + ");", 300);
			}
			//retArea.value = response;
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		},
		error: function(xhr) {
			setTimeout("get_log();", 600);
			if(E("log_content_text").value && E("log_content_text").value != "暂无日志信息！"){
				//$('#log_content_text').val($('#log_content_text').val() + "操作正在进行中，请等待日志恢复！请不要拔掉USB磁盘！！")
				E("log_content_text").value = "操作正在进行中，请等待日志恢复！\n期间请不要拔掉USB磁盘！！";
			}else{
				E("log_content_text").value = "暂无日志信息！";
			}
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
	tabtitle[tabtitle.length - 1] = new Array("", "usb2jffs");
	tablink[tablink.length - 1] = new Array("", "Module_usb2jffs.asp");
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
<input type="hidden" name="current_page" value="Module_usb2jffs.asp"/>
<input type="hidden" name="next_page" value="Module_usb2jffs.asp"/>
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
										<div style="float:left;" class="formfonttitle" style="padding-top: 12px">USB2JFFS<lable id="usb2jffs_version"></lable></div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div style="margin-left:5px;" id="head_illustrate">
											<li>使用USB2JFFS插件，轻松用U盘挂载系统JFFS分区。
											<a type="button" href="https://github.com/koolshare/rogsoft/blob/master/usb2jffs/Changelog.txt" target="_blank" class="ks_btn" style="cursor: pointer;margin-left:5px;border:none" >更新日志</a>
											</li>
										</div>
										
										<div id="usb2jffs_disks_status" style="margin:10px 0px 0px 0px;">
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="disk_table">
											</table>
										</div>

										<div id="usb2jffs_mount_status" style="margin:10px 0px 0px 0px;">
											<table id="status_pannel" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<script type="text/javascript">
													$('#status_pannel').forms([
														{ title: '状态', thead:'1'},
														{ title: 'JFFS使用量', suffix: '<div id="_jffs_status"><i></i></div>' },
														{ title: '挂载状态', suffix: '<div id="_mount_status"><i>检测状态中 ...</i></div>' }
													]);
												</script>
											</table>
										</div>
										<div id="tablet_show">
											<table style="margin:10px 0px 0px 0px;border-collapse:collapse" width="100%" height="37px">
												<tr>
													<td cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#222">
														<input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="操作"/>
														<input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="同步"/>
														<input id="show_btn3" class="show-btn3" style="cursor:pointer" type="button" value="备份"/>
														<input id="show_btn4" class="show-btn4" style="cursor:pointer" type="button" value="日志"/>
														<input id="show_btn5" class="show-btn5" style="cursor:pointer" type="button" value="帮助"/>
													</td>
													</tr>
											</table>
										</div>
										<div id="tablet_1">
											<table id="usb2jffs_config" width="100%" border="0" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<script type="text/javascript">
													$('#usb2jffs_config').forms([
														{ title: '选择挂载路径', multi: [
															{ id:'usb2jffs_mount_path', type:'select', style:'width:auto', func:'u', options:[], value:'0'},
															{ suffix:'&nbsp;<span id="msg_1" style="display:none;" >没有符合要求的磁盘！</span>'}
														]}
													]);
												</script>
											</table>
										</div>
										<div id="tablet_2" style="display: none;">
											<table id="usb2jffs_filesync" width="100%" border="0" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<script type="text/javascript">
													var title1 = "填写说明：&#13;此处填写1-23之间任意小时&#13;小时间用逗号间隔，如：&#13;当天的8点、10点、15点则填入：8,10,15"
													var option_rebc = [["0", "关闭"], ["1", "每天"], ["2", "每周"], ["3", "每月"], ["4", "每隔"], ["5", "自定义"]];
													var option_rebw = [["1", "一"], ["2", "二"], ["3", "三"], ["4", "四"], ["5", "五"], ["6", "六"], ["7", "日"]];
													var option_rebd = [];
													for (var i = 1; i < 32; i++){
														var _tmp = [];
														_i = String(i)
														_tmp[0] = _i;
														_tmp[1] = _i + "日";
														option_rebd.push(_tmp);
													}
													var option_rebim = ["1", "5", "10", "15", "20", "25", "30"];
													var option_rebih = [];
													for (var i = 1; i < 13; i++) option_rebih.push(String(i));
													var option_rebid = [];
													for (var i = 1; i < 31; i++) option_rebid.push(String(i));
													var option_rebip = [["1", "分钟"], ["2", "小时"], ["3", "天"]];
													var option_rebh = [];
													for (var i = 0; i < 24; i++){
														var _tmp = [];
														_i = String(i)
														_tmp[0] = _i;
														_tmp[1] = _i + "时";
														option_rebh.push(_tmp);
													}
													var option_rebm = [];
													for (var i = 0; i < 61; i++){
														var _tmp = [];
														_i = String(i)
														_tmp[0] = _i;
														_tmp[1] = _i + "分";
														option_rebm.push(_tmp);
													}
													$('#usb2jffs_filesync').forms([
														{ title: '定时同步（USB_JFFS → MTD_JFFS）', rid:'usb2jffs_sync_tr', multi: [
															{ id:'usb2jffs_sync', type:'select', style:'width:auto', func:'u', options:option_rebc, value:'0'},
															{ id:'usb2jffs_week', type:'select', style:'width:auto;display:none;', css:'re2', options:option_rebw, value:'1'},
															{ id:'usb2jffs_day', type:'select', style:'width:auto;display:none;', css:'re3', options:option_rebd, value:'1'},
															{ id:'usb2jffs_inter_min', type:'select', style:'width:auto;display:none;', css:'re4_1', options:option_rebim, value:'1'},
															{ id:'usb2jffs_inter_hour', type:'select', style:'width:auto;display:none;', css:'re4_2', options:option_rebih, value:'12'},
															{ id:'usb2jffs_inter_day', type:'select', style:'width:auto;display:none;', css:'re4_3', options:option_rebid, value:'1'},
															{ id:'usb2jffs_inter_pre', type:'select', style:'width:auto;display:none;', func:'u', css:'re4', options:option_rebip, value:'2'},
															{ id:'usb2jffs_custom', type:'text', style:'width:150px;display:none;', css:'re5', ph:'8,10,15', title:title1},
															{ suffix:'<span style="display:none;" class="re5">&nbsp;小时</span>'},
															{ id:'usb2jffs_time_hour', type:'select', style:'width:auto;display:none;', css:'re1 re2 re3 re4_3', options:option_rebh, value:'0'},
															{ id:'usb2jffs_time_min', type:'select', style:'width:auto;display:none;', css:'re1 re2 re3 re4_3 re5', options:option_rebm, value:'0'},
															{ suffix:'&nbsp;<a type="button" class="ks_btn bt2" style="cursor:pointer;display:none;" onclick="save(6)">应用定时设定</a>'}
														]},
														{ title: '卸载/删除时同步', rid:'usb2jffs_rsync_tr', multi: [
															{ id:'usb2jffs_rsync', func:'u', type:'checkbox', value:false},
															{ suffix:'&nbsp;<a type="button" class="ks_btn bt2" style="cursor:pointer;display:none;" onclick="save(7)">应用此设定</a>'}
														]},
													]);
												</script>
											</table>
										</div>
										<div id="tablet_3" style="display: none;">
											<table id="usb2jffs_snapshot" width="100%" border="0" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<th>上传备份</th>
													<td>
														&nbsp;<a class="ks_btn bt3" href="javascript:void(0);" onclick="upload_backup()">上传备份</a>
														<input style="color:#FFCC00;*color:#000;width: 350px;vertical-align: middle;" id="file" type="file" name="file"/>
														<img id="loadingicon" style="margin-left:5px;margin-right:5px;display:none;" src="/images/InternetScan.gif">
														<span id="file_info" style="display:none;">完成</span>
													</td>
												</tr>												
												<script type="text/javascript">
													$('#usb2jffs_snapshot').forms([
														{ title: '创建备份', multi: [
															{ suffix:'&nbsp;<a type="button" class="ks_btn bt3" style="cursor:pointer;" onclick="save(8)">创建备份</a>'}
														]},
														{ title: '备份恢复', multi: [
															{ id:'usb2jffs_backup_file', type:'select', style:'width:auto', func:'u', options:[], value:'0'},
															{ suffix:'&nbsp;<a type="button" class="ks_btn bt3" style="cursor:pointer;" onclick="save(9)">恢复</a>'},
															{ suffix:'&nbsp;<a type="button" class="ks_btn bt3" style="cursor:pointer;" onclick="save(10)">删除</a>'},
															{ suffix:'&nbsp;<a type="button" class="ks_btn bt3" style="cursor:pointer;" onclick="save(11)">下载</a>'}
														]}
													]);
												</script>
											</tr>										
											</table>
										</div>
										<div id="tablet_4" style="display: none;">
											<div id="log_content" style="margin-top:-1px;display:block;overflow:hidden;">
												<textarea cols="63" rows="22" wrap="on" readonly="readonly" id="log_content_text" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
											</div>
										</div>
										<div id="tablet_5" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
												<td>
													<ul>
														<h4><i>插件说明</i></h4>
															&nbsp;&nbsp;&nbsp;&nbsp;1. 使用USB2JFFS插件，轻松用U盘挂载系统JFFS分区。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;2. 部分实现参考了：<a href="https://koolshare.cn/thread-161017-1-1.html" title="" target="_blank"><em>此koolshare论坛贴</em></a>，不过已经大不相同。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;3. 插件GITHUB开源地址：<a href="https://github.com/koolshare/rogsoft/tree/master/usb2jffs" title="" target="_blank"><em>https://github.com/koolshare/rogsoft/tree/master/usb2jffs</em></a><br />
														<h4><i>插件使用</i></h4>
															&nbsp;&nbsp;&nbsp;&nbsp;1. 使用本插件，你需要提前准备一个已经格式化成ext3/ext4格式的U盘（或者和虚拟内存一个盘）。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;2. 使用的U盘质量不能太差，要求读写速度不能太低，可长时间稳定运行，不然可能极度影响使用体验。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;3. 用USB磁盘挂载JFFS的时候，建议路由器只插入一个USB设备，以免出现未知问题。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;4. 建议使用本插件挂载了USB JFFS后保持路由器长时间开机，不要频繁重启。
														<h4><i>插件功能</i></h4>
															&nbsp;&nbsp;&nbsp;&nbsp;挂载： 插入U盘，点击挂载，插件会在USB磁盘中创建.koolshare_jffs目录，并用此目录挂载到/jffs。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;卸载： 仅会移除/jffs与USB磁盘的挂载关系，并不会删除U盘和JFFS里的任何内容。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;删除： 不仅会移除/jffs与USB磁盘的挂载关系，还会删除USB磁盘里的.koolshare_jffs目录。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;同步： 点击同步，会将USB磁盘里.koolshare_jffs目录和固件FLASH里的原始jffs挂载点分区进行同步。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;备份： 点击备份，会将USB磁盘里.koolshare_jffs目录打包成tar格式的压缩包，并且可以进行恢复和下载。。<br />
														<h4><i>关于测速</i></h4>
															&nbsp;&nbsp;&nbsp;&nbsp;在创建挂载时，USB2JFFS插件会对USB磁盘进行简单的读写速度测试。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;因为测试文件块较小，此测试速度和USB磁盘实际速度可能有一定差别，因此本插件的读写速度结果仅供参考。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;在同等测试条件下，RT-AC86U, RT-AX88U, GT-AC5300等机型的flash读为10MB/s, 写为30MB/s。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;如果你的USB磁盘读写速度较低，使用本插件将会得到更差的实际体验！。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;因此，USB2JFFS插件要求USB磁盘设备读取不低于20MB/s, 写入速度不低于为30MB/s。<br />
														<h4><i>注意事项</i></h4>
															&nbsp;&nbsp;文件同步：<br />
															&nbsp;&nbsp;&nbsp;&nbsp;1. 在成功挂载后，会复制原jffs目录下所有文件到USB磁盘的新jffs目录（即.koolshare_jffs文件夹）<br />
															&nbsp;&nbsp;&nbsp;&nbsp;2. 因路由器系统相关文件写入/更新、软件中心插件安装/更新等操作，新jffs内的文件会比原jffs新<br />
															&nbsp;&nbsp;&nbsp;&nbsp;3. 设定自动同步，或者手动点击同步按钮，会将新jffs下的文件和原jffs文件进行对比，并进行更新<br />
															&nbsp;&nbsp;&nbsp;&nbsp;4. 自动同步和点击同步按钮不宜太频繁，避免文件频繁更新导致原jffs出现问题。<br />
															&nbsp;&nbsp;&nbsp;&nbsp;5. 如果安装了很多插件导致.koolshare_jffs目录大于原jffs分区大小，同步功能将只同步系统相关文件，如证书文件等。<br />
															&nbsp;&nbsp;拔出USB磁盘：<br />
															&nbsp;&nbsp;&nbsp;&nbsp;1. 请勿在已经使用USB磁盘挂载了JFFS的状态下拔掉USB磁盘！<br />
															&nbsp;&nbsp;&nbsp;&nbsp;2. 如果需要，请先在插件内点击卸载按钮，卸载USB型JFFS<br />
															&nbsp;&nbsp;&nbsp;&nbsp;3. 再使用固件自带的功能卸载USB磁盘，最后拔下USB磁盘。<br />
															&nbsp;&nbsp;重启路由器：<br />
															&nbsp;&nbsp;&nbsp;&nbsp;1. 如非必要，请保持路由器长时间开机，如需重启可以在后台管理界面点击重启，或者直接关闭电源后开机<br />
															&nbsp;&nbsp;&nbsp;&nbsp;2. 目前已经修复reboot命令无法重启路由的问题（在386固件下测试）<br />
															&nbsp;&nbsp;重置路由器：<br />
															&nbsp;&nbsp;&nbsp;&nbsp;1. 虽然插件考虑到了重置路由器的情况，但是还是建议你用以下操作<br />
															&nbsp;&nbsp;&nbsp;&nbsp;2. 插件内点击卸载按钮，卸载USB型JFFS，固件内卸载USB设备，拔下USB磁盘<br />
															&nbsp;&nbsp;&nbsp;&nbsp;3. 重置路由器，更新软件中心，安装USB2JFFS插件，重新进行挂载操作<br />	
													</ul>
												</td>
												</tr>
											</table>
										</div>
										<div id="apply_button" class="apply_gen">
											<input class="button_gen sbt0" type="button" onclick="save(1)" value="应用" style="display: none;">
											<input class="button_gen sbt1" type="button" onclick="save(2)" value="卸载" style="display: none;">
											<input class="button_gen sbt2" type="button" onclick="save(3)" value="删除" style="display: none;">
											<input class="button_gen bt2" type="button" onclick="save(5)" value="手动同步" style="display: none;">
											<input class="button_gen bt4" type="button" onclick="save(4)" value="清除日志" style="display: none;">
											<input class="button_gen bt5" type="button" onclick="help()" value="交流反馈" style="display: none;">
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

