#!/usr/bin/env python3
"""Exercise exact-model routing and parsing without changing router state."""
from pathlib import Path
import os
import subprocess

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
wifi6 = ('TUF-AX4200', 'TUF-AX4200Q', 'TUF-AX6000', 'TX-AX6000')
for model in wifi6 + ('GS7',):
    expected = ('iwpriv|rax0|temperature:iwpriv' if model in wifi6
                else 'mwctl|rai0|temperature:mwctl')
    for odm, product in ((model, model), ('', model)):
        env = dict(os.environ, ROG_TEST_ODM=odm, ROG_TEST_PRODUCT=product)
        actual = subprocess.check_output(['sh', '-c', routing], env=env, text=True)
        assert actual == expected, (odm, product, actual)
for model, temperature in (('UNKNOWN_MTK', 'hnd'), ('RT-AX88U', 'hnd'),
                           ('RT-AX89X', 'qca'), ('ZenWiFi_BD4', 'ipq'),
                           ('GS7_Air', 'mwctl')):
    env = dict(os.environ, ROG_TEST_ODM=model, ROG_TEST_PRODUCT=model)
    actual = subprocess.check_output(['sh', '-c', routing], env=env, text=True)
    assert actual == 'unsupported||temperature:' + temperature, actual

start = script.index("-v band=\"${band}\" '\n", script.index('get_mtk_target_power_band(){'))
start += len("-v band=\"${band}\" '\n")
parser = script[start:script.index("');then", start)]
old = 'Band Index: 1, Channel Band: 1:5G\nBandIdx: 1, Max Base Pwr: 99 dbm\n'
marker = 'rog-test-fresh'
for band, header in ((0, 'Channel Band: 0:2G, Band Index: 0,'),
                     (1, 'Band Index: 1, Channel Band: 1:5G')):
    fresh = marker + '\n' + header + '\n'
    for value in ('25.5', '28', '-0.5'):
        p = subprocess.run(['awk', '-v', 'marker=' + marker, '-v', 'band=' + str(band), parser],
            input=old + fresh + 'BandIdx: %s, Max Base Pwr: %s dbm\n' % (band, value),
            text=True, capture_output=True)
        assert p.returncode == 0 and p.stdout == 'data:%.1f' % float(value), p
    for report in (old, fresh, fresh + 'BandIdx: %s, Max Base Pwr: NaN dbm\n' % band,
                   fresh + 'BandIdx: %s, Max Base Pwr: 99 dbm\n' % (1 - band)):
        p = subprocess.run(['awk', '-v', 'marker=' + marker, '-v', 'band=' + str(band), parser],
                           input=report, text=True, capture_output=True)
        assert p.returncode != 0 and not p.stdout, (report, p.stdout)
assert 'mgmt_frame_pwr' not in script
print('MTK backend: model/alias/productid routing, temperature routing, fresh-band parsing and stale/error rejection passed')
