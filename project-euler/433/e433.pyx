#!/usr/bin/env python

import sys
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range


# @functools.lru_cache(maxsize=128*1024)
cdef int E(int x, int y):
    cdef int r = 0
    while y != 0:
        r += 1
        x, y = y, x % y
    return r


cdef long long S(int n):
    cdef long long ret = 0
    # For x == y
    ret += n
    cdef int y, yy, m, x
    cdef long long s, ss
    for yy in range(n):
        y = yy+1
        s = m = n % y
        for x in range(m-1):
            s += E(y, x+1)
        s += E(y, m)
        ss = s
        s += y - m
        for x in range(y-m-1):
            s += E(y, x+m+1)
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
