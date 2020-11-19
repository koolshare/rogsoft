#!/bin/bash

#CURR_PATH=$(pwd)
CURR_PATH="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"
cd ${CURR_PATH}

modules=$(find . -maxdepth 1 -type d | grep -iv "\.\/\."|sed 's/.\///g'|sed '/\./d')
for module in ${modules}; do
	#echo ${module}
	if [ -f ${CURR_PATH}/${module}/build.sh ]; then
		echo "add .valid to ${module}"
		cd ${CURR_PATH}/${CURR_PATH}
		echo hnd > .valid
		cd ../..
		
		echo "build ${module}"
		cd ${CURR_PATH}/${module}
		sh build.sh
		cd ..
	else
		echo "${module}: this module do not have build.sh script!"
	fi
done
