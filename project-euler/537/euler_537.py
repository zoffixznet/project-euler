#!/usr/bin/env python3

import math
import sys
from subprocess import Popen, PIPE

if sys.version_info > (3,):
    long = int

BASE = 1004535809

# Tuple is (n,k) where n is the sum and k is the count.
cache = {(0,0):1,(1,1):1,(1,0):0,(0,1):1}

pipe = Popen("primes 2", shell=True, stdout=PIPE).stdout

last = 1
counts = []
for i in range(0,20001):
    n = int(pipe.readline())
    counts.append(n-last)
    last = n

pipe.close()

def calc(n,k):
    p = (n,k)
    if n == 0:
        return 1
    if k == 0:
        return (1 if n == 0 else 0)
    if not (p in cache):
        ret = 0
        for i in range(0,n+1):
            ret += counts[i] * calc(n-i,k-1)
        cache[p] = ret % BASE
    return cache[p]

def p_calc(n,k):
    print ("T(%d,%d) = %d" % (n,k,calc(n,k)))

p_calc(10,10)
