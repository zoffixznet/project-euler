#!/usr/bin/env python3

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
from subprocess import Popen, PIPE

if sys.version_info > (3,):
    long = int
    xrange = range

BASE = 1004535809

# Tuple is (n,k) where n is the sum and k is the count.
cache = {(0, 0): 1, (1, 1): 1, (1, 0): 0, (0, 1): 1}

pipe = Popen("primes 2", shell=True, stdout=PIPE).stdout

last = 1
counts = []
for i in xrange(20001):
    n = int(pipe.readline())
    counts.append(n-last)
    last = n

pipe.close()

MAX = 20000


def next_row(k, p):
    if k == 0:
        return counts
    return [
            sum([counts[i] * p[n-i] for i in xrange(n+1)]) % BASE
            for n in xrange(MAX+1)
            ]


def p_calc(n, k, r):
    print("T(%d,%d) = %d" % (n, k, r[n]))


r = []
k = 0
while k < 3:
    r = next_row(k, r)
    k += 1

p_calc(3, 3, r)

while k < 10:
    r = next_row(k, r)
    k += 1

p_calc(10, 10, r)

while k < MAX:
    r = next_row(k, r)
    k += 1
    print("Reached k=%d" % (k))

p_calc(MAX, MAX, r)
