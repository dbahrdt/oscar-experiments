#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
BASE_PATH=${SCRIPTPATH}
VENDOR_PATH="${BASE_PATH}/vendor"
DATA_PATH="${BASE_PATH}/../data/"

UPDATE_REPOS="n"
UPDATE_WEBSITE_QUERIES="n"
NPROC=$(nproc)

GCC_VERSION_MAJOR=$(gcc -dumpversion | grep -o -e "^[0-9]")
GCC_VERSION_MINOR=$(gcc -dumpversion | grep -o -e "^[0-9]\.[0-9]")

export CMAKE_GCC_VERSION_FOR_LTO=$(gcc -dumpversion | grep -o -e "^[0-9]\.[0-9]")

if [ -x "/usr/bin/gcc-${GCC_VERSION_MINOR}" ]; then
	export CMAKE_GCC_VERSION_FOR_LTO="${GCC_VERSION_MINOR}"
elif [ -x "/usr/bin/gcc-${GCC_VERSION_MAJOR}" ]; then
	export CMAKE_GCC_VERSION_FOR_LTO="${GCC_VERSION_MAJOR}"
else
	echo "Could not determine gcc version"
	exit 1
fi


print_help() {
	echo "setup.sh [--update-repos] [--update-queries]"
}

for i in "$@"
do
case $i in
	-ur|--update-repos)
	UPDATE_REPOS="y"
	shift # past argument=value
	;;
	-uq|--update-queries)
	UPDATE_WEBSITE_QUERIES="y"
	shift # past argument=value
	;;
	*)
	echo "Unkown option: $i"
	exit 1
			# unknown option
	;;
esac
done

update_repos() {
	git submodule update --remote --recursive ${VENDOR_PATH}/*
}

update_website_queries() {
	OQ2Q="${BASE_PATH}/build/${BUILD_NAME}/ocse/oq2q/oq2q"
	QUERY_STORAGE="${DATA_PATH}/queries/website/"

	if [ ! -x "${OQ2Q}" ]; then
		echo "Unable to convert oscar website queries to ocse queries. Missing oq2q"
		return 1
	fi

	if [ ! -d "${QUERY_STORAGE}" ]; then
		echo "Destination folder for oscar website queries is missing"
		return 1
	fi

	pushd "${QUERY_STORAGE}"

	rsync -v oscar@krilljump:/home/oscar/oscardev/service/log/search.log oscardev.raw || return 1
	rsync -v oscar@krilljump:/home/oscar/backup/oscarold/log/search.log oscarold.raw || return 1

	cat oscardev.raw oscarold.raw | perl -n -e '/.*q=\[(.*)\],\ .*/ && print $1 . "\n"' | sort -n > combined.all
	cat combined.all | uniq > combined.uniq
	cat oscardev.raw oscarold.raw | perl -n -e '/.*ip=((\d{1,3}.){3}\d{1,3}),\ .*/ && print $1 . "\n"' | sort -n | uniq > ips.txt

	echo "Converting $(cat combined.uniq | wc -l) uniq queries into ocse queries"
	cat combined.uniq | ${OQ2Q} > queries.xml
	cat combined.uniq | ${OQ2Q} -s2p > prefix_queries.xml

	popd
}

setup_build() {
	if [ -z "${BUILD_NAME}" ]; then
		echo "No build name set"
		return
	fi

	if [ -z "${BUILD_OPTIONS}" ]; then
		echo "No build options are set"
		return
	fi

	if [ ! -d "${BASE_PATH}/build" ]; then
		mkdir "${BASE_PATH}/build"
	fi

	BUILD_PATH="${BASE_PATH}/build/${BUILD_NAME}"

	if [ ! -d "${BUILD_PATH}" ]; then
		mkdir "${BUILD_PATH}"
	fi

	if [ ! -d "${BUILD_PATH}/oscar" ]; then
		mkdir "${BUILD_PATH}/oscar"
	fi

	if [ ! -d "${BUILD_PATH}/ocse" ]; then
		mkdir "${BUILD_PATH}/ocse"
	fi

	if [ ! -d "${BUILD_PATH}/bitpacking" ]; then
		mkdir "${BUILD_PATH}/bitpacking"
	fi

	if [ ! -d "${BUILD_PATH}/osi-compare" ]; then
		mkdir "${BUILD_PATH}/osi-compare"
	fi

	cd "${BUILD_PATH}/oscar" && cmake ${BUILD_OPTIONS} "${VENDOR_PATH}/oscar"
	
	if [ $? -ne 0 ]; then
		echo "Failed oscar build setup"
		exit 1
	fi

	cd "${BUILD_PATH}/ocse" && cmake ${BUILD_OPTIONS} "${VENDOR_PATH}/ocse"
	
	if [ $? -ne 0 ]; then
		echo "Failed ocse build setup"
		exit 1
	fi

	cd "${BUILD_PATH}/bitpacking" && cmake ${BUILD_OPTIONS} "${VENDOR_PATH}/bitpacking"
	
	if [ $? -ne 0 ]; then
		echo "Failed bitpacking build setup"
		exit 1
	fi

	cd "${BUILD_PATH}/osi-compare" && cmake ${BUILD_OPTIONS} "${VENDOR_PATH}/osi-compare"
	
	if [ $? -ne 0 ]; then
		echo "Failed osi-compare build setup"
		exit 1
	fi
}

compile_build() {
	if [ -z "${BUILD_NAME}" ]; then
		echo "No build name set"
		return
	fi

	if [ -z "${BUILD_OPTIONS}" ]; then
		echo "No build options are set"
		return
	fi


	BUILD_PATH="${BASE_PATH}/build/${BUILD_NAME}"


	echo "Compiling ${BUILD_NAME} build of oscar in ${VENDOR_PATH}/oscar"
	
	cd "${BUILD_PATH}/oscar" && make ${MAKE_OPTIONS} oscar-create oscar-cmd
	
	if [ $? -ne 0 ]; then
		echo "Failed to compile oscar"
		exit 1
	fi

	cd "${BUILD_PATH}/oscar/liboscar/sserialize/sserializebenchmarks" && make ${MAKE_OPTIONS}
	
	if [ $? -ne 0 ]; then
		echo "Failed to compile sserialize benchmarks"
		exit 1
	fi

	cd "${BUILD_PATH}/oscar/liboscar/sserialize/sserialize-tools" && make ${MAKE_OPTIONS}
	
	if [ $? -ne 0 ]; then
		echo "Failed to compile sserialize tools"
		exit 1
	fi
	echo "Compiling ${BUILD_NAME} build of ocse in ${VENDOR_PATH}/ocse"

	cd "${BUILD_PATH}/ocse" && make ${MAKE_OPTIONS}
	
	if [ $? -ne 0 ]; then
		echo "Failed to build ocse"
		exit 1
	fi

	cd "${BUILD_PATH}/bitpacking" && make ${MAKE_OPTIONS}
	
	if [ $? -ne 0 ]; then
		echo "Failed to build bitpacking"
		exit 1
	fi

	cd "${BUILD_PATH}/osi-compare" && make ${MAKE_OPTIONS}
	
	if [ $? -ne 0 ]; then
		echo "Failed to build osi-compare"
		exit 1
	fi

}

if [ "${UPDATE_REPOS}" = "y" ]; then
	update_repos
	if [ $? -ne 0 ]; then
		echo "Failed to update some repositories"
		exit 1
	fi
fi

BUILD_NAME=debug
BUILD_OPTIONS="-DCMAKE_BUILD_TYPE=Debug -DSSERIALIZE_CHEAP_ASSERT_ENABLED=true"
MAKE_OPTIONS="-j${NPROC}"
setup_build
compile_build

BUILD_NAME=debug-assert
BUILD_OPTIONS="-DCMAKE_BUILD_TYPE=Debug -DSSERIALIZE_EXPENSIVE_ASSERT_ENABLED=true"
MAKE_OPTIONS="-j${NPROC}"
setup_build
compile_build

BUILD_NAME=lto
BUILD_OPTIONS="-DCMAKE_BUILD_TYPE=lto"
MAKE_OPTIONS="-j${NPROC}"
#setup_build
#compile_build

BUILD_NAME=ultra-assert
BUILD_OPTIONS="-DCMAKE_BUILD_TYPE=ultra -DSSERIALIZE_CHEAP_ASSERT_ENABLED=true"
MAKE_OPTIONS="-j${NPROC}"
setup_build
compile_build

BUILD_NAME=ultra
BUILD_OPTIONS="-DCMAKE_BUILD_TYPE=ultra"
MAKE_OPTIONS="-j${NPROC}"
setup_build
compile_build

#compile ocse java stuff
CLEAN="y" ${VENDOR_PATH}/ocse/setup.sh

if [ "${UPDATE_WEBSITE_QUERIES}" = "y" ]; then
	BUILD_NAME=debug
	update_website_queries
fi
