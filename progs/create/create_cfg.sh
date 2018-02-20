#!/bin/bash

#BUILD_NAME and SOURCE_NAME need to be set

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
BASE_PATH=${SCRIPTPATH}

if [ -z "${BASE_PATH}" ]; then
	echo "Missing BASE_PATH"
	exit 1
fi

if [ -z "${BUILD_NAME}" ]; then
	echo "No build name given: ${BUILD_NAME}"
	exit 1
fi

if [ -z "${SOURCE_NAME}" ]; then
	echo "No source name given"
	exit 1
fi

if [ -z "${CFG_NAME}" ]; then
	echo "No config name given"
	exit 1
fi

if [ "${SEARCH_TYPE}" = "oscar" ] && [ -z "${SEARCH_OSCAR_TYPE}" ]; then
	echo "No oscar type given"
	exit 1
fi

if [ "${SEARCH_TYPE}" = "osi" ] && [ -z "${OSI_INDEX_TYPE}" ]; then
	echo "No osi index type given"
	exit 1
fi

HOST_NAME=$(hostname -f)
BUILD_DIR="${BASE_PATH}/../build/${BUILD_NAME}/"
VENDOR_DIR="${BASE_PATH}/../vendor/"
LOG_DIR="${BASE_PATH}/log"
SRC_DIR="${BASE_PATH}/src"
QUERIES_DIR="${BASE_PATH}/queries"
STORE_DIR="${BASE_PATH}/stores"
SEARCH_DIR="${BASE_PATH}/search"
STATS_DIR="${BASE_PATH}/stats"
CFG_DIR="${BASE_PATH}/cfg"
TEMP_DIR="${BASE_PATH}/tempdir"
export JOSCAR_LIB_PATH="${BUILD_DIR}/ocse/libjoscar"
LOGFILE_PREFIX=${LOG_DIR}/${SOURCE_NAME}.${CFG_NAME}
STORE_DEST=${STORE_DIR}/${CFG_NAME}/${SOURCE_NAME}
# SEARCH_OSCAR_PRE_DEST=${SEARCH_DIR}/oscar-pre/${CFG_NAME}/${SOURCE_NAME}
# SEARCH_OSCAR_SUB_DEST=${SEARCH_DIR}/oscar-sub/${CFG_NAME}/${SOURCE_NAME}
SEARCH_OSCAR_DEST=${SEARCH_DIR}/oscar-${SEARCH_OSCAR_TYPE}/${CFG_NAME}/${SOURCE_NAME}
SEARCH_OSCAR_TYPE_CFG=${CFG_DIR}/oomgeocell_${SEARCH_OSCAR_TYPE}.json
SEARCH_LUCENE_DEST=${SEARCH_DIR}/lucene/${CFG_NAME}/${SOURCE_NAME}
SEARCH_MG4J_DEST=${SEARCH_DIR}/mg4j/${CFG_NAME}/${SOURCE_NAME}
SEARCH_OSI_DEST=${SEARCH_DIR}/osi-compare/${CFG_NAME}/${SOURCE_NAME}/${OSI_INDEX_TYPE}

INSPECT_ITEM_INDEX_BINARY="${BUILD_DIR}/oscar/liboscar/sserialize/sserialize-tools/sserialize-tools_inspect_ItemIndexStore"
BENCHMARK_ITEM_INDEX_BINARY="${BUILD_DIR}/oscar/liboscar/sserialize/sserializebenchmarks/benchmarks_itemindex"
BENCHMARK_CODING="${BUILD_DIR}/oscar/liboscar/sserialize/sserializebenchmarks/benchmarks_coding"
BENCHMARK_BITPACKING="${BUILD_DIR}/bitpacking/bitpack-compare"
OSCAR_CREATE_BINARY="${BUILD_DIR}/oscar/oscar-create/oscar-create"
OSCAR_CMD_BINARY="${BUILD_DIR}/oscar/oscar-cmd/oscar-cmd"
OCSE_BINARY="${VENDOR_DIR}/ocse/run.sh"
OQ2Q_BINARY="${BUILD_DIR}/ocse/oq2q/oq2q"
FOQ_BINARY="${BUILD_DIR}/ocse/foq/foq"
OQS_BINARY="${BUILD_DIR}/ocse/oqs/oqs"
OSI_CREATE_BINARY="${BUILD_DIR}/osi-compare/osi-compare-create"
OSI_QUERY_BINARY="${BUILD_DIR}/osi-compare/osi-compare-query"

if [ ! -x "${INSPECT_ITEM_INDEX_BINARY}" ]; then
	echo "tools_inspect_ItemIndexStore binary does not existing at ${INSPECT_ITEM_INDEX_BINARY}"
	exit 1
fi

if [ ! -x "${BENCHMARK_ITEM_INDEX_BINARY}" ]; then
	echo "benchmarks_itemindex binary does not existing at ${BENCHMARK_ITEM_INDEX_BINARY}"
	exit 1
fi

if [ ! -x "${OSCAR_CREATE_BINARY}" ]; then
	echo "oscar-create binary does not existing at ${OSCAR_CREATE_BINARY}"
	exit 1
fi

if [ ! -x "${OSCAR_CMD_BINARY}" ]; then
	echo "oscar-cmd binary does not existing at ${OSCAR_CMD_BINARY}"
	exit 1
fi

if [ ! -x "${OCSE_BINARY}" ]; then
	echo "ocse binary does not existing at ${OCSE_BINARY}"
	exit 1
fi

if [ ! -x "${OQ2Q_BINARY}" ]; then
	echo "oq2q binary does not existing at ${OQ2Q_BINARY}"
	exit 1
fi

if [ ! -x "${FOQ_BINARY}" ]; then
	echo "foq binary does not existing at ${FOQ_BINARY}"
	exit 1
fi

if [ ! -x "${OSI_CREATE_BINARY}" ]; then
	echo "osi-compare-create binary does not existing at ${OSI_CREATE_BINARY}"
	exit 1
fi

if [ ! -x "${OSI_QUERY_BINARY}" ]; then
	echo "osi-compare-query binary does not existing at ${OSI_QUERY_BINARY}"
	exit 1
fi

if [ ! -f "${CFG_DIR}/${CFG_NAME}.json" ] && [ ! -f "${CFG_DIR}/store_${CFG_NAME}.json" ]; then
	echo "No config for selected config name"
	exit 1
fi

if [ ! -z "${SEARCH_OSCAR_TYPE}" ] && [ ! -f "${SEARCH_OSCAR_TYPE_CFG}" ]; then
	echo "No config for selected oscar search type ${SEARCH_OSCAR_TYPE} at ${SEARCH_OSCAR_TYPE_CFG}"
	exit 1
fi

if [ ! -d "${TEMP_DIR}" ]; then
	echo "Temp directory ${TEMP_DIR} does not exist"
	exit 1
fi

if [ "${BUILD_NAME}" = "debug" ] || [ "${USE_GDB}" = "y" ] || [ "${USE_GDB}" = "yes" ]; then
	USE_DEBUGGER=true
	OSCAR_CMD_BINARY="cgdb --args ${OSCAR_CMD_BINARY}"
	OSCAR_CREATE_BINARY="cgdb --args ${OSCAR_CREATE_BINARY}"
	OSI_CREATE_BINARY="cgdb --args ${OSI_CREATE_BINARY}"
fi

