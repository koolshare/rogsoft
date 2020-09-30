<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - frps</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/> 
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="css/element.css">
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
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
}
.frpc_btn:hover {
    border: 1px solid #222;
    background: linear-gradient(to bottom, #27c9c9  0%, #279fd9 100%); /* W3C */
    font-size:10pt;
    color: #fff;
    padding: 5px 5px;
    border-radius: 5px 5px 5px 5px;
    width:16%;
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
<script type="text/javascript" src="/dbconf?p=frps&v=<% uptime(); %>"></script>
<script type="text/javascript" src="/res/frps-menu.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script>
var $j = jQuery.noConflict();
var $G = function(id) {
    return document.getElementById(id);
};

// 数据和字段定义
var db_frps = {};
var params_input = ["frps_enable", "frps_common_dashboard_port", "frps_common_dashboard_user", "frps_common_dashboard_pwd", "frps_common_bind_port", "frps_common_privilege_token", "frps_common_vhost_http_port", "frps_common_vhost_https_port", "frps_common_cron_time", "frps_common_max_pool_count", "frps_common_log_file", "frps_common_log_level", "frps_common_log_max_days", "frps_common_tcp_mux", "frps_common_cron_hour_min"]
var params_check = []
var params_base64 = []

function initial(){
    show_menu(menu_hook);
    get_dbus_data();
    get_status();
    conf2obj();
    version_show();
    buildswitch();
    toggle_switch();
}

// 读取db_frps配置
function get_dbus_data() {
	$j.ajax({
		type: "GET",
		url: "/_api/frps",
		dataType: "json",
		async: false,
		success: function(data) {
            db_frps = data.result[0];
			console.log(db_frps);
		}
	});
}

function get_status() {
    $j.ajax({
        url: 'apply.cgi?current_page=Module_frps.asp&next_page=Module_frps.asp&group_id=&modified=0&action_mode=+Refresh+&action_script=&action_wait=&first_time=&preferred_lang=CN&SystemCmd=frps_status.sh',
        dataType: 'html',
        error: function(xhr) {
            alert("error");
        },
        success: function(response) {
            //alert("success");
            setTimeout("check_FRPS_status();", 1000);
        }
    });
}
var noChange_status=0;
var _responseLen;
function check_FRPS_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "frps_status.sh", "params":[1], "fields": ""};
	$j.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
            var _cmdBtn = document.getElementById("cmdBtn");
            document.getElementById("status").innerHTML = response.result;
            if(response.result.search("进程运行正常") != -1){
                return true;
            }

            if(_responseLen == response.result.length){
                noChange_status++;
            }else{
                noChange_status = 0;
            }
            if(noChange_status > 100){
                noChange_status = 0;
                //refreshpage();
            }else{
                setTimeout("check_FRPS_status();", 1000);
            }
            _responseLen = response.result.length;
		},
		error: function(xhr){
            console.log(xhr)
            setTimeout("check_FRPS_status();", 3000);
		}
	});
    // $j.ajax({
    //     url: '/res/frps_check.html',
    //     dataType: 'html',
        
    //     error: function(xhr){
    //         setTimeout("check_FRPS_status();", 1000);
    //     },
    //     success: function(response){
    //         var _cmdBtn = document.getElementById("cmdBtn");
    //         if(response.search("XU6J03M6") != -1){
    //             frps_status = response.replace("XU6J03M6", " ");
    //             //alert(frpc_status);
    //             document.getElementById("status").innerHTML = frps_status;
    //             return true;
    //         }

    //         if(_responseLen == response.length){
    //             noChange_status++;
    //         }else{
    //             noChange_status = 0;
    //         }
    //         if(noChange_status > 100){
    //             noChange_status = 0;
    //             //refreshpage();
    //         }else{
    //             setTimeout("check_FRPS_status();", 400);
    //         }
    //         _responseLen = response.length;
    //     }
    // });
}
function toggle_switch(){ //根据frps_enable的值，打开或者关闭开关
    var rrt = document.getElementById("switch");
    if (document.form.frps_enable.value != "1") {
        rrt.checked = false;
    } else {
        rrt.checked = true;
    }
}

function buildswitch(){ //生成开关的功能，checked为开启，此时传递frps_enable=1
    $j("#switch").click(
    function(){
        if(document.getElementById('switch').checked){
            document.form.frps_enable.value = 1;
            
        }else{
            document.form.frps_enable.value = 0;
        }
    });
}

function conf2obj(){ //表单填写函数，将dbus数据填入到对应的表单中
    for (var field in db_frps) {
        $j('#'+field).val(db_frps[field]);
    }
    //input
	for (var i = 0; i < params_input.length; i++) {
		if(db_frps[params_input[i]]){
			E(params_input[i]).value = db_frps[params_input[i]];
		}
	}
	// checkbox
	for (var i = 0; i < params_check.length; i++) {
		if(db_frps[params_check[i]]){
			E(params_check[i]).checked = db_frps[params_check[i]] == 1 ? true : false
		}
	}
	//base64
	for (var i = 0; i < params_base64.length; i++) {
		if(db_frps[params_base64[i]]){
			E(params_base64[i]).value = Base64.decode(db_frps[params_base64[i]]);
		}
	}
}

function validForm(){
    return true;
}

function pass_checked(obj){
	switchType(obj, document.form.show_pass.checked, true);
}

function onSubmitCtrl(o, s) { //提交操作，提交时运行config-frps.sh，显示5秒的载入画面
    var _form = document.form;
    if(trim(_form.frps_common_dashboard_port.value)=="" || trim(_form.frps_common_dashboard_user.value)=="" || trim(_form.frps_common_dashboard_pwd.value)=="" || trim(_form.frps_common_bind_port.value)=="" || trim(_form.frps_common_privilege_token.value)=="" || trim(_form.frps_common_vhost_http_port.value)=="" || trim(_form.frps_common_vhost_https_port.value)=="" || trim(_form.frps_common_max_pool_count.value)=="" || trim(_form.frps_common_cron_time.value)==""){
        alert("提交的表单不能为空!");
        return false;
    }

    //新版保存
    //input
	for (var i = 0; i < params_input.length; i++) {
		if (E(params_input[i]).value) {
			db_frps[params_input[i]] = E(params_input[i]).value;
		}else{
			db_frps[params_input[i]] = "";
		}
	}
	// checkbox
	for (var i = 0; i < params_check.length; i++) {
		db_frps[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
	}
	//base64
	for (var i = 0; i < params_base64.length; i++) {
		if (!E(params_base64[i]).value) {
			db_frps[params_base64[i]] = "";
		} else {
			if (E(params_base64[i]).value.indexOf("=") != -1) {
				db_frps[params_base64[i]] = Base64.encode(E(params_base64[i]).value);
			} else {
				db_frps[params_base64[i]] = "";
			}
		}
    }
    
    var uid = parseInt(Math.random() * 100000000);
	var postData = {"id": uid, "method": "config-frps.sh", "params": [], "fields": db_frps };
	$j.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData),
		success: function(response) {
			if (response.result == uid){
                console.log(response);
				showLoading(5);
			}
		}
	});


    document.form.action_mode.value = s;
    document.form.SystemCmd.value = "config-frps.sh";
    document.form.submit();
    showLoading(5);
}

function done_validating(action) { //提交操作5秒后刷洗网页
    refreshpage(5);
}
function reload_Soft_Center(){ //返回软件中心按钮
    location.href = "/Module_Softcenter.asp";
}
function menu_hook(title, tab) {
    var enable_ss = "<% nvram_get("enable_ss"); %>";
    var enable_soft = "<% nvram_get("enable_soft"); %>";
    if(enable_ss == "1" && enable_soft == "1"){
        tabtitle[tabtitle.length -2] = new Array("", "Frps 内网穿透");
        tablink[tablink.length -2] = new Array("", "Module_frps.asp");
    }else{
        tabtitle[tabtitle.length -1] = new Array("", "Frps 内网穿透");
        tablink[tablink.length -1] = new Array("", "Module_frps.asp");
    }
}
function version_show(){
    $j.ajax({
        url: 'https://koolshare.ngrok.wang/frps/config.json.js',
        type: 'GET',
        dataType: 'jsonp',
        success: function(res) {
            if(typeof(res["version"]) != "undefined" && res["version"].length > 0) {
                if(res["version"] == db_frps["frps_version"]){
                    $j("#frps_version_show").html("<i>插件版本：" + res["version"]);
                   }else if(res["version"] > db_frps["frps_version"]) {
                    $j("#frps_version_show").html("<font color=\"#66FF66\">有新版本：</font>" + res.version);
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
<form method="POST" name="form" action="/applydb.cgi?p=frps" target="hidden_frame"> 
<input type="hidden" name="current_page" value="Module_frps.asp"/>
<input type="hidden" name="next_page" value="Main_frps.asp"/>
<input type="hidden" name="group_id" value=""/>
<input type="hidden" name="modified" value="0"/>
<input type="hidden" name="action_mode" value=""/>
<input type="hidden" name="action_script" value=""/>
<input type="hidden" name="action_wait" value="5"/>
<input type="hidden" name="first_time" value=""/>
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="config-frps.sh"/>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
<input type="hidden" id="frps_enable" name="frps_enable" value='<% dbus_get_def("frps_enable", "0"); %>'/>

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
                                    <div style="float:left;" class="formfonttitle">软件中心 - Frps内网穿透</div>
                                    <div style="float:right; width:15px; height:25px;margin-top:10px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
                                    <div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/res/icon-frps.png"/></div>
                                    <div class="formfontdesc" id="cmdDesc"><i>* 为了Frps稳定运行，请开启虚拟内存功能！！！</i>&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://koolshare.cn/thread-65379-1-1.html"  target="_blank"><i>服务器搭建教程</i></a></div>
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                        <tr id="switch_tr">
                                            <th>
                                                <label><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(0)">开启Frps</a></label>
                                            </th>
                                            <td colspan="2">
                                                <div class="switch_field" style="display:table-cell;float: left;">
                                                    <label for="switch">
                                                        <input id="switch" class="switch" type="checkbox" style="display: none;">
                                                        <div class="switch_container" >
                                                            <div class="switch_bar"></div>
                                                            <div class="switch_circle transition_style">
                                                                <div></div>
                                                            </div>
                                                        </div>
                                                    </label>
                                                </div>
                                                <span style="margin-left: 300px;"><a href="https://raw.githubusercontent.com/ppyTeam/armsoft/master/frps/Changelog.txt" target="_blank"><em><u>[ 更新日志 ]</u></em></a></span>
                                            </td>
                                        </tr>
                                    </table>
                                    <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" style="margin-top:8px;">
                                        <thead>
                                              <tr>
                                                <td colspan="2">Frps 相关设置</td>
                                              </tr>
                                          </thead>
                                        <th style="width:25%;">版本信息</th>
                                        <td>
                                            <div id="frps_version_show" style="padding-top:5px;margin-left:0px;margin-top:0px;float: left;"><i>插件版本：<% dbus_get_def("frps_version", "未知"); %></i></div>
                                            <div id="frps_status" style="padding-top:5px;margin-left:50px;margin-top:0px;float: left;"><i><span id="status">获取中...</span></i></div>
                                        </td>
                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(1)">Dashboard port</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" value="" id="frps_common_dashboard_port" name="frps_common_dashboard_port" maxlength="5" value="" placeholder=""/>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(11)">Dashboard User</a></th>
                                            <td>
                                        <input type="text" class="input_ss_table" id="frps_common_dashboard_user" name="frps_common_dashboard_user" maxlength="50" value="" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(3)">Dashboard Pass</a></th>
                                            <td>
                                                <input type="password" name="frps_common_dashboard_pwd" id="frps_common_dashboard_pwd" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="256" value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);"/>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(2)">Bind port</a></th>
                                            <td>
                                        <input type="text" class="input_ss_table" id="frps_common_bind_port" name="frps_common_bind_port" maxlength="5" value="" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(3)">Privilege Token</a></th>
                                            <td>
                                                <input type="password" name="frps_common_privilege_token" id="frps_common_privilege_token" class="input_ss_table" autocomplete="new-password" autocorrect="off" autocapitalize="off" maxlength="256" value="" onBlur="switchType(this, false);" onFocus="switchType(this, true);"/>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(4)">vhost http port</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" id="frps_common_vhost_http_port" name="frps_common_vhost_http_port" maxlength="6" value="" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(5)">vhost https port</a></th>
                                            <td>
                                                <input type="text" class="input_ss_table" id="frps_common_vhost_https_port" name="frps_common_vhost_https_port" maxlength="6" value="" />
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(13)">TCP 多路复用</a></th>
                                            <td>
                                                <select id="frps_common_tcp_mux" name="frps_common_tcp_mux" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="true">开启</option>
                                                    <option value="false">关闭</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(6)">日志记录</a></th>
                                            <td>
                                                <select id="frps_common_log_file" name="frps_common_log_file" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="/tmp/frps.log">开启</option>
                                                    <option value="/dev/null">关闭</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(7)">日志等级</a></th>
                                            <td>
                                                <select id="frps_common_log_level" name="frps_common_log_level" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="info">info</option>
                                                    <option value="warn">warn</option>
                                                    <option value="error">error</option>
                                                    <option value="debug">debug</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(8)">日志记录天数</a></th>
                                            <td>
                                                <select id="frps_common_log_max_days" name="frps_common_log_max_days" style="width:165px;margin:0px 0px 0px 2px;" class="input_option" >
                                                    <option value="1">1</option>
                                                    <option value="2">2</option>
                                                    <option value="3" selected="selected">3</option>
                                                    <option value="4">4</option>
                                                    <option value="5">6</option>
                                                    <option value="6">6</option>
                                                    <option value="7">7</option>
                                                    <option value="30">30</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(9)">max pool count</a></th>
                                            <td>
                                                <select id="frps_common_max_pool_count" name="frps_common_max_pool_count" style="width:60px;margin:3px 2px 0px 2px;" class="input_option">
                                                    <option value="10">10</option>
                                                    <option value="20">20</option>
                                                    <option value="30">30</option>
                                                    <option value="40">40</option>
                                                    <option value="50" selected="selected">50</option>
                                                    <option value="60">60</option>
                                                    <option value="70">70</option>
                                                    <option value="80">80</option>
                                                    <option value="90">90</option>
                                                    <option value="100">100</option>
                                                    <option value="150">150</option>
                                                    <option value="200">200</option>
                                                </select>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th width="20%"><a class="hintstyle" href="javascript:void(0);" onclick="openssHint(10)">定时注册服务</a>(<i>0为关闭</i>)</th>
                                            <td>
                                                每 <input type="text" id="frps_common_cron_time" name="frps_common_cron_time" class="input_3_table" maxlength="2" value="30" placeholder="" />
                                                <select id="frps_common_cron_hour_min" name="frps_common_cron_hour_min" style="width:60px;margin:3px 2px 0px 2px;" class="input_option">
                                                    <option value="min" selected="selected">分钟</option>
                                                    <option value="hour">小时</option>
                                                </select> 重新注册一次服务
                                            </td>
                                        </tr>
                                    </table>
                                    <div class="formfontdesc" id="cmdDesc">
                                        <i>* 注意事项：</i><br>
                                        <i>1. 请使用虚拟内存！请使用虚拟内存！请使用虚拟内存！重要的事说三遍</i><br>
                                        <i>2. 上面所有内容都为必填项，请认真填写，不然无法穿透。</i><br>
                                        <i>3. 每一个文字都可以点击查看相应的帮助信息。</i><br>
                                    </div>
                                    <div class="apply_gen">
                                        <span><input class="button_gen_long" id="cmdBtn" onclick="onSubmitCtrl(this, ' Refresh ')" type="button" value="提交"/></span>
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
<!--[if !IE]>-->
    (function($){
        var i = 0;
    })(jQuery);
<!--<![endif]-->
</script>
</html>
