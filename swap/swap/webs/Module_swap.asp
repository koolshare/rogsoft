<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - 虚拟内存</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
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
	background:#C0D1D3 url(/res/proceding.gif);
}
</style>

<script>
var db_swap_ = {};
var dbus = {};
var usbDevicesList;
var disk_format;

function init() {
	show_menu();
	get_disks();
	conf2obj();
}

function get_disks(){
	require(['/require/modules/diskList.js'], function(diskList) {
		usbDevicesList = diskList.list();
		//console.log(usbDevicesList)
		var html = '';
		html += '<thead>'
		html += '<tr>'
		html += '<td colspan="8">磁盘列表</td>'
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
				$("#select_disk").append("<option value='"  + usbDevicesList[i].partition[j].mountPoint + "'>" + usbDevicesList[i].partition[j].partName + "</option>");
				//check for swap exist
				disk_format = usbDevicesList[i].partition[j].format
				if(disk_format.indexOf("ext") != -1){
					dbus["swap_check_partName_" + (parseInt(i)) + "_" + (parseInt(j))] = '/mnt/' + usbDevicesList[i].partition[j].partName || "";
				}
				//write table
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
				html += '<td>' + disk_format + '</td>'
				html += '<td>' + usbDevicesList[i].partition[j].mountPoint + '</td>'
				html += '<td>' + '/tmp/mnt/' + usbDevicesList[i].partition[j].partName + '</td>'
				html += '</tr>'
			}
		}
		$('#disk_table').html(html);
		check_swap();
	});
}

function check_swap() {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "swap_check.sh", "params":[2], "fields": dbus};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			$("#warn").html("<em>" + response.result.split("@@")[0] + "</em>");
			var menused = response.result.split("@@")[1]/1024;
			var memtotal = response.result.split("@@")[2]/1024;
			if (memtotal){
				$("#swap_used_status").html(menused.toFixed(2) + " / " + memtotal.toFixed(2) + "&nbsp;MB");
			}
		}
	});
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/swap_",
		dataType: "json",
		async: false,
		success: function(data) {
			db_swap_ = data.result[0];
		}
	});
}

function menu_hook() {
	tabtitle[tabtitle.length - 1] = new Array("", "虚拟内存");
	tablink[tablink.length - 1] = new Array("", "Module_swap.asp");
}

function conf2obj() {
	$.ajax({
		type: "GET",
		url: "/_api/swap_",
		dataType: "json",
		async: false,
		success: function(data) {
			db_swap_ = data.result[0];
			var p = "swap_";
			var params = ["size"];
			for (var i = 0; i < params.length; i++) {
				if (typeof db_swap_[p + params[i]] !== "undefined") {
					$("#swap_" + params[i]).val(db_swap_[p + params[i]]);
				}
			}
		}
	});
}

function show_log(){
	x = -1;
	get_log(3);
}

function get_log(action){
	showSWAPLoadingBar(action);
	$.ajax({
		url: '/_temp/swap_log.txt',
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

function showSWAPLoadingBar(action){
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
	LoadingSWAPProgress(action);
}

function LoadingSWAPProgress(action){
	E("LoadingBar").style.visibility = "visible";
	$("#loading_block2").html("<font color='#ffcc00'>----------------------------------------------------------------------------------------------------------------------------------");
	if (action == 1){
		E("loading_block3").innerHTML = "创建虚拟内存 ..."
	}else if (action == 2){
		E("loading_block3").innerHTML = "删除虚拟内存 ..."
	}else if (action == 3){
		E("loading_block3").innerHTML = "查看日志"
	}
}

function hideSWAPLoadingBar(){
	x = -1;
	E("LoadingBar").style.visibility = "hidden";
	refreshpage();
}

var x = 6;
function count_down_close() {
	if (x == "0") {
		hideSWAPLoadingBar();
	}
	if (x < 0) {
		E("ok_button1").value = "手动关闭"
		return false;
	}
	E("ok_button1").value = "自动关闭（" + x + "）"
		--x;
	setTimeout("count_down_close();", 1000);
}

function makeswap(action){
	if(action == 1){
		if(disk_format.indexOf("ext") != -1){
			if(!confirm('\n检测到你的磁盘格式为：' + disk_format + '！该磁盘格式符合虚拟内存创建要求！\n\n【虚拟内存】插件将会在你指定的磁盘分区里创建文件名为：swapfile 的虚拟内存文件！\n\n一般来说，此操作不会影响到USB磁盘分区内已有的任何文件。\n但是还是强烈建议你先备份磁盘内的重要文件，再进行虚拟内存的创建！')){
				return false;
			}
		}else{
			if(!confirm('\n检测到你的磁盘格式为：' + disk_format + '！该磁盘格式符合虚拟内存创建要求！\n\n点击确定按钮后，【虚拟内存】插件将自动格式化磁盘分区为ext3格式，然后创建文件名为：swapfile 的虚拟内存文件！\n\n请注意：此过程中，你磁盘上的数据将会全部丢失！！！\n\n强烈建议你先备份磁盘内的重要文件，再进行虚拟内存的创建！')){
				return false;
			}
		}
	}
	var dbus = {};
	dbus["swap_make_part_mount"] = $("#select_disk").val();
	dbus["swap_make_part_partname"] = $("#select_disk option:selected").text();
	dbus["swap_size"] = E("swap_size").value;

	for (var i = 0; i < usbDevicesList.length; ++i){
		for (var j = 0; j < usbDevicesList[i].partition.length; ++j){
			if (usbDevicesList[i].partition[j].mountPoint == $("#select_disk").val()){
				dbus["swap_make_part_format"] = usbDevicesList[i].partition[j].format;
				dbus["swap_make_part_status"] = usbDevicesList[i].partition[j].status;
				dbus["swap_diskorder"] = usbDevicesList[i].usbPath;
				//dbus["swap_make_part_partname"] = usbDevicesList[i].partition[j].partName;
			}
		}
	}
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "swap_make.sh", "params":[action], "fields": dbus};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			get_log(action);
		}
	});
}

function reload_Soft_Center() {
	location.href = "/Module_Softcenter.asp";
}
</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<div id="LoadingBar" class="popup_bar_bg">
	<table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock"  align="center">
		<tr>
			<td height="100">
				<div id="loading_block3" style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;"></div>
				<div id="loading_block2" style="margin:10px auto;width:95%;"><li><font color='#ffcc00'></font></li></div>
				<div id="log_content2" style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
					<textarea cols="63" rows="21" wrap="on" readonly="readonly" id="log_content3" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Courier New', Courier, mono; font-size:11px;background:#000;color:#FFFFFF;"></textarea>
				</div>
				<div id="ok_button" class="apply_gen" style="background: #000;display: none;">
					<input id="ok_button1" class="button_gen" type="button" onclick="hideSWAPLoadingBar()" value="确定">
				</div>
			</td>
		</tr>
	</table>
	</div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
	<form method="POST" name="form" action="/applydb.cgi?p=swap_" target="hidden_frame">
	<input type="hidden" name="current_page" value="Module_swap.asp"/>
	<input type="hidden" name="next_page" value="Module_swap.asp"/>
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
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
										<div style="float:left;" class="formfonttitle">虚拟内存</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div class="formfontdesc" style="padding-top:5px;margin-top:0px;" id="cmdDesc">创建虚拟内存，让路由运行更顺畅</div>
										<div style="padding-top:5px;margin-left:0px;" id="NoteBox" >
											<li style="margin-top:5px;">通过本插件创建虚拟内存，请先只插入一个具有较好读写速度的USB磁盘设备。 </li>
											<li style="margin-top:5px;">如果你通过其它方式创建了虚拟内存，可以不用使用该工具，也可以删除之前的虚拟内存后再使用本工具。</li>
											<li style="margin-top:5px;">如果你的磁盘不是ext2/ext3/ext4格式，使用本工具创建虚拟内存将会自动进行磁盘格式转换，同时磁盘内的所有数据将会被清空！</li>					
										</div>
										<table style="margin:0px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="disk_table">
										</table>
										
										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
											<tr>
												<td colspan="2">状态</td>
											</tr>
											</thead>											
											<tr id="swap_status">
												<th>
													<label>状态</label>
												</th>
												<td>
 													<div id="warn"><i>检测状态中 ...</i></div>
												</td>										
											</tr>
											<tr id="swap_usage_tr">
												<th>虚拟内存使用率</th>
												<td id="swap_used_status"><% sysinfo("memory.swap.used"); %> / <% sysinfo("memory.swap.total"); %>&nbsp;MB</td>
											</tr>
										</table>																	

										<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
											<tr>
												<td colspan="2">创建虚拟内存</td>
											</tr>
											</thead>											
											<tr id="swap_select">
												<th>
													<label>选择磁盘</label>
												</th>
												<td>
 													<select name="select_disk" id="select_disk"  class="input_option" ></select>
												</td>										
											</tr>
											<tr id="swap_size_tr">
												<th width="35%">虚拟内存大小</th>
												<td>
													<select id="swap_size" name="swap_size" style="width:auto;" class="ssconfig input_option">
														<option value="256144">256M</option>
														<option value="524288" selected>512M</option>
														<option value="1048576">1G</option>
													</select>
												</td>
											</tr>
											<tr>
												<th width="35%">操作</th>
												<td>
													<input type="button" id="mkswap" class="button_gen" onclick="makeswap(1);" value="创建虚拟内存">
													<input type="button" id="dlswap" class="button_gen" onclick="makeswap(2);" value="删除虚拟内存">
													<input type="button" id="log1" class="button_gen" onclick="show_log();" value="查看日志">
												</td>
											</tr>
										</table>
										<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
										<div class="KoolshareBottom">论坛技术支持： <a href="http://www.koolshare.cn" target="_blank"> <i><u>koolshare.cn</u></i> </a>
											<br/>Github项目： <a href="https://github.com/koolshare/rogsoft" target="_blank"> <i><u>github.com/koolshare</u></i> </a>
											<br/>Shell & Web by： <a href="mailto:sadoneli@gmail.com"> <i>sadog</i> </a>, <i>Xiaobao</i>
										</div>

									</td>
								</tr>
							</table>
						</td>
						<td width="10" align="center" valign="top"></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</form>
	</td>
	<div id="footer"></div>
</body>
</html>



