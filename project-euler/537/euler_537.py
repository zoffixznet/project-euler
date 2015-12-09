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

MAX = 20000
# p = prev.
def next_row(k,p):
    if k == 0:
        return counts
    return [
            sum([counts[i] * p[n-i] for i in range(0,n+1)]) % BASE
            for n in range(0, MAX+1)
            ]

def p_calc(n,k,r):
    print ("T(%d,%d) = %d" % (n,k,r[n]))

r = []
k = 0
while k < 3:
    r = next_row(k,r)
    k += 1

p_calc(3,3,r)

while k < 10:
    r = next_row(k,r)
    k += 1

p_calc(10,10,r)

while k < MAX:
    r = next_row(k,r)
    k += 1
    print ("Reached k=%d" % (k))

p_calc(MAX,MAX,r)
