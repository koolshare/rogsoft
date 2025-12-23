#!/bin/sh

MODULE="fakehttp"
VERSION="1.0"
TITLE="FakeHTTP"
DESCRIPTION="TCP连接伪装成HTTP协议"
HOME_URL="Module_fakehttp.asp"
TAGS="网络 工具"
AUTHOR="sadog"
LINK="https://github.com/MikeWang000000/FakeHTTP"

DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# 引用基础构建脚本
. $DIR/../softcenter/build_base.sh

# 执行构建
do_build_result
