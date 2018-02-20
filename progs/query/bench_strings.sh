#!/bin/bash

for i in bw de; do
	for j in sub-global sub-local; do
		SRC=src/${i}-${j}
		for k in text.setops text spatial; do
			QUERIES=queries/${i}.${k}.txt
			for c in false true; do
				for l in 1 2 3 4 5; do
					OFN=stats/hc-${i}.${j}.${k}.${c}.${l}
					echo "Bench ${OFN}"
    				./oscar-cmd  ${SRC} --benchmark i=${QUERIES},o=${OFN},subset=${c},items=false,cc=false,ghsg=pass,tc=1,t=geocell;
				done
			done
		done
	done
done
