#!/bin/bash

#CURR_PATH=$(pwd)
CURR_PATH="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"
SOFT_PATH=$(dirname $CURR_PATH)
cd ${SOFT_PATH}

modules=$(find . -maxdepth 1 -type d | grep -iv "\.\/\."|sed 's/.\///g'|sed '/\./d')
for module in ${modules}; do
	#echo ${module}
	if [ -f ${SOFT_PATH}/${module}/build.sh ]; then
		cd ${SOFT_PATH}/${module}
		
		echo "add .valid to ${module}"
		echo hnd >${SOFT_PATH}/${module}/${module}/.valid

		echo "build ${module}"
		sh build.sh
	else
		echo "${module}: this module do not have build.sh script!"
	fi
done
