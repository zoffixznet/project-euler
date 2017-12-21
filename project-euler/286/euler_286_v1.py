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

if sys.version_info > (3,):
    long = int
    xrange = range


def calc(q):
    probs = [1.0]
    for x in xrange(1, 51):
        p = 1 - x / q
        new_probs = []
        for i in xrange(x+1):
            # print("%d %d" % (i,x))
            new_probs.append((0 if (i == x) else probs[i] * (1-p)) +
                             (0 if (i == 0) else (p * probs[i-1])))
        probs = new_probs
    return probs[20]


low = float(50)
high = float(100000)

while True:
    m = ((low + high) / 2)
    v_m = calc(m)
    print("%.40f = %.40f" % (m, v_m))
    if v_m > 0.02:
        low = m
    elif v_m < 0.02:
        high = m
    else:
        break
