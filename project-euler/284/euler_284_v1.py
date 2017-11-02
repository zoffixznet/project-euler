#!/usr/bin/env python

import sys
from six import print_
from gmpy2 import mpz

sys.setrecursionlimit(10019)
if sys.version_info > (3,):
    long = int
    xrange = range

BASE = 14
powers = [mpz(1)]
for n in xrange(1, 10001):
    powers.append(powers[-1] * BASE)

MP = [[p * d for d in xrange(0, BASE)] for p in powers]

MAX = 9
ret = 0


def rec(n, sq, is_z, digits_sum):
    global ret
    # print_('sq =', sq)
    if n > MAX or (((sq*sq) % powers[n]) != sq) or (sq == 0 and n > 1):
        return
    if not is_z:
        ret += digits_sum
    m = MP[n]
    for d in xrange(0, BASE):
        rec(n+1, sq+m[d], (d == 0), digits_sum+d)


def wrap(max_):
    global MAX, ret
    ret = 0
    MAX = max_
    rec(0, mpz(0), True, 0)
    return ret


print_(wrap(9))
print_(wrap(10000))
