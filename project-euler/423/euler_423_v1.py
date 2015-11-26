#!/usr/bin/env python3
import math
import sys
import subprocess

if sys.version_info > (3,):
    long = int

MOD = 1000000007

s_n = 0

primes_s = subprocess.Popen(["primes", "2", "50000000"], stdout=subprocess.PIPE).communicate()[0]
primes = [int(p) for p in (str(primes_s)).split("\n") if len(p) > 0] + [-1]

current = [6]
pi = 0
for n in range(1,50000000+1):
    print "n = ", n, " ; curr = " , current
    next_ = [(5 * current[0]) % MOD]
    current.append(0)
    for i in range(1,n+1):
        next_.append((current[i]*5+current[i-1]) % MOD)

    if primes[0] == n:
        primes.pop(0)
        pi += 1

    C = sum(current[0:(pi+1)])
    s_n = ((s_n + C) % MOD)
    print ("C(%d) = %d; S = %d" % (n,C,s_n))
    current = next_
