import numpy as np
from ml_helper import getModel
from ml_helper import eval
from ml_helper import getData
from ml_helper import dumpSignal
from ml_helper import quantizeArray
import argparse
import sys

############### Setting basic arguments #################

print ('sys.argv:', sys.argv)
parser = argparse.ArgumentParser()
parser.add_argument('-b', '--block', default=0, type=int)
parser.add_argument('-f', '--from_all', default=0, type=int)
args = parser.parse_args()

block = args.block # core, L1, L2
from_all = args.from_all

############### Loading signal/bit names ###############

block_names = ['core', 'L1_tlb', 'L2', 'dpu', 'ifu', 'other']
# Signal number: 426644            56347                   263480       222378       71242      90685
block_sigs = ['u_ca53_noram', 'u_ca53_caches_tlb_rams', 'u_ca53_l2', 'u_ca53dpu', 'u_ca53ifu', 'other']
print ('Block', block, block_names[block], block_sigs[block])

# Use a mask to select non-memory signals/bits only
mem_bit_mask = np.load('memory/mem_bit_mask.npy')
folder = '../'

bitname = np.load('../sigs/signalList_bitName.npy')
bitname = bitname[mem_bit_mask]

if not from_all:
    print ('Include only block signals!', 'from_all:', from_all)
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
    print ('Include all signals!', 'from_all:', from_all)
    bitmask = np.ones(len(bitname)).astype(bool)
print ('bitmask', bitname[bitmask], bitname[bitmask].shape)

############### Loading parsed data (feature, label) #################

names = [['test_bench1', 0, 2000], ['test_bench2', 0, 2000]] # ... 
Xs, ys, _ = getData(names, folder, bit=True, block=True)
Xs = [np.asarray(i.todense(order='F')).astype(bool) for i in Xs]
ys = [ i[:, block]  for i in ys]
Xtest = np.vstack(Xs)[:, mem_bit_mask]
ytest = np.hstack(ys)

names2 = [['training_bench1', 0, 2000], ['training_bench2', 0, 2000]] # ... 
Xs2, ys2, _ = getData(names2, folder, bit=True, block=True)
Xs2 = [np.asarray(i.todense(order='F')).astype(bool) for i in Xs2]
ys2 = [ i[:, block]  for i in ys2]
Xtrain = np.vstack(Xs2)[:, mem_bit_mask]
ytrain = np.hstack(ys2)

########## Signal selection by training a linear model with MCP ###########

start_alpha = [300, 250, 150, 50, 30] 
max_iter = 100

for f_n in [
            getModel('mcp', alpha=start_alpha[0], max_iter=max_iter), 
            getModel('mcp', alpha=start_alpha[1], max_iter=max_iter), 
            getModel('mcp', alpha=start_alpha[2], max_iter=max_iter),
            getModel('mcp', alpha=start_alpha[3], max_iter=max_iter) ]:
    f, n = f_n
    print ('Applying model:', n)
    f.fit(Xtrain, ytrain, values, verbose=True, bitmask=bitmask)

    Xtrain_sel = Xtrain[:, f.final_mask].astype(float)
    Xtest_sel = Xtest[:, f.final_mask].astype(float)

    ptrain = Xtrain_sel @ f.finalMaskW
    ptest = Xtest_sel @ f.finalMaskW

    print ('nonzero coef_, all coef_', (np.abs(f.coef_) > 1e-7).sum(), len(f.coef_))
    eval(ytrain, ptrain, 's_train_' + n)
    eval(ytest, ptest, 's_test_' + n)
    print ()

    ########## Retrain an ML model with selected signals, ###########
    ########## then quantize weights, roughtly estimate area, and save selected signals #############
    print ('--retrain--')

    coef_all = f.fullRetrainWs[0]
    coef = f.finalMaskRetrainWs[0]
    print ('nonzero coef_, all coef_', (np.abs(coef) > 1e-7).sum(), 
                            (np.abs(coef) != 0).sum(), len(coef))

    W = quantizeArray(coef.copy(), mbits=0)
    ptest = Xtest_sel @ W
    eval(ytest, ptest, 's_test_' + n, do_plot=False)
    print ()
    
    prefix = n + '_' + 'bit_' + str(block_names[block]) + '_'
    dumpSignal(coef_all, prefix=prefix, bit=True)
    print ()
    print ('=====\n')


