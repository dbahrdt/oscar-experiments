#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
BASE_PATH=${SCRIPTPATH}

LOG_DIR="${BASE_PATH}/log"
SEARCH_DIR="${BASE_PATH}/search"
CFG_DIR="${BASE_PATH}/cfg"
JOSCAR_LIB_PATH="build_nodebug"

if [ -z "${NAME}" ]; then
	echo "No name given"
	exit 0
fi

LOGFILE_PREFIX=${LOG_DIR}/${NAME}
OSCAR_PRE_DEST=${SEARCH_DIR}/oscar-pre/${NAME}
OSCAR_SUB_DEST=${SEARCH_DIR}/oscar-sub/${NAME}
LUCENE_DEST=${SEARCH_DIR}/lucene/${NAME}
MG4J_DEST=${SEARCH_DIR}/mg4j/${NAME}

PREFIX_QUERIES=${BASE_PATH}/queries/prefix.xml
SUBSTRING_QUERIES=${BASE_PATH}/queries/substring.xml

./ocse.sh --oscar --lucene --lucene-path ${LUCENE_DEST} --mg4j --mg4j-path ${MG4J_DEST}/data -i ${CFG_DIR}/lists/k_values_substring_prefix.txt -q ${PREFIX_QUERIES} ${OSCAR_PRE_DEST} &> ${LOGFILE_PREFIX}.query.prefix

./ocse.sh --oscar --lucene --lucene-path ${LUCENE_DEST} -i ${CFG_DIR}/lists/k_values_substring_prefix.txt -q ${SUBSTRING_QUERIES} ${OSCAR_SUB_DEST} &> ${LOGFILE_PREFIX}.query.substring