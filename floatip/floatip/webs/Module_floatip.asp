<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - 浮动网关</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/device-map/device-map.css">
<link rel="stylesheet" type="text/css" href="/res/softcenter.css">
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/general.js"></script>
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

input[type=button]:focus {
    outline: none;
}

</style>
<script>
var noChange_status=0;
var _responseLen;
function init() {
	show_menu(menu_hook);
	set_skin();
	get_dbus_data();
	get_run_status();
}

function set_skin(){
	var SKN = '<% nvram_get("sc_skin"); %>';
	if(SKN){
		$("#app").attr("skin", '<% nvram_get("sc_skin"); %>');
	}
}

var db_floatip = {};

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/floatip",
		dataType: "json",
		async: false,
		success: function(data) {
			db_floatip = data.result[0];
			console.log(db_floatip)
			conf_to_obj();
			version_show();
		}
	});
}

function get_run_status() {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "floatip_status.sh", "params":[], "fields": ""};
	$.ajax({
		type: "POST",
		cache: false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
			var result = JSON.parse(response.result) //对字符串进行JSON解析
			if (result){
				console.log(result)
				E("status").innerHTML = result.status == 1 ? "已运行" + " PID:" + result.pid : "未运行";
				E("floatip_router_id").innerHTML = result.router_id;
			}
			setTimeout("get_run_status();", 10000);
		},
		error: function(response) {
			setTimeout("get_run_status();", 5000);
		}
	});
}

function conf_to_obj() {
	E("floatip_enable").checked = db_floatip["floatip_enable"] == "1";
	E("floatip_setip").value = db_floatip["floatip_setip"];
	E("floatip_checkip").value = db_floatip["floatip_checkip"];
}

function onSubmitCtrl() {
	showSSLoadingBar();
	// collect basic data
	db_floatip["floatip_enable"] = E("floatip_enable").checked ? "1" : "0";
	db_floatip["floatip_setip"] = E("floatip_setip").value;
	db_floatip["floatip_checkip"] = E("floatip_checkip").value;
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "floatip_config.sh", "params":[], "fields": db_floatip};
    $("#loading_block3").html("<b>正在提交数据！</b>等待后台运行完毕，请不要刷新本页面！")
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == id) {
				$("#loading_block3").html("<b>提交成功！</b>")
				setTimeout("refreshpage();", 500);
			} else {
				$("#loading_block3").html("<b>提交失败！</b>错误代码：" + response.result)
				return false;
			}
		}
	});
}

function menu_hook() {
	tabtitle[tabtitle.length - 1] = new Array("", "浮动网关", "__INHERIT__");
	tablink[tablink.length - 1] = new Array("", "Module_floatip.asp", "NULL");
}

function openShutManager(oSourceObj, oTargetObj, shutAble, oOpenTip, oShutTip) {
	var sourceObj = typeof oSourceObj == "string" ? document.getElementById(oSourceObj) : oSourceObj;
	var targetObj = typeof oTargetObj == "string" ? document.getElementById(oTargetObj) : oTargetObj;
	var openTip = oOpenTip || "";
	var shutTip = oShutTip || "";
	if (targetObj.style.display != "none") {
		if (shutAble) return;
		targetObj.style.display = "none";
		if (openTip && shutTip) {
			sourceObj.innerHTML = shutTip;
		}
	} else {
		targetObj.style.display = "block";
		if (openTip && shutTip) {
			sourceObj.innerHTML = openTip;
		}
	}
}

function showSSLoadingBar(seconds) {
	if (window.scrollTo)
		window.scrollTo(0, 0);

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

	if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth) {
		winHeight = document.documentElement.clientHeight;
		winWidth = document.documentElement.clientWidth;
	}

	if (winWidth > 1050) {
		winPadding = (winWidth - 1050) / 2;
		winWidth = 1105;
		blockmarginLeft = (winWidth * 0.3) + winPadding - 150;
	} else if (winWidth <= 1050) {
		blockmarginLeft = (winWidth) * 0.3 + document.body.scrollLeft - 160;
	}

	if (winHeight > 660)
		winHeight = 660;

	blockmarginTop = winHeight * 0.5

	E("loadingBarBlock").style.marginTop = blockmarginTop + "px";
	E("loadingBarBlock").style.marginLeft = blockmarginLeft + "px";
	E("loadingBarBlock").style.width = 770 + "px";
	E("LoadingBar").style.width = winW + "px";
	E("LoadingBar").style.height = winH + "px";
	E("LoadingBar").style.visibility = "visible";
}

function version_show() {
	$.ajax({
		url: 'https://rogsoft.ddnsto.com/floatip/config.json.js',
		type: 'GET',
		dataType: 'jsonp',
		success: function(res) {
			if (typeof(res["version"]) != "undefined" && res["version"].length > 0) {
				if (res["version"] == db_floatip["floatip_version"]) {
					$("#floatip_version_show").html("插件版本：" + res["version"]);
				} else if (res["version"] > db_floatip["floatip_version"]) {
					$("#floatip_version_show").html("<font color=\"#66FF66\">有新版本：" + res.version + "</font>");
				}
			}
		}
	});
}

function reload_Soft_Center() {
	location.href = "/Module_Softcenter.asp";
}
</script>
</head>
<body id="app" skin="ASUSWRT" onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<div id="LoadingBar" class="popup_bar_bg">
		<table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
			<tr>
				<td height="100">
					<div id="loading_block3" style="margin:10px auto;width:85%; font-size:12pt;">数据提交中，请稍候...</div>
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
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle" style="border: 0px solid transparent;">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top" style="border-radius: 8px">
										<div>&nbsp;</div>
										<div class="formfonttitle">软件中心 - 浮动网关</div>
										<div style="float:right; width:15px; height:25px;margin-top:-20px">
											<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
										</div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote">
											<li>浮动网关是酷友社小宝开发的，让网络品质提升的插件。</li>
										</div>
										<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
												<tr>
													<td colspan="2">浮动网关 - 基础设置</td>
												</tr>
											</thead>
											<tr id="switch_tr">
												<th>
													<label>开关</label>
												</th>
												<td colspan="2">
													<div claddnsto="switch_field" style="display:table-cell;float: left;">
														<label for="floatip_enable">
															<input id="floatip_enable" class="switch" type="checkbox" style="display: none;">
															<div class="switch_container">
																<div class="switch_bar"></div>
																<div class="switch_circle transition_style">
																	<div></div>
																</div>
															</div>
														</label>
													</div>
													<div id="floatip_version_show" style="padding-top:5px;margin-left:30px;margin-top:0px;float: left;"></div>
												</td>
											</tr>
											<tr id="floatip_status">
												<th>运行状态</th>
												<td><span id="status">获取中...</span>
												</td>
											</tr>
											<tr>
												<th>浮动网关IP<span style="color: red;"> * </span></th>
												<td>
													<input style="width:300px;" type="text" class="input_ss_table" id="floatip_setip" name="floatip_setip" maxlength="100" value=""  autocorrect="off" autocapitalize="off">
												</td>
											</tr>
											<tr>
												<th>旁路由IP<span style="color: red;"> * </span></th>
												<td>
													<input style="width:300px;" type="text" class="input_ss_table" id="floatip_checkip" name="floatip_checkip" maxlength="100" value=""  autocorrect="off" autocapitalize="off">
												</td>
											</tr>
										</table>
										<div id="warning" style="font-size:14px;margin:20px auto;"></div>
										<div class="apply_gen">
											<input class="button_gen" id="cmdBtn" onClick="onSubmitCtrl(this, ' Refresh ')" type="button" value="提交" />
										</div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
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

