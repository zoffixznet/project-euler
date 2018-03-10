#!/usr/bin/env python

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
from subprocess import check_output
from six import print_
from six.moves import range
# import heapq
from BitVector import BitVector

if sys.version_info > (3,):
    long = int

out = check_output(["primesieve", "2000000000", "2000002000", "-p1"])
primes = [int(x) for x in out.decode('utf-8').split("\n") if len(x)]

ret_sum = 0
MAX = 1000000000000
for p in primes:

    def expmod(b, e):
        if e == 0:
            return 1
        r = 1
        if ((e & 1) == 1):
            r *= b
        rec = expmod(b, e >> 1)
        return ((r * rec * rec) % p)

    r = [MAX]
    bv = BitVector(size=p)
    for nn in range(2, p):
        C = {0: 1}
        b = 0

        def cem(e):
            if e not in C:
                r = 1
                if ((e & 1) == 1):
                    r = b * cem(e ^ 1)
                else:
                    i = cem(e >> 1)
                    r = i * i
                C[e] = r % p
            return C[e]
        if bv[nn]:
            continue
        b = modbase = expmod(nn, 10000)

        def handle(n, mod):
            mult = MAX - n
            min_mult = MAX % n
            sum_mult = ((mult + min_mult) * ((mult - min_mult) // n + 1)) >> 1
            r[0] += mod * sum_mult
        handle(nn, modbase)
        step = 2 if nn > 2 else 1
        n = nn*nn
        li = 1
        mod = modbase
        i = nn
        ns = step*nn
        while n < p:
            if not bv[n]:
                # print_('pn = ', n)
                bv[n] = 1
                mod *= cem(i-li)
                mod %= p
                handle(n, mod)
                li = i
            n += ns
            i += step
        print_(p, modbase, 'n=', nn)
        sys.stdout.flush()
    r[0] %= p
    ret_sum += r[0]
    print_(p, r, ret_sum)
