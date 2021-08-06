<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta HTTP-EQUIV="Pragma" CONTENT="no-cache" />
	<meta HTTP-EQUIV="Expires" CONTENT="-1" />
	<link rel="shortcut icon" href="images/favicon.png" />
	<link rel="icon" href="images/favicon.png" />
	<title>软件中心-Aria2</title>
	<link rel="stylesheet" type="text/css" href="index_style.css" />
	<link rel="stylesheet" type="text/css" href="form_style.css" />
	<link rel="stylesheet" type="text/css" href="usp_style.css" />
	<link rel="stylesheet" type="text/css" href="ParentalControl.css">
	<link rel="stylesheet" type="text/css" href="css/icon.css">
	<link rel="stylesheet" type="text/css" href="css/element.css">
	<link rel="stylesheet" type="text/css" href="res/softcenter.css">
	<script type="text/javascript" src="/state.js"></script>
	<script type="text/javascript" src="/popup.js"></script>
	<script type="text/javascript" src="/help.js"></script>
	<script type="text/javascript" src="/validator.js"></script>
	<script type="text/javascript" src="/js/jquery.js"></script>
	<script type="text/javascript" src="/general.js"></script>
	<script type="text/javascript" src="/disk_functions.js"></script>
	<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
	<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
	<script type="text/javascript" src="/res/softcenter.js"></script>
	<style type="text/css">
		.mask_bg{
			position:absolute;
			margin:auto;
			top:0;
			left:0;
			width:100%;
			height:100%;
			z-index:100;
			/*background-color: #FFF;*/
			background:url(images/popup_bg2.gif);
			background-repeat: repeat;
			filter:progid:DXImageTransform.Microsoft.Alpha(opacity=60);
		 -moz-opacity: 0.6;
			display:none;
			/*visibility:hidden;*/
			overflow:hidden;
		}
		.mask_floder_bg{
			position:absolute;
			margin:auto;
			top:0;
			left:0;
			width:100%;
			height:100%;
			z-index:300;
			/*background-color: #FFF;*/
			background:url(images/popup_bg2.gif);
			background-repeat: repeat;
			filter:progid:DXImageTransform.Microsoft.Alpha(opacity=60);
			-moz-opacity: 0.6;
			display:none;
			/*visibility:hidden;*/
			overflow:hidden;
		}
			.folderClicked{
			color:#569AC7;
			font-size:14px;
			cursor:text;
		}
		.lastfolderClicked{
			color:#FFFFFF;
			cursor:pointer;
		}
		.show-btn1, .show-btn2, .show-btn3, .show-btn4, .show-btn5, .show-btn6 {
			border: 1px solid #222;
			font-size:10pt;
			color: #fff;
			padding: 10px 3.75px;
			border-radius: 5px 5px 0px 0px;
			width:8.45601%;
			background: linear-gradient(to bottom, #919fa4  0%, #67767d 100%);
			background: linear-gradient(to bottom, #91071f  0%, #700618 100%); /* W3C rogcss */
			border: 1px solid #91071f; /* W3C rogcss */
			background: none; /* W3C rogcss */
		}
		.active {
			background: #2f3a3e;
			background: linear-gradient(to bottom, #61b5de  0%, #279fd9 100%);
			background: linear-gradient(to bottom, #cf0a2c  0%, #91071f 100%); /* W3C rogcss */
			border: 1px solid #91071f; /* W3C rogcss */
		}
		input[type=button]:focus {
			outline: none;
		}
		textarea{
			width:99%;
			font-family:'Lucida Console';
			font-size:12px;
			color:#FFFFFF;
			background:#475A5F;
			background:transparent; /* W3C rogcss */
			border:1px solid #91071f; /* W3C rogcss */
		}
		.popup_bar_bg_ks{
			position:fixed;	
			margin: auto;
			top: 0;
			left: 0;
			width:100%;
			height:100%;
			z-index:99;
			filter:alpha(opacity=90);
			background-repeat: repeat;
			visibility:hidden;
			overflow:hidden;
			background-color: #444F53;
			background:rgba(68, 79, 83, 0.9) none repeat scroll 0 0 !important;
			background: url(/images/New_ui/login_bg.png); /* W3C rogcss */
			background-position: 0 0; /* W3C rogcss */
			background-size: cover; /* W3C rogcss */
			opacity: .94; /* W3C rogcss */
		}
		#log_content3, #loading_block2, #log_content1 {
			line-height:1.5
		}
		em {
		    color: #00ffe4;
		    font-style: normal;
		}
	</style>
	<script>
			jQuery.ajax = (function(_ajax) {
				var protocol = location.protocol,
					hostname = location.hostname,
					exRegex = RegExp(protocol + '//' + hostname),
					YQL = 'http' + (/^https/.test(protocol) ? 's' : '') + '://query.yahooapis.com/v1/public/yql?callback=?',
					query = 'select * from html where url="{URL}" and xpath="*"';
				function isExternal(url) {
					return !exRegex.test(url) && /:\/\//.test(url);
				}
				return function(o) {
					var url = o.url;
					if (/get/i.test(o.type) && !/json/i.test(o.dataType) && isExternal(url)) {
						// Manipulate options so that JSONP-x request is made to YQL
						o.url = YQL;
						o.dataType = 'json';
						o.data = {
							q: query.replace(
								'{URL}',
								url + (o.data ?
								 (/\?/.test(url) ? '&' : '?') + jQuery.param(o.data) : '')
							),
							format: 'xml'
						};
						// Since it's a JSONP request
						// complete === success
						if (!o.success && o.complete) {
							o.success = o.complete;
							delete o.complete;
						}
						o.success = (function(_success) {
							return function(data) {
								if (_success) {
									// Fake XHR callback.
									_success.call(this, {
										responseText: (data.results[0] || '')
											// YQL screws with<script>s
											// Get rid of them
											.replace(/<script[^>]+?\/>|<script(.|\s)*?\/script>/gi, '')
									}, 'success');
								}
							};
						})(o.success);
					}
					return _ajax.apply(this, arguments);
				};
			})(jQuery.ajax);
			<% get_AiDisk_status(); %>
			<% disk_pool_mapping_info(); %>
			var aria2_action;
			var _responseLen;
			var noChange = 0;
			var x = 5;
			var PROTOCOL = "cifs";
			var _layer_order = "";
			var FromObject = "0";
			var lastClickedObj = 0;
			var disk_flag = 0;
			var nfsd_enable = '<% nvram_get("nfsd_enable"); %>';
			var nfsd_exportlist_array = '<% nvram_get("nfsd_exportlist"); %>';
			window.onresize = cal_panel_block;
			var db_aria2_ = {};
			var ddnsto_ = {};
			var params_input = ["aria2_cpulimit_value", "aria2_dir", "aria2_max_tries", "aria2_retry_wait", "aria2_referer", "aria2_disk_cache", "aria2_file_allocation", "aria2_rpc_listen_port", "aria2_event_poll", "aria2_rpc_secret", "aria2_max_concurrent_downloads", "aria2_max_connection_per_server", "aria2_min_split_size", "aria2_split", "aria2_max_overall_download_limit", "aria2_max_download_limit", "aria2_max_overall_upload_limit", "aria2_max_upload_limit", "aria2_lowest_speed_limit", "aria2_dht_listen_port", "aria2_bt_max_peers", "aria2_listen_port", "aria2_user_agent", "aria2_peer_id_prefix", "aria2_seed_ratio", "aria2_save_session_interval", "aria2_input_file", "aria2_save_session"]
			var params_check1 = ["aria2_enable", "aria2_cpulimit_enable", "aria2_ddnsto"];
			var params_check2 = ["aria2_disable_ipv6", "aria2_continue", "aria2_enable_mmap", "aria2_enable_rpc", "aria2_rpc_allow_origin_all", "aria2_rpc_listen_all", "aria2_bt_enable_lpd", "aria2_enable_dht", "aria2_bt_require_crypto", "aria2_follow_torrent", "aria2_enable_peer_exchange", "aria2_force_save", "aria2_bt_hash_check_seed", "aria2_bt_seed_unverified", "aria2_bt_save_metadata"];
			var params_base64 = ["aria2_custom", "aria2_bt_tracker"];
			var params_all = ["aria2_cpulimit_value", "aria2_dir", "aria2_max_tries", "aria2_retry_wait", "aria2_referer", "aria2_disk_cache", "aria2_file_allocation", "aria2_rpc_listen_port", "aria2_event_poll", "aria2_rpc_secret", "aria2_max_concurrent_downloads", "aria2_max_connection_per_server", "aria2_min_split_size", "aria2_split", "aria2_max_overall_download_limit", "aria2_max_download_limit", "aria2_max_overall_upload_limit", "aria2_max_upload_limit", "aria2_lowest_speed_limit", "aria2_dht_listen_port", "aria2_bt_max_peers", "aria2_listen_port", "aria2_user_agent", "aria2_peer_id_prefix", "aria2_seed_ratio", "aria2_save_session_interval", "aria2_input_file", "aria2_save_session", "aria2_enable", "aria2_cpulimit_enable", "aria2_ddnsto", "aria2_disable_ipv6", "aria2_continue", "aria2_enable_mmap", "aria2_enable_rpc", "aria2_rpc_allow_origin_all", "aria2_rpc_listen_all", "aria2_bt_enable_lpd", "aria2_enable_dht", "aria2_bt_require_crypto", "aria2_follow_torrent", "aria2_enable_peer_exchange", "aria2_force_save", "aria2_bt_hash_check_seed", "aria2_bt_seed_unverified", "aria2_bt_save_metadata", "aria2_custom", "aria2_bt_tracker"];
			function init() {
				show_menu(menu_hook);
				get_dbus_data();
			}
			function get_dbus_data() {
				$.ajax({
				 type: "GET",
					url: "/_api/aria2,ddnsto",
					dataType: "json",
					async: false,
					success: function(data) {
						db_aria2_ = data.result[0];
						db_ddnsto_ = data.result[1];
						conf2obj();
						toggle_func();
						update_visibility();
						buildswitch();
						initial_dir();
						check_dir_path();
						check_ddnsto();
						generate_ariang_link();
						generate_glutton_link();
						get_run_status();
					}
				});
			}
			function check_ddnsto() {
				if (db_ddnsto_["ddnsto_enable"] == 1) {
					$("#aria2_ddnsto").attr("disabled",false);
					E("ddnsto_status").innerHTML = "启用DDNSTO远程穿透连接(自动设置配置Token及控制台)";
				} else {
					if (db_aria2_["aria2_ddnsto_token"]) {
						$("#aria2_ddnsto").attr("disabled", true);
						E("aria2_ddnsto").checked = true;
						E("ddnsto_status").innerHTML = "DDNSTO插件已关闭，不能通过远程穿透连接访问控制台！";
					}else{
						$("#aria2_ddnsto").attr("disabled", true);
						E("aria2_ddnsto").checked = false;
						E("ddnsto_status").innerHTML = "<font color=#ffffff>如需远程穿透连接Aria2，请正确设置DDNSTO插件并启用！</font>";
					}
				}
				if (E("aria2_ddnsto").checked) {
					//穿透开启，显示穿透token：aria2_ddnsto_token
					E('aria2_rpc_secret').value = db_aria2_["aria2_ddnsto_token"]||"";
					E("aria2_rpc_secret").readOnly = true;
				} else {
					//穿透未开启，显示普通token：aria2_rpc_secret
					E('aria2_rpc_secret').value = db_aria2_["aria2_rpc_secret"]||"";
					E("aria2_rpc_secret").readOnly = false;
				}
			}

			function oncheckclick(obj) {
				if (obj.checked) {
					if (obj.id == "aria2_ddnsto") {
						//穿透开启，显示穿透token：aria2_ddnsto_token
						E("aria2_rpc_secret").readOnly = true;
						E('aria2_rpc_secret').value = db_aria2_["aria2_ddnsto_token"]||"";
					}
				} else {
					if (obj.id == "aria2_ddnsto") {
						//穿透未开启，显示普通token：aria2_rpc_secret
						E("aria2_rpc_secret").readOnly = false;
						E('aria2_rpc_secret').value = db_aria2_["aria2_rpc_secret"]||"";
					}
				}
			}
			function randomWord(randomFlag, min, max) {
				var str = "",
					range = min,
					arr = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
				// 随机产生
				if (randomFlag) {
					range = Math.round(Math.random() * (max - min)) + min;
				}
				for (var i = 0; i < range; i++) {
					pos = Math.round(Math.random() * (arr.length - 1));
					str += arr[pos];
				}
				return str;
			}
			function menu_hook(title, tab) {
				tabtitle[tabtitle.length -1] = new Array("", "aria2");
				tablink[tablink.length -1] = new Array("", "Module_aria2.asp");
			}
			function buildswitch() {
				$("#aria2_enable").click(
					function() {
					if (E('aria2_enable').checked) {
						E('glutton').style.display = "";
						E('aria2_base_table').style.display = "";
						E('aria2_rpc_table').style.display = "none";
						E('aria2_limit_table').style.display = "none";
						E('aria2_bt_table').style.display = "none";
						E('aria2_help').style.display = "none";
						E('aria2_install_table').style.display = "";
						E('cmdBtn1').style.display = "";
						E('tablet_show').style.display = "";
						$('.show-btn1').addClass('active');
						$('.show-btn2').removeClass('active');
						$('.show-btn3').removeClass('active');
						$('.show-btn4').removeClass('active');
						$('.show-btn5').removeClass('active');
					} else {
						E('glutton').style.display = "none";
						E('aria2_base_table').style.display = "none";
						E('aria2_rpc_table').style.display = "none";
						E('aria2_limit_table').style.display = "none";
						E('aria2_bt_table').style.display = "none";
						E('aria2_help').style.display = "none";
						E('cmdBtn1').style.display = "none";
						E('tablet_show').style.display = "none";
						E('aria2_install_table').style.display = "none";
					}
				});
			}
			function update_visibility(r) {
				if (db_aria2_["aria2_enable"] != "1") {
					E("aria2_enable").checked = false;
					E('glutton').style.display = "none";
					E('aria2_base_table').style.display = "none";
					E('aria2_rpc_table').style.display = "none";
					E('aria2_limit_table').style.display = "none";
					E('aria2_bt_table').style.display = "none";
					E('aria2_help').style.display = "none";
					E('cmdBtn1').style.display = "none";
					E('tablet_show').style.display = "none";
					E('aria2_install_table').style.display = "none";
				} else {
					E("aria2_enable").checked = true;
					E('glutton').style.display = "";
					if($('.show-btn1').hasClass("active")){
						E('aria2_base_table').style.display = "";
						E('aria2_rpc_table').style.display = "none";
						E('aria2_limit_table').style.display = "none";
						E('aria2_bt_table').style.display = "none";
						E('aria2_help').style.display = "none";
					}else if($('.show-btn2').hasClass("active")){
						E('aria2_base_table').style.display = "none";
						E('aria2_rpc_table').style.display = "";
						E('aria2_limit_table').style.display = "none";
						E('aria2_bt_table').style.display = "none";
						E('aria2_help').style.display = "none";
					}else if($('.show-btn3').hasClass("active")){
						E('aria2_base_table').style.display = "none";
						E('aria2_rpc_table').style.display = "none";
						E('aria2_limit_table').style.display = "";
						E('aria2_bt_table').style.display = "none";
						E('aria2_help').style.display = "none";
					}else if($('.show-btn4').hasClass("active")){
						E('aria2_base_table').style.display = "none";
						E('aria2_rpc_table').style.display = "none";
						E('aria2_limit_table').style.display = "none";
						E('aria2_bt_table').style.display = "";
						E('aria2_help').style.display = "none";
					}else if($('.show-btn4').hasClass("active")){
						E('aria2_base_table').style.display = "none";
						E('aria2_rpc_table').style.display = "none";
						E('aria2_limit_table').style.display = "none";
						E('aria2_bt_table').style.display = "none";
						E('aria2_help').style.display = "";
					}
					E('aria2_install_table').style.display = "";
					E('cmdBtn1').style.display = "";
				}
				showhide("aria2_dht_listen_port_tr", (E("aria2_enable_dht").checked == true));
				showhide("aria2_cpulimit_value", (E("aria2_cpulimit_enable").checked == true));
				showhide("aria2_rpc_listen_port_tr", (E("aria2_enable_rpc").checked == true));
				showhide("aria2_rpc_allow_origin_all_tr", (E("aria2_enable_rpc").checked == true));
				showhide("aria2_rpc_listen_all_tr", (E("aria2_enable_rpc").checked == true));
				showhide("aria2_disable_ipv6_tr", (E("aria2_enable_rpc").checked == true));
				showhide("aria2_event_poll_tr", (E("aria2_enable_rpc").checked == true));
				showhide("aria2_rpc_secret_tr", (E("aria2_enable_rpc").checked == true));
				showhide("aria2_save_session_tr", (E("aria2_force_save").checked == true));
				showhide("aria2_save_session_interval_tr", (E("aria2_force_save").checked == true));
			}
			function toggle_func() {
				E("aria2_base_table").style.display = "";
				E("aria2_rpc_table").style.display = "none";
				E("aria2_limit_table").style.display = "none";
				E("aria2_bt_table").style.display = "none";
				E("aria2_help").style.display = "none";
				$('.show-btn1').addClass('active');
				$(".show-btn1").click(
					function() {
						$('.show-btn1').addClass('active');
						$('.show-btn2').removeClass('active');
						$('.show-btn3').removeClass('active');
						$('.show-btn4').removeClass('active');
						$('.show-btn5').removeClass('active');
						$('.show-btn6').removeClass('active');
						E("aria2_base_table").style.display = "";
						E("aria2_rpc_table").style.display = "none";
						E("aria2_limit_table").style.display = "none";
						E("aria2_bt_table").style.display = "none";
						E("aria2_log").style.display = "none";
						E("aria2_help").style.display = "none";
					});
				$(".show-btn2").click(
					function() {
						$('.show-btn1').removeClass('active');
						$('.show-btn2').addClass('active');
						$('.show-btn3').removeClass('active');
						$('.show-btn4').removeClass('active');
						$('.show-btn5').removeClass('active');
						$('.show-btn6').removeClass('active');
						E("aria2_base_table").style.display = "none";
						E("aria2_rpc_table").style.display = "";
						E("aria2_limit_table").style.display = "none";
						E("aria2_bt_table").style.display = "none";
						E("aria2_log").style.display = "none";
						E("aria2_help").style.display = "none";
					});
				$(".show-btn3").click(
					function() {
						$('.show-btn1').removeClass('active');
						$('.show-btn2').removeClass('active');
						$('.show-btn3').addClass('active');
						$('.show-btn4').removeClass('active');
						$('.show-btn5').removeClass('active');
						$('.show-btn6').removeClass('active');
						E("aria2_base_table").style.display = "none";
						E("aria2_rpc_table").style.display = "none";
						E("aria2_limit_table").style.display = "";
						E("aria2_bt_table").style.display = "none";
						E("aria2_log").style.display = "none";
						E("aria2_help").style.display = "none";
					});
				$(".show-btn4").click(
					function() {
						$('.show-btn1').removeClass('active');
						$('.show-btn2').removeClass('active');
						$('.show-btn3').removeClass('active');
						$('.show-btn4').addClass('active');
						$('.show-btn5').removeClass('active');
						$('.show-btn6').removeClass('active');
						E("aria2_base_table").style.display = "none";
						E("aria2_rpc_table").style.display = "none";
						E("aria2_limit_table").style.display = "none";
						E("aria2_bt_table").style.display = "";
						E("aria2_log").style.display = "none";
						E("aria2_help").style.display = "none";
					});
				$(".show-btn5").click(
					function() {
						$('.show-btn1').removeClass('active');
						$('.show-btn2').removeClass('active');
						$('.show-btn3').removeClass('active');
						$('.show-btn4').removeClass('active');
						$('.show-btn5').addClass('active');
						$('.show-btn6').removeClass('active');
						E("aria2_base_table").style.display = "none";
						E("aria2_rpc_table").style.display = "none";
						E("aria2_limit_table").style.display = "none";
						E("aria2_bt_table").style.display = "none";
						E("aria2_log").style.display = "none";
						E("aria2_help").style.display = "";
					});
				$(".show-btn6").click(
					function() {
						$('.show-btn1').removeClass('active');
						$('.show-btn2').removeClass('active');
						$('.show-btn3').removeClass('active');
						$('.show-btn4').removeClass('active');
						$('.show-btn5').removeClass('active');
						$('.show-btn6').addClass('active');
						E("aria2_base_table").style.display = "none";
						E("aria2_rpc_table").style.display = "none";
						E("aria2_limit_table").style.display = "none";
						E("aria2_bt_table").style.display = "none";
						E("aria2_log").style.display = "";
						E("aria2_help").style.display = "none";
						get_log();
					});
				$("#log_content2").click(
					function() {
						x = -1;
					});
			}
			function conf2obj() {
				//input
				for (var i = 0; i < params_input.length; i++) {
					if(db_aria2_[params_input[i]]){
						E(params_input[i]).value = db_aria2_[params_input[i]];
					}
				}
				// check for 0 and 1
				for (var i = 0; i < params_check1.length; i++) {
					if(db_aria2_[params_check1[i]]){
						E(params_check1[i]).checked = db_aria2_[params_check1[i]] == 1 ? true : false
					}
				}
				// check for true and false
				for (var i = 0; i < params_check2.length; i++) {
					if(db_aria2_[params_check2[i]]){
						E(params_check2[i]).checked = db_aria2_[params_check2[i]] == "true" ? true : false
					}
				}
				//base64
				for (var i = 0; i < params_base64.length; i++) {
					if(db_aria2_[params_base64[i]]){
						E(params_base64[i]).value = Base64.decode(db_aria2_[params_base64[i]]);
					}
				}
				//set default tracker
				if(!db_aria2_["aria2_bt_tracker"]){
					E("aria2_bt_tracker").value = Base64.decode("dWRwOi8vdHJhY2tlci5jb3BwZXJzdXJmZXIudGs6Njk2OS9hbm5vdW5jZQp1ZHA6Ly9leG9kdXMuZGVzeW5jLmNvbTo2OTY5L2Fubm91bmNlCnVkcDovL3RyYWNrZXIub3BlbnRyYWNrci5vcmc6MTMzNy9hbm5vdW5jZQp1ZHA6Ly90cmFja2VyLmludGVybmV0d2FycmlvcnMubmV0OjEzMzcvYW5ub3VuY2UKdWRwOi8vOS5yYXJiZy50bzoyNzEwL2Fubm91bmNlCnVkcDovL3B1YmxpYy5wb3Bjb3JuLXRyYWNrZXIub3JnOjY5NjkvYW5ub3VuY2UKdWRwOi8vdHJhY2tlci52YW5pdHljb3JlLmNvOjY5NjkvYW5ub3VuY2UKdWRwOi8vZXhwbG9kaWUub3JnOjY5NjkvYW5ub3VuY2UKdWRwOi8vdHJhY2tlci5tZzY0Lm5ldDo2OTY5L2Fubm91bmNlCnVkcDovL21ndHJhY2tlci5vcmc6Njk2OS9hbm5vdW5jZQp1ZHA6Ly9pcHY0LnRyYWNrZXIuaGFycnkubHU6ODAvYW5ub3VuY2UKdWRwOi8vdHJhY2tlci50aW55LXZwcy5jb206Njk2OS9hbm5vdW5jZQp1ZHA6Ly90cmFja2VyLnRvcnJlbnQuZXUub3JnOjQ1MS9hbm5vdW5jZQp1ZHA6Ly90aGV0cmFja2VyLm9yZzo4MC9hbm5vdW5jZQp1ZHA6Ly9idC54eHgtdHJhY2tlci5jb206MjcxMC9hbm5vdW5jZQp1ZHA6Ly90cmFja2VyNC5pdHpteC5jb206MjcxMC9hbm5vdW5jZQp1ZHA6Ly90cmFja2VyMS5pdHpteC5jb206ODA4MC9hbm5vdW5jZQp1ZHA6Ly90cmFja2VyLnBvcnQ0NDMueHl6OjY5NjkvYW5ub3VuY2UKdWRwOi8vdHJhY2tlci5jeXBoZXJwdW5rcy5ydTo2OTY5L2Fubm91bmNlCnVkcDovL3JldHJhY2tlci5sYW50YS1uZXQucnU6MjcxMC9hbm5vdW5jZQo=");
				}
			}
			function save() {
				aria2_action = 0;
				if(alert_custom() == false){
					return false;
				}
				showLoadingBar();
				var dbus = {};
				// 如果ddnsto进程被关闭了，那么关闭穿透开关
				if (db_ddnsto_["ddnsto_enable"] != 1) {
					E("aria2_ddnsto").checked = false;
				}
				// 如果开启穿透，那么aria2_rpc_secret不要写为穿透用的token，而是保留原有token，然后会进入下一步被保存
				if (E("aria2_ddnsto").checked) {
					E('aria2_rpc_secret').value = db_aria2_["aria2_rpc_secret"]||"";
					//dbus["aria2_rpc_secret"] = db_aria2_["aria2_rpc_secret"]||"";
				}
				//input
				for (var i = 0; i < params_input.length; i++) {
					if (E(params_input[i]).value) {
						dbus[params_input[i]] = E(params_input[i]).value;
					}
				}
				if (!E("aria2_rpc_secret").value){
					dbus["aria2_rpc_secret"] = randomWord(true, 16, 32);
				}
				// check for 0 and 1
				for (var i = 0; i < params_check1.length; i++) {
					dbus[params_check1[i]] = E(params_check1[i]).checked ? '1' : '0';
				}
				// check for true and false
				for (var i = 0; i < params_check2.length; i++) {
					dbus[params_check2[i]] = E(params_check2[i]).checked ? 'true' : 'false';
				}
				//base64
				for (var i = 0; i < params_base64.length; i++) {
					if (!E(params_base64[i]).value) {
						dbus[params_base64[i]] = "";
					} else {
						dbus[params_base64[i]] = Base64.encode(E(params_base64[i]).value);
					}
				}

				//console.log(db_aria2_);
				// post data
				var id = parseInt(Math.random() * 100000000);
				var postData = {"id": id, "method": "aria2_config.sh", "params": ["restart"], "fields": dbus };
				$.ajax({
					url: "/_api/",
					cache: false,
				 type: "POST",
					dataType: "json",
					data: JSON.stringify(postData),
					success: function(response) {
						if (response.result == id){
							//refreshpage();
							get_realtime_log();
						}
					}
				});
			}
			function get_log() {
				$.ajax({
					url: '/_temp/aria2_log.txt',
					type: 'GET',
					dataType: 'html',
					async: true,
					cache:false,
					success: function(response) {
						var retArea = E("log_content1");
						if (response.search("XU6J03M6") != -1) {
							retArea.value = response.replace("XU6J03M6", " ");
							return true;
						}
						if (_responseLen == response.length) {
							noChange++;
						} else {
							noChange = 0;
						}
						if (noChange > 5) {
							//retArea.value = "当前日志文件为空";
							return false;
						} else {
							setTimeout("get_log();", 100);
						}
						retArea.value = response;
						_responseLen = response.length;
					},
					error: function(xhr) {
						//setTimeout("get_log();", 1000);
						E("log_content1").value = "获取日志失败！";
					}
				});
			}
			function get_realtime_log() {
				$.ajax({
					url: '/_temp/aria2_log.txt',
					type: 'GET',
					async: true,
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
						if (_responseLen == response.length) {
							noChange++;
						} else {
							noChange = 0;
						}
						if (noChange > 1000) {
							return false;
						} else {
							setTimeout("get_realtime_log();", 100);
						}
						retArea.value = response.replace("XU6J03M6", " ");
						retArea.scrollTop = retArea.scrollHeight;
						_responseLen = response.length;
					},
					error: function() {
						setTimeout("get_realtime_log();", 500);
					}
				});
			}
			function count_down_close() {
				if (x == "0") {
					hideSSLoadingBar();
				}
				if (x < 0) {
					E("ok_button1").value = "手动关闭"
					return false;
				}
				E("ok_button1").value = "自动关闭（" + x + "）"
					--x;
				setTimeout("count_down_close();", 1000);
			}
			function showLoadingBar() {
				if (window.scrollTo)
					window.scrollTo(0, 0);
			
				disableCheckChangedStatus();
			
				htmlbodyforIE = document.getElementsByTagName("html"); //this both for IE&FF, use "html" but not "body" because <!DOCTYPE html PUBLIC.......>
				htmlbodyforIE[0].style.overflow = "hidden"; //hidden the Y-scrollbar for preventing from user scroll it.
			
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
			
				blockmarginTop = winHeight * 0.3 - 140
			
				E("loadingBarBlock").style.marginTop = blockmarginTop + "px";
				E("loadingBarBlock").style.marginLeft = blockmarginLeft + "px";
				E("loadingBarBlock").style.width = 770 + "px";
				E("LoadingBar").style.width = winW + "px";
				E("LoadingBar").style.height = winH + "px";
			
				LoadingProgress();
			}
			function LoadingProgress() {
				E("LoadingBar").style.visibility = "visible";
				if (aria2_action == 0) {
					if(E("aria2_enable").checked ? '1' : '0' == "1"){
						E("loading_block3").innerHTML = "aria2启用中 ..."
					}else{
						E("loading_block3").innerHTML = "aria2关闭中 ..."
					}
				} else if (aria2_action == 1) {
					E("loading_block3").innerHTML = "aria2配置恢复 ..."
				}
				$("#loading_block2").html("<li><font color='#ffcc00'>插件工作有问题？请到我们的论坛 <a href='http://koolshare.cn/forum-98-1.html' target='_blank'><u><em>http://koolshare.cn</em></u></a> 反馈...</li></font>");
			}
			function hideSSLoadingBar() {
				x = -1;
				E("LoadingBar").style.visibility = "hidden";
				refreshpage();
			}
			function load_default_value() {
				if (confirm("你确定要恢复默认配置吗？") != true){
					return false;
				}
				aria2_action = 1;
				showLoadingBar();
				var dbus = {};
				for (var i = 0; i < params_all.length; i++) {
					dbus[params_all[i]] = "";
				}
				dbus["aria2_enable"] = "0";
				var id = parseInt(Math.random() * 100000000);
				var postData = {"id": id, "method": "aria2_config.sh", "params": ["clean"], "fields": dbus };
				$.ajax({
					url: "/_api/",
					cache: false,
				 type: "POST",
					dataType: "json",
					data: JSON.stringify(postData),
					success: function(response) {
						if (response.result == id){
							//refreshpage();
							get_realtime_log();
						}
					}
				});
			}
			function get_run_status(){
				var id = parseInt(Math.random() * 100000000);
				var postData = {"id": id, "method": "aria2_status.sh", "params":[], "fields": ""};
				$.ajax({
				 type: "POST",
					cache:false,
					url: "/_api/",
					data: JSON.stringify(postData),
					dataType: "json",
					success: function(response){
						console.log(response)
						E("status").innerHTML = response.result;
						setTimeout("get_run_status();", 10000);
					},
					error: function(){
						setTimeout("get_run_status();", 5000);
					}
				});
			}
			function alert_custom() {
				var s = E('aria2_custom').value;
				if (s.search(/enable-rpc=/) != -1) {
					alert("不能在此设置 enable-rpc 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/max-tries=/) != -1) {
					alert("不能在此设置 max-tries 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/rpc-allow-origin-all=/) != -1) {
					alert("不能在此设置 enable-rpc 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/rpc-listen-all=/) != -1) {
					alert("不能在此设置 rpc-listen-all 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/rpc-listen-port=/) != -1) {
					alert("不能在此设置 rpc-listen-port 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/event-poll=/) != -1) {
					alert("不能在此设置 event-poll 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/rpc-user=/) != -1) {
					alert("不能在此设置 rpc-user 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/rpc-passwd=/) != -1) {
					alert("不能在此设置 rpc-passwd 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/max-concurrent-downloads=/) != -1) {
					alert("不能在此设置 max-concurrent-downloads 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/continue=/) != -1) {
					alert("不能在此设置 continue 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/max-connection-per-server=/) != -1) {
					alert("不能在此设置 max-connection-per-server 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/min-split-size=/) != -1) {
					alert("不能在此设置 min-split-size 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/split=/) != -1) {
					alert("不能在此设置 split 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/max-overall-download-limit=/) != -1) {
					alert("不能在此设置 max-overall-download-limit 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/max-download-limit=/) != -1) {
					alert("不能在此设置 max-download-limit 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/max-overall-upload-limit=/) != -1) {
					alert("不能在此设置 max-overall-upload-limit 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/max-upload-limit=/) != -1) {
					alert("不能在此设置 max-upload-limit 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/lowest-speed-limit=/) != -1) {
					alert("不能在此设置 lowest-speed-limit 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/lowest-speed-limit=/) != -1) {
					alert("不能在此设置 referer 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/input-file=/) != -1) {
					alert("不能在此设置 input-file 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/save-session=/) != -1) {
					alert("不能在此设置 save-session 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/dir=/) != -1) {
					alert("不能在此设置 dir 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/disk-cache=/) != -1) {
					alert("不能在此设置 disk-cache 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/enable-mmap=/) != -1) {
					alert("不能在此设置 enable-mmap 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/file-allocation=/) != -1) {
					alert("不能在此设置 file-allocation 选项! 请在图形界面设置");
				}
				if (s.search(/bt-enable-lpd=/) != -1) {
					alert("不能在此设置 bt-enable-lpd 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/dir=/) != -1) {
					alert("不能在此设置 dir 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/bt-tracker=/) != -1) {
					alert("不能在此设置 bt-tracker 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/bt-max-peers=/) != -1) {
					alert("不能在此设置 bt-max-peers 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/bt-require-crypto=/) != -1) {
					alert("不能在此设置 bt-require-crypto 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/follow-torrent=/) != -1) {
					alert("不能在此设置 follow-torrent 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/listen-port=/) != -1) {
					alert("不能在此设置 listen-port 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/dir=/) != -1) {
					alert("不能在此设置 dir 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/enable-dht=/) != -1) {
					alert("不能在此设置 enable-dht 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/enable-peer-exchange=/) != -1) {
					alert("不能在此设置 enable-peer-exchange 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/user-agent=/) != -1) {
					alert("不能在此设置 user-agent 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/peer-id-prefix=/) != -1) {
					alert("不能在此设置 peer-id-prefix 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/seed-ratio=/) != -1) {
					alert("不能在此设置 seed-ratio 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/force-save=/) != -1) {
					alert("不能在此设置 force-save 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/bt-hash-check-seed=/) != -1) {
					alert("不能在此设置 bt-hash-check-seed 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/bt-seed-unverified=/) != -1) {
					alert("不能在此设置 bt-seed-unverified 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/bt-save-metadata=/) != -1) {
					alert("不能在此设置 bt-save-metadata 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/save-session-interval=/) != -1) {
					alert("不能在此设置 save-session-interval 选项! 请在图形界面设置");
					return false;
				}
				if (s.search(/disable-ipv6=/) != -1) {
					alert("不能在此设置 save-session-interval 选项! 请在图形界面设置");
					return false;
				}
			}
			function initial_dir() {
				var __layer_order = "0_0";
				var url = "/getfoldertree.asp";
				var type = "General";
				url += "?motion=gettree&layer_order=" + __layer_order + "&t=" + Math.random();
				$.get(url, function(data) {
					initial_dir_status(data);
				});
			}
			function initial_dir_status(data) {
				if (data != "" && data.length != 2) {
					get_layer_items("0");
					eval("var default_dir=" + data);
				} else {
					//E("EditExports").style.display = "none";
					disk_flag = 1;
				}
			}
			function submit_server(x) {
					var server_type = eval('document.serverForm.nfsd_enable ');
					showLoadingBar();
					if (x == 1)
						server_type.value = 0;
					else
						server_type.value = 1;
					document.serverForm.flag.value = "nodetect";
					document.serverForm.submit();
				}
				// get folder
			var dm_dir = new Array();
			var WH_INT = 0,
				Floder_WH_INT = 0,
				General_WH_INT = 0;
			var folderlist = new Array();
			function apply() {
				var rule_num = E('nfsd_exportlist_table').rows.length;
				var item_num = E('nfsd_exportlist_table').rows[0].cells.length;
				var tmp_value = "";
				for (i = 0; i < rule_num; i++) {
					tmp_value += "<"
					for (j = 0; j < item_num - 1; j++) {
						tmp_value += E('nfsd_exportlist_table').rows[i].cells[j].innerHTML;
						if (j != item_num - 2)
							tmp_value += ">";
					}
				}
				if (tmp_value == "<" + "<#IPConnection_VSList_Norule#>" || tmp_value == "<")
					tmp_value = "";
				document.form.nfsd_exportlist.value = tmp_value;
				showLoadingBar();
				FormActions("start_apply.htm", "apply", "restart_nasapps", "5");
				document.form.submit();
			}
			function get_disk_tree() {
				if (disk_flag == 1) {
					alert('没有找到USB设备！');
					return false;
				}
				cal_panel_block();
				$("#folderTree_panel").fadeIn(300);
				get_layer_items("0");
			}
			function get_layer_items(layer_order) {
				$.ajax({
					url: '/gettree.asp?layer_order=' + layer_order,
					dataType: 'script',
					error: function(xhr) {;
					},
					success: function() {
						get_tree_items(treeitems);
					}
				});
			}
			function get_tree_items(treeitems) {
				document.aidiskForm.test_flag.value = 0;
			 this.isLoading = 1;
				var array_temp = new Array();
				var array_temp_split = new Array();
				for (var j = 0; j < treeitems.length; j++) { // To hide folder 'Download2'
					array_temp_split[j] = treeitems[j].split("#");
					if (array_temp_split[j][0].match(/^asusware$/)) {
						continue;
					}
					array_temp.push(treeitems[j]);
				}
			 this.Items = array_temp;
				if (this.Items && this.Items.length >= 0) {
					BuildTree();
				}
			}
			function BuildTree() {
				var ItemText, ItemSub, ItemIcon;
				var vertline, isSubTree;
				var layer;
				var short_ItemText = "";
				var shown_ItemText = "";
				var ItemBarCode = "";
				var TempObject = "";
				for (var i = 0; i < this.Items.length; ++i) {
				 this.Items[i] = this.Items[i].split("#");
					var Item_size = 0;
					Item_size = this.Items[i].length;
					if (Item_size > 3) {
						var temp_array = new Array(3);
						temp_array[2] = this.Items[i][Item_size - 1];
						temp_array[1] = this.Items[i][Item_size - 2];
						temp_array[0] = "";
						for (var j = 0; j < Item_size - 2; ++j) {
							if (j != 0)
								temp_array[0] += "#";
							temp_array[0] += this.Items[i][j];
						}
					 this.Items[i] = temp_array;
					}
					ItemText = (this.Items[i][0]).replace(/^[\s]+/gi, "").replace(/[\s]+$/gi, "");
					ItemBarCode = this.FromObject + "_" + (this.Items[i][1]).replace(/^[\s]+/gi, "").replace(/[\s]+$/gi, "");
					ItemSub = parseInt((this.Items[i][2]).replace(/^[\s]+/gi, "").replace(/[\s]+$/gi, ""));
					layer = get_layer(ItemBarCode.substring(1));
					if (layer == 3) {
						if (ItemText.length > 21)
							short_ItemText = ItemText.substring(0, 30) + "...";
						else
							short_ItemText = ItemText;
					} else
						short_ItemText = ItemText;
					shown_ItemText = showhtmlspace(short_ItemText);
					if (layer == 1)
						ItemIcon = 'disk';
					else if (layer == 2)
						ItemIcon = 'part';
					else
						ItemIcon = 'folders';
					SubClick = ' onclick="GetFolderItem(this, ';
					if (ItemSub<= 0) {
						SubClick += '0);"';
						isSubTree = 'n';
					} else {
						SubClick += '1);"';
						isSubTree = 's';
					}
					if (i == this.Items.length - 1) {
						vertline = '';
						isSubTree += '1';
					} else {
						vertline = ' background="/images/Tree/vert_line.gif"';
						isSubTree += '0';
					}
					if (layer == 2 && isSubTree == 'n1') { // Uee to rebuild folder tree if disk without folder, Jieming add at 2012/08/29
						document.aidiskForm.test_flag.value = 1;
					}
					TempObject += '<table class="tree_table" id="bug_test">';
					TempObject += '<tr>';
					// the line in the front.
					TempObject += '<td class="vert_line">';
					TempObject += '<img id="a' + ItemBarCode + '" onclick=\'E("d' + ItemBarCode + '").onclick();\' class="FdRead" src="/images/Tree/vert_line_' + isSubTree + '0.gif">';
					TempObject += '</td>';
					if (layer == 3) {
						/*a: connect_line b: harddisc+name c:harddisc d:name e: next layer forder*/
						TempObject += '<td>';
						TempObject += '<img id="c' + ItemBarCode + '" onclick=\'E("d' + ItemBarCode + '").onclick();\' src="/images/New_ui/advancesetting/' + ItemIcon + '.png">';
						TempObject += '</td>';
						TempObject += '<td>';
						TempObject += '<span id="d' + ItemBarCode + '"' + SubClick + ' title="' + ItemText + '">' + shown_ItemText + '</span>\n';
						TempObject += '</td>';
					} else if (layer == 2) {
						TempObject += '<td>';
						TempObject += '<table class="tree_table">';
						TempObject += '<tr>';
						TempObject += '<td class="vert_line">';
						TempObject += '<img id="c' + ItemBarCode + '" onclick=\'E("d' + ItemBarCode + '").onclick();\' src="/images/New_ui/advancesetting/' + ItemIcon + '.png">';
						TempObject += '</td>';
						TempObject += '<td class="FdText">';
						TempObject += '<span id="d' + ItemBarCode + '"' + SubClick + ' title="' + ItemText + '">' + shown_ItemText + '</span>';
						TempObject += '</td>';
						TempObject += '<td></td>';
						TempObject += '</tr>';
						TempObject += '</table>';
						TempObject += '</td>';
						TempObject += '</tr>';
						TempObject += '<tr><td></td>';
						TempObject += '<td colspan=2><div id="e' + ItemBarCode + '" ></div></td>';
					} else {
						/*a: connect_line b: harddisc+name c:harddisc d:name e: next layer forder*/
						TempObject += '<td>';
						TempObject += '<table><tr><td>';
						TempObject += '<img id="c' + ItemBarCode + '" onclick=\'E("d' + ItemBarCode + '").onclick();\' src="/images/New_ui/advancesetting/' + ItemIcon + '.png">';
						TempObject += '</td><td>';
						TempObject += '<span id="d' + ItemBarCode + '"' + SubClick + ' title="' + ItemText + '">' + shown_ItemText + '</span>';
						TempObject += '</td></tr></table>';
						TempObject += '</td>';
						TempObject += '</tr>';
						TempObject += '<tr><td></td>';
						TempObject += '<td><div id="e' + ItemBarCode + '" ></div></td>';
					}
					TempObject += '</tr>';
				}
				TempObject += '</table>';
				E("e" + this.FromObject).innerHTML = TempObject;
			}
			function get_layer(barcode) {
				var tmp, layer;
				layer = 0;
				while (barcode.indexOf('_') != -1) {
					barcode = barcode.substring(barcode.indexOf('_'), barcode.length);
				 ++layer;
					barcode = barcode.substring(1);
				}
				return layer;
			}
			function build_array(obj, layer) {
				var path_temp = "/mnt";
				var layer2_path = "";
				var layer3_path = "";
				if (obj.id.length > 6) {
					if (layer == 3) {
						layer3_path = "/" + obj.title;
						while (layer3_path.indexOf("&nbsp;") != -1)
							layer3_path = layer3_path.replace("&nbsp;", " ");
						if (obj.id.length > 8)
							layer2_path = "/" + E(obj.id.substring(0, obj.id.length - 3)).innerHTML;
						else
							layer2_path = "/" + E(obj.id.substring(0, obj.id.length - 2)).innerHTML;
						while (layer2_path.indexOf("&nbsp;") != -1)
							layer2_path = layer2_path.replace("&nbsp;", " ");
					}
				}
				if (obj.id.length > 4 && obj.id.length<= 6) {
					if (layer == 2) {
						layer2_path = "/" + obj.title;
						while (layer2_path.indexOf("&nbsp;") != -1)
							layer2_path = layer2_path.replace("&nbsp;", " ");
					}
				}
				path_temp = path_temp + layer2_path + layer3_path;
				return path_temp;
			}
			function GetFolderItem(selectedObj, haveSubTree) {
				var barcode, layer = 0;
				showClickedObj(selectedObj);
				barcode = selectedObj.id.substring(1);
				layer = get_layer(barcode);
				if (layer == 0)
					alert("Machine: Wrong");
				else if (layer == 1) {
					// chose Disk
					setSelectedDiskOrder(selectedObj.id);
					path_directory = build_array(selectedObj, layer);
					E('createFolderBtn').className = "createFolderBtn";
					E('deleteFolderBtn').className = "deleteFolderBtn";
					E('modifyFolderBtn').className = "modifyFolderBtn";
					E('createFolderBtn').onclick = function() {};
					E('deleteFolderBtn').onclick = function() {};
					E('modifyFolderBtn').onclick = function() {};
				} else if (layer == 2) {
					// chose Partition
					setSelectedPoolOrder(selectedObj.id);
					path_directory = build_array(selectedObj, layer);
					E('createFolderBtn').className = "createFolderBtn_add";
					E('deleteFolderBtn').className = "deleteFolderBtn";
					E('modifyFolderBtn').className = "modifyFolderBtn";
					E('createFolderBtn').onclick = function() {
						popupWindow('OverlayMask', '/aidisk/popCreateFolder.asp');
					};
					E('deleteFolderBtn').onclick = function() {};
					E('modifyFolderBtn').onclick = function() {};
					document.aidiskForm.layer_order.disabled = "disabled";
					document.aidiskForm.layer_order.value = barcode;
				} else if (layer == 3) {
					// chose Shared-Folder
					setSelectedFolderOrder(selectedObj.id);
					path_directory = build_array(selectedObj, layer);
					E('createFolderBtn').className = "createFolderBtn";
					E('deleteFolderBtn').className = "deleteFolderBtn_add";
					E('modifyFolderBtn').className = "modifyFolderBtn_add";
					E('createFolderBtn').onclick = function() {};
					E('deleteFolderBtn').onclick = function() {
						popupWindow('OverlayMask', '/aidisk/popDeleteFolder.asp');
					};
					E('modifyFolderBtn').onclick = function() {
						popupWindow('OverlayMask', '/aidisk/popModifyFolder.asp');
					};
					document.aidiskForm.layer_order.disabled = "disabled";
					document.aidiskForm.layer_order.value = barcode;
				}
				if (haveSubTree)
					GetTree(barcode, 1);
			}
			function showClickedObj(clickedObj) {
				if (this.lastClickedObj != 0)
				 this.lastClickedObj.className = "lastfolderClicked"; //this className set in AiDisk_style.css
				clickedObj.className = "folderClicked";
			 this.lastClickedObj = clickedObj;
			}
			function GetTree(layer_order, v) {
				if (layer_order == "0") {
				 this.FromObject = layer_order;
					E('d' + layer_order).innerHTML = '<span class="FdWait">. . . . . . . . . .</span>';
					setTimeout('get_layer_items("' + layer_order + '", "gettree")', 1);
					return;
				}
				if (E('a' + layer_order).className == "FdRead") {
					E('a' + layer_order).className = "FdOpen";
					E('a' + layer_order).src = "/images/Tree/vert_line_s" + v + "1.gif";
				 this.FromObject = layer_order;
					E('e' + layer_order).innerHTML = '<img src="/images/Tree/folder_wait.gif">';
					setTimeout('get_layer_items("' + layer_order + '", "gettree")', 1);
				} else if (E('a' + layer_order).className == "FdOpen") {
					E('a' + layer_order).className = "FdClose";
					E('a' + layer_order).src = "/images/Tree/vert_line_s" + v + "0.gif";
					E('e' + layer_order).style.position = "absolute";
					E('e' + layer_order).style.visibility = "hidden";
				} else if (E('a' + layer_order).className == "FdClose") {
					E('a' + layer_order).className = "FdOpen";
					E('a' + layer_order).src = "/images/Tree/vert_line_s" + v + "1.gif";
					E('e' + layer_order).style.position = "";
					E('e' + layer_order).style.visibility = "";
				} else
					alert("Error when show the folder-tree!");
			}
			function cancel_folderTree() {
			 this.FromObject = "0";
				$("#folderTree_panel").fadeOut(300);
			}
			function confirm_folderTree() {
				E('aria2_dir').value = path_directory;
			 this.FromObject = "0";
				$("#folderTree_panel").fadeOut(300);
			}
			function cal_panel_block() {
				var blockmarginLeft;
				if (window.innerWidth)
					winWidth = window.innerWidth;
				else if ((document.body) && (document.body.clientWidth))
					winWidth = document.body.clientWidth;
				if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth) {
					winWidth = document.documentElement.clientWidth;
				}
				if (winWidth > 1050) {
					winPadding = (winWidth - 1050) / 2;
					winWidth = 1105;
					blockmarginLeft = (winWidth * 0.25) + winPadding;
				} else if (winWidth<= 1050) {
					blockmarginLeft = (winWidth) * 0.25 + document.body.scrollLeft;
				}
				E("folderTree_panel").style.marginLeft = blockmarginLeft + "px";
			}
			function check_dir_path() {
				var dir_array = E('aria2_dir').value.split("/");
				if (dir_array[dir_array.length - 1].length > 21)
					E('aria2_dir').value = "/" + dir_array[1] + "/" + dir_array[2] + "/" + dir_array[dir_array.length - 1].substring(0, 18) + "...";
			}

			function generate_ariang_link() {
				var link_ariang = window.btoa(db_aria2_["aria2_ddnsto_token"])
				if (E("aria2_ddnsto").checked) {
					E("link4.1").href = "http://aria2.me/aria-ng/#!/settings/rpc/set/wss/www.ddnsto.com/443/jsonrpc/" + link_ariang;
				} else {
					E("link4.1").href = "http://aria2.me/aria-ng/#!/settings/rpc/set/http/" + '<% nvram_get("lan_ipaddr"); %>' + "/" + db_aria2_["aria2_rpc_listen_port"] + "/jsonrpc/" + link_ariang;
				}
			}
			
			function generate_glutton_link() {
				if (E("aria2_ddnsto").checked) {
					var link_glutton = window.btoa("https://www.ddnsto.com:443" + "/jsonrpc||" + db_aria2_["aria2_ddnsto_token"])
				} else {
					var link_glutton = window.btoa("http://" + '<% nvram_get("lan_ipaddr"); %>' + ":" + db_aria2_["aria2_rpc_listen_port"] + "/jsonrpc||" + db_aria2_["aria2_rpc_secret"])
				}
				E("link4.2").href = "http://aria2.me/glutton/" + "?s=" + link_glutton;
			}
			function copyUrl2(){ 
				var Url2 = E("link4.2").href; 
				Url2.select();
				document.execCommand("Copy", "false",null);
				alert("已复制好，可贴粘。"); 
			}
	</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<!-- floder tree-->
	<div id="DM_mask" class="mask_bg"></div>
	<div id="folderTree_panel" class="panel_folder">
		<table>
			<tr>
				<td>
					<div class="machineName" style="width:200px;font-family:Microsoft JhengHei;font-size:12pt;font-weight:bolder; margin-top:15px;margin-left:30px;">选择下载目录</div>
				</td>
				<td>
					<div style="width:240px;margin-top:17px;margin-left:125px;">
						<table>
							<tr>
								<td>
									<div id="createFolderBtn" class="createFolderBtn" title="<#AddFolderTitle#>"></div>
								</td>
								<td>
									<div id="deleteFolderBtn" class="deleteFolderBtn" title="<#DelFolderTitle#>"></div>
								</td>
								<td>
									<div id="modifyFolderBtn" class="modifyFolderBtn" title="<#ModFolderTitle#>"></div>
								</td>
							<tr>
						</table>
					</div>
				</td>
				</tr>
		</table>
		<div id="e0" class="folder_tree"></div>
		<div style="background-image:url(images/Tree/bg_02.png);background-repeat:no-repeat;height:90px;">
			<input class="button_gen" type="button" style="margin-left:27%;margin-top:18px;" onclick="cancel_folderTree();" value="取消">
			<input class="button_gen" type="button" onclick="confirm_folderTree();" value="确认">
		</div>
	</div>
	<div id="DM_mask_floder" class="mask_floder_bg"></div>
	<!-- floder tree-->
	<div id="Loading" class="popup_bg"></div>
	<div id="LoadingBar" class="popup_bar_bg_ks" style="z-index: 200;" >
		<table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock"  align="center">
			<tr>
				<td height="100">
				<div id="loading_block3" style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;"></div>
				<div id="loading_block2" style="margin:10px auto;width:95%;"></div>
				<div id="log_content2" style="margin-left:15px;margin-right:15px;margin-top:10px;overflow:hidden">
					<textarea cols="50" rows="36" wrap="off" readonly="readonly" id="log_content3" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Lucida Console'; font-size:11px;background:transparent;color:#FFFFFF;outline: none;padding-left:3px;padding-right:22px;overflow-x:hidden"></textarea>
				</div>
				<div id="ok_button" class="apply_gen" style="background: #000;display: none;">
					<input id="ok_button1" class="button_gen" type="button" onclick="hideSSLoadingBar()" value="确定">
				</div>
				</td>
			</tr>
		</table>
	</div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
	<form method="post" name="serverForm" action="/start_apply.htm" target="hidden_frame">
		<input type="hidden" name="action_mode" value="apply">
		<input type="hidden" name="action_script" value="restart_nasapps">
		<input type="hidden" name="action_wait" value="5">
		<input type="hidden" name="current_page" value="Module_aria2.asp">
		<input type="hidden" name="flag" value="">
		<input type="hidden" name="nfsd_" value="<% nvram_get(" nfsd_ "); %>">
	</form>
	<form method="post" name="aidiskForm" action="" target="hidden_frame">
		<input type="hidden" name="motion" id="motion" value="">
		<input type="hidden" name="layer_order" id="layer_order" value="">
		<input type="hidden" name="test_flag" value="" disabled="disabled">
		<input type="hidden" name="protocol" id="protocol" value="">
	</form>
	<input type="hidden" name="current_page" value="Module_aria2.asp" />
	<input type="hidden" name="next_page" value="Module_aria2.asp" />
	<input type="hidden" name="group_id" value="" />
	<input type="hidden" name="modified" value="0" />
	<input type="hidden" name="action_mode" value="" />
	<input type="hidden" name="action_script" value="" />
	<input type="hidden" name="action_wait" value="5" />
	<input type="hidden" name="first_time" value="" />
	<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get(" preferred_lang "); %>"/>
	<input type="hidden" name="SystemCmd" id="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="aria2_config.sh" />
	<input type="hidden" name="firmver" value="<% nvram_get(" firmver "); %>"/>
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
										<div style="float:left;" class="formfonttitle">Aria2</div>
										<div style="float:right; width:15px; height:25px;margin-top:10px">
											<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
										</div>
										<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote" id="head_illustrate"><em>Aria2是一个轻量级的跨平台下载工具，支持HTTP/HTTPS、FTP、SFTP、BitTorrent等协议，支持多线程下载，占用cpu、内存资源少。</em></div>
										<div class="formfontdesc" id="cmdDesc"></div>
										<div id="aria2_switch" style="margin:-1px 0px 0px 0px;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<thead>
														<tr>
															<td colspan="2">开关</td>
														</tr>
													</thead>
													<th style="width:25%;">开启Aria2</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell">
															<label for="aria2_enable">
																<input id="aria2_enable" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container">
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
													</td>
												</tr>
											</table>
										</div>
										<!--beginning of aria2 install table-->
										<div id="aria2_install_table" style="margin:10px 0px 0px 0px;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
													<tr>
														<td colspan="2">Aria2相关信息</td>
													</tr>
												</thead>
												<tr id="aria2_status">
													<th style="width:25%;">运行状态</th>
													<td><span id="status">获取中...</span>
													</td>
												</tr>
												<tr id="aria2_ddnsto_tr">
													<th style="width:25%;">远程穿透连接</th>
													<td>
														<input type="checkbox" id="aria2_ddnsto" name="aria2_ddnsto" checked="checked" disabled="" onclick="oncheckclick(this);">
														<span id="ddnsto_status"></span>
													</td>
												</tr>
												<tr id="ariang">
													<th style="width:25%;">AriaNg控制台</th>
													<td>
														<div style="padding-top:5px;">
															<a id="link4.1" style="font-size: 14px;" href="http://aria2.me/aria-ng/" target="_blank"><i><u>http://aria2.me/aria-ng/</u></i></a>
															<span><a style="font-size: 12px;margin-left: 20px;" href="http://koolshare.cn/thread-116500-1-1.html" target="_blank"><i><u>戳我了解</u></i></a>
															</div>
														</td>
													</tr>
												<tr id="glutton">
													<th style="width:25%;">Glutton控制台</th>
													<td>
														<div style="padding-top:5px;">
															<a id="link4.2" style="font-size: 14px;" href="http://aria2.me/glutton/" target="_blank"><i><u>http://aria2.me/glutton/</u></i></a>
															<span><a style="font-size: 12px;margin-left: 20px;" href="https://koolshare.cn/thread-40938-1-1.html" target="_blank"><i><u>戳我了解</u></i></a>
														</div>
													</td>
												</tr>
												<tr id="webui">
													<th style="width:25%;">更多控制台</th>
													<td>
													<div style="padding-top:5px;">
														<a style="font-size: 14px;" href="http://aria2.me/" target="_blank"><i><u>http://aria2.me/</u></i></a>
													</div>
													</td>
												</tr>
											</table>
										</div>
										<div id="tablet_show">
											<table style="margin:10px 0px 0px 0px;border-collapse:collapse" width="100%" height="37px">
												<tr	width="235px">
													<td colspan="4" cellpadding="0" cellspacing="0" style="padding:0" border="1" bordercolor="#000">
														<input id="show_btn1" class="show-btn1" style="cursor:pointer" type="button" value="基本设置"/>
														<input id="show_btn2" class="show-btn2" style="cursor:pointer" type="button" value="RPC设定"/>
														<input id="show_btn3" class="show-btn3" style="cursor:pointer" type="button" value="下载限制"/>
														<input id="show_btn4" class="show-btn4" style="cursor:pointer" type="button" value="BT设置"/>
														<input id="show_btn6" class="show-btn6" style="cursor:pointer" type="button" value="查看日志"/>
														<input id="show_btn5" class="show-btn5" style="cursor:pointer" type="button" value="帮助信息"/>
													</td>
													</tr>
											</table>
										</div>
										<div id="aria2_base_table" style="margin:-1px 0px 0px 0px;display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<td style="width:25%;">
														<label>启用CPU占用限制</label>
													</td>
													<td>
														<input type="checkbox" id="aria2_cpulimit_enable" name="aria2_cpulimit_enable" checked="" onchange="update_visibility();">
														<input style="display: none;" type="text" class="input_ss_table" style="width:auto;" name="aria2_cpulimit_value" value="30" maxlength="40" size="40" id="aria2_cpulimit_value">
														<small>(范围: 1 - 100; 默认: 30)</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>下载存储目录</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" name="aria2_dir" value="downloads" maxlength="50" size="40" ondblClick="get_disk_tree();" id="aria2_dir">
														<small></br>手动输入或者<i>双击输入框选择路径</i>，如果没有定义，将使用第一个USB设备的根目录.</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>启用续传</label>
													</td>
													<td>
														<input type="checkbox" id="aria2_continue" name="aria2_continue" checked=""/>
														<small>*</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>最大重试次数</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:80px;" name="aria2_max_tries" value="0" maxlength="16" size="7" id="aria2_max_tries">
														<small>(范围: 0 - 9999; 默认: 0 - 无限制)</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>重试间隔时间</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:80px;" name="aria2_retry_wait" value="10" maxlength="16" size="7" id="aria2_retry_wait">
														<small>秒 (范围: 0 - 3600; 默认: 10)</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>Referer (适用于v1.16+)</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:80px;" name="aria2_referer" value="*" maxlength="1024" size="15" id="aria2_referer">
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>磁盘缓存大小 (适用于v1.16+)</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:80px;" name="aria2_disk_cache" value="0" maxlength="16" size="7" id="aria2_disk_cache">
														<small>( 以K或M结尾，例如，10K, 5M, 1024K 等等; 缺省: 0 - 无磁盘缓存)</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>启用 MMAP</label>
													</td>
													<td>
														<input type="checkbox" id="aria2_enable_mmap" name="aria2_enable_mmap"/>
														<small>*</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>文件分配方式</label>
													</td>
													<td>
														<select class="input_ss_table" style="width:86px;height:25px;" name="aria2_file_allocation" id="aria2_file_allocation">
														<option value="prealloc">Prealloc</option>
														<option value="trunc">Trunc</option>
														<option value="falloc">Falloc</option>
														<option value="none" selected="">None*</option>
														</select>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>Aria2 配置自定义</label>
													</td>
													<td>
														<textarea rows=6 name="aria2_custom" id="aria2_custom" title="">ca-certificate=/etc/ssl/certs/ca-certificates.crt</textarea>
														<small></br>请一行输入一个参数，已经在界面上定义的参数不能在此输入！</small>
													</td>
												</tr>
											</table>
										</div>
										<div id="aria2_rpc_table" style="margin:-1px 0px 0px 0px;display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<td style="width:25%;">
														<label>启用 RPC</label>
													</td>
													<td>
														<input type="checkbox" id="aria2_enable_rpc" name="aria2_enable_rpc" checked="" onchange="update_visibility();"/>
														<small>*</small>
													</td>
												</tr>
												<tr id="aria2_rpc_listen_port_tr">
													<td style="width:25%;">
														<label>RPC 监听端口</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:80px;" name="aria2_rpc_listen_port" value="6800" maxlength="5" size="7" id="aria2_rpc_listen_port" title=""><small>*</small>
													</td>
												</tr>
												<tr id="aria2_rpc_allow_origin_all_tr">
													<td style="width:25%;">
														<label>RPC 允许所有来源</label>
													</td>
													<td>
														<input type="checkbox" id="aria2_rpc_allow_origin_all" name="aria2_rpc_allow_origin_all" checked="" />
														<small>*</small>
													</td>
												</tr>
												<tr id="aria2_disable_ipv6_tr">
													<td style="width:25%;">
														<label>RPC 不监听IPV6</label>
													</td>
													<td>
														<input type="checkbox" id="aria2_disable_ipv6" name="aria2_disable_ipv6" checked="" />
														<small>*</small>
													</td>
												</tr>
												<tr id="aria2_rpc_listen_all_tr">
													<td style="width:25%;">
														<label>RPC 监听所有网络接口</label>
													</td>
													<td>
														<input type="checkbox" id="aria2_rpc_listen_all" name="aria2_rpc_listen_all" checked="" />
														<small>*</small>
													</td>
												</tr>
												<tr id="aria2_event_poll_tr">
													<td style="width:25%;">
														<label>轮询方式</label>
													</td>
													<td>
														<select class="input_ss_table" style="width:86px;height:25px;" name="aria2_event_poll" id="aria2_event_poll">
															<option value="select" selected="">Select</option>
															<option value="poll">Poll</option>
															<option value="port">Port</option>
															<option value="kqueue">KQueue</option>
															<option value="epoll">EPoll</option>
														</select>
													</td>
												</tr>
												<tr id="aria2_rpc_secret_tr">
													<td style="width:25%;">
														<label>RPC密码 / token</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:97%;" name="aria2_rpc_secret" value="" maxlength="32" size="32" id="aria2_rpc_secret">
														<small><i>(不填或者清空此处，将会使用自动生成的随机密码)<br />(如果勾选上方的“启用DDNSTO远程穿透连接”，此处将使用预设值且不能自定义。)</i></small>
													</td>
												</tr>
											</table>
										</div>
										<div id="aria2_limit_table" style="margin:-1px 0px 0px 0px;display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<td style="width:25%;">
														<label>最大同时下载任务数</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:80px;" name="aria2_max_concurrent_downloads" value="3" maxlength="10" size="7" id="aria2_max_concurrent_downloads">
														<small>(范围: 1 - 100; 缺省: 5)</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>同服务器最大连接数</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:80px;" name="aria2_max_connection_per_server" value="1" maxlength="10" size="7" id="aria2_max_connection_per_server"><small>(缺省: 1)</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;" style="width:25%;">
														<label>最小文件分片大小</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:80px;" name="aria2_min_split_size" value="10M" maxlength="20" size="10" id="aria2_min_split_size"><small>(范围: 1M - 1024M; 缺省: 10M)</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>单文件最大线程数</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:80px;" name="aria2_split" value="5" maxlength="10" size="10" id="aria2_split"><small>(范围: 1 - 100; 缺省: 5)</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>下载总速度限制</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:80px;" name="aria2_max_overall_download_limit" value="0" maxlength="16" size="10" id="aria2_max_overall_download_limit"><small>( 例如, 10K, 5M, 1024K 等等; 缺省: 0 - 无限制)</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>单文件下载速度限制</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:80px;" name="aria2_max_download_limit" value="0" maxlength="16" size="10" id="aria2_max_download_limit"><small>( 例如, 10K, 5M, 1024K 等等; 缺省: 0 - 无限制)</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>上传总速度限制</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:80px;" name="aria2_max_overall_upload_limit" value="0" maxlength="16" size="10" id="aria2_max_overall_upload_limit"><small>( 例如, 10K, 5M, 1024K 等等; 缺省: 0 - 无限制)</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>单文件上传速度限制</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:80px;" name="aria2_max_upload_limit" value="0" maxlength="16" size="10" id="aria2_max_upload_limit"><small>( 例如, 10K, 5M, 1024K 等等; 缺省: 0 - 无限制)</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>断开此速度以下的连接</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:80px;" name="aria2_lowest_speed_limit" value="0" maxlength="16" size="10" id="aria2_lowest_speed_limit"><small>( 例如, 10K, 5M, 1024K 等等; 缺省: 0 - 无限制)</small>
													</td>
												</tr>
											</table>
										</div>
										<div id="aria2_bt_table" style="margin:-1px 0px 0px 0px;display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
													<td style="width:25%;">
														<label>启用本地节点查找(LPD)</label>
													</td>
													<td>
														<input type="checkbox" id="aria2_bt_enable_lpd" name="aria2_bt_enable_lpd" />
														<small>*</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>启用 DHT</label>
													</td>
													<td>
														<input type="checkbox" id="aria2_enable_dht" name="aria2_enable_dht" checked="" onchange="update_visibility();">
														<small>*</small>
													</td>
												</tr>
												<tr id="aria2_dht_listen_port_tr">
													<td style="width:25%;">
														<label>DHT 监听端口</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" name="aria2_dht_listen_port" value="52413" maxlength="50" size="50" id="aria2_dht_listen_port">
														<small>默认: 52413</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>添加额外的Tracker</label>
													</td>
													<td>
														<textarea rows=21 style="font-size:10px;" name="aria2_bt_tracker" id="aria2_bt_tracker"></textarea>
														<label>访问<a target="_blank" href="http://www.tkser.tk/"> <i><u>www.tkser.tk</u></i> </a>, <a target="_blank" href="https://github.com/ngosang/trackerslist"> <i><u>https://github.com/ngosang/trackerslistk</u></i> </a>可以获取额外tracker。</label>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>单种子最大连接数</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" name="aria2_bt_max_peers" value="55" maxlength="10" size="7" id="aria2_bt_max_peers">
														<small>(范围: 1 - 9999; 缺省: 55)</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>强制加密</label>
													</td>
													<td>
														<input type="checkbox" id="aria2_bt_require_crypto" name="aria2_bt_require_crypto" checked=""/>
														<small>*</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>自动下载.torrent种子</label>
													</td>
													<td>
														<input type="checkbox" id="aria2_follow_torrent" name="aria2_follow_torrent" checked="" />
														<small>*</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>BT 监听端口</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" name="aria2_listen_port" value="6881-6889,51413" maxlength="50" size="50" id="aria2_listen_port">
														<small>*</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>启用节点信息交换</label>
													</td>
													<td>
														<input type="checkbox" id="aria2_enable_peer_exchange" name="aria2_enable_peer_exchange" checked="" />
														<small>*</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>用户代理</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" name="aria2_user_agent" value="uTorrent/2210(25130)" maxlength="64" size="50" id="aria2_user_agent" />
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>节点ID前缀</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" name="aria2_peer_id_prefix" value="-UT2210-" maxlength="64" size="15" id="aria2_peer_id_prefix" />
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>分享比例</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" name="aria2_seed_ratio" value="1.0" maxlength="64" size="15" id="aria2_seed_ratio" /><small>(范围: 0.0 - 9999; 缺省: 1.0)</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>启用会话session强制保存</label>
													</td>
													<td>
														<input type="checkbox" id="aria2_force_save" name="aria2_force_save" checked="" onchange="update_visibility();">
														<small>*</small>
													</td>
												</tr>
												<tr id="aria2_save_session_interval_tr">
													<td style="width:25%;">
														<label>&nbsp;&nbsp;&nbsp;&nbsp;会话session保存间隔</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" name="aria2_save_session_interval" value="60" maxlength="20" size="7" id="aria2_save_session_interval" /><small>秒 (范围: 0 - 3600; 缺省: 60)</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>&nbsp;&nbsp;&nbsp;&nbsp;下载的URIs 文件</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" name="aria2_input_file" value="/koolshare/aria2/aria2.session" maxlength="50" size="50" id="aria2_input_file" />
													</td>
												</tr>
												<tr id="aria2_save_session_tr">
													<td style="width:25%;">
														<label>&nbsp;&nbsp;&nbsp;&nbsp;会话session保存文件</label>
													</td>
													<td>
														<input type="text" class="input_ss_table" style="width:auto;" name="aria2_save_session" value="/koolshare/aria2/aria2.session" maxlength="50" size="50" id="aria2_save_session" />
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>启用哈希检查做种</label>
													</td>
													<td>
														<input type="checkbox" id="aria2_bt_hash_check_seed" name="aria2_bt_hash_check_seed" checked="" />
														<small>*</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>启用无校验做种</label>
													</td>
													<td>
														<input type="checkbox" id="aria2_bt_seed_unverified" name="aria2_bt_seed_unverified" />
														<small>*</small>
													</td>
												</tr>
												<tr>
													<td style="width:25%;">
														<label>启用元数据保存</label>
													</td>
													<td>
														<input type="checkbox" id="aria2_bt_save_metadata" name="aria2_bt_save_metadata" />
														<small>*</small>
													</td>
												</tr>
											</table>
										</div>
										<div id="aria2_log" style="margin:-1px 0px 0px 0px;display: none;">
											<div id="log_content" style="margin-top:-1px;display:block;overflow:hidden;">
												<textarea cols="63" rows="36" wrap="on" readonly="readonly" id="log_content1" style="margin-top:-1px;width:97%; padding-left:4px;padding-right:37px;border:0px solid #222;font-family:'Lucida Console';font-size:11px;color:#FFFFFF;outline:none;overflow-x:hidden;" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>
											</div>
										</div>	
										<div id="aria2_help" style="margin:-1px 0px 0px 0px;display: none;">
											<table style="margin:-1px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<tr>
												<td>
													<ul>
														<li>注意：未挂载磁盘时，开启aria2会默认使用路由器/tmp空间作为默认下载地址！可能会让你的内存爆满！</li>
														<li>注意：未挂载磁盘时，aria2插件不会随路由器开机自启！</li>
														<li>额外tracker设置，如果有多个tracker，可以用英文逗号隔开，或者每行一个，或者各一行一个均可！</li>
														<li>如果你是非公网ip用户，可以开启远程穿透连接，插件将会自动为你设置为通过ddnsto插件穿透！</li>
														<li>感谢<a href="https://github.com/aria2/aria2" target="_blank" ><i><u>aria2开源项目</u></i></a>，更多帮助信息，请在<a href="https://aria2.github.io/" target="_blank" ><i><u>aria2官方网站</u></i></a>了解。</li>
														<li>本插件的维护地址在<a href="https://github.com/koolshare/rogsoft" target="_blank" ><i><u>https://github.com/koolshare/rogsoft</u></i></a>，欢迎到此反馈问题！</li>
													</ul>
												</td>
												</tr>
											</table>
										</div>
										<div class="apply_gen">
											<input class="button_gen" type="button" onclick="save()" value="提交"/>
											<input class="button_gen" type="button" onclick="load_default_value()" value="恢复默认参数" id="cmdBtn1"/>
										</div>
										<div class="KoolshareBottom">
												论坛技术支持：
											<a href="http://www.koolshare.cn" target="_blank"><i><u>www.koolshare.cn</u></i></a>
											<br/>后台技术支持：<i>Xiaobao</i>
											<br/>Shell, Web by：<i>sadog</i>
											<br/>
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
	<div id="footer"></div>
	<div id="OverlayMask" class="popup_bg">
	<div align="center">
		<iframe src="" frameborder="0" scrolling="no" id="popupframe" width="400" height="400" allowtransparency="true" style="margin-top:150px;"></iframe>
	</div>
	</div>
</body>
</html>
