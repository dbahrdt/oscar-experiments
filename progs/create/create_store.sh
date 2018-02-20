#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
BASE_PATH=${SCRIPTPATH}
source "${BASE_PATH}/create_cfg.sh"

if [ -z "${GRIDSIZE}" ]; then
	echo "No grid size given. set with GRIDSIZE={100,500,1000,3000}"
	exit 1
fi

if [ ! -f "${CFG_DIR}/store_grid${GRIDSIZE}.json" ]; then
	echo "Grid store_grid${GRIDSIZE}.json does not exist"
	exit 1
fi

if [ ! -f "${SRC_DIR}/${SOURCE_NAME}.osm.pbf" ]; then
	echo "Source ${SOURCE_NAME}.osm.pbf file does not exist"
	exit 1
fi

if [ -f "${CFG_DIR}/${CFG_NAME}.json" ]; then
	ADDITIONAL_PARAMS="${ADDITIONAL_PARAMS} -c ${CFG_DIR}/${CFG_NAME}.json"
fi

if [ -f "${CFG_DIR}/store_${CFG_NAME}.json" ]; then
	ADDITIONAL_PARAMS="${ADDITIONAL_PARAMS} -c ${CFG_DIR}/store_${CFG_NAME}.json"
fi

if [ -f "${CFG_DIR}/${HOST_NAME}.json" ]; then
	ADDITIONAL_PARAMS="${ADDITIONAL_PARAMS} -c ${CFG_DIR}/${HOST_NAME}.json"
fi

if [ -f "${CFG_DIR}/store_${HOST_NAME}.json" ]; then
	ADDITIONAL_PARAMS="${ADDITIONAL_PARAMS} -c ${CFG_DIR}/store_${HOST_NAME}.json"
fi

pushd "${BASE_PATH}"
if [ ! -d "${STORE_DEST}" ]; then
	mkdir -p "${STORE_DEST}" || exit 1
	touch "${STORE_DEST}/.ours" || exit 1
	MYCMD="${OSCAR_CREATE_BINARY} -c ${CFG_DIR}/common.json -c ${CFG_DIR}/store_all.json -c ${CFG_DIR}/store_grid${GRIDSIZE}.json ${ADDITIONAL_PARAMS} -i ${SRC_DIR}/${SOURCE_NAME}.osm.pbf -o ${STORE_DEST}"
	if [ ${USE_DEBUGGER} ]; then
		/usr/bin/time -v -o ${LOGFILE_PREFIX}.store.debugged.time ${MYCMD}
	else
		/usr/bin/time -v -o ${LOGFILE_PREFIX}.store.time  ${MYCMD} 2>&1 > ${LOGFILE_PREFIX}.store.log
	fi
		if [ $? -ne 0 ]; then
			echo "Failed to create store at ${STORE_DEST}"
			if [ -f "${STORE_DEST}/.ours" ]; then
				rm -r "${STORE_DEST}"
			fi
			exit 1
		fi
else
	echo "Store destination already exists at ${STORE_DEST}"
	exit 1
fi
popd
