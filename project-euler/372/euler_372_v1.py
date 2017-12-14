#!/usr/bin/env python

import math
import sys
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range


def calc_R(M, N):
    N2 = N*N
    ret = 0
    for x in xrange(M+1, N+1):
        r = 0
        xs = x2 = x*x
        xn = xs + x2
        # got = []
        while xs <= N2:
            t = int(math.sqrt(xn))
            if t*t == xn:
                t -= 1
            s = int(math.sqrt(xs))
            if s*s != xs:
                s += 1
            if t > N:
                t = N
            if t >= s:
                r += t-s+1
                # got += range(s, t+1)
            xs = xn + x2
            xn = xs + x2
        if x & 1023 == 1023:
            print_("x = ", x)
            sys.stdout.flush()
        ret += r
    return ret


def main():
    print_(calc_R(0, 100))
    assert calc_R(0, 100) == 3019
    assert calc_R(100, 10000) == 29750422
    print_(calc_R(2000000, 1000000000))


main()


#        if True:
#            good = 0
#            want = []
#            for y in xrange(M+1, N+1):
#                if (((y*y // (x*x)) & 1) == 1):
#                    want.append(y)
#                    good += 1
#            if good != r:
#                print_(x, good, r)
#            # assert good == r
