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

P = [[x for x in xrange(10)]]
for x in range(1000):
    P.append([x * P[-1][1] * 10 for x in xrange(10)])

s = 0


def it(L, p, n, cnt, last):
    if p == -1:
        global s
        s += 1000000000000000000000000000000 / n
        return
    for d in xrange(last):
        it(L, p-1, n+P[p][d], 1, d)
    if cnt < 2:
        it(L, p-1, n+P[p][last], cnt + 1, last)
    for d in xrange(last+1, 10):
        it(L, p-1, n+P[p][d], 1, d)


def main():
    # total = BigFloat('0')
    L = 1
    while True:
        for d in xrange(1, 10):
            it(L, L-2, P[L-1][d], 1, d)
            print(("n=%030d t = %d") % (L, s))
            sys.stdout.flush()
        L += 1


main()
