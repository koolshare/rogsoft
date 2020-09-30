#!/usr/bin/env python
# _*_ coding:utf-8 _*_

import os
import json
import codecs
import hashlib
from string import Template 

parent_path = os.path.dirname(os.path.realpath(__file__))

def md5sum(full_path):
    with open(full_path, 'rb') as rf:
        return hashlib.md5(rf.read()).hexdigest()

def get_or_create():
    conf_path = os.path.join(parent_path, "config.json.js")
    conf = {}
    if not os.path.isfile(conf_path):
        print u"config.json.js not found，build.py is root path. auto write config.json.js"
        module_name = os.path.basename(parent_path)
        conf["module"] = module_name
        conf["version"] = "0.0.1"
        conf["home_url"] = ("Module_%s.asp" % module_name)
        conf["title"] = "title of " + module_name
        conf["description"] = "description of " + module_name
    else:
        with codecs.open(conf_path, "r", "utf-8") as fc:
            conf = json.loads(fc.read())
    return conf

def build_module():
    try:
        conf = get_or_create()
    except:
        print u"config.json.js file format is incorrect"
        traceback.print_exc()
    if "module" not in conf:
        print u" module is not in config.json.js"
        return
    module_path = os.path.join(parent_path, conf["module"])
    if not os.path.isdir(module_path):
        print u"not found %s dir，check config.json.js is module ?" % module_path
        return
    install_path = os.path.join(parent_path, conf["module"], "install.sh")
    if not os.path.isfile(install_path):
        print u"not found %s file，check install.sh file"
        return
    print u"build..."
    t = Template("cd $parent_path && rm -f $module.tar.gz && tar -zcf $module.tar.gz $module")
    os.system(t.substitute({"parent_path": parent_path, "module": conf["module"]}))
    conf["md5"] = md5sum(os.path.join(parent_path, conf["module"] + ".tar.gz"))
    conf_path = os.path.join(parent_path, "config.json.js")
    with codecs.open(conf_path, "w", "utf-8") as fw:
        json.dump(conf, fw, sort_keys = True, indent = 4, ensure_ascii=False, encoding='utf8')
    print u"build done", conf["module"] + ".tar.gz"
    hook_path = os.path.join(parent_path, "backup.sh")
    if os.path.isfile(hook_path):
        os.system(hook_path)

build_module()

