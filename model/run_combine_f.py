
import numpy as np
from scipy import sparse
import time
from ml_helper import getModel
from ml_helper import eval
from ml_helper import getData
from ml_helper import getDataY
from ml_helper import dumpSignal
from ml_helper import quantizeArray
from calculate_area import calAreaW
import sys
import math
from vif import VifRegression
from scipy.optimize import nnls
import os

import argparse


print ('sys.argv:', sys.argv)
parser = argparse.ArgumentParser()
parser.add_argument('-u', '--use', default=0, type=int)
args = parser.parse_args()

use_mchenry = args.use


shift_cycle = 0
bit = True

fd = 'dumpSigs/'

fs = 'savetimeComb4f/'
fxtest = fs + 'Xtest.npy'
fytest = fs + 'ytest.npy'
fxtrain = fs + 'Xtrain.npy'
fytrain = fs + 'ytrain.npy'

mem_bit_mask = np.load('memory/mem_bit_mask609997_753677.npy')

wbs1 = []
wbs2 = []

fn = fd + 'mcp_a2_bit_13_L1_tlb_MM1325allW.npy'
print (fn)
wb = np.load(fn)
wb = wb [mem_bit_mask]
print ('wb', wb.shape, (wb>0).sum() )
wall = wb.copy()
wbs1.append(wb)
wbs2.append(wb)

fn = fd + 'mcp_a150_bit_13_L2_307allW.npy'
print (fn)
wb = np.load(fn)
print ('wb', wb.shape, (wb>0).sum() )
wall += wb
wbs1.append(wb)
wbs2.append(wb)

fn = fd + 'mcp_a150_bit_13_dpu_384allW.npy'
print (fn)
wb = np.load(fn)
print ('wb', wb.shape, (wb>0).sum() )
wall += wb
wbs1.append(wb)

fn = fd + 'mcp_a250_bit_13_dpu_277allW.npy'
print (fn)
wb = np.load(fn)
wall += wb
wbs2.append(wb) 

fn = fd + 'mcp_a250_bit_13_ifu_91allW.npy'
print (fn)
wb = np.load(fn)
print ('wb', wb.shape, (wb>0).sum() )
wall += wb
wbs1.append(wb)
wbs2.append(wb)

fn = fd + 'mcp_a300_bit_13_other_103allW.npy'
print (fn)
wb = np.load(fn)
print ('wb', wb.shape, (wb>0).sum() )
wall += wb
wbs1.append(wb)
wbs2.append(wb)
print ('wall', wall.shape, (wall!=0).sum() )

print ('=====shift_cycle', shift_cycle, '\n')
block_names = ['core', 'L1_tlb', 'L2', 'dpu', 'ifu', 'other']
#                426644            56347                   263480       222378       71242
block_sigs = ['u_ca53_noram', 'u_ca53_caches_tlb_rams', 'u_ca53_l2', 'u_ca53dpu', 'u_ca53ifu', 'other']

names2 = [['neon_vfpRt', 0, 4000], ['simd_intRt', 4000, 5000], ['simd_fpRt', 4000, 5000],
          ['max_power_L2Rt', 6000, 8000], ['max_power_L2Rt', 26000, 30000],
          ['comb_opRt', 3500, 6500], ['pow_opRt', 7000, 9000]]

names = [['wfiRt', 4000, 4500], ['max_powerRt', 3000, 7500], ['saxpyRt', 4000, 9000],
         ['arm_okRt', 4000, 9000], ['cache_missRt', 4000, 10000], ['dhrystoneRt', 3000, 8000] ]

folder = '../ICCAD22_stage1/'

#if False:
if not os.path.exists(fs):
    os.mkdir(fs)

    Xs2, ys2, _ = getData(names2, shift_cycle, folder, bit=bit)

    ys2 = [i for i in ys2]
    Xtrain = np.vstack(Xs2)
    ytrain = np.hstack(ys2)
    np.save(fxtrain, Xtrain)
    np.save(fytrain, ytrain)

    Xs, ys, _ = getData(names, shift_cycle, folder, bit=bit)
    Xs = [np.asarray( (i[:, mem_bit_mask][:, wall != 0]).todense(order='F')).astype(bool) for i in Xs]
    ys = [ i for i in ys]

    Xtest = np.vstack(Xs)
    ytest = np.hstack(ys)
    np.save(fxtest, Xtest)
    np.save(fytest, ytest)
else:
    Xtrain = np.load(fxtrain)
    ytrain = np.load(fytrain)
    Xtest = np.load(fxtest)
    ytest = np.load(fytest)


valueN = np.load('../ICCAD22_stage3/sigs/signalListNameW.npy')
bitname = np.hstack([valueN[:, 0], np.load('../ICCAD22_stage3/sigs/signalList_bitNameW.npy')])
values = valueN [:, 1].astype(int)
values = np.hstack([values, np.ones(len(bitname) - len(values)) ])

values = values[mem_bit_mask]
bitname = bitname[mem_bit_mask]


for wb in wbs1:
    print ('-wb1-')
    calAreaW(values[wb!=0], wb[wb!=0])

ys2 = getDataY(names2, folder, block=True)
ys = getDataY(names, folder, block=True)
ys2 = np.vstack(ys2)
ys = np.vstack(ys)
print ('ys2, ys', ys2.shape, ys.shape)


if True:
    for alpha, gamma in [ [40, 0.95], [40, 0.98], [50, 0.98], [70, 0.98], [90, 0.98], [90, 0.99], [100, 0.99]]:
    #for alpha, gamma in [ [100, 0.98], [100, 0.99], [130, 0.98], [130, 0.99], [150, 0.98], [150, 0.99]]:
        if alpha > 50:
            wbs = wbs2
        else:
            wbs = wbs1

        pnews = []
        ynews = []
        ptrains = []
        ytrains = []
        areas = []
        print ('\n\n')
        for i in range(5): 
            ytrain = ys2[:, i + 1]
            ytest = ys[:, i + 1]

            print ('****selection in', block_names[i+1])
            if block_names[i+1] == 'other':
                f = VifRegression(alpha = 13, gamma=gamma)
            else:
                f = VifRegression(alpha = alpha, gamma=gamma)

            mask = wbs[i][wall != 0]
            assert abs(wbs[i].sum() - mask.sum()) < 1e-4
            mask = mask != 0
            full_mask = wbs[i] != 0

            #print ('Total signal candidates', Xtrain[:, mask].shape[1], len(values[full_mask]) )

            if True: #i < 4:
                    if block_names[i+1] == 'L1_tlb':
                        select = f.fit(Xtrain[:, mask], ytrain, Xtest[:, mask], ytest,
                               values=values[full_mask], verbose=True, use_mchenry=False)
                    else:
                        select = f.fit(Xtrain[:, mask], ytrain, Xtest[:, mask], ytest,
                               values=values[full_mask], verbose=True, use_mchenry=True)
            else:
                assert block_names[i+1] == 'other'
                select = f.fit(Xtrain[:, mask], ytrain + sum(ytrains) - sum(ptrains), 
                               Xtest[:, mask], ytest + sum(ynews) - sum(pnews), 
                               values=values[full_mask], verbose=use_mchenry, use_mchenry=use_mchenry)

            Wnew = nnls(Xtrain[:, mask][:, select], ytrain)[0]

            wq = quantizeArray(Wnew)
            pnew = Xtest[:, mask][:, select] @ wq
            #eval(ytest, pnew, 'Verify_selection')
            pnews.append(pnew)
            ynews.append(ytest)

            ytrains.append(ytrain)
            ptrains.append(Xtrain[:, mask][:, select] @ wq)
            # 'L1_tlb', 'L2', 'dpu', 'ifu', 'other'

            eval(ynews[-1], pnews[-1], block_names[i+1])
            area = calAreaW(values[full_mask][select[wq!=0]], wq)
            print (bitname[full_mask][select])
            print ('===================')
            print ('')
            areas.append(area)

        print ('====Final====')
        print ('alpha, gamma', alpha, gamma)
        print ('areas', areas)
        print ('Total area', sum(areas) )

        for i in range(5):
            print (block_names[i+1])
            eval(ynews[i], pnews[i], block_names[i+1])

        print ()

        eval(ynews[2] + ynews[3] + ynews[4], 
             pnews[2] + pnews[3] + pnews[4], 'cpu_noram')

        eval(ynews[0] + ynews[2] + ynews[3] + ynews[4], 
             pnews[0] + pnews[2] + pnews[3] + pnews[4], 'cpu+L1')

        eval(ynews[0] + ynews[1] + ynews[2] + ynews[3] + ynews[4], 
             pnews[0] + pnews[1] + pnews[2] + pnews[3] + pnews[4], 'cpu+L1+L2')



