const fs=require('fs'),vm=require('vm'),assert=require('assert');
const html=fs.readFileSync(process.argv[2],'utf8');
const source=html.match(/<script>([\s\S]*?)<\/script>/)[1];
function controller(model){
 const nodes={},calls=[];
 function elt(id){return nodes[id]||(nodes[id]={style:{},value:'',text(v){this.value=v;return this},prop(k,v){if(v===undefined)return this[k];this[k]=v;return this},show(){this.style.display='';return this},on(k,fn){this[k]=fn;return this}})}
 function $(s){return elt(s.slice(1))} $.ajax=x=>calls.push(x);
 const c={$,E:elt,setTimeout(){},window:{location:{href:'http://router/Module_rog.asp'}}};vm.createContext(c);
 const js=source.replace(/<%cpu_core_num\(\);%>/g,'4').replace(/<% nvram_get\("odmpid"\); %>/g,model).replace(/<%[\s\S]*?%>/g,'');
 vm.runInContext(js,c);
 ['show_menu','set_skin','detect_CPU_RAM','showbootTime','showclock','fan_ctrl'].forEach(k=>c[k]=()=>{});c.init();return{c,calls,nodes};
}
let p=controller('GS7');assert.equal(p.calls.length,2);assert.equal(JSON.parse(p.calls[1].data).params[0],'wifi_power');p.calls[1].success({result:'off@@data:25.5'});assert(/2.4 GHz：无线已关闭\n5 GHz：数据帧最高目标 25.5 dBm/.test(p.nodes.rog_wl_power.value));
p.calls[0].success({result:'55°C@@5G 45°C@@@@1800@@5.4.281@@aarch64@@2026'});assert(p.nodes.rog_wl_power.value.includes('25.5'));p.calls[1].complete();p.nodes.rog_wl_power_refresh.click();assert.equal(p.calls.length,3);p.calls[2].success({result:'unavailable@@busy'});assert(p.nodes.rog_wl_power.value.includes('无法读取'));assert(p.nodes.rog_wl_power.value.includes('正在查询'));p.calls[2].complete();assert.equal(p.nodes.rog_wl_power_refresh.disabled,false);
p=controller('TX-AX6000');p.calls[1].success({result:'28.0,28.0@@27.5,26.0'});assert(p.nodes.rog_wl_power.value.includes('管理帧 26.0 dBm'));
p=controller('RT-AX88U');assert.equal(p.calls.length,1);p.calls[0].success({result:'55°C@@2G/5G@@legacy@@1800@@4.19@@arm@@2026'});assert.equal(p.nodes.rog_wl_power.innerHTML,'legacy');
console.log('ROG frontend: GS7 data-only, disabled radio, errors, refresh, polling isolation, TX-AX6000 and legacy passed');
