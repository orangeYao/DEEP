
import numpy as np
from scipy import sparse
import time
from ml_helper import getModel
from ml_helper import eval
from ml_helper import getData
from ml_helper import dumpSignal
from ml_helper import quantizeArray
from calculate_area import calAreaW
import argparse
import sys
import math

print ('sys.argv:', sys.argv)
parser = argparse.ArgumentParser()
parser.add_argument('-s', '--shift', default=0, type=int)
parser.add_argument('-m', '--mode', default='00', type=str)
parser.add_argument('-b', '--block', default=0, type=int)
parser.add_argument('-f', '--from_all', default=0, type=int)
args = parser.parse_args()

shift_cycle = args.shift
mode = args.mode
block = args.block # core, L1, L2
from_all = args.from_all
bit = True

mem_bit_mask = np.load('memory/mem_bit_mask609997_753677.npy')

print ('=====shift_cycle', shift_cycle, '\n')
block_names = ['core', 'L1_tlb', 'L2', 'dpu', 'ifu', 'other']
#                426644            56347                   263480       222378       71242      90685
block_sigs = ['u_ca53_noram', 'u_ca53_caches_tlb_rams', 'u_ca53_l2', 'u_ca53dpu', 'u_ca53ifu', 'other']
print ('Block', block, block_names[block], block_sigs[block])

folder = '../ICCAD22_stage1/'

tname = ''
valueN = np.load('../ICCAD22_stage3/sigs/signalListNameW.npy')
values = valueN [:, 1].astype(int)
values = np.hstack([values, np.ones(len(mem_bit_mask) - len(values)) ])
print ('values, shape', len(values) )

bitname = np.hstack([valueN[:, 0], np.load('../ICCAD22_stage3/sigs/signalList_bitNameW.npy')])

bitname = bitname[mem_bit_mask]
values = values[mem_bit_mask]
# first filter by mem_bit_mask

if not from_all:
    if block_names[block] == 'other':
        bitmask = []
        for i in bitname:
            bitmask.append(True)
            for bs in block_sigs[1:]:
                if bs in i: 
                    bitmask[-1] = False # in existing blocks
                    break
        bitmask = np.array(bitmask)
        print ('bitname, bitmask', bitname.shape, bitmask.shape)
    elif block_names[block] == 'L1_tlb' or block_names[block] == 'L2':
        bitmask = np.array([block_sigs[block] in i for i in bitname])
        print ('bitmask', bitname[bitmask], bitname[bitmask].shape)
    else:
        bitmask = np.array([block_sigs[block] in i for i in bitname])
else:
    bitmask = np.ones(len(bitname)).astype(bool)

if from_all:
    print ('Include all signals!', 'from_all:', from_all)
else:
    print ('Include only block signals!', 'from_all:', from_all)

print ('bitmask', bitname[bitmask], bitname[bitmask].shape)

###############

names2 = [['neon_vfpRt', 0, 4000], ['simd_intRt', 4000, 5000], ['simd_fpRt', 4000, 5000],
          ['max_power_L2Rt', 6000, 8000], ['max_power_L2Rt', 26000, 30000],
          ['comb_opRt', 3500, 6500], ['pow_opRt', 7000, 9000]]
Xs2, ys2, _ = getData(names2, shift_cycle, folder, bit=bit, block=True)
Xs2 = [np.asarray(i.todense(order='F')).astype(bool) for i in Xs2]
ys2 = [ i[:, block]  for i in ys2]

Xtrain = np.vstack(Xs2)[:, mem_bit_mask]
ytrain = np.hstack(ys2)

names = [['wfiRt', 4000, 4500], ['max_powerRt', 3000, 7500], ['saxpyRt', 4000, 9000],
         ['arm_okRt', 4000, 9000], ['cache_missRt', 4000, 10000], ['dhrystoneRt', 3000, 8000] ]
Xs, ys, _ = getData(names, shift_cycle, folder, bit=bit, block=True)
Xs = [np.asarray(i.todense(order='F')).astype(bool) for i in Xs]
ys = [ i[:, block]  for i in ys]

Xtest = np.vstack(Xs)[:, mem_bit_mask]
ytest = np.hstack(ys)



print ('\n=====Tname, shift_cycle', tname, shift_cycle, '\n')
print ('Xtrain, ytrain', Xtrain.shape, ytrain.shape, 'ytrain_ave', np.mean(ytrain), np.min(ytrain))
print ('Xtest, ytest', Xtest.shape, ytest.shape, 'ytest_ave', np.mean(ytest), np.min(ytest))


if from_all:
    #start_alpha = [128, 32, 16, 2]
    start_alpha = [300, 250, 150, 100, 50, 30] 
    start_alpha = [i*3 for i in start_alpha]
else:
    start_alpha = [300, 250, 150, 100, 50, 30] 


max_iter = 100
for f_n in [
            getModel('mcp', alpha=start_alpha[0], max_iter=max_iter), 
            getModel('mcp', alpha=start_alpha[1], max_iter=max_iter), 
            getModel('mcp', alpha=start_alpha[2], max_iter=max_iter),
            getModel('mcp', alpha=start_alpha[3], max_iter=max_iter),
          #  getModel('mcp', alpha=start_alpha[4], max_iter=max_iter),
          #  getModel('mcp', alpha=start_alpha[5], max_iter=max_iter)
            ]:
    f, n = f_n
    print ('Applying model:', n, mode)
    f.fit(Xtrain, ytrain, values, verbose=True, mode=mode, bitmask=bitmask)

    Xtrain_sel = Xtrain[:, f.final_mask].astype(float)
    Xtest_sel = Xtest[:, f.final_mask].astype(float)

    ptrain = Xtrain_sel @ f.finalMaskW
    ptest = Xtest_sel @ f.finalMaskW

    print ('nonzero coef_, all coef_', (np.abs(f.coef_) > 1e-7).sum(), (np.abs(f.coef_) != 0).sum(), len(f.coef_))
    eval(ytrain, ptrain, 's' + tname + '_train_' + n)
    eval(ytest, ptest, 's' + tname + '_test_' + n)

    print ()
    print ('--retrain--, mean diff', round(np.mean(np.abs(ytest)), 2))

    for ii in [0]:
        #coef = f.fullRetrainWs[ii]
        coef_all = f.fullRetrainWs[ii]
        coef = f.finalMaskRetrainWs[ii]
        print ('nonzero coef_, all coef_', (np.abs(coef) > 1e-7).sum(), 
                                (np.abs(coef) != 0).sum(), len(coef))

        for mbits in [0]:
            W = quantizeArray(coef.copy(), mbits=mbits)

            ptest = Xtest_sel @ W
            eval(ytest, ptest, 's' + tname + '_test_' + n, do_plot=False)

            calAreaW(values[f.final_mask][W != 0], W[W!=0])
            print ('W', W, values[f.final_mask][W != 0].shape, '/', len(W))
            print ()

        if ii == 0:
            if from_all:
                prefix = n + '_' + 'bit_' + mode + '_' + str(block_names[block]) + '_fromAll'
            else:
                prefix = n + '_' + 'bit_' + mode + '_' + str(block_names[block]) + '_'
            dumpSignal(coef_all, values, prefix=prefix, bit=True)
            print ('dumpSignal', prefix)

        print ()
    print ('=====\n')


