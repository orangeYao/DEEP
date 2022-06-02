
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
        #print (vector.shape, vector)
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
        #csr_matrix.toarray(order='F')
        #sparse.load_npz()

#loadPickle('dhrystone/power.pickle', 0, 10720, clock=1, isPower=True)
#loadPickle('dhrystone/signalList.pickle', 0.5, 10720.5, clock=1, isPower=False)


#for ins in [['dhrystoneNew', 10764.5], ['max_powerNew', 8006.5], ['saxpyNew', 11160.5], 
#            ['arm_okNew', 11108.5],  ['max_power_L2New', 30428.5], ['cache_missNew/', 12044.5], 
#            ['wfi64New/', 9020.5], ['neon_vfpNew/', 12432.5]]:
#for ins in [['debugPower', 10764.5], ['debugPower2', 10764.5]]:

#for ins in [['neon_vfpNew/', 6503.5], ['simd_intNew/', 7189.5], ['simd_fpNew/', 6776.5], 
#            ['comb_opNew/', 7030.5],  ['pow_opNew/', 9309.5] ]:
#for ins in [['dhrystone2Core/', 10788.5]]:
#for ins in [['pow_opRt/', 9311.5], ['comb_opRt/', 7032.5]]:

for ins in [['neon_vfpRt/', 6503.5], ['cache_missRt/', 12044.5], ['saxpyRt/', 11160.5], 
            ['dhrystoneRt/', 10764.5], ['simd_fpRt/', 6776.5],
            ['simd_intRt/', 7189.5], ['wfiRt/', 9020.5], ['max_powerRt/', 8006.5], 
            ['max_power_L2Rt/', 30428.5], ['arm_okRt/', 11108.5] ]:

    fd, et = ins[0], ins[1]
    print ('Start', fd)
    sys.stdout = open(fd + '/2_loadSigPow.log', 'w')

    if True:
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



