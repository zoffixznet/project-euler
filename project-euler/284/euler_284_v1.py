#!/usr/bin/env python

import sys
from six import print_

sys.setrecursionlimit(10019)
if sys.version_info > (3,):
    long = int
    xrange = range

BASE = 14
powers = [long(1)]
for n in xrange(1, 20000):
    powers.append(powers[-1] * BASE)

MP = [[p * d for d in xrange(0, BASE)] for p in powers]

MAX = 9


def rec(n, sq, is_z, digits_sum):
    # print_('sq =', sq)
    s = [[sq, is_z, digits_sum, 0]]
    ret = 0
    while len(s):
        if len(s) & 0xFF == 0:
            print_('n =', len(s))
        if len(s) > MAX+1:
            s.pop()
            continue
        sq, is_z, digits_sum, d = s[-1]
        if (((sq*sq) % powers[len(s)-1]) != sq):
            s.pop()
            continue
        if sq == 0 and len(s) > 3:
            s.pop()
            continue
        if d == 0:
            if not is_z:
                ret += digits_sum
        elif d == BASE:
            s.pop()
            continue
        s[-1][-1] += 1
        s.append([sq+MP[len(s)-1][d], (d == 0), digits_sum+d, 0])
    return ret

print_(rec(0, long(0), True, 0))
MAX = 10000
print_(rec(0, long(0), True, 0))
