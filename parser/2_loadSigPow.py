import numpy as np
import _pickle as cPickle
from helper import Signal
from scipy import sparse
import os
import sys

def convert(vals, st, et, clock, isFloat=True):
    cycVector = np.zeros(int((et - st) // clock))
    if vals is None:
        return cycVector

    for val in vals:
        currTime = float(val[0]) 
        idx = int((currTime - st) // clock)
        if idx >= len(cycVector):
            break
        cycVector[idx] = True
        if isFloat:
            cycVector[idx] = float(val[1])
    return cycVector

def loadPickle(fname, st, et, clock, isPower=True, totalPower=True):
    with open(fname, "rb") as input_file:
        e = cPickle.load(input_file)

    if isPower:
        if totalPower:
            sigs = e[-1:] # total dynamic power
        else:
            sigs = e
        print ('Parsing power from', fname)
    else:
        sigs = e
        print ('Parsing signals from', fname)
        print ('Number of read-in signals:', len(sigs))

    vectorList = []
    nameList = []

    for v in sigs:
        vector = convert(v.values, st, et, clock, isFloat=isPower)
        # skip 1st cycle
        vectorList.append(vector[1:])
        nameList.append([v.name, v.width])

    vectorList = np.array(vectorList)
    nameList = np.array(nameList)
    sname = fname.split('.pickle')[0] 
    print ('skip 1st cycle, saved to: ' + sname, vectorList.shape)
    if isPower:
        np.save(sname, vectorList)
        np.save(sname + 'NameW', nameList)
        print ('saved to ', sname, 'with shape', vectorList.shape, nameList.shape)
    else:
        sVectorList = sparse.csr_matrix(vectorList)
        sparse.save_npz(sname, sVectorList)
        np.save(sname + 'NameW', nameList)
        print ('saved to ', sname, 'with shape', vectorList.shape, nameList.shape)

for ins in [['cache_missRt/', 12044.5] # ... (All testbenches) 
            ]: 
    fd, et = ins[0], ins[1]
    print ('Start', fd)
    sys.stdout = open(fd + '/2_loadSigPow.log', 'w')

    if not os.path.exists(fd + '/signalList.pickle'):
        print (fd + '/signalList.pickle not exists!')
    else:
        loadPickle(fd + '/signalList.pickle', 0.5, et, clock=1, isPower=False)

    if not os.path.exists(fd + '/power.pickle'):
        print (fd + '/power.pickle not exists!')
    else:
        loadPickle(fd + '/power.pickle', 0, et - 0.5, clock=1, isPower=True, totalPower=True)

    if not os.path.exists(fd + '/powerList.pickle'):
        print (fd + '/power.pickle not exists!')
    else:
        loadPickle(fd + '/powerList.pickle', 0, et - 0.5, clock=1, isPower=True, totalPower=False)

    sys.stdout.close()
    sys.stdout = sys.__stdout__
    print ('Finish', fd, '\n')



