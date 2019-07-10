#!/bin/sh

MODULE="cfddns"
VERSION="1.0"
TITLE="CloudFlare DDNS"
DESCRIPTION="CloudFlare DDNS"
HOME_URL="Module_cfddns.asp"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
