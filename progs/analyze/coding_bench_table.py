#!/usr/bin/python3
#A sample data file: benchmark.coding.random.lto.txt
#TestLengthBegin: 1000000000
#TestLengthEnd: 1000000001
#TestLengthMul: 10
#Test Count: 100
#type: random
#Entries are in M/s
#count;pc32;pvl32;uba32;uba32vl;vec32;vec32c;pc64;pvl64;uba64;uba64vl;vec64;vec64c
#1000000000;1169.56;145.315;164.39;36.6402;1229.18;365.616;550.001;62.4447;109.681;23.8828;543.939;207.342

import os
import sys
import argparse
import re
import jinja2
import pprint

cmdLineParser = argparse.ArgumentParser(description="Creates a table out of coding bench stats")
cmdLineParser.add_argument('-d', help='Source file directory', dest='d', nargs=1, type=str, required=True)
cmdLineParser.add_argument('-t', help='Path to template file', dest='t', nargs=1, type=str, required=True)
cmdLineParser.add_argument('-o', help='Outfile', dest='o', nargs=1, type=str, required=True)

parsedArgs = cmdLineParser.parse_args()

builds = {
    "lto" : "lto",
    "ultra" : "ultra"
}

generators = {
    "random" : "random",
    "range" : "sequence"
}

containers = {
    "pc32" : "pack uint",
    "pvl32" : "pack vuint",
    "uba32" : "UBA uint",
    "uba32vl" : "UBA vuint",
    "vec32" : "std::array",
    "vec32c" : "std::vector",
    "pc64" : "pack uint",
    "pvl64" : "pack vuint",
    "uba64" : "UBA uint",
    "uba64vl" : "UBA vuint",
    "vec64" : "std::array",
    "vec64c" : "std::vector"
}

bits = {
    "pc32" : 32,
    "pvl32" : 32,
    "uba32" : 32,
    "uba32vl" : 32,
    "vec32" : 32,
    "vec32c" : 32,
    "pc64" : 64,
    "pvl64" : 64,
    "uba64" : 64,
    "uba64vl" : 64,
    "vec64" : 64,
    "vec64c" : 64
}

entry_order = ["pc32", "pvl32", "uba32", "uba32vl", "vec32", "vec32c",
               "pc64", "pvl64", "uba64", "uba64vl", "vec64","vec64c"]

baseDir = parsedArgs.d[0]

tempdata = dict()

for build in builds.keys(): 
    tempdata[build] = dict()
    for generator in generators.keys():
        tempdata[build][generator] = dict()

for build in builds.keys(): 
    for generator in generators.keys():
        #benchmark.coding.random.lto.txt
        filename = "benchmark.coding.{0}.{1}.txt".format(generator, build)
        path = os.path.join(baseDir, filename)
        if not os.path.isfile(path):
            print("Skipping " + path)
            continue
        file = open(path, 'rt')
        while (True):
            line = next(file).strip()
            if (not len(line)):
                continue
            if line[0] is '#':
                continue
            names = [ x.strip() for x in line.split(';')]
            line = next(file).strip()
            values = [ "{0:.1f}".format(float(x)) for x in line.split(';')]
            assert(len(names) == len(values))
            for name, value in zip(names, values):
                tempdata[build][generator][name] = value
            break


jinja_data = []
for container in entry_order:
    entry = {
        "name" : containers[container],
        "bits" : bits[container],
    }
    for build in builds.keys():
        entry[build] = dict()
        for generator in generators.keys():
            entry[build][generator] = tempdata[build][generator][container]
    jinja_data.append(entry)

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