
import numpy as np

class Signal:
    def __init__(self, idx, name, values, unit):
        self.idx = idx
        self.name = name
        if values[0][1] is None:
            self.width = 0
            print ('idx', idx, 'name', name, 'no value!')
            self.values = None
            return

        for i in range(len(values)):
            values[i][0] = int(values[i][0]) * unit
        self.values = np.array(values)
        self.width = len(values[0][1]) # first signal, value
        assert self.values.shape[1] == 2

    def __repr__(self):
        #return str(self.idx) + '-' + str(self.name) + '-' + str(self.width) + '-' + str(self.values.shape)
        return str(self.idx) + '-' + str(self.name) + '-' + str(self.width) 

    def __str__(self):
        #return str(self.idx) + '-' + str(self.name) + '-' + str(self.width) + '-' + str(self.values.shape)
        return str(self.idx) + '-' + str(self.name) + '-' + str(self.width) 

    def printValues(self):
        print ('Time stamp (ns), values')
        if self.values is not None:
            print (self.values.shape)
            print (self.values[:10])


