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

E = [0, 6]
while len(E) < 3001136:
    E.append((E[-1] * 5) % MOD)


def pascal_sum(n, p):
    global MOD
    b = n
    l_int = long(1)
    C = E[b] * l_int
    for k in xrange(p):
        b -= 1
        l_int = l_int * (n-1-k) / (k+1)
        C += E[b] * l_int
    return int(C % MOD)


if __name__ == "__main__":
    s_n = 0

    # a0 a1 a2 a3 | a4
    # b0 b1 b2 b3 | b4
    # S[b4] = S[a4] * 6 - (S[a4]-S[a3]) = 5*S[a4]+S[a3]
    primes_s = open("primes.txt").read()
    primes = [int(p) for p in (str(primes_s)).split("\n") if len(p) > 0] + [-1]

    def base6(n):
        if n == 0:
            return ''
        return base6(n/6) + str(n % 6)

    sums = [6, 6, 6]
    pi = 0
    # PS = 1000
    PS = 1
    pa = PS
    # for n in xrange(1,50+1):
    for n in xrange(1, 50000000 + 1):
        if primes[0] == n:
            primes.pop(0)
            pi += 1

        C = pascal_sum(n, pi)
        s_n += C
        s_n %= MOD
        if n == pa:
            pa += PS
            print("C(%d) = %d; S = %d" % (n, C, s_n))
