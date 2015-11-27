#!/usr/bin/env python3
import math
import sys
import subprocess

if sys.version_info > (3,):
    long = int

MOD = 1000000007

s_n = 0

# a0 a1 a2 a3 | a4
# b0 b1 b2 b3 | b4
# S[b4] = S[a4] * 6 - (S[a4]-S[a3]) = 5*S[a4]+S[a3]
primes_s = open("primes.txt").read()
primes = [int(p) for p in (str(primes_s)).split("\n") if len(p) > 0] + [-1]

sums = [6, 6, 6]
pi = 0
STEP = 100
at = STEP
PS = 1000
pa = PS
for n in range(1,50000000+1):
    # n_sums → new_sums
    n_sums = [5*sums[0]]
    for i in range(1,n+1):
        n_sums.append(sums[i]*5+sums[i-1])
    n_sums.append(n_sums[-1])
    # print ("n = ", n, " ; sums = " , [x//6 for x in sums])
    if primes[0] == n:
        primes.pop(0)
        pi += 1

    C = sums[pi]
    s_n += C
    if n == at:
        at += STEP
        sums = [x%MOD for x in n_sums]
        if n == pa:
            pa += PS
            print ("C(%d) = %d; S = %d" % (n,C,s_n))
    else:
        sums = n_sums

