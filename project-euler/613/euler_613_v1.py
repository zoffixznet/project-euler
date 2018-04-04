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
from math import acos, atan2, log, sqrt
from six import print_

if sys.version_info > (3,):
    long = int
    xrange = range

FROM_RAD = 1/(2*acos(-1))


def calc_brute(H, W, divs):
    ret = 0.0
    count = 0
    num_steps = divs
    WSTEP = W / num_steps
    xx = 0
    yy = 0
    HS = H / num_steps
    for max_ in xrange(num_steps+1):
        # for y in xrange(1, num_steps+1):
        xx = 0
        for i in xrange(max_+1):
            ret += (- atan2(W-xx, H-yy) + atan2(xx, yy))
            # ret += atan2(xx, yy)
            xx += WSTEP
        count += max_+1
        yy += HS
    return ret * FROM_RAD / count + 0.25*2


def calc_brute2(H, W, divs):
    ret = 0.0
    count = 0
    num_steps = divs
    WSTEP = W / num_steps
    xx = 0
    yy = 0
    HS = H / num_steps
    for max_ in xrange(num_steps+1):
        # for y in xrange(1, num_steps+1):
        xx = 0
        for i in xrange(max_+1):
            ret += (atan2(xx, yy))
            # ret += atan2(xx, yy)
            xx += WSTEP
        count += max_+1
        yy += HS
    return ret * FROM_RAD / count


def calc_brute2_wrapper(H, W, divs):
    return calc_brute2(H, W, divs) + calc_brute2(W, H, divs) + 0.25


def calc2(H, W):
    H2 = H*H
    ret = 0.0
    count = 0
    num_steps = 2
    WSTEP = W / num_steps
    WS = WSTEP * 2
    count += 1
    xx = 0
    # ret += (atan2(H, xx) * sqrt(H2+xx*xx))
    ret += (atan2(xx, H) * sqrt(H2+xx*xx))
    count += 1
    xx = W
    # ret += (atan2(H, xx) * sqrt(H2+xx*xx))
    ret += (atan2(xx, H) * sqrt(H2+xx*xx))
    while True:
        # for y in xrange(1, num_steps+1):
        xx = WSTEP
        while xx < W:
            count += 1
            ret += (atan2(H-xx, xx) * sqrt(H2+xx*xx))
            # ret += (atan2(xx, H) * sqrt(H2+xx*xx))

            xx += WS
        yield ret * FROM_RAD / count / H
        num_steps <<= 1
        WSTEP *= 0.5
        WS = WSTEP * 2


def calc(H, W):
    H2 = H*H

    ret = 0.0
    count = 0
    num_steps = 2
    WSTEP = W / num_steps
    WS = WSTEP * 2
    count += 1
    # See https://math.stackexchange.com/questions/390080/
    a = 1
    b1 = 0
    c1 = H2

    def P(x):
        return x*x+c1

    def integral(x):
        return sqrt(a) / 2 * ((x + b1) * sqrt(P(x)) + c1 *
                              log(b1+x+sqrt(P(x))))
    div = (integral(W)-integral(0))/W

    def h(xx):
        return (atan2(xx, H) * sqrt(H2+xx*xx))
        # return (atan2(xx, H) * H / cos(atan2(xx, H)))
        # return (atan2(H, xx) * sqrt(H2+xx*xx))
    xx = 0
    # ret += (atan2(H, xx) * sqrt(H2+xx*xx))
    ret += h(xx)
    count += 1
    xx = W
    # ret += (atan2(H, xx) * sqrt(H2+xx*xx))
    ret += h(xx)
    while True:
        # for y in xrange(1, num_steps+1):
        xx = WSTEP
        while xx < W:
            count += 1
            # ret += (atan2(H, xx) * sqrt(H2+xx*xx))
            ret += h(xx)
            xx += WS
        # yield ret * FROM_RAD / count / H
        yield ret * FROM_RAD / count / div
        num_steps <<= 1
        WSTEP *= 0.5
        WS = WSTEP * 2


log2 = 1
H = 30.0
W = 40.0
gens = [calc(H, W), calc(W, H)]
while True:
    r = list(reversed([next(x) for x in gens]))
    # r[1] = 0.25 - r[1]
    res = sum(r)
    print_(("%8d[0] : " % log2) + str(r))
    print_("%8d[a] : %.50f" % (log2, res))
    print_("%8d[b] : %.50f" % (log2, 1 - res))
    print_("%8d[c] : %.50f" % (log2, res+0.25))
    print_("%8d[g] : %.50f" % (log2, calc_brute(H, W, log2*100)))
    print_("%8d[t] : %.50f" % (log2, calc_brute2_wrapper(H, W, log2*100)))
    log2 += 1
