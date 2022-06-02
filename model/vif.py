
import numpy as np
from scipy import sparse
import time
from sklearn.linear_model import Ridge
import math
import scipy.stats as stats
from calculate_area import calAreaW
from ml_helper import quantizeArray
from sklearn import metrics  
from scipy.optimize import nnls

class VifRegression():
    def __init__(self, alpha=100, max_iter=100, retrain=True, gamma=0.97):
        self.alpha = alpha # scaled by 2
        self.max_iter = max_iter

        self.coef_ = None
        self.W, self.fullW = None, None
        self.retrain = retrain
        self.positive = True
        self.gamma = gamma

    def fit(self, X, y, Xt, yt, values=None, verbose=False, use_mchenry=True):

        self.use_mchenry = use_mchenry
        self.values = values
        # N = ncycles, D = nsigs
        N, D = X.shape 
        assert not sparse.issparse(X)
        norm_full = X.sum(axis=0) 

        self.nz_mask = norm_full > 0
        if self.nz_mask.sum() != len(self.nz_mask):
            print ('Error! Sum, len:', self.nz_mask.sum(), len(self.nz_mask))
        assert self.nz_mask.sum() == len(self.nz_mask)

        print ('alpha, positive', self.alpha, self.positive)
        print ('ncycles, nsigs candidates', N, D)

        # initialize weights W
        self.W = np.ones(D)
        self.W *= np.sum(y) / np.sum(norm_full)
        self.verbose = verbose

        # faster selection of column
        X = X.astype(float) # without this bool -> float, iteration is 2X slower
        import warnings
        with warnings.catch_warnings():
            warnings.simplefilter('ignore')
            return self.fit_on_r(X, y, Xt, yt)

    def remove(self, X, y, select):
        vs = []
        for i in select:
            selni = [j for j in select if j != i]
            selX = X[:, selni]
            v = round(self.calVif(selX, X[:, i]), 2)
            vs.append(v)
        return vs

    def mchenry(self, X, y, selectP):
        select = selectP.copy()
        for idx, i in enumerate(select): # remove i
            selni = [j for j in select if j != i]
            res = np.array([])
            for j in range(X.shape[1]):
                selX = X[:, selni + [j]]
                #w = nnls(selX, y)[0]
                w = np.linalg.lstsq(selX, y, rcond=None)[0] # faster, same result
                p = selX @ w
                r = self.cr2(y, p)
                #r = self.cr(y, p)
                res = np.append(res, r)
            select[idx] = res.argmax()
        return select

    def step_r(self, X, y, select):
        res = np.array([]) 
        for i in range(X.shape[1]):
            seli = np.append(select, i)
            selX = X[:, seli]
            #w = nnls(selX, y)[0]
            w = np.linalg.lstsq(selX, y, rcond=None)[0] # faster, same result

            p = selX @ w
            r = self.cr2(y, p)
            #r = self.cr(y, p)
            res = np.append(res, r)
        select = np.append(select, res.argmax())
        return select


    def fit_on_r(self, X, y, Xt, yt):
        select = np.array([]).astype(int)
        for j in range(self.alpha):
            ts = time.time()

            select = self.step_r(X, y, select)
            #vs = self.remove(X, y, select)

            #if j % 2 == 1 and j != self.alpha-1:
            #    continue

            w = nnls(X[:, select], y)[0]

            p = X[:, select] @ w
            pt = Xt[:, select] @ w
            if self.verbose:
                print (j)
                print ('Train mae, r, r2', self.cm(y, p), round(self.cr(y, p), 5), round(self.cr2(y, p), 5) )
                print ('Test mae, r, r2', self.cm(yt, pt), round(self.cr(yt, pt), 3), round(self.cr2(yt, pt), 3) )

            #if self.use_mchenry and j % 2 == 1:
            if self.use_mchenry: # and j % 2 == 1:
                change = True
                while change:
                #if change:
                    s0 = select.copy()
                    select = self.mchenry(X, y, select)
                    change = sum([s0[i] != select[i] for i in range(len(s0))])
                    print (s0, '->', select, 'changes:', change)

                w = nnls(X[:, select], y)[0]
                p = X[:, select] @ w
                pt = Xt[:, select] @ w
                if self.verbose:
                    print (j)
                    print ('MTrain mae, r, r2', self.cm(y, p), round(self.cr(y, p), 5), round(self.cr2(y, p),5) )
                    print ('MTest mae, r, r2', self.cm(yt, pt), round(self.cr(yt, pt), 3), round(self.cr2(yt, pt),3) )


            wq = quantizeArray(w)
            pt = Xt[:, select] @ wq

            if self.verbose:
                calAreaW(self.values[select[wq!=0]], wq[wq!=0])
                print ('Test mae, r, r2', self.cm(yt, pt), round(self.cr(yt, pt), 3), round(self.cr2(yt, pt), 3) )
                print ('nonzW', (wq!=0).sum(), '/', len(wq))
                print ('time', round(time.time() - ts, 3))
                print ()
            if self.cr(yt, pt) > self.gamma:
                break
        return select

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


