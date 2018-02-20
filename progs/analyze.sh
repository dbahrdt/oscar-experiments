#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
BASE_PATH=${SCRIPTPATH}
VENDOR_PATH="${BASE_PATH}/vendor"
DATA_PATH="${BASE_PATH}/../data/"
ANA_PATH="${BASE_PATH}/analyze"

cd ${BASE_PATH} || exit 1

${ANA_PATH}/benchmarks2cdf.py -f ${DATA_PATH}/logs/create/*.raw
${ANA_PATH}/benchmarks2cdf.py -f ${DATA_PATH}/logs/create/*.raw --standardize cells
${ANA_PATH}/benchmarks2cdf.py -f ${DATA_PATH}/logs/create/*.raw --standardize items
${ANA_PATH}/benchmarks2cdf.py -f ${DATA_PATH}/logs/create/*.raw --standardize size
${ANA_PATH}/benchmarks2cdf.py -f ${DATA_PATH}/logs/mobile/*.raw
${ANA_PATH}/benchmarks2cdf.py -f ${DATA_PATH}/logs/mobile/*.raw --standardize cells
${ANA_PATH}/benchmarks2cdf.py -f ${DATA_PATH}/logs/mobile/*.raw --standardize items

${ANA_PATH}/wq_mean_median_table.py -d ../data/logs/create/ -c tcqr -q text -t ../../tex/templates/website_queries_table.tex -o ../../tex/figs/experiments/table-website-text-queries.tex
${ANA_PATH}/wq_mean_median_table.py -d ../data/logs/create/ -c tcqr -q text.setops -t ../../tex/templates/website_queries_table.tex -o ../../tex/figs/experiments/table-website-text-setops-queries.tex
${ANA_PATH}/wq_mean_median_table.py -d ../data/logs/create/ -c tcqr -q spatial -t ../../tex/templates/website_queries_table.tex -o ../../tex/figs/experiments/table-website-spatial-queries.tex

${ANA_PATH}/wq_mean_median_table.py -d ../data/logs/create/ -c cqr -q text -t ../../tex/templates/website_queries_table.tex -o ../../tex/figs/experiments/table-website-text-queries-cqr.tex
${ANA_PATH}/wq_mean_median_table.py -d ../data/logs/create/ -c cqr -q text.setops -t ../../tex/templates/website_queries_table.tex -o ../../tex/figs/experiments/table-website-text-setops-queries-cqr.tex
${ANA_PATH}/wq_mean_median_table.py -d ../data/logs/create/ -c cqr -q spatial -t ../../tex/templates/website_queries_table.tex -o ../../tex/figs/experiments/table-website-spatial-queries-cqr.tex

${ANA_PATH}/wq_index_bench_table.py -d ../data/logs/create/ -s ../data/stats/search_oscar_index_compare_file_sizes -t ../../tex/templates/index_benchmark_table.tex -o ../../tex/figs/experiments/table-index-benchmark.tex
${ANA_PATH}/coding_bench_table.py -d ../data/logs/create/ -t ../../tex/templates/coding_benchmark_table.tex -o ../../tex/figs/experiments/table-coding-benchmark.tex
${ANA_PATH}/alttes_diff.py -d ../data/logs/create/
