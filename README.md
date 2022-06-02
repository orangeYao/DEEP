# DEEP

### This Repo is Still Under Construction

## Step 1. Paring design information

### Paring .fsdb and .power files
- 1\_parser.py
    Input: signals or power in .fsdb
    Output: a pickle file, including a list of Signal objects

    - helper.py
        Class: Signal
            -name: signal names
            -values: with toggle information

- 2\_loadSigPow.py
    Input: the pickle file with a list of Signal objects
    # signalList.pickle, power.pickle

    Output: signal toggles, signal names, power values
    # signalList.npz, signalListName.npy, power.npy

- 2\_loadSigPow.py

## Step 2. Build ML model



