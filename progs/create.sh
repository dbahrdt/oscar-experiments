#!/bin/bash
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
BASE_PATH=${SCRIPTPATH}
VENDOR_PATH="${BASE_PATH}/vendor"
CREATE_PATH="${BASE_PATH}/create"

print_help() {
	echo "create.sh -t=<type> -s=<source name> -c=<config name> -b=<build name> -ot=<oscar-type> --osi-index-type=<h3|htm> --osi-levels=<number>"
}

for i in "$@"
do
case $i in
	-t=*|--create-type=*)
	CREATE_TYPE="${i#*=}"
	shift # past argument=value
	;;
	-s=*|--source-name=*)
	SOURCE_NAME="${i#*=}"
	shift # past argument=value
	;;
	-c=*|--cfg-name=*)
	CFG_NAME="${i#*=}"
	shift # past argument=value
	;;
	-b=*|--build-name=*)
	BUILD_NAME="${i#*=}"
	shift # past argument=value
	;;
	-ot=*|--oscar-type=*)
	OSCAR_TYPE="${i#*=}"
	shift # past argument with no value
	;;
	--osi-index-type=*)
	OSI_INDEX_TYPE="${i#*=}"
	shift # past argument with no value
	;;
	--osi-levels=*)
	OSI_LEVELS="${i#*=}"
	shift # past argument with no value
	;;
	*)
	echo "Unkown option: $i"
			# unknown option
	;;
esac
done

export CREATE_TYPE
export SOURCE_NAME
export CFG_NAME
export BUILD_NAME
export OSCAR_TYPE
export OSI_INDEX_TYPE
export OSI_LEVELS

if [ -z $CREATE_TYPE ]; then
	echo "No create type given"
	print_help
	exit 1
fi

if [ -z $SOURCE_NAME ]; then
	echo "No source name given"
	print_help
	exit 1
fi

if [ -z $CFG_NAME ]; then
	echo "No config name given, defaulting to cellsplit1k"
	CFG_NAME="cellsplit1k"
fi

if [ -z $BUILD_NAME ]; then
	echo "No build type given, defaulting to ultra"
	BUILD_NAME="ultra"
fi

if [ "${CREATE_TYPE}" = "oscar" ] || [ "${CREATE_TYPE}" = "all" ] || [ "${CREATE_TYPE}" = "oscar-all" ] || [ "${CREATE_TYPE}" = "osi" ]; then
	if [ -z "${OSCAR_TYPE}" ]; then
		echo "No oscar type given"
		exit 1
	fi
fi

if [ "${CREATE_TYPE}" = "osi-create" ]; then
	if [ -z "${OSI_INDEX_TYPE}" ]; then
		echo "No osi type given"
		exit 1
	fi
	if  [ -z "${OSI_LEVELS}" ]; then
		echo "No osi levels given"
		exit 1
	fi
fi

if [ "${SOURCE_NAME}" = "de" ] || [ "${SOURCE_NAME}" = "germany" ] ; then
	export GRIDSIZE=500
elif [ "${SOURCE_NAME}" = "eu" ] || [ "${SOURCE_NAME}" = "europe" ] ; then
	export GRIDSIZE=1000
elif [ "${SOURCE_NAME}" = "pl" ] || [ "${SOURCE_NAME}" = "planet" ] ; then
	export GRIDSIZE=3000
elif [ -z "${GRIDSIZE}" ]; then
	echo "No default grid size for source ${SOURCE_NAME} set and non given in environment. Defaulting to 100"
	export GRIDSIZE=100
fi

if [ "${CREATE_TYPE}" = "speed-check" ] ; then
	${CREATE_PATH}/speed_check.sh
fi

if [ "${CREATE_TYPE}" = "download" ] || [ "${CREATE_TYPE}" = "all" ] || [ "${CREATE_TYPE}" = "oscar-all" ] ; then
	${CREATE_PATH}/download_sources.sh
fi

if [ "${CREATE_TYPE}" = "store" ] || [ "${CREATE_TYPE}" = "all" ] || [ "${CREATE_TYPE}" = "oscar-all" ] ; then
	${CREATE_PATH}/create_store.sh
fi

if [ "${CREATE_TYPE}" = "oscar" ] || [ "${CREATE_TYPE}" = "all" ] || [ "${CREATE_TYPE}" = "oscar-all" ] ; then
	${CREATE_PATH}/create_search.sh "oscar" ${OSCAR_TYPE}
fi

if [ "${CREATE_TYPE}" = "osi-create" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_search.sh "osi" ${OSCAR_TYPE}
fi

if [ "${CREATE_TYPE}" = "lucene" ] || [ "${CREATE_TYPE}" = "all" ] ; then
	${CREATE_PATH}/create_search.sh "lucene"
fi

if [ "${CREATE_TYPE}" = "mg4j" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_search.sh "mg4j"
fi
 
if [ "${CREATE_TYPE}" = "queries" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_queries.sh ${OSCAR_TYPE}
fi

if [ "${CREATE_TYPE}" = "indexes" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_indexes.sh ${OSCAR_TYPE}
fi

if [ "${CREATE_TYPE}" = "sserialize-bench" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_benchmarks.sh "sserialize" ${OSCAR_TYPE}
fi

if [ "${CREATE_TYPE}" = "bitpacking-bench" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_benchmarks.sh "bitpacking" ${OSCAR_TYPE}
fi

if [ "${CREATE_TYPE}" = "oscar-bench" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_benchmarks.sh "oscar" ${OSCAR_TYPE}
fi

if [ "${CREATE_TYPE}" = "osi-bench" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_benchmarks.sh "osi" ${OSCAR_TYPE}
fi

if [ "${CREATE_TYPE}" = "index-bench" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_benchmarks.sh "index" ${OSCAR_TYPE}
fi

if [ "${CREATE_TYPE}" = "ocse-oscar" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_benchmarks.sh "ocse-oscar" ${OSCAR_TYPE}
fi

if [ "${CREATE_TYPE}" = "ocse-lucene" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_benchmarks.sh "ocse-lucene" ${OSCAR_TYPE}
fi

if [ "${CREATE_TYPE}" = "ocse-mg4j" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_benchmarks.sh "ocse-mg4j" ${OSCAR_TYPE}
fi

if [ "${CREATE_TYPE}" = "store-stats" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_stats.sh "store" ${OSCAR_TYPE}
fi
 
if [ "${CREATE_TYPE}" = "index-stats" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_stats.sh "index" ${OSCAR_TYPE}
fi

if [ "${CREATE_TYPE}" = "textsearch-stats" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_stats.sh "textsearch" ${OSCAR_TYPE}
fi

if [ "${CREATE_TYPE}" = "geohierarchy-stats" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_stats.sh "geohierarchy" ${OSCAR_TYPE}
fi

if [ "${CREATE_TYPE}" = "regionarrangement-stats" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_stats.sh "regionarrangement" ${OSCAR_TYPE}
fi

if [ "${CREATE_TYPE}" = "osi-stats" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_stats.sh "osi" ${OSCAR_TYPE}
fi

if [ "${CREATE_TYPE}" = "query-stats" ] || [ "${CREATE_TYPE}" = "all" ]; then
	${CREATE_PATH}/create_stats.sh "queries" ${OSCAR_TYPE}
fi
