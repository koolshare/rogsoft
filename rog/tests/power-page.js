const fs = require('fs'), vm = require('vm'), assert = require('assert');
const html = fs.readFileSync(process.argv[2], 'utf8');
const source = html.match(/<script>([\s\S]*?)<\/script>/)[1];
const notes = html.match(/<div class="SimpleNote">[\s\S]*?<\/div>/g);
assert(notes[notes.length - 1].includes('id="rog_wl_power_note"'));
assert(!html.includes('Wi-Fi 发射目标功率'));
assert(!html.includes('无线固件逐速率表的最高目标值，用于前后对比；不是仪器实测功率。'));
assert(html.includes('<th id="rog_wl_power_label">发射功率</th>'));
function controller(model, product) {
 const nodes = {}, calls = [];
 function elt(id) {
  return nodes[id] || (nodes[id] = {
   style: {}, value: '',
   text(v) { this.value = v; return this; },
   prop(k, v) { if (v === undefined) return this[k]; this[k] = v; return this; },
   show() { this.style.display = ''; return this; },
   on(k, fn) { this[k] = fn; return this; }
  });
 }
 function $(s) { return elt(s.slice(1)); }
 $.ajax = x => calls.push(x);
 const c = { $, E: elt, setTimeout() {}, window: { location: { href: 'http://router/Module_rog.asp' } } };
 vm.createContext(c);
 const js = source.replace(/<%cpu_core_num\(\);%>/g, '4')
  .replace(/<% nvram_get\("odmpid"\); %>/g, model)
  .replace(/<% nvram_get\("productid"\); %>/g, product || model)
  .replace(/<%[\s\S]*?%>/g, '');
 vm.runInContext(js, c);
 ['show_menu', 'set_skin', 'detect_CPU_RAM', 'showbootTime', 'showclock', 'fan_ctrl'].forEach(k => c[k] = () => {});
 c.init();
 return { c, calls, nodes };
}
assert(!html.includes('rog_wl_power_refresh'));
assert(!html.includes('get_mtk_wifi_power'));
assert(!html.includes('"wifi_power"'));
let p = controller('GS7');
assert.equal(p.calls.length, 1);
assert.equal(JSON.parse(p.calls[0].data).params[0], 2);
assert.equal(p.calls[0].timeout, 20000);
p.calls[0].success({ result: '55°C@@5G 45°C@@2.4 GHz：无线已关闭；5 GHz：25.5 dBm@@1800@@5.4.281@@aarch64@@2026' });
assert.equal(p.nodes.rog_wl_power.value, '2.4 GHz：无线已关闭；5 GHz：25.5 dBm');
assert.equal(p.nodes.rog_wl_power_note.style.display, '');
p.calls[0].success({ result: '55°C@@5G 46°C@@2.4 GHz：无线已关闭；5 GHz：24.5 dBm@@1800@@5.4.281@@aarch64@@2026' });
assert.equal(p.nodes.rog_wl_power.value, '2.4 GHz：无线已关闭；5 GHz：24.5 dBm');
assert.equal(p.nodes.rog_kernel.innerHTML, '5.4.281');
for (const model of ['TUF-AX4200', 'TUF-AX4200Q', 'TX-AX6000', 'TUF-AX6000', 'RT-AX57_Go', 'RT-AX57-Go', 'RT-AX57 Go', 'PRT-AX57_GO', 'GS7_Air', 'GS7_AIR', 'GS7 Air', 'GS7_MAGIC', 'GS-BE7200X']) {
 p = controller(model);
 assert.equal(p.calls.length, 1);
 p.calls[0].success({ result: '55°C@@2G/5G@@2.4 GHz：28.0 dBm；5 GHz：27.5 dBm@@1800@@5.4.246@@aarch64@@2026' });
 assert.equal(p.nodes.rog_wl_power.value, '2.4 GHz：28.0 dBm；5 GHz：27.5 dBm');
 assert(!p.nodes.rog_wl_power.value.includes('管理帧'));
}
for (const model of ['ZenWiFi_BT8P', 'BT8P', 'ZenWiFi BT8P']) {
 p = controller(model);
 assert.equal(p.calls.length, 1);
 p.calls[0].success({ result: '55°C@@three bands@@2.4 GHz：26.0 dBm；5 GHz-1：27.0 dBm；5 GHz-2：28.0 dBm@@1800@@5.4.281@@aarch64@@2026' });
 assert.equal(p.nodes.rog_wl_power.value, '2.4 GHz：26.0 dBm；5 GHz-1：27.0 dBm；5 GHz-2：28.0 dBm');
}
for (const product of ['TUF-AX4200', 'TUF-AX4200Q', 'TUF-AX6000', 'TX-AX6000', 'RT-AX57_Go', 'RT-AX57-Go', 'RT-AX57 Go', 'PRT-AX57_GO', 'GS7', 'GS7_Air', 'GS7_AIR', 'GS7 Air', 'GS7_MAGIC', 'GS-BE7200X', 'ZenWiFi_BT8P', 'BT8P', 'ZenWiFi BT8P']) {
 p = controller('', product);
 assert.equal(p.calls.length, 1, product);
 assert(p.c.mtkWifiPowerSupported);
}
for (const model of ['RT-AX88U', 'RT-AX57', 'GS7_PRO', 'UNKNOWN_MTK']) {
 p = controller(model);
 assert.equal(p.calls.length, 1, model);
 p.calls[0].success({ result: '55°C@@2G/5G@@legacy@@1800@@4.19@@arm@@2026' });
 assert.equal(p.nodes.rog_wl_power.innerHTML, 'legacy');
}
console.log('ROG power UI: one status request, automatic power updates, no refresh button, aliases and legacy passed');
