#!/bin/bash

#CURR_PATH=$(pwd)
CURR_PATH="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"
cd ${CURR_PATH}

modules=$(find . -maxdepth 1 -type d | grep -iv "\.\/\."|grep -v softcenter|sed 's/.\///g'|sed '/\./d')
for module in ${modules}; do
	#echo ${module}
	if [ -f ${CURR_PATH}/${module}/build.sh ]; then
		echo "build ${module}"
		cd ${CURR_PATH}/${module}
		sh build.sh
	else
		echo "${module}: this module do not have build.sh script!"
	fi
done