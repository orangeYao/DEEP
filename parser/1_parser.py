import sys
import os
rel_lib_path = os.environ['VERDI_HOME'] + '/share/NPI/python'
sys.path.append(os.path.abspath(rel_lib_path))
from pynpi import npisys
from pynpi import waveform
import _pickle as cPickle
from helper import Signal
import glob

class FsdbSetup:
    def __init__(self, mint, maxt, unit):
        self.parseUnit(unit)
        self.mint = float(mint)
        self.maxt = float(maxt)

    def parseUnit(self, unit):
        if 'p' in unit:
            self.unit = 0.001 * float(unit.split('p')[0])
        elif 'n' in unit:
            self.unit = 1 * float(unit.split('n')[0])
        else:
            print ('Unit not recognized', unit)
            exit()
    
    def __repr__(self):
        return self.__str__()

    def __str__(self):
        return 'unit (ns): ' + str(self.unit) \
               + ', min (ns): ' + str(self.mint * self.unit) \
               + ', max (ns): ' + str(self.maxt * self.unit) 


def iterSignalBase(tb, sig_names, unit):
    # iterate each signal
    max_time = 1000 ** 4
    tb.iter_start(0, max_time)
    record_id = 0
    values = []
    SignalList = []

    while True:
        idx = 0
        idx,currTime = tb.iter_next()
        if idx == 0:
            break

        if record_id != idx:  # loaded new signal
            if record_id > 0: # 2nd signal loaded, save 1st signal
                SignalList.append(Signal(record_id, sig_names[record_id-1], values, unit))
            record_id = idx
            values = []
            #if idx > 100: # for debug
            #    break

        v = tb.get_value(waveform.VctFormat_e.BinStrVal)
        #print ("idx", idx, "time:", currTime, "value:", v)
        values.append([currTime, v]) # time, value

    #if record_id == 1: # only one signal: power simulation
    #    SignalList.append(Signal(record_id, sig_names[0], values, unit))
    SignalList.append(Signal(record_id, sig_names[record_id-1], values, unit))

    tb.iter_stop()
    return SignalList


def dfsScope(scope_list):
    # load all scopes by DFS
    def dfsHelper(s, scopes):
        for c in s.child_scope_list():
            dfsHelper(c, scopes)
            scopes.append(c)

    scopes = []
    for s in scope_list:
        dfsHelper(s, scopes)
    return scopes


def bfsScope(scope_list, key):
    scopes = []
    for s in scope_list:
        scopes.append(s)
        for c in s.child_scope_list():
            scopes.append(c)
            for cc in c.child_scope_list():
                if key in cc.full_name():
                    scopes.append(cc)
                #for ccc in cc.child_scope_list():
                #    if key in ccc.full_name(): # key = u_ca53_noram
                #        scopes.append(ccc)
    return scopes

def saveSignals(tb, sig_names, unit):
    SignalList = iterSignalBase(tb, sig_names, unit)
    for Signal in SignalList:
        print (Signal)
        Signal.printValues()
    return SignalList


def dumpFile(data, fname='signalList'):
    with open(fname + ".pickle", "wb") as output_file:
        cPickle.dump(data, output_file)
        # e = cPickle.load(input_file)
        print ('Saved to ' + fname + '.pickle!')


def finish(fileHandle):
    waveform.close(fileHandle)
    npisys.end()
    print ('===============')


def openFile(fileName, sv_fd = './'):
    npisys.init(["-SX"])
    fileHandle = waveform.open(fileName)

    if fileHandle is None:
        print ("Error: open file failed")

    mint, maxt = fileHandle.min_time(), fileHandle.max_time()
    print("min, max:", mint, maxt, fileHandle.scale_unit())

    fsdb_set = FsdbSetup(fileHandle.min_time(), 
                         fileHandle.max_time(),
                         fileHandle.scale_unit())

    print (fsdb_set)

    top_sig_list = fileHandle.top_sig_list()
    print('top signal', [i.name() for i in top_sig_list])

    waveform.hier_tree_dump_scope(fileHandle, sv_fd + "hier_scope.log")
    isPow = False

    # 0. Top signal exists for power simulation
    if len(top_sig_list) > 0:
        isPow = True
        print ('Reading power simulation results!')
        tb = waveform.SigBasedHandle()
        for top_sig in top_sig_list:
            tb.add(top_sig)

        SignalList = saveSignals(tb, [top_sig.name() for top_sig in top_sig_list], 
                                 fsdb_set.unit)
        dumpFile (SignalList, sv_fd + 'power')
        del tb
        #finish(fileHandle)

    # 0. Dump out scope and signal names
    waveform.hier_tree_dump_scope(fileHandle, sv_fd + "hier_scope.log")
    waveform.hier_tree_dump_sig(fileHandle, sv_fd + "hier_sig.log")

    # 1. Iterate all scopes
    if isPow:
        scopes = bfsScope(fileHandle.top_scope_list(), 'u_ca53_noram')
    else:
        scopes = dfsScope(fileHandle.top_scope_list())

    scope_names = [s.full_name() for s in scopes]
    print ('scope_names', scope_names)

    # 2. Save all signals in scopes
    tb = waveform.SigBasedHandle()
    sig_names = []
    for s in scopes:
        for sig in s.sig_list():
            if isPow and 'dynamic' not in sig.full_name():
                continue
            tb.add(sig)
            sig_names.append(sig.full_name())

    print ('#scope_names, #sig_names', len(scope_names), len(sig_names))

    # 3. Trace all signal values, save to list of objects
    SignalList = saveSignals(tb, sig_names, fsdb_set.unit)
    print ('SignalList', SignalList, len(SignalList))
    if isPow:
        dumpFile (SignalList, sv_fd + 'powerList')
    else:
        dumpFile (SignalList, sv_fd + 'signalList')

    finish(fileHandle)


fds = ['cache_missRt/'   ]# ... (All testbenches)  
for fd in fds:
    print ('Start', fd)
    sys.stdout = open(fd + '/1_parser.log', 'w')
    data_dir = "./"
    data_dir = data_dir + fd

    for fsdb in ['/*vcd.fsdb', '/*route.fsdb']: # [signals fsdb, power fsdb]
        fileNameSigs = glob.glob(data_dir + fsdb)
        if len(fileNameSigs) < 1:
            print (fsdb + ' not found!! Skip!', fileNameSigs)
            continue
        else:
            for fileNameSig in fileNameSigs:
                print ('fileNameSig:', fileNameSig)
                openFile(fileNameSig, fd)

    sys.stdout.close()
    sys.stdout = sys.__stdout__
    print ('Finish', fd)

