#!/usr/bin/env python
# _*_ coding:utf-8 _*_


import os
import urllib.parse
import http.client
import json
import hashlib
import codecs
from shutil import copyfile
import sys
import traceback
import re  # 用于正则解析 git_path 和 JS 预处理
from packaging import version  # 新增：用于版本比较（替换 LooseVersion）
import tarfile
from string import Template

try:
    import requests
except ImportError:
    raise ImportError("The 'requests' library is required but not installed. Please install it before running this script.")

#https://docs.python.org/2.4/lib/httplib-examples.html


curr_path = os.path.dirname(os.path.realpath(__file__))
parent_path = os.path.realpath(os.path.join(curr_path, ".."))
git_bin = "git"

def http_request(url, depth=0):
    if depth > 10:
        raise Exception("Redirected {} times, giving up.".format(depth))
    try:
        resp = requests.get(url, headers={"Cache-Control": "max-age=0"}, timeout=10, allow_redirects=False)
        # 处理重定向
        if 300 < resp.status_code < 400 and "location" in resp.headers and resp.headers["location"] != url:
            return http_request(resp.headers["location"], depth + 1)
        return resp.content
    except Exception as e:
        print(f"[http_request] requests error: {e}")
        raise

def work_modules():
    module_path = os.path.join(curr_path, "modules.json")
    updated = False
    with codecs.open(module_path, "r", "utf-8") as fc:
        modules = json.loads(fc.read())
        if modules:
            for m in modules:
                if "module" in m:
                    try:
                        up = sync_module(m["module"], m["git_source"], m["branch"])
                        if not updated:
                            updated = up
                    except Exception as e:
                        traceback.print_exc()
    return updated

def sync_module(module, git_path, branch):
    module_path = os.path.join(parent_path, module)
    conf_path = os.path.join(module_path, "config.json.js")
    rconf = get_remote_js(git_path, branch)
    if rconf is None:
        print(f"[sync_module] Skipping module '{module}' due to invalid config URL.")
        return False  # 不更新，返回 False
    lconf = get_local_js(conf_path)
    update = False
    if not rconf:
        return False  # 修改：如果 rconf 无效，也返回 False
    print(rconf)
    if not lconf:
        update = True
    else:
        # 修改：使用 packaging.version.parse 替换 LooseVersion
        if version.parse(rconf["version"]) > version.parse(lconf["version"]):
            update = True
    if update:
        print("updating", git_path)
        cmd = ""
        tar_path = os.path.join(module_path, "%s.tar.gz" % module)
        if os.path.isdir(module_path):
            #cmd = "cd $module_path && $git_bin reset --hard && $git_bin clean -fdqx && $git_bin pull && rm -f $module.tar.gz && tar -zcf $module.tar.gz $module"
            cmd = "cd $module_path && $git_bin reset --hard && $git_bin clean -fdqx && $git_bin fetch --depth 1 && rm -f $module.tar.gz"
        else:
            # 修改：添加 --depth 1 和 --branch $branch 以实现浅克隆指定分支
            cmd = "cd $parent_path && $git_bin clone --depth 1 --branch $branch $git_path $module_path && cd $module_path && tar -zcf $module.tar.gz $module"
        t = Template(cmd)
        params = {"parent_path": parent_path, "git_path": git_path, "module_path": module_path, "module": module, "git_bin": git_bin, "branch": branch}
        s = t.substitute(params)
        os.system(s)
        rconf["md5"] = md5sum(tar_path)
        with codecs.open(conf_path, "w", "utf-8") as fw:
            json.dump(rconf, fw, sort_keys=True, indent=4, ensure_ascii=False)
        #os.system("cd %s && chown -R www:www ." % module_path)
    return update

def get_config_js(git_path, branch):
    if not git_path:
        print("[get_config_js] Warning: git_source is empty for this module.")
        return None

    # 解析 git_path 以提取 owner 和 repo
    # 支持格式：
    # - https://github.com/owner/repo.git
    # - git@github.com:owner/repo.git
    # - owner/repo.git 或 owner/repo
    owner = None
    repo = None

    # 去除可能的 .git 后缀
    if git_path.endswith(".git"):
        git_path = git_path[:-4]

    # 正则匹配常见格式
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

    # 构建正确的 GitHub raw URL
    raw_url = f"https://raw.githubusercontent.com/{owner}/{repo}/{branch}/config.json.js"
    return raw_url

def get_remote_js(git_path, branch):
    url = get_config_js(git_path, branch)
    if not url:
        return None
    data = http_request(url)
    if not data:
        print(f"[get_remote_js] Warning: No data received from {url}")
        return None
    try:
        conf = json.loads(data.decode('utf-8'))
    except Exception as e:
        print(f"[get_remote_js] Error decoding JSON from {url}: {e}")
        print(f"[get_remote_js] Raw data: {data}")
        return None
    return conf

def get_local_js(conf_path):
    if os.path.isfile(conf_path):
        with codecs.open(conf_path, "r", "utf-8") as fc:
            conf = json.loads(fc.read())
            return conf
    return None

def make_tarfile(output_filename, source_dir):
    with tarfile.open(output_filename, "w:gz") as tar:
        tar.add(source_dir, arcname=os.path.basename(source_dir))

def md5sum(full_path):
    with open(full_path, 'rb') as rf:
        return hashlib.md5(rf.read()).hexdigest()

def work_parent():
    ignore_paths = frozenset(["maintain_files", "softcenter", "v2ray"])
    for fname in os.listdir(parent_path):
        if fname[0] == "." or fname in ignore_paths:
            continue
        path = os.path.join(parent_path, fname)
        if os.path.isdir(path):
            yield fname, path

def parse_js_config(content):
    # """辅助函数：预处理 .js 文件内容，提取纯 JSON 部分"""
    # 去除注释（单行 // 和多行 /* */）
    content = re.sub(r'//.*?$|/\*.*?\*/', '', content, flags=re.MULTILINE | re.DOTALL)
    # 去除 var ... = 和结尾 ;
    content = re.sub(r'^\s*(var\s+\w+\s*=\s*)?\{', '{', content)
    content = re.sub(r';\s*$', '', content)
    # 如果键没有引号，添加（简单正则替换，假设键是字母数字）
    content = re.sub(r'(\s*)([a-zA-Z0-9_]+)\s*:', r'\1"\2":', content)
    return content.strip()

def gen_modules(modules):
    for module, path in work_parent():
        conf = os.path.join(path, "config.json.js")
        m = None
        try:
            with codecs.open(conf, "r", "utf-8") as fc:
                raw_content = fc.read()
                # 预处理为纯 JSON
                json_content = parse_js_config(raw_content)
                m = json.loads(json_content)
                if m:
                    m["name"] = module
                    if "tar_url" not in m:
                        m["tar_url"] = module + "/" + module + ".tar.gz"
                    if "home_url" not in m:
                        m["home_url"] = "Module_" + module + ".asp"
        except json.JSONDecodeError as e:
            print(f"[gen_modules] JSON decode error in {conf}: {e}")
            print(f"[gen_modules] Raw content: {raw_content}")
            # 跳过无效模块，使用默认值
            m = None
        except Exception as e:
            traceback.print_exc()

        if not m:
            m = {"name":module, "title":module, "tar_url": module + "/" + module + ".tar.gz"}
        modules.append(m)

def refresh_gmodules():
    gmodules = None
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

updated = work_modules()
if updated:
    refresh_gmodules()
    #os.system("chown -R www:www %s/softcenter/app.json.js" % parent_path)