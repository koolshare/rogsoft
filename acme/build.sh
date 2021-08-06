#!/bin/sh

MODULE="acme"
VERSION="3.3"
TITLE="Let's Encrypt"
DESCRIPTION="自动部署SSL证书"
HOME_URL="Module_acme.asp"
TAGS="网络 工具"
AUTHOR="sadog"
LINK="https://github.com/acmesh-official/acme.sh"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
