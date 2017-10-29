#!/usr/bin/env python

import sys
from six import print_

sys.setrecursionlimit(10019)
if sys.version_info > (3,):
    long = int
    xrange = range

BASE = 14
powers = [long(1)]
for n in xrange(1, 10001):
    powers.append(powers[-1] * BASE)

MP = [[p * d for d in xrange(0, BASE)] for p in powers]

MAX = 9


def rec(n, sq, is_z, digits_sum):
    # print_('sq =', sq)
    if n & 0xFF == 0:
        print_('n =', n)
    if n > MAX:
        return 0
    if (((sq*sq) % powers[n]) != sq):
        return 0
    if sq == 0 and n > 3:
        return 0
    ret = 0 if is_z else digits_sum
    m = MP[n]
    for d in xrange(0, BASE):
        ret += rec(n+1, sq+m[d], (d == 0), digits_sum+d)
    return ret

print_(rec(0, long(0), True, 0))
MAX = 10000
print_(rec(0, long(0), True, 0))
