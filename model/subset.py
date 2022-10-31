import numpy as np
from scipy import sparse
import math
import scipy.stats as stats
from ml_helper import quantizeArray
from sklearn import metrics  
from scipy.optimize import nnls

class SubsetSelection():
    def __init__(self, max_iter=100, max_acc=0.97):
        self.max_iter = max_iter 
        self.coef_ = None
        self.max_acc = max_acc

    def fit(self, X, y, verbose=False, use_refresh=True):
        self.use_refresh = use_refresh
        self.verbose = verbose

        # N = ncycles, D = nsigs
        N, D = X.shape 
        assert not sparse.issparse(X)
        norm_full = X.sum(axis=0) 
        self.nz_mask = norm_full > 0
        assert self.nz_mask.sum() == len(self.nz_mask)

        print ('max_iter', self.max_iter)
        print ('ncycles, nsigs candidates', N, D)
        X = X.astype(float) # without this bool -> float, iteration is 2X slower
        import warnings
        with warnings.catch_warnings():
            warnings.simplefilter('ignore')
            return self.fit_on_r(X, y)

    def refresh(self, X, y, selectP):
        select = selectP.copy()
        for idx, i in enumerate(select): # remove i
            selni = [j for j in select if j != i]
            res = np.array([])
            for j in range(X.shape[1]):
                selX = X[:, selni + [j]]
                w = np.linalg.lstsq(selX, y, rcond=None)[0]
                p = selX @ w
                r = self.cr2(y, p)
                res = np.append(res, r)
            select[idx] = res.argmax()
        return select

    def step_r(self, X, y, select):
        res = np.array([]) 
        for i in range(X.shape[1]):
            seli = np.append(select, i)
            selX = X[:, seli]
            w = np.linalg.lstsq(selX, y, rcond=None)[0] 

            p = selX @ w
            r = self.cr2(y, p)
            res = np.append(res, r)
        select = np.append(select, res.argmax())
        return select

    def fit_on_r(self, X, y):
        select = np.array([]).astype(int)
        for _ in range(self.max_iter):
            select = self.step_r(X, y, select)
            w = nnls(X[:, select], y)[0]

            if self.use_refresh: 
                change = True
                while change:
                    s0 = select.copy()
                    select = self.refresh(X, y, select)
                    change = sum([s0[i] != select[i] for i in range(len(s0))])
                    print (s0, '->', select, 'changes:', change)
                w = nnls(X[:, select], y)[0]

            wq = quantizeArray(w)
            p = X[:, select] @ w

            if self.verbose:
                print ('Train mae, r, r2', self.cm(y, p), round(self.cr(y, p), 3), round(self.cr2(y, p), 3) )
                print ('non-zero weights', (wq!=0).sum(), '/', len(wq))
                print ()
            if self.cr(y, p) > self.max_acc:
                break
        return select

    # accuracy evaluation
    def cr(self, y, p):
        r = stats.pearsonr(y, p)[0]
        if math.isnan(r):
            r = 0
        return r

    def cm(self, y, p):
        return round(np.sum(np.abs(y - p)) / len(y), 2)

    def cr2(self, y, p):
        return metrics.r2_score(y, p)

    def calVif(self, X, y):
        w = np.linalg.lstsq(X, y, rcond=None)[0]
        vif = 1 / ( 1-metrics.r2_score(y, X @ w) )
        return vif


