#!/usr/bin/env python3
#
# Oscar Format is:
# Query id; cqr time [us];subgraph time[us];toGlobalIds time[us];flaten time[us];cell count; item count
#
# file name oscar:
# pl.disconnected.substring.benchmark.oscar.cqr.osi-text.setops.raw
#

import argparse
import pandas as pd
import os

cmdLineParser = argparse.ArgumentParser(description="Creates per query completion time diffs for alternative map tesselation stats")
cmdLineParser.add_argument('-d', help='source directory', dest='d', nargs=1, type=str, required=True)

args = cmdLineParser.parse_args()


names = ["bw", "de", "eu", "pl"]
refinements = ["disconnected", "nocellsplit", "cellsplit1k", "celldiag5k"]

cqrvariant = ["tcqr", "cqr"]

phases = ["cqr", "flaten"]

o_fnf = "{name}.{refinement}.substring.benchmark.oscar.{cqr}.osi-{query}.raw"

out_cdf = "{name}.{refinement}.benchmark.substring.cqr-tcqr-diff.{query}.cdf"
out_raw = "{name}.{refinement}.benchmark.substring.cqr-tcqr-diff.{query}.raw"

def read_o(fn):
    return pd.read_csv(os.path.join(args.d[0], fn), delimiter=';')

def compute_diffs(name, setops):
    q = "text.setops" if setops else "text"
    od = { "cqr": {}, "tcqr" : {}}
    for x in refinements:
        for cqr in ["cqr", "tcqr"]:
            ifn = o_fnf.format(name=name, cqr=cqr, refinement=x, query=q)
            try:
                tmp = read_o(ifn)
                od[cqr][x] = tmp
            except:
                print("Could not open parse " + ifn)

    queryCount = len(od.get("cqr").get("disconnected"))

    for ref in refinements:
        if ref not in od["cqr"] or ref not in od["tcqr"]:
            continue
        df_cdf = pd.DataFrame({"Query id": range(0, queryCount)})
        df = pd.DataFrame({"Query id": range(0, queryCount)})
        cqrt = ((od.get("cqr").get(ref)[" cqr time [us]"] - od.get("tcqr").get(ref)[" cqr time [us]"])/1000)
        flatent = ((od.get("cqr").get(ref)["flaten time[us]"] - od.get("tcqr").get(ref)["flaten time[us]"])/1000)

        df_cdf["cells cqr-dcqr time [ms]"] = cqrt.sort_values().values
        df_cdf["items cqr-dcqr time [ms]"] = flatent.sort_values().values
        outfn = out_cdf.format(name=name, refinement=ref, query=q)
        df_cdf.to_csv(os.path.join(args.d[0], outfn), sep=";",index=False)

        df["cells cqr-dcqr time [ms]"] = cqrt
        df["items cqr-dcqr time [ms]"] = flatent
        outfn = out_raw.format(name=name, refinement=ref, query=q)
        df.to_csv(os.path.join(args.d[0], outfn), sep=";",index=False)
    
for name in names:
    compute_diffs(name, False)
    compute_diffs(name, True)