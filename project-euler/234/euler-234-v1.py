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


import subprocess
import sys
import math

if sys.version_info > (3,):
    xrange = range

MAX = int(sys.argv[1])

SQ = int(math.sqrt(float(MAX)))

pipe = subprocess.Popen(['primes', '3'], shell=False, stdout=subprocess.PIPE)

bottom = 2
b_sq = bottom * bottom
top = -1
t_sq = -1


def debug_n(n):
    if n > MAX:
        raise "Foobar"
    print("Found[] = ", n)


def debug():
    for g in xrange(bottom+1, top):
        debug_n(g*top)
        debug_n(g*bottom)


# Sum
before_s = -1
s = 0
while before_s < s:
    before_s = s
    top = int(pipe.stdout.readline().rstrip())
    print("top = ", top)
    t_sq = top * top
    if top <= SQ:
        # debug()
        s += (((top + bottom) * (top + bottom) * (top-bottom-1)) >> 1)
    else:
        r = bottom * (bottom+1)
        while r <= MAX:
            # debug_n(r)
            s += r
            r += bottom
    # for g in xrange(bottom+1,top):
    #    s += g*top
    #    s += g*bottom
    r = (bottom-1) * top
    while r > MAX:
        r -= top
    while r > b_sq:
        # debug_n(r)
        s += r
        r -= top
    r = bottom * (top + 1)
    low = min(t_sq-1, MAX)
    while r <= low:
        # debug_n(r)
        s += r
        r += bottom
    bottom = top
    b_sq = t_sq

if False:
    d = bottom + 1
    while d*bottom <= MAX or d*top <= MAX:
        if d*bottom <= MAX:
            debug_n(d*bottom)
            s += d*bottom
        if d*top <= MAX:
            debug_n(d*top)
            s += d*top
        d += 1

print("s = ", s)
