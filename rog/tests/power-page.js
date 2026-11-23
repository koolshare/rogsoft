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
let p = controller('GS7');
assert.equal(p.calls.length, 2);
assert.equal(JSON.parse(p.calls[1].data).params[0], 'wifi_power');
p.calls[1].success({ result: 'off@@data:25.5' });
assert.equal(p.nodes.rog_wl_power.value, '2.4 GHz：无线已关闭；5 GHz：25.5 dBm');
assert.equal(p.nodes.rog_wl_power_note.style.display, '');
p.calls[0].success({ result: '55°C@@5G 45°C@@@@1800@@5.4.281@@aarch64@@2026' });
assert.equal(p.nodes.rog_wl_power.value, '2.4 GHz：无线已关闭；5 GHz：25.5 dBm');
p.calls[1].complete();
p.nodes.rog_wl_power_refresh.click();
assert.equal(p.calls.length, 3);
p.calls[2].success({ result: 'unavailable@@busy' });
assert(p.nodes.rog_wl_power.value.includes('无法读取'));
assert(p.nodes.rog_wl_power.value.includes('正在查询'));
p.calls[2].complete();
assert.equal(p.nodes.rog_wl_power_refresh.disabled, false);
for (const model of ['TUF-AX4200', 'TUF-AX4200Q', 'TX-AX6000', 'TUF-AX6000']) {
 p = controller(model);
 p.calls[1].success({ result: 'data:28.0@@data:27.5' });
 assert.equal(p.nodes.rog_wl_power.value, '2.4 GHz：28.0 dBm；5 GHz：27.5 dBm');
 assert(!p.nodes.rog_wl_power.value.includes('管理帧'));
}
for (const product of ['TUF-AX4200', 'TUF-AX4200Q', 'TUF-AX6000', 'TX-AX6000', 'GS7']) {
 p = controller('', product);
 assert.equal(p.calls.length, 2, product);
}
for (const model of ['RT-AX88U', 'UNKNOWN_MTK', 'GS7_Air', 'ZenWiFi_BT8P']) {
 p = controller(model);
 assert.equal(p.calls.length, 1, model);
 p.calls[0].success({ result: '55°C@@2G/5G@@legacy@@1800@@4.19@@arm@@2026' });
 assert.equal(p.nodes.rog_wl_power.innerHTML, 'legacy');
}
console.log('ROG power UI: concise values, lower SimpleNote, default query, refresh, polling isolation, model aliases and legacy passed');
