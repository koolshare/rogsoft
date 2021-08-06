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
<title>openssh-sftp-server</title>
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
<script type="text/javascript" language="JavaScript" src="/client_function.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<style>
	.show-btn1, .show-btn2 {
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
		border: 1px solid #91071f; /* W3C rogcss */
		background: none; /* W3C rogcss */
	}
	.show-btn1:hover, .show-btn2:hover, .active {
		border: 1px solid #2f3a3e;
		background: #2f3a3e;
		border: 1px solid #91071f; /* W3C rogcss */
		background: #91071f; /* W3C rogcss */
	}
	#log_content{
		width:748px;
		outline: 1px solid #222;
		outline: 1px solid #91071f; /* W3C rogcss */
	}
	#log_content_text{
		width:97%;
		padding-left:4px;
		padding-right:37px;
		font-family:'Lucida Console';
		font-size:10px;
		line-height:1.5;
		color:#FFFFFF;
		outline:none;
		overflow-x:hidden;
		border:0px solid #222;
		background:#475A5F;
		background:transparent; /* W3C rogcss */
	}
	#tablet_1, #tablet_2 { border:1px solid #91071f; } /* W3C rogcss */
	input[type=button]:focus {
		outline: none;
	}
</style>
<script>
function init() {
	show_menu(menu_hook);
	toggle_func();
	get_status();
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
	var postData = {"id": id, "method": "sftpserver_status.sh", "params": [1], "fields": {} };
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
		url: '/_temp/sftpserver_log.txt',
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
	tabtitle[tabtitle.length - 1] = new Array("", "sftpserver");
	tablink[tablink.length - 1] = new Array("", "Module_sftpserver.asp");
}

function reload_Soft_Center(){
	location.href = "/Module_Softcenter.asp";
}

</script>
</head>
<body onload="init();">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>
<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
<form method="POST" name="form" action="/applydb.cgi?p=swap_" target="hidden_frame">
<input type="hidden" name="current_page" value="Module_sftpserver.asp"/>
<input type="hidden" name="next_page" value="Module_sftpserver.asp"/>
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
										<div style="float:left;" class="formfonttitle" style="padding-top: 12px">Sftp-Server<lable id="sftpserver_version"></lable></div>
										<div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div style="margin-left:5px;" id="head_illustrate">
											<li>Sftp-Server插件可以轻松帮你安装openssh-sftp-server。</li>
											<li>只需要安装上本插件，不需要进行任何其它操作，你就能使用sftp协议访问路由器了！</li>
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
														&nbsp;&nbsp;&nbsp;&nbsp;1. 本插件依赖Entware环境，建议使用软件中心Entware插件进行环境配置。<br />
														&nbsp;&nbsp;&nbsp;&nbsp;2. 安装此插件即代表安装openssh-sftp-server，卸载插件同理。<br />
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

