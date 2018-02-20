#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
BASE_PATH=${SCRIPTPATH}

SEARCH_OSCAR_TYPE="${1}"

source "${BASE_PATH}/create_cfg.sh"

QUERIES_SRC="${QUERIES_DIR}/website/combined.uniq"
QUERIES_DEST_DIR="${QUERIES_DIR}/website/filtered"
QUERIES_DEST=${QUERIES_DEST_DIR}/${SOURCE_NAME}

if [ ! -d "${STORE_DEST}" ]; then
	echo "Store does not exist"
	exit 1
fi

if [ ! -d ${SEARCH_OSCAR_DEST} ]; then
	echo "Oscar search destination does not exist"
	exit 1
fi

if [ ! -f "${QUERIES_SRC}" ]; then
	echo "No queries to analyze"
	exit 1
fi

if [ ! -d ${QUERIES_DEST_DIR} ]; then
	echo "Query destination directory does not exit"
	exit 1
fi

cd "${BASE_PATH}"


if [ ! -f ${QUERIES_DEST}.txt ]; then
	cat "${QUERIES_SRC}" | ${FOQ_BINARY} --filter "${SEARCH_OSCAR_DEST}" > ${QUERIES_DEST}.txt
	if [ $? -ne 0 ]; then
		echo "Failed to create queries"
		exit 1
	fi
fi

if [ ! -f ${QUERIES_DEST}.text.txt ]; then
	cat "${QUERIES_SRC}" | ${FOQ_BINARY} --only-text --filter "${SEARCH_OSCAR_DEST}" > ${QUERIES_DEST}.text.txt
	if [ $? -ne 0 ]; then
		echo "Failed to create text queries"
		exit 1
	fi
fi

if [ ! -f ${QUERIES_DEST}.text.setops.txt ]; then
	cat "${QUERIES_DEST}.text.txt" | ${FOQ_BINARY} --with-setop > ${QUERIES_DEST}.text.setops.txt
	if [ $? -ne 0 ]; then
		echo "Failed to create text setop queries"
		exit 1
	fi
fi

if [ ! -f ${QUERIES_DEST}.spatial.txt ]; then
	cat "${QUERIES_SRC}" | ${FOQ_BINARY} --with-spatial --filter "${SEARCH_OSCAR_DEST}" > ${QUERIES_DEST}.spatial.txt
	if [ $? -ne 0 ]; then
		echo "Failed to create spatial queries"
		exit 1
	fi
fi

if [ ! -f ${QUERIES_DEST}.text.nodiff.txt ]; then
	cat "${QUERIES_DEST}.text.txt" | ${FOQ_BINARY} --no-set-difference > ${QUERIES_DEST}.text.nodiff.txt
	if [ $? -ne 0 ]; then
		echo "Failed to create text queries"
		exit 1
	fi
fi

if [ ! -f ${QUERIES_DEST}.text.xml ]; then
	cat ${QUERIES_DEST}.txt | ${OQ2Q_BINARY} > ${QUERIES_DEST}.text.xml
	if [ $? -ne 0 ]; then
		echo "Failed to create ocse queries"
		exit 1
	fi
fi

if [ ! -f ${QUERIES_DEST}.text.nodiff.xml ]; then
	cat ${QUERIES_DEST}.text.nodiff.txt | ${OQ2Q_BINARY} > ${QUERIES_DEST}.text.nodiff.xml
	if [ $? -ne 0 ]; then
		echo "Failed to create ocse queries"
		exit 1
	fi
fi

if [ ! -f ${QUERIES_DEST}.text.prefix.xml ]; then
	cat ${QUERIES_DEST}.text.txt | ${OQ2Q_BINARY} -s2p > ${QUERIES_DEST}.text.prefix.xml
	if [ $? -ne 0 ]; then
		echo "Failed to create ocse prefix queries"
		exit 1
	fi
fi

if [ ! -f ${QUERIES_DEST}.text.nodiff.prefix.xml ]; then
	cat ${QUERIES_DEST}.text.nodiff.txt | ${OQ2Q_BINARY} -s2p > ${QUERIES_DEST}.text.nodiff.prefix.xml
	if [ $? -ne 0 ]; then
		echo "Failed to create ocse prefix queries"
		exit 1
	fi
fi

for i in $(ls -1 ${QUERIES_DEST}*.txt); do
	grep -v " in " $i | egrep -v '^in .*' | grep -v '\$' > ${QUERIES_DEST_DIR}/$(basename ${i} .txt).osi.txt;
done

exit 0
