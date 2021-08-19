<!DOCTYPE html
    PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="-1">
    <link rel="shortcut icon" href="images/favicon.png">
    <link rel="icon" href="images/favicon.png">
    <title>KoolShare - 软件中心</title>
    <link rel="stylesheet" type="text/css" href="index_style.css">
    <link rel="stylesheet" type="text/css" href="form_style.css">
    <link rel="stylesheet" type="text/css" href="/res/softcenter.css">
    <link rel="stylesheet" type="text/css" href="/res/layer/theme/default/layer.css">
    <script language="JavaScript" type="text/javascript" src="/state.js"></script>
    <script language="JavaScript" type="text/javascript" src="/help.js"></script>
    <script language="JavaScript" type="text/javascript" src="/general.js"></script>
    <script language="JavaScript" type="text/javascript" src="/popup.js"></script>
    <script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
    <script language="JavaScript" type="text/javascript" src="/validator.js"></script>
    <script type="text/javascript" src="/js/jquery.js"></script>
    <script type="text/javascript" src="/general.js"></script>
    <script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
    <script type="text/javascript" src="/res/softcenter.js"></script>
    <script type="text/javascript" src="/form.js"></script>
    <!--  -->
    <script type="module" crossorigin src="/res/soft-v19/assets/index.4c1141a5.js"></script>
    <link rel="modulepreload" href="/res/soft-v19/assets/vendor.cad358c0.js">
    <link rel="stylesheet" href="/res/soft-v19/assets/style.e707abbd.css">
    <!--  -->
</head>
<script>
    // 加载默认全局菜单
    function init() {
        show_menu();
    }
    window.Koolshare_Software = {
        EXT: '<% nvram_get("extendno"); %>',
        jffs2_scripts: '<% nvram_get("jffs2_scripts"); %>',
        ro_model: '<% nvram_get("odmpid"); %>' || '<% nvram_get("productid"); %>',
        ro_mac_addr: '<% nvram_get("et0macaddr"); %>',
        net_addr: '<% nvram_get("lan_ipaddr"); %>',
        home_url: '<% nvram_get("sc_url"); %>',
    }
</script>

<body onload="init()">
    <div id="TopBanner"></div>
    <div id="Loading" class="popup_bg"></div>

    <table class="content" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td width="17">&nbsp;</td>
            <td valign="top" width="202">
                <div id="mainMenu"></div>
                <div id="subMenu"></div>
            </td>
            <td valign="top">
                <div id="tabMenu" class="submenuBlock" style="display: none;"></div>
                <table width="100%" style="width: calc( 100% - 6px);" border="0" align="left" cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="left" valign="top">
                            <div id="app"></div>
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
