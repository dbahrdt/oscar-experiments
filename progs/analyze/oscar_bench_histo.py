#!/usr/bin/python3
import os
import argparse
import matplotlib
import matplotlib.pyplot as plt
import csv

cmdLineParser = argparse.ArgumentParser(description="Creates graphics out of oscar-cmd benchmark raw stats")
cmdLineParser.add_argument('-f', help='Source file', dest='f', nargs=1, type=str, required=True)
cmdLineParser.add_argument('-d', help='Description of the source file', dest='d', nargs=1, type=str)
cmdLineParser.add_argument('-o', help='outfile', dest='o', nargs=1, type=str)

parsedArgs = cmdLineParser.parse_args()

infile = open(parsedArgs.f[0], mode='r')
desc = parsedArgs.d
reader = csv.reader(infile, delimiter=';')
data = {
    'ids' : [],
    'cqr' : [],
    'subgraph' : [],
    'globalids' : [],
    'flaten' : []
}

bins = list(range(1, 10, 1)) + list(range(10, 100, 10)) + list(range(100, 1000, 100)) + list(range(1000, 100000, 1000))

##create a histogram
def myhisto(l):
    h = {}
    for x in l:
        for bin in bins:
            if x < bin:
                if (not bin in h):
                    h[bin] = 0
                h[bin] += 1
                break
    return h

def histo_with_ids(ids, l):
    h = {}
    for id, x in zip(ids, l):
        for bin in bins:
            if x < bin:
                if (not bin in h):
                    h[bin] = []
                h[bin].append(id)
                break
    return h

def text_histo(h):
    r = []
    for bin in bins:
        if (bin in h):
            r.append(str(bin) + ":" + str(h[bin]))
    return (','.join(r))

next(reader) # skip header
for row in reader:
    # a row:
    # Query id; cqr time [us];subgraph time[us];toGlobalIds time[us];flaten time[us];cell count; item count
    row = list( map(lambda x : int(x), row) )
    data['ids'].append(row[0])
    data['cqr'].append(row[1]/1000)
    data['subgraph'].append(row[2]/1000)
    data['globalids'].append(row[3]/1000)
    data['flaten'].append(row[4]/1000)

print("CQR: " + text_histo(myhisto(data['cqr'])))
print("Subgraph: " + text_histo(myhisto(data['subgraph'])))
print("GlobalIds: " + text_histo(myhisto(data['globalids'])))
print("Flaten: " + text_histo(myhisto(data['flaten'])))

print("CQR bins with ids: " + text_histo(histo_with_ids(data['ids'], data['cqr'])))
