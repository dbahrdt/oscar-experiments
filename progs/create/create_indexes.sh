#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
BASE_PATH=${SCRIPTPATH}

SEARCH_OSCAR_TYPE="${1}"

source "${BASE_PATH}/create_cfg.sh"

if [ ! -d "${STORE_DEST}" ]; then
	echo "Store does not exist"
	exit 1
fi

if [ ! -d ${SEARCH_OSCAR_DEST} ]; then
	echo "Oscar search destination does not exist"
	exit 1
fi


if [ ! -f  "${SEARCH_OSCAR_DEST}/index" ]; then
	echo "No index file in search destination"
	exit 1
fi


cd "${BASE_PATH}"

for i in native regline wah rlede eliasfano pfor for; do
	if [ ! -f "${SEARCH_OSCAR_DEST}/index.${i}" ] && [ ! -f "${SEARCH_OSCAR_DEST}/${i}/index" ]; then
		${INSPECT_ITEM_INDEX_BINARY} -cc -nd -t ${i} -o "${SEARCH_OSCAR_DEST}/index.${i}" "${SEARCH_OSCAR_DEST}/index"
	fi
	if [ -f "${SEARCH_OSCAR_DEST}/index.${i}" ]; then
		mkdir ${SEARCH_OSCAR_DEST}/${i} || exit 1
		mv "${SEARCH_OSCAR_DEST}/index.${i}" "${SEARCH_OSCAR_DEST}/${i}/index"
		ln -s "${SEARCH_OSCAR_DEST}/kvstore" "${SEARCH_OSCAR_DEST}/${i}/kvstore"
		ln -s "${SEARCH_OSCAR_DEST}/textsearch" "${SEARCH_OSCAR_DEST}/${i}/textsearch"	
	fi
done

if [ ! -f "${SEARCH_OSCAR_DEST}/index.multi" ] && [ ! -f "${SEARCH_OSCAR_DEST}/multi/index" ]; then
	${INSPECT_ITEM_INDEX_BINARY} -cc -nd -t native -t wah -t rlede -t eliasfano -t pfor -t for -o "${SEARCH_OSCAR_DEST}/index.multi" "${SEARCH_OSCAR_DEST}/index"
fi

if [ -f "${SEARCH_OSCAR_DEST}/index.multi" ]; then
	mkdir ${SEARCH_OSCAR_DEST}/multi || exit 1
	mv "${SEARCH_OSCAR_DEST}/index.multi" "${SEARCH_OSCAR_DEST}/multi/index"
	ln -s "${SEARCH_OSCAR_DEST}/kvstore" "${SEARCH_OSCAR_DEST}/multi/kvstore"
	ln -s "${SEARCH_OSCAR_DEST}/textsearch" "${SEARCH_OSCAR_DEST}/multi/textsearch"	
fi

exit 0
