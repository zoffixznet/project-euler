#!/usr/bin/env python

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
