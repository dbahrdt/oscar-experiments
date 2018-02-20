#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
BASE_PATH=${SCRIPTPATH}

SEARCH_TYPE="${1}"

if [ "${SEARCH_TYPE}" = "oscar" ] || [ "${SEARCH_TYPE}" = "osi" ]; then
	SEARCH_OSCAR_TYPE="${2}"
fi

source "${BASE_PATH}/create_cfg.sh"

if [ ! -d "${STORE_DEST}" ]; then
	echo "Store does not exist"
	exit 1
fi

cd "${BASE_PATH}"

if [ -f "${CFG_DIR}/${HOST_NAME}.json" ]; then
	ADDITIONAL_PARAMS="${ADDITIONAL_PARAMS} -c ${CFG_DIR}/${HOST_NAME}.json"
fi

if [ -f "${CFG_DIR}/search_${HOST_NAME}.json" ]; then
	ADDITIONAL_PARAMS="${ADDITIONAL_PARAMS} -c ${CFG_DIR}/search_${HOST_NAME}.json"
fi

if [ "${SEARCH_TYPE}" = "oscar" ]; then
	if [ ! -d ${SEARCH_OSCAR_DEST} ]; then
		mkdir -p "${SEARCH_OSCAR_DEST}" || exit 1
		touch "${SEARCH_OSCAR_DEST}/.ours" || exit 1
		TIMEFILE_PATH=${LOGFILE_PREFIX}.search.oscar-${SEARCH_OSCAR_TYPE}.time
		LOGFILE_PATH=${LOGFILE_PREFIX}.search.oscar-${SEARCH_OSCAR_TYPE}.log

		/usr/bin/time -v -o ${TIMEFILE_PATH} ${OSCAR_CREATE_BINARY} -c ${CFG_DIR}/common.json -c ${CFG_DIR}/oomgeocell.json ${ADDITIONAL_PARAMS} -c ${SEARCH_OSCAR_TYPE_CFG} -i ${STORE_DEST} -o ${SEARCH_OSCAR_DEST} 2>&1 > ${LOGFILE_PATH}

		if [ $? -ne 0 ]; then
			echo "Failed to create search for oscar at ${SEARCH_OSCAR_DEST}"
# 			rm ${TIMEFILE_PATH}
# 			rm ${LOGFILE_PATH}
			#rm ${TEMP_DIR}/fast/*
			#rm ${TEMP_DIR}/slow/*
			if [ -f "${SEARCH_OSCAR_DEST}/.ours" ]; then
				rm -r ${SEARCH_OSCAR_DEST}
			fi
			exit 1
		fi
	else
		echo "Search destination for oscar-${SEARCH_OSCAR_TYPE} already exists at ${SEARCH_OSCAR_DEST}."
		exit 1
	fi
fi

if [ "${SEARCH_TYPE}" = "osi" ]; then
	if [ ! -d ${SEARCH_OSCAR_DEST} ]; then
		echo "Need oscar search files to create osi files. None available at ${SEARCH_OSCAR_DEST}"
		exit 1
	fi
	if [ -z "${OSI_INDEX_TYPE}" ]; then
		echo "osi index type not set"
		exit 1
	fi
	if [ -z "${OSI_LEVELS}" ]; then
		echo "osi levels not set"
		exit 1
	fi
	if [ ! -d ${SEARCH_OSI_DEST} ]; then
		mkdir -p "${SEARCH_OSI_DEST}" || exit 1
		touch "${SEARCH_OSI_DEST}/.ours" || exit 1
		TIMEFILE_PATH=${LOGFILE_PREFIX}.search.osi.${OSI_INDEX_TYPE}.${SEARCH_OSCAR_TYPE}.time
		LOGFILE_PATH=${LOGFILE_PREFIX}.search.osi.${OSI_INDEX_TYPE}.${SEARCH_OSCAR_TYPE}.log
		OSI_PARAMETERS="-f ${SEARCH_OSCAR_DEST} -o ${SEARCH_OSI_DEST} --index-type ${OSI_INDEX_TYPE} -l ${OSI_LEVELS} --tempdir ${TEMP_DIR}/fast/osi -t 0 -st 0"
		if [ ${USE_DEBUGGER} ]; then
			${OSI_CREATE_BINARY} ${OSI_PARAMETERS}
		else
			/usr/bin/time -v -o ${TIMEFILE_PATH} ${OSI_CREATE_BINARY} ${OSI_PARAMETERS} 2>&1 > ${LOGFILE_PATH}
		fi
		
		if [ $? -ne 0 ]; then
			echo "Failed to create search for osi at ${SEARCH_OSI_DEST}"
			if [ -f "${SEARCH_OSI_DEST}/.ours" ]; then
				rm -r ${SEARCH_OSI_DEST}
			fi
			exit 1
		fi
	else
		echo "Skipping ${SEARCH_OSI_DEST}"
	fi
fi

if [ "${SEARCH_TYPE}" = "mg4j" ]; then
	if [ ! -d ${SEARCH_MG4J_DEST} ]; then
		mkdir -p "${SEARCH_MG4J_DEST}" || exit 1
		touch "${SEARCH_MG4J_DEST}/.ours" || exit 1
		export TIME_BENCH="${LOGFILE_PREFIX}.search.mg4j.time"
		${OCSE_BINARY} --mg4j-build --mg4j-path ${SEARCH_MG4J_DEST}/data -i ${CFG_DIR}/lists/k_values_substring_prefix.txt ${STORE_DEST} 2>&1 > ${LOGFILE_PREFIX}.search.mg4j.log
		
		if [ $? -ne 0 ]; then
			echo "Failed to create search for mg4j at ${SEARCH_MG4J_DEST}"
# 			rm ${TIME_BENCH}
# 			rm ${LOGFILE_PREFIX}.search.mg4j.log
			if [ -f "${SEARCH_MG4J_DEST}/.ours" ]; then
				rm -r ${SEARCH_MG4J_DEST}
			fi
			exit 1
		fi
	fi
fi

if [ "${SEARCH_TYPE}" = "lucene" ]; then
	if [ ! -d ${SEARCH_LUCENE_DEST} ]; then
		mkdir -p "${SEARCH_LUCENE_DEST}" || exit 1
		touch "${SEARCH_LUCENE_DEST}/.ours" || exit 1
		export TIME_BENCH="${LOGFILE_PREFIX}.search.lucene.time"
		${OCSE_BINARY} --lucene-build --lucene-path ${SEARCH_LUCENE_DEST} -i ${CFG_DIR}/lists/k_values_substring_prefix.txt ${STORE_DEST} 2>&1 > ${LOGFILE_PREFIX}.search.lucene.log
		
		if [ $? -ne 0 ]; then
			echo "Failed to create search for lucene at ${SEARCH_LUCENE_DEST}"
# 			rm ${TIME_BENCH}
# 			rm ${LOGFILE_PREFIX}.search.mg4j.log
			if [ -f "${SEARCH_LUCENE_DEST}/.ours" ]; then
				rm -r ${SEARCH_LUCENE_DEST}
			fi
			exit 1
		fi
	fi
fi

exit 0
