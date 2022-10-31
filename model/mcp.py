import numpy as np
from scipy import sparse
import time
from sklearn.linear_model import Ridge
import math

class McpRegression():
    def __init__(self, alpha=1, gamma=5, max_iter=100, retrain=True):
        self.alpha = alpha # scaled by 2
        self.max_iter = max_iter
        self.gamma = gamma

        self.mcp_k = self.gamma / (self.gamma - 1)
        self.mcp_b = self.gamma * self.alpha / (self.gamma - 1)
        self.coef_ = None
        self.W, self.fullW = None, None
        self.retrain = retrain
        self.positive = True

    def fit(self, X, y, verbose=False, bitmask=None):
        # X is sparse matrix or 2D np arrray
        # y is 1D np array
        # Coordinate descent
        # https://www.coursera.org/learn/ml-regression/lecture/AsCvQ/\
        #   coordinate-descent-for-lasso-unnormalized-features

        # N = ncycles, D = nsigs
        N, D = X.shape 
        # norm (D), actually sum of squared (binary) element
        assert not sparse.issparse(X)
        norm_full = X.sum(axis=0) 

        if bitmask is None:
            self.nz_mask = norm_full > 0
        else:
            self.nz_mask = ((norm_full > 0) * bitmask).astype(bool)

        D_tog = self.nz_mask.sum()
        print ('alpha, gamma, max_iter, positive', self.alpha, self.gamma, self.max_iter, self.positive)
        print ('ncycles, nsigs, tog_sigs', N, D, D_tog)

        norm = norm_full[self.nz_mask]

        # initialize weights W
        self.W = np.ones(D_tog)
        self.W *= np.sum(y) / np.sum(norm)
        #self.W = np.zeros(D_tog)

        # faster selection of column
        X_full = X[0:5] # backup part of the full input
        X = X[:, self.nz_mask]
        X = X.astype(float) # without this bool -> float, iteration is 2X slower
        print ('New X shape', X.shape, X.dtype)

        # N cycles
        preds = self.partial_predict(X)

        for i in range(self.max_iter):
            st = time.time()
            if i > 0 and verbose:
                print ('Iteration', i, metric(preds, y))
                print ('Signals', (np.abs(self.W) > 0).sum(), (np.abs(self.W) > 1e-5).sum())

            if i > 0 and i % 2 == 0:
                update_preds = self.partial_predict(X)
                assert np.sum(np.abs(preds - update_preds)) < 1e-4
                preds = update_preds 
                accu_steps = int(np.sum(np.abs(self.W - oldW)))
                print ('Accumulated updates', accu_steps, int(np.abs(self.W).sum()))
                #if accu_steps < 10:
                if accu_steps < 1:
                    break
                    print ()
            oldW = self.W.copy()

            for j in range(D_tog):
                Xj = X[:, j]
                preds -= self.W[j] * Xj
                rho = Xj @ (y - preds)
                self.W[j] = self.mcp(rho) / norm[j]
                preds += self.W[j] * Xj

        self.fullW = self.updateFullWeight(self.W)
        self.final_mask = np.abs(self.fullW) > 1e-6
        self.finalMaskW = self.fullW [np.abs(self.fullW) > 1e-6]

        self.coef_ = self.fullW
        assert self.same(self.predict(X_full[0:3]), self.partial_predict(X[0:3]))

        if self.retrain:
            st = time.time()
            self.retrainFit(X, y) # get self.retrainWs
            print ('time', round(time.time() - st))
            self.fullRetrainWs = [self.updateFullWeight2stage(i) for i in self.retrainWs]
            self.finalMaskRetrainWs = [w[self.final_mask] for w in self.fullRetrainWs]

        if self.positive:
            assert self.fullW.min() >= 0

        if verbose:
            print ('Finish', metric(preds, y))
            print ('End training, evaluate:')
            self.predict_eval(X, y)
            #print ('Finish test1', metric(X_full @ self.fullW, y))
            #print ('Finish test2', metric(X_full[:, self.final_mask] @ self.finalMaskW, y) )
            print ()

    def same(self, a, b):
        return (np.abs(a - b)).sum() < 1e-4

    def updateFullWeight(self, W):
        fullW = np.zeros(len(self.nz_mask))
        fullW[self.nz_mask] = W
        assert abs(np.abs(fullW).sum() - np.abs(W).sum()) < 1e-4
        return fullW

    def updateFullWeight2stage(self, W):
        fullW = np.zeros(len(self.final_mask))
        fullW[self.final_mask] = W
        assert abs(np.abs(fullW).sum() - np.abs(W).sum()) < 1e-4
        return fullW

    def partial_predict(self, X):
        return X.dot(self.W)

    def predict(self, X):
        # X is sparse matrix or 2D np arrray
        pred = X.dot(self.fullW)
        if sparse.issparse(X):
            pred = np.squeeze(np.asarray(pred))
        return pred

    def retrainPredict(self, X):
        # X is sparse matrix or 2D np arrray
        preds = []
        for i in self.fullRetrainWs:
            pred = X.dot(i)
            if sparse.issparse(X):
                pred = np.squeeze(np.asarray(pred))
            preds.append(pred)
        return preds

    def predict_eval(self, X, y):
        pred = self.partial_predict(X)
        print (metric(pred, y))
        return pred
        
    def retrainFit(self, X, y): # new solution with only non-zero weights
        nonzero_mask = (self.W > 1e-6)
        self.retrainWs = []
        Xsel = X[:, nonzero_mask]

        for alpha in [1, 50]:
            weight = np.zeros(len(self.W))
            clf = Ridge(alpha = alpha, fit_intercept=False, positive=self.positive)
            clf.fit(Xsel, y)
            pred = clf.predict(Xsel)
            print ('retrain', alpha, metric(pred, y))
            self.retrainWs.append(clf.coef_)

    def mcp(self, wj):
        if abs(wj) >= self.gamma * self.alpha:
            if wj > 0:
                return wj
            else:
                if self.positive:
                    return 0
                else:
                    return wj
        if wj > 0:
            return max(0, wj * self.mcp_k - self.mcp_b)
        else:
            if self.positive:
                return 0
            else:
                return min(0, wj * self.mcp_k + self.mcp_b)

    def lasso(self, wj):
        if wj > 0:
            return max(0, wj - self.alpha)
        else:
            return min(0, wj + self.alpha)


import scipy.stats as stats
def metric(y, p):
    mae = str(round(np.sum(np.abs(y - p)) / len(y), 1))
    r = str(round(stats.pearsonr(y, p)[0], 2))
    return 'MAE = ' + mae + ', R = ' + r


