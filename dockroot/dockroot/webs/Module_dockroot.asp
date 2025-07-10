<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - 轻量版Docker</title>
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
	get_disks();
}

function set_skin(){
	var SKN = '<% nvram_get("sc_skin"); %>';
	if(SKN){
		$("#app").attr("skin", '<% nvram_get("sc_skin"); %>');
	}
}

var db_dockroot = {};
function formatDiskSize(bytes) {
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    let size = bytes;
    let unitIndex = 0;
    
    while (size >= 1024 && unitIndex < units.length - 1) {
        size /= 1024;
        unitIndex++;
    }
    
    return `${size.toFixed(2)} ${units[unitIndex]}`;
}
function get_disks(){
	require(['/require/modules/diskList.js'], function(diskList) {
		usbDevicesList = diskList.list();
		console.log(usbDevicesList)
		for (var i = 0; i < usbDevicesList.length; ++i){
			for (var j = 0; j < usbDevicesList[i].partition.length; ++j){
				var disk_format = usbDevicesList[i].partition[j].format;
				var totalsize = ((usbDevicesList[i].partition[j].size)/1000000).toFixed(2);
				var usedsize = ((usbDevicesList[i].partition[j].used)/1000000).toFixed(2);
				var usedpercent = (usedsize/totalsize*100).toFixed(2) + " %";
				var used = totalsize + " GB" + " (" + usedpercent + ")" ;
				var mount = '/tmp/mnt/' + usbDevicesList[i].partition[j].partName;
				var txt = mount + "|"+ disk_format + "|" + used;
				$("#dockroot_path_selected").append("<option value='" + mount + "'>" + txt + "</option>");
        if (db_dockroot.dockroot_path_selected !== undefined) {
	        E("dockroot_path_selected").value = db_dockroot.dockroot_path_selected;
        }
			}
		}
	});
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/dockroot",
		dataType: "json",
		async: false,
		success: function(data) {
			db_dockroot = data.result[0];
			console.log(db_dockroot)
			conf_to_obj();
			version_show();
		}
	});
}

function get_run_status() {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "dockroot_status.sh", "params":[], "fields": ""};
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
        switch(result.status){
        case 0:
				  E("status").innerHTML = "已安装，版本：" + result.version;
          break;
        case 1:
				  E("status").innerHTML = "文件夹不存在，请重新安装";
          break;
        case 2:
				  E("status").innerHTML = "DockRoot 没下载，请重新安装";
          break;
        case 3:
				  E("status").innerHTML = "DockRoot程序错误，请重新安装";
          break;
        }
			}
			setTimeout("get_run_status();", 10000);
		},
		error: function(response) {
			setTimeout("get_run_status();", 5000);
		}
	});
}

function conf_to_obj() {
	E("dockroot_path_selected").value = db_dockroot["dockroot_path_selected"] || "";
}

function onSubmitCtrl() {
	showSSLoadingBar();
	// collect basic data
	db_dockroot["dockroot_path_selected"] = E("dockroot_path_selected").value;
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "dockroot_config.sh", "params":[], "fields": db_dockroot};
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
	tabtitle[tabtitle.length - 1] = new Array("", "轻量版Docker", "__INHERIT__");
	tablink[tablink.length - 1] = new Array("", "Module_dockroot.asp", "NULL");
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
		url: 'https://rogsoft.dockroot.com/dockroot/config.json.js',
		type: 'GET',
		dataType: 'jsonp',
		success: function(res) {
			if (typeof(res["version"]) != "undefined" && res["version"].length > 0) {
				if (res["version"] == db_dockroot["dockroot_version"]) {
					$("#dockroot_version_show").html("插件版本：" + res["version"]);
				} else if (res["version"] > db_dockroot["dockroot_version"]) {
					$("#dockroot_version_show").html("<font color=\"#66FF66\">有新版本：" + res.version + "</font>");
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
										<div class="formfonttitle">软件中心 - 轻量版Docker</div>
										<div style="float:right; width:15px; height:25px;margin-top:-20px">
											<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
										</div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote">
											<li>DockRoot可以在几乎所有带root的Linux版本下面运行部分Docker镜像。</li>
											<li>建议先安装 USB2JFFS 否则可能空间不足；内存小则建议安装虚拟内存</li>
										</div>
										<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
											<thead>
												<tr>
													<td colspan="2">dockroot - 基础设置</td>
												</tr>
											</thead>
											<tr id="dockroot_status">
												<th>运行状态</th>
												<td><span id="status">获取中...</span>
												</td>
											</tr>
											<tr id="swap_select">
												<th>
													<label>共享磁盘<span style="color: red;"> * </span></label>
												</th>
												<td>
 													<select name="dockroot_path_selected" id="dockroot_path_selected"  class="input_option" ></select>
												</td>										
											</tr>
											<tr id="rule_update_switch">
												<th>帮助</th>
												<td> <a type="button" class="ks_btn" style="cursor:pointer" href="https://www.kspeeder.com/dockroot.html" target="_blank">前往更多帮助</a>
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

