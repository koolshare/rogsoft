#!/bin/sh
source /koolshare/scripts/base.sh

find /koolshare/init.d/ -name "*cfddns*" | xargs rm -rf
rm -rf /koolshare/res/icon-cfddns.png
rm -rf /koolshare/scripts/cfddns*.sh
rm -rf /koolshare/scripts/uninstall_cfddns.sh
rm -rf /koolshare/webs/Module_cfddns.asp
