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
<title>tmux</title>
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
#app[skin=ROG] #tablet_1, #app[skin=ROG] #tablet_2 { border:1px solid #91071f; }
#app[skin=TUF] #tablet_1, #app[skin=TUF] #tablet_2 { border:1px solid #92650F; }
#app[skin=TS] #tablet_1, #app[skin=TS] #tablet_2 { border:1px solid #2ed9c3; }
.input_option{
	vertical-align:middle;
	font-size:12px;
}
input[type=button]:focus {
	outline: none;
}
</style>
<script>
function init() {
	show_menu(menu_hook);
	set_skin();
	toggle_func();
	get_status();
}
function set_skin(){
	var SKN = '<% nvram_get("sc_skin"); %>';
	if(SKN){
		$("#app").attr("skin", '<% nvram_get("sc_skin"); %>');
	}
}

function select_tablet(w){
	for (var i = 1; i <= 2; i++) {
		$('.show-btn' + i).removeClass('active');
		$('#tablet_' + i).hide();
	}
	$('.show-btn' + w).addClass('active');
	$('#tablet_' + w).show();
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
}

function get_status() {
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "tmux_status.sh", "params": [1], "fields": {} };
	$.ajax({
		type: "POST",
		cache: false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			if (response.result == id){
				get_log();
			}else{
				alert("状态请求错误！");
				return false;
			}
		},
		error: function(XmlHttpRequest, textStatus, errorThrown){
			console.log(XmlHttpRequest.responseText);
			alert("状态请求错误！");
		}
	});
}

function get_log(){
	$.ajax({
		url: '/_temp/tmux_log.txt',
		type: 'GET',
		cache:false,
		dataType: 'text',
		success: function(response) {
			var retArea = E("log_content_text");
			if (response.search("XU6J03M6") != -1) {
				retArea.value = response.replace("XU6J03M6", " ");
				return false;
			}else{
				setTimeout("get_log();", 600);
			}
			retArea.value = response.replace("XU6J03M6", " ");
			retArea.scrollTop = retArea.scrollHeight;
		}
	});
}

function menu_hook() {
	tabtitle[tabtitle.length - 1] = new Array("", "tmux");
	tablink[tablink.length - 1] = new Array("", "Module_tmux.asp");
}

function reload_Soft_Center(){
	location.href = "/Module_Softcenter.asp";
}

</script>
</head>
<body id="app" skin="ASUSWRT" onload="init();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="POST" name="form" action="/applydb.cgi?p=swap_" target="hidden_frame">
<input type="hidden" name="current_page" value="Module_tmux.asp"/>
<input type="hidden" name="next_page" value="Module_tmux.asp"/>
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
										<div style="float:left;" class="formfonttitle" style="padding-top: 12px">tmux<lable id="tmux_version"></lable></div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div style="margin-left:5px;" id="head_illustrate">
											<li>tmux是一个终端复用器,它可以启动一系列终端会话。。</li>
										</div>

										<div id="tablet_show">
											<table style="margin:10px 0px 0px 0px;border-collapse:collapse" width="100%" height="37px">
												<tr>
													<td cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#222">
														<input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="状态"/>
														<input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="帮助"/>
													</td>
													</tr>
											</table>
										</div>
										<div id="tablet_1">
											<div id="log_content" style="margin:-1px 0px 0px 0px;;display:block;overflow:hidden;">
												<textarea cols="63" rows="16" wrap="on" readonly="readonly" id="log_content_text" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
											</div>
										</div>
										<div id="tablet_2" style="display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
												<td>
													<ul>
														<h4><i>插件说明</i></h4>
														&nbsp;&nbsp;&nbsp;&nbsp;1. 本插件依赖Entware环境，建议使用软件中心Entware插件进行Entware环境配置。<br />
													</ul>
												</td>
												</tr>
											</table>
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

