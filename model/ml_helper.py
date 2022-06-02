
import numpy as np
from scipy import sparse
import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
import scipy.stats as stats
from sklearn import linear_model
from sklearn import cluster
from sklearn import metrics  
from mcp import McpRegression
#from vif import VifRegression
import os
import math
import random
from sklearn.metrics import roc_auc_score

def getModel(name, alpha=None, l1=0.5, max_iter=100):
    if name == 'linear': 
        return [linear_model.LinearRegression(), 'linear']
    elif name == 'lasso':
        return [linear_model.Lasso(alpha=alpha, max_iter=200, positive=True, fit_intercept=False), 'lasso_a' + str(alpha)]
        #return [linear_model.Lasso(alpha=alpha, max_iter=200), 'lasso_a' + str(alpha)]
    elif name == 'kmeans':
        return [cluster.KMeans(n_clusters=alpha), 'kmean_c' + str(alpha)]
    elif name == 'elast':
        return [linear_model.ElasticNet(alpha=alpha, max_iter=2000, l1_ratio=l1), 'elast_a' + str(alpha)]
    elif name == 'mcp':
        return [McpRegression(alpha=alpha, max_iter=max_iter), 'mcp_a' + str(alpha)]
    elif name == 'ridge':
        return [linear_model.Ridge(alpha = alpha, fit_intercept=False, positive=True, max_iter=max_iter), 'ridge_a' + str(alpha)]
    #elif name == 'vif':
    #    return [VifRegression(alpha=alpha, max_iter=max_iter), 'vif_a' + str(alpha)]
    else:
        exit()

def plots(y, fd):
    plt.plot(np.arange(len(y)), y)
    plt.savefig('plots/' + fd + '_y.png', dpi = 400)
    plt.clf()


def eval(y, p, fd, do_plot=False):
    assert len(y) == len(p)
    tau, p_value = stats.kendalltau(y, p)
    tau = round(tau, 2)
    mae = round(np.sum(np.abs(y - p)) / len(y), 2)
    r = str(round(stats.pearsonr(y, p)[0], 3))
    r2 = round(metrics.r2_score(y, p)*100, 1)
    #thres = 50
    #auc = round(roc_auc_score(y > thres, p) * 100, 2)
    print ('Eval', fd, np.mean(y) )
    print ('mae, r, r2', mae, r, r2)
    #print ('mae, r, auc', mae, r, auc)

    if do_plot:
        plt.figure(figsize=(18, 6))
        plt.plot(np.arange(len(p)), p, c='orange', alpha=0.5, label='pred')
        plt.plot(np.arange(len(y)), y, c='blue', alpha=0.5, label='label')
        plt.title(fd + '_mae_' + str(mae) + '_R_' + str(r))
        plt.xlabel('Cycle Index')
        plt.legend()
        plt.savefig('plots/' + fd + '.png', dpi = 400, bbox_inches='tight', pad_inches=0)
        plt.clf()
        plt.close()

        plt.figure(figsize=(10, 8))
        plt.scatter(y, p, c='blue', alpha=0.5)
        plt.plot([y.min(), y.max()], [y.min(), y.max()], c='red', alpha=0.5)
        plt.title(fd + '_mae_' + str(mae) + '_R_' + str(r))
        plt.savefig('plots/' + fd + '_sca.png', dpi = 400, bbox_inches='tight', pad_inches=0)
        plt.clf()
        plt.close()



def plot_bench(sX, y, fd):
    plt.figure(figsize=(12, 6))
    sumX = sX.sum(axis=1) # sum toggled sigs
    plt.plot(np.arange(len(y)), sumX, c='orange', alpha=0.5, label='ToggleSigalNum')
    plt.plot(np.arange(len(y)), y* 20, c='blue', alpha=0.5, label='Power*20 mW')
    plt.legend()
    plt.title('Bench_1GHz_' + fd)
    plt.xlabel('Cycle Index')
    plt.savefig('plots/' + fd + '_bench.png', dpi = 400, bbox_inches='tight', pad_inches=0)
    plt.clf()
    


def getDataY(names, folder='', block=False):
    ys = []

    for fd_st_et in names:
        fd, st, et = fd_st_et
        fd = folder + fd

        if not block:
            y = np.load(fd + '/power.npy')[0] * 1000
        else:
            #sel = [3, 2, 0] # core, tlb + cache, l2
            #sel = sel + [9, 6] # dpu (data processing unit), ifu (instruction fetech unit)
            sel = [7, 6, 1] # Rt: core, tlb + cache, l2
            sel = sel + [10, 13] # Rt: dpu (data processing unit), ifu (instruction fetech unit)
            y = np.load(fd + '/powerList.npy')[sel] * 1000
            yres = y[0] - y[-1] - y[-2]
            y = np.vstack([y, yres])
            y = y.T

        y = y[st:et] 
        ys.append(y)
    return ys


def getData(names, shift_cycle, folder='', en=False, bit=False, block=False):
    Xs, ys, idxs = [], [], []

    print ('shift_cycle', shift_cycle)
    for fd_st_et in names:
        fd, st, et = fd_st_et
        fd = folder + fd
        sX = sparse.load_npz(fd[:-2] + 'New' + '/signalList.npz').T
        
        if not block:
            y = np.load(fd + '/power.npy')[0] * 1000
        else:
            #sel = [3, 2, 0] # core, tlb + cache, l2
            #sel = sel + [9, 6] # dpu (data processing unit), ifu (instruction fetech unit)
            sel = [7, 6, 1] # Rt: core, tlb + cache, l2
            sel = sel + [10, 13] # Rt: dpu (data processing unit), ifu (instruction fetech unit)
            y = np.load(fd + '/powerList.npy')[sel] * 1000
            yres = y[0] - y[-1] - y[-2]
            y = np.vstack([y, yres])
            y = y.T

        if en:
            sXen = sparse.load_npz(fd[:-2] + 'New' + '/signalList_en.npz').T
            sX = sparse.hstack([sX, sXen])

        if bit:
            sXen = sparse.load_npz(fd[:-2] + 'New' + '/signalList_bit.npz').T
            if sXen.shape[0] != sX.shape[0]:
                sXen = sXen.T
                print ('bit-input inconsistent dimension solved')
            sX = sparse.hstack([sX, sXen])

        print ('sX shape:', sX.shape)

        if len(idxs) == 0:
            idxs.append(et - st - shift_cycle)
        else:
            idxs.append(idxs[-1] + et - st - shift_cycle)

        if sparse.issparse(sX):
            sX = sX.tocsr()

        # skip first 3000 cycles, all sigs
        sX = sX[st:et, :] 
        y = y[st:et] 

        if shift_cycle > 0:
            # prev X, later y
            sX = sX[:-shift_cycle, :] # shift by cycles
            y = y[shift_cycle:] # shift by cycles

        if shift_cycle < 0:
            # later X, prev y
            print ('Warning shift_cycle<0', shift_cycle)
            sX = sX[-shift_cycle:, :] # shift by cycles
            y = y[:shift_cycle] # shift by cycles

        #plot_bench(sX, y, fd)
        print (fd, 'X, y shapes:', sX.shape, y.shape)

        Xs.append(sX)
        ys.append(y)
    return Xs, ys, idxs[:-1]


def dumpSignal(W, values, fn='../ICCAD22_stage1/dhrystoneNew/signalListName.npy', 
               prefix="", en=False, bit=False):
    fd = "dumpSigs/"
    if not os.path.exists(fd):
        os.mkdir(fd)
    mask = (W != 0)
    np.save(fd + prefix + str(mask.sum()) + "allW", W)


def dataAugRand(X, y):
    np.random.seed(0)
    N = len(y)
    #n = np.arange(N)
    #np.random.shuffle(n)
    #k = 10
    k = 50
    nk = np.arange(N//k)
    np.random.shuffle(nk)
    n = []
    for i in nk:
        for j in range(k):
            n.append(i*k + j)
    n = np.array(n)
    print ('N', N)
    print ('n', n)
    Xc = np.vstack([X, X[n]])
    yc = np.hstack([y, y[n]])
    return Xc, yc


def dataAug(X, y):
    N = len(y)
    Xn, yn = [], []
    for i in range(N//2):
        Xn.append(X[2*i])
        yn.append(y[2*i])

    Xn = np.array(Xn)
    yn = np.array(yn)
    Xc = np.vstack([X, Xn])
    yc = np.hstack([y, yn])
    return Xc, yc


def quantization(x, mbits=0):
    gap = 0.5 ** mbits
    reminder = x % gap
    if reminder < gap /2:
        rtn = x - reminder 
    else:
        rtn = x - reminder + gap
    return rtn


def quantPower(x):
    x = round(x)
    if x <= 0:
        return 0

    e = math.log2(x)
    low = 2** math.floor(e)
    high = 2** math.ceil(e)
    #print ('low, x, high', low, x, high)
    assert (low <= x and x <= high)

    if low == high:
        return low

    if high - x < x - low:
        rtn = high
    elif high - x > x - low:
        rtn = low
    else:
        rtn = random.choice([low, high])
        #print ('same', low, high, rtn)
    return rtn


def quantizeArray(X, mbits=0, power=False):
    random.seed(0)
    rtn = []
    for x in X:
        if power:
            rtn.append(quantPower(x))
        else:
            rtn.append(quantization(x, mbits))
    return np.array(rtn)


def weightInfo(w):
    nonzero = (w!=0).sum()
    s = set()
    for i in w:
        if i != 0:
            s.add(i)
    print ('Non-zero, different weights', nonzero, len(s))


def calDiff2(Xs, ys):
    # Xs: list of 2D np array
    # ys: list of 1D np array
    Xd, yd = [], []

    if sparse.issparse(Xs[0]):
        for i in range(len(Xs)):
            Xs[i] = np.asarray(Xs[i].todense(order = 'F'))

    for i in range(len(Xs)):
        y = ys[i]
        X = Xs[i]
        Xd.append(X[1:] - X[:-1])
        yd.append(y[1:] - y[:-1])

    Xd = np.vstack(Xd)
    yd = np.hstack(yd)
    return Xd, yd


def calDiff(Xs, ys):
    # Xs: list of 2D np array
    # ys: list of 1D np array
    # calculate in-place
    if sparse.issparse(Xs[0]):
        for i in range(len(Xs)):
            Xs[i] = np.asarray(Xs[i].todense(order = 'F')).astype(np.int8)

    for i in range(len(Xs)):
        X = Xs[i]
        y = ys[i]
        Xs[i] = X[1:] - X[:-1]
        ys[i] = y[1:] - y[:-1]


def calDiff1D(ys):
    # ys: list of 1D np array
    yd = []
    for i in range(len(ys)):
        y = ys[i]
        yd.append(y[1:] - y[:-1])
    yd = np.hstack(yd)
    return yd


def calVif(X, y):
    w = np.linalg.lstsq(X, y, rcond=None)[0]
    vif = 1 / ( 1-metrics.r2_score(y, X @ w) )
    return vif







