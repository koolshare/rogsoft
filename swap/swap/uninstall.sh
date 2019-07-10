#! /bin/sh
rm -rf /koolshare/scripts/swap*
find /koolshare/init.d/ -name "*swap.sh*"|xargs rm -rf
rm -rf /koolshare/webs/Module_swap.asp
rm -rf /koolshare/res/icon-swap.png
