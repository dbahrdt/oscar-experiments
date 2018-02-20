#!/usr/bin/env python3
#
# Format is:
# Query id; cqr time [us];subgraph time[us];toGlobalIds time[us];flaten time[us];cell count; item count
#
# Output without standardization
# Threshold [ms];cqr time [1];subgraph time [1];toGlobalIds time [1];flaten time [1]
#
# Output with standardization
# Threshold 1k (cells|items) [ms];cqr time [1];subgraph time [1];toGlobalIds time [1];flaten time [1]
#

import argparse
import csv

cmdLineParser = argparse.ArgumentParser(description="Creates cdfs out of oscar-cmd benchmark raw stats")
cmdLineParser.add_argument('-f', help='source file', dest='infn', nargs='+', type=str, required=True)
cmdLineParser.add_argument('--standardize', help='Standardize to cells|items|size', dest='standardize', nargs=1, type=str, default=[])

parsedArgs = cmdLineParser.parse_args()

normalization_factor = 1000
print_normalization_factor = 1

cells_mult = 1000
items_mult = 1000


if len(parsedArgs.standardize) and parsedArgs.standardize[0] in ["cells", "items", "size"]:
    normalization_factor = 1000

standardize_col_names = {
    "cells" : "cell count",
    "items" : "item count",
    "size" : "Size[1]"
}


meas_unit = {1000: "ms", 1: "us"}.get(normalization_factor*print_normalization_factor)
si_unit = {10**6: "M", 1000: "K", 1: ""}


def handle_file(fileName):
    infile = open(fileName, "r")
    reader = csv.reader(infile, delimiter=';')

    names = {} # column:int -> name:str
    data = {} # column:int -> data:[int]
    counts = {} #column:int -> count:str

    try:
        row = next(reader)
    except StopIteration:
        print("Skipping file " + fileName)
        return
        
    for i in range(0, len(row)):
        if "[us]" in row[i]:
            names[i] = row[i].replace("[us]", "").strip()
            data[i] = []
        else:
            counts[row[i].strip()] = i
            data[i] = []

    columns = list(names.keys())
    columns.sort()

    if len(parsedArgs.standardize) and standardize_col_names.get(parsedArgs.standardize[0]) not in counts:
        return

    for row in reader:
        row = [float(x) for x in row]
        for col in columns:
            val = row[col]
            if "cells" in parsedArgs.standardize:
                val = val*cells_mult / max(1, row[counts.get("cell count")])
            elif "items" in parsedArgs.standardize:
                val = val*items_mult / max(1, row[counts.get("item count")])
            elif "size" in parsedArgs.standardize:
                val = val*items_mult / max(1, row[counts.get("Size[1]")])
            data[col].append(int(float(val)/normalization_factor))

    for key in data.keys():
        data[key].sort()

    thresholds = []
    for key in data.keys():
        thresholds.extend(data[key])
    thresholds = list(set(thresholds))
    thresholds.sort()

    num_measurements = dict( [ [key, len(data[key])] for key in data.keys() ] )

    cdf = dict([[key, []] for key in data.keys()] )
    data_positions = dict([[key, 0] for key in data.keys()] )

    for th in thresholds:
        for col in columns:
            while ( data_positions[col] < len(data[col]) and data[col][data_positions[col]] <= th):
                data_positions[col] += 1
            cdf[col].append(data_positions[col])

    outfilename = fileName + ".cdf"
    if "cells" in parsedArgs.standardize:
        outfilename += ".stdcells"
    elif "items" in parsedArgs.standardize:
        outfilename += ".stditems"
    elif "size" in parsedArgs.standardize:
        outfilename += ".stditems"

    with open(outfilename, 'wt') as csvfile:
        writer = csv.writer(csvfile, delimiter=';', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        row = []
        if "cells" in parsedArgs.standardize:
            row.append("Threshold for {cellmult} cells [{measunit}]".format(cellmult=cells_mult, measunit=meas_unit))
        elif "items" in parsedArgs.standardize or "size" in parsedArgs.standardize:
            row.append("Threshold for {itemmult} items [{measunit}]".format(itemmult=items_mult, measunit=meas_unit))
        else:
            row.append("Threshold [{}]".format(meas_unit))
        row += ["{0} [1]".format(names[col]) for col in columns]
        writer.writerow(row)
        for i in range(0, len(thresholds)):
            row = ["{:.1f}".format(thresholds[i]/print_normalization_factor)] + [cdf[col][i]/num_measurements[col]*100 for col in columns]
            writer.writerow(row)


for fileName in parsedArgs.infn:
    try:
        handle_file(fileName)
    except Exception as e:
        print("Error occured while handling file {fn}: {errormsg}".format(fn=fileName, errormsg=str(e)))
    
