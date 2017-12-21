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
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range


def count(n, p):
    if p > n:
        return 0
    return n // p + count(n // p, p)


def main():
    ret = 1
    MOD = 1000000009

    def expmod(b, e):
        if e == 0:
            return 1
        r = 1
        if ((e & 1) == 1):
            r *= b
        rec = expmod(b, e >> 1)
        return ((r * rec * rec) % MOD)

    n = 100000000
    half = n >> 1
    with open('primes.txt') as f:
        for line in f:
            p = int(line.rstrip('\n'))
            ret *= 1 + (p*p if p > half else expmod(p, count(n, p) << 1))
            ret %= MOD
            print_('p = %d ; ret = %d' % (p, ret))
    print_('ret = %d' % (ret))


main()
