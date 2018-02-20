#!/bin/bash

#stores
./create.sh -t=store -s=bw -c=cellsplit1k -b=ultra
./create.sh -t=store -s=de -c=cellsplit1k -b=ultra
./create.sh -t=store -s=eu -c=cellsplit1k -b=ultra
./create.sh -t=store -s=pl -c=cellsplit1k -b=ultra

./create.sh -t=store -s=bw -c=celldiag5k -b=ultra
./create.sh -t=store -s=de -c=celldiag5k -b=ultra
./create.sh -t=store -s=eu -c=celldiag5k -b=ultra
./create.sh -t=store -s=pl -c=celldiag5k -b=ultra

./create.sh -t=store -s=bw -c=nocellsplit -b=ultra
./create.sh -t=store -s=de -c=nocellsplit -b=ultra
./create.sh -t=store -s=eu -c=nocellsplit -b=ultra
./create.sh -t=store -s=pl -c=nocellsplit -b=ultra

./create.sh -t=store -s=bw -c=disconnected -b=ultra
./create.sh -t=store -s=de -c=disconnected -b=ultra
./create.sh -t=store -s=eu -c=disconnected -b=ultra
./create.sh -t=store -s=pl -c=disconnected -b=ultra

#oscar cell local ids
./create.sh -t=oscar -s=bw -c=cellsplit1k -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar -s=de -c=cellsplit1k -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar -s=eu -c=cellsplit1k -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar -s=pl -c=cellsplit1k -b=ultra -ot=substring-celllocalids

./create.sh -t=oscar -s=bw -c=celldiag5k -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar -s=de -c=celldiag5k -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar -s=eu -c=celldiag5k -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar -s=pl -c=celldiag5k -b=ultra -ot=substring-celllocalids

./create.sh -t=oscar -s=bw -c=nocellsplit -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar -s=de -c=nocellsplit -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar -s=eu -c=nocellsplit -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar -s=pl -c=nocellsplit -b=ultra -ot=substring-celllocalids

./create.sh -t=oscar -s=bw -c=disconnected -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar -s=de -c=disconnected -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar -s=eu -c=disconnected -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar -s=pl -c=disconnected -b=ultra -ot=substring-celllocalids

#oscar global ids
./create.sh -t=oscar -s=bw -c=cellsplit1k -b=ultra -ot=substring
./create.sh -t=oscar -s=de -c=cellsplit1k -b=ultra -ot=substring
./create.sh -t=oscar -s=eu -c=cellsplit1k -b=ultra -ot=substring
./create.sh -t=oscar -s=pl -c=cellsplit1k -b=ultra -ot=substring

./create.sh -t=oscar -s=bw -c=celldiag5k -b=ultra -ot=substring
./create.sh -t=oscar -s=de -c=celldiag5k -b=ultra -ot=substring
./create.sh -t=oscar -s=eu -c=celldiag5k -b=ultra -ot=substring
./create.sh -t=oscar -s=pl -c=celldiag5k -b=ultra -ot=substring

./create.sh -t=oscar -s=bw -c=nocellsplit -b=ultra -ot=substring
./create.sh -t=oscar -s=de -c=nocellsplit -b=ultra -ot=substring
./create.sh -t=oscar -s=eu -c=nocellsplit -b=ultra -ot=substring
./create.sh -t=oscar -s=pl -c=nocellsplit -b=ultra -ot=substring

./create.sh -t=oscar -s=bw -c=disconnected -b=ultra -ot=substring
./create.sh -t=oscar -s=de -c=disconnected -b=ultra -ot=substring
./create.sh -t=oscar -s=eu -c=disconnected -b=ultra -ot=substring
./create.sh -t=oscar -s=pl -c=disconnected -b=ultra -ot=substring

#oscar indices
./create.sh -t=indexes -s=pl -c=cellsplit1k -b=ultra -ot=substring
./create.sh -t=indexes -s=pl -c=cellsplit1k -b=ultra -ot=substring-celllocalids

#oscar ocse
./create.sh -t=oscar -s=bw -c=nocellsplit -b=ultra -ot=ocse-celllocalids
./create.sh -t=oscar -s=de -c=nocellsplit -b=ultra -ot=ocse-celllocalids
./create.sh -t=oscar -s=eu -c=nocellsplit -b=ultra -ot=ocse-celllocalids
./create.sh -t=oscar -s=pl -c=nocellsplit -b=ultra -ot=ocse-celllocalids

./create.sh -t=oscar -s=bw -c=nocellsplit -b=ultra -ot=ocse
./create.sh -t=oscar -s=de -c=nocellsplit -b=ultra -ot=ocse
./create.sh -t=oscar -s=eu -c=nocellsplit -b=ultra -ot=ocse
./create.sh -t=oscar -s=pl -c=nocellsplit -b=ultra -ot=ocse

#lucene
./create.sh -t=lucene -s=bw -c=nocellsplit -b=ultra
./create.sh -t=lucene -s=de -c=nocellsplit -b=ultra
./create.sh -t=lucene -s=eu -c=nocellsplit -b=ultra
./create.sh -t=lucene -s=pl -c=nocellsplit -b=ultra

 #mg4j (only bw, de, eu?)
./create.sh -t=mg4j -s=bw -c=nocellsplit -b=ultra
./create.sh -t=mg4j -s=de -c=nocellsplit -b=ultra
./create.sh -t=mg4j -s=eu -c=nocellsplit -b=ultra
./create.sh -t=mg4j -s=pl -c=nocellsplit -b=ultra

#stats
./create.sh -t=store-stats -s=bw -c=cellsplit1k -b=ultra
./create.sh -t=store-stats -s=de -c=cellsplit1k -b=ultra
./create.sh -t=store-stats -s=eu -c=cellsplit1k -b=ultra
./create.sh -t=store-stats -s=pl -c=cellsplit1k -b=ultra

./create.sh -t=store-stats -s=bw -c=celldiag5k -b=ultra
./create.sh -t=store-stats -s=de -c=celldiag5k -b=ultra
./create.sh -t=store-stats -s=eu -c=celldiag5k -b=ultra
./create.sh -t=store-stats -s=pl -c=celldiag5k -b=ultra

./create.sh -t=store-stats -s=bw -c=nocellsplit -b=ultra
./create.sh -t=store-stats -s=de -c=nocellsplit -b=ultra
./create.sh -t=store-stats -s=eu -c=nocellsplit -b=ultra
./create.sh -t=store-stats -s=pl -c=nocellsplit -b=ultra

./create.sh -t=store-stats -s=bw -c=disconnected -b=ultra
./create.sh -t=store-stats -s=de -c=disconnected -b=ultra
./create.sh -t=store-stats -s=eu -c=disconnected -b=ultra
./create.sh -t=store-stats -s=pl -c=disconnected -b=ultra

#gh, ra stats for planet

./create.sh -t=geohierarchy-stats -s=pl -c=disconnected -b=ultra
./create.sh -t=geohierarchy-stats -s=pl -c=nocellsplit -b=ultra
./create.sh -t=geohierarchy-stats -s=pl -c=cellsplit1k -b=ultra
./create.sh -t=geohierarchy-stats -s=pl -c=celldiag5k -b=ultra

./create.sh -t=regionarrangement-stats -s=pl -c=disconnected -b=ultra
./create.sh -t=regionarrangement-stats -s=pl -c=nocellsplit -b=ultra
./create.sh -t=regionarrangement-stats -s=pl -c=cellsplit1k -b=ultra
./create.sh -t=regionarrangement-stats -s=pl -c=celldiag5k -b=ultra


#index benchmarks
./create.sh -t=index-bench -s=pl -c=cellsplit1k -b=ultra -ot=substring
./create.sh -t=index-bench -s=pl -c=cellsplit1k -b=ultra -ot=substring-celllocalids

#oscar bench global ids
./create.sh -t=oscar-bench -s=bw -c=disconnected -b=ultra -ot=substring
./create.sh -t=oscar-bench -s=bw -c=nocellsplit -b=ultra -ot=substring
./create.sh -t=oscar-bench -s=bw -c=cellsplit1k -b=ultra -ot=substring
./create.sh -t=oscar-bench -s=bw -c=celldiag5k -b=ultra -ot=substring

./create.sh -t=oscar-bench -s=de -c=disconnected -b=ultra -ot=substring
./create.sh -t=oscar-bench -s=de -c=nocellsplit -b=ultra -ot=substring
./create.sh -t=oscar-bench -s=de -c=cellsplit1k -b=ultra -ot=substring
./create.sh -t=oscar-bench -s=de -c=celldiag5k -b=ultra -ot=substring

./create.sh -t=oscar-bench -s=eu -c=disconnected -b=ultra -ot=substring
./create.sh -t=oscar-bench -s=eu -c=nocellsplit -b=ultra -ot=substring
./create.sh -t=oscar-bench -s=eu -c=cellsplit1k -b=ultra -ot=substring
./create.sh -t=oscar-bench -s=eu -c=celldiag5k -b=ultra -ot=substring

./create.sh -t=oscar-bench -s=pl -c=disconnected -b=ultra -ot=substring
./create.sh -t=oscar-bench -s=pl -c=nocellsplit -b=ultra -ot=substring
./create.sh -t=oscar-bench -s=pl -c=cellsplit1k -b=ultra -ot=substring
./create.sh -t=oscar-bench -s=pl -c=celldiag5k -b=ultra -ot=substring

#oscar bench local ids
./create.sh -t=oscar-bench -s=bw -c=disconnected -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar-bench -s=bw -c=nocellsplit -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar-bench -s=bw -c=cellsplit1k -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar-bench -s=bw -c=celldiag5k -b=ultra -ot=substring-celllocalids

./create.sh -t=oscar-bench -s=de -c=disconnected -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar-bench -s=de -c=nocellsplit -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar-bench -s=de -c=cellsplit1k -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar-bench -s=de -c=celldiag5k -b=ultra -ot=substring-celllocalids

./create.sh -t=oscar-bench -s=eu -c=disconnected -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar-bench -s=eu -c=nocellsplit -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar-bench -s=eu -c=cellsplit1k -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar-bench -s=eu -c=celldiag5k -b=ultra -ot=substring-celllocalids

./create.sh -t=oscar-bench -s=pl -c=disconnected -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar-bench -s=pl -c=nocellsplit -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar-bench -s=pl -c=cellsplit1k -b=ultra -ot=substring-celllocalids
./create.sh -t=oscar-bench -s=pl -c=celldiag5k -b=ultra -ot=substring-celllocalids

#ocse stuff
./create.sh -s=bw -t=ocse-oscar -c=nocellsplit -b=ultra -ot=ocse
./create.sh -s=bw -t=ocse-oscar -c=nocellsplit -b=ultra -ot=ocse-celllocalids
./create.sh -s=de -t=ocse-oscar -c=nocellsplit -b=ultra -ot=ocse
./create.sh -s=de -t=ocse-oscar -c=nocellsplit -b=ultra -ot=ocse-celllocalids
./create.sh -s=eu -t=ocse-oscar -c=nocellsplit -b=ultra -ot=ocse
./create.sh -s=eu -t=ocse-oscar -c=nocellsplit -b=ultra -ot=ocse-celllocalids
./create.sh -s=pl -t=ocse-oscar -c=nocellsplit -b=ultra -ot=ocse
./create.sh -s=pl -t=ocse-oscar -c=nocellsplit -b=ultra -ot=ocse-celllocalids

./create.sh -s=bw -t=ocse-lucene -c=nocellsplit -b=ultra -ot=ocse
./create.sh -s=de -t=ocse-lucene -c=nocellsplit -b=ultra -ot=ocse
./create.sh -s=eu -t=ocse-lucene -c=nocellsplit -b=ultra -ot=ocse
./create.sh -s=pl -t=ocse-lucene -c=nocellsplit -b=ultra -ot=ocse

./create.sh -s=bw -t=ocse-mg4j -c=nocellsplit -b=ultra -ot=ocse
./create.sh -s=de -t=ocse-mg4j -c=nocellsplit -b=ultra -ot=ocse
./create.sh -s=eu -t=ocse-mg4j -c=nocellsplit -b=ultra -ot=ocse
./create.sh -s=pl -t=ocse-mg4j -c=nocellsplit -b=ultra -ot=ocse

#osi compare stuff
./create.sh -t=osi-create -s=bw -c=disconnected -b=ultra -ot=substring --osi-index-type=htm --osi-levels=11
./create.sh -t=osi-create -s=de -c=disconnected -b=ultra -ot=substring --osi-index-type=htm --osi-levels=11
./create.sh -t=osi-create -s=eu -c=disconnected -b=ultra -ot=substring --osi-index-type=htm --osi-levels=11
./create.sh -t=osi-create -s=pl -c=disconnected -b=ultra -ot=substring --osi-index-type=htm --osi-levels=11

./create.sh -t=osi-create -s=bw -c=disconnected -b=ultra -ot=substring --osi-index-type=h3 --osi-levels=6
./create.sh -t=osi-create -s=de -c=disconnected -b=ultra -ot=substring --osi-index-type=h3 --osi-levels=6
./create.sh -t=osi-create -s=eu -c=disconnected -b=ultra -ot=substring --osi-index-type=h3 --osi-levels=6
./create.sh -t=osi-create -s=pl -c=disconnected -b=ultra -ot=substring --osi-index-type=h3 --osi-levels=6

./create.sh -t=osi-create -s=bw -c=disconnected -b=ultra -ot=substring --osi-index-type=simplegrid --osi-levels=12
./create.sh -t=osi-create -s=de -c=disconnected -b=ultra -ot=substring --osi-index-type=simplegrid --osi-levels=12
./create.sh -t=osi-create -s=eu -c=disconnected -b=ultra -ot=substring --osi-index-type=simplegrid --osi-levels=12
./create.sh -t=osi-create -s=pl -c=disconnected -b=ultra -ot=substring --osi-index-type=simplegrid --osi-levels=12

#osi compare stuff
./create.sh -t=osi-query -s=bw -c=disconnected -b=ultra -ot=substring --osi-index-type=htm --osi-levels=11
./create.sh -t=osi-query -s=de -c=disconnected -b=ultra -ot=substring --osi-index-type=htm --osi-levels=11
./create.sh -t=osi-query -s=eu -c=disconnected -b=ultra -ot=substring --osi-index-type=htm --osi-levels=11
./create.sh -t=osi-query -s=pl -c=disconnected -b=ultra -ot=substring --osi-index-type=htm --osi-levels=11

./create.sh -t=osi-query -s=bw -c=disconnected -b=ultra -ot=substring --osi-index-type=h3 --osi-levels=6
./create.sh -t=osi-query -s=de -c=disconnected -b=ultra -ot=substring --osi-index-type=h3 --osi-levels=6
./create.sh -t=osi-query -s=eu -c=disconnected -b=ultra -ot=substring --osi-index-type=h3 --osi-levels=6
./create.sh -t=osi-query -s=pl -c=disconnected -b=ultra -ot=substring --osi-index-type=h3 --osi-levels=6

./create.sh -t=osi-query -s=bw -c=disconnected -b=ultra -ot=substring --osi-index-type=simplegrid --osi-levels=12
./create.sh -t=osi-query -s=de -c=disconnected -b=ultra -ot=substring --osi-index-type=simplegrid --osi-levels=12
./create.sh -t=osi-query -s=eu -c=disconnected -b=ultra -ot=substring --osi-index-type=simplegrid --osi-levels=12
./create.sh -t=osi-query -s=pl -c=disconnected -b=ultra -ot=substring --osi-index-type=simplegrid --osi-levels=12

#osi stats stuff
./create.sh -t=osi-stats -s=bw -c=disconnected -b=ultra -ot=substring --osi-index-type=htm --osi-levels=12
./create.sh -t=osi-stats -s=de -c=disconnected -b=ultra -ot=substring --osi-index-type=htm --osi-levels=11
./create.sh -t=osi-stats -s=eu -c=disconnected -b=ultra -ot=substring --osi-index-type=htm --osi-levels=11
./create.sh -t=osi-stats -s=pl -c=disconnected -b=ultra -ot=substring --osi-index-type=htm --osi-levels=11

./create.sh -t=osi-stats -s=bw -c=disconnected -b=ultra -ot=substring --osi-index-type=h3 --osi-levels=7
./create.sh -t=osi-stats -s=de -c=disconnected -b=ultra -ot=substring --osi-index-type=h3 --osi-levels=7
./create.sh -t=osi-stats -s=eu -c=disconnected -b=ultra -ot=substring --osi-index-type=h3 --osi-levels=7
./create.sh -t=osi-stats -s=pl -c=disconnected -b=ultra -ot=substring --osi-index-type=h3 --osi-levels=7

./create.sh -t=osi-stats -s=bw -c=disconnected -b=ultra -ot=substring --osi-index-type=simplegrid --osi-levels=12
./create.sh -t=osi-stats -s=de -c=disconnected -b=ultra -ot=substring --osi-index-type=simplegrid --osi-levels=12
./create.sh -t=osi-stats -s=eu -c=disconnected -b=ultra -ot=substring --osi-index-type=simplegrid --osi-levels=12
./create.sh -t=osi-stats -s=pl -c=disconnected -b=ultra -ot=substring --osi-index-type=simplegrid --osi-levels=12
