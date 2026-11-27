#!/usr/bin/env python3
"""Run production radio querying/aggregation against isolated fake driver clients."""
from pathlib import Path
import os
import subprocess
import tempfile

source = (Path(__file__).resolve().parents[1] / 'rog/scripts/rog_status.sh').read_text()
def function(name):
    start = source.index(name + '(){')
    return source[start:source.index('\n}\n', start) + 3]

functions = '\n'.join(function(n) for n in (
    '_get_model', 'get_mtk_power_backend', 'get_mtk_band_label', 'format_mtk_power_band',
    'format_mtk_power_status', 'get_mtk_power_state', 'read_mtk_power_cache',
    'get_mtk_target_power_band', 'read_mtk_temperature', 'get_mtk_temperature', 'status_uptime',
    'write_status_cache', 'sample_status_with_lock', 'start_status_sample', 'refresh_mtk_target_power',
    'get_mtk_target_power', 'refresh_status_samples'))
functions = functions.replace('/dev/kmsg', '${ROG_TEST_ROOT}/kmsg')
functions = functions.replace('/sys/class/net/', '${ROG_TEST_ROOT}/net/')
functions = functions.replace('/tmp/rog_wifi_temperature.cache', '${ROG_TEST_ROOT}/temperature')
functions = functions.replace('/tmp/rog_wifi_power.cache', '${ROG_TEST_ROOT}/cache')
functions = functions.replace('/tmp/mtk-txpwr-target.lock', '${ROG_TEST_ROOT}/lock')

stubs = r'''
nvram(){
    case "$2" in
        odmpid|productid) printf '%s' "$ROG_TEST_MODEL" ;;
        wl0_nband) printf '2' ;; wl1_nband) printf '1' ;;
        wl2_nband) printf '%s' "$ROG_TEST_BAND2" ;;
        wl2_radio) printf '%s' "$ROG_TEST_RADIO2" ;;
        *_radio) printf '1' ;;
        location_code) printf 'XX' ;;
        reg_spec) printf 'CN' ;;
        *_txpower) printf '100' ;;
        *_channel) printf '0' ;;
    esac
}
iwconfig(){ printf 'Mode:Master Channel:36\n'; }
dmesg(){ cat "$ROG_TEST_ROOT/kmsg"; }
fixture_cli(){
    method=$1 iface=$2 action=$3
    case "$iface" in ra0) b=0 ;; rai0) b=1 ;; rax0) if [ "$method" = mwctl ];then b=2;else b=1;fi ;; *) exit 20 ;; esac
    if [ "$action" = stat ];then
        printf 'CurrentTemperature = %s\n' "$((40+b))"
        return
    fi
    # Hold the first refresh long enough for the next poll to see the lock.
    sleep 0.08
    printf '%s %s\n' "$method" "$iface" >> "$ROG_TEST_ROOT/queries"
    printf '\nBand Index: %s, Channel Band: 1:5G\n=== BandIdx: %s, Max Base Pwr: %s dbm ===\n' "$b" "$b" "$((26+b))" >> "$ROG_TEST_ROOT/kmsg"
}
iwpriv(){
    if [ "$2" != stat ];then [ "$2" = show ] && [ "$3" = data_frame_pwr=0-0 ] || exit 22;fi
    fixture_cli iwpriv "$1" "$2"
}
mwctl(){
    [ "$1" = dev ] || exit 21
    if [ "$3" != stat ];then [ "$3" = show ] && [ "$4" = data_frame_pwr=0-0 ] || exit 23;fi
    fixture_cli mwctl "$2" "$3"
}
'''
program = stubs + '\n' + functions + '''
get_mtk_power_backend
get_mtk_temperature
get_mtk_target_power
printf '%s\\n' "$wl_txpwr"
refresh_status_samples
get_mtk_target_power
printf '%s\\n' "$wl_txpwr"
refresh_status_samples
wait
get_mtk_target_power
printf '%s\\n' "$wl_txpwr"
get_mtk_temperature
printf '%s\\n' "$wl_temp"
'''
models = ('TX-AX6000', 'TUF-AX6000', 'TUF-AX4200Q', 'TUF-AX4200', 'RT-AX57_Go',
          'GS7', 'GS7_Air', 'GS-BE7200X', 'ZenWiFi_BT8P')
for model in models:
    variants = [('1', '1')]
    if model == 'ZenWiFi_BT8P': variants += [('0', '1'), ('1', '4')]
    for radio2, band2 in variants:
        with tempfile.TemporaryDirectory(prefix='rog-radio-test-') as folder:
            root = Path(folder)
            (root / 'kmsg').write_text('')
            for iface in ('ra0', 'rai0', 'rax0'): (root / 'net' / iface).mkdir(parents=True)
            env = dict(os.environ, ROG_TEST_ROOT=folder, ROG_TEST_MODEL=model,
                       ROG_TEST_RADIO2=radio2, ROG_TEST_BAND2=band2)
            lines = subprocess.check_output(['sh', '-c', program], env=env, text=True).splitlines()
            assert len(lines) == 4, lines
            assert lines[0] == lines[1] and '正在查询…' in lines[0], lines
            expected = '2.4 GHz：26.0 dBm / 398.11 mW；5 GHz：27.0 dBm / 501.19 mW'
            count = 2
            if model == 'ZenWiFi_BT8P':
                count = 2 if radio2 == '0' else 3
                if band2 == '4': expected = '2.4 GHz：26.0 dBm / 398.11 mW；5 GHz：27.0 dBm / 501.19 mW；6 GHz：28.0 dBm / 630.96 mW'
                else: expected = '2.4 GHz：26.0 dBm / 398.11 mW；5 GHz-1：27.0 dBm / 501.19 mW；5 GHz-2：' + ('无线已关闭' if radio2 == '0' else '28.0 dBm / 630.96 mW')
            assert lines[2] == expected, (model, lines)
            assert lines[3].count('GHz：') + lines[3].count('GHz-1：') + lines[3].count('GHz-2：') == (3 if model == 'ZenWiFi_BT8P' else 2), lines
            queries = (root / 'queries').read_text().splitlines()
            assert len(queries) == count, queries  # Overlapping polls can only start one driver query per band.
            wifi6 = model.startswith('TUF-') or model.startswith('TX-') or model.startswith('RT-')
            method = 'iwpriv' if wifi6 else 'mwctl'
            interfaces = ['ra0', 'rax0' if wifi6 else 'rai0'] + (['rax0'] if count == 3 else [])
            assert queries == [method + ' ' + iface for iface in interfaces], queries
            assert not (root / 'lock').exists()
print('MTK radios: all nine stock-model/alias profiles, exact commands/interfaces, three-band power/temperature, disabled radio and cache passed')
