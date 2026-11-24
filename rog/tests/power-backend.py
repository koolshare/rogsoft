#!/usr/bin/env python3
"""Exercise exact-model routing and parsing without changing router state."""
from pathlib import Path
import os
import subprocess
import tempfile
import re
import json

script = (Path(__file__).resolve().parents[1] / 'rog/scripts/rog_status.sh').read_text()

def function(name):
    start = script.index(name + '(){')
    return script[start:script.index('\n}\n', start) + 3]

stubs = '''
nvram(){
    case "$2" in
        odmpid) printf '%s' "$ROG_TEST_ODM" ;;
        productid) printf '%s' "$ROG_TEST_PRODUCT" ;;
    esac
}
get_mtk_temperature(){ printf 'temperature:%s' "${mtk_power_backend}"; }
get_tmp_pwr_mtk(){ printf 'temperature:iwpriv'; }
get_tmp_pwr_MT7988X(){ printf 'temperature:mwctl'; }
get_tmp_pwr_ipq(){ printf 'temperature:ipq'; }
get_tmp_pwr_qca(){ printf 'temperature:qca'; }
get_tmp_pwr_hnd(){ printf 'temperature:hnd'; }
'''
routing = stubs + '\n' + '\n'.join(function(n) for n in (
    '_get_model', 'get_mtk_power_backend', 'get_tmp_pwr')) + '''
if get_mtk_power_backend; then
    printf '%s|%s|' "$mtk_power_backend" "$mtk_power_5g"
else
    printf 'unsupported||'
fi
get_tmp_pwr
'''
wifi6 = ('TUF-AX4200', 'TUF-AX4200Q', 'TUF-AX6000', 'TX-AX6000', 'RT-AX57_Go', 'RT-AX57-Go', 'RT-AX57 Go', 'PRT-AX57_GO')
wifi7 = ('GS7', 'GS7_Air', 'GS7_AIR', 'GS7 Air', 'GS7_MAGIC', 'GS-BE7200X')
triband = ('ZenWiFi_BT8P', 'BT8P', 'ZenWiFi BT8P')
for model in wifi6 + wifi7 + triband:
    expected = ('iwpriv|rax0|temperature:iwpriv' if model in wifi6
                else 'mwctl|rai0|temperature:mwctl')
    for odm, product in ((model, model), ('', model)):
        env = dict(os.environ, ROG_TEST_ODM=odm, ROG_TEST_PRODUCT=product)
        actual = subprocess.check_output(['sh', '-c', routing], env=env, text=True)
        assert actual == expected, (odm, product, actual)
# Keep power support in step with the MTK list maintained by the software center.
installer = (Path(__file__).resolve().parents[2] / 'softcenter/softcenter/install.sh').read_text().splitlines()
mtk_line = next(i for i, line in enumerate(installer) if 'local SC_URL=https://mtksoft.ddnsto.com' in line)
center_models = re.findall(r'\$\{RO_MODEL\}" == "([^\"]+)"', installer[mtk_line - 1])
assert center_models
for model in center_models:
    assert model in wifi6 + wifi7 + triband, model
    env = dict(os.environ, ROG_TEST_ODM=model, ROG_TEST_PRODUCT=model)
    actual = subprocess.check_output(['sh', '-c', routing], env=env, text=True)
    assert not actual.startswith('unsupported'), (model, actual)

for model, temperature in (('UNKNOWN_MTK', 'hnd'), ('RT-AX88U', 'hnd'),
                           ('RT-AX89X', 'qca'), ('ZenWiFi_BD4', 'ipq'),
                           ('GS7_PRO', 'hnd')):
    env = dict(os.environ, ROG_TEST_ODM=model, ROG_TEST_PRODUCT=model)
    actual = subprocess.check_output(['sh', '-c', routing], env=env, text=True)
    assert actual == 'unsupported||temperature:' + temperature, actual

start = script.index("-v band=\"${band}\" '\n", script.index('get_mtk_target_power_band(){'))
start += len("-v band=\"${band}\" '\n")
parser = script[start:script.index("');then", start)]
old = 'Band Index: 1, Channel Band: 1:5G\nBandIdx: 1, Max Base Pwr: 99 dbm\n'
marker = 'rog-test-fresh'
for band, header in ((0, 'Channel Band: 0:2G, Band Index: 0,'),
                     (1, 'Band Index: 1, Channel Band: 1:5G'),
                     (2, 'Band Index: 2, Channel Band: 1:5G')):
    fresh = marker + '\n' + header + '\n'
    for value in ('25.5', '28', '-0.5'):
        p = subprocess.run(['awk', '-v', 'marker=' + marker, '-v', 'band=' + str(band), parser],
            input=old + fresh + 'BandIdx: %s, Max Base Pwr: %s dbm\n' % (band, value),
            text=True, capture_output=True)
        assert p.returncode == 0 and p.stdout == 'data:%.1f' % float(value), p
    for report in (old, fresh, fresh + 'BandIdx: %s, Max Base Pwr: NaN dbm\n' % band,
                   fresh + 'BandIdx: %s, Max Base Pwr: 99 dbm\n' % ((band + 1) % 3)):
        p = subprocess.run(['awk', '-v', 'marker=' + marker, '-v', 'band=' + str(band), parser],
                           input=report, text=True, capture_output=True)
        assert p.returncode != 0 and not p.stdout, (report, p.stdout)
# Cross-check runtime profiles against extracted latest-stock-firmware metadata.
stock = json.loads((Path(__file__).resolve().parent / 'fixtures/mtk-stock-20261123.json').read_text())
profile_probe = stubs + function('_get_model') + function('get_mtk_power_backend') + "\nget_mtk_power_backend && printf '%s|%s|%s' \"${mtk_power_backend}\" \"${mtk_power_ifnames}\" \"${mtk_power_bands}\""
for row in stock['firmwares']:
    env = dict(os.environ, ROG_TEST_ODM=row['model'], ROG_TEST_PRODUCT=row['model'])
    actual = subprocess.check_output(['sh', '-c', profile_probe], env=env, text=True)
    expected = row['backend'] + '|' + ' '.join(row['interfaces']) + '|' + str(len(row['interfaces']))
    assert actual == expected, (row['model'], actual, expected)

# Cache is monotonic, expires at 30 seconds and is invalidated by radio state.
with tempfile.TemporaryDirectory(prefix='rog-power-cache-test-') as temp:
    cache = Path(temp) / 'cache'
    value = '2.4 GHz：无线已关闭；5 GHz：25.5 dBm / 354.81 mW'
    cache.write_text('100\nstate-a\n' + value + '\n')
    reader = function('read_mtk_power_cache') + '\nread_mtk_power_cache "$1" "$2" "$3"'
    for state, now, valid in [('state-a', 100, True), ('state-a', 129, True),
                              ('state-a', 130, False), ('state-a', 99, False),
                              ('state-b', 101, False)]:
        result = subprocess.run(['sh', '-c', reader, 'test', str(cache), state, str(now)],
                                text=True, capture_output=True)
        assert (result.returncode == 0) == valid, result
        assert result.stdout == (value if valid else ''), result.stdout
    for malformed in ['invalid\nstate-a\nvalue\n', '100\nstate-a\n']:
        cache.write_text(malformed)
        result = subprocess.run(['sh', '-c', reader, 'test', str(cache), 'state-a', '101'],
                                text=True, capture_output=True)
        assert result.returncode != 0 and not result.stdout

# Verify that real state-key construction notices active-channel and region changes.
state_stubs = r"""
nvram(){
    case "$2" in
        odmpid|productid) printf 'GS7' ;;
        wl0_radio) printf '%s' "$ROG_TEST_RADIO" ;;
        location_code) printf '%s' "$ROG_TEST_LOCATION" ;;
    esac
}
iwconfig(){ printf 'Mode:Master Channel:%s Access Point: test\n' "$ROG_TEST_CHANNEL"; }
"""
state_program = state_stubs + function('_get_model') + function('get_mtk_power_state') + '\nmtk_power_ifnames="ra0 rai0"; get_mtk_power_state'
keys = []
for radio, channel, location in [('1', '36', 'XX'), ('0', '36', 'XX'),
                                  ('1', '100', 'XX'), ('1', '36', 'CN')]:
    env = dict(os.environ, ROG_TEST_RADIO=radio, ROG_TEST_CHANNEL=channel,
               ROG_TEST_LOCATION=location)
    keys.append(subprocess.check_output(['sh', '-c', state_program], env=env, text=True))
assert len(set(keys)) == 4, keys

# Exercise the real top-level aggregation with hardware-only calls stubbed.
main = script[script.index('\nget_cpu_temp\nget_tmp_pwr\n'):]
aggregate_stubs = stubs + "\n" + "\n".join(function(name) for name in (
    '_get_model', 'get_mtk_power_backend', 'number_test')) + """
get_cpu_temp(){ cpu_temp='50°C'; }
get_tmp_pwr(){ wl_temp='2G/5G'; wl_txpwr='legacy'; }
get_mtk_target_power(){ printf '2.4 GHz：无线已关闭；5 GHz：25.5 dBm / 354.81 mW'; }
get_mhz(){ cpu_mhz=1800; }
get_system_info(){ kernel_ver=5.4; hardware_type=aarch64; build_date=2026; }
http_response(){ printf '%s' "$1"; }
"""
for model in wifi6 + wifi7 + triband + ('RT-AX88U',):
    env = dict(os.environ, ROG_TEST_ODM=model, ROG_TEST_PRODUCT=model)
    result = subprocess.check_output(['bash', '-c', aggregate_stubs + main,
                                      'test', '12345', '2'], env=env, text=True)
    fields = result.split('@@')
    assert len(fields) == 7, fields
    assert fields[2] == ('legacy' if model == 'RT-AX88U' else value), fields
assert 'mgmt_frame_pwr' not in script
assert '[ "$2" = "wifi_power" ]' not in script

print('MTK backend: model routing, fresh reports, cache expiry/invalidation and unified seven-field response passed')
