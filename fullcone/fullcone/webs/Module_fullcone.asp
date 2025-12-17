<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="-1" />
<link rel="shortcut icon" href="/res/icon-fullcone.png" />
<link rel="icon" href="/res/icon-fullcone.png" />
<title>软件中心 - FULLCONE NAT 插件</title>
<link rel="stylesheet" type="text/css" href="index_style.css">
<link rel="stylesheet" type="text/css" href="form_style.css">
<link rel="stylesheet" type="text/css" href="usp_style.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="/device-map/device-map.css">
<link rel="stylesheet" type="text/css" href="/js/table/table.css">
<link rel="stylesheet" type="text/css" href="/res/layer/theme/default/layer.css">
<link rel="stylesheet" type="text/css" href="/res/softcenter.css">
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/res/layer/layer.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/res/jquery-ui.js"></script> 
<script type="text/javascript" src="/res/softcenter.js"></script>
<script type="text/javascript" src="/help.js"></script>
<style>
a:focus {
	outline: none;
}
.SimpleNote {
	padding:5px 5px;
}
i {
	color: #FC0;
	font-style: normal;
}
.loadingBarBlock{
	width:740px;
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
	background:rgba(68, 79, 83, 0.85) none repeat scroll 0 0 !important;
	background-position: 0 0;
	background-size: cover;
	opacity: .94;
}

.FormTitle em {
	color: #00ffe4;
	font-style: normal;
}
.FormTable th{
	width:20%;
}
.formfonttitle {
	font-family: Roboto-Light, "Microsoft JhengHei";
	font-size: 18px;
	margin-left: 5px;
}
.FormTitle, .FormTable, .FormTable th, .FormTable td, .FormTable thead td, .FormTable_table, .FormTable_table th, .FormTable_table td, .FormTable_table thead td {
	font-size: 14px;
	font-family: Roboto-Light, "Microsoft JhengHei";
}
body .layui-layer-lan .layui-layer-btn0 {border-color:#22ab39; background-color:#22ab39;color:#fff; background:#22ab39}
body .layui-layer-lan .layui-layer-btn .layui-layer-btn1 {border-color:#1678ff; background-color:#1678ff;color:#fff;}
body .layui-layer-lan .layui-layer-btn2 {border-color:#FF6600; background-color:#FF6600;color:#fff;}
body .layui-layer-lan .layui-layer-title {background: #1678ff;}
body .layui-layer-lan .layui-layer-btn a{margin:8px 8px 0;padding:5px 18px;}
body .layui-layer-lan .layui-layer-btn {text-align:center}
.popup_bar_bg_ks{
	position:fixed;	
	margin: auto;
	top: 0;
	left: 0;
	width:100%;
	height:100%;
	z-index:99;
	/*background-color: #444F53;*/
	filter:alpha(opacity=90);  /*IE5、IE5.5、IE6、IE7*/
	background-repeat: repeat;
	visibility:hidden;
	overflow:hidden;
	/*background: url(/images/New_ui/login_bg.png);*/
	background:rgba(68, 79, 83, 0.85) none repeat scroll 0 0 !important;
	background-position: 0 0;
	background-size: cover;
	opacity: .94;
}
.loadingBarBlock{
	width:740px;
}
.loading_block_spilt {
	/* below are custom styles for fc modals */
}
/* ========== FULLCONE custom modal styles ========== */
.fc-modal{font-size:13px;line-height:1.6;color:#e6e6e6}
.fc-modal .fc-wrap{background:#1f252b;border:1px solid #2b323a;border-radius:10px;padding:14px}
.fc-modal .fc-header{display:flex;align-items:center;gap:10px;margin-bottom:8px}
.fc-modal .fc-header .fc-icon{font-size:18px}
.fc-modal .fc-sub{color:#aab4bf;margin:6px 0 10px}
.fc-modal .fc-split{height:1px;background:#2b323a;margin:10px 0}
.fc-plans{display:grid;grid-template-columns:repeat(4,1fr);gap:10px;margin:8px 0}
.fc-plan{cursor:pointer;border:1px solid #333a44;border-radius:8px;padding:10px;background:#202830;transition:all .15s}
.fc-plan:hover{border-color:#3f8cff;background:#222e39}
.fc-plan.active2{border-color:#2e7dfb;box-shadow:0 0 0 1px #2e7dfb inset}
.fc-plan .name{font-weight:600;color:#f0f3f6}
.fc-plan .price{font-size:16px;color:#7bc3ff;margin-top:4px}
.fc-tip{color:#8ea2b3;margin-top:6px}
.fc-actions{display:flex;gap:10px;flex-wrap:wrap;margin-top:12px}
.fc-btn{display:inline-flex;align-items:center;gap:6px;padding:8px 14px;border-radius:6px;border:1px solid #33414f;background:#22303d;color:#e6f0ff;cursor:pointer}
.fc-btn:hover{background:#273747}
.fc-btn.primary{background:#1678ff;border-color:#1678ff;color:#fff}
.fc-btn.success{background:#22ab39;border-color:#22ab39;color:#fff}
.fc-btn.warn{background:#ff6600;border-color:#ff6600;color:#fff}
.fc-badge{display:inline-block;padding:1px 6px;border-radius:10px;font-size:12px;margin-left:6px;background:#33414f;color:#9cc7ff}
.fc-kv{display:flex;gap:10px;flex-wrap:wrap}
.fc-kv .item{background:#202830;border:1px solid #2b323a;border-radius:8px;padding:8px 10px;color:#c9d4df}
.fc-code{font-family:'Lucida Console',monospace;color:#ffb86b}
.fc-link{color:#7bc3ff;cursor:pointer;text-decoration:underline}

.loading_block_spilt {
	background: #656565;
	height: 1px;
	width: 98%;
}
/* ========== FULLCONE light modal styles (fcx-*) ========== */
.fcx-modal{font-size:13px;line-height:1.6;color:#222}
.fcx-wrap{background:#f2f2f2;;padding:16px;margin:0 auto}
.fcx-header{display:flex;align-items:center;gap:8px;margin-bottom:8px}
/* Center title only for inline-pay modals */
.fcx-pay .fcx-header{justify-content:center}
.fcx-icon{font-size:18px}
.fcx-sub{color:#6b7785;margin:6px 0 10px}
.fcx-split{height:1px;background:#edf1f5;margin:12px 0}
.fcx-grid{display:grid;grid-template-columns:repeat(5,minmax(120px,1fr));gap:12px}
.fcx-grid.fcx-grid-4{grid-template-columns:repeat(4,minmax(120px,1fr))}
.fcx-card{cursor:pointer;border:1px solid #e6e9f0;border-radius:12px;padding:12px;background:#fbfdff;transition:transform .15s, box-shadow .15s, border-color .15s}
.fcx-card:hover{transform:translateY(-1px);box-shadow:0 6px 18px rgba(0,0,0,0.06)}
.fcx-card.active2{border-color:#2e7dfb;box-shadow:0 0 0 1px #2e7dfb inset, 0 6px 18px rgba(46,125,251,0.12)}
.fcx-name{font-weight:600}
.fcx-price{margin-top:4px;font-size:16px}
.fcx-1y{background:linear-gradient(135deg,#ecfff6 0%,#f8fffb 100%);border-color:#d9f6e8}
.fcx-2y{background:linear-gradient(135deg,#eef6ff 0%,#fafcff 100%);border-color:#dce9fb}
.fcx-3y{background:linear-gradient(135deg,#f4f0ff 0%,#fcfbff 100%);border-color:#e6defd}
.fcx-life{background:linear-gradient(135deg,#fff6e6 0%,#fffbf2 100%);border-color:#f8e7c7}
.fcx-1y .fcx-price{color:#14B67A}
.fcx-2y .fcx-price{color:#2e7dfb}
.fcx-3y .fcx-price{color:#7c5cfc}
.fcx-life .fcx-price{color:#d4a017}
.fcx-tip{color:#6b7785;margin-top:6px}
.fcx-actions{display:flex;gap:12px;flex-wrap:wrap;margin-top:12px;justify-content:center}
/* 更大的按钮与图标，提高可读性与对比度 */
.fcx-btn{display:inline-flex;align-items:center;gap:10px;padding:12px 24px;border-radius:12px;border:2px solid #dfe5ee;background:#ffffff;color:#1f2937;cursor:pointer;font-size:16px;line-height:1}
.fcx-btn:hover{filter:brightness(0.99)}
/* 以纯白为底 + 品牌色描边，保证与彩色图标的对比度；悬停时轻微着色 */
/* 说明：某些固件/主题对 .primary/.success 使用 !important 覆盖背景色，因此这里也用 !important 兜底 */
#fcx-wechat, #fcx-ext-wechat, #fcx-ext-wechat-unified{background:#ffffff !important;border-color:#48b338 !important;color:#1f4d28 !important;box-shadow:0 0 0 2px rgba(72,179,56,0.10) inset !important}
#fcx-wechat:hover, #fcx-ext-wechat:hover, #fcx-ext-wechat-unified:hover{background:#f6fbf7 !important}
#fcx-alipay, #fcx-ext-alipay, #fcx-ext-alipay-unified{background:#ffffff !important;border-color:#009fe8 !important;color:#0c4f72 !important;box-shadow:0 0 0 2px rgba(0,159,232,0.10) inset !important}
#fcx-alipay:hover, #fcx-ext-alipay:hover, #fcx-ext-alipay-unified:hover{background:#f4faff !important}
#fcx-trial,#fcx-exp-trial{background:#ffffff;border-color:#ff960e;color:#7a4b14;box-shadow:0 0 0 2px rgba(255,150,14,0.12) inset}
#fcx-trial:hover,#fcx-exp-trial:hover{background:#fff8ef}
/* purchase/extend/deactivate action buttons */
#fcx-buy,#fcx-trial-buy{background:#ffffff;border-color:#d4237a;color:#7a1348;box-shadow:0 0 0 2px rgba(212,35,122,0.10) inset}
#fcx-buy:hover,#fcx-trial-buy:hover{background:#fff0f7}
#fcx-ext{background:#ffffff;border-color:#d4237a;color:#7a1348;box-shadow:0 0 0 2px rgba(212,35,122,0.10) inset}
#fcx-ext:hover{background:#fff0f7}
#fcx-deact{background:#ffffff;border-color:#1296db;color:#0c4f72;box-shadow:0 0 0 2px rgba(18,150,219,0.10) inset}
#fcx-deact:hover{background:#f4faff}

.fcx-btn#fcx-wechat,.fcx-btn#fcx-alipay,.fcx-btn#fcx-trial,.fcx-btn#fcx-exp-trial,.fcx-btn#fcx-ext-wechat,.fcx-btn#fcx-ext-alipay,.fcx-btn#fcx-ext-wechat-unified,.fcx-btn#fcx-ext-alipay-unified,.fcx-btn#fcx-buy,.fcx-btn#fcx-trial-buy,.fcx-btn#fcx-ext,.fcx-btn#fcx-deact{padding:10px 20px}
.fcx-btn .fcx-ico{width:32px;height:32px;display:inline-block;vertical-align:middle;margin-right:10px}
.fcx-kv{display:flex;gap:10px;flex-wrap:wrap}
.fcx-kv .item{background:#fbfdff;border:1px solid #e6e9f0;border-radius:10px;padding:8px 10px;color:#333}
.fcx-code{font-family: 'Lucida Console', monospace;color:#b4690e}
.fcx-link{cursor:pointer;user-select:none}
.fcx-link:hover{text-decoration:underline}
.fcx-center{display:flex;justify-content:center}
/* Mask input characters without using type=password */
#fullcone_key.fcx-mask{ -webkit-text-security: disc; text-security: disc; }

/* expired highlight */
.fcx-exp{background:#ffecec;border-color:#ffc9c9 !important;color:#FF3366}
/* Ensure highlight wins over `.fcx-kv .item` (higher specificity + !important) */
.fcx-kv .item.fcx-exp{background:#ffecec !important;border-color:#ffc9c9 !important;color:#FF3366 !important}
.fcx-btn.danger{background:#e02424;border-color:#e02424;color:#fff}

/* ====== Make selected plan brighter & more eye‑catching ====== */
.fcx-card{position:relative;background:#ffffff}
/* lighter plan tints */
.fcx-1y{background:linear-gradient(180deg,#f4fff9 0%,#ffffff 100%);border-color:#c8f1df}
.fcx-2y{background:linear-gradient(180deg,#f0f7ff 0%,#ffffff 100%);border-color:#cfe3ff}
.fcx-3y{background:linear-gradient(180deg,#f7f3ff 0%,#ffffff 100%);border-color:#e3d9ff}
.fcx-4y{background:linear-gradient(180deg,#fff7f0 0%,#ffffff 100%);border-color:#ffe0c7}
.fcx-5y{background:linear-gradient(180deg,#f2fff6 0%,#ffffff 100%);border-color:#cfeeda}
.fcx-life{background:linear-gradient(180deg,#fff9ee 0%,#ffffff 100%);border-color:#ffe3b3}
.fcx-name{color:#1f2a37}

/* active glow */
.fcx-card.active2{transform:translateY(-1px);border-width:2px;border-color:#22ab39;background:#b8ffbe;box-shadow:none}
.fcx-card.active2:after{content:"";position:absolute;top:0;left:0;right:0;height:0}
.fcx-1y.active2,.fcx-2y.active2,.fcx-3y.active2,.fcx-life.active2{box-shadow:none}
/* remove recommend ribbon for life */
.fcx-life:before{content:none}
/* prevent horizontal scroll in layer content */
.fcx-wrap{overflow-x:hidden}

/* diff line for extend preview */
.fcx-diff{font-size:13px;color:#1f2937}
.fcx-diff .arr{margin:0 4px;color:#9ca3af}
.fcx-diff .life{color:#14B67A;font-weight:700}
.fcx-diff .life-badge{display:inline-block;background:#ffe5ef;color:#a40e4c;border:1px solid #ffb3cc;border-radius:10px;padding:0 6px;line-height:1.6}

/* 已激活弹窗中的终身授权样式（参考授权已过期，仅设置文字颜色，使用绿色系） */
.fcx-kv .life-badge{
    color:#2e7d32;
}

/* 推荐角标样式 */
.fcx-reco{position:absolute;top:-6px;right:-6px;background:#ff3b30;color:#fff;font-size:12px;line-height:1;padding:4px 8px;border-radius:12px;box-shadow:0 2px 6px rgba(0,0,0,0.2);z-index:2}

</style>
<script type="text/javascript">
var dbus = {};
var refresh_flag
var db_fullcone = {}
var count_down;
var _responseLen;
var STATUS_FLAG;
var noChange = 0;
// Payment/activation backend
var pay_server = '42.192.18.234';
var pay_port = '8083';
var params_check = ["fullcone_basic", "fullcone_random", "fullcone_hairpin"];
var params_input = ["fullcone_port_start", "fullcone_port_end", "fullcone_key", "fullcone_rand_method"];
// Router identification for after-sales support
var router_mac = '';
var router_model = '';

// Patch layer.open default position: top=230px, move right by +100px
// fcx_patch_layer: disabled per request (no horizontal shift for layer modals for now)
function fcx_patch_layer(){ /* disabled */ }

// toggle mask for fullcone_key input
function toggleKeyMask(show){
	var el = document.getElementById('fullcone_key');
	if (!el) return;
	if (show){
		el.classList.remove('fcx-mask');
	} else {
		el.classList.add('fcx-mask');
	}
}

// 实时监听授权码输入变化：若检测到以 fx_ 开头的兑换码，则显式显示按钮并将文案改为“兑换”，否则为“激活”
function fcx_watch_code(){
  var el = document.getElementById('fullcone_key');
  var btn = document.getElementById('fullcone_active_btn');
  if (!el || !btn) return;
  function isActivated(){ try{ return !!(dbus && dbus['fullcone_key']); }catch(e){ return false; } }
  function apply(){
    var v = (el.value||'').trim();
    var act = isActivated();
    // 严格校验 UUID 形式，长度 36（含连字符）
    var fxUuidRe = /^fx_[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$/;
    var fcUuidRe = /^fc_[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$/;
    // fx_ 兑换码：仅当格式完整（长度正确）时显示“兑换”
    if (fxUuidRe.test(v)){
      try{ btn.style.display = ''; }catch(e){}
      btn.textContent = '兑换';
      return;
    }
    // fc_ 激活码：仅当格式完整且“未激活”时显示“激活”；否则隐藏
    if (fcUuidRe.test(v)){
      if (act){ btn.style.display = 'none'; }
      else { try{ btn.style.display = ''; }catch(e){} btn.textContent = '激活'; }
      return;
    }
    // 其它或空：不显示按钮
    btn.style.display = 'none';
  }
  el.addEventListener('input', apply);
  el.addEventListener('change', apply);
  el.addEventListener('keyup', apply);
  apply();
}

// Decode fc_ code to extract exp date (UI-only; backend enforces via RSA ticket/server)
function fcExpFromCode(code){
	try{
		if(!code || code.indexOf('fc_')!==0) return '';
		var rest = code.slice(3); var pay = rest.split('.')[0];
		var s = pay.replace(/-/g,'+').replace(/_/g,'/');
		if (s.length % 4) s += '='.repeat(4 - (s.length % 4));
		var raw = atob(s); var ps = raw.split('|');
		if(ps.length<2) return '';
		var ts = parseInt(ps[1],10); if(!ts) return '';
		var d = new Date(ts*1000);
		var y=d.getFullYear(), m=('0'+(d.getMonth()+1)).slice(-2), dd=('0'+d.getDate()).slice(-2);
		return y+'-'+m+'-'+dd;
	}catch(e){ return ''; }
}

// Console.log wrapper with dbus switch (fullcone_console=1 to enable)
function fcLog(){
	try{
		if(typeof dbus !== 'undefined' && dbus['fullcone_console'] === '1'){
			console.log.apply(console, arguments);
		}
	}catch(e){}
}

// Decode local RSA ticket payload (code|mac|model|exp_ts|type|nonce[|react_left|activation_date|first_purchase_date|react_used])
function parseTicket(tk){
	try{
		if(!tk) return null; var sp=tk.split('.'); if(sp.length<2) return null;
		var pay=sp[0].replace(/-/g,'+').replace(/_/g,'/'); if (pay.length%4) pay += '='.repeat(4-(pay.length%4));
		var raw=atob(pay); var ps=raw.split('|');
		if(ps.length<5) return null; var exp_ts=parseInt(ps[3],10);
		var d=new Date(exp_ts*1000); var y=d.getFullYear(), m=('0'+(d.getMonth()+1)).slice(-2), dd=('0'+d.getDate()).slice(-2);
        var obj = { code: ps[0], mac: ps[1], model: ps[2], exp_ts: exp_ts, exp: y+'-'+m+'-'+dd, type: ps[4], plan: ps[4] };
		if (ps.length>=6) obj.nonce = ps[5];
		if (ps.length>=7) { var rl=parseInt(ps[6],10); if(!isNaN(rl)) obj.react_left = rl; }
		if (ps.length>=8) { obj.activation_date = ps[7]; if (/^\d{4}-\d{2}-\d{2}$/.test(obj.activation_date||'')) obj.activated_at = obj.activation_date; }
		if (ps.length>=9) { obj.first_purchase_date = ps[8]; if (/^\d{4}-\d{2}-\d{2}$/.test(obj.first_purchase_date||'')) obj.first_purchase_at = obj.first_purchase_date; }
		if (ps.length>=10) { var ru=parseInt(ps[9],10); obj.react_used = isNaN(ru) ? 0 : ru; } else { obj.react_used = 0; }
		fcLog('[FULLCONE DEBUG] parseTicket成功, activated_at:', obj.activated_at, ', first_purchase_at:', obj.first_purchase_at, ', react_used:', obj.react_used, ', ticket对象:', obj);
		return obj;
	}catch(e){
		fcLog('[FULLCONE DEBUG] parseTicket失败:', e);
		return null;
	}
}

String.prototype.myReplace = function(f, e){
	var reg = new RegExp(f, "g");
	return this.replace(reg, e);
}

function init() {
    // fcx_patch_layer disabled
    show_menu(menu_hook);
    set_skin();
    register_event();
    get_router_info(); // Get MAC and model for after-sales support
    get_dbus_data();
    check_status();
	// Auto-fill activation code from return URL: Module_fullcone.asp?key=...
        try {
            var urlParams = new URLSearchParams(window.location.search);
            var retKey = urlParams.get('key');
            var xplan  = urlParams.get('xplan');
            var xexp   = urlParams.get('xexp');
            if (retKey) {
                E('fullcone_key').value = retKey;
                if (xplan){
                  try{
                    var tk = dbus['fullcone_ticket'] ? parseTicket(dbus['fullcone_ticket']) : null;
                    function labelType(p){ if(!p) return ''; if(p==='trial')return '试用'; if(p==='gift')return '赠送'; if(p==='buy')return '购买'; if(p.indexOf('trial')===0) return '试用'; if(p.indexOf('gift')===0) return '赠送'; if(p.indexOf('buy')===0) return '购买'; return p; }
                    var cv = tk;
                    var prv = cv && cv.plan ? labelType(cv.plan) : '';
                    var nxt = '购买';
                    if (prv){
                      // 有旧票据，视为延长授权
                      window._fcx_ext_hint = { prev: prv, next: nxt, code: retKey };
                      window._fcx_countdown_override = 10;
                    } else {
                      // 无旧授权，视为购买
                      // 购买路径下也统一走标准日志，不再透传“购买成功”提示
                    }
                  }catch(ex){}
                }
                // try to activate silently
                setTimeout(function(){ boost_now(3); }, 300);
            }
        } catch (e) {}
    // 首次使用提示：检查是否已阅读使用说明
    try {
        if (dbus['fullcone_note'] !== '1') {
            // 延迟弹出，确保页面完全加载
            setTimeout(function(){ show_usage_notes(); }, 500);
        }
    } catch (e) {}
}
function set_skin(){
	var SKN = '<% nvram_get("sc_skin"); %>';
	if(SKN){
		$("#app").attr("skin", '<% nvram_get("sc_skin"); %>');
	}
}

// Get router MAC and model for after-sales support
function get_router_info(){
	// Get MAC address from LAN interface
	router_mac = '<% nvram_get("lan_hwaddr"); %>';
	if (!router_mac || router_mac === ''){
		router_mac = '<% nvram_get("et0macaddr"); %>';
	}
	// Get router model (prefer odmpid, fallback to productid)
	router_model = '<% nvram_get("odmpid"); %>';
	if (!router_model || router_model === ''){
		router_model = '<% nvram_get("productid"); %>';
	}
	// Normalize MAC to uppercase
	if (router_mac){
		router_mac = router_mac.toUpperCase();
	}
}

function get_dbus_data(){
	$.ajax({
		type: "GET",
		url: "/_api/fullcone_",
		dataType: "json",
		async: false,
		success: function(data) {
			dbus = data.result[0];
			conf2obj();
			show_hide_element();
          }
        });
}

function conf2obj(){
	for (var i = 0; i < params_check.length; i++) {
		if(dbus[params_check[i]]){
			E(params_check[i]).checked = dbus[params_check[i]] != "0";
    }
    // 绑定授权码输入框监听：检测 fx_ 兑换码时，显示按钮并将“激活”改为“兑换”
    try{ fcx_watch_code(); }catch(e){}
}
	for (var i = 0; i < params_input.length; i++) {
		if (dbus[params_input[i]]) {
			$("#" + params_input[i]).val(dbus[params_input[i]]);
		}
	}
	if (dbus["fullcone_version"]){
		E("fullcone_version").innerHTML = " - " + dbus["fullcone_version"];
	}

		if(dbus["fullcone_key"]){
			E("fullcone_buy_btn").style.display = "none";
			E("fullcone_active_btn").style.display = "none";
			E("fullcone_authorized_btn").style.display = "";
            }else{
                E("fullcone_buy_btn").style.display = "";
                // 全新安装且未填写授权码时，不显示“激活”按钮；由输入监听决定何时显示
                E("fullcone_active_btn").style.display = "none";
                E("fullcone_authorized_btn").style.display = "none";
                // 全新安装且未授权：在授权信息栏显示“未授权”（红色）
                if (E('fullcone_auth_info')) { E('fullcone_auth_info').innerHTML = '未授权'; E('fullcone_auth_info').style.color = '#FF3366'; }
            }
        // 过期态/有效期 UI：回退到由前端解析 ticket 的方式
        (function(){
            var code = dbus['fullcone_key'] || '';
            var tk = dbus['fullcone_ticket'] || '';
            if (!code) return;
            var info = tk ? parseTicket(tk) : null;
            if (info && info.exp){
                var now = new Date(); var today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
                var expd = new Date(info.exp_ts*1000);
                var expired = expd < today;
                var isTrial = ((info.type||'') === 'trial') || (info.plan === 'trial');
                if (expired){
                    E('fullcone_auth_info').innerHTML = '授权已过期（原到期：<em>'+info.exp+'</em>）';
                    E('fullcone_auth_info').style.color='#FF3366';
                    if (isTrial){
                        E('fullcone_authorized_btn').innerHTML='试用过期';
                        E('fullcone_authorized_btn').onclick=function(){ open_expired(true); };
                        try{ E('fullcone_authorized_btn').style.width='70px'; }catch(e){}
                    } else {
                        E('fullcone_authorized_btn').innerHTML='授权过期';
                        E('fullcone_authorized_btn').onclick=function(){ open_expired(false); };
                        try{ E('fullcone_authorized_btn').style.width=''; }catch(e){}
                    }
                } else {
                    // 终身显示“终身”而非日期
                    var p = info.plan||''; var ets = parseInt(info.exp_ts||'0',10);
                    var life = false; if (p){ life = (p==='buy_life' || p==='gift_life' || p==='life'); }
                    // 兼容不同服务端终身时间戳或日期：4102415999/4102444799 或 exp=2099-12-31
                    if (!life){
                        if (ets && ets >= 4102358400){ life = true; }
                        else if (info.exp && info.exp.indexOf('2099-12-31')===0){ life = true; }
                    }
                    if (life){
                        // 根据需求：授权信息栏使用“永久”字样
                        E('fullcone_auth_info').innerHTML = '有效期至：<em>永久</em>';
                    } else {
                        E('fullcone_auth_info').innerHTML = '有效期至：<em>'+info.exp+'</em>';
                    }
                    E('fullcone_auth_info').style.color='';
                    if (isTrial){
                        var nowTs = Math.floor(Date.now()/1000); var left = Math.max(0, Math.ceil((parseInt(info.exp_ts,10)-nowTs)/86400));
                        E('fullcone_authorized_btn').innerHTML='试用中（剩余'+left+'天）';
                        E('fullcone_authorized_btn').onclick=function(){ open_trial_info(); };
                        try{ E('fullcone_authorized_btn').style.width='125px'; }catch(e){}
                    } else {
                        E('fullcone_authorized_btn').innerHTML='已激活';
                        E('fullcone_authorized_btn').onclick=function(){ open_info(); };
                        try{ E('fullcone_authorized_btn').style.width=''; }catch(e){}
                    }
                }
            } else {
                // 仅使用本地数据，不再联网获取
                E('fullcone_authorized_btn').innerHTML='已激活';
                E('fullcone_authorized_btn').onclick=function(){ open_info(); };
            }
        })();
	if (dbus["fullcone_warn"]){
		//E("qrcode_show").style.height = "505px"
		E("fullcone_buy_btn").style.display = "none";
		E("fullcone_active_btn").style.display = "none";
		E("fullcone_authorized_btn").style.display = "none";
	}
}

function show_hide_element(){
	// 授权信息在未开启插件时也应显示
	E("fullcone_status_tr").style.display = "";
	E("fullcone_authinfo_tr").style.display = "";
	if(dbus["fullcone_enable"] == "1"){
		E("fullcone_apply_btn_1").style.display = "none";
		E("fullcone_apply_btn_2").style.display = "";
		E("fullcone_apply_btn_3").style.display = "";
	}else{
		E("fullcone_apply_btn_1").style.display = "";
		E("fullcone_apply_btn_2").style.display = "none";
		E("fullcone_apply_btn_3").style.display = "none";
	}

	if(E("fullcone_basic").checked == true){
		E("rand_tr").style.display = "none";
	}else{
		E("rand_tr").style.display = "";
	}
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length - 1] = new Array("", "fullcone文件列表");
	tablink[tablink.length - 1] = new Array("", "Module_fullcone.asp");
}

// NAT 类型检测按钮（全局注册，避免 register_event 生命周期影响）
$(function(){
  // NAT 类型检测按钮
  $(document).on('click', '#fcx-nat-test', function(){
    try{ layer.closeAll(); }catch(e){}
    var tip = "<div class='fcx-nat-tip' style=\"padding:10px 12px 6px;color:red;font-size:13px;line-height:1.6;background:#f9fbff;border-bottom:1px solid #e5eaf0\">"
            //+   "<div style=\"margin-bottom:4px;font-weight:600\">检测提示：</div>"
            +   "<ol style=\"margin:0 0 6px 18px;padding:0\">"
            +     "<li>为检测准确，请确保浏览器所在网络由本路由器提供，通过远程访问的检测结果无法反应出本路由网络NAT后的类型</li>"
            +     "<li>检测前需要关闭手机/PC/浏览器的代理程序，如果使用windows电脑检测，需要关闭防火墙才能检测准确</li>"
            +     "<li>此检测结果仅供参考，你可以使用<a href='https://github.com/HMBSbige/NatTypeTester' target='_blank' rel='noopener noreferrer' style='color:#001bdd'>NatTypeTester</a>、<a href='https://github.com/oneclickvirt/gostun' target='_blank' rel='noopener noreferrer' style='color:#001bdd'>gostun</a>等检测工具，在本路由器下局域网中的客户端机器中进行检测</li>"
            +   "</ol>"
            + "</div>";
    // Hide iframe vertical scrollbar by clipping the right-side scrollbar area (cross-origin page; cannot style inside iframe)
    var iframe = "<div class='fcx-nat-iframe' style=\"width:760px;height:620px;margin:0 auto;overflow:hidden;\">"
               +   "<iframe src=\"https://ai.koolcenter.com/nat/?from=asusgo\" style=\"width:760px;height:620px;border:0;\" scrolling=\"yes\" referrerpolicy=\"no-referrer\"></iframe>"
               + "</div>";
    var box = "<div class='fcx-nat-wrap' style=\"background:#fff;overflow:hidden\">" + tip + iframe + "</div>";
    layer.open({ type:1, skin:'layui-layer-lan', title:'NAT 类型检测', area:'744px', offset:'auto', shade:0.8, resize:false, content:box,
      success:function(layero, idx){
        try{
          var $layer = $(layero);
          var dbg = (window.FCX_DEBUG === true);
          var applySize = function(){
            // Prefer explicit iframe wrapper width (cross-origin iframe may delay layout)
            var w = $layer.find('.fcx-nat-iframe').outerWidth(true) || $layer.find('.fcx-nat-wrap').outerWidth(true) || 0;
            if (dbg) console.log('[fcx-nat] idx=', idx, 'wrap_w=', w, 'layer_w(before)=', $layer.width());
            // Layer 默认会给 .layui-layer 写入 width:360px；这里强制覆盖为内容宽度
            if (w && w > 360){
              $layer.css({ width: w + 'px', maxWidth: 'none' });
            } else {
              // 兜底：移除 width，让其按内容自适应（部分 layer 版本对 auto 支持不一致）
              $layer[0].style.width = '';
              $layer.css({ width: '', maxWidth: 'none' });
            }
            $layer.find('.layui-layer-content').css({ overflow: 'hidden', width: 'auto' });
            if (dbg) console.log('[fcx-nat] layer_w(after)=', $layer.width());
          };
          applySize();
          setTimeout(applySize, 60);
        }catch(e){}
      }
    });
  });

  // 使用说明按钮
  $(document).on('click', '#note2user', function(){
    show_usage_notes();
  });
});

// 显示使用说明弹窗
function show_usage_notes(){
  try{ layer.closeAll(); }catch(e){}

  // README 内容（转换为 HTML）
  var content = `
<div class="fcx-readme-content" style="padding:16px 20px;line-height:1.8;color:#1f2937;font-size:14px;word-wrap:break-word;">
<h3 style="margin:0 0 10px 0;color:#1f2937;font-size:16px;font-weight:700;border-bottom:2px solid #3b82f6;padding-bottom:6px;">使用须知</h3>

<ul style="margin:0 0 14px 0;padding-left:24px;">
<li>本插件能实现最高的NAT等级取决于你路由器所在的网络环境（wan网络环境）；</li>
<li>插件为付费授权，建议试用期间测试NAT类型，确定能实现NAT1后再付费购买</li>
<li>插件提供了免费NAT类型测试工具，测试方法：点击顶部的<code style="background:#f3f4f6;padding:2px 6px;border-radius:3px;color:#be123c;">NAT类型检测按钮</code>；</li>
<li>Full Cone有助于改善游戏联机、P2P下载、视频通话、远程访问、直播串流等场景；</li>
<li>Full Cone意味着更开放的网络，改善网络环境的同时也意味着更多的网络风险。</li>
</ul>

<h3 style="margin:16px 0 10px 0;color:#1f2937;font-size:16px;font-weight:700;border-bottom:2px solid #3b82f6;padding-bottom:6px;">授权说明</h3>

<ul style="margin:0 0 14px 0;padding-left:24px;">
<li>本插件为付费授权插件，目前支持试用 /赠送 /购买三种类型的授权方式；</li>
<li>原则上购买后不退款，如有重复支付、不发码等请联系：<a href="mailto:mjy211@gmail.com" style="color:#3b82f6;">mjy211@gmail.com</a>；</li>
<li>授权码为fc_xxx格式，授权码为一机一码，授权码和路由器设备绑定；</li>
<li>购买方式：点击<code style="background:#f3f4f6;padding:2px 6px;border-radius:3px;color:#be123c;">授权购买</code>，选择购买方案和支付方式，扫码支付后自动激活。</li>
</ul>

<h3 style="margin:16px 0 10px 0;color:#1f2937;font-size:16px;font-weight:700;border-bottom:2px solid #3b82f6;padding-bottom:6px;">购买规则</h3>

<ul style="margin:0 0 14px 0;padding-left:24px;">
<li>套餐售价：1年/9.99元；2年/17.99元；3年/25.99元；4年/33.99元；终身/39.99元；</li>
<li>反激活次数：1年/0次；2年/1次；3年/2次；4年/3次；终身/4次；</li>
<li>购买授权将覆盖试用/赠送授权，这意味着试用/赠送授权剩余天数将不会叠加。</li>
</ul>

<h3 style="margin:16px 0 10px 0;color:#1f2937;font-size:16px;font-weight:700;border-bottom:2px solid #3b82f6;padding-bottom:6px;">反激活</h3>

<ul style="margin:0 0 14px 0;padding-left:24px;">
<li>反激活可将激活码与本机解绑，解绑后该激活码可用于其他设备（或本机再次激活）；</li>
<li>注意：反激活次数用尽后，该激活码将绑定在最后一次激活的设备，直至到期；</li>
<li>如果你的反激活次数用光，可以通过购买延长授权来获得新的反激活次数；</li>
<li>试用授权/授权不支持反激活，购买授权（≥2年）支持按档位的反激活次数。</li>
<li>授权码反激活后并不会冻结使用时间，而是根据授权码到期日计算授权到期。</li>
</ul>

<h3 style="margin:16px 0 10px 0;color:#1f2937;font-size:16px;font-weight:700;border-bottom:2px solid #3b82f6;padding-bottom:6px;">延长规则</h3>

<ul style="margin:0 0 14px 0;padding-left:24px;">
<li>延长授权套餐：1年/9.99元；2年/17.99元；3年/25.99元；4年/33.99元；5年/39.99元；</li>
<li>延长授权反激活次数：1年/0次；2年/1次；3年/2次；4年/3次；5年/4次；</li>
<li>购买类型的授权，在有效期内可以继续购买延长授权，延长授权可以和购买授权叠加；</li>
<li>延长规则1：购买延长套餐叠加当前购买套餐的剩余使用天数和剩余反激活次数；</li>
<li>延长规则2：延长后天数叠加超过1795天（4年11个月），授权自动转为终身授权；</li>
<li>延长规则3：首次购买激活后30天内购买延长授权至终身，优惠3.99元(补差价)。</li>
</ul>

<h3 style="margin:16px 0 10px 0;color:#1f2937;font-size:16px;font-weight:700;border-bottom:2px solid #3b82f6;padding-bottom:6px;">试用规则</h3>

<ul style="margin:0 0 14px 0;padding-left:24px;">
<li>可以免费试用3天，试用过期后可继续申请试用，每台机器可以申请3次；</li>
<li>试用期间/到期后可随时购买授权套餐，购买授权的权益将覆盖试用权益；</li>
<li>试用期间/到期后可以使用兑换码，兑换码兑换的授权类型将覆盖试用权益；</li>
</ul>

<h3 style="margin:16px 0 10px 0;color:#1f2937;font-size:16px;font-weight:700;border-bottom:2px solid #3b82f6;padding-bottom:6px;">兑换码</h3>

<ul style="margin:0 0 14px 0;padding-left:24px;">
<li>兑换码分赠送/购买，前者用于推广，后者用于其它支付方式发码；</li>
<li>兑换码格式：fx_xxx，使用后会兑换为格式：fc_xxx的授权码；</li>
<li>赠送/购买类型兑换码可以兑换相应授权类型的授权码（fc_xxx）；</li>
<li>赠送授权可以覆盖试用授权，赠送授权会被购买授权覆盖；</li>
<li>授权天数多的兑换码会覆盖授权天数低的赠送授权，反之不会。</li>
</ul>

<h3 style="margin:16px 0 10px 0;color:#1f2937;font-size:16px;font-weight:700;border-bottom:2px solid #3b82f6;padding-bottom:6px;">其它说明</h3>

<ul style="margin:0 0 14px 0;padding-left:24px;">
<li>RT-AC86U等机型已经自带Fullcone NAT支持，本插件功能重复，不建议购买本插件；</li>
<li>RT-AC86U等机型使用本插件实现Fullcone NAT，请先关闭固件自带Fullcone NAT功能！</li>
<li>关闭方法：<code style="background:#f3f4f6;padding:2px 6px;border-radius:3px;color:#be123c;">外部网络(WAN)</code> - <code style="background:#f3f4f6;padding:2px 6px;border-radius:3px;color:#be123c;">互联网连接</code>，<code style="background:#f3f4f6;padding:2px 6px;border-radius:3px;color:#be123c;">NAT类型</code>设置为对称型(Symmetric)；</li>
</ul>
</div>
  `;

  var scrollContainer =
    '<div class="fcx-readme-wrapper" style="background:#fff;">' +
      '<div class="fcx-readme-scroll" style="max-height:500px;overflow-y:auto;border:1px solid #e5e7eb;border-radius:6px;">' +
        content +
      '</div>' +
      '<div class="fcx-readme-footer" style="padding:16px 20px;border-top:1px solid #e5e7eb;text-align:center;">' +
        '<button id="fcx-readme-confirm" class="fcx-btn" disabled style="background:#d1d5db;color:#6b7280;cursor:not-allowed;padding:10px 32px;border:none;border-radius:6px;font-size:14px;font-weight:600;">我已知晓</button>' +
        '<div style="margin-top:8px;font-size:12px;color:#9ca3af;">请滚动至底部后点击按钮</div>' +
      '</div>' +
    '</div>';

  var idx = layer.open({
    type: 1,
    skin: 'layui-layer-lan',
    title: 'FULLCONE NAT - 使用说明',
    area: '635px',
    offset: 'auto',
    shade: 0.8,
    resize: false,
    move: false,
    closeBtn: 0,
    content: scrollContainer,
    success: function(layero, index){
      var $scroll = $(layero).find('.fcx-readme-scroll');
      var $btn = $(layero).find('#fcx-readme-confirm');
      var $hint = $(layero).find('.fcx-readme-footer div');

      // 检测是否滚动到底部
      function checkScroll(){
        var scrollTop = $scroll.scrollTop();
        var scrollHeight = $scroll[0].scrollHeight;
        var clientHeight = $scroll.height();

        // 允许5px的误差
        if (scrollTop + clientHeight >= scrollHeight - 5){
          $btn.prop('disabled', false)
              .css({
                'background': 'linear-gradient(135deg, #3b82f6 0%, #2563eb 100%)',
                'color': '#fff',
                'cursor': 'pointer',
                'box-shadow': '0 2px 8px rgba(59,130,246,0.3)'
              });
          $hint.text('感谢阅读').css('color', '#10b981');
        }
      }

      // 监听滚动事件
      $scroll.on('scroll', checkScroll);

      // 初次检测（内容可能不需要滚动）
      setTimeout(checkScroll, 100);

      // 按钮点击事件
      $btn.on('click', function(){
        if (!$(this).prop('disabled')){
          // 写入 dbus 标记，表示用户已阅读使用说明
          var id = parseInt(Math.random() * 100000000);
          var postData = {"id": id, "method": "dummy_script.sh", "params": [], "fields": {"fullcone_note": "1"}};
          $.ajax({
            type: "POST",
            url: "/_api/",
            data: JSON.stringify(postData),
            dataType: "json",
            async: false
          });
          // 更新本地 dbus 缓存
          dbus['fullcone_note'] = '1';
          layer.close(index);
        }
      });
    }
  });
}

function register_event(){
	$(".popup_bar_bg_ks").click(
		function() {
			count_down = -1;
		});
  $(window).resize(function(){
		var page_h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
		var page_w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
		if($('.popup_bar_bg_ks').css("visibility") == "visible"){
			document.scrollingElement.scrollTop = 0;
			var log_h = E("loadingBarBlock").clientHeight;
			var log_w = E("loadingBarBlock").clientWidth;
			var log_h_offset = (page_h - log_h) / 2;
			var log_w_offset = (page_w - log_w) / 2 + 90;
			$('#loadingBarBlock').offset({top: log_h_offset, left: log_w_offset});
		}
	});
}

function check_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "fullcone_status.sh", "params":[''], "fields": ""};
	$.ajax({
		type: "POST",
		url: "/_api/",
		async: true,
		data: JSON.stringify(postData),
		success: function (response) {
			E("fullcone_status").innerHTML = response.result;
			setTimeout("check_status();", 10000);
		},
		error: function(){
			E("fullcone_status").innerHTML = "获取运行状态失败";
			setTimeout("check_status();", 5000);
		}
	});
}

// 取消后端视图解析：前端直接解析 ticket


function save(flag){
	var db_fullcone = {};
	if(flag){
		console.log(flag)
		db_fullcone["fullcone_enable"] = flag;
	}else{
		db_fullcone["fullcone_enable"] = "0";
	}
	for (var i = 0; i < params_check.length; i++) {
			db_fullcone[params_check[i]] = E(params_check[i]).checked ? '1' : '0';
	}
	for (var i = 0; i < params_input.length; i++) {
		if (E(params_input[i])) {
			db_fullcone[params_input[i]] = E(params_input[i]).value;
		}
	}
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "fullcone_config.sh", "params": ["web_submit"], "fields": db_fullcone};
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response) {
                if(response.result == id){
                    // 常规保存不改倒计时；延长授权场景已在具体入口设置 _fcx_countdown_override
                    get_log();
                }
		}
	});
}

// Activate with the entered license code via local auth script
	function boost_now(step){
	    var code = (E('fullcone_key') && E('fullcone_key').value || '').trim();
	    if (!code) {
	        layer.msg('请输入激活码');
	        return;
	    }
	    var id = parseInt(Math.random() * 100000000);
	    // 方案A：不再透传任何“购买/延长提示字段”，由后端通过“旧ticket + 新ticket”自行计算日志
	    var fields = { 'fullcone_key': code };
	    var postData = { id: id, method: 'fullcone_auth.sh', params: ['activate'], fields: fields };
	    E('ok_button').style.visibility = 'hidden';
	    showALLoadingBar();
	    // tail the log written by fullcone_auth.sh
	    $.ajax({
	        type: 'POST', url: '/_api/', data: JSON.stringify(postData), dataType: 'json',
	        success: function(resp){ try{ window._fcx_ext_hint=null; window._fcx_buy_hint=null; }catch(e){} var f = (step===3?2:1); get_log(f); },
	        error: function(){ try{ window._fcx_ext_hint=null; window._fcx_buy_hint=null; }catch(e){} var f = (step===3?2:1); get_log(f); }
	    });
	}

function get_log(flag){
	E("ok_button").style.visibility = "hidden";
	showALLoadingBar();
  $.ajax({
      url: '/_temp/fullcone_log.txt',
      type: 'GET',
      cache:false,
      dataType: 'text',
        success: function(response) {
            var retArea = E("log_content");
            if (response.search("XU6J03M16") != -1) {
                retArea.value = response.myReplace("XU6J03M16", " ");
                E("ok_button").style.visibility = "visible";
                retArea.scrollTop = retArea.scrollHeight;
                // 前端不再回填/清空授权码输入框，改由后端 fullcone_auth.sh 统一恢复
              // 优先使用前端覆盖的倒计时（例如延长授权激活后 10 秒自动关闭）
              if (typeof window._fcx_countdown_override === 'number' && window._fcx_countdown_override > 0){
                  count_down = window._fcx_countdown_override;
                    refresh_flag = 1;
                    try{ window._fcx_countdown_override = null; }catch(e){}
                } else {
                    if(flag == 1){
                        count_down = -1;
                        refresh_flag = 0;
                    }else{
                        count_down = 10;
                        refresh_flag = 1;
                    }
                }
                count_down_close();
                return false;
            }
			setTimeout("get_log(" + flag + ");", 500);
			retArea.value = response.myReplace("XU6J03M16", " ");
			retArea.scrollTop = retArea.scrollHeight;
		},
		error: function(xhr) {
			E("loading_block_title").innerHTML = "暂无日志信息 ...";
			E("log_content").value = "日志文件为空，请关闭本窗口！";
			E("ok_button").style.visibility = "visible";
			return false;
		}
	});
}

function showALLoadingBar(){
	document.scrollingElement.scrollTop = 0;
	E("loading_block_title").innerHTML = "&nbsp;&nbsp;FULLCONE NAT 日志信息";
	E("LoadingBar").style.visibility = "visible";
	var page_h = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
	var page_w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
	var log_h = E("loadingBarBlock").clientHeight;
	var log_w = E("loadingBarBlock").clientWidth;
	var log_h_offset = (page_h - log_h) / 2;
	var log_w_offset = (page_w - log_w) / 2 + 90;
	$('#loadingBarBlock').offset({top: log_h_offset, left: log_w_offset});
}
function hideALLoadingBar(){
	E("LoadingBar").style.visibility = "hidden";
	E("ok_button").style.visibility = "hidden";
	if (refresh_flag == "1"){
		refreshpage();
	}
}
function count_down_close() {
	if (count_down == "0") {
		hideALLoadingBar();
	}
	if (count_down < 0) {
		E("ok_button1").value = "手动关闭"
		return false;
	}
	E("ok_button1").value = "自动关闭（" + count_down + "）"
		--count_down;
	setTimeout("count_down_close();", 1000);
}

// Force refresh current page without query string (remove ?key=... to avoid re-triggering activation)
function refreshpage() {
	try {
		var url = window.location.protocol + '//' + window.location.host + window.location.pathname;
		window.location.replace(url);
	} catch(e){ location.href = location.pathname; }
}

function close() {
	if (confirm('确定马上关闭吗.?')) {
		showLoading(2);
		refreshpage(2);
		var id = parseInt(Math.random() * 100000000);
		var postData = { "id": id, "method": "fullcone_config.sh", "params": ["stop"], "fields": "" };
		$.ajax({
			url: "/_api/",
			cache: false,
			type: "POST",
			dataType: "json",
			data: JSON.stringify(postData)
		});
	}
}

function get_run_log(){
	if(STATUS_FLAG == 0) return;
	$.ajax({
		url: '/_temp/fullcone_run_log.txt',
		type: 'GET',
		dataType: 'html',
		async: true,
		cache: false,
		success: function(response) {
			var retArea = E("log_content_fullcone");
			if (_responseLen == response.length) {
				noChange++;
			} else {
				noChange = 0;
			}
			if (noChange > 10) {
				return false;
			} else {
				setTimeout("get_run_log();", 1500);
			}
			retArea.value = response;

			if(E("fullcone_stop_log").checked == false){
				retArea.scrollTop = retArea.scrollHeight;
			}
			_responseLen = response.length;
		},
		error: function(xhr) {
			E("log_pannel_title").innerHTML = "暂无日志信息 ...";
			E("log_content_fullcone").value = "日志文件为空，请关闭本窗口！";
			setTimeout("get_run_log();", 5000);
		}
	});
}
function hide_log_pannel(){
	E("log_pannel_div").style.visibility = "hidden";
	STATUS_FLAG = 0;
}
function open_fullcone_hint(itemNum) {
    // New concise hints (1..7). Return early; legacy content below will never run.
    statusmenu = "";
    width = "620px";
    if (itemNum == 1) {
        statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;显示 FULLCONE NAT 是否已注入内核规则（PREROUTING/POSTROUTING）。<br/><br/>"
                   + "&nbsp;&nbsp;&nbsp;&nbsp;状态仅反映当前iptables规则与内核模块是否就绪；实际NAT是否实现需要用第三方工具测试。<br/><br/>"
                   + "&nbsp;&nbsp;&nbsp;&nbsp;如显示未启用：先确认已“开启插件”，若仍失败，请查看日志排查依赖、内核模块及固件兼容性。";
        _caption = "运行状态";
    } else if (itemNum == 2) {
        statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;显示本机授权信息，具体授权信息可以在激活后点击“已激活”按钮查看。<br/><br/>"
                   + "&nbsp;&nbsp;&nbsp;&nbsp;若过期，会显示“授权过期”，可通过购买或试用继续使用。";
        _caption = "授权信息";
    } else if (itemNum == 3) {
        statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;在此粘贴授权码：支持 <b>fc_</b>（激活码）或 <b>fx_</b>（兑换码）。<br/><br/>"
                   + "&nbsp;&nbsp;&nbsp;&nbsp;提交激活码/兑换码后将自动联网完成激活/兑换；<br/><br/>"
                   + "&nbsp;&nbsp;&nbsp;&nbsp;试用/赠送授权不可反激活；购买授权（含兑换购购买）支持按档位的反激活次数。";
        _caption = "授权码";
    } else if (itemNum == 4) {
        statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;选择 FULLCONE NAT 写入策略：<b>基础模式</b>或<b>端口随机</b>。<br/><br/>"
                   + "&nbsp;&nbsp;&nbsp;&nbsp;插件会改写NAT表 PREROUTING/POSTROUTING 规则为 FULLCONENAT，加载对应内核模块/扩展。";
        _caption = "FULLCONE NAT 方案";
    } else if (itemNum == 5) {
        statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;又称 NAT Loopback：允许内网主机通过“路由器公网 IP/域名”访问内网服务。<br/><br/>"
                   + "&nbsp;&nbsp;&nbsp;&nbsp;如需在 LAN 访问自己映射到公网的端口/域名，请开启；双 NAT 或特定运营商环境可能需额外调整。";
        _caption = "Hairpin NAT";
    } else if (itemNum == 6) {
        statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;稳定优先：在保持端口不变的情况下启用 FULLCONE NAT。<br/><br/>"
                   + "&nbsp;&nbsp;&nbsp;&nbsp;适合大多数场景，兼容性最好。建议首先尝试此模式。";
        _caption = "基础模式";
    } else if (itemNum == 7) {
        statusmenu = "&nbsp;&nbsp;&nbsp;&nbsp;为出站连接进行端口随机化，增强隐私与对等端兼容性。<br/><br/>"
                   + "&nbsp;&nbsp;&nbsp;&nbsp;可能影响对固定源端口有依赖的应用（如特定端口转发策略），如遇问题请切回“基础模式”。";
        _caption = "端口随机";
    }
    return overlib(statusmenu, OFFSETX, 10, OFFSETY, 10, RIGHT, STICKY, WIDTH, 'width', CAPTION, _caption, CLOSETITLE, '');
}
function mOver(obj, hint){
	$(obj).css({
		"color": "#00ffe4",
		"text-decoration": "underline"
	});
	open_fullcone_hint(hint);
}
function mOut(obj){
	$(obj).css({
		"color": "#fff",
		"text-decoration": ""
	});
	E("overDiv").style.visibility = "hidden";
}
// Determine whether to use jump-pay (avoid https page embedding http pay server)
function fcx_use_jump_pay(){
    var m = '';
    try{ m = (dbus && dbus['fullcone_pay_mode']) ? String(dbus['fullcone_pay_mode']).toLowerCase() : ''; }catch(e){ m = ''; }
    var isHttps = (location && location.protocol === 'https:');
    if (isHttps) return true;
    if (m === 'jump' || m === 'redirect') return true;
    if (m === 'inline') return false;
    return false;
}
function fcx_open_jump_pay(params){
    var qs = [];
    params = params || {};
    // 明确告知服务端当前为跳转支付场景
    params['pay_scene'] = 'jump';
    for (var k in params){
        if (!params.hasOwnProperty(k)) continue;
        if (params[k] === undefined || params[k] === null) continue;
        qs.push(encodeURIComponent(k)+'='+encodeURIComponent(params[k]));
    }
    var url = 'http://'+pay_server+':'+pay_port+'/fullcone_purchase.php?' + qs.join('&');
    try{ window.open(url, '_blank'); }catch(e){ location.href = url; }
    try{ layer.msg('已为你打开支付页面，请在新窗口完成支付'); }catch(e){}
}
// Purchase entry: choose plan and payment provider, then redirect to server
function open_buy() {
	var current_url = window.location.href;
	var net_address = current_url.split("/Module")[0];
    var plans = [
            { id: 'buy_1y', name: '1年', price: '9.99' },
            { id: 'buy_2y', name: '2年', price: '17.99' },
            { id: 'buy_3y', name: '3年', price: '25.99' },
            { id: 'buy_4y', name: '4年', price: '33.99' },
            { id: 'buy_life', name: '终身', price: '39.99' }
    ];
      var html = "<div class='fcx-modal'><div class='fcx-wrap'>"+
            "<div class='fcx-header'><div style='font-size:18px;font-weight:700'>FULLCONE NAT 授权购买</div></div>"+
            "<div class='fcx-sub'>请选择授权时长：</div>"+
            "<div class='fcx-grid'>"+
              plans.map(function(p,idx){ var skin=p.id.replace(/^buy_/,''); return "<div class='fcx-card fcx-"+skin+" "+(idx==0?"active2":"")+"' data-plan='"+p.id+"'><div class='fcx-name'>"+p.name+"</div><div class='fcx-price'>￥"+p.price+"</div></div>";}).join('')+
            "</div>"+
            "<div class='fcx-tip' id='fcx-plan-desc'>1年授权，初始反激活次数 0 次。</div>"+
            "<div class='fcx-tip' id='fcx-plan-prev' style='color:#1f2937'></div>"+
            "<input type='radio' name='fc_plan' id='fc_plan_hidden' value='buy_1y' checked style='display:none'>"+
            "<div class='fcx-split'></div>"+
            "<div class='fcx-actions fcx-center' style='margin-bottom:6px'>"+
              "<div class='fcx-btn primary' id='fcx-wechat'><img class='fcx-ico' src='/res/fullcone_wechatpay.png' alt=''>微信支付</div>"+
              "<div class='fcx-btn success' id='fcx-alipay'><img class='fcx-ico' src='/res/fullcone_alipay.png' alt=''>支付宝</div>"+
              "<div class='fcx-btn warn' id='fcx-trial'><img class='fcx-ico' src='/res/fullcone_tryfree.png' alt=''>试用3天</div>"+
            "</div>"+
          "</div></div>";
      var idx = layer.open({ type:1, skin:'layui-layer-lan', shade:0.8, title:'选择购买方案与支付方式', time:0, area:'840px', offset:'230px', btnAlign:'c', resize:false, closeBtn:1, shadeClose:true, content:html,
          success: function(layero, index){
            // 购买预览：遵循试用/赠送覆盖规则
            function labelPlan(p){ if(!p) return ''; if(p==='trial3')return '试用3天'; if(p.indexOf('gift_')===0){ var x=p.substr(5); if(x==='30d')return '赠送30天'; if(x==='1y')return '赠送1年'; if(x==='2y')return '赠送2年'; if(x==='3y')return '赠送3年'; if(x==='4y')return '赠送4年'; return '赠送'+x; } if(p.indexOf('buy_')===0){ var x=p.substr(4); if(x==='1y')return '购买1年'; if(x==='2y')return '购买2年'; if(x==='3y')return '购买3年'; if(x==='4y')return '购买4年'; if(x==='life')return '购买终身'; return '购买'+x; } var map={'1y':'购买1年','2y':'购买2年','3y':'购买3年','4y':'购买4年','5y':'购买5年'}; return map[p]||p; }
            // 购买预览：不再显示"升级到某档位"，改为剩余天数/到期/反激活次数
            function baseDays(p){ var m={'buy_1y':365,'buy_2y':730,'buy_3y':1095,'buy_4y':1460,'buy_life':1825,'1y':365,'2y':730,'3y':1095,'4y':1460,'5y':1825}; return m[p]||0; }
            function baseRL(p){ var m={'buy_1y':1,'buy_2y':2,'buy_3y':3,'buy_4y':4,'buy_life':4,'1y':1,'2y':2,'3y':3,'4y':4,'5y':4}; return m[p]||0; }
            function fmtDate(ts){ if(!ts) return ''; var d=new Date(ts*1000); var y=d.getFullYear(),m=('0'+(d.getMonth()+1)).slice(-2),dd=('0'+d.getDate()).slice(-2); return y+'-'+m+'-'+dd; }
            function updatePreviewBuy(lo){
                 var cur = dbus['fullcone_ticket']?parseTicket(dbus['fullcone_ticket']):null;
                 var nowTs = Math.floor(Date.now()/1000);
                 var curExp = cur&&cur.exp_ts?parseInt(cur.exp_ts,10):0;
                 var curRL = (cur&&cur.react_left!=null)?parseInt(cur.react_left,10):0;
                 var ctype = cur && (cur.type||cur.plan||'') || '';
                 var curValid = (curExp && curExp > nowTs);
                 var showCurrent = curValid && (ctype==='trial' || (typeof ctype==='string' && ctype.indexOf('trial')===0) || ctype==='gift' || (typeof ctype==='string' && ctype.indexOf('gift')===0));
                 // 终身判断：兼容两种约定的终身时间戳（4102415999/4102444799）
                 var isLife = (curExp && curExp >= 4102358400);
                 // 统一与顶部按钮一致：向上取整
                 var curRemainDays = isLife ? null : Math.max(0, Math.ceil((curExp - nowTs)/86400));
                 var curExpStr = isLife ? '<span class=\"life-badge\">永不过期</span>' : (curExp?fmtDate(curExp):'');
                 var pSel = $('#fc_plan_hidden').val()||'buy_1y';
                 var addDays = baseDays(pSel);
                 var LIFE_THRESH = 1795;
                 var becomeLife = false; // 不以 plan 决定“终身”，仅以天数阈值判断
                 // 试用/赠送购买为覆盖：不叠加现有剩余天数
                 var coverMode = showCurrent; // trial/gift 时为 true，已购买为 false
                 var newRemainDays, newExpTs, newExpStr;
                 if (isLife){
                   newRemainDays = '无限期'; newExpStr = '<span class=\"life-badge\">永不过期</span>';
                 } else {
                   var base = coverMode ? 0 : ((curRemainDays!=null)?curRemainDays:0);
                   var total = base + addDays;
                   if (!becomeLife && total < LIFE_THRESH){ newRemainDays = total; newExpTs = nowTs + total*86400; newExpStr = fmtDate(newExpTs); }
                   else { newRemainDays = '无限期'; newExpStr = '<span class=\"life-badge\">永不过期</span>'; }
                 }
                 var buyBaseRL = (function(pp){ if(pp==='buy_life') return 4; if(pp==='buy_4y'||pp==='4y') return 3; if(pp==='buy_3y'||pp==='3y') return 2; if(pp==='buy_2y'||pp==='2y') return 1; return 0; })(pSel);
                 var newRL = buyBaseRL;
                 var shortCn=(function(pp){ if(!pp) return ''; if(pp==='buy_life') return '<span class="life-badge">终身</span>'; if(pp==='buy_4y'||pp==='4y') return '4年'; if(pp==='buy_3y'||pp==='3y') return '3年'; if(pp==='buy_2y'||pp==='2y') return '2年'; if(pp==='buy_1y'||pp==='1y') return '1年'; return pp; })(pSel);
                 // 统一为"变化对比"一行文案：购买[x年]后，预计授权变化：授权剩余天数 A → B，到期日：a → b，反激活次数：x → y
                 var beforeDaysTxt = isLife ? '<span class="life-badge">终身</span>' : (curRemainDays!=null?curRemainDays:0);
                 var afterDaysTxt  = (newRemainDays==='无限期') ? '<span class="life-badge">终身</span>' : newRemainDays;
                 var beforeDateTxt = isLife ? '<span class="life-badge">永不过期</span>' : (curExp?fmtDate(curExp):'');
                 var afterDateTxt  = (newExpStr && newExpStr.indexOf('永不过期')>=0) ? '<span class="life-badge">永不过期</span>' : newExpStr;
                 var msg = '<div class="fcx-diff">购买['+shortCn+']后，预计授权变化：'
                         + '授权剩余天数 '+beforeDaysTxt+' <span class="arr">→</span> '+afterDaysTxt
                         + '；到期日：'+(beforeDateTxt||'')+' <span class="arr">→</span> '+(afterDateTxt||'')
                         + '；反激活次数：'+curRL+' <span class="arr">→</span> '+newRL+'</div>';
                 $(lo).find('#fcx-plan-prev').html(msg);
             }
            // 卡片点击与初始化
            $(layero).find('.fcx-card').on('click', function(){
              $(layero).find('.fcx-card').removeClass('active2'); $(this).addClass('active2');
              var p=$(this).data('plan'); $('#fc_plan_hidden').val(p).prop('checked', true);
              var desc;
              if(p==='buy_life') desc='终身授权，初始反激活次数 4 次。';
              else if(p==='buy_4y') desc='4年授权，初始反激活次数 3 次。';
              else if(p==='buy_3y') desc='3年授权，初始反激活次数 2 次。';
              else if(p==='buy_2y') desc='2年授权，初始反激活次数 1 次。';
              else /* buy_1y 默认 */ desc='1年授权，初始反激活次数 0 次。';
              $(layero).find('#fcx-plan-desc').text(desc);
              updatePreviewBuy(layero);
              // 点击终身卡片时启动庆祝特效，点击其它卡片时关闭
              if(p==='buy_life'){ try{ fcxCelebrate(0); }catch(e){} }
              else { try{ fcxStopCelebrate(); }catch(e){} }
            });
            // trial-expired actions: buy/deactivate
            $(layero).on('click','#fcx-buy', function(){ try{ layer.close(index);}catch(e){} open_buy(); });
            $(layero).on('click','#fcx-deact', function(){ try{ layer.close(index);}catch(e){} open_deactivate_confirm(); });
            updatePreviewBuy(layero);
            // 购买弹窗内：试用3天
            $(layero).on('click','#fcx-trial', function(){
              try{ fcxStopCelebrate(); }catch(e){} // 关闭庆祝特效
              try{ layer.close(index);}catch(e){}
              var id = parseInt(Math.random() * 100000000);
              var postData = { id: id, method: 'fullcone_auth.sh', params: ['trial'], fields: {} };
              try{ E('ok_button').style.visibility = 'hidden'; showALLoadingBar(); window._fcx_countdown_override = 10; }catch(e){}
              $.ajax({ type:'POST', url:'/_api/', data: JSON.stringify(postData), dataType:'json', success:function(){ get_log(2); }, error:function(){ get_log(2); } });
            });
        // 支付方式：支持两种逻辑（保留旧跳转；或内联二维码+轮询）
        function fcx_build_buy_req(plan, paytype){
          var req = { action:'order_create', plan:plan, paytype:paytype, router: net_address, mac: router_mac, model: router_model };
          try{
            var cur = dbus['fullcone_ticket']?parseTicket(dbus['fullcone_ticket']):null;
            var ctype = (cur&&cur.type)?cur.type:(cur&&cur.plan?cur.plan:'');
            var codeLocal = dbus['fullcone_key']||'';
            if (ctype==='trial' && codeLocal){ req.op='extend'; req.code=codeLocal; }
          }catch(e){}
          return req;
        }
        function open_inline_pay(plan, paytype){
          var titleTxt = (plan==='buy_life'?'终身':(plan==='buy_4y'?'4年':(plan==='buy_3y'?'3年':(plan==='buy_2y'?'2年':'1年'))));
          var req = fcx_build_buy_req(plan, paytype);
          $.ajax({ type:'POST', url:'http://'+pay_server+':'+pay_port+'/api_fullcone.php', data: req, dataType:'json', timeout: 10000,
            success: function(r){
              if (!r || r.status!=='ok'){ layer.msg(r && r.message ? r.message : '创建订单失败'); return; }
              var od = r.order_id || ''; var qr = r.qr_addr || r.qr_url || ''; var expSec = r.qr_expire || 300; var aoid=r.qr_aoid||''; var price=r.price||''; var plan_key=r.plan_key||'';
              // 使用服务端支付页作为二维码渲染（iframe），避免在路由器内引入额外 QR 库
              var payUrl = 'http://'+pay_server+':'+pay_port+'/fullcone_purchase.php?name=' + encodeURIComponent('FULLCONE NAT 授权（'+titleTxt+'）')
                          + '&pay_type=' + encodeURIComponent(r.pay_type||'')
                          + '&price=' + encodeURIComponent(price)
                          + '&qr_expire=' + encodeURIComponent(expSec)
                          + '&qr_aoid=' + encodeURIComponent(aoid)
                          + '&order_id=' + encodeURIComponent(od)
                          + '&plan=' + encodeURIComponent(plan_key||'')
                          + '&router_addr=' + encodeURIComponent(net_address)
                          + '&qr_addr=' + encodeURIComponent(qr);
              var box = "<div class='fcx-modal fcx-pay' style='width:100%;height:100%'><div class='fcx-wrap'>"+
                         "<div class='fcx-header'><div class='fcx-icon'></div><div style='font-size:16px;font-weight:700'>FULLCONE NAT 授权购买 - 请扫码支付（"+titleTxt+"）</div></div>"+
                        "<div class='fcx-iframe' style='display:flex;justify-content:center;margin-top:6px'><iframe src='"+payUrl+"' style='width:100%;height:100%;border:0;'></iframe></div>"+
                        "<div class='fcx-footer'>"+
                          "<div class='fcx-tip' id='fcx-pay-tip' style='text-align:center'>等待支付中…</div>"+
                          "<div class='fcx-kv' style='justify-content:center;margin-top:6px'><div class='item'>订单号：<span id='od'>"+od+"</span></div></div>"+
                          "<div class='fcx-actions fcx-center' style='margin-top:6px'><div class='fcx-btn' id='fcx-recheck'>我已支付，立即核对</div></div>"+
                         "</div>"+
                       "</div></div>";
              var boxIdx = layer.open({ type:1, skin:'layui-layer-lan', title:'扫码支付', area:['100%','100%'], offset:'0px', shade:0.8, resize:false, content:box, success:function(lo){
                  try{ layer.full(boxIdx); }catch(e){}
                  try{ $(lo).closest('.layui-layer-content').css('overflow','hidden'); $('html,body').css('overflow','hidden'); }catch(e){}
                  // auto-close on QR expire and return to plan selection
                  var expTimer = setTimeout(function(){ try{ layer.close(boxIdx);}catch(e){} layer.msg('二维码已过期，请重新选择后支付'); }, (expSec*1000)+800);
                  function fcx_fitIframe(){
                    try{
                      var h = $(window).height();
                      var used = 0; $(lo).find('.fcx-header,.fcx-footer').each(function(){ used += $(this).outerHeight(true) || 0; });
                      var pad = 24 + 80; var v = Math.max(320, h - used - pad);
                      $(lo).find('.fcx-iframe iframe').height(v);
                    }catch(e){}
                  }
                  setTimeout(fcx_fitIframe, 0);
                  $(window).on('resize.fcx_buy', fcx_fitIframe);
                  $(lo).on('remove', function(){ $(window).off('resize.fcx_buy'); if(expTimer){ clearTimeout(expTimer);} try{ $('html,body').css('overflow',''); }catch(e){} });
                  var tmr = null; var busy=false; function pollOnce(force){ if(busy) return; busy=true; $.ajax({ url:'http://'+pay_server+':'+pay_port+'/api_fullcone.php', type:'GET', data:{ action:'order_status', order_id: od }, dataType:'json', timeout:8000,
                      success:function(s){
                        var tip = $('#fcx-pay-tip');
                        if (!s || s.status!=='ok'){ tip.text((s && s.message) ? s.message : '查询失败，稍后自动重试…'); busy=false; return; }
              if (s.issued){
                  tip.text('支付完成，准备激活...');
                  // 关闭所有 layer 弹窗（强制两次+延迟一次），避免遮挡后续日志窗口
                  try{ layer.closeAll(); }catch(e){}
                  setTimeout(function(){ try{ layer.closeAll(); }catch(e){} }, 30);
                  setTimeout(function(){ try{ layer.closeAll(); }catch(e){} }, 120);
                  // 若尚未发放授权码（极端竞态），不触发激活，直接提示联系邮箱
                  if (!s.code){
                    try{
                      showALLoadingBar();
                      var now = new Date();
                      var ts = now.getFullYear()+"-"+('0'+(now.getMonth()+1)).slice(-2)+"-"+('0'+now.getDate()).slice(-2)+" "+('0'+now.getHours()).slice(-2)+":"+('0'+now.getMinutes()).slice(-2)+":"+('0'+now.getSeconds()).slice(-2);
                      E('loading_block_title').innerHTML = '&nbsp;&nbsp;FULLCONE NAT 日志信息';
                      var ta = E('log_content');
                      ta.value = '【'+ts+'】: 购买已完成，但暂未发放授权码\n请联系客服邮箱：mjy211@gmail.com';
                      E('ok_button').style.visibility='visible';
                      try{ window._fcx_countdown_override = 10; }catch(e){}
                    }catch(e){}
                    return;
                  }
                  // 将授权码写入输入框
                  try{ E('fullcone_key').value = s.code; }catch(e){}
                  // 购买覆盖提示：仅透传本次购买的天数与反激活次数，避免被误识别为“延长叠加”
                  try{ window._fcx_buy_hint = { days: parseInt(s.grant_days||0,10)||0, react: parseInt(s.grant_react||0,10)||0 }; }catch(e){}
                  setTimeout(function(){ boost_now(3); }, 100);
                  return;
              }
                        if (s.paid){ tip.html('支付已完成，正在等待平台通知…<br>已启用自动重试补发'); } else { tip.text('等待支付中…'); }
                        busy=false;
                      }, error:function(){ busy=false; }
                  }); }
                  tmr = setInterval(function(){ pollOnce(false); }, 2000);
                  $(lo).on('click','#fcx-recheck', function(){
                    if(busy) return false;
                    busy=true;
                    $.ajax({ url:'http://'+pay_server+':'+pay_port+'/api_fullcone.php', type:'POST', data:{ action:'order_issue', order_id: od }, dataType:'json', timeout:8000,
                      complete:function(){ busy=false; pollOnce(true); }
                    });
                    return false;
                  });
                  $(lo).on('remove', function(){ if(tmr){ clearInterval(tmr); tmr=null; } });
              }});
            }, error:function(){ layer.msg('创建订单失败：网络异常'); }
          });
        }
        $(layero).find('#fcx-wechat').on('click', function(){
          try{ fcxStopCelebrate(); }catch(e){} // 关闭庆祝特效
          var plan=$("input[name='fc_plan']:checked").val();
          if (fcx_use_jump_pay()){
            var req = fcx_build_buy_req(plan, 1); delete req.action;
            fcx_open_jump_pay(req);
          } else {
            open_inline_pay(plan, 1);
          }
        });
        $(layero).find('#fcx-alipay').on('click', function(){
          try{ fcxStopCelebrate(); }catch(e){} // 关闭庆祝特效
          var plan=$("input[name='fc_plan']:checked").val();
          if (fcx_use_jump_pay()){
            var req2 = fcx_build_buy_req(plan, 2); delete req2.action;
            fcx_open_jump_pay(req2);
          } else {
            open_inline_pay(plan, 2);
          }
        });
            // 移除重复绑定，试用事件已通过委托绑定在上方
	  }
	});
}
// NAT 类型测试入口已下线（仅移除前端入口，保留服务器实现供后续完善）

// Unified extend authorization flow (for both expired/trial/gift and active buy scenarios)
function open_extend_unified(sourceCode){
  var current_url = window.location.href;
  var net_address = current_url.split("/Module")[0];

  // 检测当前是否为购买类型的终身授权用户
  var cur = dbus['fullcone_ticket']?parseTicket(dbus['fullcone_ticket']):null;
  var curExp = cur&&cur.exp_ts?parseInt(cur.exp_ts,10):0;
  var curType = (cur&&cur.type)?cur.type:(cur&&cur.plan?cur.plan:'');
  var isCurrentLife = (curExp && curExp >= 4102358400);
  var isBuyType = (curType==='buy' || (typeof curType==='string' && curType.indexOf('buy')===0));

  // 定义套餐列表
  var allPlans=[{id:'1y',name:'1年',price:'9.99'},{id:'2y',name:'2年',price:'17.99'},{id:'3y',name:'3年',price:'25.99'},{id:'4y',name:'4年',price:'33.99'},{id:'5y',name:'5年',price:'39.99'}];
  // 购买类型的终身授权用户：不显示1年套餐
  var plans = (isCurrentLife && isBuyType) ? allPlans.filter(function(p){return p.id!=='1y';}) : allPlans;

  // 根据套餐数量调整弹窗宽度
  var modalWidth = plans.length === 4 ? '720px' : '840px';

  // 默认选中第一个套餐（购买类型终身授权用户时为2年，否则为1年）
  var defaultPlan = plans.length > 0 ? 'buy_'+plans[0].id : 'buy_1y';

  // 套餐说明文字（购买类型终身授权用户显示2-5年，其他用户显示1-5年）
  var planDescText = (isCurrentLife && isBuyType)
    ? "延长套餐：2/3/4/5年分别增加反激活次数 1/2/3/4 次，延长后天数叠加超过1795天自动转为终身授权。"
    : "延长套餐：1/2/3/4/5年分别增加反激活次数 0/1/2/3/4 次，延长后天数叠加超过1795天自动转为终身授权。";

  // 购买类型的终身授权用户才显示提示
  var lifeTip = (isCurrentLife && isBuyType) ? "<div class='fcx-tip' style='color:#2e7d32;background:#e8f5e9;border:1px solid #81c784;padding:8px 10px;border-radius:6px;margin:10px 0 6px 0;font-weight:600'>⚠️ 注意：终身授权后再次购买延长授权不叠加使用时长，只叠加反激活次数！</div>" : "";

  var ext = "<div class='fcx-modal'><div class='fcx-wrap'>"+
    "<div class='fcx-header'><div class='fcx-icon'></div><div style='font-weight:700'>延长授权</div></div>"+
    lifeTip+
    "<div class='fcx-grid"+(plans.length===4?" fcx-grid-4":"")+"'>"+plans.map(function(p,idx){return "<div class='fcx-card fcx-"+p.id+" "+(idx==0?"active2":"")+"' data-plan='"+p.id+"'><div class='fcx-name'>"+p.name+"</div><div class='fcx-price'>￥"+p.price+"</div></div>";}).join('')+"</div>"+
    "<div class='fcx-tip' id='fcx-plan-desc-ext'>"+planDescText+"</div>"+
    "<div class='fcx-tip' id='fcx-plan-prev-ext' style='color:#1f2937'></div>"+
    "<input type='radio' name='fc_plan' id='fc_plan_ext_unified' value='"+defaultPlan+"' checked style='display:none'>"+
    "<div class='fcx-split'></div>"+
    "<div class='fcx-actions fcx-center' style='margin-bottom:6px'><div class='fcx-btn primary' id='fcx-ext-wechat-unified'><img class='fcx-ico' src='/res/fullcone_wechatpay.png' alt=''>微信支付</div><div class='fcx-btn success' id='fcx-ext-alipay-unified'><img class='fcx-ico' src='/res/fullcone_alipay.png' alt=''>支付宝</div></div>"+
    "</div></div>";
  layer.open({ type:1, skin:'layui-layer-lan', title:'延长授权 - 选择套餐', area:modalWidth, offset:'230px', resize:false, content:ext,
    success:function(lo){
      function baseDays(p){ var m={'buy_1y':365,'buy_2y':730,'buy_3y':1095,'buy_4y':1460,'1y':365,'2y':730,'3y':1095,'4y':1460,'5y':1825}; return m[p]||0; }
      function extInc(p){ var m={'buy_1y':0,'buy_2y':1,'buy_3y':2,'buy_4y':3,'buy_5y':4,'1y':0,'2y':1,'3y':2,'4y':3,'5y':4}; return m[p]||0; }
      function fmtDate(ts){ if(!ts) return ''; var d=new Date(ts*1000); var y=d.getFullYear(),m=('0'+(d.getMonth()+1)).slice(-2),dd=('0'+d.getDate()).slice(-2); return y+'-'+m+'-'+dd; }
      function shortPlanCn(p){ if(!p) return ''; if(p==='buy_life'||p==='life') return '<span class="life-badge">终身</span>'; if(p==='buy_5y'||p==='5y') return '5年'; if(p==='buy_4y'||p==='4y') return '4年'; if(p==='buy_3y'||p==='3y') return '3年'; if(p==='buy_2y'||p==='2y') return '2年'; if(p==='buy_1y'||p==='1y') return '1年'; return p; }

      function updatePreviewUnified(lo){
        var cur = dbus['fullcone_ticket']?parseTicket(dbus['fullcone_ticket']):null;
        var nowTs = Math.floor(Date.now()/1000);
        var curExp = cur&&cur.exp_ts?parseInt(cur.exp_ts,10):0;
        var curRL = (cur&&cur.react_left!=null)?parseInt(cur.react_left,10):0;
        var curType = (cur&&cur.type)?cur.type:(cur&&cur.plan?cur.plan:'');
        var isLife = (curExp && curExp >= 4102358400);
        var isExpired = (curExp > 0 && curExp < nowTs);
        var isTrial = (curType==='trial' || (typeof curType==='string' && curType.indexOf('trial')===0));
        var isGift = (curType==='gift' || (typeof curType==='string' && curType.indexOf('gift')===0));
        // CRITICAL FIX: 过期/试用/赠送授权购买时，从今天开始计算，不叠加负数天数
        var shouldResetBase = (isExpired || isTrial || isGift);
        // 计算以“秒”为基准（与服务端一致），但展示剩余天数用向上取整（与顶部按钮一致）
        var remainSecs = (isLife || shouldResetBase) ? 0 : Math.max(0, (curExp - nowTs));
        var curRemainDaysShow = isLife ? null : (shouldResetBase ? 0 : Math.max(0, Math.ceil(remainSecs/86400)));

        fcLog('[延长授权] 当前状态: isExpired='+isExpired+', isTrial='+isTrial+', isGift='+isGift+', shouldResetBase='+shouldResetBase+', remainSecs='+remainSecs+', curRemainDaysShow='+curRemainDaysShow);

        var p = $(lo).find('#fc_plan_ext_unified').val()||'buy_1y';
        var addDays = baseDays(p);
        var LIFE_THRESH = 1795;
        var becomeLife = false; // 仅按累计天数达阈值判断终身
        var newRemainDays, newExpTs, newExpStr;

        if (isLife){
          newRemainDays = '无限期'; newExpStr = '<span class="life-badge">永不过期</span>';
        } else {
          // 阈值判断以 floor(remain/86400) 为准（与服务端一致）
          var totalDaysForThresh = Math.floor(remainSecs/86400) + addDays;
          if (!becomeLife && totalDaysForThresh < LIFE_THRESH){
            newExpTs = nowTs + remainSecs + addDays*86400;
            newRemainDays = Math.max(0, Math.ceil((newExpTs - nowTs)/86400));
            newExpStr = fmtDate(newExpTs);
          } else {
            newRemainDays = '无限期';
            newExpStr = '<span class="life-badge">永不过期</span>';
          }
        }

        var shortCn = shortPlanCn(p);
        // 过期/试用/赠送：反激活次数不叠加，按套餐从 0 重新计算
        var baseRL = shouldResetBase ? 0 : Math.max(0, curRL);
        var newRL = baseRL + extInc(p);
        var beforeDaysTxt = isLife ? '<span class="life-badge">终身</span>' : (shouldResetBase ? '0天(过期/试用/赠送)' : ((curRemainDaysShow!=null ? (curRemainDaysShow+'天') : '0天')));
        var afterLife = isLife || becomeLife || (newRemainDays==='无限期');
        var afterDaysTxt = afterLife ? '<span class="life-badge">终身</span>' : (newRemainDays+'天');
        var curDateTxt = isLife ? '<span class="life-badge">永不过期</span>' : (curExp?fmtDate(curExp):'');
        var newDateTxt = afterLife ? '<span class="life-badge">永不过期</span>' : (newExpTs?fmtDate(newExpTs): (typeof newExpStr==='string'?newExpStr:''));
        // 若符合"30天内补差价直升终身"权益，且当前选择为推荐档位，并且本次延长后将成为终身，则反激活次数为：4 - react_used
        try{
          if (window._fcx_upgrade30_eligible && window._fcx_rec_ext_plan){
            var sel = (p||'').replace(/^buy_/,'');
            var rec = (window._fcx_rec_ext_plan||'').replace(/^buy_/,'');
            if (sel === rec && afterLife){ newRL = 4 - (cur.react_used || 0); }
          }
        }catch(e){}
        var beforeRLTxt = shouldResetBase ? '0次(过期/试用/赠送不计入)' : (Math.max(0,curRL)+'次');
        var msg = '<div class="fcx-diff">延长['+shortCn+']后，授权天数：'+beforeDaysTxt+' <span class="arr">→</span> '+(afterLife?'<span class="life-badge">终身</span>':afterDaysTxt)+'；到期：'+curDateTxt+' <span class="arr">→</span> '+(afterLife?'<span class="life-badge">永不过期</span>':newDateTxt)+'；反激活数：'+beforeRLTxt+' <span class="arr">→</span> '+newRL+'次</div>';

        try{ window._fcx_ext_hint = window._fcx_ext_hint || {}; window._fcx_ext_hint.after_ts = (afterLife? (nowTs + 200*365*86400) : (newExpTs||0)); window._fcx_ext_hint.after_rl = newRL; }catch(e){}
        $(lo).find('#fcx-plan-prev-ext').html(msg);
      }

      // 自动选择推荐档位并检查30天补差价
      (function autoSelectUnified(){
        try{
          var cur = dbus['fullcone_ticket']?parseTicket(dbus['fullcone_ticket']):null;
          if (!cur) { updatePreviewUnified(lo); return; }
          var t = (cur.type||cur.plan||'');
          var isBuy = (t==='buy') || (typeof t==='string' && t.indexOf('buy')===0);
          var nowTs = Math.floor(Date.now()/1000);
          var curExp = cur&&cur.exp_ts?parseInt(cur.exp_ts,10):0;
          var isLife = (curExp && curExp>=4102358400);
          var isExpired = (curExp > 0 && curExp < nowTs);
          var isTrial = (t==='trial' || (typeof t==='string' && t.indexOf('trial')===0));
          var isGift = (t==='gift' || (typeof t==='string' && t.indexOf('gift')===0));

          // 仅对有效的购买授权自动推荐升级到终身
          if (!isBuy || isLife || isExpired || isTrial || isGift){ updatePreviewUnified(lo); return; }

          var curRemainDays = Math.max(0, Math.floor((curExp - nowTs)/86400));
          var LIFE_THRESH=1795;
          var days2life = LIFE_THRESH - curRemainDays;
          if (days2life <= 0){ updatePreviewUnified(lo); return; }

          var opts=[{id:'1y',d:365},{id:'2y',d:730},{id:'3y',d:1095},{id:'4y',d:1460},{id:'5y',d:1825}];
          var pick='1y';
          for (var i=0;i<opts.length;i++){ if (opts[i].d >= days2life){ pick=opts[i].id; break; } }
          $(lo).find('.fcx-card').removeClass('active2');
          $(lo).find('.fcx-card[data-plan="'+pick+'"]').addClass('active2');
          $('#fc_plan_ext_unified').val(pick).prop('checked', true);
          $(lo).find('.fcx-card .fcx-reco').remove();
          $(lo).find('.fcx-card[data-plan="'+pick+'"]').append('<div class="fcx-reco">推荐</div>');

          // 30天补差价判断
          window._fcx_rec_ext_plan = pick;
          fcLog('[30天补差价-统一] 开始判断条件, 推荐档位:', pick);
          var firstPurchaseAt = cur && cur.first_purchase_at ? cur.first_purchase_at : '';
          fcLog('[30天补差价-统一] 首次购买日期(first_purchase_at):', firstPurchaseAt);

          var eligible30 = false;
	          if (firstPurchaseAt){
	            // 使用 ISO 格式避免部分浏览器对 "YYYY-MM-DD HH:mm:ss" 解析不一致
	            var t0 = new Date(firstPurchaseAt+'T00:00:00');
	            if(!isNaN(t0.getTime())){
	              var diff = (Date.now()-t0.getTime())/86400000;
	              eligible30 = (diff <= 30.0001);
	              fcLog('[30天补差价-统一] 距今天数:', diff.toFixed(2), ', 是否30天内:', eligible30);
	            }
	          }

          window._fcx_upgrade30_eligible = eligible30;
          if (window._fcx_upgrade30_eligible){
            var priceNode = $(lo).find('.fcx-card[data-plan="'+pick+'"]').find('.fcx-price');
            var txt = priceNode.text().replace(/[^0-9.]/g,''); var pr = parseFloat(txt||'0');
            if (!isNaN(pr) && pr>0){
              var d=(Math.round((pr - 3.99) * 100) / 100).toFixed(2);
              priceNode.html('<span style="text-decoration:line-through;color:#888;margin-right:6px;">￥'+pr.toFixed(2)+'</span><span style="color:#d93025;font-weight:700">￥'+d+'</span>');
            }
            var tip = "首次购买激活后30天内购买延长授权至终身，优惠3.99元(补升级差价)";
            if ($(lo).find('#fcx-upgrade30-tip').length===0){
              $('<div id="fcx-upgrade30-tip" class="fcx-tip" style="color:#b91c1c;background:#fee2e2;border:1px solid #fecaca;padding:6px 8px;border-radius:6px;margin-bottom:6px;"></div>').insertBefore($(lo).find('.fcx-grid')).text(tip);
            }
          }
        }catch(e){ fcLog('[30天补差价-统一] 异常:', e); }
        updatePreviewUnified(lo);
      })();

      $(lo).find('.fcx-card').on('click', function(){
        $(lo).find('.fcx-card').removeClass('active2'); $(this).addClass('active2');
        var p=$(this).data('plan'); $('#fc_plan_ext_unified').val(p).prop('checked', true);
        updatePreviewUnified(lo);
        // 点击5年卡片时启动庆祝特效（延长至终身），点击其它卡片时关闭
        if(p==='5y'){ try{ fcxCelebrate(0); }catch(e){} }
        else { try{ fcxStopCelebrate(); }catch(e){} }
      });

      function fcx_build_extend_req(plan, paytype, sourceCode){
        var req = { action:'order_create', plan:plan, paytype:paytype, router: net_address, op:'extend', code: sourceCode, mac: router_mac, model: router_model };
        try{
          if (window._fcx_rec_ext_plan && (plan===window._fcx_rec_ext_plan || plan===('buy_'+window._fcx_rec_ext_plan)) && window._fcx_upgrade30_eligible){
            req.upgrade = 1;
            fcLog('[30天补差价-统一] 设置upgrade=1');
          }
        }catch(ex){ fcLog('[30天补差价-统一] upgrade判断异常:', ex); }
        return req;
      }
      function open_inline_extend_unified(plan, paytype){
        var titleTxt = (function(pp){
          if(pp==='5y'||pp==='buy_5y') return '5年';
          if(pp==='4y'||pp==='buy_4y') return '4年';
          if(pp==='3y'||pp==='buy_3y') return '3年';
          if(pp==='2y'||pp==='buy_2y') return '2年';
          return '1年';
        })(plan);
        var req = fcx_build_extend_req(plan, paytype, sourceCode);
        fcLog('[30天补差价-统一] 发送请求:', req);

        $.ajax({ type:'POST', url:'http://'+pay_server+':'+pay_port+'/api_fullcone.php', data: req, dataType:'json', timeout: 10000,
          success: function(r){
            fcLog('[30天补差价-统一] 服务器响应:', r);
            if(!r||r.status!=='ok'){ layer.msg(r&&r.message?r.message:'创建订单失败'); return; }
            var od=r.order_id||''; var qr=r.qr_addr||r.qr_url||''; var expSec=r.qr_expire||300; var aoid=r.qr_aoid||''; var price=r.price||''; var plan_key=r.plan_key||''; var opType=r.op||'extend';
            fcLog('[30天补差价-统一] 服务器返回op:', opType);
            if (opType === 'upgrade'){ titleTxt = '终身补差价'; fcLog('[30天补差价-统一] 套餐名称改为:', titleTxt); }

            var payUrl='http://'+pay_server+':'+pay_port+'/fullcone_purchase.php?name='+encodeURIComponent('FULLCONE NAT 授权（'+titleTxt+'）')+'&pay_type='+encodeURIComponent(r.pay_type||'')+'&price='+encodeURIComponent(price)+'&qr_expire='+encodeURIComponent(expSec)+'&qr_aoid='+encodeURIComponent(aoid)+'&order_id='+encodeURIComponent(od)+'&plan='+encodeURIComponent(plan_key||'')+'&router_addr='+encodeURIComponent(net_address)+'&qr_addr='+encodeURIComponent(qr)+'&op='+encodeURIComponent(opType);
            var box="<div class='fcx-modal fcx-pay' style='width:100%;height:100%'><div class='fcx-wrap'>"+
              "<div class='fcx-header'><div class='fcx-icon'></div><div style='font-size:16px;font-weight:700'>FULLCONE NAT 授权延长 - 请扫码支付（"+titleTxt+"）</div></div>"+
              "<div class='fcx-iframe' style='display:flex;justify-content:center;margin-top:6px'><iframe src='"+payUrl+"' style='width:100%;height:100%;border:0;'></iframe></div>"+
              "<div class='fcx-footer'>"+
                "<div class='fcx-tip' id='fcx-pay-tip-unified' style='text-align:center'>等待支付中…</div>"+
                "<div class='fcx-kv' style='justify-content:center;margin-top:6px'><div class='item'>订单号：<span id='od-unified'>"+od+"</span></div></div>"+
                "<div class='fcx-actions fcx-center' style='margin-top:6px'><div class='fcx-btn' id='fcx-recheck-unified'>我已支付，立即核对</div></div>"+
              "</div></div></div>";
            var bI = layer.open({ type:1, skin:'layui-layer-lan', title:'扫码支付（延长授权）', area:['100%','100%'], offset:'0px', shade:0.8, resize:false, content:box,
              success:function(lo2){
                try{ layer.full(bI);}catch(e){}
                try{ $(lo2).closest('.layui-layer-content').css('overflow','hidden'); $('html,body').css('overflow','hidden'); }catch(e){}
                function fcx_fitIframe(){ try{ var h=$(window).height(); var used=0; $(lo2).find('.fcx-header,.fcx-footer').each(function(){ used+=$(this).outerHeight(true)||0; }); var pad=24+80; var v=Math.max(320,h-used-pad); $(lo2).find('.fcx-iframe iframe').height(v);}catch(e){} }
                setTimeout(fcx_fitIframe,0); $(window).on('resize.fcx_ext_unified',fcx_fitIframe);

                var t=null; var bz=false;
                function poll(){
                  if(bz) return; bz=true;
                  $.ajax({ url:'http://'+pay_server+':'+pay_port+'/api_fullcone.php', type:'GET', data:{action:'order_status', order_id:od}, dataType:'json', timeout:8000,
                    success:function(s){
                      var tip=$('#fcx-pay-tip-unified');
                      if(!s||s.status!=='ok'){ tip.text((s&&s.message)?s.message:'查询失败，稍后自动重试…'); bz=false; return; }
                      if(s.issued){
                        tip.text('支付完成，准备激活...');
                        try{ layer.closeAll(); }catch(e){}
                        if(s.code){ try{ E('fullcone_key').value=s.code; }catch(e){} }
                        try{
                          showALLoadingBar();
                          var prev=(dbus['fullcone_ticket']?parseTicket(dbus['fullcone_ticket']).plan:'');
                          function label(p){ if(!p) return ''; if(p==='trial3') return '试用3天'; if(p.indexOf('gift_')===0){ var x=p.substr(5); if(x==='30d') return '赠送30天'; if(x==='life') return '赠送终身'; if(x==='1y')return '赠送1年'; if(x==='2y')return '赠送2年'; if(x==='3y')return '赠送3年'; if(x==='4y')return '赠送4年'; return '赠送'+x; } if(p.indexOf('buy_')===0){ var x=p.substr(4); if(x==='life') return '购买终身'; if(x==='1y')return '购买1年'; if(x==='2y')return '购买2年'; if(x==='3y')return '购买3年'; if(x==='4y')return '购买4年'; return '购买'+x; } return p; }
                          var nxt=label(s.plan||''); var prv=label(prev);
                          var msg='延长授权成功！['+prv+'] → ['+nxt+']<br>授权码保持不变：'+(s.code||'')+'<br>开始激活 FULLCONE NAT 延长授权...';
                          $('#loading_block_title').html(msg);
                          try{ window._fcx_ext_hint = { prev: prv, next: nxt, code: (s.code||'') }; window._fcx_countdown_override = 8; }catch(e){}
                        }catch(e){}
                        setTimeout(function(){ boost_now(3); }, 100);
                        return;
                      }
                      if(s.paid){ tip.html('支付已完成，正在等待平台通知…<br>已启用自动重试补发'); }
                      else { tip.text('等待支付中…'); }
                      bz=false;
                    },
                    error:function(){ bz=false; }
                  });
                }
                t=setInterval(function(){ poll(); },2000);
                var expTimer = setTimeout(function(){ try{ layer.close(bI);}catch(e){} layer.msg('二维码已过期，请重新选择后支付'); }, (expSec*1000)+800);
                $(lo2).on('click','#fcx-recheck-unified', function(){
                  if(bz) return false;
                  bz=true;
                  $.ajax({ url:'http://'+pay_server+':'+pay_port+'/api_fullcone.php', type:'POST', data:{ action:'order_issue', order_id: od }, dataType:'json', timeout:8000,
                    complete:function(){ bz=false; poll(); }
                  });
                  return false;
                });
                $(lo2).on('remove', function(){ if(t){ clearInterval(t); t=null; } if(expTimer){ clearTimeout(expTimer);} try{ $('html,body').css('overflow',''); }catch(e){} $(window).off('resize.fcx_ext_unified'); });
              }
            });
          },
          error:function(){ layer.msg('创建订单失败：网络异常'); }
        });
      }

      $(lo).find('#fcx-ext-wechat-unified').on('click', function(){
        try{ fcxStopCelebrate(); }catch(e){}
        var p=$("input[name='fc_plan']:checked").val();
        if (fcx_use_jump_pay()){
          var reqJ = fcx_build_extend_req(p,1,sourceCode); delete reqJ.action;
          fcx_open_jump_pay(reqJ);
        } else {
          open_inline_extend_unified(p,1);
        }
      });
      $(lo).find('#fcx-ext-alipay-unified').on('click', function(){
        try{ fcxStopCelebrate(); }catch(e){}
        var p=$("input[name='fc_plan']:checked").val();
        if (fcx_use_jump_pay()){
          var reqJ2 = fcx_build_extend_req(p,2,sourceCode); delete reqJ2.action;
          fcx_open_jump_pay(reqJ2);
        } else {
          open_inline_extend_unified(p,2);
        }
      });
    }
  });
}

// Expired license: show red-styled modal with retry trial button
function open_expired(isTrial){
	var code = dbus['fullcone_key'] || '';
            var tk = dbus['fullcone_ticket'] || '';
            var exp = '';
            var tkInfo = null;
            if (tk){ tkInfo=parseTicket(tk); if (tkInfo && tkInfo.exp) exp=tkInfo.exp; }
            var actAt = (tkInfo && (tkInfo.activated_at || tkInfo.activation_date)) ? (tkInfo.activated_at || tkInfo.activation_date) : '';
            var bmod = tkInfo && tkInfo.model ? tkInfo.model : '';
            var bmac = tkInfo && tkInfo.mac ? tkInfo.mac : '';
    // 仅展示“试用/赠送/购买”，不再展示 custom/档位等
    function labelType(p){
      if (!p) return '';
      var t = (p==='trial'||p==='gift'||p==='buy') ? p
        : ((''+p).indexOf('trial')===0 ? 'trial' : ((''+p).indexOf('gift')===0 ? 'gift' : ((''+p).indexOf('buy')===0 ? 'buy' : '')));
      if (t==='trial') return '试用';
      if (t==='gift') return '赠送';
      if (t==='buy') return '购买';
      return '';
    }
    var tval = (tkInfo && tkInfo.type) ? tkInfo.type : (tkInfo && tkInfo.plan ? tkInfo.plan : (dbus['fullcone_plan']||''));
    var typeText = labelType(tval);
    if (!typeText && isTrial) typeText = '试用';
	var html;
    if (isTrial){
        html = "<div class='fcx-modal'><div class='fcx-wrap'>"
             + "<div class='fcx-header'><div class='fcx-icon'></div><div style='font-size:18px;font-weight:700'>试用过期</div></div>"
             + "<div class='fcx-kv'>"
             + (typeText?"<div class='item'>类型："+typeText+"</div>":"")
             + (code?"<div class='item'>授权码：<span class='fcx-code'>"+code+"</span> <span class='fcx-link' id='fcx-copy-exp'>复制</span></div>":"")
             + (actAt?"<div class='item'>激活："+actAt+"</div>":"")
             + (exp?"<div class='item fcx-exp'>到期："+exp+"（已过期）</div>":"")
             + "<div class='item fcx-exp'>剩余天数：无</div>"
             + (bmod||bmac?"<div class='item'>设备："+bmod+" "+bmac+"</div>":"")
             + "</div><div class='fcx-split'></div>"
             + "<div class='fcx-tip' style='color:#7f1d1d;background:#fef2f2;border:1px solid #fecaca;padding:8px 10px;border-radius:6px;margin:4px 0;'>注意：购买将覆盖试用授权（不叠加时长）。</div>"
             + "<div class='fcx-actions fcx-center'>"
             +   "<div class='fcx-btn' id='fcx-buy'><img class='fcx-ico' src='/res/fullcone_purchase.png' alt=''>购买授权</div>"
             +   "<div class='fcx-btn' id='fcx-exp-trial'><img class='fcx-ico' src='/res/fullcone_tryfree.png' alt=''>试用3天</div>"
             + "</div>"
             + "</div></div>";
    } else {
        html = "<div class='fcx-modal'><div class='fcx-wrap'>"
             + "<div class='fcx-header'><div class='fcx-icon'></div><div style='font-size:18px;font-weight:700'>授权过期</div></div>"
             + "<div class='fcx-kv'>"
             + (typeText?"<div class='item'>类型："+typeText+"</div>":"")
             + (code?"<div class='item'>授权码：<span class='fcx-code'>"+code+"</span> <span class='fcx-link' id='fcx-copy-exp'>复制</span></div>":"")
             + (actAt?"<div class='item'>激活："+actAt+"</div>":"")
             + (exp?"<div class='item fcx-exp'>到期："+exp+"（已过期）</div>":"")
             + "<div class='item fcx-exp'>剩余天数：无</div>"
             + (bmod||bmac?"<div class='item'>设备："+bmod+" "+bmac+"</div>":"")
             + "</div><div class='fcx-split'></div>"
             + "<div class='fcx-actions fcx-center'>"
             +   "<div class='fcx-btn' id='fcx-exp-trial'><img class='fcx-ico' src='/res/fullcone_tryfree.png' alt=''>试用3天</div>"
             +   "<div class='fcx-btn' id='fcx-ext'><img class='fcx-ico' src='/res/fullcone-entend.png' alt=''>延长授权</div>"
             + "</div>"
             + "</div></div>";
    }
layer.open({ type:1, skin:'layui-layer-lan', shade:0.8, title:(isTrial?'FULLCONE NAT - 试用过期':'FULLCONE NAT - 授权过期'), area:'700px', offset:'230px', resize:false, content:html,
	  success:function(layero,index){
		$(layero).on('click','#fcx-copy-exp', function(){
		  var txt = code; if(!txt) return;
		  if (navigator.clipboard && navigator.clipboard.writeText){
			navigator.clipboard.writeText(txt).then(function(){ layer.msg('已复制授权码'); });
		  } else {
			try{ var ta=document.createElement('textarea'); ta.value=txt; document.body.appendChild(ta); ta.select(); document.execCommand('copy'); document.body.removeChild(ta); layer.msg('已复制授权码'); }catch(e){ layer.msg('复制失败，请手动复制'); }
		  }
		});
        $(layero).find('#fcx-exp-trial').on('click', function(){
          try{ layer.close(index); }catch(e){}
          var id = parseInt(Math.random() * 100000000);
              var postData = { id: id, method: 'fullcone_auth.sh', params: ['trial'], fields: {} };
              E('ok_button').style.visibility = 'hidden'; showALLoadingBar();
              // 试用成功后，前端倒计时 10 秒自动关闭
              try{ window._fcx_countdown_override = 10; }catch(e){}
              $.ajax({ type:'POST', url:'/_api/', data: JSON.stringify(postData), dataType:'json', success:function(){ get_log(2); }, error:function(){ get_log(2); } });
            });
        // 试用过期弹窗的“购买授权”按钮：打开购买方案弹窗
        $(layero).on('click', '#fcx-buy', function(){
          try{ layer.close(index); }catch(e){}
          open_buy();
        });
		$(layero).find('#fcx-ext').on('click', function(){
		  var codeLocal = dbus['fullcone_key'] || '';
		  open_extend_unified(codeLocal);
		});
      }
	});
}

// Trial active: show minimal info and a Buy button
function open_trial_info(){
  var code = dbus['fullcone_key'] || '';
  var tinfo = dbus['fullcone_ticket'] ? parseTicket(dbus['fullcone_ticket']) : null;
  var exp = (tinfo && tinfo.exp) ? tinfo.exp : '';
  var ets = (tinfo && tinfo.exp_ts) ? parseInt(tinfo.exp_ts,10) : 0;
  var react = (tinfo && (tinfo.react_left!=null)) ? parseInt(tinfo.react_left,10) : 0;
  var bmod = tinfo && tinfo.model ? tinfo.model : '';
  var bmac = tinfo && tinfo.mac ? tinfo.mac : '';
  var actAt = (tinfo && tinfo.activated_at) ? tinfo.activated_at : (function(){ var d=new Date(); var y=d.getFullYear(),m=('0'+(d.getMonth()+1)).slice(-2),dd=('0'+d.getDate()).slice(-2); return y+'-'+m+'-'+dd; })();
  // 试用弹窗也展示剩余天数（按天向上取整）
  var leftDays = (ets? Math.max(0, Math.ceil((ets - Math.floor(Date.now()/1000))/86400)) : 0);
  var html = "<div class='fcx-modal'><div class='fcx-wrap'>" 
           + "<div class='fcx-header'><div class='fcx-icon'>🔐</div><div style='font-size:16px;font-weight:600'>试用授权</div></div>"
           + "<div class='fcx-kv'>"
           +   "<div class='item'>类型：试用</div>"
           +   (code?"<div class='item'>授权码：<span class='fcx-code' id='fcx-trial-code'>"+code+"</span> <span class='fcx-link' id='fcx-trial-copy'>复制</span></div>":"")
           +   (actAt?"<div class='item'>激活："+actAt+"</div>":"")
           +   (exp?"<div class='item'>到期："+exp+"</div>":"")
           +   ((ets?"<div class='item'>剩余天数："+leftDays+"天</div>":""))
           +   "<div class='item'>反激活剩余："+react+"</div>"
           +   (bmod||bmac?"<div class='item'>设备："+bmod+" "+bmac+"</div>":"")
           + "</div><div class='fcx-split'></div>"
	           + "<div class='fcx-tip' style='color:#7f1d1d;background:#fef2f2;border:1px solid #fecaca;padding:8px 10px;border-radius:6px;margin:4px 0;'>"
	           +   "注意：购买将覆盖当前试用授权（不叠加时长）。"
	           + "</div>"
           + "<div class='fcx-actions fcx-center'><div class='fcx-btn' id='fcx-trial-buy'><img class='fcx-ico' src='/res/fullcone_purchase.png' alt=''>购买授权</div></div>"
           + "</div></div>";
  layer.open({ type:1, skin:'layui-layer-lan', title:'FULLCONE NAT - 试用中', area:'700px', offset:'230px', resize:false, content:html,
    success:function(lo,idx){
      $(lo).on('click','#fcx-trial-copy', function(){ try{ var v=$('#fcx-trial-code').text(); navigator.clipboard.writeText(v); layer.msg('已复制'); }catch(e){ layer.msg('复制失败'); } });
      $(lo).on('click','#fcx-trial-buy', function(){ try{ layer.close(idx);}catch(e){} open_buy(); });
    }
  });

}

// Already activated: show actions (extend, deactivate, query)
function open_info(){
  var code = dbus['fullcone_key'] || '';
  var current_url = window.location.href;
  var net_address = current_url.split("/Module")[0];
  // 内联渲染函数：采用函数声明，避免末尾额外的 `};` 造成括号失衡
  function render(info){
	  var masked = code; // show full code
  var tinfo = dbus['fullcone_ticket'] ? parseTicket(dbus['fullcone_ticket']) : null;
  var exp = (info && info.exp) ? info.exp : (tinfo && tinfo.exp ? tinfo.exp : '');
  // 终身授权显示：弹窗内显示“终身授权，永不过期”，列表/信息栏已改为“永久”
  var p  = (tinfo && tinfo.plan) ? tinfo.plan : (info && info.plan ? info.plan : '');
  var ets = (tinfo && tinfo.exp_ts) ? parseInt(tinfo.exp_ts,10) : (info && info.exp_ts ? parseInt(info.exp_ts,10) : 0);
  var isLife = false;
  (function(){
    try{
      if (p){ isLife = (p==='buy_life' || p==='gift_life' || p==='life'); }
      // 兼容不同服务端终身时间戳或日期：4102415999/4102444799 或 exp=2099-12-31
      if (!isLife){
        if (ets && ets >= 4102358400){ isLife = true; }
        else if (exp && (''+exp).indexOf('2099-12-31')===0){ isLife = true; }
      }
      if (isLife){ exp = "<span class=\"life-badge\">终身授权，永不过期</span>"; }
    }catch(e){}
  })();
	  var react = (tinfo && (tinfo.react_left!=null)) ? tinfo.react_left : ((info && (info.react_left!=null)) ? info.react_left : (dbus['fullcone_react_left']!=null ? dbus['fullcone_react_left'] : ''));
  var actAt = (tinfo && tinfo.activated_at) ? tinfo.activated_at : '';
  // 计算“剩余天数”（非终身时展示）
  var nowTs2 = Math.floor(Date.now()/1000);
  var leftDays2 = (!isLife && ets) ? Math.max(0, Math.ceil((ets - nowTs2)/86400)) : null;
	  var bmod = info && info.bound_model ? info.bound_model : '';
	  var bmac = info && info.bound_mac ? info.bound_mac : '';
    // 组装类型显示（仅 trial/gift/buy 三种）
    function labelType(p){
      if (!p) return '';
      // p 可能是 type，也可能是旧 plan；做一次归一化
      var t = (p==='trial'||p==='gift'||p==='buy') ? p
        : (p.indexOf('trial')===0 ? 'trial' : (p.indexOf('gift')===0 ? 'gift' : (p.indexOf('buy')===0 ? 'buy' : '')));
      if (t==='trial') return '试用'; if (t==='gift') return '赠送'; if (t==='buy') return '购买';
      return '';
    }
    var typeText = '';
    var tval = (tinfo && tinfo.type) ? tinfo.type : (tinfo && tinfo.plan ? tinfo.plan : (info && info.plan ? info.plan : (dbus['fullcone_plan']||'')));
    typeText = labelType(tval);
	    // 操作按钮区域：赠送授权仿照试用，仅提供“购买授权”；购买授权提供“延长/反激活”
	    // 新逻辑：当反激活次数为 0（或缺失）时，不展示“反激活”按钮
	    var rlNum = parseInt(react, 10);
	    var showDeact = (!isNaN(rlNum) && rlNum > 0);
	    var actionsHtml = "<div class='fcx-actions fcx-center'>"
	                    +   "<div class='fcx-btn' id='fcx-ext'><img class='fcx-ico' src='/res/fullcone-entend.png' alt=''>延长授权</div>"
	                    +   (showDeact ? "<div class='fcx-btn' id='fcx-deact'><img class='fcx-ico' src='/res/fullcone-deactive.png' alt=''>反激活</div>" : "")
	                    + "</div>";
    if (typeText==='赠送'){
      actionsHtml = "<div class='fcx-actions fcx-center'><div class='fcx-btn' id='fcx-buy'><img class='fcx-ico' src='/res/fullcone_purchase.png' alt=''>购买授权</div></div>";
    }
    var giftTip = '';
    if (typeText==='赠送'){
      giftTip = "<div class='fcx-tip' style='color:#7f1d1d;background:#fef2f2;border:1px solid #fecaca;padding:8px 10px;border-radius:6px;margin:4px 0;'>"+
                "注意：购买将覆盖当前赠送授权（不叠加时长）。"+
                "</div>";
    }
    var html = "<div class='fcx-modal'><div class='fcx-wrap'>"+
		"<div class='fcx-header'><div class='fcx-icon'>🔐</div><div style='font-size:16px;font-weight:600'>已激活</div></div>"+
		"<div class='fcx-kv'>"+
      (typeText?"<div class='item' id='fcx-type'>类型："+typeText+"</div>":"<div class='item' id='fcx-type'></div>") +
		  "<div class='item'>授权码：<span class='fcx-code' id='fcx-code'>"+masked+"</span> <span class='fcx-link' id='fcx-copy'>复制</span></div>"+
      (actAt?"<div class='item'>激活："+actAt+"</div>":"")+
      (exp?"<div class='item'>到期："+exp+"</div>":"")+
      ((!isLife && leftDays2!=null)?"<div class='item'>剩余天数："+leftDays2+"天</div>":"")+
      (react!==''?"<div class='item'>反激活剩余："+react+"</div>":"")+
		  (bmod||bmac?"<div class='item'>设备："+bmod+" "+bmac+"</div>":"")+
		"</div><div class='fcx-split'></div>"+
        giftTip+
		actionsHtml+
	  "</div></div>";
    layer.open({ type:1, skin:'layui-layer-lan', shade:0.8, title:'FULLCONE NAT - 已激活', area:'700px', offset:'230px', resize:false, content:html,
        success:function(layero, index){
          try{
            // 购买类型的终身授权：庆祝效果（彩带/烟花），持续 30s
            if (typeText==='购买' && isLife) { fcxCelebrate(30000); }
            // 关闭弹窗时停止动画（双保险：监听 remove 与 end 回调）
            $(layero).on('remove', function(){ try{ fcxStopCelebrate(); }catch(e){} });
          }catch(e){}
          // 绑定“复制授权码”按钮
          try{
            $(layero).on('click','#fcx-copy', function(){
              var txt = code;
              if (navigator.clipboard && navigator.clipboard.writeText){
                navigator.clipboard.writeText(txt).then(function(){ layer.msg('已复制授权码'); });
              } else {
                try{ var ta=document.createElement('textarea'); ta.value=txt; document.body.appendChild(ta); ta.select(); document.execCommand('copy'); document.body.removeChild(ta); layer.msg('已复制授权码'); }catch(e){ layer.msg('复制失败，请手动复制'); }
              }
            });
          }catch(e){}

          // 绑定"购买授权"按钮
          $(layero).find('#fcx-buy').on('click', function(){
            try{ layer.close(index); }catch(e){}
            open_buy();
          });

          // 绑定"延长授权"按钮
          $(layero).find('#fcx-ext').on('click', function(){
            try{ layer.close(index); }catch(e){}
            open_extend_unified(code);
          });

          // 绑定"反激活"按钮
          $(layero).find('#fcx-deact').on('click', function(){
	            if (!code) { layer.msg('未找到授权码'); return; }
	            var tinfo = dbus['fullcone_ticket'] ? parseTicket(dbus['fullcone_ticket']) : null;
	            var rl = tinfo && (tinfo.react_left!=null) ? parseInt(tinfo.react_left,10) : -1;
	            var ets = tinfo && tinfo.exp_ts ? parseInt(tinfo.exp_ts,10) : 0;
	            var nowTs = Math.floor(Date.now()/1000);
	            var p  = tinfo && tinfo.plan ? tinfo.plan : (dbus['fullcone_plan']||'');
	            var isGift  = p && p.indexOf('gift_')===0;
	            var isTrial = p && p.indexOf('trial')===0;
	            // 已过期授权：即便 ticket 里还有反激活次数，也视为 0 次，不允许反激活
	            if (ets > 0 && ets <= nowTs){
	              layer.alert('授权已过期，不支持反激活。如需在新设备使用，请重新购买。',{skin:'layui-layer-lan'});
	              return;
	            }
	            if (isGift || isTrial){
	              var msg = '该授权码来自试用/赠送，不可反激活。<br>如果希望获得反激活，请购买延长授权。';
	              layer.alert(msg,{skin:'layui-layer-lan'});
	              return;
	            }
            if (rl === 0){ layer.alert('该激活码反激活次数已用尽，不再支持授权释放。如需在新设备使用，请重新购买。',{skin:'layui-layer-lan'}); return; }
            var msgHtml = "<div class='fcx-deact-tip' style=\"color:#1f2937;font-size:13px;line-height:1.8;background:#fff;padding:12px 16px;\">"
                        + "<ul style=\"margin:0;padding-left:18px;list-style:disc\">"
                        + "<li style=\"margin-bottom:8px\">反激活可将激活码与本机解绑，解绑后该激活码可用于其他设备（或本机再次激活）。</li>"
                        + "<li style=\"margin-bottom:8px\">注意：反激活次数用尽后，该激活码将绑定在最后一次激活的设备，直至到期。</li>"
                        + "<li style=\"margin-bottom:8px\">如果你的反激活次数用光，可以通过购买延长授权来获得新的反激活次数。</li>"
                        + "</ul>"
                        + "<div style=\"margin-top:10px;color:#d93025;font-weight:600\">确认现在进行反激活吗？反激活后，本机会删除激活状态！（请提前复制授权码）</div>"
                        + "</div>";
            layer.open({ type:1, skin:'layui-layer-lan', title:'确认反激活', area:'520px', offset:'230px', resize:false, content:msgHtml, btn:['确认','取消'],
              yes:function(idx){
                layer.close(idx);
                try{ layer.closeAll(); }catch(e){}
                var id = parseInt(Math.random() * 100000000);
                var postData = { id: id, method: 'fullcone_auth.sh', params: ['deactivate'], fields: {} };
                E('ok_button').style.visibility = 'hidden'; showALLoadingBar();
                $.ajax({ type:'POST', url:'/_api/', data: JSON.stringify(postData), dataType:'json', success:function(){ get_log(2); }, error:function(){ get_log(2); } });
              }
            });
          });
        },
        end:function(){ try{ fcxStopCelebrate(); }catch(e){} }
    });
  }
  // 使用后端视图对象构造显示信息
  // 仅使用本地 ticket 构造显示信息
  var tinfo = dbus['fullcone_ticket'] ? parseTicket(dbus['fullcone_ticket']) : null;
  var info = null;
  if (tinfo){ info = { plan: tinfo.plan, exp: tinfo.exp, exp_ts: tinfo.exp_ts, react_left: tinfo.react_left, bound_model: tinfo.model, bound_mac: tinfo.mac, src: (tinfo.plan && tinfo.plan.indexOf('trial')===0)?'trial':'' }; }
  render(info);
}

  </script>
<script type="text/javascript">
// Simple confetti celebration for life-time purchased license
function fcxCelebrate(ms){
  try{
    // If exists, remove old to avoid stacking
    try{ var old=document.getElementById('fcx-confetti'); if(old&&old.parentNode){ old.parentNode.removeChild(old); } }catch(e){}
    var cv=document.createElement('canvas'); cv.id='fcx-confetti';
    cv.style.position='fixed'; cv.style.left='0'; cv.style.top='0';
    cv.style.width='100%'; cv.style.height='100%'; cv.style.pointerEvents='none';
    // Set extremely high z-index to be above layer shade/modal
    cv.style.zIndex='2147483647';
    document.body.appendChild(cv);
    var ctx=cv.getContext('2d'); var W=window.innerWidth, H=window.innerHeight; cv.width=W; cv.height=H;
    var parts=[]; var N=140;
    for(var i=0;i<N;i++){
      parts.push({
        x: Math.random()*W,
        y: Math.random()*-H,
        r: Math.random()*8+4,
        c: 'hsl('+Math.floor(Math.random()*360)+',85%,60%)',
        vx: (Math.random()*2-1)*1.2,
        vy: Math.random()*2+2.5,
        rot: Math.random()*6.28
      });
    }
    var start=Date.now();
    window.__fcx_confetti_stop = false;
    function step(){
      var t = Date.now()-start; ctx.clearRect(0,0,W,H);
      for(var i=0;i<parts.length;i++){
        var p=parts[i]; p.x+=p.vx; p.y+=p.vy; p.vy+=0.03; p.rot+=0.1;
        if (p.y>H){ p.y=-10; p.vy=Math.random()*2+2.5; p.x=Math.random()*W; }
        ctx.save(); ctx.translate(p.x,p.y); ctx.rotate(p.rot); ctx.fillStyle=p.c; ctx.fillRect(-p.r/2,-p.r/2,p.r,p.r); ctx.restore();
      }
      if (!window.__fcx_confetti_stop && t < (ms||3000)) { requestAnimationFrame(step); }
      else { try{ document.body.removeChild(cv); }catch(e){} try{ window.removeEventListener('resize', window._fcx_confetti_resize); }catch(e){} window._fcx_confetti_resize=null; }
    }
    requestAnimationFrame(step);
    window._fcx_confetti_resize = function(){ W=window.innerWidth; H=window.innerHeight; cv.width=W; cv.height=H; };
    window.addEventListener('resize', window._fcx_confetti_resize);
  }catch(e){}
}

function fcxStopCelebrate(){
  try{ window.__fcx_confetti_stop = true; }catch(e){}
  try{ var cv=document.getElementById('fcx-confetti'); if(cv&&cv.parentNode){ cv.parentNode.removeChild(cv); } }catch(e){}
  try{ if (window._fcx_confetti_resize){ window.removeEventListener('resize', window._fcx_confetti_resize); window._fcx_confetti_resize=null; } }catch(e){}
}
</script>
  
<body id="app" skin="ASUSWRT" onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<div id="LoadingBar" class="popup_bar_bg_ks" style="z-index: 200;" >
		<table cellpadding="5" cellspacing="0" id="loadingBarBlock" class="loadingBarBlock" align="center">
			<tr>
				<td height="100">
					<div id="loading_block_title" style="margin:10px auto;margin-left:10px;width:85%; font-size:12pt;"></div>
					<div id="loading_block_spilt" style="margin:10px 0 10px 15px;" class="loading_block_spilt"></div>
					<div>
						<ul>
							<li><font color="#ffcc00">此处显示上次FULLCONE NAT插件的运行日志！</font></li>
						</ul>
					</div>
					<div style="margin-left:15px;margin-right:15px;margin-top:10px;outline: 1px solid #3c3c3c;overflow:hidden">
						<textarea cols="50" rows="25" wrap="off" readonly="readonly" id="log_content" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Lucida Console'; font-size:11px;background:transparent;color:#FFFFFF;outline: none;padding-left:5px;padding-right:22px;overflow-x:hidden;white-space:break-spaces;"></textarea>
					</div>
					<div id="ok_button" class="apply_gen" style="background:#000;visibility:hidden;">
						<input id="ok_button1" class="button_gen" type="button" onclick="hideALLoadingBar()" value="确定">
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div id="log_pannel_div" class="popup_bar_bg_ks" style="z-index: 200;" >
		<table cellpadding="5" cellspacing="0" id="log_pannel_table" class="loadingBarBlock" style="width:960px" align="center">
			<tr>
				<td height="100">
					<div style="text-align: center;font-size: 18px;color: #99FF00;padding: 10px;font-weight: bold;">FULLCONE NAT 日志</div>
					<div style="margin-left:15px"><i>🗒️此处展示fullcone程序的运行日志...</i></div>
					<div style="margin-left:15px;margin-right:15px;margin-top:10px;outline: 1px solid #3c3c3c;overflow:hidden">
						<textarea cols="50" rows="32" wrap="off" readonly="readonly" id="log_content_fullcone" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" style="border:1px solid #000;width:99%; font-family:'Lucida Console'; font-size:11px;background:transparent;color:#FFFFFF;outline: none;padding-left:5px;padding-right:22px;line-height:1.3;overflow-x:hidden;white-space:break-spaces;"></textarea>
					</div>
					<div id="ok_button_fullcone" class="apply_gen" style="background:#000;">
						<input class="button_gen" type="button" onclick="hide_log_pannel()" value="返回主界面">
						<input style="margin-left:10px" type="checkbox" id="fullcone_stop_log">
						<lable>&nbsp;暂停日志刷新</lable>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<iframe name="hidden_frame" id="hidden_frame" width="0" height="0" frameborder="0"></iframe>
	<!--=============================================================================================================-->
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
										<div class="formfonttitle">FULLCONE NAT <lable id="fullcone_version"></lable></div>
										<div style="float: right; width: 15px; height: 25px; margin-top: -20px">
											<img id="return_btn" alt="" onclick="reload_Soft_Center();" align="right" style="cursor: pointer; position: absolute; margin-left: -30px; margin-top: -25px;" title="返回软件中心" src="/images/backprev.png" onmouseover="this.src='/images/backprevclick.png'" onmouseout="this.src='/images/backprev.png'" />
										</div>
										<div style="margin: 10px 0 10px 5px;" class="splitLine"></div>
										<div class="SimpleNote">
											<span>使用此插件让你的网络轻松变为Full Cone（全锥形），即NAT1!</span>
											<span><a type="button" href="https://github.com/koolshare/rogsoft/blob/master/fullcone/Changelog.txt" target="_blank" class="ks_btn" style="margin-left:5px;" >更新日志</a></span>
											<span><a type="button" class="ks_btn" href="javascript:void(0);" onclick="get_log(1)" style="margin-left:5px;">插件日志</a></span>
											<span><a type="button" class="ks_btn" href="javascript:void(0);" id="note2user" style="margin-left:5px;">使用说明</a></span>
											<span><a type="button" class="ks_btn" href="javascript:void(0);" id="fcx-nat-test" style="margin-left:5px;">NAT类型检测</a></span>
										</div>
										<div id="fullcone_status_pannel">
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
													<tr>
														<td colspan="2">FULLCONE NAT - 状态</td>
													</tr>
												</thead>
												<tr id="fullcone_status_tr" style="display: none;">
													<th><a onmouseover="mOver(this, 1)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);">运行状态</a></th>
													<td>
														<span style="margin-left:4px" id="fullcone_status"></span>
													</td>
												</tr>
												<tr id="fullcone_authinfo_tr" style="display: none;">
													<th><a onmouseover="mOver(this, 2)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);">授权信息</a></th>
													<td>
														<span style="margin-left:4px" id="fullcone_auth_info"></span>
														<!--<span style="margin-left:4px" id="fullcone_webver"></span>-->
													</td>
												</tr>

											</table>
										</div>
										<div id="fullcone_setting_pannel" style="margin-top:10px">
											<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
												<thead>
													<tr>
														<td colspan="2">FULLCONE NAT - 设置</td>
													</tr>
												</thead>
												<tr>
            <th><a onmouseover="mOver(this, 4)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);"><em>FULLCONE NAT 方案</em></a></th>
													<td>
                        <input type="radio" name="fullcone_mode" id="fullcone_basic" onchange="show_hide_element();" class="input" checked=true><a onmouseover="mOver(this, 6)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);"><font color="#ffcc00">基础模式</font></a>
                        <input type="radio" name="fullcone_mode" id="fullcone_random" onchange="show_hide_element();" class="input"><a onmouseover="mOver(this, 7)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);"><font color="#ffcc00">端口随机</font></a>
													</td>
												</tr>
												<tr id="rand_tr">
													<th>端口随机设置</th>
													<td>
														端口范围:
														<input type="text" maxlength="200" id="fullcone_port_start" class="input_6_table" spellcheck="false" style="width:40px;" value="40000">
														-
														<input type="text" maxlength="200" id="fullcone_port_end" class="input_6_table" spellcheck="false" style="width:40px;" value="60000">&nbsp;&nbsp;
														端口随机方式:
														<select id="fullcone_rand_method" class="input_option" style="width:auto;margin:0px 0px 0px 2px;">
															<option value="1">--random</option>
															<option value="2">--random-fully</option>
														</select>
													</td>
												</tr>
												<tr>
            <th><a onmouseover="mOver(this, 5)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);">Hairpin</a></th>
													<td>
														<input type="checkbox" id="fullcone_hairpin" style="vertical-align:middle;" checked=true>
                                            &nbsp;
													</td>
												</tr>
												<tr>
													<th><a onmouseover="mOver(this, 3)" onmouseout="mOut(this)" class="hintstyle" href="javascript:void(0);">授权码</a></th>
													<td>
<input type="text" maxlength="100" id="fullcone_key" class="input_ss_table fcx-mask" title="此处输入FULLCONE NAT插件激活码或者兑换码！" style="width:340px;font-size:95%;" readonly onfocus="this.removeAttribute('readonly');toggleKeyMask(true);" onblur="toggleKeyMask(false);" data-lpignore="true" data-1p-ignore="true" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" >
														<button id="fullcone_active_btn" onclick="boost_now(3);" class="ks_btn" style="width:50px;cursor:pointer;vertical-align: middle;">激活</button>
														<button id="fullcone_buy_btn" onclick="open_buy();" class="ks_btn" style="width:80px;cursor:pointer;vertical-align: middle;">试用 / 购买</button>
														<button id="fullcone_authorized_btn" onclick="open_info();" class="ks_btn" style="width:80px;cursor:pointer;vertical-align: middle;">已激活</button>
													</td>
												</tr>
											</table>
										</div>
										<div id="fullcone_apply" class="apply_gen">
											<input class="button_gen" style="display: none;" id="fullcone_apply_btn_1" onClick="save(1)" type="button" value="开启" />
											<input class="button_gen" style="display: none;" id="fullcone_apply_btn_2" onClick="save(2)" type="button" value="重启" />
											<input class="button_gen" style="display: none;" id="fullcone_apply_btn_3" onClick="save(0)" type="button" value="关闭" />
										</div>
										<div style="margin: 10px 0 10px 5px;" class="splitLine"></div>
										<div style="margin:10px 0 0 0px;display:none;">
											<ul>
											<li>如有不懂，特别是fullcone配置文件的填写，请查看fullcone官方文档<a href="https://fullcone.nn.ci/zh/" target="_blank"><em>点这里看文档</em></a></li>
											<li>插件使用有任何问题请加入<a href="https://t.me/xbchat" target="_blank"><em><u>koolcenter TG群</u></em></a>或<a href="https://t.me/meilinchajian" target="_blank"><em><u>Mc Chat TG群</u></em></a>联系 @fiswonder<br></li>
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
