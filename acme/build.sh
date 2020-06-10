#!/bin/sh

MODULE="acme"
VERSION="3.1"
TITLE="Let's Encrypt"
DESCRIPTION="自动部署SSL证书"
HOME_URL="Module_acme.asp"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
