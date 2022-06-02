import numpy as np
import math

def r(x):
    return round(x)

def ceil_log(x):
    return math.ceil(math.log2(abs(x)))

def w_log(x):
    return math.ceil(math.log2(abs(x) + 1))


def calArea(W, B):
# /opt/share/ips/digital/arm/tsmc/cln28le/sc12mc_base_lvt_c40/r0p0/lef/
    # W is a list of selected signals with bit numbers, W in np array
    # AND2_
    a_and = 0.672
    # DFFQA_X1M_A12TS_C30
    a_ff = 2.688
    # XOR2_X0P5M_A12TS_C30
    a_xor = 1.34
    # ADDF_X1M_A12TL_C40
    a_adder = 2.856
    # OR2_
    a_or4 = 1.34

    a_total = 4045931.5680
    a_allcell = 744562.7280

    # this w is bit width, not weight!
    assert len(W) == (W>0).sum()
    signum = len(W)

    interface = 0
    for bit in W:
        interface += bit * (a_xor + 2 * a_ff)
        interface += (bit//4 + bit // 16) * a_or4
    interface = r(interface)

    and_comp = signum * B * a_and
    add_comp = (signum - 1) * a_adder * B

    comp = and_comp + add_comp
    comp = r(comp)
    s = interface + comp 
    print ('FP gate area percent (%)', interface, '+', comp, '=', s, round(s / a_allcell * 100, 2))



def calAreaW(W, Weights):
# /opt/share/ips/digital/arm/tsmc/cln28le/sc12mc_base_lvt_c40/r0p0/lef/
    # W is a list of selected signals with bit numbers, W in np array
    # AND2_
    a_and = 0.672
    # DFFQA_X1M_A12TS_C30
    a_ff = 2.688
    # XOR2_X0P5M_A12TS_C30
    a_xor = 1.34
    # ADDF_X1M_A12TL_C40
    a_adder = 2.856
    # OR2_
    a_or4 = 1.34

    a_total = 4045931.5680
    a_allcell = 744562.7280

    # total area 4045931 (after placement)
    # total gate area 3225193 (after synthesis)

    # this w is bit width, not weight!
    assert len(W) == (W>0).sum()
    #assert len(W) == len(Weights)
    #Weights = Weights[Weights != 0] # W is int weights

    interface = 0
    FF = 0
    for bit in W:
        interface += bit * (a_xor + 2 * a_ff)
        FF        += bit * 2 * a_ff
        interface += (bit//4 + bit // 16) * a_or4 # suppose to be 0
    interface = r(interface)

    Bs = sum([w_log(i) for i in Weights])
    and_comp = Bs * a_and
    add_comp = Bs * a_adder 

    comp = and_comp + add_comp + a_ff * 13 # FF final output
    FF +=  13 * a_ff
    comp = r(comp)

    print ('signum, bit num:', len(W), W.sum(), ', Wbit:', Bs)
    s = interface + comp #+ average
    #print ('gate area percent (%)', round(s - FF, 2), '+', round(FF, 2), '=', s, round(s / a_allcell * 100, 2))
    print ('gate area percent (%)', round(interface, 2), '+', round(comp, 2), '=', s, round(s / a_allcell * 100, 3))

    return round(s / a_allcell * 100, 3)

if __name__ == "__main__":
    n = 48
    W = [1] * n
    Weights = [1, 3, 7, 31] * 2 + [31, 3, 7] * 13 + [31]
    calAreaW(np.array(W), np.array(Weights) )
    calArea(np.array(W), 5)




