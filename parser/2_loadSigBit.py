import numpy as np
import _pickle as cPickle
from helper import Signal
from scipy import sparse
import os
import sys
import time

def convert(vals, st, et, clock, width):
    length = int((et - st) // clock)
    w = int(width)

    mulCycVector = np.zeros((length, w)).astype(bool)

    if vals is None:
        return mulCycVector

    record = []
    for val in vals:
        currTime = float(val[0]) 
        idx = int((currTime - st) // clock)
        if idx >= length:
            break
        record.append([idx, val[1]])

    for i in range(len(record)-1):
        k, v = record[i]
        k1, v1 = record[i+1]
        mulCycVector[k1, :] = np.array([v[j] != v1[j] for j in range(w)])
    return mulCycVector


def loadPickle(fname, st, et, clock):
    with open(fname, "rb") as input_file:
        sigs = cPickle.load(input_file)

    print ('Parsing signals from', fname)
    print ('Number of read-in signals:', len(sigs))

    vectorList = []
    nameList = []
    for v in sigs:
        if v.width > 1: # include bus only
            vector = convert(v.values, st, et, clock, v.width)
            # skip 1st cycle
            vectorList.append(vector[1:])
            nameList.append([v.name] * v.width)
            #print ('v', v.name, v.width)

    del sigs
    #vectorList = np.array(vectorList) # prev
    vectorList = np.hstack(vectorList)
    # signum * cycles
    sname = fname.split('.pickle')[0] + '_bit'
    nameList = np.hstack(nameList)
    print ('skip 1st cycle, saved to: ' + sname, vectorList.shape, nameList.shape)

    sVectorList = sparse.csr_matrix(vectorList.T)
    sparse.save_npz(sname, sVectorList)

    del vectorList

    print ('nameList', nameList)
    np.save(sname + 'NameW', nameList)


for ins in [['cache_missNew/', 12044.5]    # ... (All testbenches) 
             ]:
             
    fd, et = ins[0], ins[1]
    print ('Start', fd)
    sys.stdout = open(fd + '/2_loadSigBit.log', 'w')

    if not os.path.exists(fd + '/signalList.pickle'):
        print (fd + '/signalList.pickle not exists!')
    else:
        loadPickle(fd + '/signalList.pickle', 0.5, et, clock=1)

    sys.stdout.close()
    sys.stdout = sys.__stdout__
    print ('Finish', fd, '\n')


