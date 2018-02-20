#!/usr/bin/python3
#A sample data file:
# pl.nocellsplit.substring-celllocalids.benchmark.oscar.tcqr.text.setops.stats
# total [us]: 558783989
# cqr::total[us]: 125305814
# cqr::min[us]: 18
# cqr::max[us]: 3841978
# cqr::mean[us]: 33558
# cqr::median[us]: 5932
# subgraph::total[us]: 78241118
# subgraph::min[us]: 3
# subgraph::max[us]: 1924348
# subgraph::mean[us]: 20953
# subgraph::median[us]: 110
# toGlobalIds::total[us]: 22407647
# toGlobalIds::min[us]: 834
# toGlobalIds::max[us]: 1331386
# toGlobalIds::mean[us]: 6000
# toGlobalIds::median[us]: 1689
# flaten::total[us]: 332658226
# flaten::min[us]: 19
# flaten::max[us]: 7862872
# flaten::mean[us]: 89088
# flaten::median[us]: 907
# A sample log file
# ***STUFF***
# Constructing Hierarchy
# sserialize::spatial::GeoHierarchy--stats-BEGIN
# max cellsplit at 1486081 with 176656
# max children at 1486057 with 5318
# max parents at 1246568 with 12
# #cells: 1684436
# #items in all cells: 617136905
# #child ptrs: 20152615
# sserialize::spatial::GeoHierarchy--stats-END
# There are 1127 incorrectly sampled regions-child relations
# GeoHierarchy passed the consistency check.
# OsmKeyValueObjectStore::stats::begin
# Items: 593594804
# Keys: 69172
# Values: 77390667
# Boundary: GeoRect[(-90, -180); (90, 180)]
# OsmKeyValueObjectStore::stats::end
# Time to create KeyValueStore: 14h 51M 53s
# Serializing KeyValueStore
# Serializing OsmKeyValueObjectStore payload...took 129 seconds
# DynamicKeyValueObjectStore::serialize: Serializing string tables...took 117 seconds
# ***STUFF***


import os
import sys
import argparse
import re
import jinja2
import pprint

class Vividict(dict):
    def __missing__(self, key):
        value = self[key] = type(self)() # retain local pointer to value
        return value                     # faster to return than dict lookup

class Stat:
    def __init__(self):
        self.min = 0
        self.max = 0
        self.median = 0
        self.mean = 0

cmdLineParser = argparse.ArgumentParser(description="Creates graphics out of oscar-cmd benchmark raw stats")
cmdLineParser.add_argument('-d', help='Source file directory', dest='d', nargs=1, type=str, required=True)
cmdLineParser.add_argument('-q', help='Type (text, spatial...)', dest='q', nargs=1, type=str, required=True)
cmdLineParser.add_argument('-c', help='cqr variant (tcqr, cqr)', dest='c', nargs=1, type=str, required=True)
cmdLineParser.add_argument('-t', help='Path to template file', dest='t', nargs=1, type=str, required=True)
cmdLineParser.add_argument('-o', help='Outfile', dest='o', nargs=1, type=str, required=True)

parsedArgs = cmdLineParser.parse_args()

names = {
    "bw" : "BaWü",
    "de" : "Germany",
    "eu" : "Europe",
    "pl" : "Planet"
}

refinements  = {
    "disconnected" : "Disconnected Cell Arrangement",
    "nocellsplit" : "Connected Cell Arrangement",
    "cellsplit1k" : "Max 1000 triangles per cell",
    "celldiag5k" : "Max 5000m cell diagonal"
}

idtypes = {
    "substring" : "Global",
    "substring-celllocalids" : "Local"
}

cqrvariant = {
    "tcqr" : "TreedCQR",
    "cqr" : "CellQueryResult",
    "decelled" : "Naive"
}

phases = {
    "cqr" : "Cells",
    "subgraph" : "Subgraph",
    "toGlobalIds" : "Id Mapping",
    "flaten" : "Items"
}

queryType = parsedArgs.q[0]
baseDir = parsedArgs.d[0]
cqrVariant = parsedArgs.c[0]

assert(cqrVariant in cqrvariant)

# flaten::median[us]: 907
rx = "^(\w+)[:][:](\w+)\[us\][:]\s*(\d+)$"
prg = re.compile(rx)

items_prg = re.compile("^Items: (\d+)$")
cells_prg = re.compile("^#cells: (\d+)$")

tempdata = Vividict()

def valueformat(v):
    return "{0:.0f}".format(v/1000)

for refinement in refinements.keys():
    tempdata[refinement] = dict()
    for phase in phases.keys():
        tempdata[refinement][phase] = dict()
        for idtype in idtypes.keys():
            tempdata[refinement][phase][idtype] = dict()
            for name in names.keys():
                tempdata[refinement][phase][idtype][name] = {"min" : None, "max" : None, "mean" : None, "median" : None, "total" : None}

for refinement in refinements.keys():
    for idtype in idtypes.keys():
        for name in names.keys():
            #pl.nocellsplit.substring-celllocalids.benchmark.oscar.tcqr.text.setops.stats
            filename = "{0}.{1}.{2}.benchmark.oscar.{4}.{3}.stats".format(name, refinement, idtype, queryType, cqrVariant)
            path = os.path.join(baseDir, filename)
            if not os.path.isfile(path):
                print("Skipping " + path)
                continue
            file = open(path,'rt')
            try:
                next(file)# skip total
            except StopIteration:
                 print("Skipping empty file " + path)
                 continue

            for line in file:
                result = prg.search(line)
                if result is None:
                    print("Error parsing line " + line)
                    sys.exit(1)
                # flaten::median[us]: 907
                phasename = result.group(1)
                statname = result.group(2)
                value = int(result.group(3))
                tempdata[refinement][phasename][idtype][name][statname] = valueformat(value)

#decelled stuff
haveDecelled = False
#pl.nocellsplit.substring-celllocalids.benchmark.oscar.decelled.text.raw
for name in names.keys():
    filename = "{0}.nocellsplit.substring.benchmark.oscar.decelled.{1}.stats".format(name, queryType)
    path = os.path.join(baseDir, filename)
    if not os.path.isfile(path):
        print("Skipping " + path)
        continue
    file = open(path,'rt')
    try:
        next(file)# skip total
    except StopIteration:
            print("Skipping empty file " + path)
            continue

    for line in file:
        result = prg.search(line)
        if result is None:
            print("Error parsing line " + line)
            sys.exit(1)
        # flaten::median[us]: 907
        phasename = result.group(1)
        statname = result.group(2)
        value = int(result.group(3))
        tempdata["decelled"][phasename]["substring"][name][statname] = valueformat(value)
        haveDecelled = True

# pprint.pprint(tempdata["decelled"])

#assemble data for jinja
# [
#    ("Refined Cell Arrangement", [
#       ("Cells", 
#          [("Global" : [(min, max, mean, median)]]  
#     ]
# ]

jinja_naive = []
for phasename in ["flaten"]:
    pt = (phases[phasename], [])
    pt_v = pt[1]
    for idtype in ["substring"]:
        idt = (idtypes[idtype], [])
        idt_v = idt[1]
        for name in ["bw", "de", "eu", "pl"]:
            statdata = tempdata["decelled"][phasename][idtype][name]
            st = [statdata[statname] for statname in ["min", "max", "mean", "median"]]
            for i in range(0, len(st)):
                if st[i] == None:
                    st[i] = '-'
            idt_v.append(tuple(st))
        pt_v.append(idt)
    jinja_naive.append(pt)

if not haveDecelled:
    jinja_naive = haveDecelled

# pprint.pprint(jinja_naive)

jinja_data = []

for refinement in ["disconnected", "nocellsplit", "cellsplit1k", "celldiag5k"]:
    rft = (refinements[refinement], [])
    rft_v = rft[1]
    for phasename in ["cqr", "toGlobalIds", "subgraph", "flaten"]:
        cidts = ["substring", "substring-celllocalids"] if phasename != "toGlobalIds" else ["substring-celllocalids"]
        pt = (phases[phasename], [], len(cidts))
        pt_v = pt[1]
        for idtype in cidts:
            idt = (idtypes[idtype], [])
            idt_v = idt[1]
            for name in ["bw", "de", "eu", "pl"]:
                statdata = tempdata[refinement][phasename][idtype][name]
                st = [statdata[statname] for statname in ["min", "max", "mean", "median"]]
                for i in range(0, len(st)):
                    if st[i] == None:
                        st[i] = '-'
                idt_v.append(tuple(st))
            pt_v.append(idt)
        rft_v.append(pt)
    jinja_data.append(rft)


latex_jinja_env = jinja2.Environment(
	block_start_string = '\BLOCK{',
	block_end_string = '}',
	variable_start_string = '\VAR{',
	variable_end_string = '}',
	comment_start_string = '\#{',
	comment_end_string = '}',
	line_statement_prefix = '%%',
	line_comment_prefix = '%#',
	trim_blocks = True,
	autoescape = False,
	loader = jinja2.FileSystemLoader(os.path.dirname(parsedArgs.t[0]))
)

template = latex_jinja_env.get_template( os.path.basename(parsedArgs.t[0]))

with open(parsedArgs.o[0], 'wt') as outfile:
    print(template.render(refinements=jinja_data, naivedata=jinja_naive), file=outfile)