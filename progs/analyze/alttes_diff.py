#!/usr/bin/env python3
#
# Oscar Format is:
# Query id; cqr time [us];subgraph time[us];toGlobalIds time[us];flaten time[us];cell count; item count
#
# alttes format is:
# Query id; cqr time [us];flaten time[us];cell count; item count
#
# file name sg:
# pl.disconnected.substring.osi.h3.benchmark.cqr.text.setops.h3.stats.raw
#
# file name oscar:
# pl.disconnected.substring.benchmark.oscar.cqr.osi-text.setops.raw
#
#
#



import argparse
import pandas as pd
import os

cmdLineParser = argparse.ArgumentParser(description="Creates per query completion time diffs for alternative map tesselation stats")
cmdLineParser.add_argument('-d', help='source directory', dest='d', nargs=1, type=str, required=True)

args = cmdLineParser.parse_args()


names = ["bw", "de", "eu", "pl"]
refinements = ["disconnected", "nocellsplit", "cellsplit1k", "celldiag5k"]

spatialgrids = ["htm", "h3", "simplegrid"]

cqrvariant = ["tcqr", "cqr"]

phases = ["cqr", "flaten"]

sg_fnf = "{name}.disconnected.substring.osi.{sg}.benchmark.{cqr}.{query}.{sg}.stats.raw"
o_fnf = "{name}.{refinement}.substring.benchmark.oscar.{cqr}.osi-{query}.raw"

outfnf = "{name}.benchmark.substring.osi-diff.{cqr}.{query}.raw"

def read_sg(fn):
    return pd.read_csv(os.path.join(args.d[0], fn), delimiter=';', skipfooter=1, engine="python")

def read_o(fn):
    return pd.read_csv(os.path.join(args.d[0], fn), delimiter=';')

def compute_diffs(name, cqr, setops):
    q = "text.setops" if setops else "text"
    sgd = {}
    od = {}
    for x in spatialgrids:
        sgd[x] = read_sg(sg_fnf.format(name=name, sg=x, cqr=cqr, query=q))
    for x in refinements:
        try:
            tmp = read_o(o_fnf.format(name=name, cqr=cqr, refinement=x, query=q))
            od[x] = tmp
        except:
            pass

    queryCount = len(od.get("disconnected"))

    df = pd.DataFrame(
        {
            "Query id": range(0, queryCount)
        }
    )
    for ref in refinements:
        for sg in spatialgrids:
            cqrt = None
            flatent = None
            if ref in od:
                cqrt = ((sgd.get(sg)[" cqr time [us]"] - od.get(ref)[" cqr time [us]"])/1000).sort_values().values
                flatent = ((sgd.get(sg)["flaten time[us]"] - od.get(ref)["flaten time[us]"])/1000).sort_values().values
            else:
                cqrt = [0]*queryCount
                flatent = [0]*queryCount
            df["cqr time {} - {} [ms]".format(sg, ref)] = cqrt
            df["flaten time {} - {} [ms]".format(sg, ref)] = flatent
    
    for first, second in [("htm", "simplegrid"), ("htm", "h3"), ("h3", "simplegrid")]:
        df["cqr time {} - {} [ms]".format(first, second)] = ((sgd.get(first)[" cqr time [us]"] - sgd.get(second)[" cqr time [us]"])/1000).sort_values().values
        df["flaten time {} - {} [ms]".format(first, second)] = ((sgd.get(first)["flaten time[us]"] - sgd.get(second)["flaten time[us]"])/1000).sort_values().values

    outfn = outfnf.format(name=name, cqr=cqr, query=q)
    #print("Writing " + outfn)
    df.to_csv(os.path.join(args.d[0], outfn), sep=";",index=False)

    
for name in names:
    for cqr in cqrvariant:
        compute_diffs(name, cqr, False)
        compute_diffs(name, cqr, True)