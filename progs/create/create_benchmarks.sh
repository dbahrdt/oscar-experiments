#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
BASE_PATH=${SCRIPTPATH}

SEARCH_TYPE="${1}"
SEARCH_OSCAR_TYPE="${2}"

source "${BASE_PATH}/create_cfg.sh"

QUERIES_DEST_DIR="${QUERIES_DIR}/website/filtered"
QUERIES_DEST=${QUERIES_DEST_DIR}/${SOURCE_NAME}
OSCAR_QUERIES=${QUERIES_DEST}.txt
OSCAR_TEXT_QUERIES=${QUERIES_DEST}.text.txt
OSCAR_TEXT_SETOP_QUERIES=${QUERIES_DEST}.text.setops.txt
OSCAR_SPATIAL_QUERIES=${QUERIES_DEST}.spatial.txt
OCSE_QUERIES=${QUERIES_DEST}.text.nodiff.xml
OCSE_PREFIX_QUERIES=${QUERIES_DEST}.text.nodiff.prefix.xml
OSI_TEXT_QUERIES=${QUERIES_DEST}.text.osi.txt
OSI_TEXT_SETOP_QUERIES=${QUERIES_DEST}.text.setops.osi.txt

if [ ! -d "${STORE_DEST}" ]; then
	echo "Store does not exist"
	exit 1
fi

if [ ! -d ${SEARCH_OSCAR_DEST} ]; then
	echo "Oscar search destination does not exist"
	exit 1
fi

if [ ! -d ${QUERIES_DEST_DIR} ]; then
	echo "Query destination directory does not exit"
	exit 1
fi

cd "${BASE_PATH}"

if [ "${SEARCH_TYPE}" = "oscar" ]; then
	MY_LOGFILE_PREFIX="${LOGFILE_PREFIX}.${SEARCH_OSCAR_TYPE}.benchmark.oscar"
	
	MY_SOP="${MY_LOGFILE_PREFIX}.decelled.text"
	if [ ! -s "${MY_SOP}.stats" ]; then
		${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST} --mload index --mload kvstore --mload textsearch --benchmark i=${OSCAR_TEXT_QUERIES},o=${MY_SOP},t=decelled,tc=0,ghsg=pass,subset=false,items=true
	fi

	MY_SOP="${MY_LOGFILE_PREFIX}.decelled.text.setops"
	if [ ! -s "${MY_SOP}.stats" ]; then
		${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST} --mload index --mload kvstore --mload textsearch --benchmark i=${OSCAR_TEXT_SETOP_QUERIES},o=${MY_SOP},t=decelled,tc=0,ghsg=pass,subset=false,items=true
	fi

	MY_SOP="${MY_LOGFILE_PREFIX}.tcqr.text"
	if [ ! -s "${MY_SOP}.stats" ]; then
		${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST} --mload index --mload kvstore --mload textsearch --benchmark i=${OSCAR_TEXT_QUERIES},o=${MY_SOP},t=treedgeocell,tc=0,ghsg=pass,subset=true,items=true
	fi
	
	MY_SOP="${MY_LOGFILE_PREFIX}.tcqr.text.setops"
	if [ ! -s "${MY_SOP}.stats" ]; then	
		${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST} --mload index --mload kvstore --mload textsearch --benchmark i=${OSCAR_TEXT_SETOP_QUERIES},o=${MY_SOP},t=treedgeocell,tc=0,ghsg=pass,subset=true,items=true
	fi
	
	MY_SOP="${MY_LOGFILE_PREFIX}.cqr.text.setops"
	if [ ! -s "${MY_SOP}.stats" ]; then	
		${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST} --mload index --mload kvstore --mload textsearch --benchmark i=${OSCAR_TEXT_SETOP_QUERIES},o=${MY_SOP},t=geocell,tc=1,ghsg=pass,subset=true,items=true
	fi
	
	MY_SOP="${MY_LOGFILE_PREFIX}.cqr.text"
	if [ ! -s "${MY_SOP}.stats" ]; then	
		${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST} --mload index --mload kvstore --mload textsearch --benchmark i=${OSCAR_TEXT_QUERIES},o=${MY_SOP},t=geocell,tc=1,ghsg=pass,subset=true,items=true
	fi
	
	MY_SOP="${MY_LOGFILE_PREFIX}.tcqr.spatial"
	if [ ! -s "${MY_SOP}.stats" ]; then	
		${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST} --mload index --mload kvstore --mload textsearch --benchmark i=${OSCAR_SPATIAL_QUERIES},o=${MY_SOP},t=treedgeocell,tc=0,ghsg=pass,subset=true,items=true
	fi
		
	MY_SOP="${MY_LOGFILE_PREFIX}.cqr.spatial"
	if [ ! -s "${MY_SOP}.stats" ]; then
			${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST} --mload index --mload kvstore --mload textsearch --benchmark i=${OSCAR_SPATIAL_QUERIES},o=${MY_SOP},t=geocell,tc=1,ghsg=pass,subset=true,items=true
	fi
	
	#osi stuff
	MY_SOP="${MY_LOGFILE_PREFIX}.tcqr.osi-text"
	if [ ! -s "${MY_SOP}.stats" ]; then
		${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST} --mload index --mload kvstore --mload textsearch --benchmark i=${OSI_TEXT_QUERIES},o=${MY_SOP},t=treedgeocell,tc=0,ghsg=pass,subset=true,items=true
	fi
	
	MY_SOP="${MY_LOGFILE_PREFIX}.tcqr.osi-text.setops"
	if [ ! -s "${MY_SOP}.stats" ]; then	
		${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST} --mload index --mload kvstore --mload textsearch --benchmark i=${OSI_TEXT_SETOP_QUERIES},o=${MY_SOP},t=treedgeocell,tc=0,ghsg=pass,subset=true,items=true
	fi
	
	MY_SOP="${MY_LOGFILE_PREFIX}.cqr.osi-text.setops"
	if [ ! -s "${MY_SOP}.stats" ]; then	
		${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST} --mload index --mload kvstore --mload textsearch --benchmark i=${OSI_TEXT_SETOP_QUERIES},o=${MY_SOP},t=geocell,tc=1,ghsg=pass,subset=true,items=true
	fi
	
	MY_SOP="${MY_LOGFILE_PREFIX}.cqr.osi-text"
	if [ ! -s "${MY_SOP}.stats" ]; then	
		${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST} --mload index --mload kvstore --mload textsearch --benchmark i=${OSI_TEXT_QUERIES},o=${MY_SOP},t=geocell,tc=1,ghsg=pass,subset=true,items=true
	fi

fi

if [ "${SEARCH_TYPE}" = "osi" ]; then
	MY_LOGFILE_PREFIX="${LOGFILE_PREFIX}.${SEARCH_OSCAR_TYPE}.osi.${OSI_INDEX_TYPE}.benchmark"
	OSI_PARAMS="-f ${SEARCH_OSI_DEST} --preload --compact-hcqr --hcqr-cache 100"

	MY_SOP="${MY_LOGFILE_PREFIX}.tcqr.text"
	if [ ! -s "${MY_SOP}.log" ]; then
		${OSI_QUERY_BINARY} ${OSI_PARAMS} --benchmark ${OSI_TEXT_QUERIES} ${MY_SOP} "true" "false" 0 2>&1 > ${MY_SOP}.log
	else
		echo "Skipping ${MY_SOP}"
	fi
	
	MY_SOP="${MY_LOGFILE_PREFIX}.cqr.text"
	if [ ! -s "${MY_SOP}.log" ]; then
		${OSI_QUERY_BINARY} ${OSI_PARAMS} --benchmark ${OSI_TEXT_QUERIES} ${MY_SOP} "false" "false" 1 2>&1 > ${MY_SOP}.log
	else
		echo "Skipping ${MY_SOP}"
	fi
	
	MY_SOP="${MY_LOGFILE_PREFIX}.hcqr.text"
	if [ ! -s "${MY_SOP}.log" ]; then
		${OSI_QUERY_BINARY} -o ${SEARCH_OSCAR_DEST} ${OSI_PARAMS} --benchmark ${OSI_TEXT_QUERIES} ${MY_SOP} "false" "true" 1 2>&1 > ${MY_SOP}.log
	else
		echo "Skipping ${MY_SOP}"
	fi
	
	MY_SOP="${MY_LOGFILE_PREFIX}.tcqr.text.setops"
	if [ ! -s "${MY_SOP}.log" ]; then
		${OSI_QUERY_BINARY} ${OSI_PARAMS} --benchmark ${OSI_TEXT_SETOP_QUERIES} ${MY_SOP} "true" "false" 0 2>&1 > ${MY_SOP}.log
	else
		echo "Skipping ${MY_SOP}"
	fi
	
	MY_SOP="${MY_LOGFILE_PREFIX}.cqr.text.setops"
	if [ ! -s "${MY_SOP}.log" ]; then
		${OSI_QUERY_BINARY} ${OSI_PARAMS} --benchmark ${OSI_TEXT_SETOP_QUERIES} ${MY_SOP} "false" "false" 1 2>&1 > ${MY_SOP}.log
	else
		echo "Skipping ${MY_SOP}"
	fi
	
	MY_SOP="${MY_LOGFILE_PREFIX}.hcqr.text.setops"
	if [ ! -s "${MY_SOP}.log" ]; then
		${OSI_QUERY_BINARY} -o ${SEARCH_OSCAR_DEST} ${OSI_PARAMS} --benchmark ${OSI_TEXT_SETOP_QUERIES} ${MY_SOP} "false" "true" 1 2>&1 > ${MY_SOP}.log
	else
		echo "Skipping ${MY_SOP}"
	fi
fi

if [ "${SEARCH_TYPE}" = "oscar-cqr-tcqr" ]; then
	MY_LOGFILE_PREFIX="${LOGFILE_PREFIX}.${SEARCH_OSCAR_TYPE}.benchmark.oscar-cqr-tcqr"
	
	MY_SOP="${MY_LOGFILE_PREFIX}.text"
	if [ ! -s "${MY_SOP}.stats" ]; then
		${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST} --mload index --mload kvstore --mload textsearch --benchmark i=${OSCAR_TEXT_QUERIES},o=${MY_SOP},t=decelled,tc=0,ghsg=pass,subset=false,items=true
	fi
fi

if [ "${SEARCH_TYPE}" = "index" ]; then
	for i in native pfor regline wah rlede eliasfano for multi; do
		if [ ! -d ${SEARCH_OSCAR_DEST}/${i} ]; then
			echo "No data available for index ${i} at ${SEARCH_OSCAR_DEST}/${i}"
			continue
		fi
		MY_LOGFILE_PREFIX="${LOGFILE_PREFIX}.${SEARCH_OSCAR_TYPE}.benchmark.index"

		MY_SOP="${MY_LOGFILE_PREFIX}.${i}.cqr.text"
		if [ ! -s "${MY_SOP}.stats" ]; then
			echo "Will not create ${i} index benchmark for cqr and threads=1"
			#${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST}/${i} --mload index,kvstore,textsearch --benchmark i=${OSCAR_TEXT_QUERIES},o=${MY_SOP},t=geocell,tc=1,ghsg=pass,subset=false
		fi
		
		MY_SOP="${MY_LOGFILE_PREFIX}.${i}.tcqr.text"
		if [ ! -s "${MY_SOP}.stats" ]; then
			${OSCAR_CMD_BINARY} ${SEARCH_OSCAR_DEST}/${i} --mload index --mload kvstore --mload textsearch --benchmark i=${OSCAR_TEXT_QUERIES},o=${MY_SOP},t=treedgeocell,tc=0,ghsg=pass,subset=false

			echo "${MY_SOP}.stats already there"
		fi
	done
fi

if [ "${SEARCH_TYPE}" = "ocse-lucene" ]; then
	MY_LOGFILE_PREFIX="${LOGFILE_PREFIX}.benchmark.ocse.lucene"
	${OCSE_BINARY} -i ${CFG_DIR}/lists/k_values_substring_prefix.txt --lucene --lucene-path ${SEARCH_LUCENE_DEST} -q ${OCSE_QUERIES} --stats-out-prefix ${MY_LOGFILE_PREFIX}.substring.run0 ${SEARCH_OSCAR_DEST} > ${MY_LOGFILE_PREFIX}.substring.run0.txt
	${OCSE_BINARY} -i ${CFG_DIR}/lists/k_values_substring_prefix.txt --lucene --lucene-path ${SEARCH_LUCENE_DEST} -q ${OCSE_QUERIES} --stats-out-prefix ${MY_LOGFILE_PREFIX}.substring.run1 ${SEARCH_OSCAR_DEST} > ${MY_LOGFILE_PREFIX}.substring.run1.txt
	${OCSE_BINARY} -i ${CFG_DIR}/lists/k_values_substring_prefix.txt --lucene --lucene-path ${SEARCH_LUCENE_DEST} -q ${OCSE_PREFIX_QUERIES} --stats-out-prefix ${MY_LOGFILE_PREFIX}.prefix.run0 ${SEARCH_OSCAR_DEST} > ${MY_LOGFILE_PREFIX}.prefix.run0.txt
	${OCSE_BINARY} -i ${CFG_DIR}/lists/k_values_substring_prefix.txt --lucene --lucene-path ${SEARCH_LUCENE_DEST} -q ${OCSE_PREFIX_QUERIES} --stats-out-prefix ${MY_LOGFILE_PREFIX}.prefix.run1 ${SEARCH_OSCAR_DEST} > ${MY_LOGFILE_PREFIX}.prefix.run1.txt

fi

if [ "${SEARCH_TYPE}" = "ocse-oscar" ]; then
	if [ "${USE_GDB}" = "y" ]; then
		${OCSE_BINARY} -i ${CFG_DIR}/lists/k_values_substring_prefix.txt --oscar -q ${OCSE_QUERIES} ${SEARCH_OSCAR_DEST} 
	else
		MY_LOGFILE_PREFIX="${LOGFILE_PREFIX}.benchmark.ocse.oscar.${SEARCH_OSCAR_TYPE}"
		${OCSE_BINARY} -i ${CFG_DIR}/lists/k_values_substring_prefix.txt --oscar -q ${OCSE_QUERIES} --stats-out-prefix ${MY_LOGFILE_PREFIX}.substring.run0 ${SEARCH_OSCAR_DEST} > ${MY_LOGFILE_PREFIX}.substring.run0.txt
		${OCSE_BINARY} -i ${CFG_DIR}/lists/k_values_substring_prefix.txt --oscar -q ${OCSE_QUERIES} --stats-out-prefix ${MY_LOGFILE_PREFIX}.substring.run1 ${SEARCH_OSCAR_DEST} > ${MY_LOGFILE_PREFIX}.substring.run1.txt

		${OCSE_BINARY} -i ${CFG_DIR}/lists/k_values_substring_prefix.txt --oscar -q ${OCSE_PREFIX_QUERIES} --stats-out-prefix ${MY_LOGFILE_PREFIX}.prefix.run0 ${SEARCH_OSCAR_DEST} > ${MY_LOGFILE_PREFIX}.prefix.run0.txt
		${OCSE_BINARY} -i ${CFG_DIR}/lists/k_values_substring_prefix.txt --oscar -q ${OCSE_PREFIX_QUERIES} --stats-out-prefix ${MY_LOGFILE_PREFIX}.prefix.run1 ${SEARCH_OSCAR_DEST} > ${MY_LOGFILE_PREFIX}.prefix.run1.txt
	fi
fi

if [ "${SEARCH_TYPE}" = "ocse-mg4j" ]; then
		MY_LOGFILE_PREFIX="${LOGFILE_PREFIX}.benchmark.ocse.mg4j.prefix"
	${OCSE_BINARY} -i ${CFG_DIR}/lists/k_values_substring_prefix.txt --mg4j --mg4j-path ${SEARCH_MG4J_DEST}/data -q ${OCSE_PREFIX_QUERIES} --stats-out-prefix ${MY_LOGFILE_PREFIX}.run0 ${SEARCH_OSCAR_DEST} > ${MY_LOGFILE_PREFIX}.run0.txt
	${OCSE_BINARY} -i ${CFG_DIR}/lists/k_values_substring_prefix.txt --mg4j --mg4j-path ${SEARCH_MG4J_DEST}/data -q ${OCSE_PREFIX_QUERIES} --stats-out-prefix ${MY_LOGFILE_PREFIX}.run1 ${SEARCH_OSCAR_DEST} > ${MY_LOGFILE_PREFIX}.run1.txt
fi

if [ "${SEARCH_TYPE}" = "sserialize" ]; then
	echo "Executing ${BENCHMARK_CODING}"
	echo "Destination: ${LOG_DIR}/benchmark.coding.${BUILD_NAME}.txt"
	${BENCHMARK_CODING} 1000000000 1000000001 10 100 random > "${LOG_DIR}/benchmark.coding.random.${BUILD_NAME}.txt"
	${BENCHMARK_CODING} 1000000000 1000000001 10 100 range > "${LOG_DIR}/benchmark.coding.range.${BUILD_NAME}.txt"
fi

if [ "${SEARCH_TYPE}" = "bitpacking" ]; then
	echo "Executing ${BENCHMARK_BITPACKING}"
	${BENCHMARK_BITPACKING} -bb 1 -e 32 -s 25 -r 10 -b sserialize -b forblock -b fastpfor --sep '&' > "${LOG_DIR}/benchmark.coding.bitpacking.${BUILD_NAME}.txt"
fi

exit 0
