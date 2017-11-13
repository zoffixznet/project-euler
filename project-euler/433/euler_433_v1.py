#!/usr/bin/env python

import sys
from six import print_
# import functools

if sys.version_info > (3,):
    long = int
    xrange = range

c = [[0], [1]]


def E(x, y):
    if y <= 1:
        return y
    if y <= 30000:
        return c[y][x % y]
    return 1 + E(y, x % y)


for y in xrange(2, 30001):
    c.append([])
    arr = c[y]
    for m in xrange(y):
        arr.append(E(y, m)+1)


# @functools.lru_cache(maxsize=128*1024)
def R(x, y):
    return 1+G(y, x % y)


def G(x, y):
    if y <= 1:
        return y
    return R(x, y)


def S(n):
    ret = 0
    # For x == y
    ret += n
    for y in xrange(1, n+1):
        s = m = n % y
        for x in xrange(1, m+1):
            s += E(y, x)
        ss = s
        for x in xrange(m+1, y):
            s += E(y, x)
        ret += ((ss + (s + y - m) * ((n - y) // y)) << 1) + (n-y)
        if ((y & 0x3FF) == 0):
            print_("y = %d ; ret = %d" % (y, ret))
            sys.stdout.flush()
    print_("n = %d ; ret = %d" % (n, ret))
    return ret

#       if False:
#           d = 0
#           for x in xrange(y+1, n+1):
#               d += E(x, y) + E(y, x)
#           print_("y = %d ; d = %d ; delta = %d" % (y, d, delta))


def main():
    S(10)
    S(100)
    S(5000000)


main()
