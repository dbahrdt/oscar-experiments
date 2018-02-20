#!/bin/bash
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
BASE_PATH=${SCRIPTPATH}

source "${BASE_PATH}/cfg.sh"

clean_in_path() {
	cd $2
	git clean -x -d --dry-run ./
	echo "Clean $1?";
	read ANSWER
	if [ "${ANSWER}" = "y" ]; then
		git clean -x -d -f ./
	fi
}

clean_in_path "builds" "${BUILD_PATH}"
clean_in_path "searches" "${SEARCHES_PATH}"
clean_in_path "stores" "${STORES_PATH}"