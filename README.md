# DEEP

If you are viewing an anonymous repo, please go to our public repo in: https[]()://github.com/orangeYao/DEEP 

This repo provides the flow/script/code developed in our work named DEEP, which develops power model by extracting the most power-related RTL signals/bits. However, the commercial designs, technology libraries, and data used in our experiment are not owned by us and thus cannot be included in this repo. 
  
Zhiyao Xie, et al. [DEEP: Developing Extremely Efficient Runtime On-Chip Power Meters](https://zhiyaoxie.github.io/files/ICCAD22_DEEP.pdf). In International Conference on Computer Aided Design (ICCAD), 2022. 

## Step 0. Run an ordinary design flow (only as example)

### The basic digital design flow for experiment is in flow\_share/  
Design flow scripts are specific to designs, libraries, and EDA tools. For this part, for your reference, we provide some basic synthesis/layout scripts and open-sourced design RTL targeting Nangate 45nm library. 

- Design implementation flow (example scripts in **flow_share/**)   
    Input: design RTL, technology library (NanGate 45nm)  
    Output: design netlist (after synthesis) or design layout (after both synthesis & layout)   
    Possible tools: Synopsys Design Compiler, Cadence Innovus   

- Signal generation   
    Simulate testbench on design RTL (or netlist) and dump out signals in .fsdb/.vcd.  
    Input: design RTL, testbench  
    Output: signal toggles/waveforms in .fsdb/.vcd  
    Possible tools: Synopsys VCS, Verilator   

- Ground-truth power generation (example script in **flow_share/power/**)      
    Run power simulation on generated layout (or netlist), and dump out per-cycle power in .fsdb/.vcd.   
    Input: design netlist/layout, signal toggles/waveforms in .fsdb/.vcd  
    Output: per-cycle power in .fsdb (including per-component power)   
    Possible tools: Synopsys PTPX  


## Step 1. Paring design information

### Paring .fsdb and .power files in parser/
- **1\_parser.py**   
    This FSDB parser requires api from Synopsys Verdi.   
    Optionally you can write your own parser from scratch on a VCD file.   
    Input: signals or power in .fsdb  
    Output: a pickle file, including a list of Signal objects   

    dependent on helper.py  
        Class: Signal   
            -name: signal names    
            -values: toggle information   
 
- **2\_loadSigPow.py**   
    Input: the pickle file with a list of Signal objects  
    e.g. signalList.pickle, power.pickle   

    Output: signal toggles, signal names, power values    
    e.g. signalList.npz, signalListName.npy, power.npy    

- **2\_loadSigBit.py**   
    Input: the pickle file with a list of Signal objects   
    e.g. signalList.pickle  

    Output: bit toggles, bit names  (for bit-level selection)     
    e.g. signalList_bit.npz, signalList_bitNameW.npy   


## Step 2. Build ML model 

### Train power model in model/
- **1\_mcp.py** (invoked by *run_ml_step1_mcp.py*)    
    It implements the minimax concave penalty (MCP) algorithm (together with Lasso algorithm) from scratch.   
    It optimizes a linear function with MCP (or Lasso) as the penalty term.   
    The optimization algorithm is coordinate descent. More explanation about the implementation is in: https://www.coursera.org/lecture/ml-regression/coordinate-descent-for-lasso-unnormalized-features-AsCvQ 
    - def **\_\_init\_\_(self, alpha, gamma, max_iter, retrain)**:
        - The *alpha* and *gamma* are hyper-parameters of the MCP function.  
        - The *max_iter* controls the number of iterations.    
        - The *retrain* is whether a new linear model will be trained after signals are selected with MCP.   
    - def **fit(self, X, y, verbose, bitmask)**:
        - The *X* and *y* are N\*M signal toggling activity and N\*1 power label in numpy array. N is number of cycles and M is number of signals/bits.    
        - The optional *bitmask* is M\*1 boolean array indicating which signals/bits can be selected (when not all M signals/bits in X can be selected).     


- **2\_subset.py** (invoked by *run_ml_step2_select.py*)  
    It implements a bottom-up subset selection method, which keeps adding the best candidate to the selection list, then refreshes the list until no change happens.  
    - def **fit(self, X, y, verbose, use_refresh)**:
        - The *X* and *y* are N\*M signal toggling activity and N\*1 power label in numpy array.   
        - The optional *use_refresh* indicates whether refresh selection list after adding each new candidate. 

## Step 3. OPM implementation (e.g. in Verilog) (only as an example)

### An straightforward template of OPM is given in opm\_template/

It shows a simple implementation of a 5-input OPM (opm5.v) and a 40-input OPM (opm40.v) with the same number of corresponding weights.  

The weights should be replaced by real generated and quantized weights in the power model. The input signals/bits should be connected to corresponding selected RTL signals/bits in the target design.  

