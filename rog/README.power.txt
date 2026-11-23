ROG Toolbox MTK power query

Supported verified backends:
  TX-AX6000: iwpriv ra0/rax0 show data_frame_pwr=0-0 and mgmt_frame_pwr.
  GS7: mwctl dev ra0/rai0 show data_frame_pwr=0-0 (Wi-Fi 7).

The page queries once on open and on Refresh. Temperature/status polling does
not query the power table. Each query has a fresh kernel-log marker; both
bands share a lock and only a complete report for the requested band is used.

GS7 returns data:<maximum-target-dBm> per enabled radio. Its management-power
query was not verified as an absolute target and is not displayed. A disabled
radio returns off; busy/unavailable results do not fall back to stale values.
The numbers are firmware targets, not calibrated RF measurements.

Local verification:
  sh -n rog/rog/scripts/rog_status.sh
  node rog/tests/power-page.js rog/rog/webs/Module_rog.asp

Live GS7 verified on 2026-11-23:
  wifi_power API: off@@data:25.5
  The original seven-field status API is preserved.
  Original installed files are backed up on GS7 under
  /koolshare/.rog-gs7-power-20261123-1795444263/ (*.original).
