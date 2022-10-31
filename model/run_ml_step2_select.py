import numpy as np
from ml_helper import eval
from ml_helper import getData
from ml_helper import quantizeArray
import sys
from subset import SubsetSelection
from scipy.optimize import nnls
import argparse

print ('sys.argv:', sys.argv)
parser = argparse.ArgumentParser()
parser.add_argument('-u', '--use_refresh', default=0, type=int)
args = parser.parse_args()
use_refresh = args.use_refresh

############### Loading already selected weights in step 1 ###############
fd = 'dumpSigs/'
mem_bit_mask = np.load('memory/mem_bit_mask.npy')
wbs = []

wb = np.load(fd + 'L1_tlb_weight.npy')
wbs.append(wb)

wb = np.load(fd + 'L2_weight.npy')
wbs.append(wb)

wb = np.load(fd + 'dpu_weight.npy')
wbs.append(wb)

wb = np.load(fd + 'ifu_weight.npy')
wbs.append(wb)

wb = np.load(fd + 'other_weight.npy')
wbs.append(wb)

############### Loading parsed data (feature, label) #################

block_names = ['core', 'L1_tlb', 'L2', 'dpu', 'ifu', 'other']
#                426644            56347                   263480       222378       71242
block_sigs = ['u_ca53_noram', 'u_ca53_caches_tlb_rams', 'u_ca53_l2', 'u_ca53dpu', 'u_ca53ifu', 'other']

names2 = [['training_bench1', 0, 2000], ['training_bench2', 0, 2000]] # ... 
names = [['test_bench1', 0, 2000], ['test_bench2', 0, 2000]] # ... 

folder = '../'
Xs2, ys2, _ = getData(names2, folder, bit=True)
Xtrain = np.vstack(Xs2)
ys2 = np.vstack(ys2)

Xs, ys, _ = getData(names, folder, bit=True)
Xtest = np.vstack(Xs)
ys = np.vstack(ys)

bitname = np.load('../sigs/signalList_bitName.npy')
bitname = bitname[mem_bit_mask]

########## Signal selection ###########
for max_iter, max_acc in [ [40, 0.95], [40, 0.98], [50, 0.98], [70, 0.98], [90, 0.98], [90, 0.99], [100, 0.99]]:
    pnews, ynews, ptrains, ytrains = [], [], [], []

    for i in range(5): 
        # i is the block index, 1 - 'L1_tlb', 5 - 'other (parts of CPU except IFU and DPU)'
        ytrain = ys2[:, i + 1] # y is in shape of [number of cycles, number of blocks]
        ytest = ys[:, i + 1]

        print ('Selection in', block_names[i+1])
        f = SubsetSelection(max_iter = max_iter, max_acc=max_acc)

        mask = wbs[i] != 0
        select = f.fit(Xtrain[:, mask], ytrain, verbose=True, use_refresh=use_refresh)

        Wnew = nnls(Xtrain[:, mask][:, select], ytrain)[0]
        wq = quantizeArray(Wnew)
        pnew = Xtest[:, mask][:, select] @ wq
        pnews.append(pnew)
        ynews.append(ytest)

        ytrains.append(ytrain)
        ptrains.append(Xtrain[:, mask][:, select] @ wq)

        eval(ynews[-1], pnews[-1], block_names[i+1])
        print (bitname[mask][select])
        print ('===================\n')

    for i in range(5):
        print (block_names[i+1])
        eval(ynews[i], pnews[i], block_names[i+1])




