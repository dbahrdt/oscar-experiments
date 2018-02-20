#!/usr/bin/python3
#A sample data file:
# pl.cellsplit1k.substring.benchmark.index.rlede.tcqr.text.stats
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

import os
import sys
import argparse
import re
import jinja2
import pprint

cmdLineParser = argparse.ArgumentParser(description="Create a table from index benchmark stats")
cmdLineParser.add_argument('-d', help='Source file directory', dest='d', nargs=1, type=str, required=True)
cmdLineParser.add_argument('-s', help='Size information', dest='s', nargs=1, type=str, required=True)
cmdLineParser.add_argument('-t', help='Path to template file', dest='t', nargs=1, type=str, required=True)
cmdLineParser.add_argument('-o', help='Outfile', dest='o', nargs=1, type=str, required=True)

parsedArgs = cmdLineParser.parse_args()

#from https://stackoverflow.com/questions/635483/what-is-the-best-way-to-implement-nested-dictionaries
class Vividict(dict):
    def __missing__(self, key):
        value = self[key] = type(self)() # retain local pointer to value
        return value                     # faster to return than dict lookup

names = {
    # "bw" : "BaWü",
    # "de" : "Germany",
    # "eu" : "Europe",
    "pl" : "Planet"
}

refinements  = {
    # "disconnected" : "Disconnected Cell Arrangement",
    # "nocellsplit" : "Connected Cell Arrangement",
    "cellsplit1k" : "Refined Cell Arrangement"
}

indexes = {
    "rlede" : "Rl delta",
    "wah" : "Rl bit vector",
    "native" : "Array",
    "regline" : "Regression line",
    "eliasfano" : "EliasFano",
    "for" : "FoR",
    "pfor" : "Patched FoR",
    "multi" : "Best"
}

idtypes = {
    "substring" : "Global",
    "substring-celllocalids" : "Local"
}

phases = {
    "cqr" : "Cells",
    "subgraph" : "Subgraph",
    "toGlobalIds" : "Id Mapping",
    "flaten" : "Items"
}

baseDir = parsedArgs.d[0]

# flaten::median[us]: 907
rx = "^(\w+)[:][:](\w+)\[us\][:]\s*(\d+)$"
prg = re.compile(rx)

# 25754640 ./oscar-substring-celllocalids/cellsplit1k/pl/multi/index
rxs = "^\s*(\d*)\s*\W*oscar-([\w-]+)/([\w-]+)/([\w-]+)/([\w-]+)/index"
prgs = re.compile(rxs)

class Stat:
    def __init__(self):
        self.min = 0
        self.max = 0
        self.median = 0
        self.mean = 0

tempdata = Vividict()

for refinement in refinements.keys():
    for idtype in idtypes.keys():
        for index in indexes.keys():
            for name in names.keys():
                #pl.cellsplit1k.substring.benchmark.index.rlede.tcqr.text.stats
                filename = "{0}.{1}.{2}.benchmark.index.{3}.tcqr.text.stats".format(name, refinement, idtype, index)
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
                    value = int(int(result.group(3))/(1000000))
                    tempdata[refinement][idtype][index][name][phasename][statname] = value

with open(parsedArgs.s[0], 'rt') as sizefile:
    for line in sizefile:
        r = prgs.search(line)
        
        if r is None:
            continue
        
        # 25 754 640 ./oscar-substring-celllocalids/cellsplit1k/pl/multi/index
        size = r.group(1)
        idtype = r.group(2)
        refinement = r.group(3)
        name = r.group(4)
        index = r.group(5)
        tempdata[refinement][idtype][index][name]["size"] = "{0:.1f}".format(int(size)/(1024*1024))


#assemble data for jinja
# [
#    {"link" : "native",
#     "name" : "Integer Array",
#     "local/global" : {
#                "cqr" : 10,
#                "toGlobalIds" : 8,
#                "flaten" : 9
#               }
#    }
# ]

jinja_data = []
refinement = "cellsplit1k"
name = "pl"
statname = "total"
for index in ["native", "regline", "wah", "rlede", "eliasfano", "for", "pfor", "multi"]:
    d = dict()
    d["link"] = index
    d["name"] = indexes[index]
    for idtype in ["substring", "substring-celllocalids"]:
        d[idtypes[idtype]] = {
            "size" : tempdata[refinement][idtype][index][name]["size"]
        }
        for phasename in ["cqr", "toGlobalIds", "flaten"]:
            d[idtypes[idtype]][phasename] = tempdata[refinement][idtype][index][name][phasename][statname]
    jinja_data.append(d)

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
    print(template.render(data=jinja_data), file=outfile)
