<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!-- version: 1.8 -->
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - ROG工具箱</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/> 
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script language="JavaScript" type="text/javascript" src="/state.js"></script>
<script language="JavaScript" type="text/javascript" src="/help.js"></script>
<script language="JavaScript" type="text/javascript" src="/general.js"></script>
<script language="JavaScript" type="text/javascript" src="/popup.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script language="JavaScript" type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<style>
.rog_btn {
	border: 1px solid #222;
	background: linear-gradient(to bottom, #003333  0%, #000000 100%); /* W3C */
	background: linear-gradient(to bottom, #91071f  0%, #700618 100%); /* W3C rogcss */
	font-size:10pt;
	color: #fff;
	padding: 5px 5px;
	border-radius: 5px 5px 5px 5px;
	width:14%;
}
.rog_btn:hover {
	border: 1px solid #222;
	background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%); /* W3C */
	background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%); /* W3C rogcss */
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
#ram_bar {
	background-color:#0096FF;
}
</style>
<script>
var asus = 0;
var cpu_info_old = new Array();
var core_num = '<%cpu_core_num();%>';
var cpu_usage_array = new Array();
var array_size = 46;
var refresh_flag=1;
for (i = 0; i < core_num; i++) {
	cpu_info_old[i] = {
		total: 0,
		usage: 0
	}
	cpu_usage_array[i] = new Array();
	for (j = 0; j < array_size; j++) {
		cpu_usage_array[i][j] = 101;
	}
}
var ram_usage_array = new Array(array_size);
for (i = 0; i < array_size; i++) {
	ram_usage_array[i] = 101;
}
var params_chk = ['rog_ui_flag'];
var params_inp = ['rog_fan_level'];

function init() {
	show_menu(menu_hook);
	var current_url = window.location.href;
	var net_address = current_url.split("/Module")[0];
	var port = net_address.split(":")[2];
	//console.log(port);
	if(port && port != "80" && asus == "1"){
		$("#rog_main").hide();
		$("#msg2").hide();
		$(".SimpleNote").hide();
		$('#warn_msg_1').html('<h1><font color="#FF6600">哦豁！</font></h1><h2>目前<font color="#3399FF">华硕官方固件 / 梅林原版固件</font>安装的插件在https下暂时不可用~<h2>建议先使用http访问路由器后台，以便使用插件。</h2><h2>你也可以关注 <a href="https://koolshare.cn"><font color="#00CC66">https://koolshare.cn</font></a> 论坛，看下插件是否更新了https下能使用的版本！</h2>');
		$("#warn_msg_1").show();
		return false;
	}
	detect_CPU_RAM();
	get_temperature();
	showbootTime();
	showclock();
	show_ui_switch();
}

function show_ui_switch(){
	var BLD = '<% nvram_get("buildno"); %>';
	var EXT = '<% nvram_get("extendno"); %>';
	if(productid == "RT-AC86U"){
		if (EXT.indexOf('koolshare') != -1){
			EXT_1 = EXT.match(/(\S*)_/)[1];
			if(EXT_1 < "81918" && BLD != "386"){
				$("#UI_SWITCH").show();
				$("#FAN_SETTING").hide();
				$("#msg2").show();
				get_dbus_data();
			}else{
				$("#UI_SWITCH").hide();
				$("#FAN_SETTING").hide();
				$("#msg2").hide();
			}
		}else{
			$("#UI_SWITCH").hide();
			$("#FAN_SETTING").hide();
			$("#msg2").hide();
		}
	}else if(productid == "RAX80"){
		$("#UI_SWITCH").hide();
		$("#FAN_SETTING").show();
		$("#msg2").hide();
		get_dbus_data();
	}else{
		$("#UI_SWITCH").hide();
		$("#FAN_SETTING").hide();
		$("#msg2").hide();
	}
}

function get_dbus_data(){
	$.ajax({
		type: "GET",
		url: "/_api/rog_",
		dataType: "json",
		async: false,
		success: function(data) {
			dbus = data.result[0];
			conf2obj();
		}
	});
}

function conf2obj(){
	for (var i = 0; i < params_chk.length; i++) {
		if(dbus[params_chk[i]]){
			E(params_chk[i]).checked = dbus[params_chk[i]] == "1";
		}
	}
	for (var i = 0; i < params_inp.length; i++) {
		if (dbus[params_inp[i]]) {
			$("#" + params_inp[i]).val(dbus[params_inp[i]]);
		}
	}
}

function get_temperature(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "rog_status.sh", "params":[2], "fields": ""};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			E("rog_cpu_temperature").innerHTML = response.result.split("@@")[0];
			E("rog_wl_temperature").innerHTML = response.result.split("@@")[1];
			var pwr = response.result.split("@@")[2];
			if (pwr){
				E("rog_wl_power_tr").style.display = "";
				E("rog_wl_power").innerHTML = pwr;
			}else{
				E("rog_wl_power_tr").style.display = "none";
			}
			setTimeout("get_temperature();", 2000);
		},
		error: function(){
			E("rog_cpu_temperature").innerHTML = "获取运行状态失败！";
			setTimeout("get_temperature();", 5000);
		}
	});
}

function render_RAM(total, free, used) {
	var used_percentage = total_MB = free_MB = used_MB = 0;
	total_MB = Math.round(total / 1024);
	free_MB = Math.round(free / 1024);
	used_MB = Math.round(used / 1024);
	used_percentage = Math.round((used / total) * 100);
	$("#rog_ram_used").html(used_MB + "MB" + "&nbsp;/&nbsp;" + used_percentage + "%");
	$("#rog_ram_free").html(free_MB + "MB");
	$("#ram_bar").css("width", used_percentage + "%");
}
function render_CPU(cpu_info_new) {
	var pt = "";
	var percentage = total_diff = usage_diff = 0;
	var length = Object.keys(cpu_info_new).length;
	for (i = 0; i < length; i++) {
		pt = "";
		total_diff = (cpu_info_old[i].total == 0) ? 0 : (cpu_info_new["cpu" + i].total - cpu_info_old[i].total);
		usage_diff = (cpu_info_old[i].usage == 0) ? 0 : (cpu_info_new["cpu" + i].usage - cpu_info_old[i].usage);
		if (total_diff == 0)
			percentage = 0;
		else
			percentage = parseInt(100 * usage_diff / total_diff);
		$("#cpu" + i + "_bar").css("width", percentage + "%");
		$("#cpu" + i + "_quantification").html(percentage + "%");
		cpu_usage_array[i].push(100 - percentage);
		cpu_usage_array[i].splice(0, 1);
		for (j = 0; j < array_size; j++) {
			pt += j * 6 + "," + cpu_usage_array[i][j] + " ";
		}
		document.getElementById('cpu' + i + '_graph').setAttribute('points', pt);
		cpu_info_old[i].total = cpu_info_new["cpu" + i].total;
		cpu_info_old[i].usage = cpu_info_new["cpu" + i].usage;
	}
}

function detect_CPU_RAM() {
	if (parent.isIE8) {
		require(['/require/modules/makeRequest.js'], function(makeRequest) {
			makeRequest.start('/cpu_ram_status.asp', function(xhr) {
				//render_CPU(cpuInfo);
				render_RAM(memInfo.total, memInfo.free, memInfo.used);
				setTimeout("detect_CPU_RAM();", 2000);
			}, function() {});
		});
	} else {
		$.ajax({
			url: '/cpu_ram_status.asp',
			dataType: 'script',
			error: detect_CPU_RAM,
			success: function(data) {
				//render_CPU(cpuInfo);
				render_RAM(memInfo.total, memInfo.free, memInfo.used);
				setTimeout("detect_CPU_RAM();", 2000);
			}
		});
	}
}

function flush_ram(){
	E("ram_flush").disabled=true;
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "rog_config.sh", "params": ["1"], "fields": ""};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			E("ram_flush").disabled=false;
			//get_realtime_log();
		}
	});
}

function showbootTime() {
	Days = Math.floor(boottime / (60 * 60 * 24));
	Hours = Math.floor((boottime / 3600) % 24);
	Minutes = Math.floor(boottime % 3600 / 60);
	Seconds = Math.floor(boottime % 60);
	document.getElementById("boot_days").innerHTML = Days;
	document.getElementById("boot_hours").innerHTML = Hours;
	document.getElementById("boot_minutes").innerHTML = Minutes;
	document.getElementById("boot_seconds").innerHTML = Seconds;
	boottime += 1;
	setTimeout("showbootTime()", 1000);
}

function fix_nu(num, length) {
	return ('' + num).length < length ? ((new Array(length + 1)).join('0') + num).slice(-length) : '' + num;
}

Date.prototype.toLocaleString = function() {
	return this.getFullYear() + "年 " + fix_nu((this.getMonth() + 1), 2) + "月" + fix_nu(this.getDate(), 2) + "日 " + fix_nu(this.getHours(), 2) + ":" + fix_nu(this.getMinutes(), 2) + ":" + fix_nu(this.getSeconds(), 2);
};

function showclock() {
    var time = new Date(systime_millsec);//获取当前时间
    E("rog_time").innerHTML = time.toLocaleString();
    var refreshTime=this.setInterval(function () {//每个一秒执行的方法如下
        time = new Date(time.valueOf() + 1000);
        E("rog_time").innerHTML = time.toLocaleString();
    }, 1000);
}

function showROGLoadingBar(action){
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
	LoadingROGProgress(action);
}

function LoadingROGProgress(action){
	E("LoadingBar").style.visibility = "visible";
	$("#loading_block2").html("<font color='#ffcc00'>----------------------------------------------------------------------------------------------------------------------------------");
	if (action == "2"){
		E("loading_block3").innerHTML = "ROG插件日志";
	}else{
		E("loading_block3").innerHTML = "切皮肤中 ...";
	}
}

function hideROGLoadingBar(){
	x = -1;
	E("LoadingBar").style.visibility = "hidden";
	if (refresh_flag == "1"){
		refreshpage();
	}
}

var x = 6;
function count_down_close() {
	if (x == "0") {
		hideROGLoadingBar();
	}
	if (x < 0) {
		E("ok_button1").value = "手动关闭"
		return false;
	}
	E("ok_button1").value = "自动关闭（" + x + "）"
		--x;
	setTimeout("count_down_close();", 1000);
}

function switch_ui(action){
	var dbus = {};
	dbus["rog_ui_flag"] = E("rog_ui_flag").checked ? '1' : '0';
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "rog_config.sh", "params":["2", action], "fields": dbus};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			get_log(1);
		}
	});
}

function apply_fan(action){
	var dbus = {};
	dbus["rog_fan_level"] = E("rog_fan_level").value;
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "rog_config.sh", "params":["3"], "fields": dbus};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json"
	});
}

function get_log(action){
	showROGLoadingBar(action);
	$.ajax({
		url: '/_temp/rog_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content3");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", " ");
				E("ok_button").style.display = "";
				retArea.scrollTop = retArea.scrollHeight;
				if (action == "1"){
					count_down_close();
				}
				return true;
			}
			setTimeout("get_log(" + action + ");", 200);
			retArea.value = response.replace("XU6J03M6", " ");
			retArea.scrollTop = retArea.scrollHeight;
		}
	});
}

function show_log() {
	x = -1;
	refresh_flag=2;
	E("ok_button1").value = "关闭日志";
	get_log(2);
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "ROG tools");
	tablink[tablink.length - 1] = new Array("", "Module_rog.asp");
}

</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<div id="LoadingBar" class="popup_bar_bg">
		<table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
			<tr>
				<td height="100">
					<div id="loading_block3" style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;"></div>
					<div id="loading_block2" style="margin:10px auto;width:95%;"></div>
					<div id="log_content2" style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
						<textarea cols="63" rows="21" wrap="on" readonly="readonly" id="log_content3" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Courier New', Courier, mono; font-size:11px; background:#000; color:#FFFFFF; outline:none;"></textarea>
					</div>
					<div id="ok_button" class="apply_gen" style="background: #000;display: none;">
						<input id="ok_button1" class="button_gen" type="button" onclick="hideROGLoadingBar()" value="确定">
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
											<div class="formfonttitle">软件中心 - ROG 工具箱</div>
											<div style="float:right; width:15px; height:25px;margin-top:-20px">
												<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
											</div>
											<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
											<div class="SimpleNote">
												<li>ROG 工具箱是软件中心的一个辅助工具，用以实现一些简单的功能的工具箱。</li>
											</div>
											<table id="rog_main" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
													<tr>
														<td colspan="2">ROG 工具箱设置</td>
													</tr>
												</thead>
												<tr>
													<th>固件版本</th>
													<td id="rog_ver"></td>
													<script type="text/javascript">
														var MODEL = '<% nvram_get("odmpid"); %>' || '<% nvram_get("productid"); %>';
														var BUILD = '<% nvram_get("buildno"); %>'
														var FWVER = '<% nvram_get("extendno"); %>';
														var RC_SUPPORT = '<% nvram_get("rc_support"); %>';
														if (BUILD.indexOf(".") != -1){
															if(RC_SUPPORT.indexOf("koolsoft") != -1){
																$("#rog_ver").html(MODEL + "&nbsp;&nbsp;" + BUILD + "_" + FWVER + "&nbsp;&nbsp;梅林改版固件");
															}else{
																$("#rog_ver").html(MODEL + "&nbsp;&nbsp;" + BUILD + "_" + FWVER + "&nbsp;&nbsp;梅林原版固件");
															}
														}else{
															if(RC_SUPPORT.indexOf("koolsoft") != -1){
																$("#rog_ver").html(MODEL + "&nbsp;&nbsp;" + BUILD + "_" + FWVER + "&nbsp;&nbsp;官改固件");
															}else{
																$("#rog_ver").html(MODEL + "&nbsp;&nbsp;" + BUILD + "_" + FWVER + "&nbsp;&nbsp;华硕官方固件");
															}
														}
													</script>													
												</tr>
												<tr>
													<th>系统时间</th>
													<td id="rog_time"></td>
												</tr>
												<tr>
													<th>开机时间</a></th>
													<td>
														<span id="boot_days"></span> 天 <span id="boot_hours"></span> 时 <span id="boot_minutes"></span> 分 <span id="boot_seconds"></span> 秒
													</td>
												</tr>
												<tr>
													<th>CPU温度</th>
													<td><span id="rog_cpu_temperature"></span></td>
												</tr>
												<tr>
													<th>网卡温度</th>
													<td><span id="rog_wl_temperature"></span></td>
												</tr>
												<tr id="rog_wl_power_tr" style="display: none;">
													<th>发射功率</th>
													<td><span id="rog_wl_power"></span></td>
												</tr>
												<tr>
													<th>内存使用</th>
													<td>
														<!--<span id="rog_ram_status"></span>-->
														<div>
															<table>
																<tr>
																	<td class="loading_bar" colspan="2" style="border: 0px;">
																		<div>
																			<div id="ram_bar" class="status_bar"></div>
																		</div>
																		<span style="float: left;margin-top: -20px;background:transparent"><font id="rog_ram_used" color='#000000'>484MB</font></span>
																		<span style="float: left;margin-top: -20px;background:transparent;margin-left: 207px;"><font id="rog_ram_free" color='#000000'>555MB</font></span>
																	</td>
																</tr>
															</table>
														</div>
														<div style="margin-top: -29px;margin-left: 280px;">
														<!--<a style="cursor:pointer;" id="ram_flush" class="rog_btn" onclick="flush_ram()" disabled=false >一键释放内存</a>-->
														<button id="ram_flush" onclick="flush_ram();" class="rog_btn" style="width:110px;cursor:pointer;">一键释放内存</button>
														</div>
													</td>
												</tr>
												<tr id="UI_SWITCH" style="display:none;">
													<th>切换皮肤</th>
													<td>
														<input type="checkbox" id="rog_ui_flag" name="rog_ui_flag" >包括下架插件
														<a style="cursor:pointer;margin-left: 10px;" class="rog_btn" onclick="switch_ui(1)" >Rog风格</a>
														<a style="cursor:pointer;" class="rog_btn" onclick="switch_ui(2)" >Asuswrt风格</a>
														<a style="cursor:pointer;" class="rog_btn" onclick="show_log()" >查看日志</a>
													</td>
												</tr>
												<tr id="FAN_SETTING" style="display:none;">
													<th>风扇控制</th>
													<td>
														<span>当前风扇档位：</span>
														<select id="rog_fan_level" name="rog_fan_level" style="width:auto;" class="ssconfig input_option">
															<option value="5" selected>自动策略</option>
															<option value="0">关闭</option>
															<option value="1">1档</option>
															<option value="2">2档</option>
															<option value="3">3档</option>
															<option value="4">4档</option>
														</select>
														<a style="cursor:pointer;margin-left: 10px;" class="rog_btn" onclick="apply_fan()" >应用风扇档位</a>
													</td>
												</tr>
												<!--<tr>
													<th>性能测试</th>
													<td><span id="rog_benchmark">上次得分：9170.86</span><a style="margin-left: 20px;" style="cursor:pointer;" class="rog_btn" onclick="open_user_rule()" >开始测试</a></td>
												</tr>-->
											</table>
											<div id="warning" style="font-size:14px;margin:20px auto;"></div>
											<!--<div class="apply_gen">
												<input class="button_gen" id="cmdBtn" onClick="save();" type="button" value="提交" />
											</div>-->
											<div id="warn_msg_1" style="display: none;text-align:center; line-height: 4em;"><i></i></div>
											<div style="margin:10px 0 10px 5px;" class="splitLine"></div>
											<div class="SimpleNote">
												<li id="msg1">本插件支持温度显示等一些简单功能，用以弥补官改固件没有温度显示的遗憾。</li>
												<li id="msg2" style="display:none;">RT-AC86U固件支持【软件中心】和【插件】在Rog风格和Asuswrt风格皮肤之间的切换。</li>
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

