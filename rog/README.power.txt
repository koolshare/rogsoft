ROG Toolbox 5.9.18: MTK power display

Shared MTK package, selected by exact router model (odmpid, then productid):
  GS7 (Wi-Fi 7): mwctl dev ra0/rai0 show data_frame_pwr=0-0.
  TUF-AX4200 / TUF-AX4200Q / TUF-AX6000 / TX-AX6000 (Wi-Fi 6):
    iwpriv ra0/rax0 show data_frame_pwr=0-0.
  Runtime routing is shared by power and temperature queries, including models
  with an empty odmpid and only productid set. Installation does not select or
  remove a Wi-Fi generation: the same MTK archive always contains both paths.
  Other models retain the existing status/power path; unverified MTK models
  are not sent a guessed power-query command.

Display
  Label: 发射功率
  GS7 example: 2.4 GHz：无线已关闭；5 GHz：25.5 dBm
  TX-AX6000 example: 2.4 GHz：28.0 dBm；5 GHz：27.5 dBm
  Query on page open and on Refresh. Temperature/status polling does not query
  power. Both backends return data:<maximum-target-dBm>; management-frame
  power is neither queried nor displayed.
  Explanation is in the lower SimpleNote, not alongside the values:
  发射功率为无线固件报告的数据帧最高目标值，非仪器实测射频功率。

Reliability
  A fresh kernel-log marker excludes old reports; both bands share a lock.
  Only a complete report for the requested band is accepted. A disabled radio
  returns off; busy/unavailable results do not fall back to stale values.

Build / verify
  sh -n rog/rog/scripts/rog_status.sh
  node rog/tests/power-page.js rog/rog/webs/Module_rog.asp
  python3 rog/tests/power-backend.py
  cd rog && sh build_mtk.sh
  build.sh stamps rog/version before archiving. The archive must contain
  rog/.valid=mtk and rog/version=5.9.18. rog.tar.gz MD5 must match both the
  outer version file and config.json.js.

Live verified on 2026-11-23
  GS7: off@@data:25.5
  TX-AX6000: data:28.0@@data:27.5
  Both original seven-field status APIs remain valid.
  AX4200 compatibility: ra0/rax0 confirmed from its l1profile; its official
  show_data_frame_power and mtf_txpower_all_rate_info machine code matches
  the verified TX-AX6000 driver. Model dispatch and parser tests passed;
  AX4200 has not been tested on physical hardware in this change.
  Pre-update files and version values are backed up on each router:
    GS7: /koolshare/.rog-power-5.9.17-1795445579/
    TX-AX6000: /koolshare/.rog-power-5.9.17-1795445580/
  No radio configuration was changed. No online software-center publication.
