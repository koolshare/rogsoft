<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!-- version: 1.8 -->
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="-1" />
    <link rel="shortcut icon" href="/res/icon-reboothelper.png" />
    <link rel="icon" href="/res/icon-reboothelper.png" />
    <title>软件中心 - 重启助手</title>
    <link rel="stylesheet" type="text/css" href="index_style.css" />
    <link rel="stylesheet" type="text/css" href="form_style.css" />
    <link rel="stylesheet" type="text/css" href="css/element.css">
    <link rel="stylesheet" type="text/css" href="res/softcenter.css">
    <script language="JavaScript" type="text/javascript" src="/state.js"></script>
    <script language="JavaScript" type="text/javascript" src="/help.js"></script>
    <script language="JavaScript" type="text/javascript" src="/general.js"></script>
    <script language="JavaScript" type="text/javascript" src="/popup.js"></script>
    <script language="JavaScript" type="text/javascript" src="/validator.js"></script>
    <script type="text/javascript" src="/js/jquery.js"></script>
    <script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
    <script type="text/javascript" src="/res/softcenter.js"></script>
    <style type="text/css">
        .rog_btn {
            border: 1px solid #222;
            background: linear-gradient(to bottom, #003333 0%, #000000 100%); /* W3C */
            font-size: 10pt;
            color: #fff;
            padding: 5px 5px;
            border-radius: 5px 5px 5px 5px;
            width: 14%;
        }

            .rog_btn:hover {
                border: 1px solid #222;
                background: linear-gradient(to bottom, #27c9c9 0%, #279fd9 100%); /* W3C */
                font-size: 10pt;
                color: #fff;
                padding: 5px 5px;
                border-radius: 5px 5px 5px 5px;
                width: 14%;
            }

        .loading_bar {
            width: 250px;
            border: 0px;
        }

            .loading_bar > div {
                margin-left: -10px;
                background-color: white;
                border-radius: 7px;
                padding: 1px;
            }

        .status_bar {
            height: 18px;
            border-radius: 7px;
        }

        #ram_bar {
            background-color: #0096FF;
        }
    </style>
    <script type="text/javascript">
        var dbus = {}

        function saveConfig() {
            delete dbus.reboothelper_version;
            dbus["reboothelper_enable"] = $(':radio[name="reboot_schedule_enable_x"]:checked').val();
            dbus["reboothelper_day"] = $('#txt_day').val();
            dbus["reboothelper_week"] = $(':radio[name="reboot_week"]:checked').val();
            dbus["reboothelper_hour"] = $('#txt_hour').val();
            dbus["reboothelper_minute"] = $('#txt_minute').val();

            if (typeof (dbus["reboothelper_week"]) == 'undefined') {
                dbus["reboothelper_week"] = '';
            }


            if (dbus["reboothelper_enable"] == 1) {
                if (dbus["reboothelper_day"].length == 0 && dbus["reboothelper_week"].length == 0 && dbus["reboothelper_hour"].length == 0 && dbus["reboothelper_minute"].length == 0) {
                    alert('至少设置一个条件');
                    return false;
                }
                if (dbus["reboothelper_minute"].length != 0 && dbus["reboothelper_hour"].length == 0) {
                    dbus["reboothelper_hour"] = '*';
                }
                if (dbus["reboothelper_day"].length != 0) {
                    if (dbus["reboothelper_hour"].length == 0 && dbus["reboothelper_minute"].length == 0) {
                        alert('你这个条件会让你的路由在这天不断重启的 , 建议设置一下小时或分钟');
                        return false;
                    }
                }
                if (dbus["reboothelper_week"].length != 0) {
                    if (dbus["reboothelper_hour"].length == 0 && dbus["reboothelper_minute"].length == 0) {
                        alert('你这个条件会让你的路由在这天不断重启的 , 建议设置一下小时或分钟');
                        return false;
                    }
                }
                if (dbus["reboothelper_hour"].length != 0 && dbus["reboothelper_minute"].length == 0) {
                    alert('你这个条件会让你的路由在这个小时不断重启的 , 建议设置一下分钟');
                    return false;
                }
                if (dbus["reboothelper_day"].length != 0 && dbus["reboothelper_week"].length != 0 && dbus["reboothelper_hour"].length != 0 && dbus["reboothelper_minute"].length != 0) {
                    if (!confirm('你这个条件很奇怪 , 确定要这样玩吗.?')) {
                        return false;
                    }
                }
                if (dbus["reboothelper_day"].length != 0 && dbus["reboothelper_week"].length != 0) {
                    if (!confirm('你这个条件很奇怪 , 确定要这样玩吗.?')) {
                        return false;
                    }
                }
            }

            Object.keys(dbus).forEach(function (key) {
                if (dbus[key].length == 0) {
                    dbus[key] = '*';
                } else {
                    dbus[key] = parseInt(dbus[key]);
                }
            });

            showLoading(2);
            refreshpage(2);


            var id = parseInt(Math.random() * 100000000);
            var postData = { "id": id, "method": "reboothelper_config.sh", "params": [1], "fields": dbus };
            $.ajax({
                url: "/_api/",
                cache: false,
                type: "POST",
                dataType: "json",
                data: JSON.stringify(postData)
            });
        }

        function rebootNow() {
            if (confirm('确定马上重启吗.?')) {
                var id = parseInt(Math.random() * 100000000);
                var postData = { "id": id, "method": "reboothelper_status.sh", "params": [1], "fields": "" };
                $.ajax({
                    url: "/_api/",
                    cache: false,
                    type: "POST",
                    dataType: "json",
                    data: JSON.stringify(postData)
                });
            }
        }

        function init() {
            show_menu(menu_hook);
        }

        function CleanReboot_date() {
            $(':radio[name="reboot_week"]:checked').attr("checked", false);
            $(':text').val('');
        }

        function menu_hook(title, tab) {
            tabtitle[tabtitle.length - 1] = new Array("", "Reboot Helper");
            tablink[tablink.length - 1] = new Array("", "Module_reboothelper.asp");
        }

        function get_dbus_data() {
            $.ajax({
                type: "GET",
                url: "/_api/reboothelper",
                dataType: "json",
                async: false,
                success: function (data) {
                    dbus = data.result[0];
                    $('#lbl_Version').html(' v' + dbus['reboothelper_version']);
                    var val_week = dbus['reboothelper_week'];
                    if (val_week == "*") {
                        val_week = 9;
                    }
                    $(':radio[name="reboot_schedule_enable_x"][value=' + dbus['reboothelper_enable'] + ']').prop('checked', true);
                    $(':radio[name="reboot_week"][value=' + val_week + ']').prop('checked', true);
                    if (dbus['reboothelper_day'] != "*") {
                        $('#txt_day').val(dbus['reboothelper_day']);
                    }
                    if (dbus['reboothelper_hour'] != "*") {
                        $('#txt_hour').val(dbus['reboothelper_hour']);
                    }
                    if (dbus['reboothelper_minute'] != "*") {
                        $('#txt_minute').val(dbus['reboothelper_minute']);
                    }
                }
            });
        }

        function dayRange(o, p) {
            if (o.value.length == 0) {
                o.value = "1";
            }
            if (p == 0 || p == 2) {
                if (o.value < 1 || o.value > 31) {
                    alert('请输入一数值介于 1 至 31');
                    o.value = "1";
                    o.focus();
                    o.select();
                    return false;
                }
                return true;
            } else {
                if (o.value > 59) {
                    alert('请输入一数值介于 00 至 59');
                    o.value = "00";
                    o.focus();
                    o.select();
                    return false;
                }
                return true;
            }
            return true;
        }

        $(function () {
            $('#btn_SaveConfig').click(saveConfig);
            $("#btn_Reboot").click(rebootNow);
            $('#btn_CleanReboot_date').click(CleanReboot_date);

            get_dbus_data();
        });
    </script>
</head>
<body onload="init();">
    <div id="TopBanner"></div>
    <div id="Loading" class="popup_bg"></div>
    <div id="LoadingBar" class="popup_bar_bg">
        <table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
            <tr>
                <td height="100">
                    <div id="loading_block3" style="margin: 10px auto; margin-left: 10px; width: 85%; font-size: 12pt;"></div>
                    <div id="loading_block2" style="margin: 10px auto; width: 95%;"></div>
                    <div id="log_content2" style="margin-left: 15px; margin-right: 15px; margin-top: 10px; overflow: hidden">
                        <textarea cols="63" rows="21" wrap="on" readonly="readonly" id="log_content3" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border: 1px solid #000; width: 99%; font-family: 'Courier New', Courier, mono; font-size: 11px; background: #000; color: #FFFFFF;"></textarea>
                    </div>
                    <div id="ok_button" class="apply_gen" style="background: #000; display: none;">
                        <input id="ok_button1" class="button_gen" type="button" onclick="hideKPLoadingBar()" value="确定">
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <iframe name="hidden_frame" id="hidden_frame" width="0" height="0" frameborder="0"></iframe>
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
                                        <div class="formfonttitle">软件中心 - 重启助手<span id="lbl_Version">v0.0</span></div>
                                        <div style="float: right; width: 15px; height: 25px; margin-top: -20px">
                                            <img id="return_btn" alt="" onclick="reload_Soft_Center();" align="right" style="cursor: pointer; position: absolute; margin-left: -30px; margin-top: -25px;" title="返回软件中心" src="/images/backprev.png" onmouseover="this.src='/images/backprevclick.png'" onmouseout="this.src='/images/backprev.png'" />
                                        </div>
                                        <div style="margin: 10px 0 10px 5px;" class="splitLine"></div>
                                        <div class="SimpleNote">
                                            梅林固件重启过程会有一定概率陷入死循环 , 此工具能解决这个Bug，插件来自：<a href="https://koolshare.cn/thread-167906-1-1.html"><i>https://koolshare.cn/thread-167906-1-1.html</i></a>
                                        </div>
                                        <table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
                                            <thead>
                                                <tr>
                                                    <td colspan="2">重启助手 - 设置</td>
                                                </tr>
                                            </thead>
                                            <tr>
                                                <th>条件说明</th>
                                                <td>每个条件是 [并且] 关系 , 而不是 [或者] , 设置了每月几号重启就不用去设置每星期几重启
                                                </td>
                                            </tr>
                                            <tr>
                                                <th style="color: red;">警告</th>
                                                <td>奇奇怪怪的条件会令到路由器不断重启 , 最严重的要恢复出厂设置
                                                </td>
                                            </tr>
                                            <tr id="reboot_schedule_enable_tr">
                                                <th>启动定时重启</th>
                                                <td>
                                                    <input type="radio" value="1" name="reboot_schedule_enable_x">是
                                                    <input type="radio" value="0" name="reboot_schedule_enable_x" checked="">否
                                                </td>
                                            </tr>
                                            <tr id="reboot_schedule_date_day_tr">
                                                <th>自动重启排程日&nbsp;(每月几号)</th>
                                                <td>
                                                    <input type="text" id="txt_day" maxlength="2" class="input_3_table" name="reboot_time_x_day" onkeypress="return validator.isNumber(this,event);" onblur="dayRange(this,0);" autocorrect="off" autocapitalize="off" style="background-color: rgb(89, 110, 116);">
                                                </td>
                                            </tr>
                                            <tr id="reboot_schedule_date_tr" style="">
                                                <th>自动重启排程日&nbsp;(星期几)</th>
                                                <td>
                                                    <input type="radio" name="reboot_week" class="input" value="0" />日
                                                    <input type="radio" name="reboot_week" class="input" value="1" />一
                                                    <input type="radio" name="reboot_week" class="input" value="2" />二
                                                    <input type="radio" name="reboot_week" class="input" value="3" />三
                                                    <input type="radio" name="reboot_week" class="input" value="4" />四
                                                    <input type="radio" name="reboot_week" class="input" value="5" />五
                                                    <input type="radio" name="reboot_week" class="input" value="6" />六
                                                    <button id="btn_CleanReboot_date" class="rog_btn" style="width: 110px; cursor: pointer; float: right; margin-left: 5px;">清除条件</button>
                                                </td>
                                            </tr>
                                            <tr id="reboot_schedule_time_tr" style="">
                                                <th>自动重启排程时间</th>
                                                <td>
                                                    <input type="text" id="txt_hour" maxlength="2" class="input_3_table" name="reboot_time_x_hour" onkeypress="return validator.isNumber(this,event);" onblur="validator.timeRange(this, 0);" autocorrect="off" autocapitalize="off" style="background-color: rgb(89, 110, 116);">
                                                    :
                                                    <input type="text" id="txt_minute" maxlength="2" class="input_3_table" name="reboot_time_x_min" onkeypress="return validator.isNumber(this,event);" onblur="validator.timeRange(this, 1);" autocorrect="off" autocapitalize="off" style="background-color: rgb(89, 110, 116);">

                                                    <button id="btn_Reboot" class="rog_btn" style="width: 110px; cursor: pointer; float: right; margin-left: 5px;">马上重启</button>
                                                    <button id="btn_SaveConfig" class="rog_btn" style="width: 110px; cursor: pointer; float: right;">保存设置</button>
                                                </td>
                                            </tr>
                                        </table>
                                        <div id="warning" style="font-size: 14px; margin: 20px auto;"></div>
                                        <div style="margin: 10px 0 10px 5px;" class="splitLine"></div>
                                        <div class="SimpleNote" style="float: right;">
                                            <ul>
                                                <li><a href="https://koolshare.cn/thread-167906-1-1.html" target="_blank" style="color: yellow;">Make By Lonlykids</a></li>
                                                <li><a href="https://koolshare.cn/forum-96-1.html" target="_blank" style="color: yellow;">@KoolShare</a></li>
                                            </ul>
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

