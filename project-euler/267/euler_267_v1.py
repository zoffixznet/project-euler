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
import math
from bigfloat import BigFloat, precision

if sys.version_info > (3,):
    long = int
    xrange = range

with precision(20000):
    N_tosses = 1000
    h_probs = [math.factorial(N_tosses) /
               (math.factorial(x) * math.factorial(N_tosses-x)) *
               (BigFloat('0.5') ** N_tosses) for x in xrange(N_tosses+1)]
    s = 0
    h_sums = [0]
    for x in h_probs:
        s += x
        h_sums.append(s + 0)

    def calc_prob(f, h_sums):
        h = N_tosses + 0
        money = (1 + 2 * f) ** h
        while money > 1e9:
            h -= 1
            money *= (1 - f) / (1 + 2 * f)
        h += 1
        return h

    for f_base in xrange(101):
        h = calc_prob(f_base * BigFloat('0.01'), h_sums)
        print("f=%d%% h=%d prob = %.16f" %
              (f_base, h, h_sums[N_tosses + 1 - h]))
