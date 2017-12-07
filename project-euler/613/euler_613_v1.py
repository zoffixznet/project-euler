#!/usr/bin/env python

import sys
from math import acos, atan2, sqrt
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range

FROM_RAD = 1/(2*acos(-1))


def calc(H, W):
    H2 = H*H
    ret = 0.0
    count = 0
    num_steps = 2
    WSTEP = W / num_steps
    WS = WSTEP * 2
    count += 1
    xx = 0
    ret += (atan2(xx, H) * sqrt(H2+xx*xx))
    count += 1
    xx = W
    ret += (atan2(xx, H) * sqrt(H2+xx*xx))
    while True:
        # for y in xrange(1, num_steps+1):
        xx = WSTEP
        while xx < W:
            count += 1
            ret += (atan2(xx, H) * sqrt(H2+xx*xx))

            xx += WS
        yield ret * FROM_RAD / count / H
        num_steps <<= 1
        WSTEP *= 0.5
        WS = WSTEP * 2


log = 1
H = 30.0
W = 40.0
gens = [calc(H, W), calc(W, H)]
while True:
    res = sum([next(x) for x in gens])
    print_("%8d[a] : %.50f" % (log, res))
    print_("%8d[b] : %.50f" % (log, 1 - res))
    log += 1
