#!/bin/sh

# build script for rogsoft project

MODULE="nodejs"
VERSION="1.2"
TITLE="Node.js"
DESCRIPTION="Node.js"
HOME_URL="Module_nodejs.asp"
TAGS="Entware"
AUTHOR="sadog"

# Check and include base
DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

# now include build_base.sh
. $DIR/../softcenter/build_base.sh

# change to module directory
cd $DIR

# do something here
do_build_result
