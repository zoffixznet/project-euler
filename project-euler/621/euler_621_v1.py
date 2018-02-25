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
# from subprocess import check_output
from six import print_
import heapq

if sys.version_info > (3,):
    long = int
    xrange = range


class MyIter1:
    def __init__(self, n):
        self.n = n
        self.s = (n*(n+1)) >> 1

    def adv(self):
        self.n += 1
        self.s += self.n


class MyIter2:
    def __init__(self, n, s, m=0):
        self.n = n
        self.s = s
        self.m = m

    def adv(self):
        if self.m == self.n:
            return False
        self.m += 1
        self.s += self.m
        return True

    def n_inc(self):
        self.n += 1
        self.s += self.n

    def clone(self):
        return MyIter2(self.n, self.s, self.m)


class IterSumTwo:
    def i(self):
        it = self.it
        return (it.s, it.n, it.clone())

    def __init__(self):
        self.q = []
        self.n = 0
        self.last = -1
        self.it = MyIter2(0, 0)
        heapq.heappush(self.q, self.i())

    def next(self):
        s, n, i = heapq.heappop(self.q)
        if n == self.n:
            self.n += 1
            self.it.n_inc()
            heapq.heappush(self.q, self.i())
        self.last = s
        m = i.m
        if i.adv():
            heapq.heappush(self.q, (i.s, n, i))
        return s, n, m


it = IterSumTwo()
c = 0
while True:
    c += 1
    if 0 == c & (128 * 1024 - 1):
        print_(it.next())
    else:
        it.next()
