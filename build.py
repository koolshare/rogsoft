#!/usr/bin/env python3
"""Initialize or package a KoolCenter plugin from its project directory."""

import argparse
from datetime import datetime
import gzip
import hashlib
from html import escape
import json
import os
from pathlib import Path
import re
from shlex import quote
import shutil
import struct
from string import Template
import sys
import tarfile
import tempfile
from urllib.parse import urlsplit
from urllib.request import HTTPRedirectHandler, build_opener
import zlib


# Bump on release and sync the same file to the root of koolshare/rogsoft.
BUILDER_VERSION = "1.3.0"
PLATFORMS = ("hnd", "mtk", "qca", "ipq32", "ipq64", "arm384")
MODULE_NAME = re.compile(r"[a-z][a-z0-9_]*")
IGNORED = (".git", ".gitkeep", ".DS_Store", "__pycache__", "*.pyc", "*.swp")

INSTALL_SCRIPT = Template('''#!/bin/sh
set -eu

src=$$(CDPATH='' cd "$$(dirname "$$0")" && pwd)
ks=/koolshare
export PATH="$$ks/bin:$$PATH"
version=$$(cat "$$src/version")
command -v dbus >/dev/null

mkdir -p "$$ks/scripts" "$$ks/webs" "$$ks/res"
cp -f "$$src/scripts/${module}_status.sh" "$$ks/scripts/"
cp -f "$$src/uninstall.sh" "$$ks/scripts/uninstall_${module}.sh"
chmod 755 "$$ks/scripts/${module}_status.sh" "$$ks/scripts/uninstall_${module}.sh"
cp -f "$$src/webs/Module_${module}.asp" "$$ks/webs/"
cp -f "$$src/res/icon-${module}.png" "$$ks/res/"

# The demo has no binary dependency. Adapt this entry to your plugin if needed.
if [ -x "$$src/bin/${module}" ]; then
    mkdir -p "$$ks/bin"
    cp -fp "$$src/bin/${module}" "$$ks/bin/"
fi

dbus set softcenter_module_${module}_name=${module}
dbus set ${title}
dbus set ${description}
dbus set "softcenter_module_${module}_version=$$version"
dbus set softcenter_module_${module}_install=1
''')

UNINSTALL_SCRIPT = Template('''#!/bin/sh
set -eu

ks=/koolshare
export PATH="$$ks/bin:$$PATH"

rm -f "$$ks/scripts/${module}_status.sh" "$$ks/webs/Module_${module}.asp" \\
    "$$ks/res/icon-${module}.png" "$$ks/bin/${module}"
for field in name title description version install; do
    dbus remove "softcenter_module_${module}_$$field"
done
rm -f "$$ks/scripts/uninstall_${module}.sh"
''')

STATUS_SCRIPT = Template('''#!/bin/sh
case "$$1" in
    ''|*[!0-9]*) exit 1 ;;
esac
[ "$${#1}" -le 8 ] || exit 1
. /koolshare/scripts/base.sh

case "$$2" in
    1) http_response ready ;;
    *) http_response invalid_action ;;
esac
''')

DEMO_PAGE = Template('''<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${title}</title>
    <link rel="stylesheet" href="/index_style.css">
    <link rel="stylesheet" href="/form_style.css">
    <link rel="stylesheet" href="/res/softcenter.css">
    <style>
        #${module}-panel { max-width: 760px; margin: 2rem auto; padding: 1rem; }
        #app #${module}-panel .ks_btn { width: auto; }
    </style>
</head>
<body id="app" skin="ASUSWRT" onload="init();">
    <main id="${module}-panel" class="FormTitle">
        <h1 class="formfonttitle">${title}</h1>
        <button id="check" class="ks_btn" type="button">读取状态</button>
        <output id="status" class="SimpleNote" aria-live="polite"></output>
    </main>
    <script>
    function init() {
        var skin = '<% nvram_get("sc_skin"); %>'.trim().toUpperCase();
        if (skin === "TX") {
            skin = "TS";
        }
        if (["ASUSWRT", "ROG", "TS", "TUF"].indexOf(skin) !== -1) {
            document.getElementById("app").setAttribute("skin", skin);
        }

        var button = document.getElementById("check");
        var status = document.getElementById("status");
        button.onclick = function () {
            var request = new XMLHttpRequest();
            request.open("POST", "/_api/", true);
            request.setRequestHeader("Content-Type", "application/json");
            request.timeout = 15000;
            button.disabled = true;
            status.textContent = "正在读取…";
            request.onloadend = function () {
                button.disabled = false;
                status.textContent = "读取失败";
                if (request.status === 200) {
                    try {
                        if (JSON.parse(request.responseText).result === "ready") {
                            status.textContent = "插件已就绪";
                        }
                    } catch (error) {
                        status.textContent = "无效的响应";
                    }
                }
            };
            request.send(JSON.stringify({
                id: Math.floor(Math.random() * 99999999) + 1,
                method: "${module}_status.sh",
                params: [1],
                fields: {}
            }));
        };
    }
    </script>
</body>
</html>
''')


def write_config(path, config):
    path.write_text(json.dumps(config, ensure_ascii=False, indent=4) + "\n", encoding="utf-8")


def prompt(label, default=None):
    suffix = " [{}]".format(default) if default is not None else ""
    while True:
        value = input(label + suffix + ": ").strip()
        if value or default is not None:
            return value or default
        print("请输入内容。")


def demo_icon():
    def chunk(kind, data):
        body = kind + data
        return struct.pack(">I", len(data)) + body + struct.pack(">I", zlib.crc32(body))

    size = 96
    rows = bytearray()
    for y in range(size):
        rows.append(0)  # PNG scanline filter: none.
        for x in range(size):
            color = (19, 51, 93)
            if (20 <= x < 76 and 49 <= y < 69) or (27 <= x < 32 and 26 <= y < 49):
                color = (240, 247, 255)
            if 56 <= y < 62 and (56 <= x < 61 or 64 <= x < 69):
                color = (22, 126, 112)
            rows.extend(color)
    header = struct.pack(">IIBBBBB", size, size, 8, 2, 0, 0, 0)
    return b"".join((b"\x89PNG\r\n\x1a\n", chunk(b"IHDR", header), chunk(b"IDAT", zlib.compress(rows)), chunk(b"IEND", b"")))


def init_project(root):
    metadata = root / "config.json.js"
    if metadata.exists() or metadata.is_symlink():
        raise ValueError("config.json.js already exists")
    default_module = root.name if root.name != "version" and MODULE_NAME.fullmatch(root.name) else None
    while True:
        module = prompt("插件英文名", default_module)
        if module == "version":
            print("version 是打包产物文件名，请选择其他英文名。")
        elif MODULE_NAME.fullmatch(module):
            break
        else:
            print("英文名须以小写字母开头，只能包含小写字母、数字和下划线。")
    payload = root / module
    if payload.exists() or payload.is_symlink():
        raise ValueError("payload path already exists: {}".format(payload))

    config = {
        "module": module,
        "version": "0.1.0",
        "title": prompt("插件标题", module),
        "description": prompt("插件简介"),
        "author": prompt("插件作者"),
        "tags": prompt("标签，空格分隔", "工具"),
        "home_url": "Module_{}.asp".format(module),
        "link": prompt("GitHub 项目地址，可留空", ""),
        "changelog": "",
    }
    targets = PLATFORMS[:-1]
    while True:
        values = prompt("目标平台，逗号或空格分隔 ({})".format(", ".join(targets)), "hnd")
        platforms = list(dict.fromkeys(re.findall(r"[^,，\s]+", values.lower())))
        if platforms and all(platform in targets for platform in platforms):
            break
        print("请从上列平台中选择至少一个。")
    config["platforms"] = platforms

    while True:
        binary_mode = prompt("二进制布局 (n 无 / c 共用 bin / p 按平台)", "n").lower()
        if binary_mode in ("n", "c", "p"):
            break
        print("请输入 n、c 或 p。")

    with tempfile.TemporaryDirectory(prefix=".plugin-build-", dir=str(root)) as temp:
        work = Path(temp)
        source = work / module
        for directory in ("scripts", "webs", "res"):
            (source / directory).mkdir(parents=True)
        binary_dirs = {"n": [], "c": ["bin"], "p": ["bin-" + platform for platform in platforms]}
        for name in binary_dirs[binary_mode]:
            directory = source / name
            directory.mkdir()
            (directory / ".gitkeep").touch()

        scripts = {
            "install.sh": INSTALL_SCRIPT.substitute(
                module=module,
                title=quote("softcenter_module_{}_title={}".format(module, config["title"])),
                description=quote("softcenter_module_{}_description={}".format(module, config["description"])),
            ),
            "uninstall.sh": UNINSTALL_SCRIPT.substitute(module=module),
            "scripts/{}_status.sh".format(module): STATUS_SCRIPT.substitute(),
        }
        for name, script in scripts.items():
            path = source / name
            path.write_text(script, encoding="utf-8")
            path.chmod(0o755)

        page = source / "webs" / config["home_url"]
        page.write_text(DEMO_PAGE.substitute(module=module, title=escape(config["title"])), encoding="utf-8")
        (source / "res" / "icon-{}.png".format(module)).write_bytes(demo_icon())
        (source / ".valid").write_text(platforms[0] + "\n", encoding="utf-8")
        write_config(work / metadata.name, config)

        if metadata.exists() or metadata.is_symlink() or payload.exists() or payload.is_symlink():
            raise ValueError("project files already exist")
        source.rename(payload)
        (work / metadata.name).rename(metadata)

    print("已初始化 {}。运行 python3 build.py 打包 {} 离线包。".format(module, platforms[0]))


def read_config(root):
    config = json.loads((root / "config.json.js").read_text(encoding="utf-8"))
    if not isinstance(config, dict):
        raise ValueError("config.json.js must contain a JSON object")
    module = config.get("module", root.name)
    if not isinstance(module, str) or not MODULE_NAME.fullmatch(module):
        raise ValueError("module must start with a lowercase letter and use only a-z, 0-9 or _")
    if module == "version":
        raise ValueError("module cannot use the package metadata filename version")
    version = config.get("version")
    if not isinstance(version, str) or not version.strip() or version.split() != [version]:
        raise ValueError("config.json.js needs a nonempty version string without whitespace")
    config["module"] = module
    config.setdefault("home_url", "Module_{}.asp".format(module))
    if "platforms" in config:
        platforms = config["platforms"]
        if not isinstance(platforms, list) or not platforms or any(platform not in PLATFORMS for platform in platforms):
            raise ValueError("platforms must list one or more supported platform names")
    return config


def select_platform(source, requested):
    if requested:
        return requested
    marker = source / ".valid"
    if marker.is_file():
        platform = marker.read_text(encoding="utf-8").strip()
        if platform in PLATFORMS:
            return platform
    raise ValueError("use --platform or set a single platform in {}/.valid".format(source.name))


def merge_binaries(source, target):
    if target.is_symlink() or (target.exists() and not target.is_dir()):
        raise ValueError("cannot overlay a directory at {}".format(target.name))
    target.mkdir(exist_ok=True)
    ignore = shutil.ignore_patterns(*IGNORED)
    for entry in sorted(source.iterdir()):
        if entry.name in ignore(str(source), [entry.name]):
            continue
        dest = target / entry.name
        if entry.is_dir() and not entry.is_symlink():
            merge_binaries(entry, dest)
        else:
            if dest.is_symlink():
                dest.unlink()
            elif dest.is_dir():
                raise ValueError("cannot replace a directory with {}".format(entry.name))
            shutil.copy2(entry, dest, follow_symlinks=False)


class HTTPSRedirect(HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        if urlsplit(newurl).scheme != "https":
            raise ValueError("binary_url redirects must use HTTPS")
        return super().redirect_request(req, fp, code, msg, headers, newurl)


def extract_binary(download, destination, module, name):
    try:
        archive = tarfile.open(download, "r:*")
    except tarfile.ReadError:
        download.replace(destination)
        return

    with archive:
        paths = (name, "bin/" + name, module + "/bin/" + name)
        members = [member for member in archive if (member.name[2:] if member.name.startswith("./") else member.name) in paths]
        if len(members) != 1 or not members[0].isfile() or not members[0].size:
            raise ValueError("binary_url archive must contain one regular file named " + name)
        with archive.extractfile(members[0]) as content, destination.open("wb") as output:
            shutil.copyfileobj(content, output)


def prepare_downloaded_binary(config, payload):
    url = config.get("binary_url")
    if not url:
        return
    if not isinstance(url, str) or urlsplit(url).scheme != "https":
        raise ValueError("binary_url must use HTTPS")
    expected = config.get("binary_sha256")
    if not isinstance(expected, str) or not re.fullmatch(r"[a-fA-F0-9]{64}", expected):
        raise ValueError("binary_sha256 must be a SHA-256 digest when binary_url is set")
    name = config.get("binary_name")
    if not name:
        filename = Path(urlsplit(url).path).name
        match = re.fullmatch(r"(.+)-binary(?:[.-].*|$)", filename)
        name = match.group(1) if match else config["module"]
    if not isinstance(name, str) or not re.fullmatch(r"[A-Za-z0-9_][A-Za-z0-9_.+-]*", name):
        raise ValueError("binary_name must be a plain filename")
    bin_dir = payload / "bin"
    if bin_dir.is_symlink():
        raise ValueError("cannot stage a download into a symbolic link")

    with tempfile.TemporaryDirectory(prefix=".binary-", dir=str(payload.parent)) as temp:
        download = Path(temp) / "download"
        with build_opener(HTTPSRedirect()).open(url, timeout=120) as response, download.open("wb") as output:
            shutil.copyfileobj(response, output)
        if file_digest(download, "sha256") != expected.lower():
            raise ValueError("binary_sha256 mismatch")
        binary = Path(temp) / "binary"
        extract_binary(download, binary, config["module"], name)
        binary.chmod(0o755)
        bin_dir.mkdir(exist_ok=True)
        binary.replace(bin_dir / name)


def stage_payload(source, target, platform, config):
    ignore = shutil.ignore_patterns(*IGNORED)

    def ignore_payload(path, names):
        skipped = set(ignore(path, names))
        if Path(path) == source:
            skipped.update(name for name in names if name.startswith("bin-"))
            skipped.update((".valid", "version"))
        return skipped

    variants = [entry for entry in source.iterdir() if entry.name.startswith("bin-") and entry.is_dir()]
    platform_bin = source / ("bin-" + platform)
    if variants and (not platform_bin.is_dir() or platform_bin.is_symlink()):
        raise ValueError("missing platform binary directory: {}".format(platform_bin))
    shutil.copytree(source, target, symlinks=True, ignore=ignore_payload)
    if platform_bin.is_dir():
        merge_binaries(platform_bin, target / "bin")
    prepare_downloaded_binary(config, target)
    (target / ".valid").write_text(platform + "\n", encoding="utf-8")
    (target / "version").write_text(config["version"] + "\n", encoding="utf-8")

    for entry in target.rglob("*"):
        if entry.is_symlink():
            link = Path(os.readlink(entry))
            if link.is_absolute() or target not in entry.resolve(strict=True).parents:
                raise ValueError("symbolic link must point inside the payload: {}".format(entry.relative_to(target)))
        elif not (entry.is_dir() or entry.is_file()):
            raise ValueError("unsupported payload entry: {}".format(entry.relative_to(target)))

    module = config["module"]
    if not (target / "install.sh").is_file():
        raise ValueError("missing {}/install.sh".format(module))
    if not (target / "scripts").is_dir():
        raise ValueError("missing {}/scripts/".format(module))
    page = target / "webs" / ("Module_{}.asp".format(module))
    if not page.is_file():
        raise ValueError("missing {}/{}".format(module, page.relative_to(target)))


def make_archive(payload, output):
    entries = [payload] + sorted(payload.rglob("*"), key=lambda path: path.relative_to(payload).as_posix())
    with output.open("wb") as raw:
        with gzip.GzipFile(filename="", fileobj=raw, mode="wb", mtime=0, compresslevel=9) as compressed:
            with tarfile.open(fileobj=compressed, mode="w", format=tarfile.GNU_FORMAT) as archive:
                for entry in entries:
                    relative = entry.relative_to(payload)
                    info = archive.gettarinfo(str(entry), arcname=(Path(payload.name) / relative).as_posix())
                    info.uid = info.gid = info.mtime = 0
                    info.uname = info.gname = "root"
                    if info.isfile():
                        if relative.as_posix() in ("install.sh", "uninstall.sh") or (
                            relative.parts[0] == "scripts" and entry.suffix == ".sh"
                        ):
                            info.mode |= 0o111
                        with entry.open("rb") as content:
                            archive.addfile(info, content)
                    else:
                        archive.addfile(info)


def file_digest(path, algorithm):
    digest = hashlib.new(algorithm)
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def build(root, requested):
    config = read_config(root)
    module = config["module"]
    source = root / module
    if not source.is_dir() or source.is_symlink():
        raise ValueError("missing payload directory: {}".format(source))
    platform = select_platform(source, requested)
    if "platforms" in config and platform not in config["platforms"]:
        raise ValueError("{} is missing from the platforms in config.json.js".format(platform))
    filename = module + ".tar.gz"

    lock = root / ".plugin-build.lock"
    try:
        lock.mkdir()
    except FileExistsError:
        raise ValueError("build already running or stale lock: {}".format(lock))
    try:
        with tempfile.TemporaryDirectory(prefix=".plugin-build-", dir=str(root)) as temp:
            work = Path(temp)
            payload = work / module
            output = work / filename
            stage_payload(source, payload, platform, config)
            make_archive(payload, output)
            digest = file_digest(output, "md5")
            if config.get("md5") != digest or not config.get("build_date"):
                config["build_date"] = datetime.now().strftime("%Y-%m-%d_%H:%M:%S")
            config["md5"] = digest
            write_config(work / "config.json.js", config)
            (work / "version").write_text(config["version"] + "\n" + digest + "\n", encoding="utf-8")
            outputs = (filename, "version", "config.json.js")
            for name in outputs:
                if (root / name).is_dir():
                    raise ValueError("output path is a directory: {}".format(root / name))
            for name in outputs:
                os.replace(work / name, root / name)
    finally:
        lock.rmdir()

    print("{} {} [{}] MD5 {}".format(filename, config["version"], platform, digest))


def main():
    parser = argparse.ArgumentParser(prog="build.py", description=__doc__)
    parser.add_argument("--version", action="version", version="%(prog)s " + BUILDER_VERSION)
    action = parser.add_mutually_exclusive_group()
    action.add_argument("--init", action="store_true", help="interactively initialize a demo plugin")
    action.add_argument("--platform", choices=PLATFORMS, help="defaults to the platform in <module>/.valid")
    args = parser.parse_args()
    try:
        if args.init:
            init_project(Path.cwd())
        else:
            build(Path.cwd(), args.platform)
    except (EOFError, KeyboardInterrupt):
        print("\nbuild.py: cancelled", file=sys.stderr)
        return 1
    except (OSError, ValueError, RuntimeError, tarfile.TarError) as exc:
        print("build.py: {}".format(exc), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
