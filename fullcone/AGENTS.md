# Repository Guidelines

## Project Structure & Module Organization
- `fullcone/` router plugin payload: platform splits (`bin-<plat>`, `scripts-<plat>`), installers (`install-<plat>.sh`, `uninstall-<plat>.sh`), UI `webs/Module_fullcone.asp`, assets in `res/`, and kernel pieces under `fullcone/fullcone/<platform-kernel>/`.
- `shell/` development scripts: source `.sh` files and `compile.sh` used to build small wrapper binaries from shell scripts.
- `server/` optional PHP backend (activation/payment API, admin pages); managed via Composer (`server/vendor/`).
- Build entrypoints: `build_<plat>.sh` symlinks (`hnd`, `qca`, `mtk`, `ipq32`, `ipq64`) → package the plugin.

## Build, Test, and Development Commands
- Build package: run one of `./build_hnd.sh | ./build_qca.sh | ./build_mtk.sh | ./build_ipq32.sh | ./build_ipq64.sh`. Output: `fullcone.tar.gz`, plus `config.json.js` and `version`. Requires `../softcenter/gen_install.py` in a parent checkout.
- Rebuild embedded binaries from shell: `cd shell && ./compile.sh` (needs `shc` and cross toolchains under `/opt/...`).
- Quick verification: `tar tzf fullcone.tar.gz` to inspect contents; for the PHP API: `php -S 127.0.0.1:8000 -t server` (dev only).

## Coding Style & Naming Conventions
- Shell: POSIX `sh` (BusyBox targets). Avoid bashisms (`[[ ... ]]`, arrays). Indent with tabs or 4 spaces—match the surrounding file. Use lower_snake_case for variables and functions.
- Naming: `fullcone_*.sh` for scripts; platform folders `scripts-<plat>`, `bin-<plat>`; build scripts `build_<plat>.sh`.

## Testing Guidelines
- No unit tests here; validate on device (Merlin/OpenWrt): `/koolshare/scripts/fullcone.sh start` or use the UI page.
- Verify rules/modules:
  - `iptables -t nat -S | grep FULLCONENAT`
  - `lsmod | grep xt_FULLCONENAT` (non-MTK)
- Check logs at `/tmp/upload/fullcone_log.txt` and confirm status via `/koolshare/scripts/fullcone.sh status`.

## Commit & Pull Request Guidelines
- Commits: imperative + scoped prefix; small, focused changes. Examples: `shell: fix offline ticket verification`, `build: add ipq64 target`.
- PRs: include a clear description, affected platforms, reproduction/verification steps, and evidence (logs, `iptables` output, or UI screenshots). Do not include secrets.

## Security & Configuration Tips
- Do not commit real keys/tickets; `server/keys/*.pem` are development placeholders. Strip secrets and local config before submitting.
- Architecture-specific binaries under `fullcone/fullcone/*` are required for release; regenerate only if you have the correct toolchains.
