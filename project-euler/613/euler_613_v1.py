#!/usr/bin/env python

# The Expat License
#
# Copyright (c) 2017, Shlomi Fish
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


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
