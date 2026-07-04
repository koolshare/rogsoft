#!/usr/bin/env python
# _*_ coding:utf-8 _*_

import os
import json
import codecs
import traceback
import re
from packaging import version

# Check dependencies
try:
    import requests
except ImportError:
    raise ImportError("The 'requests' library is required. Please install it: pip install requests")

# Path definitions
curr_path = os.path.dirname(os.path.realpath(__file__))
parent_path = os.path.realpath(os.path.join(curr_path, ".."))
git_bin = "git"

def http_request(url, depth=0):
    """Send HTTP request to get content"""
    if depth > 10:
        raise Exception("Redirected {} times, giving up.".format(depth))
    try:
        headers = {
            "Cache-Control": "max-age=0",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        }
        resp = requests.get(url, headers=headers, timeout=15, allow_redirects=False)
        if 300 < resp.status_code < 400 and "location" in resp.headers:
            return http_request(resp.headers["location"], depth + 1)
        return resp.content
    except Exception as e:
        print(f"[http_request] Error requesting {url}: {e}")
        return None

def parse_js_config(content):
    """
    Robust JS config to JSON parser.
    FIXED: Now correctly handles URLs with // (e.g. https://) without treating them as comments.
    """
    # 1. Remove multi-line comments /* ... */
    content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)
    
    # 2. Remove single-line comments // ... 
    # CRITICAL FIX: Use negative lookbehind (?<!:) to ignore // preceded by : (like https://)
    content = re.sub(r'(?<!:)\/\/.*$', '', content, flags=re.MULTILINE)
    
    # 3. Remove variable declaration var x = { ... }; keep only { ... }
    match = re.search(r'(\{.*\})', content, re.DOTALL)
    if match:
        content = match.group(1)
    
    # 4. Remove trailing semicolon
    content = content.strip().rstrip(';')
    
    # 5. Attempt to add quotes to unquoted keys (e.g., key: value -> "key": value)
    content = re.sub(r'(?m)(?<=[\s{,])([a-zA-Z0-9_]+)(?=\s*:)', r'"\1"', content)

    # 6. Remove trailing commas (e.g., "ver": "1.0", } -> "ver": "1.0" })
    content = re.sub(r',\s*([\]}])', r'\1', content)
    
    return content

def load_config_content(content):
    try:
        return json.loads(content, strict=False)
    except Exception:
        json_str = parse_js_config(content)
        return json.loads(json_str, strict=False)

def get_config_js(git_path, branch):
    """Construct raw URL for remote config.json.js"""
    if not git_path:
        print("[get_config_js] Warning: git_source is empty for this module.")
        return None

    if git_path.endswith(".git"):
        git_path = git_path[:-4]

    match_https = re.match(r"https?://github\.com/([^/]+)/([^/]+)", git_path)
    match_ssh = re.match(r"git@github\.com:([^/]+)/([^/]+)", git_path)
    match_short = re.match(r"([^/]+)/([^/]+)", git_path)

    if match_https:
        owner, repo = match_https.groups()
    elif match_ssh:
        owner, repo = match_ssh.groups()
    elif match_short:
        owner, repo = match_short.groups()
    else:
        print(f"[get_config_js] Error: Invalid git_source format: {git_path}")
        return None

    return f"https://raw.githubusercontent.com/{owner}/{repo}/{branch}/config.json.js"

def get_remote_js(git_path, branch):
    """Get remote version config"""
    url = get_config_js(git_path, branch)
    if not url:
        return None
    
    data = http_request(url)
    if not data:
        return None
    
    try:
        content = data.decode('utf-8')
        return load_config_content(content)
    except Exception as e:
        print(f"[get_remote_js] Error parsing remote config from {url}: {e}")
        return None

def get_local_js(conf_path):
    """Get local version config"""
    if os.path.isfile(conf_path):
        with codecs.open(conf_path, "r", "utf-8") as fc:
            try:
                content = fc.read()
                return load_config_content(content)
            except Exception:
                return None
    return None

def sync_module(module, git_path, branch):
    """Core logic: Git sync only. Package building is handled by trusted deploy build steps."""
    module_path = os.path.join(parent_path, module)
    conf_path = os.path.join(module_path, "config.json.js")

    # 1. Get remote config
    rconf = get_remote_js(git_path, branch)
    if rconf is None:
        print(f"[sync_module] Skipping '{module}' - invalid remote config.")
        return False
    
    # 2. Get local config
    lconf = get_local_js(conf_path)
    
    update = False
    if not lconf:
        print(f"[{module}] Local config not found, forcing install.")
        update = True
    else:
        try:
            # Compare versions
            if version.parse(rconf["version"]) > version.parse(lconf["version"]):
                print(f"[{module}] New version found: {rconf['version']} > {lconf['version']}")
                update = True
        except Exception as e:
            print(f"[{module}] Version parse error: {e}, forcing update.")
            update = True

    if update:
        print(f"[{module}] Syncing source from {git_path} (Branch: {branch})...")
        
        # --- Git Operations ---
        if os.path.isdir(module_path):
            # Dir exists: Reset and pull without executing third-party build.sh.
            git_cmds = [
                f"cd {module_path}",
                f"{git_bin} reset --hard",
                f"{git_bin} clean -fdqx",
                f"{git_bin} fetch --depth 1 origin {branch}",
                f"{git_bin} checkout {branch}",
                f"{git_bin} reset --hard origin/{branch}"
            ]
            cmd = " && ".join(git_cmds)
        else:
            # Dir does not exist: Clone only. Trusted deploy build steps package later.
            cmd = f"cd {parent_path} && {git_bin} clone --depth 1 --branch {branch} {git_path} {module_path}"
        
        if os.system(cmd) != 0:
            print(f"[{module}] Git operation failed.")
            return False

        # --- Update local config.json.js ---
        try:
            # Do not trust or reuse remote package md5; trusted build.py updates md5 after packaging.
            if "md5" in rconf:
                rconf["md5"] = ""
                
            with codecs.open(conf_path, "w", "utf-8") as fw:
                json.dump(rconf, fw, sort_keys=True, indent=4, ensure_ascii=False)
            print(f"[{module}] Sync success. Updated to version {rconf['version']}")
        except Exception as e:
            print(f"[{module}] Warning: Failed to write config.json.js: {e}")

    return update

def work_modules():
    """Main loop: Process modules.json"""
    module_path = os.path.join(curr_path, "modules.json")
    updated = False
    
    if not os.path.exists(module_path):
        print(f"Error: {module_path} not found.")
        return False

    with codecs.open(module_path, "r", "utf-8") as fc:
        try:
            modules = json.loads(fc.read())
        except json.JSONDecodeError:
            print("Error: modules.json is not valid JSON.")
            return False

    if modules:
        print(f"Found {len(modules)} modules to process.")
        for m in modules:
            if "module" in m:
                try:
                    # Default branch is master if not specified
                    branch = m.get("branch", "master")
                    if sync_module(m["module"], m["git_source"], branch):
                        updated = True
                except Exception:
                    print(f"Error processing module {m.get('module')}")
                    traceback.print_exc()
    return updated

def work_parent():
    ignore_paths = frozenset(["maintain_files", "softcenter", "v2ray"])
    for fname in os.listdir(parent_path):
        if fname[0] == "." or fname in ignore_paths:
            continue
        path = os.path.join(parent_path, fname)
        if os.path.isdir(path):
            yield fname, path

def gen_modules(modules):
    for module, path in work_parent():
        conf = os.path.join(path, "config.json.js")
        m = None
        raw_content = ""
        try:
            with codecs.open(conf, "r", "utf-8") as fc:
                raw_content = fc.read()
                m = load_config_content(raw_content)
                if m:
                    m["name"] = module
                    if "tar_url" not in m:
                        m["tar_url"] = module + "/" + module + ".tar.gz"
                    if "home_url" not in m:
                        m["home_url"] = "Module_" + module + ".asp"
        except json.JSONDecodeError as e:
            print(f"[gen_modules] JSON decode error in {conf}: {e}")
            print(f"[gen_modules] Raw content: {raw_content}")
            m = None
        except Exception:
            traceback.print_exc()

        if not m:
            m = {"name": module, "title": module, "tar_url": module + "/" + module + ".tar.gz"}
        modules.append(m)

def refresh_gmodules():
    with codecs.open(os.path.join(curr_path, "app.template.json.js"), "r", "utf-8") as fg:
        gmodules = json.loads(fg.read())
        gmodules["apps"] = []

    gen_modules(gmodules["apps"])

    with codecs.open(os.path.join(curr_path, "config.json.js"), "r", "utf-8") as fc:
        conf = json.loads(fc.read())
        gmodules["version"] = conf["version"]
        gmodules["md5"] = conf["md5"]

    with codecs.open(os.path.join(curr_path, "app.json.js"), "w", "utf-8") as fw:
        json.dump(gmodules, fw, sort_keys=True, indent=4, ensure_ascii=False)

def main(argv=None):
    argv = argv or []
    if argv == ["refresh"]:
        refresh_gmodules()
        return

    updated = work_modules()
    if updated:
        refresh_gmodules()

if __name__ == "__main__":
    import sys
    main(sys.argv[1:])
