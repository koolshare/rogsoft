<!DOCTYPE html
	PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta HTTP-EQUIV="Pragma" CONTENT="no-cache" />
	<meta HTTP-EQUIV="Expires" CONTENT="-1" />
	<link rel="shortcut icon" href="images/favicon.png" />
	<link rel="icon" href="images/favicon.png" />
	<title>KoolShare - 软件中心</title>
	<link rel="stylesheet" type="text/css" href="index_style.css" />
	<link rel="stylesheet" type="text/css" href="form_style.css" />
	<link rel="stylesheet" type="text/css" href="css/element.css">
	<link rel="stylesheet" type="text/css" href="/res/softcenter.css">
	<link rel="stylesheet" type="text/css" href="/res/layer/theme/default/layer.css">
	<script type="text/javascript" src="/js/jquery.js"></script>
	<script type="text/javascript" src="/state.js"></script>
	<script type="text/javascript" src="/general.js"></script>
	<script type="text/javascript" src="/popup.js"></script>
	<script type="text/javascript" src="/res/softcenter.js"></script>
	<script>
		var noChange_status = 0;
		var _responseLen;
		window.Koolshare_Software = {
			EXT: '<% nvram_get("extendno"); %>',
			jffs2_scripts: '<% nvram_get("jffs2_scripts"); %>',
			ro_model: '<% nvram_get("odmpid"); %>' || '<% nvram_get("productid"); %>',
			ro_mac_addr: '<% nvram_get("et0macaddr"); %>',
			net_addr: '<% nvram_get("lan_ipaddr"); %>',
			home_url: '<% nvram_get("sc_url"); %>',
			skin: ('<% nvram_get("sc_skin"); %>').toUpperCase(),
		}
		function init() {
			show_menu(menu_hook);
		}
		function menu_hook(title, tab) {
			tabtitle[tabtitle.length - 1] = new Array("", "软件中心",);
			var fileName = window.location.pathname
			if (fileName[0] == "/") {
				fileName = fileName.slice(1)
			}
			tablink[tablink.length - 1] = new Array("", fileName);
		}
	</script>
	<!--  -->
	<script type="module" crossorigin src="/res/soft-v19/assets/index.19aa9df7.js"></script>
	<link rel="modulepreload" href="/res/soft-v19/assets/vendor.cad358c0.js">
	<link rel="stylesheet" href="/res/soft-v19/assets/style.19154c19.css">
	<!--  -->
</head>

<body onload="init();">
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
				<div id="tabMenu" class="submenuBlock"></div>
				<table width="100%" style="width: calc( 100% - 6px);" border="0" align="left" cellpadding="0"
					cellspacing="0">
					<tr>
						<td align="left" valign="top">
							<div id="app" skin='<%nvram_get("sc_skin");%>'></div>
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
