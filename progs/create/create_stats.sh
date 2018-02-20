#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
BASE_PATH=${SCRIPTPATH}

SEARCH_TYPE="${1}"
SEARCH_OSCAR_TYPE="${2}"

source "${BASE_PATH}/create_cfg.sh"

if [ ! -d "${STORE_DEST}" ]; then
	echo "Store does not exist"
	exit 1
fi


cd "${BASE_PATH}"

if [ "${SEARCH_TYPE}" = "store" ]; then
	MY_OUT_FN="${LOGFILE_PREFIX}.store.stats"
	if [ ! -f "${MY_OUT_FN}.db.stats" ]; then
		${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST} -dsf db,${MY_OUT_FN}
	fi
fi

if [ "${SEARCH_TYPE}" = "index" ]; then
	if [ ! -d ${SEARCH_OSCAR_DEST} ]; then
		echo "Oscar search destination does not exist"
		exit 1
	fi

	MY_OUT_FN="${LOGFILE_PREFIX}.${SEARCH_OSCAR_TYPE}"
	if [ ! -f "${MY_OUT_FN}.index.stats.idxstore.stats" ]; then
		${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST} -dsf idxstore,${MY_OUT_FN}.index.stats
	fi
fi

if [ "${SEARCH_TYPE}" = "textsearch" ]; then
	if [ ! -d ${SEARCH_OSCAR_DEST} ]; then
		echo "Oscar search destination does not exist"
		exit 1
	fi

	MY_OUT_FN="${LOGFILE_PREFIX}.${SEARCH_OSCAR_TYPE}"
	if [ ! -f "${MY_OUT_FN}.textsearch.stats" ]; then
		${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST} -dsf compgeocell,${MY_OUT_FN}.textsearch.stats
	fi

fi

if [ "${SEARCH_TYPE}" = "geohierarchy" ]; then
	if [ ! -d ${SEARCH_OSCAR_DEST} ]; then
		echo "Oscar search destination does not exist"
		exit 1
	fi

	MY_OUT_FN="${LOGFILE_PREFIX}.${SEARCH_OSCAR_TYPE}"
	if [ ! -f "${MY_OUT_FN}.geohierarchy.stats" ]; then
		${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST} -dsf gh,${MY_OUT_FN}.geohierarchy.stats
	fi
fi

if [ "${SEARCH_TYPE}" = "regionarrangement" ]; then
	if [ ! -d ${SEARCH_OSCAR_DEST} ]; then
		echo "Oscar search destination does not exist"
		exit 1
	fi

	MY_OUT_FN="${LOGFILE_PREFIX}.${SEARCH_OSCAR_TYPE}"
	if [ ! -f "${MY_OUT_FN}.regionarrangement.stats" ]; then
		${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST} -dsf ra,${MY_OUT_FN}.regionarrangement.stats
	fi
fi

if [ "${SEARCH_TYPE}" = "osi" ]; then
	if [ ! -d ${SEARCH_OSI_DEST} ]; then
		echo "Osi search destination does not exist"
		exit 1
	fi

	MY_OUT_FN="${LOGFILE_PREFIX}.${SEARCH_OSCAR_TYPE}.osi.stats"
	if [ ! -f "${MY_OUT_FN}" ]; then
		${OSI_QUERY_BINARY} -f ${SEARCH_OSI_DEST} --stats > ${MY_OUT_FN}
	fi
fi

if [ "${SEARCH_TYPE}" = "queries" ]; then
	FILTERED_QUERIES_DEST_DIR="${QUERIES_DIR}/website/filtered"
	MY_STATS_DIR="${STATS_DIR}/queries"
	for i in $(ls -1 ${FILTERED_QUERIES_DEST_DIR}/*.txt); do
		${OQS_BINARY} -f ${i} -o ${MY_STATS_DIR}/$(basename ${i} .txt).stats.raw > ${MY_STATS_DIR}/$(basename ${i} .txt).stats
	done
fi

exit 0
