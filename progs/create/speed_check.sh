#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
BASE_PATH=${SCRIPTPATH}

source "${BASE_PATH}/create_cfg.sh"

echo "Merge random test"
${BENCHMARK_ITEM_INDEX_BINARY} --no-baseline -t 204800 10 -o m -g r -c 5 -i for -i pfor -i native -i rlede -i eliasfano

echo "Intersect random test"
${BENCHMARK_ITEM_INDEX_BINARY} --no-baseline -t 128 10000 -o i -g r -c 5 -i for -i pfor -i native -i rlede -i eliasfano

echo "Merge monotone test"
${BENCHMARK_ITEM_INDEX_BINARY} --no-baseline -t 204800 10 -o m -g ms -c 5 -i for -i pfor -i native -i rlede -i eliasfano

echo "Intersect monotone test"
${BENCHMARK_ITEM_INDEX_BINARY} --no-baseline -t 128 10000 -o i -g ms -c 5 -i for -i pfor -i native -i rlede -i eliasfano
