#!/usr/bin/env python3

# The Expat License
#
# Copyright (c) 2017, Shlomi Fish
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


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
