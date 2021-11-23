#!/bin/sh

MODULE="sftpserver"
VERSION="1.3"
TITLE="Sftp Server"
DESCRIPTION="Sftp Server"
HOME_URL="Module_sftpserver.asp"
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
