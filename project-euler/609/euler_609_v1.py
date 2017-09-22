#!/usr/bin/env python3

import sys

if sys.version_info > (3,):
    long = int
    xrange = range

MOD = 1000000007


def P(n, primes):
    cache = {}
    factors = {}
    i = 2
    pi = 0
    ppi = 0
    cache[1] = {}
    while i < n:
        nexti = primes[pi + 1] if pi+1 < len(primes) else n+1

        u0 = i
        u1 = pi + 1
        while primes[ppi] < u1:
            ppi += 1
        prev_delta = cache[u1]
        delta = {}
        for k, v in prev_delta.iteritems():
            delta[k] = v
        inc = (0 if primes[ppi] == u1 else 1)
        if inc not in delta:
            delta[inc] = 0
        delta[inc] += 1
        for k, v in delta.iteritems():
            if k not in factors:
                factors[k] = 0
            factors[k] += v

        if u0 <= len(primes):
            cache[u0] = delta

        u0 = i+1
        delta2 = {}
        for k, v in delta.iteritems():
            delta2[k+1] = v
        count = nexti - u0
        if count > 0:
            for k, v in delta2.iteritems():
                if k not in factors:
                    factors[k] = 0
                factors[k] += count * v
            top = min(nexti - 1, len(primes))
            while u0 <= top:
                cache[u0] = delta2
                u0 += 1
        i = nexti
        pi += 1
    ret = long(1)
    for k, v in factors.iteritems():
        if v > 0:
            ret *= v
    return ret

if __name__ == "__main__":
    s_n = 0

    # a0 a1 a2 a3 | a4
    # b0 b1 b2 b3 | b4
    # S[b4] = S[a4] * 6 - (S[a4]-S[a3]) = 5*S[a4]+S[a3]
    primes_s = open("primes.txt").read()
    primes = [int(p) for p in (str(primes_s)).split("\n") if len(p) > 0]

    def myp(n):
        v = P(n, primes)
        print("P(%d) = %d (MOD: %d )" % (n, v, v % MOD))

    myp(10)
    myp(100)
    myp(100000000)
