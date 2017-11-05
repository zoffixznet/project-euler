#!/usr/bin/env python

import sys
from math import acos, atan2, sqrt
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range

FROM_RAD = 1/(2*acos(-1))

def calc(num_steps, H, W):
    H2 = H*H
    ret = 0.0
    count = 0
    WSTEP = W / num_steps
    # for y in xrange(1, num_steps+1):
    xx = 0.0
    while xx < W:
        count += 1
        ret += (atan2(xx, H) * sqrt(H2+xx*xx))

        xx += WSTEP
    return ret * FROM_RAD / count / H

log = 1
num_steps = 2
H = 30.0
W = 40.0
while True:
    res = calc(num_steps, H, W) + calc(num_steps, W, H)
    print_("%8d : %.60f" % (log, res))
    log += 1
    num_steps <<= 1
