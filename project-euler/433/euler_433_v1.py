#!/usr/bin/env python

import sys
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range


# @functools.lru_cache(maxsize=128*1024)
def E(x, y):
    r = 0
    while y != 0:
        r += 1
        x, y = y, x % y
    return r


def S(n):
    ret = 0
    # For x == y
    ret += n
    for y in xrange(1, n+1):
        s = m = n % y
        for x in xrange(1, m):
            s += E(y, x)
        s += E(y, m)
        ss = s
        s += y - m
        for x in xrange(m+1, y):
            s += E(y, x)
        ret += ((ss + s * ((n - y) // y)) << 1) + (n-y)
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
